function [R_hat,P_hat_inv]=DDOP_est(fig)

%The measurements are calculated by the true locations and velocities

lambda=fig.UserData.lambda;
v=fig.UserData.velocities;
locations=fig.UserData.locations;
R_s=fig.UserData.emitters_UTM(1,:)-locations;
t=sum(v.*R_s,2)./(vecnorm(R_s,2,2)*lambda);

% The estimated parameters are estimated by noisy locations, velocities 
% and lambda:
lambda=fig.UserData.lambda_noisy;
R_0=fig.UserData.R_0;
v=fig.UserData.velocities_noisy;
locations=fig.UserData.locations_noisy;
R_0s=R_0-locations;
norm_R_0s=vecnorm(R_0s,2,2);
D_0=sum(v.*R_0s,2)./norm_R_0s;
measurement_noise=fig.UserData.DDOP_noise;


F=v./norm_R_0s-(D_0./norm_R_0s.^2).*R_0s;

[R_hat,P_hat_inv]=linear_est_WLS(fig,D_0,t,lambda,measurement_noise,F);

end