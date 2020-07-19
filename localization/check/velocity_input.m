function velocity_input(fig)
% longitude latitude were ended
% start get velocities
fig.findobj('Tag','input_x').String='velocity x';
fig.findobj('Tag','input_y').String='velocity y';
fig.UserData.text_x='velocity x';
fig.UserData.text_y='velocity y';
num_points=length(fig.UserData.x_all);
fig.UserData.vx=zeros(num_points,1);
fig.UserData.vy=zeros(num_points,1);
fig.UserData.help_text.String=...
    {'Insert velocity,','Default velocity is zero'};
fig.UserData = rmfield(fig.UserData,{'x_bounds','y_bounds'});
fig.UserData.insertion_function=@insert_velocity;
set(fig.findobj('Tag','done_add'),...
    'Callback',@(src,~)code_evaluation(src,0,...
    @(src,~)emitter_input(src),false))
end

function insert_velocity(fig,point_location)
list_points=fig.findobj('Tag','list_points');
fig.UserData.vx(list_points.Value)=point_location(1);
fig.UserData.vy(list_points.Value)=point_location(2);
end