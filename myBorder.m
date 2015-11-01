function borderImage = myBorder( image )
% inputs: a binary image
%
% return: a binary image of the border of the object
    
    erosionImage = myErosion(image);

    borderImage = image - erosionImage;

end
