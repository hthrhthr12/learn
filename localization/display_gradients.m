function display_gradients(src,~)
% display gradients of DDOP
% one can display also the DDOP and the approximate DDOP by R_0
fig=src.Parent;
num_options=4;
fig.UserData.display_DDOP=mod(fig.UserData.display_DDOP+1,num_options+1);

%%
if fig.UserData.display_DDOP>num_options
    delete(findobj(fig.CurrentAxes,'Tag','DDOP'));
    fig.UserData.help_text.String='';
    return
end
%% DDOP
extract_parameters(fig);
    
if fig.UserData.display_DDOP==1
    % display gradients
    DDOP=create_DDOP(fig);
    imagesc(fig.CurrentAxes,fig.UserData.xgrid,fig.UserData.ygrid,DDOP,'Tag','DDOP');
    fig.UserData.help_text.String='DDOP';
elseif fig.UserData.display_DDOP==2
    DDOP=create_DDOP(fig,"norm");
    imagesc(fig.CurrentAxes,fig.UserData.xgrid,fig.UserData.ygrid,DDOP,'Tag','DDOP');
    fig.UserData.help_text.String='DDOP gradient norm';
elseif fig.UserData.display_DDOP==3
    % gradient arrows
    DDOP=create_DDOP(fig,"gradient");
    [x,y]=meshgrid(fig.UserData.xgrid,fig.UserData.ygrid);
    quiver(fig.CurrentAxes,x,y,DDOP{1},DDOP{2},'Tag','DDOP')
    fig.UserData.help_text.String='DDOP gradient norm with arrows';
elseif fig.UserData.display_DDOP==4
    DDOP=create_DDOP(fig,"log_gradient");
    imagesc(fig.CurrentAxes,fig.UserData.xgrid,fig.UserData.ygrid,DDOP{1},'Tag','DDOP');
    [x,y]=meshgrid(fig.UserData.xgrid,fig.UserData.ygrid);
    quiver(fig.CurrentAxes,x,y,DDOP{2},DDOP{3},'Tag','DDOP')
    fig.UserData.help_text.String='DDOP gradient log norm with arrows';
end
colormap('jet');
    
end