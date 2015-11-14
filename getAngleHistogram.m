function objectAngleHistogramNorm = getAngleHistogram( image, colorNum, stepSize )
% inputs: a colored binary image and the "color" of the object
%         you are intersted in (1, 2, 3, 4, etc).
%
% return: the 1x360 matrix for the normalized tangent angle histogram of the object
    
    objectAngleHistogram = zeros(1,360);
    
    borderImage = getBorder(image);
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
    
    [ ~, thetaMax ] = getMostInertia(image, colorNum);
    
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
        angle = round( atan2d(rowDiff, colDiff) );
        
        % put in range 1 - 360 degrees
        if angle <= 0
            angle = 360 + angle;
        end
        
        angle = angle - round(thetaMax);
        % wrap pixels around
        if angle <= 0
            angle = 360 + angle;
        end       
        
        objectAngleHistogram(angle) = objectAngleHistogram(angle) + 1;
    end
         
% every 45 degrees
        objectAngleHistogram45(1) = sum(objectAngleHistogram(338:360)) + sum(objectAngleHistogram(1:22)); % 0
        objectAngleHistogram45(2) = sum(objectAngleHistogram(23:67)); % 45
        objectAngleHistogram45(3) = sum(objectAngleHistogram(68:112)); % 90
        objectAngleHistogram45(4) = sum(objectAngleHistogram(113:157)); % 135
        objectAngleHistogram45(5) = sum(objectAngleHistogram(158:202)); % 180
        objectAngleHistogram45(6) = sum(objectAngleHistogram(203:247)); % 225
        objectAngleHistogram45(7) = sum(objectAngleHistogram(248:292)); % 270
        objectAngleHistogram45(8) = sum(objectAngleHistogram(293:337)); % 315
    
        objectAngleHistogram45Norm = objectAngleHistogram45 ./ sum(objectAngleHistogram45);
        objectAngleHistogramNorm = objectAngleHistogram45Norm;
        
% every 30 degrees        
%         objectAngleHistogram30(1) = sum(objectAngleHistogram(345:360)) + sum(objectAngleHistogram(1:14)); % 0
%         objectAngleHistogram30(2) = sum(objectAngleHistogram(15:44)); % 30
%         objectAngleHistogram30(3) = sum(objectAngleHistogram(45:74)); % 60
%         objectAngleHistogram30(4) = sum(objectAngleHistogram(75:104)); % 90
%         objectAngleHistogram30(5) = sum(objectAngleHistogram(105:134)); % 120
%         objectAngleHistogram30(6) = sum(objectAngleHistogram(135:164)); % 150
%         objectAngleHistogram30(7) = sum(objectAngleHistogram(165:194)); % 180
%         objectAngleHistogram30(8) = sum(objectAngleHistogram(195:224)); % 210
%         objectAngleHistogram30(9) = sum(objectAngleHistogram(225:254)); % 240
%         objectAngleHistogram30(10) = sum(objectAngleHistogram(255:284)); % 270
%         objectAngleHistogram30(11) = sum(objectAngleHistogram(285:314)); % 300
%         objectAngleHistogram30(12) = sum(objectAngleHistogram(315:344)); % 330
%     
%         objectAngleHistogram30Norm = objectAngleHistogram30 ./ sum(objectAngleHistogram30);
%         objectAngleHistogramNorm = objectAngleHistogram30Norm;
end

