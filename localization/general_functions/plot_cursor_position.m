function plot_cursor_position(fig,varargin)
p=inputParser;
p.addParameter('tag','emitter_');
p.addParameter('field','num_emitters');
p.parse(varargin{:});
[x,y]=inter2axes(fig,fig.CurrentPoint(1),fig.CurrentPoint(2));

plot(fig.CurrentAxes,x,y,'rx');
end