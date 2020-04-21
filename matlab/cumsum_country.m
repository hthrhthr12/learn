function ax=cumsum_country(days_jump,dates,cases,country,index_sub_plot)
% input:
% gets dates and cases for each country
% country : country name 
% index_sub_plot: index for subplotting
% The function evaluates the cumsum of cases for specific country and
% displays it in subplot.


cumsum_cases_country=cumsum(cases,'reverse');
ax=subplot(2,1,index_sub_plot(1));
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