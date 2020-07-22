function disappear_plot(~,event_data_structure)
% disappear graph and legend after clicking
% remove linestyle and marker
line=event_data_structure.Peer;

if all(line.LineStyle=='none')&& all(line.Marker=='none')
    line.LineStyle=line.UserData.LineStyle;
    line.Marker=line.UserData.Marker;
else
    line.UserData.Marker=line.Marker;
    line.UserData.LineStyle=line.LineStyle;
    line.LineStyle='none';
    line.Marker='none';
end
end

