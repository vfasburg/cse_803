function objectCentroid = myCentroid( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the row and column of the centroid of the object [row col]

    [row,col] = find(image == colorNum);
    
    objectArea = myArea(image, colorNum);
    
    objectCentroid = [ (sum(row) ./ objectArea), (sum(col) ./ objectArea) ];
end

