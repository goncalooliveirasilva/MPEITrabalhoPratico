function [str] = ingredientsToStr(ingredients)
    % Esta função junta os ingredientes de uma receita por ordem alfabetica
    % numa string
    % Argumentos:
    %   - ingredients: cell array com os ingredientes
    % Devolve:
    %   - str: string dos ingredientes concatenados
    str = strjoin(regexprep(ingredients, '\s+', ''), '');
end