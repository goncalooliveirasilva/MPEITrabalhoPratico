% Obtém o conjunto de pares mais similares, baseado num limiar.
% Argumentos:
%   - data: conjunto dos documentos
%   - testData: documento de teste
%   - J: matriz das similaridades de Jaccard
%   - threshold: limiar da distância
% Retorna:
%   - pairs: cell array com os pares similares
function pairs = simPairs(data, testData, J, threshold)
    N = size(data, 1);

    pairs = cell(1,3);
    n = 1;
    for n1= 1:N
        if J(n1) <= threshold
            pairs(n, :) = {0, n1, J(n1)};
            n = n+1;
        end
    end

    % Ordernar baseado nas distâncias
    pairs = sortrows(pairs, 3);
end