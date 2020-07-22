function delete_obj(fig,tag)

if ~isempty(findobj(fig,'Tag',tag))
    %delete old object
    delete(findobj(fig,'Tag',tag))
end
end