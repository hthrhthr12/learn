function [x_true,y_true]=plot_cursor_position(fig,varargin)
p=inputParser;
p.addParameter('tag','emitter_1');
p.addParameter('marker','rx');
p.parse(varargin{:});
[x_true,y_true]=choose_data_in_axis(fig,fig.CurrentPoint);
% if the currentPoint is outside the axis x_true is empty

if isempty(x_true)
    return;
end
plot(fig.CurrentAxes,x_true,y_true,p.Results.marker...
    ,'Tag',p.Results.tag);
set(fig,'WindowButtonDownFcn',@(~,~)[]);
end