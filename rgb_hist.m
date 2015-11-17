function H = rgb_hist(img, mask)
    redbits = floor(cast(img(:,:,1), 'double')/2^6);
    greenbits = floor(cast(img(:,:,2), 'double')/2^6);
    bluebits = floor(cast(img(:,:,3), 'double')/2^6);
    colorImg = redbits * 2^4 + greenbits * 2^2 + bluebits;
    % manually create histogram
    H = zeros(1, 64);
    for row = 1:size(colorImg, 1)
        for col = 1:size(colorImg,2)
            if(mask(row,col))
                H(floor(colorImg(row,col))+1) = H(floor(colorImg(row,col))+1) + 1;
            end
        end
    end
    H = H./sum(H);
    % bar(H);
end