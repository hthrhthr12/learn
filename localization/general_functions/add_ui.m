function [ui_element,new_position]=add_ui(fig,position,style,varargin)


% create ui element
% one can make its input to be a last uicontrol
p=inputParser;
p.addParameter("fontsize",0.4);
p.addOptional("tag",'',@ischar);
p.parse(varargin{:});
font_size=p.Results.fontsize;

%%
ui_element = uicontrol(fig,'Style', style,...
    'FontUnits','normalized');
if strlength(p.Results.tag)>0
    ui_element.Tag=p.Results.tag;
end
ui_element.Units='normalized';
ui_element.Position=position;
ui_element.FontSize=font_size;
if strcmp(style,'popupmenu')
    distance=0.75;
else
    distance=1.05;
end
new_position=new_position_element(position,distance);
end