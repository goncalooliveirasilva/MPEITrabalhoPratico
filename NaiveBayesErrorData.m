% Retorna uma cell array com os dados da precisão, recall e f1 para cada categoria.
function prf = NaiveBayesErrorData(confElements)
    n_cats = length(confElements);
    prf = cell(1, n_cats); % Precision, Recall e F1
    for i = 1:n_cats
        data = zeros(1, 3);
        aux = confElements{i};
        data(1) = aux(1)/(aux(1) + aux(3)); % precisão
        data(2) = aux(1)/(aux(1) + aux(4)); % recall
        data(3) = (2 * data(1) * data(2)) / (data(1) + data(2)); % f1
        prf{i} = data;
    end
end
