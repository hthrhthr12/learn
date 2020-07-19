function CEP= CEP_finding_Torrieri(l1,l2)
% finding CEP true 
gamma_s=l2./l1;
CEP=fsolve(@(c)(1+gamma_s)./(4*gamma_s)-...
    integral(@(x)exp(-x).*besseli(0,x.*(1-gamma_s)./(1+gamma_s))...
    ,0,c.^2*(1+gamma_s)/(4*l2)),1);
end

