function plot_vertical_line(fig,x_location,varargin)
% plot vertical line 

ax=gca;
x_percentages=interp1(ax.XLim,[0,1],x_location,'linear','extrap');
annotation(fig,'line',[x_percentages,x_percentages],[0,1],...
    'LineStyle',':');
end

