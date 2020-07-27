function [R_hat,P_hat_inv,solutions]=linear_est_WLS(fig,calulate_D_F,t...
    ,const,measurement_noise,total_noise)
% The function estimate the emitter's position iteratively, by batch size
% and epochs

num_samples=fig.UserData.num_samples;
num_epochs=fig.UserData.num_epochs;
if fig.UserData.WLS_batch>num_samples
    disp('WLS batch must be smaller than the number of samples')
    return
end
batch_sizes=1:fig.UserData.WLS_batch:num_samples;
if num_samples+1~=batch_sizes(end)
    % append num_samples to the end
    batch_sizes(end+1)=num_samples+1;
end

%% calculate measurements
t=t+...
    measurement_noise*randn(size(t));

%% run for all epochs
solutions=zeros(num_epochs*(length(batch_sizes)-1)+1,2);
solutions(1,:)=fig.UserData.R_0;

count=2;
for epoch=1:num_epochs
    for batch=1:length(batch_sizes)-1
        batch_indices=batch_sizes(batch):(batch_sizes(batch+1)-1);
        if isempty(batch_indices)
            continue
        end
        M=fig.UserData.num_platforms;
        platforms=0:M-1;
        % indices for all platforms
        batch_indices=kron(platforms,ones(size(batch_indices)))*...
            fig.UserData.num_samples+repmat(batch_indices,1,M);

        [D_0,F]=calulate_D_F(fig,batch_indices);
        [solutions(count,:),P_hat_inv]=...
                linear_est_WLS_batch(fig,D_0,t(batch_indices)...
            ,const,F,total_noise);
        fig.UserData.R_0=solutions(count,:);
        count=count+1;
    end
end
% restore R_0:
fig.UserData.R_0=solutions(1,:);
R_hat=solutions(end,:);
end
