function classStats = train(folderPath) % 'C:\Users\Vince\Documents\GitHub\cse_803\Training_Images'
    dirData = dir(folderPath);
    
    %get number of training samples
    for idx = 1:length(dirData)
        file = dirData(idx).name;
        if(length(file) > 4 & file(end-3:end) == '.jpg')
            if ~exist('filenames', 'var');
                filenames = char(file);
            else
                filenames = char(filenames,file);
            end
        end
    end
    data = struct([]);
    parfor idx = 1:size(filenames,1)
        file = strtrim(filenames(idx,:));
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
            labels = get_labels(file);
            data(idx).('labels') = labels;
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
                %imwrite(region, strcat(folderPath, '\foregrounds\',file(1:end-4),'_foreground.jpg'));
                featureVector = get_features(region, mask);
                data(idx).('features') = featureVector;
            end
        end
    end
    
    classStats = get_class_data(data);
end