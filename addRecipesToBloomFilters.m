function [BFs] = addRecipesToBloomFilters(BFs, n, ks, data, categories, uniqueIngredients)
    % Esta função adiciona as receitas ao respetivo bloom filter
    % BFs: cell array com os bloom filters (output da função createAllBloomFilters)
    % n: array com o tamanho de cada bloom filter (output da função createAllBloomFilters)
    % ks: array com o s valores otimos de m
    % data: matriz lógica dos ingredientes em cada receita
    % categories: cell array com as categorias de cada receita
    cat_unique = unique(categories);
    for i = 1:length(data)
        % ingredientes e categoria de cada receita
        ingredients = uniqueIngredients(data(i, :) == 1);
        category = categories(i);
        % str para a hashfunction
        str = strjoin(regexprep(ingredients, '\s+', ''), '');
        % em qual bloom filter inserir?
        indice = find(cat_unique == category);
        % adicionar ao bloom filter
        BFs{indice} = BFAddElement(BFs{indice}, n(indice), str, ks(indice));
    end
end