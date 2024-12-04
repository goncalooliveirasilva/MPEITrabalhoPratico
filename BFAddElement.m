function [BF] = BFAddElement(BF, element, k)
    % Esta função adiciona um elemento ao bloom filter BF
    n = length(BF);
    key = string2hash_2(element, k);
    key = mod(key, n) + 1;
    BF(key) = 1;
end