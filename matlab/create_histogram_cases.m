function create_histogram_cases(cases_number,bins_width,upper_bound_cases)

%input:
% cases_number: The number of cases in each day in each region.
% bin_width jump for histogram bins plot
% upper_bound_cases: maximal number of cases is presented, beyond that the
% value is ignored.

% output:
% save histogram of cases with bin_width jump where the values beyond
% upper_bound_cases are ignored.

cases_smaller_bound=cases_number(cases_number<=upper_bound_cases);
figure
histogram(cases_smaller_bound,0:bins_width:upper_bound_cases)
xlabel('number of cases in regions')
ylabel('frequency')
grid on
title(['frequency of cases, where discarded beyond ',...
    num2str(upper_bound_cases),', bins width:',num2str(bins_width)])
end