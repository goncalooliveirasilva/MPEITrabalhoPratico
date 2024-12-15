%% NAÏVE BAYES
clear
clc
rng("shuffle")

load("dataToNaiveBayes.mat")
data_split = 0.8; % Percentagem dos dados que são para treino

[train_data, train_categories, test_data, test_categories] = getTrainAndTestData(data_split, data, categories);

% Obter matriz de probabilidades
[categories_unique, base_probs, probs] = getProbabilities(train_data, train_categories);

% Obter TP, TN, FP e FN
confElements = NaiveBayesConfElements(test_data, test_categories, categories_unique, base_probs, probs);

% Obter Precision, Recall, F1
prf = NaiveBayesErrorData(confElements);

% num_errors = NaiveBayesErrors(data, categories, categories_unique, base_probs, probs);
% fprintf("Numero de errados: %d\n", num_errors);

%% BLOOM FILTER VERSÃO 1

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
[BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, 0.001);

% Inserção das receitas no respetivo bloom filter 

% ALTERAR PARA A OUTRA FUNÇÃO
[BFs, ~, ~] = addRecipesToBloomFilters_v1(BFs, n, ks, train_data, train_categories, uniqueIngredients);



%% BlOOM FILTER VERSÃO 2

% número de receitas de cada categoria
num_recipes_for_category = numRecipesForCategory(train_categories);

% criação dos bloom filters
[BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, 0.001);

% adicionar receitas aos filtros não correspondentes
[BFs, ~, ~] = addRecipesToBloomFilters_v2(BFs, n, ks, train_data, train_categories, uniqueIngredients);



%% BLOOM FILTER VERSÃO 3
% Inserir ingredientes em vez de receitas

% dados treino
% 7 bloom filters
% 6 com as categorias habituais e 1 com ingredientes genéricos, 
% que aparecem em todas os várias categorias

% são considerados ingredientes genéricos ingredientes que aparecem
% em generic_threshold ou mais categorias
generic_threshold = 3;
[specificIng, genericIng, ingOccurrences] = prepareDataForBFs_v3(train_data, train_categories, generic_threshold);

num_categories_unique = length(categories_unique);
m_BFs = getNumElementsForBFsv3(specificIng, ingOccurrences, num_categories_unique);

% Criar os bloom filters
[BFs, ks, n] = createAllBloomFilters_v3(m_BFs, 0.001);

% Inserção dos ingredientes
[BFs, ~, ~] = addIngredientsToBloomFilters_v3(BFs, n, ks, specificIng, ingOccurrences, uniqueIngredients);

% determinar falsos negativos
fn = getFalseNegatives_v3(BFs, specificIng, ingOccurrences, uniqueIngredients, ks);
fprintf('FALSOS NEGATIVOS V3\n');
disp(fn); % tudo 0's como é suposto

%%
% mecanismo para testar as receitas de teste
% método 1 - ver a receita toda em cada filtro e ver qual deles identifica
% mais ingredientes

% recognizedIngredients = checkTheWholeRecipe(BFs, uniqueIngredients(train_data(4, :) == 1), ks);
% numIngredients = length(uniqueIngredients(train_data(4, :) == 1));
% result = decideRecipeBF_v3_m1(recognizedIngredients, numIngredients, 0.3);

% teste com receitas de teste
threshold = 0.4;
num_test_recipes = length(test_categories);
receitas_acertadas = 0;
receitas_inconclusivas = 0;
receitas_classificadas_incorretas = 0;
for i = 1:num_test_recipes
    recognizedIngredients = checkTheWholeRecipe(BFs, uniqueIngredients(test_data(i, :) == 1), ks);
    numIngredients = length(uniqueIngredients(test_data(i, :) == 1));
    result = decideRecipeBF_v3_m1(recognizedIngredients, numIngredients, threshold);
    if result ~= 0
        if test_categories(i) == categories_unique(result)
            receitas_acertadas = receitas_acertadas + 1;
        else
            receitas_classificadas_incorretas = receitas_classificadas_incorretas + 1;
        end
    else
        receitas_inconclusivas = receitas_inconclusivas + 1;
    end
