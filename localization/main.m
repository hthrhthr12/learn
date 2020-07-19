clc
close all
f=figure('Units','normalized','Position',[0 0.0463 1 0.8667]);
axes(f,'Position',[0.042,0.083,0.8156,0.838],'FontUnits','normalized'...
    ,'FontSize',0.0212) % units are normalized by default
axis(f.CurrentAxes,[32,35,36,38]);
hold on
points_gui(f,0);

