function [rho, dlnet, prob] = TOuNN(nelx, nely, nelz, volfrac, displayflag, filename)
arguments
    nelx double
    nely double
    nelz double
    volfrac double
    displayflag logical = false
    filename string = "untitled.gif"
end
plots = "training-progress";
% Problem Setup
[prob, F, freedofs, KE, iK, jK, edofMat]=problem_def(nelx, nely,...
    nelz,volfrac, 0.3, 2, 1500);
dlnet=NN_init(prob);
xyz = location_sampling(prob, 1, 1); % eleSize=1, resolution=1

if plots == "training-progress"
    figure(1); clf; xlabel("Iteration");grid on;
    yyaxis left; ylim([0 inf]); ylabel("Objective")
    lineLossTrain = animatedline('Color','b');
    yyaxis right; ylim([0 1]); ylabel("Volume")
    lineVol = animatedline('Color','r');
end

init_rho = ones(nely,nelx,nelz);
if displayflag
    h = figure(2);
    h.Position = [0, 270, 1280, 720];
    clf
    viewDesign(init_rho, 0.25)
    arrow([nelx,-nelz/2,0],[nelx,-nelz/2,-3])
    drawnow
    pause(2)
    for di=1:5
        frame = getframe(h);
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        if di == 1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
    end
end

averageGrad = [];
averageSqGrad = [];
learnRate = 0.001;
gradientThresholdMethod = "l2norm";
gradientThreshold = 0.001;
loop = 0;
prob.alpha = 5;
alphaMax = 100*volfrac;
relGreyElements = 1;
executionEnvironment = "auto";
start=tic;
% START ITERATION
while loop < prob.maxiter && relGreyElements > 0.02
    loop = loop+1;
    % Continuation Scheme
    if mod(loop,10)==0
        prob.alpha = min(alphaMax, prob.alpha+1);
    end
    if mod(loop,10)==0
        prob.penal = min(5,prob.penal+0.02);
    end
    if (executionEnvironment == "auto" && canUseGPU) ||...
            executionEnvironment == "gpu"
        xyz = gpuArray(xyz);
    end
    [prob, Loss, volcon, gradients, obj, rho] = dlfeval(@modelgradients,...
        dlnet, xyz, prob, freedofs, F, KE, iK, jK, edofMat, loop);
    switch gradientThresholdMethod
        case "global-l2norm"
            gradients = thresholdGlobalL2Norm(gradients, gradientThreshold);
        case "l2norm"
            gradients = dlupdate(@(g) thresholdL2Norm(g, gradientThreshold),gradients);
        case "absolute-value"
            gradients = dlupdate(@(g) thresholdAbsoluteValue(g, gradientThreshold),gradients);
    end
    [dlnet,averageGrad,averageSqGrad] = adamupdate(dlnet,gradients,...
        averageGrad,averageSqGrad,loop,learnRate);
    if prob.ndr==true
        [ii,jj,kk]=meshgrid(1:prob.nely,2:prob.nelx-1,1:prob.nelz);
        ind=sub2ind([prob.nely, prob.nelx, prob.nelz], ii(:), jj(:), kk(:));
        dr_rho=rho(ind);
    else
        dr_rho=rho;
    end
    greyElements = sum(and(dr_rho>0.1,dr_rho<0.9),'all');
    relGreyElements = volfrac*greyElements/prob.nele;
    % PRINT RESULTS
    if mod(loop,10)==0 || loop<=20
        fprintf(' Iter.:%5i Obj.:%11.4f Vol.:%7.3f\n relG.:%7.3f Loss.:%7.3f volcon.:%7.3f\n\n',loop,obj,mean(dr_rho(:)),relGreyElements,Loss,volcon);
    end
    % PLOT DENSITIES
    if plots == "training-progress"
        D = duration(0,0,toc(start),'Format','hh:mm:ss');
        figure(1)
        title("Iteration(Epoch): " + loop + ", Elapsed: " + string(D))
        yyaxis left
        addpoints(lineLossTrain,loop,double(gather(extractdata(obj))))
        yyaxis right
        addpoints(lineVol,loop,mean(dr_rho(:)))
        title("Iteration(Epoch): " + loop + ", Elapsed: " + string(D))
        drawnow
    end
    if displayflag && mod(loop,10)==0
        figure(2)
        clf
        viewDesign(rho, 0.1+(0.65*loop/prob.maxiter))
        arrow([nelx,-nelz/2,0],[nelx,-nelz/2,-3])
        drawnow
        frame = getframe(h);
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256);
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
if prob.ndr==true
    [i,j,k]=meshgrid(1:prob.nely,[1,prob.nelx],1:prob.nelz);
    ind=sub2ind([prob.nely, prob.nelx, prob.nelz], i(:), j(:), k(:));
    r=predict(dlnet,xyz);
    r(ind)=1;
    rho=reshape(double(extractdata(r)),prob.nely,prob.nelx,prob.nelz);
end
figure(2);clf; viewDesign(rho, 0.75);drawnow
if displayflag
    for di=1:5
        frame = getframe(h);
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
end