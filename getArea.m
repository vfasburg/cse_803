function objectArea = getArea( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the area of the object
    
    objectArea = sum(sum(image == colorNum));

end