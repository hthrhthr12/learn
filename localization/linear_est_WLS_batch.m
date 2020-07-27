function [R_hat,P_hat_inv]=linear_est_WLS_batch(fig,D_0,t,const,F,total_noise)
% we estimate linearly around the middle point of the axes

R_0=fig.UserData.R_0;
% pay attention that: H_1*M=-diff(M) for all M matrix
M=fig.UserData.num_platforms;
H_1=diag(ones(M-1,1))-diag(ones(M-2,1),1);
H_1=[H_1,zeros(M-1,1)];
H_1(end)=-1;
scalar_noise=isscalar(total_noise);
I=eye(M-1,M-1);
H_1_T=H_1.';

if scalar_noise
    HH_inv=(H_1*H_1_T)\I;
end
% can be computed by svd
% [u,s,~]=svd(H_1,'econ');
% HH_inv=u*diag(diag(s).^-2)*u';

% we assume for simplicity that the noise matrix is diagonal
% and the platforms receive in each snapshot.


N=length(t)/M;
M_array=(0:M-1)*N;


t_term=0;
p_error=0;
for k=1:N
    % check algorithm
    H_1_F=-diff(F(M_array+k,:));
    if scalar_noise
        A=H_1_F.'*HH_inv;
    else
        A=H_1_F.'*(((H_1.*total_noise(M_array+k,:).')*H_1_T)\I);
    end
    
    p_error=p_error+(A*H_1_F);
    t_term=t_term-A*diff(t(M_array+k,:)-D_0(M_array+k,:)/const);    
end
disp(p_error)

R_hat=R_0.'+const*(p_error\t_term);
disp(R_hat)
P_hat_inv=(const^-2)*p_error;
if scalar_noise
    %divide only in the end
    P_hat_inv=P_hat_inv/total_noise;
end
end