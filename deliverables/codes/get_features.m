function featureVector = get_features(img, mask)
    %add other features
    coloredMask = bwlabel(mask, 4);
    circ = getCircularity(coloredMask, mode(coloredMask(coloredMask~=0)));
    if isnan(circ)
        circ = 0;
    end
        
    featureVector = [rgb_hist(img, mask) get_range_texture(img, mask) circ];
end