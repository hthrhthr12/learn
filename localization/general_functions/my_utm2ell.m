function ELL=my_utm2ell(P,ell,zone)

%% Load ellipsoids
load Ellipsoids;
if ~exist(ell,'var')
    error(['Ellipsoid ',ell,' is not defined in Ellipsoids.mat - check your definitions!.'])
end
eval(['ell=',ell,';']);


%% Do the calculations

ELL=zeros(size(P));

% 1. eccentricity
e2=(ell.a^2-ell.b^2)/ell.a^2;
% 2. eccentricity
es2=(ell.a^2-ell.b^2)/ell.b^2;

% Transverse mercator - all except poles
    y=P(:,1)-5e5;
    x=P(:,2);
    m0=0.9996;
    
    n=(ell.a-ell.b)/(ell.a+ell.b);
    es2=(ell.a^2-ell.b^2)/ell.b^2;
    
    B=(1+n)/ell.a/(1+n^2/4+n^4/64)*x/m0;
    
    b1=3/2*n*(1-9/16*n^2)*sin(2*B);
    b2=n^2/16*(21-55/2*n^2)*sin(4*B);
    b3=151/96*n^3*sin(6*B);
    b4=1097/512*n^4*sin(8*B);
    
    Bf=B+b1+b2+b3+b4;
    
    % shortened Longitude:
    Vf=sqrt(1+es2*cos(Bf).^2);
    etaf=sqrt(es2*cos(Bf).^2);
    
    ys=y*ell.b/m0/ell.a^2;
    l=atan(Vf./cos(Bf).*sinh(ys).*(1-etaf.^4.*ys.^2/6-es2.*ys.^4/10));
    ELL(:,1)=l*180/pi-183+zone*6;
    
    % Latitude:
    ELL(:,2)=atan(tan(Bf).*cos(Vf.*l).*(1-etaf.^2/6.*l.^4))*180/pi;
end
