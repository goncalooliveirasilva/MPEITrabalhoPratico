%% TESTES BLOOM FILTER VERSÃO 3 MÉTODO 2
clear; clc;

% Nesta análise variamos a probabilidade de falsos positivos e o threshold,
% que corresponde à percentagem de ingredientes da receita que devem ser
% reconhecidos. 
% No método 2 analisamos ingrediente a ingrediente qual filtro o reconhece
% e depois vemos qual a categoria mais presente entre os ingredientes.
% Ingredientes que apareçam em 3 ou mais receitas são considerados ingedientes genéricos e
% são excluídos (não são inseridos nos filtros). 
% Se a categoria maias presente entre os ingredientes for em número igual ou superior ao produto do
% número de ingredientes da receita pelo threshold, então a categoria da
% receita será a categoria mais presente. 
% A categoria do ingrediente corresponde à categoria do primeiro filtro que
% o identificou.
% Os dados para teste são selecionados aleatóriamente, pelo que em
% diferentes execuções deste script ocorrem ligeiras variações, mas que não
% produzem grande impacto na avaliação deste método.
% Vão sendo impressos na consola os parâmetros de cada iteração mais detalhadamente. 
% No final são criados alguns gráficos para se perceber mais fácilmente o
% comportamento dos parâmetros avaliados. Aparecem ainda alguns valores
% médios com o objetivo de se perceber de um modo geral a resposta da
% abordagem à variação dos parâmetros.



% Parâmetros a variar:
% Pfp_s: probabilidade de falsos positivos
% thesholds

Pfp_s = [0.15 0.1 0.05 0.01 0.001];
thresholds = [0.7 0.6 0.5 0.55 0.45 0.4 0.3];

% load: data, categories, uniqueIngerdients
load("dataToNaiveBayes.mat");
data_split = 0.8; % 80 % são dados de treino
[train_data, train_categories, test_data, test_categories] = getTrainAndTestData(data_split, data, categories);
num_recipes_for_category = numRecipesForCategory(train_categories);
categories_unique = unique(categories);
num_categories_unique = length(categories_unique);

fprintf('===== TESTES BLOOM FILTER VERSÃO 3 M2 =====\n');
fprintf('N E K SÃO CALCULADOS PELAS EXPRESSÕES TEÓRICAS\n');
num_Pfp_s = length(Pfp_s);
num_thresholds = length(thresholds);
falsos_positivos = zeros(num_thresholds, num_Pfp_s);
colisoes = cell(num_thresholds, num_Pfp_s);
dimensoes = cell(num_thresholds, num_Pfp_s);
num_hashfunctions = cell(num_thresholds, num_Pfp_s);
receitas_corretas = zeros(num_thresholds, num_Pfp_s);
receitas_incorretas = zeros(num_thresholds, num_Pfp_s);
tempos_verificacao = zeros(num_thresholds, num_Pfp_s);
len_tc = length(test_categories);

% são considerados ingredientes genéricos ingredientes que aparecem
% em generic_threshold ou mais categorias
generic_threshold = 3;

for i = 1:num_Pfp_s
    for k = 1:num_thresholds
        Pfp = Pfp_s(i);
        threshold = thresholds(k);

        [specificIng, genericIng, ingOccurrences] = prepareDataForBFs_v3(train_data, train_categories, generic_threshold);
        m_BFs = getNumElementsForBFsv3(specificIng, ingOccurrences, num_categories_unique);
        [BFs, ks, n] = createAllBloomFilters_v3(m_BFs, Pfp);
        dimensoes{k, i} = n;
        num_hashfunctions{k, i} = ks;
        % Inserção dos ingredientes
        [BFs, k_keys, collisions_counts] = addIngredientsToBloomFilters_v3(BFs, n, ks, specificIng, ingOccurrences, uniqueIngredients);
        colisoes{k, i} = collisions_counts;
        % colisões e número máximo de atribuições na mesma posição
        colisoes_table = array2table(collisions_counts);
        colisoes_table.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
        num_test_recipes = length(test_categories);
        receitas_acertadas = 0;
        receitas_inconclusivas = 0;
        receitas_classificadas_incorretas = 0;
        tic;
        for j = 1:num_test_recipes
            ingredients = uniqueIngredients(test_data(j, :) == 1);
            ingredientsProbableCategory = checkIngedientByIngredient(BFs, ingredients, ks);
            numIngredients = length(ingredients);
            result = decideRecipeBF_v3_m2(ingredientsProbableCategory, numIngredients, threshold);
            if result ~= 0
                if test_categories(j) == categories_unique(result)
                    receitas_acertadas = receitas_acertadas + 1;
                else
                    receitas_classificadas_incorretas = receitas_classificadas_incorretas + 1;
                end
            else
                receitas_inconclusivas = receitas_inconclusivas + 1;
            end
        end
        temp = toc;
        % verificação de falsos positivos
        fp = receitas_classificadas_incorretas;
        tempos_verificacao(k, i) = temp;
        falsos_positivos(k, i) = fp;
        receitas_corretas(k, i) = receitas_acertadas;
        receitas_incorretas(k, i) = receitas_classificadas_incorretas;
        % verificação de falsos negativos
        fn = getFalseNegatives(BFs, test_data, test_categories, uniqueIngredients, ks);
        fn = array2table(fn);
        fn.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
        dims = array2table(n);
        dims.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
        hf = array2table(ks);
        hf.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
        fprintf('\n');
        fprintf('Pfp = %.3f; threshold = %.3f\n', Pfp, threshold);
        fprintf('Nº RECEITAS DE TESTE: %d\n', num_test_recipes);
        fprintf('RECEITAS INCONCLUSIVAS: %d\n', receitas_inconclusivas);
        fprintf('RECEITAS IDENTIFICADAS NOS BLOOM FILTERS: %d\n', fp);
        fprintf('RECEITAS IDENTIFICADAS CORRETAMENTE: %d\n', receitas_acertadas);
        fprintf('RECEITAS IDENTIFICADAS INCORRETAMENTE: %d\n', receitas_classificadas_incorretas);
        fprintf('FALSOS POSITIVOS: %d\n', fp);
        fprintf('VERDADEIROS NEGATIVOS: %d\n', receitas_inconclusivas);
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
end



