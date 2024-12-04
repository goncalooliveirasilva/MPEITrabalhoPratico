clear
clc

% Retorna uma matriz das probabilidades de cada pixel para cada categoria,
% um vetor com as probabilidades das e um vetor com as categorias(probs e
% base_probs seguem a ordem desse vetor)
function [categories_unique, base_probs, probs] = getProbabilities(ingredientData, categories)
    % Probabilidades de obter categoria X
    categories_unique = unique(categories);
    base_probs = zeros(size(categories_unique));

    probs = zeros(length(categories_unique), size(ingredientData, 2));
    for i=1:length(categories_unique)
        base_probs(i) = sum(categories == categories_unique(i))/length(categories);
        
        % Soma de todas as imagens da categoria
        data = sum(ingredientData(categories == categories_unique(i), :));

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

load("dataToNaiveBayes.mat")
[categories_unique, base_probs, probs] = getProbabilities(data, categories);


% load("imageTestData.mat")

% test_index = 6;
% fprintf("Categoria desejada: %s\n", categories(test_index));
% [cat, prob]=testCategory(ingredientData(test_index, :), categories_unique, base_probs, probs);
% fprintf("Categoria obtida: %s\n", cat);

% load("imageTestData.mat")

num_errados = 0;
for test_index=1:length(categories)
    [cat, prob]=testCategory(data(test_index, :), categories_unique, base_probs, probs);
    
    if cat ~= categories(test_index)
        num_errados = num_errados + 1;
    end
end
fprintf("Numero de errados: %d\n", num_errados)

%% BLOOM FILTER

m = length(categories); % número receitas

% determinar o n 
% k_otimo = n*ln(2)/m
% Pfp = (1-exp(-km/n))^k
% Pfp = ????
%