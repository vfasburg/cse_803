function objectCircularity = getCircularity( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the circularity of the object

    objectCentroid = getCentroid(image, colorNum);
    
    borderImage = getBorder(image);
    [row,col] = find(borderImage == colorNum);
    
    sumMeanRadDist = sum( sqrt( (objectCentroid(1) - row).^2 + (objectCentroid(2) - col).^2 ) );
    d = size(row);
    meanRadDistance = sumMeanRadDist ./ d(1);
    
    sumStdRadDist = sum( (sqrt( (objectCentroid(1) - row).^2 + (objectCentroid(2) - col).^2 ) - meanRadDistance).^2 );
    StdRadDist = sqrt( sumStdRadDist ./ d(1) );
    
    objectCircularity = meanRadDistance ./ StdRadDist;
end
