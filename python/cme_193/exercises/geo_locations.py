"""geo systems
Database: in geodetic polar coordinates
One can define distance as the geodesic distance or the great circle distance.
We prefer the geodesic distance, since it is the real minimal distance
between two points.
The default ellipsoidal model: WGS-84, most globally accurate
"""

import geopandas as gpd
import pandas as pd
from geopy import distance
import timeit
data = pd.read_csv('geonames-database\geonames.csv', usecols=['latitude', 'longitude', 'country code'])

geo_data = gpd.GeoDataFrame(data['country code'],
                            geometry=gpd.points_from_xy(data['longitude'], data['latitude']))


def plot_map(mean_longitude=2, mean_latitude=2, radius_meters=10):
    """plot on a map places in a specific radius"""
    # (latitude, longitude)
    mean_location = mean_longitude, mean_latitude
    radius_km = radius_meters / 10 ** 3
    distances=data.apply(lambda location:distance.distance((location.latitude,location.longitude), mean_location),axis=1)

    distances=data.apply(lambda location:print(location.keys()))

a = distance.distance(zip(data['latitude'], data['longitude']), (mean_latitude, mean_longitude)).km
