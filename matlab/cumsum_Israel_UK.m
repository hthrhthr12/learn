function cumsum_Israel_UK(jump,covid_table)
% cumulative sum cases Israel vs Britain(UK: United Kingdom)
% where jump equal to jump days.
countries={'Israel','United_Kingdom'};
% where_country contains a logical array for the countries indices in
% covid_table
where_country=ismember(covid_table.countriesAndTerritories,countries);
% date and cases of Israel and UK
dates_cases_country=covid_table(where_country,[1,5,11]);
group_country=findgroups(dates_cases_country.countriesAndTerritories);
ax=splitapply(@(a,b,c,d)cumsum_country(jump,a,b,c,d),dates_cases_country,...
    group_country,group_country);
%link axes for causing zoom affect on both
linkaxes(ax,'x');
saveas(gcf,['figures/cumsum_of_cases_jump_',num2str(jump),'_days.png'])
close all
end

