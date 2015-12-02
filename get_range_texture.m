function result = get_range_texture(img, mask)
    edge = rangefilt(rgb2gray(img));
%     imshow(edge);
%     figure;
    histo = hist(cast(edge(:), 'double'),256);
%     bar(histo(2:end));
    pixels = sum(mask(mask==1));
    result = sum(sum(edge))/pixels;
    % Alternative: result = sum(sum(edge & mask))/pixels;
end
