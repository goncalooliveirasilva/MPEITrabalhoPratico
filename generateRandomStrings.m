% Gera um cell array de strings com tamanhos aleatórios.
% Argumentos:
%   - N: numero de strings a gerar
%   - minLen: comprimento minimo de cada string
%   - maxLen: Comprimento maximo de cada string
%   - chars: caracteres permitidos
% Retorna:
%   - randomStrings: cell array com as strings geradas
function randomStrings = generateRandomStrings(N, minLen, maxLen, chars)
    randomStrings = cell(N, 1);
    for i = 1:N
        strLen = randi([minLen, maxLen], 1, 1);
        randomStrings{i} = string(randsample(chars, strLen, true));
    end
end
