function [fn] = getFalseNegatives(BFs, data, categories, uniqueIngredients, ks)
    % Esta função calcula o número de falsos negativos de cada bloom filter
    % Argumentos:
    %   - Bfs: cell array com os bloom filters
    %   - data: matriz logica
    %   - categories: cell array com as categorias de cada receita
    %   - uniqueIngredients: cell array com os ingredientes das receitas
    %   sem duplicados
    % Devolve:
    %   - fn: cell array 1xlength(BFs) com o número de falsos negativos
    %   para cada bloom filter
    R = length(categories);
    N = length(BFs);
    fn = zeros(1, N);
    cat_unique = unique(categories);
    for i = 1:R
        ingredients = ingredientsToStr(uniqueIngredients(data(i, :) == 1));
        category = categories(i);
        indice = find(cat_unique == category);
        result = BFIsMember(BFs{indice}, ingredients, ks(indice));
        if ~result
            fn(indice) = fn(indice) + result;
        end
    end
end