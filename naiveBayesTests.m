% Testes para o Naïve Bayes

clear
clc
rng("shuffle")

load("dataToNaiveBayes.mat")
data_split = 0.8; % Percentagem dos dados que são para treino

% ------------------------------------------------------------------
% Médias da precisão, recall, f1

num_iter = 10;
prf = cell(1, num_iter);
for i = 1:num_iter
    perm = randperm(length(categories));
    
    % Dados de treino
    train_data = data(perm(1:ceil(length(categories)*data_split)), :);
    train_categories = categories(perm(1:ceil(length(categories)*data_split)));
    
    % Dados de teste
    test_data = data(perm((ceil(length(categories)*data_split) + 1): length(categories)), :);
    test_categories = categories(perm((ceil(length(categories)*data_split) + 1): length(categories)));
    
    % Obter probabilidades
    [categories_unique, base_probs, probs] = getProbabilities(train_data, train_categories);
    num_categories_unique = length(categories_unique);

    % Obter TP, TN, FP e FN
    confElements = naiveBayesConfElements(test_data, test_categories, categories_unique, base_probs, probs);
    
    % Obter Precision, Recall, F1
    prf{i} = naiveBayesErrorData(confElements);
end

% Calcular média
precisions = cellfun(@(x) cellfun(@(y) y(1), x), prf, "UniformOutput", false);
precisions_means = zeros(1, num_categories_unique);

recalls = cellfun(@(x) cellfun(@(y) y(2), x), prf, "UniformOutput", false);
recalls_means = zeros(1, num_categories_unique);

f1s = cellfun(@(x) cellfun(@(y) y(3), x), prf, "UniformOutput", false);
f1s_means = zeros(1, num_categories_unique);

for i = 1:num_categories_unique
    precisions_means(i) = mean(cellfun(@(x) x(i), precisions));
    recalls_means(i) = mean(cellfun(@(x) x(i), recalls));
    f1s_means(i) = mean(cellfun(@(x) x(i), f1s));
end

fprintf("Médias: \n")
for i = 1:num_categories_unique
    fprintf("%s:\n", categories_unique(i))
    fprintf(" - Precisão: %f\n", precisions_means(i))
    fprintf(" - Recall: %f\n", recalls_means(i))
    fprintf(" - F1: %f\n", f1s_means(i))
end
% ------------------------------------------------------------------


% ------------------------------------------------------------------
% Gráficos em ordem a percentagem de dados de treino
splits = 0.1:0.1:0.8;
prf2 = cell(1, length(splits));
for i = 1:length(splits)
    split = splits(i);
    perm = randperm(length(categories));
    
    % Dados de treino
    train_data = data(perm(1:ceil(length(categories)*split)), :);
    train_categories = categories(perm(1:ceil(length(categories)*split)));
    
    % Dados de teste
    test_data = data(perm((ceil(length(categories)*split) + 1): length(categories)), :);
    test_categories = categories(perm((ceil(length(categories)*split) + 1): length(categories)));
    
    % Obter probabilidades
    [categories_unique, base_probs, probs] = getProbabilities(train_data, train_categories);
    num_categories_unique = length(categories_unique);

    % Obter TP, TN, FP e FN
    confElements = naiveBayesConfElements(test_data, test_categories, categories_unique, base_probs, probs);
    
    % Obter Precision, Recall, F1
    prf2{i} = naiveBayesErrorData(confElements);
end

precisions = cellfun(@(x) cellfun(@(y) y(1), x), prf2, "UniformOutput", false);
precisions_by_category = cell(1, num_categories_unique);

recalls = cellfun(@(x) cellfun(@(y) y(2), x), prf2, "UniformOutput", false);
recalls_by_category = cell(1, num_categories_unique);

f1s = cellfun(@(x) cellfun(@(y) y(3), x), prf2, "UniformOutput", false);
f1s_by_category = cell(1, num_categories_unique);

for i = 1:num_categories_unique
    precisions_by_category{i} = cellfun(@(x) x(i), precisions);
    recalls_by_category{i} = cellfun(@(x) x(i), recalls);
    f1s_by_category{i} = cellfun(@(x) x(i), f1s);
end

for i = 1:num_categories_unique
    subplot(2, 3, i)
    hold on
    plot(splits, precisions_by_category{i}, "-r")
    plot(splits, recalls_by_category{i}, "-g")
    plot(splits, f1s_by_category{i}, "-b")
    title("Dados para " + string(categories_unique(i)))
    xlabel("Percentagem de dados de treino")
    ylabel("Precisão / Recall / F1")
    legend("Precisão", "Recall", "F1")
    xlim([0.2 0.8])
    ylim([0 1])
    hold off
end
