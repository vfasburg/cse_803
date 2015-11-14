function featureVector = get_features(img, mask)
    %add other features
    featureVector = [color_hist(img) Generate_Texture_Histograms(img,mask,'grayscale') Generate_Texture_Histograms(img,mask,'binary') ]; %put texture and shape function calls into this matrix
end