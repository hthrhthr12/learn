function [R_hat,P_hat_inv]=linear_est_WLS(fig,D_0,t,const,measurement_noise,F)
% we estimate linearly around the middle point of the axes

R_0=fig.UserData.R_0;
% pay attention that: H_1*M=-diff(M) for all M matrix
M=fig.UserData.num_platforms;
H_1=diag(ones(M-1,1))-diag(ones(M-2,1),1);
H_1=[H_1,zeros(M-1,1)];
H_1(end)=-1;
HH_inv=inv(H_1*H_1.'); 
% can be computed by svd
% [u,s,~]=svd(H_1,'econ');
% HH_inv=u*diag(diag(s).^-2)*u';

% we assume for simplicity that the noise matrix is diagonal
% and the platforms receive in each snapshot.


N=fig.UserData.num_samples;
M=fig.UserData.num_platforms;
M_array=(0:M-1)*N;


t=t+...
    measurement_noise*randn(M*N,1);
t_term=0;
p_error=0;
for k=1:fig.UserData.num_samples
    % check algorithm
    H_1_F=-diff(F(M_array+k,:));
    A=H_1_F.'*HH_inv;
    
    p_error=p_error+(A*H_1_F);
    t_term=t_term-A*diff(t(M_array+k,:)-D_0(M_array+k,:)/const);
    
end

R_hat=R_0.'+const*(p_error\t_term);
P_hat_inv=(const^-2)*p_error/measurement_noise^2;
end