% Obtém o conjunto de pares mais similares, baseado num limiar.
% Argumentos:
%   - data: conjunto dos documentos
%   - J: matriz das similaridades de Jaccard
%   - threshold: limiar da distância
% Retorna:
%   - pairs: cell array com os pares similares
function pairs = simPairs(data, J, threshold)
    pairs = cell(1,3);
    n = 1;
    for n1= 1:N
        for n2= n1+1:N
            if J(n1, n2) <= threshold
                pairs(n, :) = {data(n1), data(n2), J(n1,n2)};
                n = n+1;
            end
        end
    end

    % Ordernar baseado nas distâncias
    pairs = sortrows(pairs, 3);
end