function borderImage = getBorder( image )
% inputs: a binary image
%
% return: a binary image of the border of the object
    
    erosionImage = getErosion(image);

    borderImage = image - erosionImage;

end

