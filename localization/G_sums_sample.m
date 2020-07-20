function xy=G_sums_sample(fig,G_sums,R_hat,num_samples)
%sample ellipse in polar coordinates by G_sums
d=fig.UserData.percentage_containment/100;
d=sqrt(-2*log(1-d));

% the angle is defined up to pi radians
theta=atan(2*G_sums(3)/(G_sums(1)-G_sums(2)))/2;

U_theta=[cos(theta),-sin(theta);sin(theta),cos(theta)];
phi=linspace(0,2*pi,num_samples);
if R_hat==0
    % retreive R_hat
    [R_hat,~]=G_sums2est(G_sums);
end

a=(G_sums(1)+G_sums(3)*tan(theta))^(-0.5);
b=(G_sums(2)-G_sums(3)*tan(theta))^(-0.5);

xy=d*U_theta*[a*cos(phi);b*sin(phi)]+R_hat;
%% check the matrix of eigen vectors
% pay attention that eigs return only part of eigen vectors
% [U,~]=eig([G_sums(1),G_sums(3);G_sums(3),G_sums(2)]);
% they are the same up to sign
% disp(U);
% disp(U_theta);


end