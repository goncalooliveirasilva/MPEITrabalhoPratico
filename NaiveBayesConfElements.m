function confElements = NaiveBayesConfElements(data, categories, categories_unique, base_probs, probs)
    % Esta função devolve as componentes da matriz de confusão do Naïve Bayes.
    confElements = cell(1, length(categories_unique));
    conf_matrix = zeros(length(categories_unique));


    % Popular a matriz de confusão
    for test_index=1:length(categories)
        [cat, ~] = testCategory(data(test_index, :), categories_unique, base_probs, probs);

        conf_matrix(categories_unique == cat, categories_unique == categories(test_index)) = conf_matrix(categories_unique == cat, categories_unique == categories(test_index)) + 1;
    end

    for i=1:length(confElements)
        elements = zeros(1, 4);
        % 1 -> TP
        % 2 -> TN
        % 3 -> FP
        % 4 -> FN
        elements(1) = conf_matrix(i, i);
        elements(2) = sum(conf_matrix(setdiff(1:end,i), setdiff(1:end,i)), "all");
        
        elements(3) = sum(conf_matrix(setdiff(1:end,i), i), "all");
        elements(4) =  sum(conf_matrix(i, setdiff(1:end,i)), "all");

        confElements{i} = elements;
    end
end