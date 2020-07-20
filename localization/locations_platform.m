function locations_platform(fig,i_platform)
% create locations and velocities at snapshots for specific platform

start=fig.UserData.platforms_len(i_platform)+1;
stop=fig.UserData.platforms_len(i_platform+1);
paths=fig.UserData.platforms_distances{i_platform};
cum_path=cumsum(paths);
if fig.UserData.use_num_samples
    num_samples=fig.UserData.num_samples;
else
    % determines number of samples by sample rate and velocity
    num_samples=...
        floor(cum_path(end)*fig.UserData.sample_rate/fig.UserData.velocity);
    fig.UserData.num_samples=min(fig.UserData.num_samples,num_samples);
    % we estimate for simplicity by the min num_samples
end
disp(['num samples in path: ',num2str(num_samples)])

path_from_start=(linspace(0,cum_path(end),num_samples)).';
locations=zeros(num_samples,2);
velocities=zeros(num_samples,2);
platforms_UTM=fig.UserData.platforms_UTM(start:stop,:);
% we have small number of platforms_UTM data and large number of
% measurements, hence we use interpolation.

until_now_distance=0;
seg_indices=[1,1];
for seg=1:stop-start
    index=find(path_from_start(seg_indices(1):end)<cum_path(seg),1,'last');
    if isempty(index)
        until_now_distance=cum_path(seg);
        continue;
        % if there is no measurement points in this segment continue
    end
    seg_indices(2)=seg_indices(1)+index;
    % divide a segment by a known ratio
    paths_in_line=path_from_start(seg_indices(1):seg_indices(2))...
        -until_now_distance;
    
    locations(seg_indices(1):seg_indices(2),:)=...
        (paths_in_line.*platforms_UTM(seg+1,:)+(paths(seg)-paths_in_line)...
        .*platforms_UTM(seg,:))./paths(seg);
    
    velocity=platforms_UTM(seg+1,:)-platforms_UTM(seg,:);
    velocity=velocity/norm(velocity);
    velocities(seg_indices(1):seg_indices(2),:)=...
        kron(ones(diff(seg_indices)+1,1),velocity);
    seg_indices(1)=seg_indices(2)+1;
    %start the next segment after the last one
    until_now_distance=cum_path(seg);
end

fig.UserData.locations{i_platform}=locations;
fig.UserData.velocities{i_platform}=velocities;

end