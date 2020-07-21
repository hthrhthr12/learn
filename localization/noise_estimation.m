function [DDOP_noise,TDOA_noise]=noise_estimation(fig)
% estimate the noise of DDOP without CRLB
coherent_time=fig.UserData.coherent_time;
BW=fig.UserData.BW;
SNR=fig.UserData.SNR;
beta_r=fig.UserData.beta_r;
CRLB_TDOA=1/(8*pi^2*SNR*beta_r^2*BW*coherent_time);

lambda=physconst('LightSpeed')/f0;
noise=lambda^2*sum(velocity_error.*velocity_error)^2+...
    location_error^2*lambda^2*((norm(v)/norm(r))^2-(v*r)^2/(norm(r)^4))+...
    f0_error^2/physconst('LightSpeed')*((v1*r1)/norm(r1)-(v2*r2)/norm(r2))^2;

[DDOP_noise,TDOA_noise]=sqrt([DDOP_noise,TDOA_noise]);
end