function dloc = locationdof(prob, x_loc, y_loc, z_loc, dir)
if ~((size(x_loc,1)==size(y_loc,1))&&(size(x_loc,1)==size(z_loc,1))&&(size(x_loc,1)==size(dir,1)))
    fprintf("All inputs should have same size in the first dimension\n")
else
    dofx=[];dofy=[];dofz=[];
    [i,j,k]=meshgrid(x_loc,y_loc,z_loc);
    nid=k*(prob.nelx+1)*(prob.nely+1)+i*(prob.nely+1)+prob.nely-j+1;
    if dir(1)~=0
        dofx = 3*nid(:) - 2;
    end
    if dir(2)~=0
        dofy = 3*nid(:) - 1;
    end
    if dir(3)~=0
        dofz = 3*nid(:);
    end
    dloc = sort([dofx; dofy; dofz]);
end
    