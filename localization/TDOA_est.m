function [R_hat,P_hat_inv]=TDOA_est(fig)
%true locations
locations=fig.UserData.locations;
%The measurements are calculated by the true locations
c=fig.UserData.c;
t=vecnorm(fig.UserData.emitters_UTM(1,:)-locations,2,2)/c;

R_0=fig.UserData.R_0;
locations=fig.UserData.locations_noisy;
% The estimated parameters are estimated by noisy locations
D_0=vecnorm(R_0-locations,2,2);
% t=D_0/c+noise
measurement_noise=fig.UserData.TDOA_noise;
R_s=(R_0-locations);

F=R_s./vecnorm(R_s,2,2);
[R_hat,P_hat_inv]=linear_est_WLS(fig,D_0,t,c,measurement_noise,F);

end