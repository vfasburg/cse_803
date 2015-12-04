% After running metatrain, reverts all .tmp images in the directory back to .jpg

function resetTrainingFolder(folderPath)

    dirData = dir(folderPath);
    for idx = 1:length(dirData)
        file = dirData(idx).name;
        if(length(file) > 4 & file(end-3:end) == '.tmp')
            fullFileName = strcat(folderPath,'\',file);
            movefile(fullFileName, fullFileName(1:end-4));
        end
    end

end