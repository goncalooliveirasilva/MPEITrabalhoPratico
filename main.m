%% NAÏVE BAYES
clear
clc

load("dataToNaiveBayes.mat")
[categories_unique, base_probs, probs] = getProbabilities(data, categories);

% load("imageTestData.mat")
% test_index = 6;
% fprintf("Categoria desejada: %s\n", categories(test_index));
% [cat, prob]=testCategory(ingredientData(test_index, :), categories_unique, base_probs, probs);
% fprintf("Categoria obtida: %s\n", cat);
% load("imageTestData.mat")

num_errors = NaiveBayesErrors(data, categories, categories_unique, base_probs, probs);
fprintf("Numero de errados: %d\n", num_errors);

%% BLOOM FILTER

% bloom filter vai indicar se a receita pertence a alguma das categorias
% cada categoria tem o seu BF
% determinar n 
% k_otimo = n*ln(2)/m
% Pfp = (1-exp(-km/n))^k
% n (fase inicial) -> 10 x m

clc;
%m = length(categories); % número receitas
%n = 15000;
%k_otimo = ceil(n*log(2)/m);

% número de receitas de cada categoria
num_recipes_for_category = numRecipesForCategory(categories);

%%
function [BFs, n, m] = allBloomFilters(num_recipes_for_category, Pfp)
    % Esta função cria um cell array que contém um bloom filter para
    % cada categoria.
    % num_recipes_for_category: numero de receitas em cada categoria
    % Pfp: objetivo de percentagem de falsos positivos
    cat_unique = length(num_recipes_for_category(:, 2));
    BFs = cell(1, cat_unique);

    % valores de m (numero de membros de cada conjunto)
    m = num_recipes_for_category(:, 2);

    % determinar os valores de n para cada filtro
    n = zeros(1, cat_unique);
    for i = 1:cat_unique
        % FORMULA INCORRETA
        n(i) = ceil(log(Pfp) / (log((1-exp(-log(2))^(log(2)/m{i})))));
    end

    % inicialização dos filtros
    for i = 1:cat_unique
        BFs{i} = BFinitialize(n(i));
    end
end

[BFs, n, m] = allBloomFilters(num_recipes_for_category, 0.05);