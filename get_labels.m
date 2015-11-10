function labels = get_labels(filename)
    classes = ['apple     '; 'banana    '; 'fries     '; 'broccoli  ';...
               'strawberry'; 'tomato    '];
    classes = cellstr(classes);
    labels = {};
    for idx = 1:length(classes)
        if(~isempty(strfind(filename, classes{idx})))
            labels{end+1} = classes{idx};
        end
    end
end