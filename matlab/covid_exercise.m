clc
clear variables
covid_table = readtable("COVID-19-geographic-disbtribution-worldwide.xlsx");

%% 1c-1g)
cases_number=covid_table.cases;
% create histogram with bins_width=100, for cases_number<=1e3
save_histogram_cases(cases_number,100,1e3);
% create histogram with bins_width=5, for cases_number<=1e2
save_histogram_cases(cases_number,5,1e2);
% create histogram with bins_width=25, for cases_number<=1e3
save_histogram_cases(cases_number,25,1e3);

% ECDF: empirical cumulative distribution function
% ECDF cases Israel vs Britain(UK: United Kingdom)
% where jump equal to 10 days.

countries={'Israel','United_Kingdom'};
days_jump=10;
for country_index=1:length(countries)
    % where_country contains a logical array for the country indices in
    % covid_table
    where_country=strcmp...
        (covid_table.countriesAndTerritories,countries{country_index});
    % create ceil of date and cases in country
    date_cases_country=covid_table(where_country,[1,5]);
    ECDF_cases_country=cumsum(date_cases_country.cases,'reverse');
    subplot(2,1,country_index)
    plot(date_cases_country.dateRep(1:days_jump:end),...
        ECDF_cases_country(1:days_jump:end),...
        '--o','DatetimeTickFormat','dd-M-yy')
    country_name=strrep(countries{country_index},'_',' ');
    title(['ECDF of num cases for ',country_name,', total: ',num2str(ECDF_cases_country(1))])
    disp(['total number of cases in ',country_name, ' is :',...
        num2str(ECDF_cases_country(1))])
end
saveas(gcf,'figures/ECDF_of_cases.png')
close all

%% 1h-1i)
%Boxplot represents the validity of results. It displays the spread of 
% data around its mean.
% Boxplot num cases for country for day
boxplot(covid_table.cases)
title('spread of num of cases per country per day')
saveas(gcf,'figures/boxplot_num_cases.png')

