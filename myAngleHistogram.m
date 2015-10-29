function objectAngleHistogramNorm = myAngleHistogram( image, colorNum )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the 1x360 matrix for the normalized tangent angle histogram of the object
    
    stepSize = 5;
    objectAngleHistogram = zeros(1,360);
    
    borderImage = myBorder(image);
    [row,col] = find(borderImage == colorNum);
    
    % set first pixel
    pixelNum = 1;
    r = row(1);
    c = col(1);
    rowOrdered(pixelNum) = r;
    colOrdered(pixelNum) = c;
    
    % make list of pixel values in order around object
    perimeterDone = 0;
    while perimeterDone == 0
        borderImage(r,c) = 0;

        if borderImage(r+1,c) == colorNum % a 4 neighbor is connected
            r = r + 1;
        elseif borderImage(r-1,c) == colorNum
            r = r - 1;
        elseif borderImage(r,c+1) == colorNum
            c = c + 1;
        elseif borderImage(r,c-1) == colorNum
            c = c - 1;
        elseif borderImage(r+1,c+1) == colorNum % a 8-4 neightbr is connected
            r = r + 1;
            c = c + 1;
        elseif borderImage(r+1,c-1) == colorNum 
            r = r + 1;
            c = c - 1;
        elseif borderImage(r-1,c+1) == colorNum
            r = r - 1;
            c = c + 1;
        elseif borderImage(r-1,c-1) == colorNum
            r = r - 1;
            c = c - 1;
        else
            perimeterDone = 1;
        end
        
        if perimeterDone == 0
            pixelNum = pixelNum + 1;
            rowOrdered(pixelNum) = r;
            colOrdered(pixelNum) = c;
        end
    end
    
    for i = 1:pixelNum
        startPixel = i;
        endPixel = i + stepSize;
        
        % wrap pixels around
        if endPixel > pixelNum
            endPixel = endPixel - pixelNum;
        end
        
        rowDiff = rowOrdered(startPixel) - rowOrdered(endPixel);
        colDiff = colOrdered(endPixel) - colOrdered(startPixel);
        
        % in range 0 to 180 and 0 to -180
        angle = round( (180 ./ pi) .* atan2(rowDiff, colDiff) );
        
        % put in range 1 - 360 degrees
        if angle <= 0
            angle = 360 + angle;
        end
        
        objectAngleHistogram(angle) = objectAngleHistogram(angle) + 1;
        objectAngleHistogramNorm = objectAngleHistogram ./ sum(objectAngleHistogram);
    end
end

