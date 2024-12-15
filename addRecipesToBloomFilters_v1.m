% Adiciona as receitas ao respetivo bloom filter.
% Argumentos:
%   - BFs: cell array com os bloom filters (output da função createAllBloomFilters)
%   - n: array com o tamanho de cada bloom filter (output da função createAllBloomFilters)
%   - ks: array com os valores otimos de k
%   - data: matriz lógica dos ingredientes em cada receita
%   - categories: cell array com as categorias de cada receita
%   - uniqueIngredients: cell array com os ingredientes todos
% Retorna:
%   - BFs: cell array com os bloom filters com as receitas adicionadas
%   - k_keys: cell array com os índices do filtro onde foram mapeadas as receitas
%   - collisions_counts: número de colisoes por filtro
function [BFs, k_keys, collisions_counts] = addRecipesToBloomFilters_v1(BFs, n, ks, data, categories, uniqueIngredients)
    cat_unique = unique(categories);
    num_recipes = size(data, 1);
    k_keys = cell(num_recipes, 1);
    collisions_counts = zeros(1, length(cat_unique));
    for i = 1:num_recipes
        % ingredientes e categoria de cada receita
        ingredients = uniqueIngredients(data(i, :) == 1);
        category = categories(i);
        % str para a hashfunction
        str = ingredientsToStr(ingredients);
        % em qual bloom filter inserir?
        indice = find(cat_unique == category);
        % adicionar ao bloom filter
        [BFs{indice}, key, collisions] = BFAddElement(BFs{indice}, n(indice), str, ks(indice));
        k_keys{i} = key;
        collisions_counts(indice) = collisions_counts(indice) + collisions;
    end
end