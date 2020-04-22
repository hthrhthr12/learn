function cumsum_countries(jump,covid_table,countries)
% cumulative sum cases of multiple countries
% where jump equal to jump days.

% indices_country contains a logical array for the countries indices in
% covid_table
indices_country=ismember(covid_table.countriesAndTerritories,countries);
% date and cases of countries
dates_cases_country=covid_table(indices_country,{'dateRep','cases','countriesAndTerritories'});

group_country=findgroups(dates_cases_country.countriesAndTerritories);
rows_subplot=floor(sqrt(length(countries)));
sub_plot_size=[rows_subplot+1,rows_subplot];
ax=splitapply(@(a,b,c,d)cumsum_country(jump,sub_plot_size,a,b,c,d),dates_cases_country,...
    group_country,group_country);
%link axes for causing zoom affect on both
linkaxes(ax,'x');
end

function ax=cumsum_country(days_jump,sub_plot_size,dates,cases,country,index_sub_plot)
% input:
% gets dates and cases for each country
% country : country name
% index_sub_plot: index for subplotting
% The function evaluates the cumsum of cases for specific country and
% displays it in subplot.


cumsum_cases_country=cumsum(cases,'reverse');
ax=subplot(sub_plot_size(1),sub_plot_size(2),index_sub_plot(1));
plot(dates(1:days_jump:end),...
    cumsum_cases_country(1:days_jump:end),...
    '--o','DatetimeTickFormat','dd-M');
%flip the array for sorting it in ascending order
xticks(flipud(dates(1:days_jump:end)))
country_name=strrep(country{1},'_',' ');
title(['cumsum: ',country_name,', where the jump=',...
    num2str(days_jump),' days, total: ',num2str(cumsum_cases_country(1))])
grid on
end