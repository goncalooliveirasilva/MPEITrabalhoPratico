function m_BFs = getNumElementsForBFsv3(specificIng, genericIng, ingOcurrences, num_categories_unique)
    % Esta função determina quantos elementos farão parte de cada bloom
    % filter (m)
    % Argumentos:
    %   - specificIng: indices dos ingredientes que aparecem num número
    %   igual ou inferior a generic_threshold categorias
    %   - genericIng: indices dos ingredientes que aparecem num número
    %   superior a generic_threshold categorias
    %   - ingOcurrences: matriz uniqueIngridients x categorias onde em cada
    %   célula está o número total de vezes que o ingrediente aparece nas
    %   receitas da categoria
    %   - num_categories_unique: número de categorias
    % Devolve:
    %   - m_BFs: array com o número de elementos de cada BF + BF de
    %   ingredientes genéricos
    num_specific_ingredients = length(specificIng); 
    % nº de elementos de cada bloom filter
    m_BFs = zeros(1, num_categories_unique + 1);
    for i = 1:num_specific_ingredients
        ind = specificIng(i);
        % categorias em que está presente
        present_categories = find(ingOcurrences(ind, :) > 0);
        for j = present_categories
            m_BFs(j) = m_BFs(j) + 1; 
        end
    end
    m_BFs(end) = length(genericIng);
end