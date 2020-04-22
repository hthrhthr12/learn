clc
clear variables
covid_table = readtable("COVID-19-geographic-disbtribution-worldwide.xlsx");

%% 1c-1e)
cases_number=covid_table.cases;
% create histogram with bins_width=100, for cases_number<=1e3
save_histogram_cases(cases_number,100,1e3);
% create histogram with bins_width=5, for cases_number<=1e2
save_histogram_cases(cases_number,5,1e2);
% create histogram with bins_width=25, for cases_number<=1e3
save_histogram_cases(cases_number,25,1e3);

%% 1f-1h)
% cumulative sum cases Israel vs Britain(UK: United Kingdom)
% where jump equal to 10/1 days.
arrayfun(@(jump)cumsum_Israel_UK(jump,covid_table),[1,10])

%% ECDF
% ECDF: empirical cumulative distribution function
%compute histogram based on ecdf
[ecdf_values,x]=ecdf(covid_table.cases);
plot(x,ecdf_values)
xlabel('cases')
title('ECDF of cases')
saveas(gcf,'figures/ECDF_of_cases.png')
close all

%% 1i-1j)
%Boxplot represents the validity of results. It displays the spread of 
% data around its median.
% Boxplot num cases for country for day
boxplot(covid_table.cases)
title('spread of num of cases per country per day')
saveas(gcf,'figures/boxplot_num_cases.png')

%% 1k) first part
% extract the columns: cases, deaths
cases_deaths=covid_table(:,[5,6]);
[group_country,countries]=findgroups(covid_table.countriesAndTerritories);
% apply mean_cases_mean_deaths function to each country:
means_differences=splitapply(@mean_cases_mean_deaths,cases_deaths.cases,cases_deaths.deaths,group_country);
% means_differences is a cell, where in each cell we have array of mean
% differences.
countries_indices=cellfun(@cell_length,means_differences,num2cell((1:length(countries)).'));
boxplot(cell2mat(means_differences),cell2mat(countries_indices));
xlabel('countries')
ylabel('mean(Cases) - mean(deaths)')
title('countries are columns, measurement: 10 days')
saveas(gcf,'figures/boxplot_per_country.png')
close all

%% 1k) second part
date_num=datenum(covid_table.dateRep);
%split data to groups of 10 days each:
[group_10_days,days]=findgroups...
    (arrayfun(@(x)floor(x/10),date_num-min(date_num)));

% apply mean_cases_mean_deaths function to each 10 days:
means_differences=splitapply(@mean_cases_mean_deaths_divide_by_country,...
    cases_deaths,group_country,group_10_days);
% means_differences is a cell, where in each cell we have array of mean
% differences.
ten_days_indices=cell2mat(cellfun(@cell_length,means_differences,num2cell(days)));
boxplot(cell2mat(means_differences),ten_days_indices);
xlabel('10 days groups')
ylabel('mean(Cases) - mean(deaths)')
title('10 days groups are columns, measurements: countries')
x_ticks_dates=datestr(datetime(10*unique(ten_days_indices)+...
    min(date_num),'ConvertFrom','datenum'),'dd-mm');
xticklabels(x_ticks_dates)
saveas(gcf,'figures/boxplot_per_10_days.png')
close all

