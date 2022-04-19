function prob = problem_init(nelx, nely, nelz, volfrac, poissons_ratio, penal, rmin, maxiter, type, symm_x, symm_y, symm_z)
    arguments
        nelx double
        nely double
        nelz double
        volfrac double
        poissons_ratio double = 0.3
        penal double = 2
        rmin double = 1.2
        maxiter double = 100
        type char = 'minC';
        symm_x logical = false
        symm_y logical = false
        symm_z logical = false
    end
    if nargin < 4
        fprintf("Not enough input parameters for initialization")
    else
        prob.nelx=nelx;
        prob.nely=nely;
        prob.nelz=nelz;
        prob.volfrac=volfrac;
        prob.dimension='3D';
        prob.nu=poissons_ratio;
        prob.ndof=3*(nelx+1)*(nely+1)*(nelz+1);
        prob.nele=nelx*nely*nelz;
        prob.penal=penal;
        prob.E_solid=1;
        prob.E_void=1e-9;
        prob.maxiter=maxiter;
        prob.type=type;
        prob.rmin=rmin;
        prob.symm_x=symm_x;
        prob.symm_y=symm_y;
        prob.symm_z=symm_z;
    end
end

