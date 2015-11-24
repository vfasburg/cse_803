function objectAngleHistogramNorm = getAngleHistogram( mask, stepSize, colorNum )
% inputs: the mask for the image which tells which part is
%         foreground vs. background, and the stepSize
%         which is the number of pixels that are jumped over for each
%         tangent angle calculation.
%
% return: the normalized 1x8 matrix for the normalized tangent angle
%         histogram of the object where angles are rounded to their
%         nearsst 45 degree.
    
    objectAngleHistogram = zeros(1,360);
    objectAngleHistogram45 = zeros(1,8);
    
    % create binary image from mask
    binaryImage = mask;
    %imshow(binaryImage);
    
    % create border of binary image
    borderImage = getBorder(binaryImage);
    %imshow(borderImage);
    
    % get angle of axis of most inertia
    % this will act as our axis of reference to make this
    % rotation invarient
    [ ~, thetaMax ] = getMostInertia(binaryImage, colorNum);
    
    d = size(borderImage);
    for r = 1:d(1)
        for c = 1:d(2)
            if borderImage(r,c) ~= 0
                rowCurrent = r;
                colCurrent = c;
               
                while (rowCurrent ~= 0 && colCurrent ~= 0)
                    rowNext = rowCurrent;
                    colNext = colCurrent;
                    
                    % loop through to get pixel stepSize ahead
                    for i = 1:stepSize
                        [rowNext, colNext] = findNext(rowNext,colNext,borderImage,colorNum);
                    end

                    % calculate tangent angle
                    if (rowNext ~= 0 && colNext ~= 0)     
                        rowDiff = rowCurrent - rowNext;
                        colDiff = colNext - colCurrent;

                        % in range 0 to 180 and 0 to -180
                        angle = round( 180/pi*atan2(rowDiff, colDiff) );

                        % put in range 1 - 360 degrees
                        if angle <= 0
                            angle = 360 + angle;
                        end

                        % shift based on axis of most inertia
                        angle = angle - round(thetaMax);

                        % wrap pixels around
                        if angle <= 0
                            angle = 360 + angle;
                        end 

                        objectAngleHistogram(angle) = objectAngleHistogram(angle) + 1;
                        
                        borderImage(rowCurrent,colCurrent) = 0;
                        [rowCurrent, colCurrent] = findNext(rowCurrent,colCurrent,borderImage,colorNum);
                    else
                        rowCurrent = 0;
                        colCurrent = 0;
                    end
                end
            end
        end
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
        
        if(min(min(mask)) == 1)
            objectAngleHistogramNorm = zeros(size(objectAngleHistogramNorm));
        end
        
        % plot histogram
%         figure();
%         x = linspace(1,8,8);
%         bar(x, objectAngleHistogramNorm, 'r');
%         axis([0 9 0 1]);
        
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

