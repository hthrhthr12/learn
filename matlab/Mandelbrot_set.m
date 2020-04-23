clc
close all
figure
update_Mandelbrot_figure('x_lim',[-0.748766713922161, -0.748766707771757],...
    'y_lim',[ 0.123640844894862,  0.123640851045266])
h=zoom(gcf);
set(h,'ActionPostCallback',@(ohf,s)update_Mandelbrot_figure(),'Enable','on');

fig = gcf;
fig.Position = [200 200 600 600];
