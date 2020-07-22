function [ui_element,new_position]=add_ui(fig,position,style,font_size)

% create ui element
% one can make its input to be a last uicontrol


ui_element = uicontrol(fig,'Style', style,...
    'FontUnits','normalized');
ui_element.Units='normalized';
ui_element.Position=position;
if nargin==4
    ui_element.FontSize=font_size;
else
    ui_element.FontSize=0.4;
end
if strcmp(style,'popupmenu')
    distance=0.75;
else
    distance=1.05;
end
new_position=new_position_element(position,distance);
end