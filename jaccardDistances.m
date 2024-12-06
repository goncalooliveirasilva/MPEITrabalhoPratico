% Calcula as distâncias de Jaccard de uma matriz de assinaturas em relação a um documento.
% Argumentos:
%   - sigs: matriz de assinaturas
%   - testDoc: vetor assinatura do documento de teste
%   - k: número de funções de dispersão
% Retorna:
%    - J: matriz das distânicas
function J = jaccardDistances(sigs, testDoc, k)
    N = size(sigs, 1);

    J = zeros(N, 1);
    for n1=1:N
        J(n1) = sum(sigs(n1, :)~=testDoc)/k;        
    end
end