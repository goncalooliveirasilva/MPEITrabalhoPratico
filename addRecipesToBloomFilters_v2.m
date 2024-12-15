% Adiciona as receitas aos bloom filters que não correspondem à categoria da receita.
% Argumentos:
%   - BFs: cell array com os bloom filters (output da função createAllBloomFilters)
%   - n: array com o tamanho de cada bloom filter (output da função createAllBloomFilters)
%   - ks: array com o s valores ótimos de m
%   - data: matriz lógica dos ingredientes em cada receita
%   - categories: cell array com as categorias de cada receita
%   - uniqueIngredients: cell array com os ingredientes todos
% Retorna:
%   - BFs: cell array com os bloom filters com as receitas adicionadas
%   - k_keys: cell array com os índices do filtro onde foram mapeadas as receitas
%   - collisions_counts: número de colisoes por filtro
function [BFs, k_keys, collisions_counts] = addRecipesToBloomFilters_v2(BFs, n, ks, data, categories, uniqueIngredients)
    B = length(BFs);
    num_recipes = size(data, 1);
    cat_unique = unique(categories);
    k_keys = cell(num_recipes, 1);
    collisions_counts = zeros(1, length(cat_unique));
    for i = 1:num_recipes
        % ingredientes e categoria de cada receita
        ingredients = uniqueIngredients(data(i, :) == 1);
        category = categories(i);
        % str para a hash function
        str = ingredientsToStr(ingredients);
        % em qual bloom filter não inserir?
        indice = find(cat_unique == category);
        % adicionar aos bloom filters não correspondentes
        indices = 1:B;
        % eliminar o indice do BF que não é para inserir as receitas
        indices(indices == indice) = [];
        for j = indices
            [BFs{j}, key, collisions] = BFAddElement(BFs{j}, n(j), str, ks(j));
            k_keys{i} = key;
            collisions_counts(j) = collisions_counts(j) + collisions;
        end
    end
end