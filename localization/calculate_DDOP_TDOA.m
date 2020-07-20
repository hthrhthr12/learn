function calculate_DDOP_TDOA(src,~)
fig=src.Parent;

if fig.UserData.num_platforms<3
    disp('cannot estimate by less than three platforms')
    return;
end
extract_parameters(fig);
[R_hat_TDOA,P_hat_inv_TDOA]=TDOA_est(fig);
[R_hat_DDOP,P_hat_inv_DDOP]=DDOP_est(fig);

G_sums_TDOA=plot_ellipse(fig,R_hat_TDOA,P_hat_inv_TDOA,'color','b');
G_sums_DDOP=plot_ellipse(fig,R_hat_DDOP,P_hat_inv_DDOP,'color','b');
% the scales are very different
[R_hat,P_hat_inv]=G_sums2est(G_sums_TDOA+G_sums_DDOP);
plot_ellipse(fig,R_hat,P_hat_inv,'color','b');

end