end

fprintf('\n');
fprintf('Generic Threshold: %d\n', generic_threshold);
fprintf('Threshold: %f\n', threshold);
fprintf('Nº receitas de teste: %d\n', num_test_recipes);
fprintf('Nº receitas classificadas corretamente (BF v3-m1): %d\n', receitas_acertadas);
fprintf('Nº receitas inconclusivas (BF v3-m1): %d\n', receitas_inconclusivas);
fprintf('Nº receitas classificadas incorretamente (BF v3-m1): %d\n', receitas_classificadas_incorretas);



%%
% método 2 - analisar cada ingrediente individualmente, ver que filtro o
% reconhece e depois ver qual a categoria mais frequente entre os
% ingredientes

% r = 100;
% ingredients = uniqueIngredients(test_data(r, :) == 1);
% ingredientsProbableCategory = checkIngedientByIngredient(BFs, ingredients, ks);
% 
% 
% numIngredients = length(ingredients);
% % sem threshold
% result = decideRecipeBF_v3_m2(ingredientsProbableCategory, numIngredients);
% fprintf('categoria verdadeira: %s\n', test_categories(r));
% fprintf('categoria provável: %s\n', categories_unique(result));

% teste com receitas de teste
threshold = 0.4;
num_test_recipes = length(test_categories);
receitas_acertadas = 0;
receitas_inconclusivas = 0;
receitas_classificadas_incorretas = 0;
for i = 1:num_test_recipes
    ingredients = uniqueIngredients(test_data(i, :) == 1);
    ingredientsProbableCategory = checkIngedientByIngredient(BFs, ingredients, ks);
    numIngredients = length(ingredients);
    result = decideRecipeBF_v3_m2(ingredientsProbableCategory, numIngredients, threshold);
    if result ~= 0
        if test_categories(i) == categories_unique(result)
            receitas_acertadas = receitas_acertadas + 1;
        else
            receitas_classificadas_incorretas = receitas_classificadas_incorretas + 1;
        end
    else
        receitas_inconclusivas = receitas_inconclusivas + 1;
    end
end

fprintf('\n');
fprintf('Threshold: %f\n', threshold);
fprintf('Nº receitas de teste: %d\n', num_test_recipes);
fprintf('Nº receitas classificadas corretamente (BF v3-m2): %d\n', receitas_acertadas);
fprintf('Nº receitas inconclusivas (BF v3-m2): %d\n', receitas_inconclusivas);
fprintf('Nº receitas classificadas incorretamente (BF v3-m2): %d\n', receitas_classificadas_incorretas);

%% MINHASH
clear
clc
rng("shuffle")

load("dataset.mat")

data_split = 0.8; % Percentagem dos dados que são para treino

n_recipes = size(full_data, 1);
perm = randperm(n_recipes);

% Dados de treino
train_data = full_data(perm(1 : ceil(n_recipes*data_split)), :);

% Dados de teste
test_data = full_data(perm((ceil(n_recipes*data_split) + 1) : n_recipes), :);


n_disp = 100;
shingle_size = 3;
limiar = 0.4;

% Assinaturas
sigs = minhash(train_data, n_disp, shingle_size);
sigs_test = minhash(test_data, n_disp, shingle_size);
%sigs = minhashWords(train_data, n_disp);
%sigs_test = minhashWords(test_data, n_disp);

% Distâncias de Jaccaard
J = jaccardDistances(sigs, sigs_test, n_disp);

% Pares similares
pairs = simPairs(train_data, test_data, J, limiar);

% Faz print de um elemento. Provavelmente vai sair daqui ou parar de existir no futuro
%function printElement(el, ending)
%    if nargin < 2
%        ending = "\n";
%    end
%
%    fprintf('%s: {%s}%s', el{2}, join(string(el{1}), ', '));
%    fprintf(ending);
%end

