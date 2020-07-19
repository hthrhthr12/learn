function ui_element=add_ui(fig,position,style)

% create ui element

    ui_element = uicontrol(fig,'Style', style,...
		'FontUnits','normalized');
    ui_element.Units='normalized';
    ui_element.Position=position;
   
end