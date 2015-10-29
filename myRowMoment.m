function objectRowMoment = myRowMoment( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the second order row moment of the object

    [row,~] = find(image == colorNum);
    
    objectCentroid = myCentroid(image, colorNum);
    objectArea = myArea(image, colorNum);
    
    objectRowMoment = sum( ( row - objectCentroid(1) ).^2 ) ./ objectArea;

end