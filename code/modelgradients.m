function [prob, Loss, volcon, grad, obj, RHO] = modelgradients(dlnet, xyz, prob, freedofs, F, KE, iK, jK, edofMat, loop)
    rho = forward(dlnet,xyz);    
    if loop==1
        rho = (rho./rho)*prob.volfrac;
    end
    if prob.ndr==true
        [i,j,k]=meshgrid(1:prob.nely,[1,prob.nelx],1:prob.nelz);
        ind=sub2ind([prob.nely, prob.nelx, prob.nelz], i(:), j(:), k(:));
        rho(ind)=1;
    end
    r=gather(rho);
    RHO=reshape(double(extractdata(r)),prob.nely,prob.nelx,prob.nelz);
    [U, K]=FEA_solve(prob, freedofs, F, KE, iK, jK, RHO);
    [prob, Loss, volcon, obj]=objectiveFunction(prob, U, K, KE, edofMat, rho, loop);
    grad = dlgradient(Loss+volcon,dlnet.Learnables,'RetainData',true);
end