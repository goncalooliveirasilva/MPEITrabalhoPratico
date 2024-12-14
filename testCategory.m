% Calcula a categoria a que pertence recipe, com a sua probabilidade em forma logarítmica.
% Argumentos:
%   - recipe: vetor com a receita
%   - categories_unique: vetor com as categorias únicas (probs e base_probs seguem a ordem de categorias deste vetor)
%   - base_probs: vetor de probabilidades de cada categoria
%   - probs: vetor de probabilidades de cada ingrediente para cada categoria
% Retorna:
%   - cat: categoria a que pertence recipe
%   - prob: logaritmo da probabilidade
function [cat, prob] = testCategory(recipe, categories_unique, base_probs, probs)
    prob = -inf;
    cat = "NULL";
    for i=1:length(categories_unique)
        % Calcular probabilidade para a receita e categoria
        new_prob = sum(log(probs(i, recipe==1))) + log(base_probs(i));

        % Nova probabilidade maxima
        if new_prob >= prob
            prob = new_prob;
            cat = categories_unique(i);
        end
    end
end