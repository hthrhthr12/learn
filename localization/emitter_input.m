function emitter_input(fig)

if fig.UserData.num_lines==0
    error_msg='no platforms were entered, run again';
    fig.UserData.help_text.String=error_msg;
    disp(error_msg)
    return
end
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
        [sample_rate,position]=add_ui(fig,[0.892,0.945,0.076041,0.04021],'Edit','sample_rate');
        
        [f0,position]=add_ui(fig,position,'Edit','f0');
        f0.UserData.default=1e8;
        [done_add,position]=add_ui(fig,position,'pushbutton','done_add');
        set(done_add,{'String','Callback','Visible'},{'Done',...
            @calculate_DDOP_TDOA,'on'})
        
        f0.String='f0: 100MHz';
        sample_rate.String='sample rate: 1Hz';
        sample_rate.UserData.default=1;
        %% if there is no any emitter, enter default
        if isempty(findall(fig,'Tag','emitter_1'))
            fig.UserData.num_emitters=1;
            plot(fig.CurrentAxes,mean(fig.CurrentAxes.XLim),...
                mean(fig.CurrentAxes.YLim),'rx','Tag','emitter_1');
        end
        [sample_times_box,position]=add_ui(fig,position,'edit','num_samples');
        sample_times_box.String="12k samples";
        sample_times_box.UserData.default=12e3;
        
        [velocity_units,position]=add_ui(fig,position,'popupmenu','velocity_units');
        velocity_units.String={'km/h','m/h'};
        
        [show_gradients,position]=add_ui(fig,position,'pushbutton','show_gradients');
        show_gradients.String='DDOP gradient';
        show_gradients.Callback=@display_gradients;
        %%
        fig.UserData.help_text.String=...
            {'Click for Done'};
        [velocity,position]=add_ui(fig,position,'edit','velocity');
        velocity.String='velocity: 500'; % 500 km/h = 1800 m/s
        
        %%
        [TDOA_noise,position]=add_ui(fig,position,'edit','TDOA_noise');
        TDOA_noise.String='TDOA std: 1e-6 sec';
        TDOA_noise.UserData.default=1e-6;
        %%
        [DDOP_noise,position]=add_ui(fig,position,'edit','DDOP_noise');
        DDOP_noise.String='DDOP std: 1e4 Hz';
        DDOP_noise.UserData.default=1e4;
        
        %% initial_point
        [initial_point,position]=add_ui(fig,position,'popupmenu','initial_point');
        initial_point.String={'true','middle','random','manual'};
        
        [initial_point_noise,position]=add_ui(fig,position,'edit','initial_point_noise');
        initial_point_noise.String='Initial WLS: 1m std from true emitter';
        initial_point_noise.UserData.default=1;
        
        %%
        [location_error,position]=add_ui(fig,position,'edit','location_error');
        location_error.String='1m std platform location error';
        location_error.UserData.default=1;
        
        %%
        [velocity_error,position]=add_ui(fig,position,'edit','velocity_error');
        velocity_error.String='1m/s std platform velocity error';
        velocity_error.UserData.default=1;
        
        %%
        [frequency_error,position]=add_ui(fig,position,'edit','frequency_error');
        frequency_error.String='1Hz std central frequency error';
        frequency_error.UserData.default=1;
        %%
        [~,position]=add_slider(fig,position,10,20,'(dB)','SNR');
        [~,position]=add_slider(fig,position,1e8,2e8,'(Hz)','BW');
        %%
        [coherent_time,position]=add_ui(fig,position,'edit','coherent_time');
        coherent_time.String='1e-6 sec coherent time';
        coherent_time.UserData.default=1e-6;
        %%
        [beta_r,position]=add_ui(fig,position,'edit','beta_r');
        beta_r.String='1kHz beta_r';
        beta_r.UserData.default=1000;
        %%
        [stability,position]=add_ui(fig,position,'pushbutton','stability_check');
        stability.String='stability check';
        stability.Callback=@stability_check;
        %%
        [step_WLS,position]=add_ui(fig,position,'pushbutton');
        step_WLS.String='step WLS';
        step_WLS.Callback=@step_DDOP;
        %%
        [WLS_batch,~]=add_ui(fig,position,'edit','WLS_batch');
        WLS_batch.String='1000 samples batch size';
        WLS_batch.UserData.default=1e3;
        
        %%
        locations2utm(fig);
        fig.UserData.c=physconst('LightSpeed');
        fig.UserData.display_DDOP=0;
    end
end