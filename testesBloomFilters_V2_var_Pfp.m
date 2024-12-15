%% TESTES BLOOM FILTER VERSÃO 2
clear; clc;

% Nesta análise variamos a probabilidade de falsos positivos. 
% A função responsável pela inserção das receitas nos bloom filters calcula
% internamente os valores ótimos de k e os valores de n. Como tal, cada
% filtro, dependendo do número de receitas que lhe serão adicionadas terá
% uma dimensão (n) e um número de hashfunctions (k) ajustado.
% Nesta verão inserimos em cada bloom filter as receitas que não pertencem
% à categoria desse blomo filter. Se a receita não pertencer a apenas um
% bloom filter, a sua categoria será a desse filtro. Se não pertencer a
% mais que 1, a categoria não é identificada.
% Vão sendo impressos na consola os parâmetros de cada iteração mais detalhadamente. 
% No final são criados alguns gráficos para se perceber mais fácilmente o
% comportamento dos parâmetros avaliados.


% Parâmetros a variar:
% Pfp_s: probabilidade de falsos positivos

Pfp_s = [0.15 0.14 0.11 0.1 0.05 0.01 0.005 0.001 0.0001];

% load: data, categories, uniqueIngerdients
load("dataToNaiveBayes.mat");
data_split = 0.8; % 80 % são dados de treino
[train_data, train_categories, test_data, test_categories] = getTrainAndTestData(data_split, data, categories);
num_recipes_for_category = numRecipesForCategory(train_categories);
categories_unique = unique(categories);
num_categories_unique = length(categories_unique);


fprintf('===== TESTES BLOOM FILTER VERSÃO 2 =====\n');
fprintf('N E K SÃO CALCULADOS PELAS EXPRESSÕES TEÓRICAS\n');
num_Pfp_s = length(Pfp_s);
falsos_positivos = zeros(1, num_Pfp_s);
colisoes = cell(1, num_Pfp_s);
dimensoes = cell(1, num_Pfp_s);
num_hashfunctions = cell(1, num_Pfp_s);
receitas_corretas = zeros(1, num_Pfp_s);
receitas_incorretas = zeros(1, num_Pfp_s);
tempos_verificacao = zeros(1, num_Pfp_s);
len_tc = length(test_categories);

for i = 1:num_Pfp_s
    Pfp = Pfp_s(i);
    [BFs, ks, n] = createAllBloomFilters(num_recipes_for_category, Pfp);
    % Inserir as receitas de treino no bloom filter correspondente à sua
    % categoria
    dimensoes{i} = n;
    num_hashfunctions{i} = ks;
    [BFs, k_keys, collisions_counts] = addRecipesToBloomFilters_v1(BFs, n, ks, train_data, train_categories, uniqueIngredients);
    colisoes{i} = collisions_counts;
    % colisões e número máximo de atribuições na mesma posição
    colisoes_table = array2table(collisions_counts);
    colisoes_table.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
    % verificação receitas inconcluisvas
    % receitas que pertencem a mais que um bloom filter
    numRecipes = getInconclusiveRecipes(BFs, test_categories, test_data, ks, categories_unique, uniqueIngredients, 2);
    % funcionamento com receitas de teste
    num_test_recipes = length(test_categories);
    receitas_acertadas = 0;
    receitas_classificadas_incorretas = 0;
    tic;
    for j = 1:num_test_recipes
        ingredients = uniqueIngredients(test_data(j, :) == 1);
        [isMember, category] = checkIfRecipeIsKnown(BFs, ingredients, ks, categories_unique, 2);
        if isMember
           if category == test_categories(j)
               receitas_acertadas = receitas_acertadas + 1;
           else
                receitas_classificadas_incorretas = receitas_classificadas_incorretas + 1;
            end
        end
    end
    temp = toc;
    tempos_verificacao(i) = temp;
    % verificação de falsos positivos
    fp = receitas_classificadas_incorretas;
    falsos_positivos(i) = fp;
    receitas_corretas(i) = receitas_acertadas;
    receitas_incorretas(i) = receitas_classificadas_incorretas;
    % verificação de falsos negativos
    fn = getFalseNegatives(BFs, test_data, test_categories, uniqueIngredients, ks);
    fn = array2table(fn);
    fn.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
    dims = array2table(n);
    dims.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
    hf = array2table(ks);
    hf.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
    fprintf('\n');
    fprintf('Pfp = %d\n', Pfp);
    fprintf('Nº RECEITAS DE TESTE: %d\n', num_test_recipes);
    fprintf('RECEITAS INCONCLUSIVAS: %d\n', numRecipes);
    fprintf('RECEITAS IDENTIFICADAS NOS BLOOM FILTERS: %d\n', (len_tc - numRecipes));
    fprintf('RECEITAS IDENTIFICADAS CORRETAMENTE: %d\n', receitas_acertadas);
    fprintf('RECEITAS IDENTIFICADAS INCORRETAMENTE: %d\n', receitas_classificadas_incorretas);
    fprintf('FALSOS POSITIVOS: %d\n', fp);
    fprintf('VERDADEIROS NEGATIVOS: %d\n', numRecipes);
    fprintf('FALSOS NEGATIVOS:\n');
    disp(fn);
    fprintf('COLISÕES POR FILTRO:\n');
    disp(colisoes_table); 
    fprintf('DIMENSÃO DOS FILTROS (n):\n');
    disp(dims);
    fprintf('Nº HASHFUNCTIONS (k) DOS FILTROS:\n');
    disp(hf);
    fprintf('\n');
