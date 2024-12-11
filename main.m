%% NAÏVE BAYES
clear
clc
rng("shuffle")

load("dataToNaiveBayes.mat")
data_split = 0.8; % Percentagem dos dados que são para treino

perm = randperm(length(categories), length(categories));

% Dados de treino (90% dos dados totais)
train_data = data(perm(1:ceil(length(categories)*data_split)), :);
train_categories = categories(perm(1:ceil(length(categories)*data_split)));

% Dados de teste (10% dos dados totais)
test_data = data(perm((ceil(length(categories)*data_split) + 1): length(categories)), :);
test_categories = categories(perm((ceil(length(categories)*data_split) + 1): length(categories)));

% Obter matriz de probabilidades
[categories_unique, base_probs, probs] = getProbabilities(data, categories);

% Obter TP, TN, FP e FN
confElements = NaiveBayesConfElements(test_data, test_categories, categories_unique, base_probs, probs);

% Obter Precision, Recall, F1
prf = NaiveBayesErrorData(confElements);

% num_errors = NaiveBayesErrors(data, categories, categories_unique, base_probs, probs);
% fprintf("Numero de errados: %d\n", num_errors);

%% BLOOM FILTER

% bloom filter vai indicar se a receita pertence a alguma das categorias
% cada categoria tem o seu BF
% determinar n 
% k_otimo = n*ln(2)/m
% Pfp = (1-exp(-km/n))^k

clc;
%k_otimo = ceil(n*log(2)/m);

% número de receitas de cada categoria
num_recipes_for_category = numRecipesForCategory(train_categories);

% criação dos bloom filters
[BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, 0.001, 1000000);

% Inserção das receitas no respetivo bloom filter
BFs = addRecipesToBloomFilters(BFs, n, ks, train_data, categories, uniqueIngredients);


%%


function ir = naoSei(BFs, test_categories, test_data, ks, categories_unique, uniqueIngredients, v)
    arr = zeros(length(test_categories), 1);
    ing = cell(length(test_categories), 1);
    ir = 0;
    for i = 1:length(test_categories)
        ingredients = uniqueIngredients(test_data(i, :) == 1);
        ing{i} = ingredientsToStr(ingredients);
        [isMember, ~] = checkIfRecipeIsKnown(BFs, ingredients, ks, categories_unique, v);
        arr(i) = isMember;
        if ~isMember
            ir = ir + 1;
        end
    end

end


% Teste receitas (dados  teste) inconclusivas (estão em mais que um bloom filter)
ir = naoSei(BFs, test_categories, test_data, ks, categories_unique, uniqueIngredients, 1);
fprintf('RECEITAS INCONCLUSIVAS V1: %d\n', ir);

% Teste falsos negativos
fn = getFalseNegatives(BFs, test_data, test_categories, uniqueIngredients, ks);
fprintf('FALSOS NEGATIVOS\n');
disp(fn); % tudo 0's como é suposto


%% BlOOM FILTER VERSÃO 2

% número de receitas de cada categoria
num_recipes_for_category = numRecipesForCategory(train_categories);

% criação dos bloom filters
[BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, 0.001, 1000000);

%$ adicionar receitas aos filtros não correspondentes

function [BFs] = addRecipesToBloomFilters_v2(BFs, n, ks, data, categories, uniqueIngredients)
    % Esta função adiciona as receitas aos bloom filters que não
    % correspondem à categoria da receita
    % Argumentos:
    %   - BFs: cell array com os bloom filters (output da função createAllBloomFilters)
    %   - n: array com o tamanho de cada bloom filter (output da função createAllBloomFilters)
    %   - ks: array com o s valores otimos de m
    %   - data: matriz lógica dos ingredientes em cada receita
    %   - categories: cell array com as categorias de cada receita
    %   - uniqueIngredients: cell array com os ingredientes todos
    % Devolve:
    %   - BFs: cell array com os bloom filters com as receitas adicionadas
    B = length(BFs);
    cat_unique = unique(categories);
    for i = 1:length(data)
        % ingredientes e categoria de cada receita
        ingredients = uniqueIngredients(data(i, :) == 1);
        category = categories(i);
        % str para a hashfunction
        str = ingredientsToStr(ingredients);
        % em qual bloom filter não inserir?
        indice = find(cat_unique == category);
        % adicionar aos bloom filters não correspondentes
        for j = 1:B
            if j ~= indice
                BFs{j} = BFAddElement(BFs{j}, n(j), str, ks(j));
            end
        end
    end
end

% Inserção das receitas no respetivo bloom filter
BFs = addRecipesToBloomFilters_v2(BFs, n, ks, train_data, train_categories, uniqueIngredients);


% Teste receitas (dados  teste) inconclusivas (estão em mais que um bloom filter)
ir = naoSei(BFs, test_categories, test_data, ks, categories_unique, uniqueIngredients, 2);
fprintf('RECEITAS INCONCLUSIVAS V2: %d\n', ir);

% Teste falsos negativos
fn = getFalseNegatives(BFs, test_data, test_categories, uniqueIngredients, ks);
fprintf('FALSOS NEGATIVOS\n');
disp(fn); % tudo 0's como é suposto




%% MINHASH
clear
clc

load("dataset.mat")

% Valor aleatório para testar
% test_index = randi(length(uniqueIngredients));
% test_category = full_data{test_index, 2};
% test_ingredients = full_data{test_index, 1};
% test_data = full_data(test_index, :);

n_disp = 100;
shingle_size = 3;
limiar = 0.4;

% Assinaturas
sigs = minhash(full_data, n_disp, shingle_size);
sig_test = minhash(test_data, n_disp, shingle_size);

% Distâncias de Jaccaard
J = jaccardDistances(sigs, sig_test, n_disp);

% Pares similares
pairs = simPairs(full_data, test_data, J, limiar);

% Faz print de um elemento. Provavelmente vai sair daqui ou parar de existir no futuro
function printElement(el, ending)
    if nargin < 2
        ending = "\n";
    end

    fprintf('%s: {%s}%s', el{2}, join(string(el{1}), ', '));
    fprintf(ending);
end

% Print dos pares
for pairIdx=1:size(pairs, 1)
    fprintf("Par nº %d:\n", pairIdx)
    if pairs{pairIdx, 1} == 0
        printElement(test_data)
    end

    printElement(full_data(pairs{pairIdx, 2}, :))

    fprintf("Distância: %f\n\n", pairs{pairIdx, 3})
end
