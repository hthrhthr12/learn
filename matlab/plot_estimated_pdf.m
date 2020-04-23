function pdf_return=plot_estimated_pdf(distribution,sample )
% estimate the probability density of the sample data 
% and plot it in the same figure, with legend.
figure
size_sample=length(sample);
[p,x] = histcounts(sample,floor(sqrt(size_sample)));
% x contains the edges of the bin, translate it to the middle point in the bin 
bin_length=x(2)-x(1);
x=x(1:end-1)+(bin_length)/2;
p=p/(sum(p)*bin_length);
plot(x,p,'DisplayName','estimated pdf'); %PDF
hold on
plot(x,pdf(distribution,x),'DisplayName','true pdf');
hold off
grid on
legend('Location','best')
title(['estimated pdf vs actual pdf, for sample size: ',num2str(size_sample)])
pdf_return={[x;p]};
end