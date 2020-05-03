function mean_differences = mean_cases_mean_deaths(cases,deaths)
% input:
% cases and deaths number for each day in specific country.
%
% output:
%ceil with entries contain mean(Cases) - mean(deaths) for each 10 days.
number_days=length(cases);
% we calculate the mean for each 10 days, thus we need to treat the case
% where the number of days does not divide by 10:
% simple solution:
% ignore last days: for e.g.
% cases=cases(floor(number_days/10))
% otherwise: we can apply mean to the last group even if has less days.
% divide the matrix to cells each contains at most 10 days.
% valid only for column vectors.
% pay attention that each country has different number of days.
divide_groups=[10*ones(1,floor(number_days/10)),mod(number_days,10)];
mean_cases= cellfun(@mean,mat2cell(cases,divide_groups));
mean_deaths= cellfun(@mean,mat2cell(deaths,divide_groups));
mean_differences ={mean_cases-mean_deaths};
end

