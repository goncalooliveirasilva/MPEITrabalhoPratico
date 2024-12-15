% Obtém um conjunto de dados de treino e de teste baseados num limiar.
% Argumentos:
%   - data_split: percentagem dos dados totais para treino
%   - data: conjunto completo dos dados
%   - categories: conjunto das categorias
% Retorna:
%   - train_data: dados de treino
%   - train_categories: categorias de treino
%   - test_data: dados de teste
%   - test_categories: categorias de teste
function [train_data, train_categories, test_data, test_categories] = getTrainAndTestData(data_split, data, categories)
    perm = randperm(length(categories));
    % Dados de treino
    train_data = data(perm(1:ceil(length(categories)*data_split)), :);
    train_categories = categories(perm(1:ceil(length(categories)*data_split)));
    % Dados de teste
    test_data = data(perm((ceil(length(categories)*data_split) + 1): length(categories)), :);
    test_categories = categories(perm((ceil(length(categories)*data_split) + 1): length(categories)));
end