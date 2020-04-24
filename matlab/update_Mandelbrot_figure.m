function update_Mandelbrot_figure(varargin)
%update Mandelbrot figure

%% input
p = inputParser;
addParameter(p,'x_lim',0);
addParameter(p,'y_lim',0);
parse(p,varargin{:});
if p.Results.x_lim==0
    ax=gca;
    xlim=ax.XLim;
    ylim=ax.YLim;
else
    xlim=p.Results.x_lim;
    ylim=p.Results.y_lim;
end

%% Setup
maxIterations = 200;
gridSize = 1000;

%%
x = linspace( xlim(1), xlim(2), gridSize );
y = linspace( ylim(1), ylim(2), gridSize );
[xGrid,yGrid] = meshgrid( x, y );
z0 = xGrid + 1i*yGrid;
count = ones( size(z0) );

% Calculate
z = z0;
for n = 0:maxIterations
    z = z.*z + z0;
    inside = abs( z )<=2;
    count = count + inside;
end
count = log( count );
% Show
imagesc( x, y, count );
colormap( [jet();flipud(jet());0 0 0] );
title('Mandelbrot set');

end

