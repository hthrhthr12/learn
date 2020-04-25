clc
clear variables
covid_table = readtable("COVID-19-geographic-disbtribution-worldwide.xlsx");

%% 1c-1e)
cases_number=covid_table.cases;
% create histogram with bins_width=100, for cases_number<=1e3
create_histogram_cases(cases_number,100,1e3);
% create histogram with bins_width=5, for cases_number<=1e2
create_histogram_cases(cases_number,5,1e2);
% create histogram with bins_width=25, for cases_number<=1e3
create_histogram_cases(cases_number,25,1e3);
close all

%% 1f-1h)
% cumulative sum cases Israel vs Britain(UK: United Kingdom)
% where jump equal to 10/1 days.
countries={'Israel','United_Kingdom'};
arrayfun(@(jump)cumsum_countries(jump,covid_table,countries),[1,10])
close all

%% ECDF
% ECDF: empirical cumulative distribution function
%compute histogram based on ecdf
[ecdf_values,x]=ecdf(covid_table.cases);
plot(x,ecdf_values)
xlabel('cases')
title('ECDF of cases')
grid on
close all

%% 1i-1j)
%Boxplot represents the validity of results. It displays the spread of
% data around its median.
% Boxplot num cases for country for day
cases_non_zero=covid_table.cases(covid_table.cases>0);
boxplot(cases_non_zero)
title('spread of num of cases per country per day without zero cases')
xticks([])
grid on
close all

%% 1k) first part
% extract the columns: cases, deaths
cases_deaths=covid_table(:,{'cases','deaths'});
[group_country,countries]=findgroups(covid_table.countriesAndTerritories);
% apply mean_cases_mean_deaths function to each country:
means_differences=splitapply(@mean_cases_mean_deaths,cases_deaths.cases,...
    cases_deaths.deaths,group_country);
% means_differences is a cell, where in each cell we have array of mean
% differences.
countries_indices=cellfun(@repmat_array_len_list_times...
    ,means_differences,num2cell((1:length(countries)).'));
boxplot(cell2mat(means_differences),cell2mat(countries_indices));
xlabel('countries')
ylabel('mean(Cases) - mean(deaths)')
title('countries are columns, measurement: 10 days')
% you can replace the ticks to countries:
% xticklabels(countries)
grid on

%% 1k) second part
figure
date_num=datenum(covid_table.dateRep);
%split data to groups of 10 days each:
[group_10_days,days]=findgroups...
    (arrayfun(@(x)floor(x/10),date_num-min(date_num)));

% apply mean_cases_mean_deaths function to each 10 days:
means_differences=splitapply(@mean_cases_mean_deaths_divide_by_country,...
    cases_deaths,group_country,group_10_days);
% means_differences is a cell, where in each cell we have array of mean
% differences.
ten_days_indices=cell2mat(cellfun(@repmat_array_len_list_times,means_differences,num2cell(days)));
boxplot(cell2mat(means_differences),ten_days_indices);
xlabel('10 days groups')
ylabel('mean(Cases) - mean(deaths)')
title('10 days groups are columns, measurements: countries')
x_ticks_dates=datestr(datetime(10*unique(ten_days_indices)+...
    min(date_num),'ConvertFrom','datenum'),'dd-mm');
xticklabels(x_ticks_dates)
grid on
close all

%% 1l)
%Boxplot of sum of cases in all countries.
% Each column represents a month, and the measurements in each column are
% the total number of cases in the days of the month.
% I.e. at most there are 31 days in a month,
% thus it is the maximal number of points in a column.
day_cases=covid_table(:,{'day','cases'});
%sum over cases for each day separately
sum_for_each_day=@(days,cases){splitapply(@sum,cases,findgroups(days))};
[month_indices,months]=findgroups(covid_table.month);
% apply sum_for_each_day function to each month:
sum_cases=splitapply(sum_for_each_day,...
    day_cases,month_indices);
% sum_cases is a cell, where in each cell we have an array of total
% cases in a day
month_table_indices=cell2mat(cellfun(@repmat_array_len_list_times,...
    sum_cases,num2cell(months)));
year_table_indices=changem(month_table_indices,covid_table.year,covid_table.month);
boxplot(cell2mat(sum_cases),datetime(year_table_indices,month_table_indices,15));
xlabel('month')
ylabel('mean(new cases in a day)')
title('mean(new cases in a day) for the whole world')
months=flipud(unique(covid_table.month,'stable'));
year_for_month=changem(months,covid_table.year,covid_table.month);
x_ticks_dates=datestr(datetime(year_for_month,months,15),'mmmm-yy');
xticklabels(cellstr(x_ticks_dates))
grid on
close all
%% 1m)
% Plot cumulative sum of cases in country with specific jump,
% which is determined by the user.
% input:
jump_days=str2double(inputdlg('What is the jump for displaying the cumsum?'));
%%
% apply the function to each country separately:
clc
date_axis=datenum(datetime(year_table_indices,month_table_indices,15));
boxplot(cell2mat(sum_cases),date_axis,'Positions',unique(date_axis));

hold on
splitapply(@(a,b)cumsum_country_same_fig(jump_days,a,b),...
    covid_table(:,{'dateRep','cases'}),group_country);
hold off
xticklabels(cellstr(x_ticks_dates))
title(['cases cumsum in countries vs world cases boxplot, jump:',num2str(jump_days)])
xlabel('cases')
ylabel('date')
grid on
close all
%% 1n)
%total_cases in dates in [date_string-tolerance,date_string+tolerance]
% country with min deaths in those days
% country with max cases in those days
% Date with maximal cases
[total_cases,country_min_deaths,country_max_cases,...
    date_maximal_cases,mean_cases_for_each_country]...
    = cases_date('11 April 2020',2,covid_table);

%% 1o)
% optional input: min_cases, max_cases, num_cases,tolerance
% The function treats cases which are between the min and max values, and
% obeys that the distance to the num_cases is smaller than the tolerance.

%returns:
%total_cases in dates in [date_string-tolerance,date_string+tolerance]
% country with min deaths in those days
% country with max cases in those days
% Countries and their mean cases, which obey the conditions


% Example:
[total_cases,country_min_cases,country_max_cases,...
    mean_cases_for_each_country]= min_max_cases_optional_input(covid_table,'11 April 2020',2,'min_cases',11,'max_cases',11);

%% 1p)
% Israel
clc
close all
Israel_date_cases=covid_table(covid_table.countriesAndTerritories=="Israel",...
    {'dateRep','cases'});
plot(Israel_date_cases.dateRep,Israel_date_cases.cases)
grid on
ylabel('cases number')
title('number of cases in israel over time')


%graphs of mean and variance cases for windows_sizes
windows_sizes=[5,7,10];
functions_apply={@mean,@var};
cellfun(@(function_apply)plot_apply_different_windows...
    (function_apply,Israel_date_cases,windows_sizes),functions_apply)
%%
% Probability distributions
% Example
clc
close all
[KL_100_1000,KL_100_10000,KL_1000_1000]=Kullback_Liebler('Normal','mu',75,'sigma',10);


%% Hospital
% In hospital file

%% Mandelbrot_set
% In Mandelbrot_set file