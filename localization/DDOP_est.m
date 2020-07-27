function [R_hat,P_hat_inv,solutions]=DDOP_est(fig)

%The measurements are calculated by the true locations and velocities

lambda=fig.UserData.lambda;
v=fig.UserData.velocities;
locations=fig.UserData.locations;
R_s=fig.UserData.emitters_UTM(1,:)-locations;
t=sum(v.*R_s,2)./(vecnorm(R_s,2,2)*lambda);
measurement_noise=fig.UserData.DDOP_noise;

% The estimated parameters are estimated by noisy locations, velocities
% and lambda:
lambda=fig.UserData.lambda_noisy;
    function [D_0,F]=calulate_D_F(fig,batch_indices)
        R_0=fig.UserData.R_0;
        v=fig.UserData.velocities_noisy(batch_indices,:);
        locations=fig.UserData.locations_noisy(batch_indices,:);
        R_0s=R_0-locations;
        norm_R_0s=vecnorm(R_0s,2,2);
        D_0=sum(v.*R_0s,2)./norm_R_0s;
        F=v./norm_R_0s-(D_0./norm_R_0s.^2).*R_0s;
    end
[R_hat,P_hat_inv,solutions]=linear_est_WLS(fig,@calulate_D_F,t,lambda,measurement_noise,...
    fig.UserData.DDOP_total_noise);
end