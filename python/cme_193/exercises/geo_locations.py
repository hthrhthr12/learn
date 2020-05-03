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

import folium
import geopandas as gpd
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from geopy import distance
from shapely.geometry import MultiPoint

data = pd.read_csv('geonames-database\geonames.csv', usecols=['latitude', 'longitude', 'country code'])
EARTH_RADIUS_KM = distance.EARTH_RADIUS
WGS84 = "EPSG:4326"


def plot_map(mean_latitude=-10.32683, mean_longitude=15.01281
             , radius_meters=7 * 10 ** 3, print_by_matplotib=True):
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
                        radius_meters, print_by_matplotib)


def plot_map_azimuth_aperture(mean_longitude=1.5, mean_latitude=42.5,
                              azimuth=10, aperture=10, radius_meters=7 * 10 ** 3, print_by_matplotib=True):
    """plot on a map places in a specific radius
    assuming the longitude is not close to zeros lines
    """
    # (latitude, longitude)
    radius_km = radius_meters / 10 ** 3
    ratio_distance_earth = radius_km / EARTH_RADIUS_KM
    lat_bounds = max(mean_latitude - ratio_distance_earth, azimuth - aperture) \
        , min(mean_latitude + ratio_distance_earth, azimuth + aperture)
    lon_width = np.arcsin(ratio_distance_earth) / np.cos(mean_latitude)
    lon_bounds = mean_longitude - lon_width, mean_longitude + lon_width
    plot_lat_lon_limits(mean_longitude, mean_latitude, lon_bounds, lat_bounds,
                        radius_meters, print_by_matplotib)


def plot_lat_lon_limits(mean_longitude=1.5, mean_latitude=42.5, lon_bounds=(50, 60), lat_bounds=(50, 60),
                        radius_meters=7 * 10 ** 3, print_by_matplotib=True):
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
        distance_lon = np.abs(data.longitude - mean_longitude)
        distance_lat = np.abs(data.latitude - mean_latitude)
        closest_lon = data.longitude[[np.argmin(distance_lon), np.argmax(distance_lon)]]
        closest_lat = data.latitude[[np.argmin(distance_lat), np.argmax(distance_lat)]]
        print(f"minimal and maximal closest longitude {closest_lon}"
              f"minimal and maximal closest latitude {closest_lat}")
        return

    geo_data = gpd.GeoDataFrame(data_filtered['country code'],
                                crs=WGS84,
                                geometry=gpd.points_from_xy(data_filtered['longitude'], data_filtered['latitude']))
    convex_hull = MultiPoint([point for point in geo_data['geometry']]).convex_hull
    polygon = gpd.GeoDataFrame(index=[0], crs=WGS84, geometry=[convex_hull])
    print(data_filtered["country code"].unique())
    print(f"area of polygon: {convex_hull.area}")

    if print_by_matplotib:
        ax = geo_data.plot(marker='*', color='red', markersize=12)
        ax.set_xbound(lon_bounds[0], lon_bounds[1])
        ax.set_ybound(lat_bounds[0], lat_bounds[1])
        polygon.plot(ax=ax)
        plt.title(f"area of polygon: {convex_hull.area}")
    else:  # print by folium
        m = folium.Map([mean_latitude, mean_longitude], zoom_start=5, tiles='cartodbpositron')
        folium.GeoJson(polygon).add_to(m)
        folium.GeoJson(geo_data).add_to(m)
        folium.LatLngPopup().add_to(m)
        m.save('map.html')


plot_map(print_by_matplotib=False)
