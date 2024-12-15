% Determina o índice da categoria da receita, ou seja, o indice do Bloom filter
% em que foram reconhecidos mais ingredientes.
% Argumentos:
%   - recognizedIngredients: array com o número de ingredientes
%                            reconhecidos em cada bloom filter
%   - numIngredients: número de ingredientes da receita
%   - threshold (opcional): valor para decidir se a receita é identificado ou não.
%               Deve estar entre 0 e 1. Representa a percentagem de ingredientes
%               que devem ser identificados num único bloom filter para a receita
%               ser reconhecida. Quando não é fornecido, é apenas tido em conta o
%               máximo de recognizedIngredients, sem qualquer outro critério.
% Retorna:
%   - result: índice do bloom filter a que foi decidido que a receita pertence.
%             0 se a receita categoria da receita não for decidida.
function result = decideRecipeBF_v3_m1(recognizedIngredients, numIngredients, threshold)
    [m, i] = max(recognizedIngredients);
    % se houver empate
    if length(i) > 1
        result = 0;
        return;
    end
    if nargin < 3
        result = i;
        return;
    end
    T = round(numIngredients*threshold);
    if m >= T
        result = i;
        return;
    end
    result = 0;
end