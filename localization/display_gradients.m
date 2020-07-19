function display_gradients(src,~)
% display gradients of DDOP
% one can display also the DDOP and the approximate DDOP by R_0
fig=src.Parent;
fig.UserData.display_DDOP=mod(fig.UserData.display_DDOP+1,3 );

if fig.UserData.display_DDOP==1
    % display gradients
    extract_parameters(fig);
    DDOP=create_DDOP(fig,false);
    imagesc(fig.CurrentAxes,fig.UserData.xgrid,fig.UserData.ygrid,DDOP,'Tag','DDOP');
    colormap('jet');
    fig.UserData.help_text.String='DDOP';
elseif fig.UserData.display_DDOP==2
    extract_parameters(fig);
    DDOP=create_DDOP(fig,true);
    imagesc(fig.CurrentAxes,fig.UserData.xgrid,fig.UserData.ygrid,DDOP,'Tag','DDOP');
    colormap('jet');
    fig.UserData.help_text.String='DDOP gradient norm';
else
    delete(findobj(fig.CurrentAxes,'Tag','DDOP'));
    fig.UserData.help_text.String='';
end
end