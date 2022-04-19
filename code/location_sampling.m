function xyz = location_sampling(prob, eleSize, resolution)
    eS_R=eleSize/resolution;
    if isequal(prob.dimension,'2D')
        if prob.symm_x
            val_vectors{2,1}=[0.5*eS_R:eS_R:prob.nelx/2-0.5*eS_R, prob.nelx/2-0.5*eS_R:-eS_R:0.5*eS_R];
        else
            val_vectors{2,1}=[0.5*eS_R:eS_R:prob.nelx-0.5*eS_R];
        end
        if prob.symm_y
            val_vectors{1,1}=[0.5*eS_R:eS_R:prob.nely/2-0.5*eS_R, prob.nely/2-0.5*eS_R:-eS_R:0.5*eS_R];
        else
            val_vectors{1,1}=[0.5*eS_R:eS_R:prob.nely-0.5*eS_R];
        end
        val_vectors{3,1}=repmat(0.5,1,prob.nelz);
        
    elseif isequal(prob.dimension,'3D')
        if prob.symm_x
            val_vectors{2,1}=[0.5*eS_R:eS_R:prob.nelx/2-0.5*eS_R, prob.nelx/2-0.5*eS_R:-eS_R:0.5*eS_R];
        else
            val_vectors{2,1}=[0.5*eS_R:eS_R:prob.nelx-0.5*eS_R];
        end
        if prob.symm_y
            val_vectors{1,1}=[0.5*eS_R:eS_R:prob.nely/2-0.5*eS_R, prob.nely/2-0.5*eS_R:-eS_R:0.5*eS_R];
        else
            val_vectors{1,1}=[0.5*eS_R:eS_R:prob.nely-0.5*eS_R];
        end
        if prob.symm_z
            val_vectors{3,1}=[0.5*eS_R:eS_R:prob.nelz/2-0.5*eS_R, prob.nelz/2-0.5*eS_R:-eS_R:0.5*eS_R];
        else
            val_vectors{3,1}=[0.5*eS_R:eS_R:prob.nelz-0.5*eS_R];
        end
%         val_vectors={0.5*eS_R:eS_R:prob.nely-0.5*eS_R;...
%                      0.5*eS_R:eS_R:prob.nelx-0.5*eS_R;...
%                      0.5*eS_R:eS_R:prob.nelz-0.5*eS_R};
    end
    xyz=dlarray(single(flip(getcondvects_n_k([prob.nely; prob.nelx; prob.nelz], 3, val_vectors),2)),'BC');
end