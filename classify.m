% takes classStats (output from get_class_data), and image
% returns best label to be attached to that image
function label = classify(classStats, img)
    imgFeatures = get_features(img);
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
