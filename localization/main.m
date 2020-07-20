clc
close all
f=figure('Units','normalized','Position',[0 0.0463 1 0.8667]);
axes(f,'Position',[0.042,0.083,0.8156,0.838],'FontUnits','normalized'...
    ,'FontSize',0.0212) % units are normalized by default
axis(f.CurrentAxes,[32,35,36,38]);
help_text=add_ui(f,[0.0566,0.9399,0.80729,0.03418],'text');
help_text.FontSize=0.8;
help_text.String='draw platforms paths, right click for finishing';
help_text.Tag='help_text';
f.UserData.help_text=help_text;
hold on
points_gui(f,0);

