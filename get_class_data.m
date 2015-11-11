% takes struct of all training data samples,
% returns struct of all labels and their means & std devs for each feature
function classStats = get_class_data(sampleData)
    %build std devs for each feature of each class
    classData = struct();
    for sample = 1:length(sampleData) %for each sample
        field = sampleData(sample).labels{1};
        if(isfield(classData, field))
            classData.(field) = [classData.(field); sampleData(sample).features];
        else
            classData.(field) = sampleData(sample).features;
        end
    end
    
    classes = fieldnames(classData);
    classStats = struct();
    for idx = 1:length(classes)
        classStats.(classes{idx}).('means') = mean(classData.(classes{idx}));
        classStats.(classes{idx}).('devs') = std(classData.(classes{idx}));
    end
end