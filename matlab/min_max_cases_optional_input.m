function [total_cases,country_min_cases,country_max_cases,...
    mean_cases_for_each_country]...
    = min_max_cases_optional_input(covid_table,date_string,tolerance,varargin)
% 1o):
% optional input: min_cases, max_cases, num_cases,tolerance
% The function treats cases which are between the min and max values, and
% obeys that the distance to the num_cases is smaller than the tolerance.

%returns:
%total_cases in dates in [date_string-tolerance,date_string+tolerance]
% country with min deaths in those days
% country with max cases in those days
% Date with maximal cases

%Examples:
% min_max_cases_optional_input(covid_table,'11 April 2020',2,'min_cases',11,'max_cases',11)
% min_max_cases_optional_input(covid_table,'11 April 2020',2,'min_cases',11)
%% retrieve optional input

non_negative=@(x)(x>=0); % assuming integer

p = inputParser;
addRequired(p,'covid_table',@istable);
addRequired(p,'date_string',@ischar);% assuming datetime format
addRequired(p,'tolerance',non_negative);
addParameter(p,'min_cases',-1,non_negative);
addParameter(p,'max_cases',Inf,non_negative);
addParameter(p,'num_cases',50,non_negative);
addParameter(p,'tolerance_cases',300,non_negative);
parse(p,covid_table,date_string,tolerance,varargin{:});
num_cases=p.Results.num_cases;
min_cases=p.Results.min_cases;
max_cases=p.Results.max_cases;
tolerance_cases=p.Results.tolerance_cases;
%% remove dates out of the region
date_input=datenum(date_string);
dates_table=datenum(covid_table.dateRep);
relevant_table=covid_table(abs(date_input-dates_table)<=tolerance,...
    {'dateRep','cases','deaths','countriesAndTerritories'});

%% check if empty
if isempty(relevant_table)
    total_cases=0;
    country_min_cases=0;
    country_max_cases=0;
    mean_cases_for_each_country=0;
    return
end
%% calculate statistics
total_cases=sum(relevant_table.cases);

[country_indices,countries]=findgroups(relevant_table.countriesAndTerritories);
cases_countries=splitapply(@sum,relevant_table.cases,country_indices);
[~,index_country]=min(cases_countries);
country_min_cases=countries(index_country);
[~,index_country]=max(cases_countries);
country_max_cases=countries(index_country);

%% remove ignorable data

bounds_cases=[max(num_cases-tolerance_cases,min_cases),...
    min(num_cases+tolerance_cases,max_cases)];
relevant_table=relevant_table(...
    bounds_cases(1)<relevant_table.cases<bounds_cases(2),:);
%% check if empty
if isempty(relevant_table)
    mean_cases_for_each_country=0;
    return
end

mean_cases_for_each_country=splitapply(@mean,relevant_table.cases...
    ,findgroups(relevant_table.countriesAndTerritories));
end