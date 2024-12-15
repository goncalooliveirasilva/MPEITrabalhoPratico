% Adiciona um elemento ao Bloom filter BF.
% Argumentos:
%   - n: tamanho do Bloom filter
%   - element: elemento a adicionar
%   - k: numero de hashfunctions a considerar
% Retorna:
%   - BF: bloom filter com element adicionado
%   - key: códigos hash
%   - collisions: número de colisões
function [BF, key, collisions] = BFAddElement(BF, n, element, k)
    key = string2hash_2(element, k);
    key = mod(key, n) + 1;
    collisions = sum(BF(key) == 1);
    BF(key) = 1;
end