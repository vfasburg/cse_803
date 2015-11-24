% Creates a custom histogram where the values are weighted by a median
% filter in order to put more weight on the center pixels of an image.
function medianHist = median_hist( image )

    numBins = 128;
    binWidth = floor(256 / numBins);
    medianHist = zeros(1,numBins);
    
    % create median filter like matrix
    d = size(image);
    horVectorPartial = 1:floor(d(2)./2);
    horVector = [ horVectorPartial fliplr(horVectorPartial) ];
    if (numel(horVector) < d(2))
        horVector(d(2)) = 1;
    end
    
    vertVectorPartial = 1:floor(d(1)./2);
    vertVector = [ vertVectorPartial fliplr(vertVectorPartial) ];
    if (numel(vertVector) < d(1))
        vertVector(d(1)) = 1;
    end
    vertVector = vertVector.';
    medianFilter = vertVector(:) * horVector;
    
    % add values to hitogram
    for i=1:numel(image)
        curBin = floor(image(i)/binWidth) + 1;
        medianHist(curBin) = medianHist(curBin) + medianFilter(i);
    end
    medianHist = medianHist./sum(medianHist);   
    
    %bar(linspace(1,numBins,numBins),medianHist);
end



