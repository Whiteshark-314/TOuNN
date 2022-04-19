function [prob, F, freedofs, KE, iK, jK, edofMat]=problem_def(nelx, nely, nelz, volfrac, nu, penal0, maxiter)
    prob = problem_init(nelx, nely, nelz, volfrac, nu, penal0, 1.5, maxiter);
    if prob.nelz ==1
        prob.dimension='2D';
    else
        prob.dimension='3D';
    end
%     prob.symm_x=true;
%     prob.symm_y=true;
    prob.symm_z=true;
    prob.type='minC';
    prob.ndr=false;
    if isequal(prob.type,'CM')
        [prob, F] = prob_loads(prob, {prob.nelx; prob.nelx; prob.nelx}, {prob.nely/2+1; prob.nely/2+1; prob.nely/2+1}, {prob.nelz/2+1; prob.nelz/2+1; prob.nelz/2+1}, [1,0,0;0,-1,0;0,0,1]);
    elseif isequal(prob.type,'minC')
        [prob, F] = prob_loads(prob, {prob.nelx}, {0}, {0:prob.nelz}, [0,-1,0]);
    end
    if isequal(prob.type,'CM')
        [prob, freedofs] = prob_bcs(prob, {[0]}, {[0:prob.nely]}, {[0:prob.nelz]});
    elseif isequal(prob.type,'minC')
        [prob, freedofs] = prob_bcs(prob, {[0]}, {[0:prob.nely]}, {[0:prob.nelz]});
    end
    prob.dloc = locationdof(prob, [nelx/2], nely, [0:nelz], [1,0,0]);
    [KE, iK, jK, edofMat] = KE_H8(prob);
    if isequal(prob.type,'CM')
        KE(din,din)=KE(din,din)+0.1;
        KE(dout,dout)=KE(dout,dout)+0.1;
    end
end