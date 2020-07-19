function extract_parameters(fig)
% extract parameters from fig 

f0=str2double(fig.findobj('Tag','f0').String);
if isnan(f0)
    f0=10^8;% MHz
end
fig.UserData.f0=f0;% f0 units are Hz
fig.UserData.use_num_samples=true;

num_samples=str2double(fig.findobj('Tag','num_samples').String);
if isnan(num_samples)
    num_samples=12*10^3;% 12k
end
fig.UserData.num_samples=num_samples;
%%
TDOA_noise=str2double(fig.findobj('Tag','TDOA_noise').String);
if isnan(TDOA_noise) % TDOA_noise units are seconds
    TDOA_noise=1e-6;
end

fig.UserData.TDOA_noise=TDOA_noise;

%%
sample_rate=str2double(fig.findobj('Tag','sample_rate').String);
if isnan(sample_rate) % sample rate units are Hz
    sample_rate=1;% 1Hz
else
    % if user enters sample_rate and num_samples use sample_rate
    fig.UserData.use_num_samples=false;
end

fig.UserData.sample_rate=sample_rate;

velocity_units=fig.findobj('Tag','velocity_units').Value;

velocity=str2double(fig.findobj('Tag','velocity').String);
if isnan(velocity)
    velocity=500;
end
if velocity_units==2
    velocity=velocity/1000; % the units are m/h and not km/h
end
% the velocity units are m/s
% the value 3.6 transform from km/h to m/s
fig.UserData.velocity=3.6*velocity;

% extract locations and velocities at receiving places
fig.UserData.locations=cell(1,fig.UserData.num_platforms);
fig.UserData.velocities=cell(1,fig.UserData.num_platforms);

for i_platform=1:fig.UserData.num_platforms
    locations_platform(fig,i_platform);
end

N=fig.UserData.num_samples;
NM=fig.UserData.num_platforms*N;
locations=zeros(NM,2);
velocities=zeros(NM,2);

for i_platform=1:fig.UserData.num_platforms
    % we create matrix of the whole data by ignoring the samples that are
    % not common to all the sensors
    locations((i_platform-1)*N+1:i_platform*N,:)=...
        fig.UserData.locations{i_platform};
    velocities((i_platform-1)*N+1:i_platform*N,:)=...
        fig.UserData.velocities{i_platform};
    
end
fig.UserData.locations=locations;
fig.UserData.velocities=velocities*fig.UserData.velocity;
fig.UserData.percentage_containment=90;
fig.UserData.lambda=fig.UserData.c/fig.UserData.f0;
end