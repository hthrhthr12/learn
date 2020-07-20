function G_sums=retrieve_G_sums(R_hat,P_hat_inv)
% retrieve G sums from estimation for 2D case
G_sums=zeros(5,1);
G_sums(1)=P_hat_inv(1,1);
G_sums(2)=P_hat_inv(2,2);
G_sums(3)=P_hat_inv(1,2);

G_sums(4:5)=det(P_hat_inv)...
    *(([-G_sums(2),G_sums(3);G_sums(3),-G_sums(1)])\R_hat);
% pay attention that we need parantheses, since:
% c*A\b
% is different than
% c*(A\b)
end