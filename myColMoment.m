function objectColMoment = myColMoment( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the second order column moment of the object

    [~,col] = find(image == colorNum);
    
    objectCentroid = myCentroid(image, colorNum);
    objectArea = myArea(image, colorNum);
    
    objectColMoment = sum( ( col - objectCentroid(2) ).^2 ) ./ objectArea;

end

