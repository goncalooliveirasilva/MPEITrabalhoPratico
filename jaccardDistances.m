% Calcula as distâncias de Jaccard de uma matriz de assinaturas.
% Argumentos:
%   - sigs: matriz de assinaturas
%   - k: número de funções de dispersão
% Retorina:
%    - J: matriz das distânicas
function J = jaccardDistances(sigs, k)
    J = zeros(N);
    for n1=1:(N-1)
        for n2=(n1+1):N
            J(n1, n2) = sum(sigs(n1, :)~=sigs(n2, :))/k;
        end
    end
end