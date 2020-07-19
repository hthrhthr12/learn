function emitter_input(fig)

% start get emitters
fig.UserData.help_text.String={'left click for transmitter,',...
    'right click for ending'};
set(fig,'WindowButtonDownFcn',@add_emitter);
    function add_emitter(~,~)
        if strcmp('alt',get(fig, 'SelectionType'))
            frequency_input(fig);
            return
        end
        plot_cursor_position(fig,'tag','emitter_','field','num_emitters')
    end
    function frequency_input(fig)
        % emitter were ended
        create_UTM_grid(fig);
        % start get frequencies
        set(fig,'WindowButtonDownFcn',@(~,~)[])
        input_y=findall(fig,'Tag','input_y');
        input_y.Tag='sample_rate';
        input_x=findall(fig,'Tag','input_x');
        input_y.Visible='on';
        input_x.Visible='on';
        input_x.Tag='f0';
        text_x='f0: 100MHz';
        text_y='sample rate: 1Hz';
        sample_times='samples: 12k';
        fig.UserData.f0=100*1000*1000;
        fig.UserData.samples=12000;
        fig.UserData.sample_rate=12000;
        done_button=findobj(fig,'Tag','done_add');
        done_button.Visible='on';
        
        %% if there is no any emitter, enter default
        if isempty(findall(fig,'Tag','emitter_1'))
            add_point(fig,[mean(fig.CurrentAxes.XLim),...
                mean(fig.CurrentAxes.YLim)],'r','x','emitter',...
                'list_points',false);
        end
        sample_times_box=add_uicontrol(fig,0.58231,[0.8776,0.4541,0.07552,0.04371]);
        sample_times_box.String=sample_times;
        sample_times_box.Tag='num_samples';
        velocity_units=add_uicontrol(fig,0.58231,...
            [0.8786,0.3592,0.07552,0.0437],'style','popupmenu','String',{'km/h','m/h'});
        velocity_units.Tag='velocity_units';
        
        show_gradients=add_uicontrol(fig,0.58231,...
            [0.8479,0.5606,0.1255,0.0437],'style','pushbutton');
        show_gradients.String='DDOP gradient';
        show_gradients.Callback=@display_gradients;
        %%
        input_x.String=text_x;
        input_y.String=text_y;
        fig.UserData.text_x=text_x;
        fig.UserData.text_y=text_y;
        
        fig.UserData.help_text.String=...
            {'Click for Done'};
        
        
        set(fig.findobj('Tag','done_add'),...
            {'String','Callback','Visible'},{'Done',...
            @calculate_DDOP_TDOA,'on'})
        velocity=add_uicontrol(fig,0.58231,...
            [0.8786,0.2792,0.07552,0.0437],'style','edit','String'...
            ,'velocity: 500');        
        velocity.Tag='velocity';

        TDOA_noise=add_uicontrol(fig,0.58231,...
            [0.8786,0.1992,0.07552,0.0437],'style','edit','String'...
            ,'TDOA std: 1e-6 sec');
        TDOA_noise.Tag='TDOA_noise';
        locations2utm(fig);
fig.UserData.c=physconst('LightSpeed');
fig.UserData.display_DDOP=0;
    end
end