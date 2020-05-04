
import os

import contextily as ctx
import folium
import geopandas as gpd
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from geopy import distance
from shapely.geometry import MultiPoint, Point
geo_data_meter[0]

series=gpd.GeoSeries([Point(lon,lat) for lon,lat in zip(geo_data_filtered['longitude'],geo_data_filtered['latitude'])],crs=WGS84_DEGREE).to_crs(crs=WGS84_METER_SPHERE)
okay=[point.within(circle_search_meters) for point in series]
geo_data_meter[okay]