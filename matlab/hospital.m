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
