% Devolve um cell array com o número de receitas de cada categoria.
% Argumentos:
%   - categories: conjunto das categorias
% Retorna:
%   - num_recipes: cell array mencionado acima. É da forma:
%           coluna 1 -> categoria
%           coluna 2 -> numero receitas
function num_recipes = numRecipesForCategory(categories)
    cat_unique = unique(categories);
    num_recipes = cell(length(cat_unique), 2);
    for i = 1:length(cat_unique)
        num_recipes{i, 1} = cat_unique(i);
        num_recipes{i, 2} = sum(categories==cat_unique(i));
    end
end