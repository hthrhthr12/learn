function DDOP=create_DDOP(fig,varargin)
% we display DDOP map of two points
% we can display cost map of sum of error squared
p=inputParser;
p.addOptional("return_gradient","none",@isstring);
p.parse(varargin{:});
return_gradient=p.Results.return_gradient;

%% DDOP creation

xygrid=fig.UserData.xygrid;
x_1=fig.UserData.locations(1,:);
v_1=fig.UserData.velocities(1,:).';
second_platform=fig.UserData.platforms_len(2)+1;
x_2=fig.UserData.locations(second_platform,:);
v_2=fig.UserData.velocities(second_platform,:).';

DDOP=2/fig.UserData.lambda*((x_1-xygrid)*v_1./vecnorm(x_1-xygrid,2,2)...
    -(x_2-xygrid)*v_2./vecnorm(x_2-xygrid,2,2));

num_grid=fig.UserData.num_grid;
DDOP=reshape(DDOP,num_grid,num_grid);

%% DDOP gradient
if return_gradient=="none"
    return
end

[FX,FY] = gradient(DDOP);

if return_gradient=="norm"
    DDOP=sqrt(FX.^2+FY.^2);
elseif return_gradient=="gradient"
    DDOP={FX,FY};
elseif return_gradient=="log_gradient"
    DDOP_log_norm=log(sqrt(FX.^2+FY.^2));
    grad_log=@(F)sign(F).*log(abs(F));
    DDOP={DDOP_log_norm,grad_log(FX),grad_log(FY)};
end

end