function [prob, F] = prob_loads(prob, x_loc, y_loc, z_loc, val)
    prob.num_loads = size(x_loc,1);
    if ~((size(x_loc,1)==size(y_loc,1))&&(size(x_loc,1)==size(z_loc,1))&&(size(x_loc,1)==size(val,1)))
        fprintf("All inputs should have same size in the first dimension\n")
    else
        %prob.num_loads = size(x_loc,1);
        F = sparse(prob.ndof, prob.num_loads);
        for i=1:prob.num_loads
            [i_load,j_load,k_load] = meshgrid(x_loc{i}, y_loc{i}, z_loc{i});
            loadnid = k_load*(prob.nelx+1)*(prob.nely+1)+i_load*(prob.nely+1)+(prob.nely+1-j_load);
            loaddofx=[];loaddofy=[];loaddofz=[];
            if val(i,1)~=0
                loaddofx = 3*loadnid(:) - 2;
                F(loaddofx,i) = val(i,1);
            end
            if val(i,2)~=0
                loaddofy = 3*loadnid(:) - 1;
                F(loaddofy,i)= val(i,2);
            end
            if val(i,3)~=0
                loaddofz = 3*loadnid(:);
                F(loaddofz,i)= val(i,3);
            end
            if prob.num_loads==2 && isequal(prob.type,'CM')
                if i==1
                    prob.din = sort([loaddofx; loaddofy; loaddofz]);
                elseif i==2
                    prob.dout = sort([loaddofx; loaddofy; loaddofz]);
                end
            else
                prob.din=[];
                prob.dout=[];
            end
        end
    end
end