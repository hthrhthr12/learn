function KL_divergence=KL_between_samples(sample1_data,sample2_data,samples)
%The function gets two samples each contains [x,p(x)] , where x is a vector
% The function calculate the KL divergence between the samples.
% The distributions are approximated to Gaussian and the KL divergence sum
% is calculated.
%The spline approximation does not work well, because it does not require 
% positive function, also the polynomial approximation.
% The algorithm does not use the normalization property.
%The KL divergence can be calculated by integral.

x_sample_1=sample1_data(1,:);
x_sample_2=sample2_data(1,:);
low_bound=max([min(x_sample_1),min(x_sample_2)]);
high_bound=min([max(x_sample_1),max(x_sample_2)]);
x_est=linspace(low_bound,high_bound,1000);

sample_1_est=interp1(x_sample_1,sample1_data(2,:),x_est);
sample_2_est=interp1(x_sample_2,sample2_data(2,:),x_est);
dx=x_est(2)-x_est(1);
KL_divergence=sum(dx*sample_1_est.*log(sample_1_est./sample_2_est));

%% KL based on ksdensity:
sample_1_est=ksdensity(samples{1,1},x_est);
sample_2_est=ksdensity(samples{1,2},x_est);

KL_divergence_ksdensity=sum(dx*sample_1_est.*log(sample_1_est./sample_2_est));

KL_divergence={KL_divergence,KL_divergence_ksdensity};
end
