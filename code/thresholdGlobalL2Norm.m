function gradients = thresholdGlobalL2Norm(gradients,gradientThreshold)
    globalL2Norm = 0;
    for i = 1:numel(gradients.Value)
        globalL2Norm = globalL2Norm + sum(gradients.Value{i}(:).^2);
    end
    globalL2Norm = sqrt(globalL2Norm);

    if globalL2Norm > gradientThreshold
        normScale = gradientThreshold / globalL2Norm;
        for i = 1:numel(gradients.Value)
            gradients.Value{i} = gradients.Value{i} * normScale;
        end
    end
end