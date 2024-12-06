function [BF] = BFAddElement(BF, n, element, k)
    % Esta função adiciona um elemento ao bloom filter BF
    % n: tamanho do bloom filter
    % element: elemento a adicionar
    % k: numero de hashfunctions a considerar
    key = string2hash_2(element, k);
    key = mod(key, n) + 1;
    BF(key) = 1;
end