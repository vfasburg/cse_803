% CSE 803: Meal Recognition Project
% Authors: Vince Fasburg, Bonnie Reiff, Josh Thomas
% Filename: Compute_Texture_Energy.m

%% Compute_Texture_Energy: Helper function to the Perform_Texture_Analysis 
%        function. Computes the texture energy map for the specified image
%        and mask.
% Input : img, the double type r x c preprocessed grayscale image (2D matrix)
%         mask, 5x5 mask to be applied to the preprocessed image
% Output: energy_map, the r x c matrix of texture energy values for the 
%                     original image corresponding to the given mask
function [ energy_map ] = Compute_Texture_Energy( img, mask )

    %% Filter the image using the specified mask
    
    % Pad the edges with 2 extra rows/columns for the 5 x 5 mask
    % using the values on the image boundary
    padded_filter_img = img;
    top_row = padded_filter_img(1, :);
    bottom_row = padded_filter_img(end, :);
    padded_filter_img = [ top_row; top_row; padded_filter_img; bottom_row; bottom_row ];
    first_col = padded_filter_img(:, 1);
    last_col = padded_filter_img(:, end);
    padded_filter_img = [ first_col first_col padded_filter_img last_col last_col ];
    
    % Apply the mask to each 5 x 5 neighborhood
    F = img;
    for r = 1:size(img, 1)
        for c = 1:size(img, 2)
            for i = 1:5
                for j = 1:5
                    F(r, c) = F(r, c) + padded_filter_img(r + i - 1, c + j - 1) * mask(i, j);
                end
            end
        end
    end


    %% Compute the texture energy for each pixel in the image
    
    % Initialize window size variables
    window_size = 9.0; % Using a 9 x 9 window for each image
    half_size = floor(window_size / 2.0);
    % Pad the edges with extra rows/columns using the values on the
    % image boundary
    padded_energy_img = F;
    top_row = padded_energy_img(1, :);
    bottom_row = padded_energy_img(end, :);
    for i = 1:half_size
        padded_energy_img = [ top_row; padded_energy_img; bottom_row ];
    end
    first_col = padded_energy_img(:, 1);
    last_col = padded_energy_img(:, end);
    for i = 1:half_size
        padded_energy_img = [ first_col padded_energy_img last_col ];
    end
    
    % Sum the absolute value of the pixels in each neighborhood
    energy_map = F;
    for r = 1:size(F, 1)
        for c = 1:size(F, 2)
            energy = 0;
            for i = (r - half_size):(r + half_size)
                for j = (c - half_size):(c + half_size)
                    energy = energy + ...
                        abs(padded_energy_img(i + half_size, j + half_size));
                end
            end
            energy_map(r, c) = energy;
        end
    end
    
end

