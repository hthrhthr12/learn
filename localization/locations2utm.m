function locations2utm(fig)
% retrieve locations of platforms and emitters and transform to UTM
platforms=find_tags_prefix(fig,'line');
emitters=find_tags_prefix(fig,'emitter');
num_platforms=length(platforms);
fig.UserData.num_platforms=num_platforms;

[emitters_UTM,~] = geotrans2_other_func([[emitters.XData]',[emitters.YData]'],...
    'WGS84','GEO',0,'WGS84','UTM',36); % 36 is the zone in UTM
fig.UserData.emitters_UTM=emitters_UTM;

[platforms_UTM,~] = geotrans2_other_func([[platforms.XData]',[platforms.YData]'],...
    'WGS84','GEO',0,'WGS84','UTM',36); % 36 is the zone in UTM
fig.UserData.platforms_UTM=platforms_UTM;

% the array platforms_len contains the location of the data of each
% platform in platforms_UTM
% k-platform data in 
% fig.UserData.platforms_UTM(platforms_len(k)+1:platforms_len(k+1),:)

platforms_len=zeros(num_platforms+1,1);

for i_platform=1:num_platforms
platforms_len(i_platform+1)=platforms_len(i_platform)+...
    length(platforms(i_platform).XData);
end
fig.UserData.platforms_len=platforms_len;

platforms_distances=cell(fig.UserData.num_platforms,1);

for i_emit=1:fig.UserData.num_platforms
    start=fig.UserData.platforms_len(i_emit)+1;
    stop=fig.UserData.platforms_len(i_emit+1);
    platforms_distances(i_emit,1)=...
        {vecnorm(platforms_UTM(start:stop-1,:)-platforms_UTM(start+1:stop,:),2,2)};
end
fig.UserData.platforms_distances=platforms_distances;

[fig.UserData.R_0,~] = geotrans2_other_func([mean(fig.CurrentAxes.XLim),...
    mean(fig.CurrentAxes.YLim)],...
    'WGS84','GEO',0,'WGS84','UTM',36);

end