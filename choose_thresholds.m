function [thresholds, H] = choose_thresholds(greyImg)
    H = hist(cast(greyImg(:), 'double'), 128);
    for len = [15 17 19]
        H = conv(H, gausswin(len));
        H = H(floor(len/2):end-floor(len/2)-1);
    end
    thresholds = [];
    len = 8;
    for idx = len:length(H)-len
        if(all(H(idx+1:idx+len)>= H(idx)) && all(H(idx-len+1:idx-1)>= H(idx)))
            thresholds(end + 1) = idx;
        end
    end
    thresholds = thresholds * 2;
    thresholds = [0 thresholds 256];
end