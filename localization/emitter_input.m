function emitter_input(fig)
fig.UserData.num_emitters=0;
% start get emitters
fig.UserData.help_text.String=['left click for transmitter,',...
    ' right click for ending'];
set(fig,'WindowButtonDownFcn',@add_emitter);
    function add_emitter(~,~)
        if strcmp('alt',get(fig, 'SelectionType'))
            frequency_input(fig);
            return
        end
        fig.UserData.num_emitters=fig.UserData.num_emitters+1;
        plot_cursor_position(fig,'tag','emitter_','field','num_emitters')
    end
    function frequency_input(fig)
        % emitter were ended
        create_UTM_grid(fig);
        % start get frequencies
        set(fig,'WindowButtonDownFcn',@(~,~)[])
        sample_rate=add_ui(fig,[0.892,0.78281,0.076041,0.05021],'Edit');
        sample_rate.Tag='sample_rate';
        
        f0=add_ui(fig,[0.8920,0.7075,0.0760,0.0502],'Edit');
        f0.Tag='f0';
        
        text_x='f0: 100MHz';
        text_y='sample rate: 1Hz';
        sample_times='samples: 12k';
        fig.UserData.f0=100*1000*1000;
        fig.UserData.samples=12000;
        fig.UserData.sample_rate=12000;
        
        done_add=add_ui(fig,[0.8920,0.6322,0.0760,0.0502],'pushbutton');
        done_add.Tag='done_add';
        
        %% if there is no any emitter, enter default
        if isempty(findall(fig,'Tag','emitter_1'))
            fig.UserData.num_emitters=1;
            plot(fig.CurrentAxes,mean(fig.CurrentAxes.XLim),...
                mean(fig.CurrentAxes.YLim),'rx','Tag','emitter_1');
        end
        sample_times_box=add_ui(fig,[0.8920,0.5569,0.0760,0.0502],'edit');
        
        sample_times_box.String=sample_times;
        sample_times_box.Tag='num_samples';
        
        velocity_units=add_ui(fig,[0.8920,0.4816,0.0760,0.0502],'popupmenu');
        velocity_units.String={'km/h','m/h'};
        velocity_units.Tag='velocity_units';
        
        show_gradients=add_ui(fig,[0.8920,0.4063,0.0760,0.0502],'pushbutton');
        
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
        velocity=add_ui(fig,[0.8920,0.3310,0.0760,0.0502],'edit');
        velocity.String='velocity: 500';
        velocity.Tag='velocity';
        %%
        TDOA_noise=add_ui(fig,[0.8920,0.2557,0.0760,0.0502],'edit');
        TDOA_noise.String='TDOA std: 1e-6 sec';
        TDOA_noise.Tag='TDOA_noise';
        %%
        DDOP_noise=add_ui(fig,[0.8920,0.1804,0.0760,0.0502],'edit');
        DDOP_noise.String='DDOP std: 1 Hz';
        DDOP_noise.Tag='DDOP_noise';
        
        %% initial_point
        initial_point=add_ui(fig,[0.8920,0.1051,0.0760,0.0502],'popupmenu');
        initial_point.String={'true','middle','random'};
        initial_point.Tag='initial_point';
        %%
        initial_point_noise=add_ui(fig,[0.8920,0.0298,0.0760,0.0502],'edit');
        initial_point_noise.String='1m std from true emitter for each axis';
        initial_point_noise.Tag='initial_point_noise';
        
        %%
        locations2utm(fig);
        fig.UserData.c=physconst('LightSpeed');
        fig.UserData.display_DDOP=0;
    end
end