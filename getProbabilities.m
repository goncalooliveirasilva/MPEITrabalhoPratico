function [categories_unique, base_probs, probs] = getProbabilities(ingredientData, categories)
    % Retorna uma matriz das probabilidades de cada pixel para cada categoria,
    % um vetor com as probabilidades das e um vetor com as categorias(probs e
    % base_probs seguem a ordem desse vetor)

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