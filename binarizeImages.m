function binarizeImages(imageFolder, outputFolder, imsize)
    % Esta função converte as imagens png de um diretório, 
    % binariza-as e guarda-as num novo diretório
    % == Argumentos ==
    % imageFolder: path para o diretório das imagens a converter
    % outputFolder: path para o diretório de destino
    imageFiles = dir(fullfile(imageFolder, '*.jpg'));

    targetSize = [imsize NaN];
    if isempty(imageFiles)
        error('No images found in the specified folder.');
    end
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    else
        delete(fullfile(outputFolder, '*.jpg'));
    end
    for k=1:length(imageFiles)
        filePath = fullfile(imageFolder, imageFiles(k).name);
        I = imread(filePath);
        I = imresize(I, targetSize);
        if size(I, 3) == 3
            I = rgb2gray(I);
        end
        BW = imbinarize(I);
        if mean(BW(:)) > 0.5
            BW = ~BW;
        end
        [~, name, ext] = fileparts(imageFiles(k).name);
        outputFile = fullfile(outputFolder, [name, '_binarized', '.png']);
        imwrite(BW, outputFile);
    end
    n1 = length(imageFiles);
    n2 = length(dir(fullfile(outputFolder, '*.png')));
    if n1 ~= n2
        fprintf('Warning: %d images were not binarized!\n', n1-n2);
    else
        fprintf('All %d images were binarized!\n', n1);
    end
end