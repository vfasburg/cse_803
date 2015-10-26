% CSE 803: Meal Recognition Project
% Authors: Vince Fasburg, Bonnie Reiff, Josh Thomas
% Filename: Texture_Analysis.m
% Description: TODO

clear; % Clear the variable workspace

%% Read in the image to the script
% TODO: run the script for every image in the training data set and
% report all results at once
image = imread('Training_Images/apple_1.jpg', 'jpg');

%% Create the initial 5 texture masks
level  = [ 1 4 6 4 1 ];   % Center-weighted local average
edge   = [ -1 -2 0 2 1 ]; % Row or column step edge detector
spot   = [ -1 0 2 0 -1 ]; % Spot detector
ripple = [ 1 -4 6 -4 1 ]; % Ripple detector

%% Multiply each pair of texture masks to create 2D convolution masks and
%  store the masks in a matrix
Convolution_Masks = zeros(5, 5, 16);

Convolution_Masks(:,:,1) = level' * level;    %L5L5
Convolution_Masks(:,:,2) = level' * edge;     %L5E5
Convolution_Masks(:,:,3) = level' * spot;     %L5S5
Convolution_Masks(:,:,4) = level' * ripple;   %L5R5

Convolution_Masks(:,:,5) = edge' * level;     %E5L5
Convolution_Masks(:,:,6) = edge' * edge;      %E5E5
Convolution_Masks(:,:,7) = edge' * spot;      %E5S5
Convolution_Masks(:,:,8) = edge' * ripple;    %E5R5

Convolution_Masks(:,:,9)  = spot' * level;    %S5L5
Convolution_Masks(:,:,10) = spot' * edge;     %S5E5
Convolution_Masks(:,:,11) = spot' * spot;     %S5S5
Convolution_Masks(:,:,12) = spot' * ripple;   %S5R5

Convolution_Masks(:,:,13) = ripple' * level;  %R5L5
Convolution_Masks(:,:,14) = ripple' * edge;   %R5E5
Convolution_Masks(:,:,15) = ripple' * spot;   %R5S5
Convolution_Masks(:,:,16) = ripple' * ripple; %R5R5

%% Perform image preprocessing to remove the effects of illumination
% Convert the image to grayscale
image = rgb2gray(image);
% Convert all values to doubles to make the preprocessing more exact
% Results in all values between 0 and 1
image = im2double(image);

%% Apply each of the masks to the pre-processed image
%  Note: Storage may take an obnoxious amount of space depending on the 
%        size of the image
Texture_Energy_Maps = zeros(size(image, 1), size(image, 2), 16);
for i = 1:16
    Texture_Energy_Maps(:,:,i) = ...
        Compute_Texture_Energy(image, Convolution_Masks(:,:,i));
end

%% Output the 9-dimensional energy map feature vector
% [ E5S5 S5S5 R5R5 E5L5 S5L5 R5L5 S5E5 R5E5 R5S5 ]
