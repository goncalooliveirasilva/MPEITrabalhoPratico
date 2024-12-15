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

% ingredientes que aparecem em 3 ou mais categorias são excluídos
generic_threshold = 3;

threshold = 0.3;
prob_falsos_positivos = 0.001;
acertos_bloom_filter = 0;
avaliacoes_bloom_filter = 0;

% divisão dos ingredientes
[specificIng, genericIng, ingOccurrences] = prepareDataForBFs_v3(train_data, train_categories, generic_threshold);
num_categories_unique = length(categories_unique);
m_BFs = getNumElementsForBFsv3(specificIng, ingOccurrences, num_categories_unique);

% Criação dos bloom filters
[BFs, ks, n] = createAllBloomFilters_v3(m_BFs, prob_falsos_positivos);

% Inserção dos ingredientes
[BFs, ~, ~] = addIngredientsToBloomFilters_v3(BFs, n, ks, specificIng, ingOccurrences, uniqueIngredients);


% MINHASH
load("dataset.mat")

n_disp = 100;
shingle_size = 3;
limiar = 0.8;
limiar_resultado = 0.5; 

% Função anónima para fazer print de um elemento.
printElement = @(el) fprintf('%s: {%s}\n', el{2}, join(string(el{1}), ', '));

% Número de receitas acertadas corretamente
n_acertos = 0;

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

    % BLOOM FILTERS
    
    % ingredientes presentes na receita
    ingredients = uniqueIngredients(recipe_data == 1);

    % número de ingredientes da receita
    numIngredients = length(ingredients);

    % quantos ingredientes são reconhecidos em cada bloom filter
    recognizedIngredients = checkTheWholeRecipe(BFs, ingredients, ks);

    % resultado da etapa
    result = decideRecipeBF_v3_m1(recognizedIngredients, numIngredients, threshold);
    if result ~= 0
        % suposta categoria da receita
        category = categories_unique(result);
        fprintf("Bloom Filter: origem: %s\n", category);
        fprintf("\nRESULTADO:\n");
        if strcmp(string(category), recipe_data_minhash{1, 2})
            n_acertos = n_acertos + 1;
            acertos_bloom_filter = acertos_bloom_filter + 1;
            fprintf("Acertou!\n\n")
        else
            fprintf("Falhou...\n\n");
        end
        avaliacoes_bloom_filter = avaliacoes_bloom_filter + 1;
        continue;
    end

    fprintf("Bloom Filter: origem: inconclusivo\n");


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
        n_acertos = n_acertos + 1;
        fprintf("Acertou!\n\n")
    else
        fprintf("Falhou...\n\n")
    end
end

fprintf("%d das %d receitas foram classificadas corretamente.\n", n_acertos, n_test_elements)
fprintf("Bloom Filter acertou %d receitas de %d avaliadas.\n", acertos_bloom_filter, avaliacoes_bloom_filter)