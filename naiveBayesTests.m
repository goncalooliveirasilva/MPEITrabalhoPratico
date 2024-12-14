clear
clc
rng("shuffle")

load("dataToNaiveBayes.mat")
data_split = 0.8; % Percentagem dos dados que são para treino

perm = randperm(length(categories));

% Dados de treino
train_data = data(perm(1:ceil(length(categories)*data_split)), :);
train_categories = categories(perm(1:ceil(length(categories)*data_split)));

% Dados de teste
test_data = data(perm((ceil(length(categories)*data_split) + 1): length(categories)), :);
test_categories = categories(perm((ceil(length(categories)*data_split) + 1): length(categories)));

% Obter probabilidades
[categories_unique, base_probs, probs] = getProbabilities(train_data, train_categories);

% Obter TP, TN, FP e FN
confElements = NaiveBayesConfElements(test_data, test_categories, categories_unique, base_probs, probs);

% Obter Precision, Recall, F1
prf = NaiveBayesErrorData(confElements);
