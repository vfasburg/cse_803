% CSE 803: Meal Recognition Project
% Authors: Vince Fasburg, Bonnie Reiff, Josh Thomas
% Filename: Calculate_Canny_Edgeness.m

%% Calculate_Canny_Edgeness: Measures the "busyness" of the food item
%                            region texture
% Input : image, an r x c x 3 matrix of pixel intensity values
%                corresponding to the food item with a blacked out bkgrnd
%         region_mask, an r x c logical matrix indicating the food item
%                      region in the image
% Output: edgeness, the number of edge pixels in the food item region
%                   divided by the number of pixels in the region
function [ edgeness ] = Calculate_Canny_Edgeness( image, region_mask )

% Create the grayscale inensity image (assumption that the input image
% is in color!)
intensity_image = rgb2gray(image);

% Apply the edge function to use Canny Edge Detection to produce a 
% binary image
edges_image = edge(intensity_image, 'Canny');

% BEGIN DEBUG: display the image to the user
% figure;
% imshow(edges_image);
% END DEBUG

% Calculate the number of pixels in the food item region
% based on the region_mask parameter to the function
N = sum(sum(region_mask));
% Count the number of edges in region based on the Canny edge image
num_edge_pixels = sum(sum(edges_image & region_mask));

edgeness = num_edge_pixels / N;

end
