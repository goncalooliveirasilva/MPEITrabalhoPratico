% Esta função inicializa um bloom filter de tamanho n.
% Argumentos:
%   - n: dimensão do bloom filter
% Retorna:
%   - BF: bloom filter
function BF = BFinitialize(n)
    BF = zeros(n, 1);
end