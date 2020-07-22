function extract_parameters(fig,varargin)

%% input
p=inputParser;
p.addParameter('calculate_R_0',true);
p.addParameter('randomized',true);
p.parse(varargin{:});

%% extract parameters from fig

fig.UserData.f0=extract_element(fig,'f0',10^8); % MHz

fig.UserData.use_num_samples=true;

fig.UserData.num_samples=extract_element(fig,'num_samples',12*10^3); %12k

%%
sample_rate=str2double(fig.findobj('Tag','sample_rate').String);
if isnan(sample_rate) % sample rate units are Hz
    sample_rate=1;% 1Hz
else
    % if user enters sample_rate and num_samples use sample_rate
    fig.UserData.use_num_samples=false;
end

fig.UserData.sample_rate=sample_rate;

%% noises
fig.UserData.TDOA_noise=extract_element(fig,'TDOA_noise',1e-6);

fig.UserData.DDOP_noise=extract_element(fig,'DDOP_noise',1e4);
%% extract velocity
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

%% extract R0
fig.UserData.initial_point_noise=extract_element(fig,'initial_point_noise',1); % 1m

if p.Results.calculate_R_0
    initial_point=fig.findobj('Tag','initial_point').Value;
    switch initial_point
        case 1
            %true
            fig.UserData.R_0=fig.UserData.emitters_UTM(1,:);
        case 2
            % middle
            [~,fig.UserData.R_0]=ell2utm([mean(fig.CurrentAxes.XLim),...
                mean(fig.CurrentAxes.YLim)],'wgs84',[],36,[],[]);
            
        case 3
            %random
            fig.UserData.R_0=fig.UserData.emitters_UTM(1,:)+...
                fig.UserData.initial_point_noise*randn(1,2);
    end
    
end

%%
fig.UserData.location_error=extract_element(fig,'location_error',1);
fig.UserData.velocity_error=extract_element(fig,'velocity_error',1);
fig.UserData.frequency_error=extract_element(fig,'frequency_error',1);
fig.UserData.coherent_time=extract_element(fig,'coherent_time',1e-6);
fig.UserData.beta_r=extract_element(fig,'beta_r',1e3);
%%
SNR=findobj(fig,'Tag','SNR');
fig.UserData.SNR=SNR.Value;
BW=findobj(fig,'Tag','BW');
fig.UserData.BW=BW.Value;

%% extract locations and velocities at receiving places
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
        fig.UserData.locations{i_platform}(1:N,:);
    velocities((i_platform-1)*N+1:i_platform*N,:)=...
        fig.UserData.velocities{i_platform}(1:N,:);
    
end
fig.UserData.locations=locations;
fig.UserData.velocities=velocities*fig.UserData.velocity;
fig.UserData.percentage_containment=90;
fig.UserData.lambda=fig.UserData.c/fig.UserData.f0;
%% noisy parameters
if p.Results.randomized
    randomized_variables(fig)
end
end