function [R_hat,P_hat_inv]=G_sums2est(G_sums)
% retrieve estimation from G_sums for 2D case
P_hat_inv=[G_sums(1),G_sums(3);G_sums(3),G_sums(2)];
det_P=det(P_hat_inv);

R_hat=[G_sums(5)*G_sums(3)-G_sums(2)*G_sums(4);...
    G_sums(4)*G_sums(3)-G_sums(1)*G_sums(5)]/det_P;
end