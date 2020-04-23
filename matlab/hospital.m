load hospital
%%
% Plot scatter of weight as function of age, color by sex and size by smoking
clc
index_smokers=50*findgroups(hospital.Smoker);
scatter(hospital.Age,hospital.Weight,index_smokers,hospital.Sex);
grid on
xlabel('age')
ylabel('weight')
title('scatter of weight as function of age, color by sex and size by smoking')

%%
%Plot a normal distribution fit of the left column of the blood pressure.
clc
close all
fig_blood=figure;
blood_pressure=hospital.BloodPressure(:,1);
plot_normal_distribution_fit(blood_pressure,'general people',[0.5 .1 .3 .3]);

%normal distribution fit of the left column of the blood pressure only for non smokers
blood_pressure_non_smokers=blood_pressure(~hospital.Smoker);
plot_normal_distribution_fit(blood_pressure_non_smokers,'non smokers',[.2 .5 .3 .3]);
legend('location','best')
title('normal distribution fit of the left column of the blood pressure')
xlabel('left column of the blood pressure')

%%
% Count all the last names who contains ES
clc
close all
disp(['num of last names who contains ES: ',num2str(sum(contains(hospital.LastName,'ES')))]);
% Plot histogram of last names lengths
histogram(cellfun(@length,hospital.LastName))
xlabel('last name length')
title('histogram of last name lengths')
grid on
%%
%Count all the last names that ends with S
clc
close all
ends_with_s=num2str(sum(endsWith(hospital.LastName,'S')));
disp(['num of last names who ends with S: ',ends_with_s]);
%%
%Replace the first letter by the next alphabetic letter for each last name.
clc
close all

cellfun(@(word){char(word+[1,zeros(1,length(word)-1)])},hospital.LastName)


