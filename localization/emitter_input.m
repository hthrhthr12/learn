function emitter_input(fig)
fig.UserData.num_emitters=0;
% start get emitters
fig.UserData.help_text.String=['left click for transmitter,',...
    ' right click for ending'];
set(fig,'WindowButtonDownFcn',@add_emitter);
    function add_emitter(~,~)
        [x_true,~]=plot_cursor_position(fig,'tag','emitter_1');
        if ~isempty(x_true)
            fig.UserData.num_emitters=fig.UserData.num_emitters+1;
            frequency_input(fig);
        end
    end
    function frequency_input(fig)
        % emitter were ended
        create_UTM_grid(fig);
        % start get frequencies
        set(fig,'WindowButtonDownFcn',@(~,~)[])
        [sample_rate,position]=add_ui(fig,[0.892,0.945,0.076041,0.05021],'Edit');
        sample_rate.Tag='sample_rate';
        
        [f0,position]=add_ui(fig,position,'Edit');
        f0.Tag='f0';
        
        text_x='f0: 100MHz';
        text_y='sample rate: 1Hz';
        sample_times='samples: 12k';
        fig.UserData.f0=100*1000*1000;
        fig.UserData.samples=12000;
        fig.UserData.sample_rate=12000;
        
        [done_add,position]=add_ui(fig,position,'pushbutton');
        done_add.Tag='done_add';
        
        %% if there is no any emitter, enter default
        if isempty(findall(fig,'Tag','emitter_1'))
            fig.UserData.num_emitters=1;
            plot(fig.CurrentAxes,mean(fig.CurrentAxes.XLim),...
                mean(fig.CurrentAxes.YLim),'rx','Tag','emitter_1');
        end
        [sample_times_box,position]=add_ui(fig,position,'edit');
        
        sample_times_box.String=sample_times;
        sample_times_box.Tag='num_samples';
        
        [velocity_units,position]=add_ui(fig,position,'popupmenu');
        velocity_units.String={'km/h','m/h'};
        velocity_units.Tag='velocity_units';
        
        [show_gradients,position]=add_ui(fig,position,'pushbutton');
        
        show_gradients.String='DDOP gradient';
        show_gradients.Callback=@display_gradients;
        %%
        sample_rate.String=text_x;
        f0.String=text_y;
        fig.UserData.text_x=text_x;
        fig.UserData.text_y=text_y;
        
        fig.UserData.help_text.String=...
            {'Click for Done'};
        
        
        set(fig.findobj('Tag','done_add'),...
            {'String','Callback','Visible'},{'Done',...
            @calculate_DDOP_TDOA,'on'})
        [velocity,position]=add_ui(fig,position,'edit');
        velocity.String='velocity: 500';
        velocity.Tag='velocity';
        %%
        [TDOA_noise,position]=add_ui(fig,position,'edit');
        TDOA_noise.String='TDOA std: 1e-6 sec';
        TDOA_noise.Tag='TDOA_noise';
        %%
        [DDOP_noise,position]=add_ui(fig,position,'edit');
        DDOP_noise.String='DDOP std: 1e4 Hz';
        DDOP_noise.Tag='DDOP_noise';
        
        %% initial_point
        [initial_point,position]=add_ui(fig,position,'popupmenu');
        initial_point.String={'true','middle','random','manual'};
        initial_point.Tag='initial_point';
        [initial_point_noise,position]=add_ui(fig,position,'edit');
        initial_point_noise.String='Initial WLS: 1m std from true emitter';
        initial_point_noise.Tag='initial_point_noise';
        
        %%
        [location_error,position]=add_ui(fig,position,'edit');
        location_error.String='1m std platform location error';
        location_error.Tag='location_error';
        %%
        [velocity_error,position]=add_ui(fig,position,'edit');
        velocity_error.String='1m/s std platform velocity error';
        velocity_error.Tag='velocity_error';
        %%
        [frequency_error,position]=add_ui(fig,position,'edit');
        frequency_error.String='1Hz std central frequency error';
        frequency_error.Tag='frequency_error';
        %%
        [~,position]=add_slider(fig,position,10,20,'(dB)','SNR');
        [~,position]=add_slider(fig,position,1e8,2e8,'(Hz)','BW');
        %%
        [coherent_time,position]=add_ui(fig,position,'edit');
        coherent_time.String='1e-6 sec coherent time';
        coherent_time.Tag='coherent_time';
        %%
        [beta_r,position]=add_ui(fig,position,'edit');
        beta_r.String='1kHz beta_r';
        beta_r.Tag='beta_r';
        %%
        [stability,~]=add_ui(fig,position,'pushbutton');
        stability.String='stability check';
        stability.Callback=@stability_check;
        %%
        locations2utm(fig);
        fig.UserData.c=physconst('LightSpeed');
        fig.UserData.display_DDOP=0;
    end
end