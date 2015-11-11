% takes classStats (output from get_class_data), image, and the mask
% indicating the location of the food item in the full image
% returns best label to be attached to that image
function label = classify(classStats, img, mask)
    imgFeatures = get_features(img, mask);
    minWeightedDist = inf;
    label = '';
    classes = fieldnames(classStats);
    for idx = 1:length(classes)
        means = classStats.(classes{idx}).('means');
        devs = classStats.(classes{idx}).('devs');
        meanDiffs = abs(imgFeatures - means);
        scaledMeanDiffs = meanDiffs ./ max(0.1*ones(size(devs)),devs) ;
        dist = sqrt(sum(scaledMeanDiffs.^2));
        if(dist < minWeightedDist)
            minWeightedDist = dist;
            label = classes{idx};
        end
    end
end
