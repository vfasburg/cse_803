function metatrain(folderPath, testFolder)
    dirData = dir(folderPath);
    numTests = 3;
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
    classNames = getClassNames();
    filenames = cellstr(filenames);
    for classIdx = 1:length(classNames)
        curClass = strtrim(classNames{classIdx});
        classLocs = [];
        for fileIdx = 1:length(filenames)
            if strfind(filenames{fileIdx},curClass)
                classLocs = [classLocs fileIdx];
            end
        end
        numSamples = length(classLocs);
        ignoredFiles = [];
        
        if(numSamples > 15)
            bestPerf = 0;
            bestIgnored = [];
            for asdf = 1:numTests
                indicies = randsample(numSamples, numSamples - 15);
                %rename appropriate files
                for idx = 1:length(indicies)
                    curIdx = indicies(idx);
                    curLoc = classLocs(curIdx);
                    curFile = filenames{curLoc};
                    ignoredFiles = [ignoredFiles ' ' curFile];
                    movefile(strcat(folderPath,'\',curFile), strcat(folderPath,'\',curFile,'.tmp'));
                end
                % perform training & testing
                classStats = train(folderPath);
                performance = test(classStats, testFolder, 0);

                if(performance(classIdx) > bestPerf)
                    bestPerf = performance(classIdx);
                    bestIgnored = ignoredFiles;
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
            fprintf('class: %s\n', curClass);
            fprintf('best ignored files: %s\n', bestIgnored);
            fprintf('best performance: %f\n\n', bestPerf);
        end
    end
    
    