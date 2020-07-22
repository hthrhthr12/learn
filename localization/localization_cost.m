function cost=localization_cost(R_hat,P_hat_inv)
cost=norm(R_hat-fig.UserData.emitters_UTM(1,:))+1/det(P_hat_inv);
end