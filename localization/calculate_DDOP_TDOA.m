function calculate_DDOP_TDOA(src,event)
fig=src.Parent;

if fig.UserData.num_platforms<3
    disp('cannot estimate by less than three platforms')
    return;
end
%% DELETE old estimation
if ~isempty(findobj(fig,'Tag','TDOA'))
    %delete old estimation
    delete(findobj(fig,'Tag','TDOA'))
    delete(findobj(fig,'Tag','DDOP'))
    delete(findobj(fig,'Tag','TDOA_DDOP'))
    delete(findobj(fig,'Tag','R0'))
end

%% if manual initial point for WLS
initial_point=fig.findobj('Tag','initial_point').Value;
if initial_point==4 && ~isnumeric(event)
        set(fig,'WindowButtonDownFcn',@add_initial);
    return;
end
    function add_initial(~,~)
        delete_obj(fig,'R0');
        [x,y]=plot_cursor_position(fig,'plot_point',false);
        [~,fig.UserData.R_0]=ell2utm([x,y],'wgs84',[],36,[],[]);
        calculate_DDOP_TDOA(src,0);
    end

%% calculate noise std with platform errors
extract_parameters(fig);
R_0=my_utm2ell(fig.UserData.R_0,'wgs84',36);
plot(R_0(1),R_0(2),'kh','Tag','R0');
[fig.UserData.DDOP_total_noise,fig.UserData.TDOA_total_noise]=noise_estimation(fig);

%% TDOA DDOP estimation
[R_hat_TDOA,P_hat_inv_TDOA]=TDOA_est(fig);
disp('TDOA')
disp(P_hat_inv_TDOA)
disp('DDOP')
[R_hat_DDOP,P_hat_inv_DDOP]=DDOP_est(fig);
disp(P_hat_inv_DDOP)

[G_sums_TDOA,h1]=plot_ellipse(fig,R_hat_TDOA,P_hat_inv_TDOA,'color','b','Tag','TDOA');
[G_sums_DDOP,h2]=plot_ellipse(fig,R_hat_DDOP,P_hat_inv_DDOP,'color','c','Tag','DDOP');
% the scales are very different
[R_hat,P_hat_inv]=G_sums2est(G_sums_TDOA+G_sums_DDOP);
disp('combined')
disp(P_hat_inv)
[~,h3]=plot_ellipse(fig,R_hat,P_hat_inv,'color','g','Tag','TDOA_DDOP');
fig.UserData.help_text.String='paths start large and decreases';
lgd=legend([h1,h2,h3]);
lgd.ItemHitFcn={@disappear_plot};

end