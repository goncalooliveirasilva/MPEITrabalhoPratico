% Verifica ingrediente a ingrediente a qual bloom filter
% ele pertence. Se um ingrediente pertencer a mais que um filtro, conta
% apenas o primeiro filtro que registou a presença.
% Argumentos:
%   - BFs: cell array com os filtros de bloom
%   - ingredients: cell array com os ingredientes da receita
%   - ks: array com o s valores otimos de k de cada bloom filter
% Retorna:
%   - ingredientsProbableCategory: array com os indices das categorias dos ingredientes
function ingredientsProbableCategory = checkIngedientByIngredient(BFs, ingredients, ks)
    B = length(BFs);
    N = length(ingredients);
    ingredientsProbableCategory = zeros(1, N);
    for j = 1:N
        for k = 1:B
            r = BFIsMember(BFs{k}, ingredients{j}, ks(k));
            if r
                ingredientsProbableCategory(j) = k;
                break;
            end
        end
    end
end