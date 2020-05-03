clc
close all
figure
update_Mandelbrot_figure('x_lim',[-2, 2],...
    'y_lim',[ -2,  2])
h=zoom(gcf);
set(h,'ActionPostCallback',@(ohf,s)update_Mandelbrot_figure(),'Enable','on');

fig = gcf;
fig.Position = [200 200 600 600];
