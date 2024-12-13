function [specificIng, genericIng, ingOccurrences] = prepareDataForBFs_v3(train_data, train_categories, generic_threshold)
    % Esta função determina dados necessários para a implementação da
    % versão 3 dos bloom filters
    % Argumentos:
    %   - train_data: cell array com as receitas de treino
    %   - train_categories: cell array com as categorias das receitas de
    %   treino
    %   - generic_threshold: número de vezes que os ingredientes aparecem
    %   nas categorias para os considerar genéricos
    % Devolve:
    %   - specificIng: indices dos ingredientes que aparecem num número
    %   igual ou inferior a generic_threshold categorias
    %   - genericIng: indices dos ingredientes que aparecem num número
    %   superior a generic_threshold categorias
    %   - ingOccurrences: matriz uniqueIngridients x categorias onde em cada
    %   célula está o número total de vezes que o ingrediente aparece nas
    %   receitas da categoria
    num_ingredients = size(train_data, 2);
    cat_unique = unique(train_categories);
    num_categories = length(cat_unique);
    ingOccurrences = zeros(num_ingredients, num_categories);
    for i = 1:num_categories
        % indices das receitas da categoria
        recipeIndices = (train_categories == cat_unique(i));
        % nº de vezes que o ingrediente aparece na categoria
        ingOccurrences(:, i) = sum(train_data(recipeIndices, :), 1)';
    end

    % array com o nº de categorias em que cada ingrediente está presente
    ingredient_cat_ocurrences = sum(ingOccurrences > 0, 2);

    % ingredientes a adicionar nos bloom filters
    genericIng = find(ingredient_cat_ocurrences >= generic_threshold);
    specificIng = find(ingredient_cat_ocurrences < generic_threshold);

end