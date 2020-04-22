function [total_cases,country_min_deaths,country_max_cases,...
    date_maximal_cases,mean_cases_for_each_country]...
    = cases_date(date_string,tolerance)
% 1n):
%total_cases in dates in [date_string-tolerance,date_string+tolerance]
% country with min deaths in those days
% country with max cases in those days
% Date with maximal cases

global covid_table
date_input=datenum(date_string);
dates_table=datenum(covid_table.dateRep);
relevant_table=covid_table(abs(date_input-dates_table)<=tolerance,[1,5,6,11]);

total_cases=sum(relevant_table.cases);

[country_indices,countries]=findgroups(relevant_table.countriesAndTerritories);
deaths_countries=splitapply(@sum,relevant_table.deaths,country_indices);
[~,index_country]=min(deaths_countries);
country_min_deaths=countries(index_country);

[~,index_country]=max(splitapply(@sum,relevant_table.cases,country_indices));
country_max_cases=countries(index_country);

[dates_indices,dates]=findgroups(relevant_table.dateRep);
[~,index_date]=max(splitapply(@sum,relevant_table.cases,dates_indices));
date_maximal_cases=dates(index_date);

mean_cases_for_each_country=splitapply(@mean,relevant_table.cases,country_indices);
end

