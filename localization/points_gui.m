function points_gui(fig,~)
% insert points by GUI clicking
fig.UserData.text_x='longitude';
fig.UserData.text_y='latitude';
% add points by clicking
click_points(fig);
% ,true,...
%     @(fig,event)draw_path(fig,event,'end_function',@emitter_input),...
%     {'wait two seconds ,','draw a path, right click for ending'});
fig.UserData.y_bounds=[-90,90];
fig.UserData.error_message_y='Latitude limits must be within [-90 90] degrees';
fig.UserData.x_bounds=[-90,90];
fig.UserData.error_message_x='Longitude limits must be within [-90 90] degrees';

% push_button=fig.findobj('Tag','done_add');
% push_button.Visible='off';

end
