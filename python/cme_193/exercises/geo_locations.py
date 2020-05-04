"""geo systems
Database: in geodetic polar coordinates
One can define distance as the geodesic distance or the great circle distance.
We prefer the geodesic distance, since it is the real minimal distance
between two points.
The default ellipsoidal model: WGS-84, most globally accurate
longitude in (-180,180 East]
latitude in [-90,90 North]
israel:
in GPS coordinates
"""

import os

import contextily as ctx
import folium
import geopandas as gpd
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from geopy import distance
from shapely.geometry import MultiPoint, Point

EARTH_RADIUS_KM = distance.EARTH_RADIUS
WGS84_DEGREE = "EPSG:4326"  # units: degree
# EPSG:3395 uses the elliptical version of the Marcator projection
WGS84_METER_ELLIPSE = "EPSG:3395"  # units: m, World Mercator
# EPSG:3857 (Pseudo Mercator) use globe with the same radius
# for the semi major and minor axis
# WGS 84 / Pseudo-Mercator -- Spherical Mercator
WGS84_METER_SPHERE = 3857

data = pd.read_csv('geonames-database\geonames.csv', usecols=['latitude', 'longitude', 'country code'])
data.dropna(axis=0, how='any', inplace=True)


def plot_map(mean_latitude=31.0461, mean_longitude=34.8516,
             radius_meters=7 * 10 ** 3, print_by_matplotlib=True, is_open_map=False, only_filter=False,
             geodesic_distance=False):
    """
    plot on a map places in a specific radius
    assuming the longitude is not close to zeros lines
    """
    # (latitude, longitude)
    radius_km = radius_meters / 10 ** 3
    mean_location = mean_latitude, mean_longitude
    circle_search = gpd.GeoSeries(Point(mean_location[-1::-1]), crs=WGS84_DEGREE)
    circle_search_meters = circle_search.to_crs(crs=WGS84_METER_SPHERE).buffer(radius_meters)
    circle_search = circle_search_meters.to_crs(crs=WGS84_DEGREE)
    # circle_search.bounds.values:
    # min_longitude, min_latitude, max_longitude, max_latitude
    min_max_lon_lat = circle_search.bounds.values[0]
    geo_data_filtered = data[data.latitude.between(min_max_lon_lat[1], min_max_lon_lat[3])]

    if np.sign(min_max_lon_lat[0]) == np.sign(min_max_lon_lat[2]):
        # do not pass zero
        geo_data_filtered = geo_data_filtered[
            geo_data_filtered.longitude.between(min_max_lon_lat[0], min_max_lon_lat[2])]
    # reset index
    geo_data_filtered.reset_index(drop=True, inplace=True)

    if geodesic_distance:
        # geodesic distance
        geo_data_filtered = geo_data_filtered[geo_data_filtered.apply(
            lambda location: distance.distance((location.latitude, location.longitude), mean_location) <= radius_km,
            axis=1)]
        geo_data_meter = gpd.GeoDataFrame(geo_data_filtered['country code'], crs=WGS84_DEGREE,
                                          geometry=gpd.points_from_xy(geo_data_filtered['longitude'],
                                                                      geo_data_filtered['latitude'])).to_crs(
            crs=WGS84_METER_SPHERE)

    else:
        geo_data_meter = gpd.GeoDataFrame(geo_data_filtered['country code'], crs=WGS84_DEGREE,
                                          geometry=gpd.points_from_xy(geo_data_filtered['longitude'],
                                                                      geo_data_filtered['latitude'])).to_crs(
            crs=WGS84_METER_SPHERE)
        geo_data_meter = geo_data_meter[geo_data_meter.geometry.within(circle_search_meters[0])]

    if only_filter:
        return mean_location, circle_search_meters, geo_data_meter
    plot_locations(mean_location, circle_search_meters, geo_data_meter, print_by_matplotlib, is_open_map)


