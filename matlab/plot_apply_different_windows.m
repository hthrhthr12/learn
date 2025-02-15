function plot_apply_different_windows...
    (function_apply,table_date_cases,windows_sizes)
% plot function_apply results for different windows_sizes

figure
function_windows=@(window)plot_apply_to_group_days...
    (function_apply,table_date_cases,window);
arrayfun(function_windows,windows_sizes);
function_name=func2str(function_apply);
title([function_name,' cases in israel, different window'])
ylabel([function_name,' cases'])
end


function plot_apply_to_group_days...
    (function_apply,table_date_cases,window)
%apply a function to group of days and plot the result
date_num=datenum(table_date_cases.dateRep);
%split data to groups of window days each:
[group_window_days]=findgroups...
    (arrayfun(@(x)floor(x/window),date_num-min(date_num)));
fun_groups_results=splitapply(function_apply,...
    table_date_cases.cases,group_window_days);
x_values=datetime(window*unique(group_window_days)+...
    min(date_num),'ConvertFrom','datenum');
plot(x_values,fun_groups_results,'DisplayName',['window: ',num2str(window),' days'])
x_ticks_dates=datestr(datetime(window*unique(group_window_days)+...
    min(date_num),'ConvertFrom','datenum'),'dd-mm');
xticklabels(x_ticks_dates)
grid on
hold on
legend('Location','best');

end
