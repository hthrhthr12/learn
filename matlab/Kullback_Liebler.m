function KL_divergence = Kullback_Liebler(distribution_name)
%calculate KL divergence between two distributions

distributions={'Normal','Rician','Rayleigh','Uniform'};
p = inputParser;
addRequired(p,'distribution_name',@(name)ismember(name,distributions));
parse(p,distribution_name);

distribution = makedist(distribution_name);
end

