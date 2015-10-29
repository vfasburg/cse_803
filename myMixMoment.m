function objectMixMoment = myMixMoment( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the second order mixed moment of the object

    [row,col] = find(image == colorNum);
    
    objectCentroid = myCentroid(image, colorNum);
    objectArea = myArea(image, colorNum);
    
    objectMixMoment = sum( ( row - objectCentroid(1) ) .* ( col - objectCentroid(2) ) ) ./ objectArea;

end

