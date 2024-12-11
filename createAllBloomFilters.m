function [BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, Pfp, n_value)
    % Esta função cria um cell array que contém um bloom filter para
    % cada categoria. Assume que é adotado o k ótimo na inserção dos
    % elementos.
    % Argumentos:
    %   - num_recipes_for_category: numero de receitas em cada categoria
    %   - Pfp: objetivo de percentagem de falsos positivos
    % Devolve:
    %   BFs: cell array com um bloom filter em cada coluna
    %   ks: array com os valores ótimos de k para cada bloom filter
    %   n: tamanho de cada bloom filter
    cat_unique = length(num_recipes_for_category(:, 2));
    BFs = cell(1, cat_unique);

    % valores de m (numero de membros de cada conjunto)
    m = num_recipes_for_category(:, 2)';

    % determinar os valores de n para cada filtro
    n = zeros(1, cat_unique);
    if nargin == 3
        n = ones(1, cat_unique)*n_value;
    end
    for i = 1:cat_unique
        n(i) = ceil(log(Pfp) / (log(((1-exp(-log(2)))^(log(2)/m{i})))));
    end
    % determinar os valores ótimos de k
    ks = ceil((n*log(2))./cell2mat(m));

    % inicialização dos filtros
    for i = 1:cat_unique
        BFs{i} = BFinitialize(n(i));
    end
end