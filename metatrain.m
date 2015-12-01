function metatrain(folderPath, testFolder)
    dirData = dir(folderPath);
    numTests = 3;
    %get list of training samples
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
    classNames = getClassNames();
    filenames = cellstr(filenames);
    perfData = struct();

    for classIdx = 1:length(classNames)
        curClass = strtrim(classNames{classIdx});
        perfData.(curClass).bestPerf = 0;
        perfData.(curClass).bestIgnored = [];
        perfData.(curClass).curIgnored = [];
        perfData.(curClass).classLocs = [];
        for fileIdx = 1:length(filenames)
            if strfind(filenames{fileIdx},curClass)
                perfData.(curClass).classLocs = [perfData.(curClass).classLocs fileIdx];
            end
        end
    end

    for asdf = 1:numTests
        for classIdx = 1:length(classNames)
            curClass = strtrim(classNames{classIdx});
            numSamples = length(perfData.(curClass).classLocs);
            perfData.(curClass).curIgnored = [];
            if numSamples > 15
                indicies = randsample(numSamples, numSamples - 15);
                %rename appropriate files
                for idx = 1:length(indicies)
                    curIdx = indicies(idx);
                    curLoc = perfData.(curClass).classLocs(curIdx);
                    curFile = filenames{curLoc};
                    perfData.(curClass).curIgnored = [perfData.(curClass).curIgnored ' ' curFile];
                    movefile(strcat(folderPath,'\',curFile), strcat(folderPath,'\',curFile,'.tmp'));
                end
            end
        end

        % perform training & testing
        classStats = train(folderPath);
        performance = test(classStats, testFolder, 0);
        for classIdx = 1:length(classNames)
            curClass = strtrim(classNames{classIdx});
            if(performance(classIdx) > perfData.(curClass).bestPerf)
                perfData.(curClass).bestPerf = performance(classIdx);
                perfData.(curClass).bestIgnored = perfData.(curClass).curIgnored;
            end
        end
        %reset filenames
        dirData = dir(folderPath);
        %get number of training samples
        for idx = 1:length(dirData)
            file = dirData(idx).name;
            if(length(file) > 4 & file(end-3:end) == '.tmp')
                fullFileName = strcat(folderPath,'\',file);
                movefile(fullFileName, fullFileName(1:end-4));
            end
        end
    end
    for classIdx = 1:length(classNames)
        curClass = strtrim(classNames{classIdx});
        fprintf('class: %s\n', curClass);
        fprintf('best ignored files: %s\n', perfData.(curClass).bestIgnored);
        fprintf('best performance: %f\n\n', perfData.(curClass).bestPerf);
    end

    
    