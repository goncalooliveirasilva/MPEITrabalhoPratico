clc

function [imageData, categories] = loadImageData(path)
    dirs = dir(path);
    dirflag = [dirs.isdir];

    categories_names = dirs(dirflag);
    categories_names = {categories_names(3:end).name};
    
    imageData = zeros(1, 10000);
    categories = categorical(1, 10000);
    for i=1:length(categories_names)
        cat_name = convertCharsToStrings(categories_names{i});
        directory = join([path categories_names{i} "/"], "");
        
        imageFiles = dir(fullfile(directory, "*.png"));
        
        for k=1:length(imageFiles)
            filepath = fullfile(directory, imageFiles(k).name);
            imdata = imread(filepath);
            imdata = imdata(:)';
            imageData(k + (i-1)*1500, :) = imdata;
            categories(k + (i-1)*1500) = cat_name;
        end
    end
end


% [imageData, categories] = loadImageData("dataset/train/");
save("imageTrainData.mat", "imageData", "categories")

% binarizeImages("dataset_old/train/circle/", "dataset/train/circle/")
% binarizeImages("dataset_old/train/triangle/", "dataset/train/triangle/")
% binarizeImages("dataset_old/train/rectangle/", "dataset/train/rectangle/")
% binarizeImages("dataset_old/train/square/", "dataset/train/square/")
% binarizeImages("dataset_old/train/kite/", "dataset/train/kite/")
