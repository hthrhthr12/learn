% Load the geolocated data array 'map1' 
% and grid it to 1/2-degree cells.
load mapmtx
cellsize = 0.5;
[Z, refvec] = geoloc2grid(lt1, lg1, map1, cellsize);
 
% Create a figure
f = figure;
[cmap,clim] = demcmap(map1);
set(f,'Colormap',cmap,'Color','w')
 
% Define map limits
latlim = [-35 70];
lonlim = [0 100];
 
% Display 'map1' as a geolocated data array in subplot 1
subplot(1,2,1)
ax = axesm('mercator','MapLatLimit',latlim,...
   'MapLonLimit',lonlim,'Grid','on',...
   'MeridianLabel','on','ParallelLabel','on');
set(ax,'Visible','off')
geoshow(lt1, lg1, map1, 'DisplayType', 'texturemap');
 
% Display 'Z' as a regular data grid in subplot 2
subplot(1,2,2)
ax = axesm('mercator','MapLatLimit',latlim,...
   'MapLonLimit',lonlim,'Grid','on',...
   'MeridianLabel','on','ParallelLabel','on');
set(ax,'Visible','off')
geoshow(Z, refvec, 'DisplayType', 'texturemap');