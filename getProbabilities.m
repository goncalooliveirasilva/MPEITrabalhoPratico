% Calcula as probabilidades para o Naïve Bayes.
% Argumentos:
%   - ingredientData: matriz binária com os dados de cada receita
%   - categories: array com as categorias
% Retorna:
%   - categories_unique: vetor com as categorias únicas (probs e base_probs seguem a ordem de categorias deste vetor)
%   - base_probs: vetor de probabilidades de cada categoria
%   - probs: vetor de probabilidades de cada ingrediente para cada categoria
function [categories_unique, base_probs, probs] = getProbabilities(ingredientData, categories)
    % Inicializar
    categories_unique = unique(categories);
    base_probs = zeros(size(categories_unique));
    probs = zeros(length(categories_unique), size(ingredientData, 2));

    for i=1:length(categories_unique)
        base_probs(i) = sum(categories == categories_unique(i))/length(categories);     % Probabilidades de obter a categoria
        data = sum(ingredientData(categories == categories_unique(i), :));              % Soma de todas as receitas da categoria
        probs(i, :) = (data + 1) / (sum(data) + size(data, 2));                         % Calcular probabilidades com Laplace smoothing
    end
end