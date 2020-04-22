function [total_cases,country_min_deaths,country_max_cases,...
    date_maximal_cases,mean_cases_for_each_country]...
    = min_max_cases_optional_input(date_string,tolerance,varargin)
% 1o):
% optional input: min_cases, max_cases, num_cases,
%total_cases in dates in [date_string-tolerance,date_string+tolerance]
% country with min deaths in those days
% country with max cases in those days
% Date with maximal cases
p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(p,'width',validScalarPosNum);
addOptional(p,'height',defaultHeight,validScalarPosNum);
addParameter(p,'units',defaultUnits,@isstring);
addParameter(p,'shape',defaultShape,...
    @(x) any(validatestring(x,expectedShapes)));
parse(p,width,varargin{:});

a = p.Results.width*p.Results.height;
end

