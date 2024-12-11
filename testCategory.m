function [cat, prob]=testCategory(recipe, categories_unique, base_probs, probs)
    % Retorna a categoria a que pertence recipe, com a sua probabilidade
    prob = -inf;
    cat = "NULL";
    for i=1:length(categories_unique)
        % Calcular probabilidade para a imagem e categoria
        new_prob = sum(log(probs(i, recipe==1))) + log(base_probs(i));
        % fprintf("Categoria a testar: %s (Probabilidade: %f)\n", categories_unique(i), new_prob)
        % Nova probabilidade maxima
        if new_prob >= prob
            prob = new_prob;
            cat = categories_unique(i);
            % fprintf("Aceite!\n\n")
        end
    end
end