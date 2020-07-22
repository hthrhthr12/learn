function [x_true,y_true]=choose_data_in_axis(fig,data_input)
%input: x,y in normalized units in figure
% output: points in axis units

x_input=data_input(:,1);
y_input=data_input(:,2);
axes_pos=fig.CurrentAxes.Position;
relevant=(x_input>axes_pos(1))&(x_input<(axes_pos(1)+axes_pos(3)))&...
    (y_input>axes_pos(2))&(y_input<(axes_pos(2)+axes_pos(4)));

x_input=x_input(relevant);
y_input=y_input(relevant);
if ~isempty(x_input)
    [x_true,y_true]=inter2axes(fig,x_input,y_input); 
else
    x_true=[];
    y_true=[];
end
end