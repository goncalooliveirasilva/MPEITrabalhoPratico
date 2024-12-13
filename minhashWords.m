% Utiliza o método minhash para obter as assinaturas de data. (usa as palavras completas em vez de shingles)
% Argumentos:
%   - data: conjunto dos documentos
%   - k: número de funções de dispersão
% Retorna:
%   - sigs: matriz de assinaturas (linhas: documentos; colunas: números das funções de dispersão)
function sigs = minhashWords(data, k)
    N = size(data, 1);
    sigs = inf(N, k);

    % Fazer o hash dos shingles de cada dado
    for n1=1:N
        dado = data{n1, 1};

        % Hash individual de cada ingrediente
        for n2=1:length(dado)
            ingredient = [dado{n2}];
            
            % Hashing e minhash
            hash_vals = string2hash_2(ingredient, k);
            sigs(n1, :) = min(sigs(n1, :), hash_vals);
        end
    end
end