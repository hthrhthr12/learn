function value=extract_element(fig,tag)

element=fig.findobj('Tag',tag);

value=str2double(element.String);
if isnan(value) % we cannot convert the string to double
    value=element.UserData.default;
end
end