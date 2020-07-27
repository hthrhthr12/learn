function disappear_plot(src,event_data_structure)
% disappear graph and legend after clicking
% remove linestyle and marker
% of all lines with Tag
fig=src.Parent;
line=event_data_structure.Peer;

if ~isempty(line.Tag)% has_tag
    lines=findobj(fig,'Tag',line.Tag);
end

if all(line.LineStyle=='none')&& all(line.Marker=='none')
    apply_fun=@show_line;
else
    apply_fun=@disappear_line;
end
for k=1:length(lines)
    apply_fun(lines(k));
end

end

function show_line(line)
line.LineStyle=line.UserData.LineStyle;
line.Marker=line.UserData.Marker;
end

function disappear_line(line)
line.UserData.Marker=line.Marker;
line.UserData.LineStyle=line.LineStyle;
line.LineStyle='none';
line.Marker='none';
end
