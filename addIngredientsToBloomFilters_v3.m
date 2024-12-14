function [BFs, k_keys, collisions_counts] = addIngredientsToBloomFilters_v3(BFs, n, ks, specificIng, ingOccurrences, uniqueIngredients)
    % Esta função adiciona os ingredientes específicos ao bloom filter onde
    % eles aparecem
    % Argumentos:
    %   - BFs: cell array com os bloom filters
    %   - n: array com o tamanho de cada bloom filter
    %   - k: array com o s valores otimos de m
    %   - specificIng: indices dos ingredientes que aparecem num número
    %   igual ou inferior a generic_threshold categorias
    %   - ingOcurrences: matriz uniqueIngridients x categorias onde em cada
    %   célula está o número total de vezes que o ingrediente aparece nas
    %   receitas da categoria
    %   - uniqueIngredients: cell array com os ingredientes únicos
    % Devolve:
    %   - BFs: cell array com os bloom filters com os ingerdientes
    %   adicionados
    %   - k_keys: cell array com os indices do filtro onde foram mapeados os
    %   ingredientes
    %   - collisions_counts: número de colisoes por filtro

    % saber em que BF colocar cada specific ingredient
    % indice da categoria (col.2) (bllom filter a inserir)
    num_specific_ingredients = length(specificIng);
    num_filters = length(BFs);
    k_keys = cell(num_specific_ingredients, 1);
    collisions_counts = zeros(1, num_filters);
    for i = 1:num_specific_ingredients
        ind = specificIng(i);
        % categorias em que está presente
        present_categories = find(ingOccurrences(ind, :) > 0);
        if ~isempty(present_categories)
            for j = present_categories
                [BFs{j}, key, collisions] = BFAddElement(BFs{j}, n(j), uniqueIngredients{ind}, ks(j));
                k_keys{i} = key;
                collisions_counts(j) = collisions_counts(j) + collisions;
            end
        end
    end
end