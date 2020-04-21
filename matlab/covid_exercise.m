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

%% 1k)
% extract the columns: cases, deaths
dates_cases_country=covid_table(:,[5,6]);
[group_country,countries]=findgroups(covid_table.countriesAndTerritories);
% apply mean_cases_mean_deaths function to each country:
means_differences=splitapply(@mean_cases_mean_deaths,dates_cases_country.cases,dates_cases_country.deaths,group_country);
% means_differences is a cell, where in each cell we have array of mean
% differences.
countries_indices=cellfun(@cell_length,means_differences,num2cell((1:length(countries)).'));
boxplot(cell2mat(means_differences),cell2mat(countries_indices));
xlabel('countries')
ylabel('mean(Cases) - mean(deaths)')
title('countries are columns, measurement: 10 days')
saveas(gcf,'figures/boxplot_per_country.png')
close all