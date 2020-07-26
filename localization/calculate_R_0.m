function calculate_R_0(fig)
    switch fig.UserData.initial_point
        case 1
            %true
            fig.UserData.R_0=fig.UserData.emitters_UTM(1,:);
        case 2
            % middle
            [~,fig.UserData.R_0]=ell2utm([mean(fig.CurrentAxes.XLim),...
                mean(fig.CurrentAxes.YLim)],'wgs84',[],36,[],[]);
            
        case 3
            %random
            fig.UserData.R_0=fig.UserData.emitters_UTM(1,:)+...
                fig.UserData.initial_point_noise*randn(1,2);
    end
end