% Determina o índice do filtro da categoria mais presente enre os ingredientes da receita.
% Argumentos:
%   - ingredientsProbableCategory: rray com os indices das categorias dos ingredientes 
%   - numIngredients: número de ingredientes da receita
%   - threshold (opcional): valor para decidir se a receita é identificado ou não.
%   Deve estar entre 0 e 1. Representa quantas vezes a categoria mais fequente deve aparecer
%   em relação ao número de ingredientes da receita. Quando não é fornecido, é apenas tido em conta o
%   máximo de ingredientsProbableCategory, sem qualquer outro critério.
% Retorna:
%   - result: índice do bloom filter a que foi decidido que a receita
%             pertence. 0 se a receita categoria da receita não for decidida.
function result = decideRecipeBF_v3_m2(ingredientsProbableCategory, numIngredients, threshold)

    % determinar frequência de cada categoria
    occurrences = histcounts(ingredientsProbableCategory, 1:max(ingredientsProbableCategory)+1);
    % categoria mais presente entre os ingredientes
    [num_occurrences, category] = max(occurrences);
    if nargin < 3
        threshold = 0;
    end
    T = round(numIngredients * threshold);
    % se nenhum ingrediente foi reconhecido
    if sum(ingredientsProbableCategory) == 0
        result = 0;
        return;
    end
    if num_occurrences >= T
        result = category;
        return;
    end
    result = 0;
end