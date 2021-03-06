function [bkgndStart, bkgndEnd] = find_background(greyImg, thresholds)
    
    values = zeros(length(thresholds)-1, 1);
    for region = 1:length(thresholds) - 1
        curImage = ((greyImg >= thresholds(region)) & (greyImg < thresholds(region+1)));
        [mu_rr, mu_cc] = get_moments(curImage);
        values(region) = mu_rr + mu_cc;
    end
    [~, bkgndIdx] = max(values);
    bkgndStart = thresholds(bkgndIdx);
    bkgndEnd = thresholds(bkgndIdx+1);
end