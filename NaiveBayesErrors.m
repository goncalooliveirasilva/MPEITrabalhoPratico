function [num_errors] = NaiveBayesErrors(data, categories, categories_unique, base_probs, probs)
    % Esta função devolve o número de classificações erradas do
    % classificador Naive Bayes
    num_errors = 0;
    for test_index=1:length(categories)
        [cat, ~] = testCategory(data(test_index, :), categories_unique, base_probs, probs);
        if cat ~= categories(test_index)
            num_errors = num_errors + 1;
        end
    end
end