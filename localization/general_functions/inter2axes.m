function [x_true,y_true]=inter2axes(fig,x_data,y_data)
axes_pos=fig.CurrentAxes.Position;

x_true=interp1(axes_pos(1)+[0,axes_pos(3)],fig.CurrentAxes.XLim,x_data);
y_true=interp1(axes_pos(2)+[0,axes_pos(4)],fig.CurrentAxes.YLim,y_data);
end