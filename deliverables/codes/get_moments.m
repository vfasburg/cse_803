function [mu_rr, mu_cc] = get_moments(curImage)

    %compute area
    A = length(curImage(curImage > 0));
    % compute centroid
    r = [];
    c = [];
    for row = 1:size(curImage, 1)
        for col = 1:size(curImage, 2)
            if(curImage(row, col) > 0)
                r = [r, row];
                c = [c, col];
            end
        end
    end
    r_sum = sum(r);
    c_sum = sum(c);
    r_bar = r_sum/A;
    c_bar = c_sum/A;

    % calculate 2nd order moments
    mu_rr = sum((r - r_bar).^2)/A;
    %mu_rc = sum((r - r_bar).*(c - c_bar))/A;
    mu_cc = sum((c - c_bar).^2)/A;
    %fprintf('region %i: mu_rr=%f mu_cc=%f\n', region, mu_rr, mu_cc);
end