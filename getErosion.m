function erosionImage = getErosion( image )
% inputs: a binary image
%
% return: a binary image of the erosion

    structElmt = strel('square',3);
    
    erosionImage = imerode(image,structElmt);

end

