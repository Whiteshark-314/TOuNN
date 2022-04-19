function [dlnet,lgraph] = NN_init(prob)
    for i=4:15
        if numParams(i)>prob.nele
            n=i;
            break;
        end
    end
    layers = [
         featureInputLayer(3,"Name","elementCenterLocations")
         batchNormalizationLayer("Name","batchnorm0")
         fullyConnectedLayer(2^(n),"Name","fclayer1")
         batchNormalizationLayer("Name","batchnorm1")
         reluLayer("Name","relu1")
         fullyConnectedLayer(2^(n-1),"Name","fclayer2")
         batchNormalizationLayer("Name","batchnorm2")
         reluLayer("Name","relu2")
         fullyConnectedLayer(2^(n-2),"Name","fclayer3")
         batchNormalizationLayer("Name","batchnorm3")
         reluLayer("Name","relu3")
         fullyConnectedLayer(2^(n-3),"Name","fclayer4")
         batchNormalizationLayer("Name","batchnorm4")
         reluLayer("Name","relu4")
         fullyConnectedLayer(2^(n-4),"Name","fclayer5")
         batchNormalizationLayer("Name","batchnorm5")
         reluLayer("Name","relu5")
         fullyConnectedLayer(1,"Name","fclayer6")
         sigmoidLayer("Name","sigmoid")];
    lgraph = layerGraph(layers);
    dlnet=dlnetwork(lgraph);
end