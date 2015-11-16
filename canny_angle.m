function histo = canny_angle(img, mask)
    bin_img = edge(rgb2gray(img), 'Canny');
%     edge = rangefilt(rgb2gray(img));
%     bin_img = (edge > 100);
    pixels = sum(mask(mask==1));
    histo = [0 0 0 0]; % [-, /, |, \]
    for row = 2:size(bin_img,1)-1
        for col = 2:size(bin_img,2)-1
            if(all(bin_img(row,col-1:col+1)))
                histo(1) = histo(1) + 1;
            end
            if(all([bin_img(row+1,col-1) bin_img(row,col) bin_img(row-1,col+1)]))
                histo(2) = histo(2) + 1;
            end
            if(all(bin_img(row-1:row+1,col)))
                histo(3) = histo(3) + 1;
            end
            if(all([bin_img(row-1,col-1) bin_img(row,col) bin_img(row+1,col+1)]))
                histo(4) = histo(4) + 1;
            end
        end
    end
    histo = histo./pixels;
    %shift it so it is rotationally invariant
    [~, maxIdx] = max(histo);
    if(maxIdx > 1)
        histo = [histo(maxIdx:end) histo(1:maxIdx - 1)];
    end
%     imshow(bin_img);
%     figure;
%     bar(histo);
end