function [result] = BFIsMember(BF, element, k)
    % Esta função verifica se um elemento faz parte ou não
    % do bloom filter BF
    result = true;
    n = length(BF);
    key = string2hash_2(element, k);
    key = mod(key, n) + 1;
    for i = 1:length(key)
        value = BF(key);
        if value == 0
            result = false;
        end
    end
end