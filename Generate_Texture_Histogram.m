% CSE 803: Meal Recognition Project
% Authors: Vince Fasburg, Bonnie Reiff, Josh Thomas
% Filename: Generate_Texture_Histogram.m

%% Generate_Texture_Histograms: TODO
% Input: image, an r x c x 3 matrix of pixel intensity values
%        region_mask, an r x c logical matrix indicating the food item
%                     region in the image
%        in_option, TODO
% Output: TODO
function [counts] = Generate_Texture_Histogram( image, region_mask, in_option )

% Input Assumption: the background of the image has been blacked out
% (every pixel not part of food item has intensity == 0)

%% Convert the image to grayscale
grayscale_image = rgb2gray(image);

%% Compute the matrix of gradient magnitudes and directions
if (strcmp(in_option, 'grayscale'))
    % Apply the imgradient function to the image
    % (Default gradient operator: Sobel)
    % [gradient_mag, gradient_dir] = imgradient(grayscale_image);
    % [ gradient_dx gradient_dy ] = imGradient(grayscale_image, 'repeat');
    [ gradient_dx gradient_dy ] = imGradient(grayscale_image, 'reflect1');
elseif (strcmp(in_option, 'binary'))
    % Create the Canny edge image
    binary_image = edge(grayscale_image, 'Canny');
    % Apply the imgradient function to the image
    % (Default gradient operator: Sobel)
    % [gradient_mag, gradient_dir] = imgradient(binary_image);
    [ gradient_dx gradient_dy ] = imGradient(binary_image, 'repeat');
else
    fprintf('Error: Invalid option for gradient calculation!\n');
    return;
end

% Potential replacement for imgradient:
% https://github.com/gregfreeman/matlabPyrTools (need imGradient and helper
% functions found in this directory)
% Create the gradient_mag and gradient_dir matrices
gradient_mag = sqrt((gradient_dx .* gradient_dx) + (gradient_dy .* gradient_dy));
gradient_dir = atand((gradient_dy ./ gradient_dx));
gradient_dir(isnan(gradient_dir)) = 0;

%% Create the nornmalized histogram over gradient orientations 
% weighted by gradient magnitude

% Note: hist_x only matters for displaying the values in a histogram
hist_x = 0:45:360;
hist_x = hist_x(1:(end - 1)); % Eliminate the last bin
hist_x = hist_x + (45 / 2); % Shift the values so that they are bin centers

% Place every value in the appropriate bin and weight by the gradient magnitude
counts = zeros(size(hist_x));
for r = 1:size(gradient_dir, 1)
    for c = 1:size(gradient_dir, 2)
        if (region_mask(r,c) == 1) % Only perform these actions for the food item region
            % Shift the value to be in the correct range 
            % (imgradient returns [-180, 180] degrees
            if gradient_dir(r,c) < 0
                gradient_dir(r,c) = gradient_dir(r,c) + 360.0;
            end
            if (gradient_dir(r,c) == 360)
                gradient_dir(r,c) = 0;
            end
            counts_index = floor(gradient_dir(r,c) / 45) + 1;
            counts(counts_index) = counts(counts_index) + gradient_mag(r,c);
        end
    end
end

% Normalize the count values
total_counts = sum(counts);
counts = counts / total_counts;

% BEGIN DEBUG: view the histogram
% figure; bar(hist_x, counts);
% END DEBUG:

end