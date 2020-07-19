function [R_hat,P_hat_inv]=DDOP_est(fig)
v=fig.UserData.velocities;
locations=fig.UserData.locations;
R_0=fig.UserData.R_0;
R_0s=R_0-locations;
norm_R_0s=vecnorm(R_0s,2,2);
D_0=sum(v.*R_0s,2)./norm_R_0s;
measurement_noise=1;

lambda=fig.UserData.lambda;
R_s=fig.UserData.emitters_UTM(1,:)-locations;
t=sum(v.*R_s,2)./vecnorm(R_s,2,2);

F=v./norm_R_0s-(D_0./norm_R_0s.^2).*R_0s;

[R_hat,P_hat_inv]=linear_est_WLS(fig,D_0,t,lambda,measurement_noise,F);

end