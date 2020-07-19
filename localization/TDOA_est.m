function [R_hat,P_hat_inv]=TDOA_est(fig)

locations=fig.UserData.locations;
R_0=fig.UserData.R_0;
D_0=vecnorm(R_0-locations,2,2);
measurement_noise=fig.UserData.TDOA_noise;
c=fig.UserData.c;
t=vecnorm(fig.UserData.emitters_UTM(1,:)-locations,2,2)/c;
    R_s=(R_0-locations);

F=R_s./vecnorm(R_s,2,2);
[R_hat,P_hat_inv]=linear_est_WLS(fig,D_0,t,c,measurement_noise,F);

end