% class_stats is a struct with one field for each class label
% Each field contains sub-fields for means and standard deviations of each
%      feature
function [data_display] = visualize_training_data_results( class_stats )
    % Remove the field that is not a class label
    modified_class_stats = rmfield(class_stats, 'featureMax');
    classes = fieldnames(modified_class_stats);
    
    % Create the matrix in which the data should be stored
    data_display = [];
    
    for class = 1:length(classes)
        % Assumption: feature_means and feature_devs have the same length
        % and both are row vectors
        feature_means = class_stats.(classes{class}).('means');
        feature_devs = class_stats.(classes{class}).('devs');
        if ( size(feature_means,2) ~= size(feature_devs,2))
            fprintf('Error! The numbers of feature means and standard deviations reported do not match!');
            return;
        end
        
        % Creates a row vector displaying the mean and standard deviation
        % of each feature
        for feature = 1:size(feature_means, 2)
                data_display(class, (2 * feature - 1)) = feature_means(feature);
                data_display(class, (2 * feature)) = feature_devs(feature);
        end
    end
end