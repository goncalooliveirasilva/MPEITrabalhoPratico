clc

% binarizeImages("dataset_old/test/circle/", "dataset/test/circle/")
% binarizeImages("dataset_old/test/triangle/", "dataset/test/triangle/")
% binarizeImages("dataset_old/test/rectangle/", "dataset/test/rectangle/")
% binarizeImages("dataset_old/test/square/", "dataset/test/square/")
% binarizeImages("dataset_old/test/kite/", "dataset/test/kite/")

function [imageData, categories] = loadImageData(path)
    dirs = dir(path);
    dirflag = [dirs.isdir];

    categories_names = dirs(dirflag);
    categories_names = {categories_names(3:end).name};
    
    imageData = zeros(1, 10000);
    categories = categorical(1, 10000);

    index = 0;
    for i=1:length(categories_names)
        cat_name = convertCharsToStrings(categories_names{i});
        directory = join([path categories_names{i} "/"], "");
        
        imageFiles = dir(fullfile(directory, "*.png"));
        
        for k=1:length(imageFiles)
            index = index + 1;

            filepath = fullfile(directory, imageFiles(k).name);
            imdata = imread(filepath);
            imdata = imdata(:)';
            imageData(index, :) = imdata;
            categories(index) = cat_name;
        end
    end
end


% [imageData, categories] = loadImageData("dataset/test/");
% save("imageTestData.mat", "imageData", "categories")

function [categories_unique, base_probs, probs] = getProbabilities(imageData, categories)
    % Probabilidades de obter categoria X
    categories_unique = unique(categories);
    base_probs = zeros(size(categories_unique));

    probs = zeros(length(categories_unique), size(imageData, 2));
    for i=1:length(categories_unique)
        base_probs(i) = sum(categories == categories_unique(i))/length(categories);
        
        data = sum(imageData(categories == categories_unique(i), :));
        probs(i, :) = data / sum(data);
    end
end


[categories_unique, base_probs, probs] = getProbabilities(imageData, categories);
