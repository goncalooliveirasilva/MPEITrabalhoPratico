% Calcula as distâncias de Jaccard de uma matriz de assinaturas em relação a outra
% Argumentos:
%   - sigs1: matriz de assinaturas 1
%   - sigs2: matriz de assinaturas 2
%   - k: número de funções de dispersão
% Retorna:
%    - J: matriz das distânicas, tamanho NxM (N -> assinaturas de 1; M -> assinaturas de 2)
function J = jaccardDistances(sigs1, sigs2, k)
    N = size(sigs1, 1);
    M = size(sigs2, 1);

    J = zeros(N, M);
    for n1=1:N
        for n2=1:M
            J(n1, n2) = sum(sigs1(n1, :)~=sigs2(n2, :))/k;
        end
    end
end
