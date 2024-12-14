function [train_data, train_categories, test_data, test_categories] = getTrainAndTestData(data_split, data, categories)
    perm = randperm(length(categories));
    % Dados de treino
    train_data = data(perm(1:ceil(length(categories)*data_split)), :);
    train_categories = categories(perm(1:ceil(length(categories)*data_split)));
    % Dados de teste
    test_data = data(perm((ceil(length(categories)*data_split) + 1): length(categories)), :);
    test_categories = categories(perm((ceil(length(categories)*data_split) + 1): length(categories)));
end