function step_DDOP(src,~)
% we calculate the step
fig=src.Parent;
tic
%CDF (and heatmap on the grid) of the ellipse area for fixed sampling path
% and emitter in each point on the grid.
if fig.UserData.num_platforms<3
    disp('cannot estimate by less than three platforms')
    return;
end
delete(findall(fig,'Tag','est'));

fig.UserData.emitters_UTM_last=fig.UserData.emitters_UTM;
extract_parameters(fig,'calculate_R_0',false,'randomized',false);
create_UTM_grid(fig);

%Grid in GEO transformed to UTM
xygrid=fig.UserData.xygrid;
arrayfun(@(index)DDOP_result(index),1:length(xygrid));
fig.UserData.emitters_UTM=fig.UserData.emitters_UTM_last;
% colormap(f.CurrentAxes,'jet')
% colorbar(f.CurrentAxes)
% title('area of ellipses')
% xlabel('longitude')
% ylabel('latitude')
toc
    function DDOP_result(index)
        % calculate the result of ellipse DDOP estimation
        % where emitter is assumed at xygrid(index,:)
        % emitter and R_0 are changed in each function evaluation
        fig.UserData.emitters_UTM=xygrid(index,:);
        calculate_R_0(fig);
        
        [fig.UserData.DDOP_total_noise,~]=noise_estimation(fig);
        randomized_variables(fig);
        R_hat_DDOP=DDOP_est(fig);
        
        [x,y]=inter2figure(fig,[xygrid(index,1);R_hat_DDOP(1)],...
            [xygrid(index,2);R_hat_DDOP(2)]);
        if all([x;y]>0)&& all([x;y]<1)
            annotation(fig,'arrow',x,y,'Tag','est');
        end
    end

end
