clear
clc

% Load the JSON data
data = jsondecode(fileread('train.json'));

wanted_cuisines = {
    'chinese'
    'mexican'
    'italian'
    'french'
    'indian'
    'brazilian'
};
max_ingredients = 1500;

% Initialize containers
cuisines = {};
ingredients = {};

full_data = cell(0);

num_recipes = 0;

% Loop through the JSON objects
for i = 1:length(data)
    % Collect cuisine
    if any(strcmp(wanted_cuisines, data(i).cuisine))
        add = 1;
        for ing=1:length(data(i).ingredients)
            ingr = data(i).ingredients(ing);
            ingr = [ingr{:}];
            if numel(strsplit(ingr)) > 2
                add = 0;
                break
            end
        end
        if add == 1
            full_data(end+1, :) = {data(i).ingredients, data(i).cuisine};
            num_recipes = num_recipes + 1;
            cuisines{end+1} = data(i).cuisine;
            ingredients = [ingredients; data(i).ingredients];
        end
    end
    
    uniqueIngredients = unique(ingredients);
    numIngredients = numel(uniqueIngredients);
    if numIngredients > max_ingredients
        break
    end
end

% Count unique cuisines
uniqueCuisines = unique(cuisines);
numCuisines = numel(uniqueCuisines);

% Count unique ingredients
uniqueIngredients = unique(ingredients);
numIngredients = numel(uniqueIngredients);

fprintf('Number of unique cuisines: %d\n', numCuisines);
fprintf('Number of recipes: %d\n', num_recipes);
fprintf('Number of unique ingredients: %d\n', numIngredients);

%%
save("dataset.mat", "full_data", "uniqueIngredients")