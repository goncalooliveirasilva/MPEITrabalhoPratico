% Verifica quantos ingredientes são reconhecidos em cada Bloom filter.
% Argumentos:
%   - BFs: cell array com os filtros de Bloom
%   - ingredients: cell array com os ingredientes da receita
%   - ks: array com o s valores otimos de k de cada Bloom filter
% Devolve:
%   - recognizedIngredients: array com o número de ingredientes
%                            reconhecidos em cada Bloom filter
function [recognizedIngredients] = checkTheWholeRecipe(BFs, ingredients, ks)
    B = length(BFs);
    N = length(ingredients);
    recognizedIngredients = zeros(1, B);
    for i = 1:B
        for j = 1:N 
            r = BFIsMember(BFs{i}, ingredients{j}, ks(i));
            recognizedIngredients(i) = recognizedIngredients(i) + r;
        end
    end
end