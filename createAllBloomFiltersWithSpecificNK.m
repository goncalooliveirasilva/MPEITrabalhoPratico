% Cria um cell array que contém um Bloom filter para cada categoria.
% Assume que é adotado o k ótimo na inserção dos elementos.
% Argumentos:
%   - n: array com a dimensão de cada bloom filter
%   - num_categories_unique: número de categorias existentes
% Retorna:
%   BFs: cell array com um bloom filter em cada coluna
function [BFs] = createAllBloomFiltersWithSpecificNK(n, num_categories_unique)
    BFs = cell(1, num_categories_unique);
    % inicialização dos filtros
    for i = 1:num_categories_unique
        BFs{i} = BFinitialize(n(i));
    end
end