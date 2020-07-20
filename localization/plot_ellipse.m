function G_sums=plot_ellipse(fig,R_hat,P_hat_inv,varargin)
p=inputParser;
p.addParameter('color','b');
p.addParameter('Tag','result');
p.parse(varargin{:});

G_sums=retrieve_G_sums(R_hat,P_hat_inv);

xy=G_sums_sample(fig,G_sums,R_hat,200);
% [ellipse_geo,~] = geotrans2(xy.','WGS84','UTM',36,'WGS84','GEO',0); 
ellipse_geo=my_utm2ell(xy.','wgs84',36);

% 36 is the zone in UTM
plot(fig.CurrentAxes,ellipse_geo(:,1),ellipse_geo(:,2),...
    [p.Results.color,'*'],'Tag',p.Results.Tag);

end