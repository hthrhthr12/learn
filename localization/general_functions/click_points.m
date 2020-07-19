function click_points(fig)
fig.UserData.input=[];
fig.UserData.num_lines=0;
fig.WindowButtonDownFcn=@input_line;

fig.WindowButtonUpFcn=@plot_line;


ui_element=add_ui(fig,[0.892,0.78281,0.076041,0.05021],'Edit');
ui_element.FontSize=0.2836;
%click_points(fig,true,...
%    @(fig,event)draw_path(fig,event,'end_function',@emitter_input),...
%   {'wait two seconds ,','draw a path, right click for ending'});



    function input_line(fig,~)
        if strcmp('alt',get(fig, 'SelectionType'))
            emitter_input(fig);
            return
        end
        
        fig.WindowButtonMotionFcn=@append_points;
    end
    function append_points(fig,~)
        % fig.CurrentPoint is the current position of cursor in fig.Units
        fig.UserData.input(end+1,[1,2])=fig.CurrentPoint;
    end
    function plot_line(fig,~)
        
        data_input=fig.UserData.input;
        if length(data_input)<2
            fig.WindowButtonMotionFcn=@(~,~)[];
            fig.UserData.input=[];
            return;
        end
        x_input=data_input(:,1);
        y_input=data_input(:,2);
        axes_pos=fig.CurrentAxes.Position;
        relevant=(x_input>axes_pos(1))&(x_input<(axes_pos(1)+axes_pos(3)))&...
            (y_input>axes_pos(2))&(y_input<(axes_pos(2)+axes_pos(4)));
        
        x_input=x_input(relevant);
        y_input=y_input(relevant);
        if length(x_input)>1
            fig.UserData.num_lines=fig.UserData.num_lines+1;
            [x_true,y_true]=inter2axes(fig,x_input,y_input);
            line=plot(fig.CurrentAxes,x_true,y_true,'^--');
            line.Tag=['line_',num2str(fig.UserData.num_lines)];
        end
        fig.WindowButtonMotionFcn=@(~,~)[];
        fig.UserData.input=[];
    end
end