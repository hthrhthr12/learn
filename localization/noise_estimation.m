function [DDOP_noise,TDOA_noise]=noise_estimation(fig)
% estimate the noise of DDOP without CRLB
coherent_time=fig.UserData.coherent_time;
BW=fig.UserData.BW;
SNR=fig.UserData.SNR;
beta_r=fig.UserData.beta_r;
CRLB=1/(8*pi^2*SNR*beta_r^2*BW*coherent_time);

c=fig.UserData.c;
lambda_s=fig.UserData.lambda^2;
%measurement noise
DDOP_noise=fig.UserData.DDOP_noise;
TDOA_noise=fig.UserData.TDOA_noise+fig.UserData.location_error^2/c^2;
v=fig.UserData.velocities;
locations=fig.UserData.locations;

R_s=fig.UserData.emitters_UTM-locations;
norm_R_s=vecnorm(R_s,2,2);
vR_s=sum(v.*R_s,2)./norm_R_s;
norm_v=vecnorm(v,2,2);

DDOP_noise=DDOP_noise+(fig.UserData.frequency_error^2/c^2)*vR_s.^2+...
fig.UserData.velocity_error.^2/lambda_s+...
(fig.UserData.location_error^2/lambda_s)*(norm_v.^2./norm_R_s.^2-(vR_s./norm_R_s).^2);

DDOP_noise=DDOP_noise+CRLB;
TDOA_noise=TDOA_noise+CRLB;
end