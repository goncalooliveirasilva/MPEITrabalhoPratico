function str = ingredientsToStr(ingredients)
    % Esta função junta os ingredientes de uma receita por ordem alfabetica
    % num array de caracteres
    % Argumentos:
    %   - ingredients: cell array com os ingredientes
    % Devolve:
    %   - str: array de caracteres dos ingredientes concatenados
    str = strjoin(regexprep(ingredients, '\s+', ''), '');
end