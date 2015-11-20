% CSE 803: Meal Recognition Project
% Adapted from file created by: Lukas Tencer
% http://www.mathworks.com/matlabcentral/fileexchange/39951-law-s-texture-filter/content/laws.m
% Filename: get_laws_texture_energy.m

%% get_laws_texture_energy: Performs Laws Texture Energy Measures analysis
%       on the given image and computes a feature vector based on the 
%       output of the process
% Input: image, an r x c x 3 matrix of pixel intensity values
%        mask, an r x c logical matrix indicating the food item
%              region in the image
% Output: texture_energy_measure_vector, a 1 x 9 vector containing the
%         value that occurred most often in each of the nine texture
%         energy features
function [texture_energy_measure_vector] = get_laws_texture_energy( image, mask )

    %% Convert the image to grayscale
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    
    %% Define the textue vectors
    filters = {};
    filters{1} = [ 1 4 6 4 2 ];   % Level: center-weighted local average
    filters{2} = [ -1 -2 0 2 1 ]; % Edge: row or column step edge detector
    filters{3} = [ -1 0 2 0 -1 ]; % Spot detector
    filters{4} = [ 1 -4 6 -4 1 ]; % Ripple detector

    %% Preprocessing: smooth the image
    averageWindowSize = 9; % Using a 9 x 9 window for each image
    smooth_filt = ones(averageWindowSize, averageWindowSize) / (averageWindowSize ^ 2);
    image = imfilter(image, smooth_filt, 'conv', 'symmetric');
    
    %% Define the 2D covolution masks and apply them the grayscale image
    filtered2D = {};
    for i = 1:size(filters, 2)
        for j = 1:size(filters, 2)
            temp = filters{i}' * filters{j};
            filtered2D{end + 1} = imfilter(image, temp);
        end
    end
    
    %% Determine the 9 resulting image maps by averaging symmetric pairs
    % of masks
    mapz={};
    mapz{end + 1} = wfusmat(filtered2D{2}, filtered2D{5}, 'mean');   % L5E5/E5L5
    mapz{end + 1} = wfusmat(filtered2D{4}, filtered2D{13}, 'mean');  % L5R5/R5L5
    mapz{end + 1} = wfusmat(filtered2D{7}, filtered2D{10}, 'mean');  % E5S5/S5E5
    mapz{end + 1} = filtered2D{11};                                  % S5S5
    mapz{end + 1} = filtered2D{16};                                  % R5R5
    mapz{end + 1} = wfusmat(filtered2D{3}, filtered2D{9}, 'mean');   % L5S5/S5L5
    mapz{end + 1} = filtered2D{6};                                   % E5E5    
    mapz{end + 1} = wfusmat(filtered2D{8}, filtered2D{14}, 'mean');  % E5R5/R5E5
    mapz{end + 1} = wfusmat(filtered2D{12}, filtered2D{15}, 'mean'); % S5R5/R5S5
    
    % Use intensity per unit region pixel in the maps as the features
    texture_energy_measure_vector = zeros(1, 9);
    for i = 1:9
        current_TEM = mapz{i};
        num_region_pixels = sum(sum(mask));
        region_intensity_sum = sum(sum(current_TEM(mask == 1)));
        texture_energy_measure_vector(i) = region_intensity_sum / num_region_pixels;
    end

    texture_energy_measure_vector = [ texture_energy_measure_vector(7) texture_energy_measure_vector(6) texture_energy_measure_vector(2) ];
    
end

