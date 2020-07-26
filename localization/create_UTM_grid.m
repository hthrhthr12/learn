function create_UTM_grid(fig)
% create UTM grid

num_grid=fig.UserData.UTM_grid;

if isfield(fig.UserData,'xgrid')&& length(fig.UserData.xgrid)==num_grid
    % no need to calculate
    return
end
%% calculate grid

x_lim=fig.CurrentAxes.XLim;
y_lim=fig.CurrentAxes.YLim;

xgrid=linspace(x_lim(1),x_lim(2),num_grid).';
ygrid=linspace(y_lim(1),y_lim(2),num_grid).';
ones_N=ones(num_grid,1);

xygrid=[kron(xgrid,ones_N),kron(ones_N,ygrid)];
% convert from GEO to UTM

% (longitude, latitude)
zone=[]; %36;
[~,fig.UserData.xygrid]=ell2utm(xygrid,'wgs84',[],zone,[],[]);
% [fig.UserData.xygrid,~] = geotrans2_other_function(xygrid,...
%     'WGS84','GEO',0,'WGS84','UTM',36); % 36 is the zone in UTM
fig.UserData.xgrid=xgrid;
fig.UserData.ygrid=ygrid;
end