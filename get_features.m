function featureVector = get_features(img, mask)
    %add other features
    featureVector = [color_hist(img) Calculate_Canny_Edgeness(img, mask) ]; %put texture and shape function calls into this matrix
end