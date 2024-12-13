% Guarda os dados do ficheiro json num dataset

clear
clc

% Carregar dados
data = jsondecode(fileread('train.json'));

% Dados de filtragem
wanted_cuisines = {                 % Cozinhas que se quer
    'chinese'
    'mexican'
    'italian'
    'french'
    'indian'
    'brazilian'
};
max_ingredients = 3500;             % Limite para o número de ingredientes
filter_ingredient_words = true;
max_ingredient_words = 4;

cuisines = {};
ingredients = {};

full_data = cell(0);

num_recipes = 0;

% Ciclar pelos objetos JSON
for i = 1:length(data)
    % Collect cuisine
    if any(strcmp(wanted_cuisines, data(i).cuisine))
        add = 1;

        % Filtrar ingredientes se tiverem demasiadas palavras
        if filter_ingredient_words
            for ing=1:length(data(i).ingredients)
                ingr = data(i).ingredients(ing);
                ingr = [ingr{:}];
                if numel(strsplit(ingr)) > max_ingredient_words
                    add = 0;
                    break
                end
            end
        end

        if add == 1
            % Colocar array de ingredientes e cozinha nos dados
            full_data(end+1, :) = {data(i).ingredients, data(i).cuisine};
            num_recipes = num_recipes + 1;
            cuisines{end+1} = data(i).cuisine;
            ingredients = [ingredients; data(i).ingredients];
        end
    end
    
    % Parar o loop se o número de ingredientes passar do máximo
    uniqueIngredients = unique(ingredients);
    numIngredients = numel(uniqueIngredients);
    if numIngredients > max_ingredients
        break
    end
end

% -----------------------------
% OBTER ÚNICOS

% Ordenar os ingredientes de cada cell array
ingredients_sorted = cellfun(@(x) sort(x), full_data(:, 1), 'UniformOutput', false);

% Colocar os ingredients ordenados no full_data
full_data(:, 1) = ingredients_sorted;

% Transformar cada linha numa só string para remover duplicados
rowsAsStrings = cellfun(@(x) [strjoin(x{1}, ',') ',' x{2}], num2cell(full_data, 2), 'UniformOutput', false);

% Obter únicos
[uniqueRows, idx] = unique(rowsAsStrings);

% Colocar nos dados apenas os únicos
full_data = full_data(idx, :);
% -----------------------------


% Cozinhas únicas
uniqueCuisines = unique(cuisines);
numCuisines = numel(uniqueCuisines);

% Ingredientes únicos
uniqueIngredients = unique(ingredients);
numIngredients = numel(uniqueIngredients);

fprintf('Cozinhas únicas: %d\n', numCuisines);
fprintf('Número de receitas: %d\n', num_recipes);
fprintf('Ingredientes únicos: %d\n', numIngredients);

%% Guardar dataset
save("dataset.mat", "full_data", "uniqueIngredients")