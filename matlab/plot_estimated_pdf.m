function pdf_return=plot_estimated_pdf(distribution,sample )
% estimate the probability density of the sample data
% and plot it in the same figure, with legend.
% vs ksdensity

fig=figure;
xlim([min(sample),max(sample)])
size_sample=length(sample);
[bin_heights,x] = histcounts(sample,floor(sqrt(size_sample)));
% x contains the edges of the bin, translate it to the middle point in the bin
bin_length=x(2)-x(1);
x=x(1:end-1)+(bin_length)/2;
bin_heights=bin_heights/(sum(bin_heights)*bin_length);

%each data point receives the value of the mean of its neighbors, for
%smoothing purpose
bin_heights=movmean(bin_heights,floor(sqrt(length(bin_heights))));

plot(x,bin_heights,'DisplayName','estimated pdf: histogram'); %PDF
hold on
plot(x,pdf(distribution,x),'DisplayName','true pdf');
plot(x,ksdensity(sample,x),'DisplayName','estimated pdf: ksdensity'); %PDF
arrayfun(@(x)plot_vertical_line(fig,x),sample(1:min(100,length(sample))))
annotation('textbox',[.2 .5 .4 .4],'String',...
    'The dashed lines represent part of the true samples','FitBoxToText','on');
hold off
grid on
title(['estimated pdfs vs actual pdf, for sample size: ',num2str(size_sample)])
legend('Location','southeast')
pdf_return={[x;bin_heights]};
end