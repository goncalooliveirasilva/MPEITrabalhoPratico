function BFs = addIngredientsToBloomFilters_v3(BFs, n, ks, specificIng, ingOcurrences, uniqueIngredients)
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

    % saber em que BF colocar cada specific ingredient
    % indice da categoria (col.2) (bllom filter a inserir)
    num_specific_ingredients = length(specificIng); 
    for i = 1:num_specific_ingredients
        ind = specificIng(i);
        % categorias em que está presente
        present_categories = find(ingOcurrences(ind, :) > 0);
        for j = present_categories
            BFs{j} = BFAddElement(BFs{j}, n(j), uniqueIngredients{ind}, ks(j));
        end
    end
end