function objectRowMoment = getRowMoment( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the second order row moment of the object

    [row,~] = find(image == colorNum);
    
    objectCentroid = getCentroid(image, colorNum);
    objectArea = getArea(image, colorNum);
    
    objectRowMoment = sum( ( row - objectCentroid(1) ).^2 ) ./ objectArea;

end