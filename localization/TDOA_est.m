function [R_hat,P_hat_inv,solutions]=TDOA_est(fig)

%The measurements are calculated by the true locations
c=fig.UserData.c;
t=vecnorm(fig.UserData.emitters_UTM(1,:)-fig.UserData.locations,2,2)/c;
measurement_noise=fig.UserData.TDOA_noise;

    function [D_0,F]=calulate_D_F(fig,batch_indices)
        R_0=fig.UserData.R_0;
        locations=fig.UserData.locations_noisy(batch_indices,:);
        % The estimated parameters are estimated by noisy locations
        D_0=vecnorm(R_0-locations,2,2);
        % t=D_0/c+noise
        R_s=(R_0-locations);
        
        F=R_s./vecnorm(R_s,2,2);
    end
[R_hat,P_hat_inv,solutions]=linear_est_WLS(fig,@calulate_D_F,t,c,measurement_noise,...
    fig.UserData.TDOA_total_noise);
end