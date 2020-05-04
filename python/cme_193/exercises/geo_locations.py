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
from shapely.geometry import MultiPoint

data = pd.read_csv('geonames-database\geonames.csv', usecols=['latitude', 'longitude', 'country code'])
EARTH_RADIUS_KM = distance.EARTH_RADIUS
WGS84_DEGREE = "EPSG:4326"  # units: degree
WGS84_METER = "EPSG:3395"  # units: m, World Mercator


def plot_map(mean_latitude=31.0461, mean_longitude=34.8516,
             radius_meters=7 * 10 ** 3, print_by_matplotlib=True, is_open_map=False):
    """plot on a map places in a specific radius
    assuming the longitude is not close to zeros lines
    """
    # (latitude, longitude)
    radius_km = radius_meters / 10 ** 3
    ratio_distance_earth = radius_km / EARTH_RADIUS_KM
    lat_bounds = mean_latitude - ratio_distance_earth, mean_latitude + ratio_distance_earth
    # I add absolute value to the equation in:
    # https://www.movable-type.co.uk/scripts/latlong-db.html
    lon_width = abs(np.arcsin(ratio_distance_earth) / np.cos(mean_latitude))
    lon_bounds = mean_longitude - lon_width, mean_longitude + lon_width
    plot_lat_lon_limits(mean_longitude, mean_latitude, lon_bounds, lat_bounds,
                        radius_meters, print_by_matplotlib, is_open_map)


def plot_map_azimuth_aperture(mean_longitude=1.5, mean_latitude=42.5,
                              azimuth=10, aperture=10, radius_meters=7 * 10 ** 3, print_by_matplotlib=True,
                              is_open_map=False):
    """plot on a map places in a specific radius
    assuming the longitude is not close to zeros lines
    """
    # (latitude, longitude)
    radius_km = radius_meters / 10 ** 3
    ratio_distance_earth = radius_km / EARTH_RADIUS_KM
    lat_bounds = mean_latitude - ratio_distance_earth, mean_latitude + ratio_distance_earth

    lon_width = abs(np.arcsin(ratio_distance_earth) / np.cos(mean_latitude))
    lon_bounds = max(mean_longitude - lon_width, azimuth - aperture), \
                 min(mean_longitude + lon_width, azimuth + aperture)

    plot_lat_lon_limits(mean_longitude, mean_latitude, lon_bounds, lat_bounds,
                        radius_meters, print_by_matplotlib, is_open_map)


def plot_lat_lon_limits(mean_longitude=31.0461, mean_latitude=34.8516, lon_bounds=(-180, 180), lat_bounds=(-90, 90),
                        radius_meters=7 * 10 ** 3, print_by_matplotlib=True, is_open_map=False):
    """plot on a map places in a specific radius
    """
    radius_km = radius_meters / 10 ** 3

    # we assume that the region of search can pass one of limits -180,180
    # but not both
    # If the region passed, correct search:
    is_in_latitude_region = data.latitude.between(lat_bounds[0], lat_bounds[1])
    if lon_bounds[1] > 180:
        is_in_longitude_region = (lon_bounds[0] < data.longitude) | (data.longitude < lon_bounds[1] - 360)
    elif lon_bounds[0] < -180:
        is_in_longitude_region = (lon_bounds[0] + 360 < data.longitude) | (data.longitude < lon_bounds[1])
    else:
        is_in_longitude_region = data.longitude.between(lon_bounds[0], lon_bounds[1])

    data_filtered = data[is_in_latitude_region & is_in_longitude_region]

    mean_location = mean_latitude, mean_longitude

    # if there is some data, obeys the latitude, longitude bounds
    if not data_filtered.empty:
        is_in_region = data_filtered.apply(
            lambda location: distance.distance((location.latitude, location.longitude), mean_location) <= radius_km,
            axis=1)
        data_filtered = data_filtered[is_in_region]

    if data_filtered.empty:
        # return closest longitude and latitude:
        closest_lon = max(data.longitude[data.longitude < mean_longitude]), min(
            data.longitude[data.longitude > mean_longitude])
        closest_lat = max(data.latitude[data.latitude < mean_latitude]), min(
            data.latitude[data.latitude > mean_latitude])
        print(f"closest longitude to {mean_longitude}: minimal:{closest_lon[0]},maximal:{closest_lon[1]}\n"
              f"closest latitude to {mean_latitude}: minimal:{closest_lat[0]},maximal:{closest_lat[1]}")
        return

    geo_data = gpd.GeoDataFrame(data_filtered['country code'],
                                crs=WGS84_DEGREE,
                                geometry=gpd.points_from_xy(data_filtered['longitude'], data_filtered['latitude']))
    convex_hull = MultiPoint([point for point in geo_data['geometry']]).convex_hull
    polygon = gpd.GeoDataFrame(index=[0], crs=WGS84_DEGREE, geometry=[convex_hull])
    print(data_filtered["country code"].unique())
    polygon_area = polygon.to_crs(WGS84_METER).area[0]
    print(f"area of polygon in m^2: {polygon_area}")

    if print_by_matplotlib:
        geo_data = geo_data.to_crs(epsg=3857)
        polygon = polygon.to_crs(epsg=3857)
        ax = geo_data.plot(marker='*', color='red', markersize=12)
        # ax.set_xbound(lon_bounds[0], lon_bounds[1])
        # ax.set_ybound(lat_bounds[0], lat_bounds[1])
        polygon.plot(ax=ax, facecolor='none', edgecolor='k')
        plt.title(f"area of polygon: {polygon_area}")
        ctx.add_basemap(ax, zoom=12)

    else:
        # print by folium
        m = folium.Map([mean_latitude, mean_longitude], zoom_start=5)
        folium.GeoJson(polygon).add_to(m)
        folium.GeoJson(geo_data).add_to(m)
        folium.LatLngPopup().add_to(m)
        m.render()
        m.save('map.html')
        if is_open_map:
            os.system('map.html')


plot_map(radius_meters=7 * 10 ** 5, print_by_matplotlib=True)
plot_map(radius_meters=7 * 10 ** 5, print_by_matplotlib=False)
plot_map_azimuth_aperture()
plot_map_azimuth_aperture(azimuth=10, aperture=10, radius_meters=7 * 10 ** 3, print_by_matplotlib=True)

plot_map_azimuth_aperture(azimuth=-10, aperture=1, radius_meters=7 * 10 ** 5, print_by_matplotlib=True)

plot_map_azimuth_aperture(azimuth=10, aperture=10, radius_meters=7 * 10 ** 5, print_by_matplotlib=True)
plot_map(print_by_matplotlib=True)

# israel:
# 31.0461° N, 34.8516°E
# 36 UTM
