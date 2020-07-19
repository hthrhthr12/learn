function noise=noise_estimation(f0,r,v,measurement_noise,location_error, ...
    velocity_error,f0_error)
% estimate the noise of DDOP without CRLB

lambda=physconst('LightSpeed')/f0;
noise=lambda^2*sum(velocity_error.*velocity_error)^2+...
    location_error^2*lambda^2*((norm(v)/norm(r))^2-(v*r)^2/(norm(r)^4))+...
    f0_error^2/physconst('LightSpeed')*((v1*r1)/norm(r1)-(v2*r2)/norm(r2))^2;

noise=sqrt(noise);
end