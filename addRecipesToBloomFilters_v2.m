function [BFs] = addRecipesToBloomFilters_v2(BFs, n, ks, data, categories, uniqueIngredients)
    % Esta função adiciona as receitas aos bloom filters que não
    % correspondem à categoria da receita
    % Argumentos:
    %   - BFs: cell array com os bloom filters (output da função createAllBloomFilters)
    %   - n: array com o tamanho de cada bloom filter (output da função createAllBloomFilters)
    %   - ks: array com o s valores otimos de m
    %   - data: matriz lógica dos ingredientes em cada receita
    %   - categories: cell array com as categorias de cada receita
    %   - uniqueIngredients: cell array com os ingredientes todos
    % Devolve:
    %   - BFs: cell array com os bloom filters com as receitas adicionadas
    B = length(BFs);
    cat_unique = unique(categories);
    for i = 1:length(data)
        % ingredientes e categoria de cada receita
        ingredients = uniqueIngredients(data(i, :) == 1);
        category = categories(i);
        % str para a hashfunction
        str = ingredientsToStr(ingredients);
        % em qual bloom filter não inserir?
        indice = find(cat_unique == category);
        % adicionar aos bloom filters não correspondentes
        indices = 1:B;
        % eliminar o indice do BF que não é para inserir as receitas
        indices(indices == indice) = [];
        for j = indices
            BFs{j} = BFAddElement(BFs{j}, n(j), str, ks(j));
        end
    end
end