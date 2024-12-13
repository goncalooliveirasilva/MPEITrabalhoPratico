% Converte o dataset numa array lógica para usar no Naïve Bayes e no Bloom Filter

clear
clc

load("dataset.mat")

categories = categorical(full_data(:, 2));
data = zeros(size(full_data, 1), length(uniqueIngredients));

for i=1:size(full_data, 1)
    ingredientsList = full_data{i, 1};
    for ingindex=1:length(ingredientsList)
        ingredient = ingredientsList(ingindex);
        ingredient = [ingredient{:}];
        
        data(i, :) = data(i, :) + strcmp(uniqueIngredients, ingredient)';        
    end
end

save("dataToNaiveBayes.mat", "data", "categories", "uniqueIngredients")
