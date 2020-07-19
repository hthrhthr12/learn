clc
l1=1;
l2_values=1:10;
num_values=length(l2_values);
CEP_results=zeros(num_values,2);
for ind=1:num_values
    l2=l2_values(ind);
    CEP_result=CEP_finding_true(l1,l2);
    CEP_results(ind,1)=abs(CEP_result-CEP_finding_Torrieri(l1,l2));
    CEP_results(ind,2)=abs(CEP_result-CEP_finding_my(l1,l2));
end
close all
plot(CEP_results,'o--')
legend('Torrieri','my')
title('error between 71 equation to proposed 72')
ylabel('absolute error')
xticklabels(l2_values)
xlabel('\lambda_2')