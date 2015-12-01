function featureVector = get_features(img, mask)
    %add other features
    coloredMask = bwlabel(mask, 4);
    circ = getCircularity(coloredMask, mode(coloredMask(coloredMask~=0)));
    if isnan(circ)
        circ = 0;
    end
        
    featureVector = [rgb_hist(img, mask) get_range_texture(img, mask) circ]; % getAngleHistogram(mask,5,1)]; %put texture and shape function calls into this matrix
    % featureVector = [rgb_hist(img, mask) get_laws_texture_energy(img, mask) getAngleHistogram(mask,5,1)]; %put texture and shape function calls into this matrix
end