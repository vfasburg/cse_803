function data = train(folderPath) % 'C:\Users\Vince\Documents\GitHub\cse_803\images'
    dirData = dir(folderPath);
    data = struct([]);
    for idx = 1:length(dirData)
        file = dirData(idx).name;
        if(length(file) > 4 & file(end-3:end) == '.jpg')
            try
                img = imread(strcat(folderPath,'\',file));
            catch
                fprintf('file: %s has unsupported formatting', file);
                break;
            end
            labels = get_labels(file);
            data(end+1).('labels') = labels;
            greyImg = rgb2gray(img);
            thresholds = choose_thresholds(greyImg);
            [bkgndStart, bkgndEnd] = find_background(greyImg, thresholds);
            for regionIdx = 2:length(thresholds)
                regionStart = thresholds(regionIdx-1);
                regionEnd = thresholds(regionIdx);
                if(regionStart == bkgndStart)
                    break;
                end
                greyImg3d = repmat(greyImg,[1 1 3]);
                region = img .* cast((greyImg3d >= regionStart & greyImg3d < regionEnd), 'uint8');
                featureVector = get_features(region);
                data(end).('features') = featureVector;
            end
        end
    end
end