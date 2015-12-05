% takes struct of all training data samples,
% returns struct of all labels and their means & std devs for each feature
function classStats = get_class_data(sampleData)
    %build std devs for each feature of each class
    classData = struct();
    for sample = 1:length(sampleData) %for each sample
        if(isempty(sampleData(sample).labels))
            continue;
        end
        field = sampleData(sample).labels{1};
        if(isfield(classData, field))
            classData.(field) = [classData.(field); sampleData(sample).features];
        else
            classData.(field) = sampleData(sample).features;
        end
    end
    classData.('frenchfry') = classData.('fries');
    classData = rmfield(classData, 'fries');
    classes = fieldnames(classData);
    classStats = struct();
    featureMax = -inf*ones(size(sampleData(sample).features));
    %featureMin =  inf*ones(size(sampleData(sample).features));
    for idx = 1:length(classes)
        curData = classData.(classes{idx});
        classStats.(classes{idx}).('means') = mean(curData);
        classStats.(classes{idx}).('devs') = std(curData);
        maxCurData = max(curData);
        featureMax(maxCurData>featureMax) = maxCurData(maxCurData>featureMax);
    end
    classStats.('featureMax') = featureMax;
end