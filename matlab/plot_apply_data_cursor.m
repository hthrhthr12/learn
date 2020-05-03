function plot_apply_data_cursor(x,y,legend_text,cursor_text)
% plot and change the cursor-data text

plot(x,y,'DisplayName',legend_text);
hold on
dcm = datacursormode;
dcm.Enable = 'on';
dcm.UpdateFcn = @(x,info)displayCoordinates(x,info,cursor_text);
end

