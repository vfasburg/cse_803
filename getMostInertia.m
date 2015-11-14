function [ objectMostInertia, theta ] = getMostInertia( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the value and angle (degrees) of most inertia of the object
    
    objectMixMoment = getMixMoment(image,colorNum);
    objectRowMoment = getRowMoment(image,colorNum);
    objectColMoment = getColMoment(image,colorNum);
    
    theta = (atan2d( (2 .* objectMixMoment), (objectRowMoment - objectColMoment) ) ./ 2);
    
    inertia_1 = ( ( (sind(theta)).^2 ) .* objectRowMoment ) - ...
                    ( 2 .* sind(theta) .* cosd(theta) .* objectMixMoment ) + ...
                    ( ( (cosd(theta)).^2 ) .* objectColMoment );
                
    inertia_2 = ( ( (sind(theta+90)).^2 ) .* objectRowMoment ) - ...
                ( 2 .* sind(theta+90) .* cosd(theta+90) .* objectMixMoment ) + ...
                ( ( (cosd(theta+90)).^2 ) .* objectColMoment );
                
    objectMostInertia = max(inertia_1, inertia_2);
    
    if inertia_1 == objectMostInertia
       %theta = theta;
    else
       theta = theta + 90;
    end
    
    % convert to coord system with 0 to right
    theta = theta + 90;
end
