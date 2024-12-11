function num_recipes = numRecipesForCategory(categories)
    % Esta função devolve cell array com número de receitas de cada categoria
    % coluna 1 -> categoria
    % coluna 2 -> numero receitas
    cat_unique = unique(categories);
    num_recipes = cell(length(cat_unique), 2);
    for i = 1:length(cat_unique)
        num_recipes{i, 1} = cat_unique(i);
        num_recipes{i, 2} = sum(categories==cat_unique(i));
    end
end