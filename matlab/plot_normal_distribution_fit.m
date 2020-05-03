function plot_normal_distribution_fit(data_to_fit,legend_name,textbox_location)
%plot normal distribution fit to data
%E.g. plot_normal_distribution_fit(blood_pressure,'general',[.2,.5,.3,.3])

data_distribution= fitdist(data_to_fit,'Normal');
% retrieve the relevant data points
unique_data_for_plot=unique(data_to_fit);

pdf_values= pdf(data_distribution,unique_data_for_plot);
plot(unique_data_for_plot,pdf_values,'DisplayName',legend_name);
annotation(gcf,'textbox',textbox_location,'String',...
    [legend_name,': \mu: ',num2str(data_distribution.mu),', \sigma: ',...
    num2str(data_distribution.sigma)],'FitBoxToText','on');
grid on
hold on
end

