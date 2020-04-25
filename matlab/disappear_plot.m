function disappear_plot(legend_object,event_data_structure)
% disappear graph and legend after clicking

if ~all(event_data_structure.Peer.LineStyle=='none')
    event_data_structure.Peer.LineStyle='none';
else
    event_data_structure.Peer.LineStyle='-';
end
end

