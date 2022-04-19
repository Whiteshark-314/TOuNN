function [prob, freedofs] = prob_bcs(prob, x_loc, y_loc, z_loc)
    if ~((size(x_loc,1)==size(y_loc,1))&&(size(x_loc,1)==size(z_loc,1)))
        fprintf("All inputs should have same size in the first dimension\n")
    else
        fixeddof=[];
        for i=1:size(x_loc,1)
            fixeddof_f=[];fixeddof_k=[];fixeddof_t=[];fixeddof_b=[];fixeddof_l=[];fixeddof_r=[];fixeddof_a=[];
            if isequal(x_loc{i},'front')
                [j_fixed,k_fixed] = meshgrid(y_loc{i}, z_loc{i});
                fixednid = k_fixed*(prob.nelx+1)*(prob.nely+1)+nelx*(nely+1)+(prob.nely+1-j_fixed);
                fixeddof_f = 3*fixednid(:)-2;
            elseif isequal(x_loc{i},'back')
                [j_fixed,k_fixed] = meshgrid(y_loc{i}, z_loc{i});
                fixednid = k_fixed*(prob.nelx+1)*(prob.nely+1)+(prob.nely+1-j_fixed);
                fixeddof_k = 3*fixednid(:)-2;
            elseif isequal(y_loc{i},'top')
                [i_fixed,k_fixed] = meshgrid(x_loc{i}, z_loc{i});
                fixednid = k_fixed*(prob.nelx+1)*(prob.nely+1)+i_fixed*(prob.nely+1)+1;
                fixeddof_t = 3*fixednid(:)-1;
            elseif isequal(y_loc{i},'bottom')
                [i_fixed,k_fixed] = meshgrid(x_loc{i}, z_loc{i});
                fixednid = k_fixed*(prob.nelx+1)*(prob.nely+1)+i_fixed*(prob.nely+1)+(prob.nely+1);
                fixeddof_b = 3*fixednid(:)-1;
            elseif isequal(z_loc{i},'left')
                [i_fixed,j_fixed] = meshgrid(x_loc{i}, y_loc{i});
                fixednid = prob.nelz*(prob.nelx+1)*(prob.nely+1)+i_fixed*(prob.nely+1)+(prob.nely+1-j_fixed);
                fixeddof_l = 3*fixednid(:);
            elseif isequal(z_loc{i},'right')
                [i_fixed,j_fixed] = meshgrid(x_loc{i}, y_loc{i});
                fixednid = i_fixed*(prob.nely+1)+(prob.nely+1-j_fixed);
                fixeddof_r = 3*fixednid(:);
            else
                [i_fixed,j_fixed,k_fixed] = meshgrid(x_loc{i}, y_loc{i}, z_loc{i});
                fixednid = k_fixed*(prob.nelx+1)*(prob.nely+1)+i_fixed*(prob.nely+1)+(prob.nely+1-j_fixed);
                fixeddof_a = [3*fixednid(:); 3*fixednid(:)-1; 3*fixednid(:)-2];
            end
            fixeddof=union(fixeddof,union(union(union(union(union(union(fixeddof_f,fixeddof_k),fixeddof_t),fixeddof_b),fixeddof_l),fixeddof_r),fixeddof_a));
        end
        freedofs = setdiff(1:prob.ndof,sort(fixeddof));
    end
end