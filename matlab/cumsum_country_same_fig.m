function cumsum_country_same_fig(days_jump,dates,cases)
%The function plots the cumulative sum of cases for specific country

cumsum_cases_country=cumsum(cases,'reverse');
plot(datenum(datetime(dates(1:days_jump:end))),...
    cumsum_cases_country(1:days_jump:end));
%flip the array for sorting it in ascending order
grid on
end

