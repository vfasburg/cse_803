% Creates a custom histogram where the hue values of each image pixel are
% sorted into bins, weighted by their saturation and intensity. This
% removes the influence of whiteness and blackness, leaving only color
% information in the histogram. Histogram is shifted so lowest energy areas
% are at the cut-off, so that a Gaussian isn't disrupted by the rollover of
% an angle value (red is vulnerable to this).
function histo = color_hist(img)
    hsiImg = rgb2hsv(img);
    hues = hsiImg(:,:,1);
    saturations = hsiImg(:,:,2);
    values = hsiImg(:,:,3);
    
    %build custom histogram
%     numBins = 60;
    numBins = 8;
    histo = zeros([1, numBins]);
    binWidth = 1/numBins;
    for i=1:numel(hues)
        curBin = floor(hues(i)/binWidth) + 1; % bin chosen based on hue
        histo(curBin) = histo(curBin) + (saturations(i) * values(i)); 
    end
    histo = histo./sum(histo);
%     
%     % smooth histogram
%     for len = [floor(numBins/10)+1 floor(numBins/10)+3]
%         histo = conv(histo, gausswin(len));
%         histo = histo(floor(len/2):end-floor(len/2)-1);
%     end
%     
%     %shift histogram in 30deg increments so that least energy is at the edges
%     shiftSize = floor(360/numBins);
%     histMin = sum(histo(1:shiftSize));
%     minShift = 0;
%     for shift = 0:shiftSize:numBins-shiftSize
%         if(sum(histo(shift+1:shift+shiftSize)) < histMin)
%             histMin = sum(histo(shift+1:shift+shiftSize));
%             minShift = shift;
%         end
%     end
%     histo = [histo(minShift+1:end); histo(1:minShift)];
%     
%     % plot reults
% %     figure;
% %     bar(histo);
% %     str = sprintf('Histogram shifted down by %d degrees', minShift*360/numBins);
% %     title(str);
%     
%     [~, maxIdx] = max(histo);
%     
%     %convert to max hue degrees
%     maxHue = mod((maxIdx + minShift) * 360/numBins, 360);
%     %calcuate std from histo
%     [high, low, prevHigh, prevLow] = deal(maxIdx);
%     while (high<numBins && histo(high)<=histo(prevHigh))
%         prevHigh = high;
%         high = high+1;
%     end
%     while (low>1 && histo(low)<=histo(prevLow))
%         prevLow = low;
%         low=low-1;
%     end
%     mainColorHisto = histo(low:high);
%     binMidpoints = ((low-1/2)*360/numBins:360/numBins:(high-1/2)*360/numBins)';
%     histMean = sum(mainColorHisto .* binMidpoints)/sum(mainColorHisto);
%     stddev = sum(mainColorHisto .* (binMidpoints - histMean).^2)/sum(mainColorHisto);
%     colorfeature = [maxHue stddev];
end
