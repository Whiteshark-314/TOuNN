function [KE, iK, jK, edofMat] = KE_H8(prob)
    A = [32 6 -8 6 -6 4 3 -6 -10 3 -3 -3 -4 -8;
        -48 0 0 -24 24 0 0 0 12 -12 0 12 12 12];
    k = 1/144*A'*[1; prob.nu];

    K1 = [k(1) k(2) k(2) k(3) k(5) k(5);
        k(2) k(1) k(2) k(4) k(6) k(7);
        k(2) k(2) k(1) k(4) k(7) k(6);
        k(3) k(4) k(4) k(1) k(8) k(8);
        k(5) k(6) k(7) k(8) k(1) k(2);
        k(5) k(7) k(6) k(8) k(2) k(1)];
    K2 = [k(9)  k(8)  k(12) k(6)  k(4)  k(7);
        k(8)  k(9)  k(12) k(5)  k(3)  k(5);
        k(10) k(10) k(13) k(7)  k(4)  k(6);
        k(6)  k(5)  k(11) k(9)  k(2)  k(10);
        k(4)  k(3)  k(5)  k(2)  k(9)  k(12)
        k(11) k(4)  k(6)  k(12) k(10) k(13)];
    K3 = [k(6)  k(7)  k(4)  k(9)  k(12) k(8);
        k(7)  k(6)  k(4)  k(10) k(13) k(10);
        k(5)  k(5)  k(3)  k(8)  k(12) k(9);
        k(9)  k(10) k(2)  k(6)  k(11) k(5);
        k(12) k(13) k(10) k(11) k(6)  k(4);
        k(2)  k(12) k(9)  k(4)  k(5)  k(3)];
    K4 = [k(14) k(11) k(11) k(13) k(10) k(10);
        k(11) k(14) k(11) k(12) k(9)  k(8);
        k(11) k(11) k(14) k(12) k(8)  k(9);
        k(13) k(12) k(12) k(14) k(7)  k(7);
        k(10) k(9)  k(8)  k(7)  k(14) k(11);
        k(10) k(8)  k(9)  k(7)  k(11) k(14)];
    K5 = [k(1) k(2)  k(8)  k(3) k(5)  k(4);
        k(2) k(1)  k(8)  k(4) k(6)  k(11);
        k(8) k(8)  k(1)  k(5) k(11) k(6);
        k(3) k(4)  k(5)  k(1) k(8)  k(2);
        k(5) k(6)  k(11) k(8) k(1)  k(8);
        k(4) k(11) k(6)  k(2) k(8)  k(1)];
    K6 = [k(14) k(11) k(7)  k(13) k(10) k(12);
        k(11) k(14) k(7)  k(12) k(9)  k(2);
        k(7)  k(7)  k(14) k(10) k(2)  k(9);
        k(13) k(12) k(10) k(14) k(7)  k(11);
        k(10) k(9)  k(2)  k(7)  k(14) k(7);
        k(12) k(2)  k(9)  k(11) k(7)  k(14)];
    
    KE = 1/((prob.nu+1)*(1-2*prob.nu))*...
        [ K1  K2  K3  K4;
          K2' K5  K6  K3';
          K3' K6  K5' K2';
          K4  K3  K2  K1'];
    
    nodegrd = reshape(1:(prob.nely+1)*(prob.nelx+1),prob.nely+1,prob.nelx+1);
    nodeids = reshape(nodegrd(1:end-1,1:end-1),prob.nely*prob.nelx,1);
    nodeidz = 0:(prob.nely+1)*(prob.nelx+1):(prob.nelz-1)*(prob.nely+1)*(prob.nelx+1);
    nodeids = repmat(nodeids,size(nodeidz))+repmat(nodeidz,size(nodeids));
    edofVec = 3*nodeids(:)+1;
    edofMat = repmat(edofVec,1,24)+ ...
        repmat([0 1 2 3*prob.nely + [3 4 5 0 1 2] -3 -2 -1 3*(prob.nely+1)*(prob.nelx+1)+[0 1 2 3*prob.nely + [3 4 5 0 1 2] -3 -2 -1]],prob.nele,1);
    iK = reshape(kron(edofMat,ones(24,1))',24*24*prob.nele,1);
    jK = reshape(kron(edofMat,ones(1,24))',24*24*prob.nele,1);
end