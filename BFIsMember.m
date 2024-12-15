% Esta função verifica se um elemento faz parte ou não do bloom filter BF.
% Argumentos:
%   - BF: bloom filter
%   - element: elemento a verificar a pertença
%   - k: numero de hashfunctions
% Retorna:
%   - result: true ou false, se element pertence ou nao, respetivamente
function result = BFIsMember(BF, element, k)
    result = true;
    n = length(BF);
    key = string2hash_2(element, k);
    key = mod(key, n) + 1;
    %disp(key)
    for i = 1:length(key)
        value = BF(key(i));
        if value == 0
            result = false;
        end
    end
end