end

% Resultados
sum_colisoes = zeros(num_Pfp_s, 1);
for ind = 1:num_Pfp_s
    sum_colisoes(ind) = sum(colisoes{ind});
end

fprintf('\n');
fprintf('==== RESULTADOS MÉDIOS ====\n');
fprintf('> Média falsos positivos: %f\n', mean(falsos_positivos));
fprintf('> Média colisões: %f\n', mean(sum_colisoes));
fprintf('> Média receitas corretas: %f\n', mean(receitas_corretas));
fprintf('> Média receitas incorretas: %f\n', mean(receitas_incorretas));
fprintf('> Média tempo verificação receitas: %f\n', mean(tempos_verificacao));

% gráfico falsos positivos
figure;
hold on;
plot(Pfp_s, falsos_positivos, '-o', 'LineWidth', 1);
xlabel('Probabilidade falsos positivos');
ylabel('falsos positivos');
title('Número Falsos Positivos (BF-v1)');
hold off;
grid on;
grid minor;

% gráfico colisoes
figure;
hold on;
plot(Pfp_s, sum_colisoes, '-o', 'LineWidth', 1);
xlabel('Probabilidade falsos positivos');
ylabel('colisões');
title('Número Colisões Totais (BF-v1)');
hold off;
grid on;
grid minor;

% gráfico receitas corretas
figure;
hold on;
plot(Pfp_s, receitas_corretas, '-o', 'LineWidth', 1);
xlabel('Probabilidade falsos positivos');
ylabel('Receitas Corretas');
title('Número Receitas Corretas (BF-v1)');
hold off;
grid on;
grid minor;

% gráfico receitas incorretas
figure;
hold on;
plot(Pfp_s, receitas_incorretas, '-o', 'LineWidth', 1);
xlabel('Probabilidade falsos positivos');
ylabel('Receitas Incorretas');
title('Número Receitas Incorretas (BF-v1)');
hold off;
grid on;
grid minor;

% gráfico tempos
figure;
hold on;
plot(Pfp_s, tempos_verificacao, '-o', 'LineWidth', 1);
xlabel('Probabilidade falsos positivos');
ylabel('tempo (s)');
title('Tempo de Verificação das Receitas de Teste (BF-v1)');
hold off;
grid on;
grid minor;