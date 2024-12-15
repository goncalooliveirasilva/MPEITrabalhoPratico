% Junta os ingredientes de uma receita por ordem alfabetica
% Argumentos:
%   - ingredients: cell array com os ingredientes
% Retorna:
%   - str: array de caracteres dos ingredientes concatenados
function str = ingredientsToStr(ingredients)
    str = strjoin(regexprep(ingredients, '\s+', ''), '');
end