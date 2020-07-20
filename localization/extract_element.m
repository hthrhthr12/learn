function value=extract_element(fig,tag,default)
value=str2double(fig.findobj('Tag',tag).String);
if isnan(value) % we cannot convert the string to double
    value=default;
end
end