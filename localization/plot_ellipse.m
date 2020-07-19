function G_sums=plot_ellipse(fig,R_hat,P_hat_inv,varargin)
p=inputParser;
p.addParameter('color','w');
p.parse(varargin{:});

G_sums=retrieve_G_sums(R_hat,P_hat_inv);

xy=G_sums_sample(fig,G_sums,R_hat,200);
[ellipse_geo,~] = geotrans2(xy.','WGS84','UTM',36,'WGS84','GEO',0); 
% 36 is the zone in UTM
plot(fig.CurrentAxes,ellipse_geo(:,1),ellipse_geo(:,1),...
    [p.Results.color,'*']);

end