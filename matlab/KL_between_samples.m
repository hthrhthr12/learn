function KL_divergence=KL_between_samples(sample1_data,sample2_data)
%The function gets two samples each contains [x,p(x)] , where x is a vector
% The function calculate the KL divergence between the samples.
% The distributions are approximated to Gaussian and the KL divergence sum
% is calculated.
%The spline approximation does not work well, because it does not require 
% positive function, also the polynomial approximation.
% The algorithm does not use the normalization property.
% One can apply direct normal approximation:
% y = pdf(fitdist(blood_pressure,'Normal'),x_values);
%The KL divergence can be calculated by integral.

x_sample_1=sample1_data(1,:);
x_sample_2=sample2_data(1,:);
x_est=linspace(min([x_sample_1,x_sample_2]),max([x_sample_1,x_sample_2]),...
    max(length(x_sample_1),length(x_sample_2)));
sample_1_est =feval(fit(sample1_data(1,:).',sample1_data(2,:).',...
    'gauss1','Normalize','on'),x_est);

sample_2_est =feval(fit(sample2_data(1,:).',sample2_data(2,:).',...
    'gauss1','Normalize','on'),x_est);

KL_divergence=sum(sample_1_est.*log(sample_1_est./sample_2_est));
end