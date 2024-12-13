% Faz o hash de str k vezes.
% Argumentos:
%   - str: array de caracteres
%   - k: número de funções de dispersão
% Retorna:
%   - hash2: array com os valores de hash para cada função de dispersão
function hash2 = string2hash_2(str, k)
    hash2 = zeros(1, k);
    str = double(str);
    hash = 5381*ones(size(str, 1), 1); 
    for i = 1:size(str, 2) 
        hash = mod(hash * 33 + str(:,i), 2^32-1); 
    end
    for i = 1:k
        %str = num2str(i);
        hash = mod(hash * 33 + i, 2^32-1); 
        hash2(i) = hash;
    end
end