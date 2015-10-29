function [ objectLeastInertia, theta ] = myLeastInertia( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the value and angle (degrees) of least inertia of the object
    
    theta_rad = (atan2( (2 .* myMixMoment(image,colorNum)), ...
            (myRowMoment(image,colorNum)-myColMoment(image,colorNum)) ) ./ 2);
    
    inertia_1 = ( ( (sin(theta_rad)).^2 ) .* myRowMoment(image,colorNum) ) - ...
                    ( 2 .* sin(theta_rad) .* cos(theta_rad) .* myMixMoment(image,colorNum) ) + ...
                    ( ( (cos(theta_rad)).^2 ) .* myColMoment(image,colorNum) );
                
    inertia_2 = ( ( (sin(theta_rad+(pi/2))).^2 ) .* myRowMoment(image,colorNum) ) - ...
                ( 2 .* sin(theta_rad+(pi/2)) .* cos(theta_rad+(pi/2)) .* myMixMoment(image,colorNum) ) + ...
                ( ( (cos(theta_rad+(pi/2))).^2 ) .* myColMoment(image,colorNum) );
                
    objectLeastInertia = min(inertia_1, inertia_2);
    
    if inertia_1 == objectLeastInertia
       theta = (180 ./ pi) .* theta_rad;
    else
       theta = (180 ./ pi) .* (theta_rad + (pi ./ 2) );
    end
end