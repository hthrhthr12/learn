clc
close all
% uifigure cannot handle with units:'normalized', hence we use figure
f=figure('Units','normalized','Position',[0 0.0463 1 0.8667]);
axes(f,'Position',[0.042,0.083,0.8156,0.838],'FontUnits','normalized'...
    ,'FontSize',0.0212) % units are normalized by default
axis(f.CurrentAxes,[35.21,35.22,31.76,31.77]);
xlabel('longitude')
ylabel('latitude')
plot_openstreetmap;
help_text=add_ui(f,[0.0566,0.9399,0.80729,0.03418],'text','help_text');
help_text.FontSize=0.8;
help_text.String='draw platforms paths, right click for finishing';

f.UserData.help_text=help_text;
hold on
points_gui(f,0);

%% new run by using the toolbar

t = uitoolbar(f);

% Read an image
[img,map] = imread(fullfile(matlabroot,...
    'toolbox','matlab','icons','matlabicon.gif'));

% Convert image from indexed to truecolor
icon = ind2rgb(img,map);

% Create a uipushtool in the toolbar
p = uipushtool(t,'TooltipString','Toolbar push button',...
    'ClickedCallback',...
    'main');

% Set the button icon
p.CData = icon;