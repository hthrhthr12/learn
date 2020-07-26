function [x_true,y_true]=inter2figure(fig,x_data,y_data,varargin)
% input: x,y in axes
% output: x,y in figure units
%%
p=inputParser;
p.addOptional('from_utm',true)
p.parse(varargin{:})

%%
axes_pos=fig.CurrentAxes.Position;
if p.Results.from_utm
    assert(size(x_data,2)==1,'x is not a column vector')
    assert(size(y_data,2)==1,'y is not a column vector')
    [x_data,y_data]=my_utm2ell([x_data,y_data],'wgs84',36);
end

x_true=interp1(fig.CurrentAxes.XLim,axes_pos(1)+[0,axes_pos(3)],x_data,...
    'linear','extrap');
y_true=interp1(fig.CurrentAxes.YLim,axes_pos(2)+[0,axes_pos(4)],y_data,...
    'linear','extrap');
end