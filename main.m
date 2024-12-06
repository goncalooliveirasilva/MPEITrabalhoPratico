1%% NAÏVE BAYES
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
%k_otimo = ceil(n*log(2)/m);

% número de receitas de cada categoria
num_recipes_for_category = numRecipesForCategory(categories);

[BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, 0.001);

% Inserção das receitas no respetivo bloom filter
BFs = addRecipesToBloomFilters(BFs, n, ks, data, categories, uniqueIngredients);

%% MINHASH
clear
clc
rng("shuffle")

load("dataset.mat")

% Valor aleatório para testar
test_index = randi(length(uniqueIngredients));
test_category = full_data{test_index, 2};
test_ingredients = full_data{test_index, 1};
test_data = full_data(test_index, :);

n_disp = 100;
shingle_size = 3;
limiar = 0.4;

% Assinaturas
sigs = minhash(full_data, n_disp, shingle_size);
sig_test = minhash(test_data, n_disp, shingle_size);

% Distâncias de Jaccaard
J = jaccardDistances(sigs, sig_test, n_disp);

% Pares similares
pairs = simPairs(full_data, test_data, J, limiar);