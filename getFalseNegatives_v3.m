% Esta função calcula o número de falsos negativos de cada bloom filter (deverá ser 0)
% Argumentos:
%   - BFs: cell array com os bloom filters com os ingerdientes
%          adicionados
%   - specificIng: indices dos ingredientes que aparecem num número igual ou inferior
%                  a generic_threshold categorias
%   - ingOcurrences: matriz uniqueIngridients x categorias onde em cada
%                    célula está o número total de vezes que o ingrediente aparece nas
%                    receitas da categoria
%   - uniqueIngredients: cell array com os ingredientes únicos
% Retorna:
%   - fn: cell array 1xlength(BFs) com o número de falsos negativos
%         para cada bloom filter
function fn = getFalseNegatives_v3(BFs, specificIng, ingOcurrences, uniqueIngredients, ks)
    num_specific_ingredients = length(specificIng); 
    fn = zeros(1, length(BFs));
    for i = 1:num_specific_ingredients
        ind = specificIng(i);
        % categorias em que está presente
        present_categories = find(ingOcurrences(ind, :) > 0);
        for j = present_categories
            result = BFIsMember(BFs{j}, uniqueIngredients{ind}, ks(j));
            if ~result
                fn(j) = fn(j) + result;
            end
        end
    end
end