% Print dos pares
for pairIdx=1:size(pairs, 1)
    fprintf("Par nº %d:\n", pairIdx)

    printElement(train_data(pairs{pairIdx, 1}, :))
    printElement(test_data(pairs{pairIdx, 2}, :))

    fprintf("Distância: %f\n\n", pairs{pairIdx, 3})
end


%% DEMONSTRAÇÃO CONJUNTA
clear
clc
rng("shuffle")

n_test_elements = 5;

% NAÏVE BAYES E BLOOM FILTERS
load("dataToNaiveBayes.mat")

perm = randperm(length(categories));

% Dados de treino
train_data = data(perm(1:(end-n_test_elements)), :);
train_categories = categories(perm(1:(end-n_test_elements)));

% Dados de teste
test_data = data(perm((end-n_test_elements + 1): end), :);
test_categories = categories(perm((end-n_test_elements + 1): end));

% Obter matriz de probabilidades (naïve bayes)
[categories_unique, base_probs, probs] = getProbabilities(train_data, train_categories);

%%%%%%%---------------------------------------------------------
%%%%%%% Código para criar os filtros meter os dados de treino lá


%%%%%%%---------------------------------------------------------

% MINHASH
load("dataset.mat")

n_disp = 100;
shingle_size = 3;
limiar = 0.8;
limiar_resultado = 0.5; 

% Função anónima para fazer print de um elemento.
printElement = @(el) fprintf('%s: {%s}\n', el{2}, join(string(el{1}), ', '));

% Número de receitas acertadas corretamente
n_certos = 0;

% Dados de treino
train_data_minhash = full_data(perm(1:(end-n_test_elements)), :);
train_categories_minhash = categories(perm(1:(end-n_test_elements)));

% Dados de teste
test_data_minhash = full_data(perm((end-n_test_elements + 1): end), :);
test_categories_minhash = categories(perm((end-n_test_elements + 1): end));

% Assinaturas
sigs_train = minhashBoth(train_data_minhash, n_disp, shingle_size);

for test_data_idx = 1:size(test_data, 1)
    recipe_data = test_data(test_data_idx, :);
    recipe_data_minhash = test_data_minhash(test_data_idx, :);

    fprintf("Receita a testar:\n")
    printElement(recipe_data_minhash)

    %%%%%%%-----------------------------------------------------
    %%%%%%% Código para testar o elemento com o bloom filter

    %%% Se não houver problemas, dar a resposta.
    %%% Se houver, continuar.
    %%% Meter uns prints a falar do resultado (se é inconclusivo, etc)
    %%%%%%%-----------------------------------------------------

    % NAÏVE BAYES
    [cat, prob] = testCategory(recipe_data, categories_unique, base_probs, probs);
    fprintf("Naïve Bayes: origem calculada: %s\n\n", cat)
    
    % recipe_data = test_data;
    % recipe_data_minhash = test_data_minhash;

    % MINHASH
    sig_test = minhashBoth(recipe_data_minhash, n_disp, shingle_size);

    % Distâncias de Jaccaard
    J = jaccardDistances(sigs_train, sig_test, n_disp);

    % Pares similares
    pairs = simPairs(train_data_minhash, recipe_data_minhash, J, limiar);
    fprintf("Pares similares: A receita mais similar tem distância %f:\n", pairs{1, 3})
    printElement(train_data_minhash(pairs{1, 1}, :))


    % Resultado
    fprintf("\nRESULTADO:\n")
    if pairs{1, 3} <= limiar_resultado
        cat_resultado = train_data_minhash{pairs{1, 1}, 2};
    else
        cat_resultado = cat;
    end
    fprintf("A receita classifica-se como %s\n", cat_resultado)

    if strcmp(string(cat_resultado), recipe_data_minhash{1, 2})
        n_certos = n_certos + 1;
        fprintf("Acertou!\n\n")
    else
        fprintf("Falhou...\n\n")
    end
end

fprintf("%d das %d receitas foram classificadas corretamente.", n_certos, n_test_elements)