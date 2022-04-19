function [U, K]=FEA_solve(prob, freedofs, F, KE, iK, jK, rho)
    U = zeros(prob.ndof,prob.num_loads);
    sK = reshape(KE(:)*(prob.E_void+rho(:)'.^prob.penal*(prob.E_solid-prob.E_void)),24*24*prob.nele,1);
    K = sparse(iK,jK,sK); K = (K+K')/2;
    if isequal(prob.type,'CM')
        %K(prob.din,prob.din)=K(prob.din,prob.din)+0.1;
        K(prob.dout,prob.dout)=K(prob.dout,prob.dout)+1;
    end
    if prob.nele>200000
        M = diag(diag(K(freedofs,freedofs)));
        U(freedofs,:) = pcg(K(freedofs,freedofs),F(freedofs,:),1e-8,8000,M);
    else
        U(freedofs,:) = K(freedofs,freedofs)\F(freedofs,:);
    end
end