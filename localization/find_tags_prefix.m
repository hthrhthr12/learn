function elements=find_tags_prefix(fig,prefix)
% find all lines start with a prefix
% one can define a group of elements for preventing the need for grouping
% by tag prefix
elements=[];
% one can initialize empty by
% line.empty()

lines=findall(fig,'type','line');
for k=1:length(lines)
    line=lines(k);
    if startsWith(line.Tag,prefix)
        elements=[elements,line];
        % If one use the following line, then it will append only the xData
        %elements(end+1)=line;
    end
end

end