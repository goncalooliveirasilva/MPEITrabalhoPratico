clc

imsize = 100;

% binarizeImages("dataset_old/test/circle/", "dataset_25/test/circle/", imsize)
% binarizeImages("dataset_old/test/triangle/", "dataset_25/test/triangle/", imsize)
% binarizeImages("dataset_old/test/rectangle/", "dataset_25/test/rectangle/", imsize)
% binarizeImages("dataset_old/test/square/", "dataset_25/test/square/", imsize)
% binarizeImages("dataset_old/test/kite/", "dataset_25/test/kite/", imsize)

% [imageData, categories] = loadImageData("dataset_25/test/", imsize);
% save("imageTestData25px.mat", "imageData", "categories")


%%
% Retorna uma matriz das probabilidades de cada pixel para cada categoria,
% um vetor com as probabilidades das e um vetor com as categorias(probs e
% base_probs seguem a ordem desse vetor)
function [categories_unique, base_probs, probs] = getProbabilities(imageData, categories)
    % Probabilidades de obter categoria X
    categories_unique = unique(categories);
    base_probs = zeros(size(categories_unique));

    probs = zeros(length(categories_unique), size(imageData, 2));
    for i=1:length(categories_unique)
        base_probs(i) = sum(categories == categories_unique(i))/length(categories);
        
        % Soma de todas as imagens da categoria
        data = sum(imageData(categories == categories_unique(i), :));

        % Calcular probabilidades com Laplace smoothing
        probs(i, :) = (data + 1) / (sum(data) + size(data, 2));
    end
end

% Retorna a categoria a que pertence img, com a sua probabilidade
function [cat, prob]=testCategory(img, categories_unique, base_probs, probs)
    prob = -inf;
    cat = "NULL";
    for i=1:length(categories_unique)
        % Calcular probabilidade para a imagem e categoria
        new_prob = sum(log(probs(i, img==1))) + log(base_probs(i));

        % fprintf("Categoria a testar: %s (Probabilidade: %f)\n", categories_unique(i), new_prob)

        % Nova probabilidade maxima
        if new_prob >= prob
            prob = new_prob;
            cat = categories_unique(i);
            % fprintf("Aceite!\n\n")
        end
    end
end

% Mostra uma imagem
function show_image(img)
    imshow(reshape(img, 100, 100))
end

load("imageTestData.mat")
[categories_unique, base_probs, probs] = getProbabilities(imageData, categories);

% load("imageTestData.mat")

% test_index = 6;
% fprintf("Categoria desejada: %s\n", categories(test_index));
% show_image(imageData(test_index, :))
% [cat, prob]=testCategory(imageData(test_index, :), categories_unique, base_probs, probs);
% fprintf("Categoria obtida: %s\n", cat);

% load("imageTestData.mat")

num_errados = 0;
for test_index=1:length(categories)
    [cat, prob]=testCategory(imageData(test_index, :), categories_unique, base_probs, probs);
    
    if cat ~= categories(test_index)
        num_errados = num_errados + 1;
    end
end
fprintf("Numero de errados: %d\n", num_errados)