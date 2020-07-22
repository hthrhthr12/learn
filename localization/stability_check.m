function stability_check(src,~)
fig=src.Parent;

%CDF (and heatmap on the grid) of the ellipse area for fixed sampling path
% and emitter in each point on the grid.
if fig.UserData.num_platforms<3
    disp('cannot estimate by less than three platforms')
    return;
end
fig.UserData.emitters_UTM_last=fig.UserData.emitters_UTM;

N=1:100; % Monte Carlo simulations

extract_parameters(fig,'calculate_R_0',false,'randomized',false);

%Grid in GEO transformed to UTM
xygrid=fig.UserData.xygrid;
area_ellipse=arrayfun(@mean_area,1:length(xygrid));
figure;
xgrid=fig.UserData.xgrid;
num_grid=length(xgrid);
imagesc(xgrid,fig.UserData.ygrid,pi*reshape(area_ellipse,num_grid,[]));
axis xy; % flip ydirection
fig.UserData.emitters_UTM=fig.UserData.emitters_UTM_last;

    function area_est=mean_area(index)
        % calculate the area of ellipse total estimation
        % where emitter is assumed at xygrid(index,:)
        %emitter and R_0 are changed in each function evaluation
        fig.UserData.emitters_UTM=xygrid(index,:);
        
        [fig.UserData.DDOP_total_noise,fig.UserData.TDOA_total_noise]=noise_estimation(fig);
        area_est=mean(arrayfun(@(~)area_ellipse_estimation,N));
        function area=area_ellipse_estimation
            randomized_variables(fig);
            fig.UserData.R_0=xygrid(index,:)+...
                fig.UserData.initial_point_noise*randn(1,2);
            [R_hat_TDOA,P_hat_inv_TDOA]=TDOA_est(fig);         
            [R_hat_DDOP,P_hat_inv_DDOP]=DDOP_est(fig);
            [~,P_hat_inv]=G_sums2est(retrieve_G_sums(R_hat_TDOA,P_hat_inv_TDOA)+...
                retrieve_G_sums(R_hat_DDOP,P_hat_inv_DDOP));
            area=det(P_hat_inv).^(-0.5);
            % we add pi in the end
        end
    end
end