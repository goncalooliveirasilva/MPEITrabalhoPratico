% Utiliza o método minhash para obter as assinaturas de data.
% Argumentos:
%   - data: conjunto dos documentos
%   - k: número de funções de dispersão
%   - shingle_size: tamanho de cada shingle
% Retorna:
%   - sigs: matriz de assinaturas (linhas: documentos; colunas: números das funções de dispersão)
function sigs = minhash(data, k, shingle_size)
    N = size(data, 1);
    sigs = inf(N, k);

    % Fazer o hash dos shingles de cada dado
    for n1=1:N
        dado = data{n1, 1};

        % Hash individual de cada ingrediente
        for n2=1:length(dado)
            ingredient = [dado{n2}];

            n_shingles = length(ingredient)-shingle_size+1;
            for i=1:n_shingles
                % Obter shingle
                shingle = ingredient(i:(i+shingle_size-1));
                
                % Hashing e minhash
                hash_vals = string2hash_2(shingle, k);
                sigs(n1, :) = min(sigs(n1, :), hash_vals);
            end
        end
    end
end