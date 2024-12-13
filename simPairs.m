% Obtém o conjunto de pares mais similares de dois documentos, baseado num limiar.
% Argumentos:
%   - data1: conjunto dos documentos 1
%   - data2: conjunto dos documentos 2
%   - J: matriz das similaridades de Jaccard
%   - threshold: limiar da distância
% Retorna:
%   - pairs: cell array com os pares similares
function pairs = simPairs(data1, data2, J, threshold)
    N = size(data1, 1);
    M = size(data2, 1);

    pairs = cell(1,3);
    n = 1;
    for n1 = 1:N
        for n2 = 1:M
            if J(n1, n2) <= threshold
                pairs(n, :) = {n1, n2, J(n1, n2)};
                n = n+1;
            end
        end
    end

    % Ordernar baseado nas distâncias
    pairs = sortrows(pairs, 3);
end