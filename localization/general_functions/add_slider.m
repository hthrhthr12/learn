function [slider,position]=add_slider(fig,position,min_val,max_val,units_str,tag)
[slider,position]=add_ui(fig,position,'Slider');
slider.Value=(min_val+max_val)/2;
slider.Tag=tag;
slider.Min=min_val;
slider.Max=max_val;
slider.TooltipString=[tag,' ',num2str(slider.Value),units_str];
slider.KeyPressFcn=@(src,~)changeToolTip(src,tag,units_str);

end

function changeToolTip(src,tag,units_str)
set(src,'TooltipString',[tag,' ',num2str(src.Value),units_str])
% drawnow update does not help
end