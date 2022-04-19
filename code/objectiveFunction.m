function [prob, Loss, volcon, obj]=objectiveFunction(prob, Uls, K, KE, edofMat, rho, loop)
    if loop==1, prob.obj0=0; end
    obj = 0;
    if isequal(prob.type, 'minC')
        for i=1:prob.num_loads
        U=Uls(:,i);
            compliance = reshape(sum((U(edofMat)*KE).*U(edofMat),2),[prob.nely,prob.nelx,prob.nelz]);
            if loop==1
                prob.obj0=prob.obj0 + (1/prob.num_loads)*sum((prob.E_void+(rho.^(prob.penal))*(prob.E_solid-prob.E_void)).*compliance(:)','all');
            end
            obj = obj + (1/prob.num_loads)*sum((prob.E_void+(rho.^(prob.penal))*(prob.E_solid-prob.E_void)).*compliance(:)','all');
        end
        volcon = prob.alpha*(mean(rho,'all')/prob.volfrac -1)^2;
        Loss = -obj/prob.obj0;
    elseif isequal(prob.type, 'CM')
        %todo
    end
end