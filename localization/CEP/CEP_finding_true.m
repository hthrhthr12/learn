function CEP= CEP_finding_true(l1,l2)
% finding CEP true 
CEP=fsolve(@(c)sqrt(l1.*l2)/2-...
    integral(@(r)r.*exp(-r.^2*(1./(4*l1)+1./(4*l2))).*besseli(0,r.^2*(1./(4*l2)-1./(4*l1)))...
    ,0,c),1);
end

