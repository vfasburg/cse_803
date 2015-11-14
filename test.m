function test(trainingData, folderPath)
    if nargin < 2
        folderPath = '.\Testing_Images';
    end
    correct = 0;
    incorrect = 0;
    dirData = dir(folderPath);
    data = struct([]);
    for idx = 1:length(dirData)
        file = dirData(idx).name;
        if(length(file) > 4 & file(end-3:end) == '.jpg')
            try
                img = imread(strcat(folderPath,'\',file));
            catch
                fprintf('file: %s has unsupported formatting', file);
                continue;
            end
            %if img is bigger than ~500x500, shrink it
            if(size(img,1)*size(img,2) > 250000)
                img = imresize(img, sqrt(250000/(size(img,1)*size(img,2))));
            end
            greyImg = get_best_grey(img);
            [thresholds, H] = choose_thresholds(greyImg);
            %training data only has 1 food, so only need 1 threshold
            [~, minidx] = min(H(thresholds(2:end-1)./2));
            minidx = minidx + 1;  %add 1 bc 0 doesnt count
            thresholds = [0 thresholds(minidx) 256]; 
            [bkgndStart, bkgndEnd] = find_background(greyImg, thresholds);
            for regionIdx = 2:length(thresholds)
                regionStart = thresholds(regionIdx-1);
                regionEnd = thresholds(regionIdx);
                if(regionStart == bkgndStart)
                    continue;
                end
                mask = (greyImg >= regionStart & greyImg < regionEnd);
                %mask = imclose(mask, strel('disk', 10)); %replace with hole filling alg
                mask3d = repmat(mask,[1 1 3]);
                region = img.*cast(mask3d, 'uint8');
                % imshow(region);
                label = classify(trainingData, region, mask);
                fprintf('file: %s label: %s\n', file, label);
                if ~isempty(strfind(file, label))
                    correct = correct + 1;
                else
                    incorrect = incorrect + 1;
                end
            end
        end
    end
    fprintf('%2.2f percent correct. %d out of %d.\n', 100*correct/(correct+incorrect),correct, correct+incorrect);
end