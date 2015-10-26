% CSE 803: Meal Recognition Project
% Authors: Vince Fasburg, Bonnie Reiff, Josh Thomas
% Filename: Compute_Texture_Energy.m

%% Compute_Texture_History:
% Input : img, the preprocessed grayscale image (2D matrix)
%         mask, 5x5 mask to be applied to the preprocessed image
% Output: energy_map, ...
function [ energy_map ] = Compute_Texture_Energy( img, mask )
    % Pad the edges with 4 extra rows/columns using the values on the image
    % boundary
    top_row = img(1, :);
    bottom_row = img(end, :);
    img = [ top_row; top_row; top_row; top_row; img;...
              bottom_row; bottom_row; bottom_row; bottom_row ];
    first_col = img(:, 1);
    last_col = img(:, end);
    img = [ first_col first_col first_col first_col img ...
              last_col last_col last_col last_col ];

    filter_results = zeroes(size(img));
    for i = 1:size(img, 1)
        for j = 1:size(img, 1)
            % Calculate F[i,j] and store in a matrix
            filter_results(i,j) = 0; % TODO
        end
    end
    
    energy_map = zeros(size(img));
    for r = 1:size(img, 1)
        for c = 1:size(img, 2)
            energy = 0;
            for j = (c-4):(c+4)
                for i = (r-4):(r+4)
                    energy = energy + abs(filter_results(i,j));
                end
            end
            energy_map(r,c) = energy;
        end
    end
    
end

