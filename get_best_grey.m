function fullGreyImg = get_best_grey(img)
    result = [0 0 0];
    for color = 1:3
        temp_img = img(:,:, color);
        result(color) = std(cast(temp_img(:), 'single'));
    end
    [~, maxColor] = max(result);
    greyImg = img(:,:,maxColor);
    smooth_len = 7;
    half_len = floor(smooth_len/2);
    greyImg = conv2(greyImg, ones(smooth_len));
    
    greyImg = greyImg(smooth_len:end-smooth_len+1,smooth_len:end-smooth_len+1);
    %restore it to correct size
    fullGreyImg = zeros(size(img(:,:,1)));
    for row = 1:size(greyImg,1)
        fullGreyImg(row+half_len, :) = [greyImg(row,1:half_len) greyImg(row, :) greyImg(row,end-half_len+1:end)];
    end
    for col = 1:size(fullGreyImg,2)
        fullGreyImg(1:half_len,col) = fullGreyImg(half_len+1:2*half_len,col);
        fullGreyImg(end-half_len+1:end,col) = fullGreyImg(end-2*half_len+1:end-half_len,col);
    end
    fullGreyImg = fullGreyImg./max(max(fullGreyImg));
    fullGreyImg = cast(fullGreyImg*255, 'uint8');
end