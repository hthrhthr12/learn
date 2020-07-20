function calculate_DDOP_TDOA(src,~)
fig=src.Parent;

if fig.UserData.num_platforms<3
    disp('cannot estimate by less than three platforms')
    return;
end

if ~isempty(findobj(fig,'Tag','TDOA'))
    %delete old estimation
    delete(findobj(fig,'Tag','TDOA'))
    delete(findobj(fig,'Tag','DDOP'))
    delete(findobj(fig,'Tag','TDOA_DDOP'))
end
extract_parameters(fig);
[R_hat_TDOA,P_hat_inv_TDOA]=TDOA_est(fig);
[R_hat_DDOP,P_hat_inv_DDOP]=DDOP_est(fig);

G_sums_TDOA=plot_ellipse(fig,R_hat_TDOA,P_hat_inv_TDOA,'color','b','Tag','TDOA');
G_sums_DDOP=plot_ellipse(fig,R_hat_DDOP,P_hat_inv_DDOP,'color','c','Tag','DDOP');
% the scales are very different
[R_hat,P_hat_inv]=G_sums2est(G_sums_TDOA+G_sums_DDOP);
plot_ellipse(fig,R_hat,P_hat_inv,'color','g','Tag','TDOA_DDOP');
fig.UserData.help_text.String='blue: TDOA, cyan: DDOP, combined: green';
end