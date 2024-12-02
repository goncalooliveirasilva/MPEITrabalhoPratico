function [imageData, categories] = loadImageData(path, imsize)
    % Abre path e cria uma matriz de imagens e um vetor de categorias
    dirs = dir(path);
    dirflag = [dirs.isdir];

    categories_names = dirs(dirflag);
    categories_names = {categories_names(3:end).name};
    
    imageData = zeros(1, imsize*imsize);
    categories = categorical(1, imsize*imsize);

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