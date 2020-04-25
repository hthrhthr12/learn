function txt = displayCoordinates(~,info,function_symbol)
    x = info.Position(1);
    y = info.Position(2);
    txt = [function_symbol,'(' num2str(x) ')=' num2str(y)];
end