function [isMember, category] = checkIfRecipeIsKnown(BFs, ingredients, ks, categories_unique)
    % Esta função verifica se uma receita já é conhecida (é membro de algum bloom filter)
    % Argumentos:
    %   - BFs: cell array com os filtros de bloom
    %   - ingredients: cell array com os ingredientes da receita
    %   - ks: array com o s valores otimos de k de cada bloom filter
    % Devolve:
    %   - result: true ou false se a receita pertence a algum bloom filter.
    %   Se o teste indicar pertença a mais do que um bloom filter result
    %   assume valor false.
    %   - category: categoria da receita ou false se result for false
    str = ingredientsToStr(ingredients);
    results = zeros(1, length(BFs));
    isMember = false;
    category = false;
    % verificação de pertença para cada bloom filter
    for i = 1:length(BFs)
        r = BFIsMember(BFs{i}, str, ks(i));
        %disp(r);
        if r == true
            results(i) = 1;
        end
    end 
    %disp(results);
    % verificar se pertence apenas a 1 bloom filter
    if sum(results) == 1
        isMember = true;
        category = categories_unique(results == 1);
    end
end