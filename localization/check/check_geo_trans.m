% longitude in (-180,180 East]
% latitude in [-90,90 North]
N=100;
in_point=[360*rand(N,1)-180,180*rand(N,1)-90,rand(N,1)*1000];
%[longitude, latitude,height]
Datums={'WGS84','ED50'};
Projections={'UTM','GEO'};
Zones=1:60;
%if projection is GEO, zone = 0
in_Datum=Datums(randi(2));
in_Proj='GEO';%Projections(randi(2));
if strcmp(in_Proj,'GEO') 
    in_zone=0;
else
    in_zone=randi(60); 
end
out_Proj='UTM';%Projections(randi(2));
if strcmp(out_Proj,'GEO') 
    out_zone=0;
else
    out_zone=randi(60); 
end
out_Datum=Datums(randi(2));
geotrans1(in_point,in_Datum,in_Proj,in_zone,out_Datum,out_Proj,out_zone)

