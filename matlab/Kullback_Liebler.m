function [KL_100_1000,KL_100_10000,KL_1000_1000]...
    = Kullback_Liebler(distribution_name,varargin)
%calculate KL divergence between two distributions by two methods:
% Histogram algoruthm, ksdensity

% Examples:
% [KL_100_1000,KL_100_10000,KL_1000_1000]=Kullback_Liebler('Normal','mu',75,'sigma',10);
%
%assuming common region for distributions

distributions={'Normal','Rician','Rayleigh','Uniform'};
p = inputParser;
addRequired(p,'distribution_name',@(name)ismember(name,distributions));
parse(p,distribution_name);

distribution = makedist(distribution_name,varargin{:});

samples=arrayfun(@(size){random(distribution,size,1)},logspace(2,4,3));
pdfs_return=cellfun(@(sample)plot_estimated_pdf(distribution,sample ),samples);

KL_100_1000=KL_between_samples(pdfs_return{1:2},samples(1:2));
KL_100_10000=KL_between_samples(pdfs_return{[1,3]},samples([1,3]));
KL_1000_1000=KL_between_samples(pdfs_return{2},pdfs_return{2},samples([2,2]));

end