% Resultados
fprintf('\n');
fprintf('==== RESULTADOS MÉDIOS ====\n');

% médias de receitas corretas e incorretas
media_rc_thres = mean(receitas_corretas, 2);
media_ri_thres = mean(receitas_incorretas, 2);
media_rc_Pfp = mean(receitas_corretas, 1);
media_ri_Pfp = mean(receitas_incorretas, 1);

figure;
bar(thresholds, [media_rc_thres, media_ri_thres], 'grouped');
xlabel('threshold');
ylabel('média de Receitas');
legend('corretas', 'incorretas');
title('Médias de Receitas para Valores de threshold (BF-V3-M2)');
grid on;
figure;
bar(Pfp_s, [media_rc_Pfp', media_ri_Pfp'], 'grouped');
xlabel('probabilidade falsos positivos');
ylabel('média de Receitas');
legend('corretas', 'incorretas');
title('Médias de Receitas Para Valores de Pfp (p. falsos positivos) (BF-V3-M2)');
grid on;

sum_colisoes = zeros(num_thresholds, num_Pfp_s);
for t_ind = 1:size(sum_colisoes, 1)
    for p_ind = 1:size(sum_colisoes, 2)
        sum_colisoes(t_ind, p_ind) = sum(colisoes{t_ind, p_ind});
    end
end

m_receitas_corretas = mean(receitas_corretas(:));
m_receitas_incorretas = mean(receitas_incorretas(:));
m_falsos_positivos = mean(falsos_positivos(:));
fprintf('> Média falsos positivos: %f\n', m_falsos_positivos);
fprintf('> Média colisões: %f\n', mean(sum_colisoes(:)));
fprintf('> Média receitas corretas: %f\n', m_receitas_corretas);
fprintf('> Média receitas incorretas: %f\n', m_receitas_incorretas);
fprintf('> Média tempo verificação receitas: %f\n', mean(tempos_verificacao(:)));
fprintf('> RELAÇÃO ENTRE RECEITAS CORRETAS E INCORRETAS: %.3f\n', m_receitas_corretas/m_receitas_incorretas);


% gráfico falsos positivos
figure;
hold on;
for i = 1:num_thresholds
    plot(Pfp_s, falsos_positivos(i, :), '-o', 'DisplayName', sprintf('threshold = %.3f', thresholds(i)));
end
xlabel('probabilidade falsos positivos');
ylabel('falsos positivos');
title('Número Falsos Positivos (BF-V3-M2)');
legend('show');
hold off;
grid on;
grid minor;

% gráfico colisoes
figure;
hold on;
for i = 1:num_thresholds
    plot(Pfp_s, sum_colisoes(i, :), '-o', 'DisplayName', sprintf('threshold = %.3f', thresholds(i)));
end
xlabel('probabilidade falsos positivos');
ylabel('colisões');
title('Número Colisões Totais (BF-V3-M2)');
legend('show');
hold off;
grid on;
grid minor;


% gráfico receitas corretas
figure;
hold on;
for i = 1:num_thresholds
    plot(Pfp_s, receitas_corretas(i, :), '-o', 'DisplayName', sprintf('threshold = %.3f', thresholds(i)));
end
xlabel('probabilidade falsos positivos');
ylabel('Receitas Corretas');
title('Número Receitas Corretas (BF-V3-M2)');
legend('show');
hold off;
grid on;
grid minor;

% gráfico receitas incorretas
figure;
hold on;
for i = 1:num_thresholds
    plot(Pfp_s, receitas_incorretas(i, :), '-o', 'DisplayName', sprintf('threshold = %.3f', thresholds(i)));
end
xlabel('probabilidade falsos positivos');
ylabel('Receitas Incorretas');
title('Número Receitas Incorretas (BF-V3-M2)');
legend('show');
hold off;
grid on;
grid minor;

% gráfico tempos
figure;
hold on;
for i = 1:num_thresholds
    plot(Pfp_s, tempos_verificacao(i, :), '-o', 'DisplayName', sprintf('threshold = %.3f', thresholds(i)));
end
xlabel('probabilidade falsos positivos');
ylabel('tempo (s)');
title('Tempo de Verificação das Receitas de Teste (BF-V3-M2)');
legend('show');
hold off;
grid on;
grid minor;