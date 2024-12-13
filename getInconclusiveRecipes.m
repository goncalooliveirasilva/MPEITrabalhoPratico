function numRecipes = getInconclusiveRecipes(BFs, test_categories, test_data, ks, categories_unique, uniqueIngredients, v)
    % Esta função calcula o número de receitas cuja categoria não é
    % determinada na etapa dos bloom filters
    % Argumentos:
    %   - BFs: cell array com os bloom fliters
    %   - test_categories: cell array com as categorias das receitas de teste
    %   - test_data: cell array com receitas de teste
    %   - ks: array com os valores ótimos de k para cada filtro
    %   - categories_unique: cell array com as categorias únicas das
    %   receitas
    %   -   uniqueIngredients: cell array com os ingredientes sem
    %   duplicados
    %   - v: versão da implementação dos bloom filters
    % Devolve:
    %   - numRecipes: número de receitas inconclusivas
    arr = zeros(length(test_categories), 1);
    ing = cell(length(test_categories), 1);
    numRecipes = 0;
    for i = 1:length(test_categories)
        ingredients = uniqueIngredients(test_data(i, :) == 1);
        ing{i} = ingredientsToStr(ingredients);
        [isMember, ~] = checkIfRecipeIsKnown(BFs, ingredients, ks, categories_unique, v);
        arr(i) = isMember;
        if ~isMember
            numRecipes = numRecipes + 1;
        end
    end

end