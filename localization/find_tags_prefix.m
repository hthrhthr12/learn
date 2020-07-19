function elements=find_tags_prefix(fig,prefix)
% find all lines start with a prefix
elements=[];
% one can initialize empty by
% line.empty()

lines=findall(fig,'type','line');
for k=1:length(lines)
    line=lines(k);
    if startsWith(line.Tag,prefix)
        elements=[elements,line];
    end
end

end