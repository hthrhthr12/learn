function ui_element=add_ui(fig,position,style,font_size)

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
end