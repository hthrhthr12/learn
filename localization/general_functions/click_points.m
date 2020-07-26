function click_points(fig)

% input of mouse drawing
fig.UserData.input=[];
fig.UserData.num_lines=0;
fig.WindowButtonDownFcn=@input_line;

fig.WindowButtonUpFcn=@plot_line;


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
        [x_true,y_true]=choose_data_in_axis(fig,data_input);
        if length(x_true)>1
            fig.UserData.num_lines=fig.UserData.num_lines+1;
            line=scatter(fig.CurrentAxes,x_true,y_true,...
                linspace(500,1,length(x_true)),'o');
            line.Tag=['line_',num2str(fig.UserData.num_lines)];
        end
        fig.WindowButtonMotionFcn=@(~,~)[];
        fig.UserData.input=[];
    end
end