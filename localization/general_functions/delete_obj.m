function delete_obj(parent,tag)

if ~isempty(findobj(parent,'Tag',tag))
    %delete old object
    delete(findobj(parent,'Tag',tag))
end
end