% CSE 803: Meal Recognition Project
% Authors: Vince Fasburg, Bonnie Reiff, Josh Thomas
% Filename: Perform_Texture_Analysis.m

%% Perform_Texture_Analysis: Performs all steps of computing Laws Texture 
%        Energy Measures including (1) creating the convolution masks, 
%        (2) preprocessing the image, (3) computing the full texture
%        energy map for each mask, and (4) summarizing the results in a 9D
%        feature vector for each image
% Input: image, an r x c x 3 matrix of pixel intensity values
%        mask, an r x c logical matrix indicating the food item
%              region in the image
% Output: texture_energy_measure_vector, a 1 x 9 vector containing the
%         value that occurred most often in each of the nine texture
%         energy features
function [ texture_energy_measure_vector ] = Perform_Texture_Analysis( image, mask )

%% Create the initial 5 texture masks
level  = [ 1 4 6 4 1 ];   % Center-weighted local average
edge   = [ -1 -2 0 2 1 ]; % Row or column step edge detector
spot   = [ -1 0 2 0 -1 ]; % Spot detector
ripple = [ 1 -4 6 -4 1 ]; % Ripple detector

%% Multiply each pair of texture masks to create 2D convolution masks and
%  store the masks in a matrix
convolution_masks = zeros(5, 5, 15);

convolution_masks(:,:,1) = level' * edge;     %L5E5
convolution_masks(:,:,2) = level' * spot;     %L5S5
convolution_masks(:,:,3) = level' * ripple;   %L5R5

convolution_masks(:,:,4) = edge' * level;     %E5L5
convolution_masks(:,:,5) = edge' * edge;      %E5E5
convolution_masks(:,:,6) = edge' * spot;      %E5S5
convolution_masks(:,:,7) = edge' * ripple;    %E5R5

convolution_masks(:,:,8)  = spot' * level;    %S5L5
convolution_masks(:,:,9)  = spot' * edge;     %S5E5
convolution_masks(:,:,10) = spot' * spot;     %S5S5
convolution_masks(:,:,11) = spot' * ripple;   %S5R5

convolution_masks(:,:,12) = ripple' * level;  %R5L5
convolution_masks(:,:,13) = ripple' * edge;   %R5E5
convolution_masks(:,:,14) = ripple' * spot;   %R5S5
convolution_masks(:,:,15) = ripple' * ripple; %R5R5

%% Perform image preprocessing to remove the effects of illumination
% Convert the image to grayscale (assumption that the input image is in
% color!)
image = rgb2gray(image);
% Initialize window size variables
window_size = 9.0; % Using a 9 x 9 window for each image
half_size = floor(window_size / 2.0);
% Pad the edges with extra rows/columns using the values on the 
% image boundary
padded_img = image;
top_row = padded_img(1, :);
bottom_row = padded_img(end, :);
for i = 1:half_size
    padded_img = [ top_row; padded_img; bottom_row ];
end
first_col = padded_img(:, 1);
last_col = padded_img(:, end);
for i = 1:half_size
    padded_img = [ first_col padded_img last_col ];
end
% Convert the padded_img matrix to uint32 values for correct processing
padded_img = uint32(padded_img);
% Subtract the local average from each pixel to create an image in which 
% average intensity of each neighborhood is near zero
preprocessed_img = double(image);
for r = 1:size(image, 1)
    for c = 1:size(image, 2)
        sum_neighborhood_pixels = 0;
        for i = (r - half_size):(r + half_size)
            for j = (c - half_size):(c + half_size)
                sum_neighborhood_pixels = ...
                    sum_neighborhood_pixels + padded_img(i + half_size, j + half_size);
            end
        end
        avg_neighborhood_pixels = double(sum_neighborhood_pixels) / (window_size * window_size);
        preprocessed_img(r,c) = double(image(r,c)) - avg_neighborhood_pixels;
    end
end

%% Apply each of the masks to the pre-processed image
%  Note: Storage may take an obnoxious amount of space depending on the 
%        size of the image
texture_energy_maps = zeros(size(image, 1), size(image, 2), 15);
for i = 1:15
    texture_energy_maps(:,:,i) = Compute_Texture_Energy(preprocessed_img, convolution_masks(:,:,i));
end

%% Output the 9-dimensional energy map feature vector
% [ L5E5/E5L5 L5S5/S5L5 L5R5/R5L5 E5E5 E5S5/S5E5 E5R5/R5E5 S5S5 S5R5/R5S5 R5R5]

% Average the symmetric pairs of masks
texture_energy_maps(:,:,1)  = (texture_energy_maps(:,:,1)  + texture_energy_maps(:,:,4))  / 2.0; % L5E5/E5L5
texture_energy_maps(:,:,2)  = (texture_energy_maps(:,:,2)  + texture_energy_maps(:,:,8))  / 2.0; % L5S5/S5L5
texture_energy_maps(:,:,3)  = (texture_energy_maps(:,:,3)  + texture_energy_maps(:,:,12)) / 2.0; % L5R5/R5L5
texture_energy_maps(:,:,6)  = (texture_energy_maps(:,:,6)  + texture_energy_maps(:,:,9))  / 2.0; % E5S5/S5E5
texture_energy_maps(:,:,7)  = (texture_energy_maps(:,:,7)  + texture_energy_maps(:,:,13)) / 2.0; % E5R5/R5E5
texture_energy_maps(:,:,11) = (texture_energy_maps(:,:,11) + texture_energy_maps(:,:,14)) / 2.0; % S5R5/R5S5
% Remove the unused masks from the set
texture_energy_maps(:,:,[4,8,12,9,13,14]) = [];

texture_energy_measure_vector = zeros(1, 9);
for i = 1:9
    current_TEM = texture_energy_maps(:,:,i);
    num_region_pixels = sum(sum(mask));
    region_intensity_sum = sum(sum(current_TEM(mask == 1)));
    % Use inentsity per region pixel as a feature
    texture_energy_measure_vector(i) = region_intensity_sum / num_region_pixels;
end

end
