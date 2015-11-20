function test(trainingData, folderPath)
    if nargin < 2
        folderPath = '.\Testing_Images';
    end

    dirData = dir(folderPath);
    cd(folderPath);
        %get number of training samples
    for idx = 1:length(dirData)
        file = dirData(idx).name;
        if(length(file) > 4 & strcmpi(file(end-3:end),'.jpg'))
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
        if(length(file) > 4 & strcmpi(file(end-3:end),'.jpg'))
            try
                img = imread(strcat(folderPath,'\',file));
            catch
                fprintf('file: %s has unsupported formatting', file);
                continue;
            end
            data(idx).('file') = file;
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
                mask = imfill(mask,'holes');
                mask3d = repmat(mask,[1 1 3]);
                region = img.*cast(mask3d, 'uint8');
                % imshow(region);
                label = classify(trainingData, region, mask);
                data(idx).('label') = label;
            end
        end
    end
    
%     correct = 0;
%     incorrect = 0;
%     
%     for idx = 1:length(data)
%         file = data(idx).('file');
%         label = data(idx).('label');
%         fprintf('file: %s label: %s\n', file, label);
%         if ~isempty(strfind(file, label))
%             correct = correct + 1;
%         else
%             incorrect = incorrect + 1;
%         end
%     end
%     fprintf('%2.2f percent correct. %d out of %d.\n', 100*correct/(correct+incorrect),correct, correct+incorrect);

    fileID = fopen('.\label.txt');
    textline = textscan(fileID, '%[^\n]');
    numSamples = length(textline{1});
    classPerf = struct();
    fields = getTestClassNames();
    for fieldnum = 1:length(fields)
        curClass = strtrim(fields{fieldnum});
        classPerf.(curClass).('detected') = 0;
        classPerf.(curClass).('numinclass') = 0;
        classPerf.(curClass).('rejected') = 0;
        classPerf.(curClass).('numnotinclass') = 0;%size(filenames,1);
        for linenum = 1:numSamples
            %extract labels from line of text
            truelabels = textline{1}{linenum};
            spaces = strfind(truelabels, ' ');
            truelabels = truelabels(spaces(1)+1:end);
            if(~isempty(strfind(truelabels,curClass)))
                classPerf.(curClass).('numinclass') = classPerf.(curClass).('numinclass') + 1;
            else
                classPerf.(curClass).('numnotinclass') = classPerf.(curClass).('numnotinclass') + 1;
            end
        end
    end

    for idx = 1:length(data)
        file = data(idx).('file');
        label = data(idx).('label');
        fprintf('file: %s label: %s\n', file, label);
        linenum = 1;
        curline = textline{1}{linenum};
        while linenum <= length(textline{1}) & isempty(strfind(curline, file))
            linenum = linenum + 1;
            curline = textline{1}{linenum};
        end
        fprintf('linenum %d filename: %s\n', linenum, file);
        if(~isempty(strfind(curline,file)))
            %extract labels from line of text
            truelabels = textline{1}{linenum};
            truelabels = truelabels(length(file)+1:end);

            %check if label was determined correctly
            if(~isempty(strfind(truelabels,label)))
                classPerf.(label).('detected') = classPerf.(label).('detected') + 1;
            end

            %add each class that doesnt occur in either label to reject
            for classnum = 1:length(fields)
                curClass = strtrim(fields{classnum});
                if(isempty(strfind(truelabels,curClass)) && isempty(strfind(label,curClass)))
                   classPerf.(curClass).('rejected') = classPerf.(curClass).('rejected') + 1; 
                end
            end
        end
    end
    for fieldnum = 1:length(fields)
        curClass = strtrim(fields{fieldnum});
        det = classPerf.(curClass).('detected');
        in = classPerf.(curClass).('numinclass');
        rej = classPerf.(curClass).('rejected');
        out = classPerf.(curClass).('numnotinclass');
        fprintf('class: %s detected %d of %d (%f percent) rejected %d of %d (%f percent) avg %f percent\n', ...
            curClass, det, in, det/in*100, rej, out, rej/out*100, mean([det/in*100 rej/out*100]));
    end
end