def plot_map_azimuth_aperture(mean_latitude=31.0461, mean_longitude=34.8516,
                              azimuth=10, aperture=20, radius_meters=7 * 10 ** 3, print_by_matplotlib=True,
                              is_open_map=False):
    """plot on a map places in a specific radius
    assuming the longitude is not close to zeros lines
    """
    # (latitude, longitude)
    mean_location, circle_search, geo_data_meter = plot_map(mean_latitude, mean_longitude,
                                                            radius_meters, only_filter=True)
    center = circle_search.centroid
    xc, yc = float(center.x), float(center.y)

    x_val = np.array([point.x for point in geo_data_meter.geometry])
    y_val = np.array([point.y for point in geo_data_meter.geometry])
    distance_azimuth = np.abs(np.arctan2(y_val - yc,x_val - xc) - azimuth * np.pi / 180) * 180 / np.pi
    geo_data_meter = geo_data_meter[distance_azimuth < aperture]
    plot_locations(mean_location, circle_search, geo_data_meter, print_by_matplotlib, is_open_map, azimuth, aperture)


def plot_locations(mean_location, circle_search, geo_data, print_by_matplotlib, is_open_map, azimuth=None,
                   aperture=None, radius=None):
    """plot locations"""
    mean_latitude, mean_longitude = mean_location
    if geo_data.empty:
        # return closest longitude and latitude:
        closest_lon = max(data.longitude[data.longitude < mean_longitude]), min(
            data.longitude[data.longitude > mean_longitude])
        closest_lat = max(data.latitude[data.latitude < mean_latitude]), min(
            data.latitude[data.latitude > mean_latitude])
        print(f"closest longitude to {mean_longitude}: minimal:{closest_lon[0]},maximal:{closest_lon[1]}\n"
              f"closest latitude to {mean_latitude}: minimal:{closest_lat[0]},maximal:{closest_lat[1]}")
        return

    convex_hull = MultiPoint([point for point in geo_data['geometry']]).convex_hull
    polygon = gpd.GeoDataFrame(index=[0], crs=WGS84_METER_SPHERE, geometry=[convex_hull])
    countries = geo_data["country code"].unique()
    print(countries)
    polygon_area = polygon.area[0]
    print(f"area of polygon in m^2: {polygon_area}")

    if print_by_matplotlib:
        geo_data = geo_data.to_crs(crs=WGS84_DEGREE)
        polygon = polygon.to_crs(crs=WGS84_DEGREE)
        circle_search = circle_search.to_crs(crs=WGS84_DEGREE)
        ax = geo_data.plot(marker='*', color='red', markersize=12)
        polygon.plot(ax=ax, facecolor='none', edgecolor='k')
        circle_search.plot(ax=ax, facecolor='none', edgecolor='k')
        plt.title(f"polygon: {polygon_area / 10 ** 6} $(km)^2$\n {countries}")
        if azimuth:
            center = circle_search.centroid
            xc, yc = float(center.x), float(center.y)
            angle = np.pi * (azimuth - aperture) / 180
            radius = circle_search.to_crs(WGS84_DEGREE).bounds.values[0]
            radius = (radius[2] - radius[0]) / 2
            plt.plot([xc, xc + radius * np.cos(angle)], [yc, yc + radius * np.sin(angle)])
            angle = np.pi * (azimuth + aperture) / 180
            plt.plot([xc, xc + radius * np.cos(angle)], [yc, yc + radius * np.sin(angle)])
            plt.xlabel('longitude')
            plt.ylabel('latitude')
        try:
            ctx.add_basemap(ax, crs=WGS84_DEGREE)
        except ConnectionError:
            print("There is no internet connection, so you haven't map:(")
            plt.show()
    else:
        # print by folium
        m = folium.Map([mean_latitude, mean_longitude])
        folium.GeoJson(polygon).add_to(m)
        folium.GeoJson(geo_data).add_to(m)
        folium.GeoJson(circle_search).add_to(m)
        folium.LatLngPopup().add_to(m)
        m.save('map.html')
        if is_open_map:
            os.system('map.html')


plot_map_azimuth_aperture()

plot_map(radius_meters=7 * 10 ** 4, print_by_matplotlib=True)
plot_map_azimuth_aperture(mean_latitude=31.0461, mean_longitude=34.8516,
                          azimuth=10, aperture=30, radius_meters=7 * 10 ** 3, print_by_matplotlib=True)
# israel:
# lat: 31.0461° N, lon: 34.8516°E
# 36 UTM
plot_map_azimuth_aperture(mean_latitude=31.0461, mean_longitude=34.8516,
                          azimuth=10, aperture=10, radius_meters=7 * 10 ** 4, print_by_matplotlib=True)

# country on the board:
plot_map(mean_longitude=35.7860, mean_latitude=33.3058, radius_meters=7 * 10 ** 3)
