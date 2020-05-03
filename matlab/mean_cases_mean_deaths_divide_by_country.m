function mean_cases_mean_deaths = mean_cases_mean_deaths_divide_by_country...
    (cases,deaths,group_country)
% input:
% cases and deaths number for specific 10 day in all countries.
%
% output:
%ceil with entries for each country: contain mean(Cases) - mean(deaths)

mean_cases_mean_deaths ={splitapply(@(x,y)mean(x)-mean(y),...
    cases,deaths,findgroups(group_country))};
end


