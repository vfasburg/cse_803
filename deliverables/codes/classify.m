% takes classStats (output from get_class_data), image, and the mask
% indicating the location of the food item in the full image
% returns best label to be attached to that image
function label = classify(classStats, img, mask)
    if sum(sum(mask)) < 0.1 * numel(mask)
        mask = ones(size(mask));
    end
    imgFeatures = get_features(img, mask);
    minWeightedDist = inf;
    label = '';
    weights = [(ones(1,64))/64 0.5 0.5]; % get_range_texture
    weights = weights./max(0.1,classStats.featureMax);
    classStats = rmfield(classStats, 'featureMax');
    classes = fieldnames(classStats);
    for idx = 1:length(classes)
        means = classStats.(classes{idx}).('means');
        devs = classStats.(classes{idx}).('devs');
        meanDiffs = abs(imgFeatures - means);
        scaledMeanDiffs = meanDiffs ./ max(0.5*ones(size(devs)),devs);
        weightedMeanDiffs = scaledMeanDiffs .* weights;
        dist = sqrt(sum(weightedMeanDiffs.^2));
        if(dist < minWeightedDist)
            minWeightedDist = dist;
            label = classes{idx};
            if ~isempty(strfind(label, 'apple'))
                label = 'apple';
            end
            if ~isempty(strfind(label, 'egg'))
                label = 'egg';
            end
        end
    end
end
