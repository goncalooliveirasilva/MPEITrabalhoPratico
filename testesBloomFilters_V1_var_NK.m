%% TESTES BLOOM FILTER VERSÃO 1
clear; clc;

% Nesta análise variamos a dimensão ds filtros (n) e o número de
% hashfunctions (k). 
% Em cada iteração, os 6 filtros têm o mesmo valor de k.
% Vão sendo impressos na consola os parâmetros de cada iteração mais detalhadamente. 
% No final são criados alguns gráficos para se perceber mais fácilmente o
% comportamento dos parâmetros avaliados. Aparecem ainda alguns valores
% médios com o objetivo de se perceber de um modo geral a resposta da
% abordagem à variação dos parâmetros.

% Parâmetros a variar:
% k - nº hashfunctions
% a - nº de vezes que o tamanho do filtro será maior que o número de
% elementos que irá conter

k_values = 1:15;
a_values = 8:15;


% load: data, categories, uniqueIngerdients
load("dataToNaiveBayes.mat");
data_split = 0.8; % 80 % são dados de treino
[train_data, train_categories, test_data, test_categories] = getTrainAndTestData(data_split, data, categories);
num_recipes_for_category = numRecipesForCategory(train_categories);
categories_unique = unique(categories);
num_categories_unique = length(categories_unique);
m_s = zeros(1, num_categories_unique); 
for i = 1:num_categories_unique
    m_s(i) = sum(test_categories == categories_unique(i));
end

fprintf('===== TESTES BLOOM FILTER VERSÃO 1 =====\n');
fprintf('OS FILTROS TÊM TODOS OS MESMOS VALORES DE K E N\n')

num_a_values = length(a_values);
num_k_values = length(k_values);
falsos_positivos = zeros(num_a_values, num_k_values);
colisoes = cell(num_a_values, num_k_values);
receitas_corretas = zeros(num_a_values, num_k_values);
receitas_incorretas = zeros(num_a_values, num_k_values);
tempos_verificacao = zeros(num_a_values, num_k_values);
len_tc = length(test_categories);
for a_ind = 1:num_a_values
    for k_ind = 1:num_k_values

        a = a_values(a_ind);
        k_value = k_values(k_ind);

        n = a*m_s;
        ks = k_value * ones(1, num_categories_unique);

        [BFs] = createAllBloomFiltersWithSpecificNK(n, num_categories_unique);
        % Inserir as receitas de treino no bloom filter correspondente à sua
        % categoria
        [BFs, k_keys, collisions_counts] = addRecipesToBloomFilters_v1(BFs, n, ks, train_data, train_categories, uniqueIngredients);
        colisoes{a_ind, k_ind} = collisions_counts;
        % colisões e número máximo de atribuições na mesma posição
        colisoes_table = array2table(collisions_counts);
        colisoes_table.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
        % verificação receitas inconcluisvas
        % receitas que pertencem a mais que um bloom filter
        numRecipes = getInconclusiveRecipes(BFs, test_categories, test_data, ks, categories_unique, uniqueIngredients, 1);
        % funcionamento com receitas de teste
        num_test_recipes = length(test_categories);
        receitas_acertadas = 0;
        receitas_classificadas_incorretas = 0;
        tic;
        for i = 1:num_test_recipes
            ingredients = uniqueIngredients(test_data(i, :) == 1);
            [isMember, category] = checkIfRecipeIsKnown(BFs, ingredients, ks, categories_unique, 1);
            if isMember
                if category == test_categories(i)
                    receitas_acertadas = receitas_acertadas + 1;
                else
                    receitas_classificadas_incorretas = receitas_classificadas_incorretas + 1;
                end
            end
        end
        temp = toc;
        tempos_verificacao(a_ind, k_ind) = temp;
        % verificação de falsos positivos
        fp = receitas_classificadas_incorretas;
        falsos_positivos(a_ind, k_ind) = fp;
        receitas_corretas(a_ind, k_ind) = receitas_acertadas;
        receitas_incorretas(a_ind, k_ind) = receitas_classificadas_incorretas;
        % verificação de falsos negativos
        fn = getFalseNegatives(BFs, test_data, test_categories, uniqueIngredients, ks);
        fn = array2table(fn);
        fn.Properties.VariableNames = ["brazillian" "chinese" "french" "indian" "italian" "mexican"];
        fprintf('\n');
        fprintf('n = %d*m; k = %d\n', a, k_value);
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
        fprintf('\n');
        disp(colisoes_table); 
    end
end

% Resultados
fprintf('\n');
fprintf('==== RESULTADOS MÉDIOS ====\n');

% médias de receitas corretas e incorretas
media_rc_a = mean(receitas_corretas, 2);
media_ri_a = mean(receitas_incorretas, 2);
media_rc_k = mean(receitas_corretas, 1);
media_ri_k = mean(receitas_incorretas, 1);

figure;
bar(a_values, [media_rc_a, media_ri_a], 'grouped');
xlabel('a');
ylabel('média de Receitas');
legend('corretas', 'incorretas');
title('Médias de Receitas para Valores de a (n = a * m) (BF-V1)');
grid on;
figure;
bar(k_values, [media_rc_k', media_ri_k'], 'grouped');
xlabel('k');
ylabel('média de Receitas');
legend('corretas', 'incorretas');
title('Médias de Receitas Para Valores de k (nº hashfunctions) (BF-V1)');
grid on;

sum_colisoes = zeros(length(a_values), length(k_values));
for a_ind = 1:size(sum_colisoes, 1)
    for k_ind = 1:size(sum_colisoes, 2)
        sum_colisoes(a_ind, k_ind) = sum(colisoes{a_ind, k_ind});
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
for i = 1:length(a_values)
    plot(k_values, falsos_positivos(i, :), '-o', 'DisplayName', sprintf('n = %d*m', a_values(i)));
end
xlabel('k');
ylabel('falsos positivos');
title('Número Falsos Positivos (BF-V1)');
legend('show');
hold off;
grid on;
grid minor;


% gráfico colisoes
figure;
hold on;
for i = 1:length(a_values)
    plot(k_values, sum_colisoes(i, :), '-o', 'DisplayName', sprintf('n = %d*m', a_values(i)));
end
xlabel('k');
ylabel('colisões');
title('Número Colisões Totais (BF-V1)');
legend('show');
hold off;
grid on;
grid minor;

% gráfico colisoes e falsos positivos
figure;
[K, A] = meshgrid(k_values, a_values); 
colors_collisions = sum_colisoes;
scatter3(K(:), A(:), falsos_positivos(:), 50, colors_collisions(:), 'filled');
hold on; 
for i = 1:numel(K)
    plot3([K(i), K(i)], [A(i), A(i)], [0, falsos_positivos(i)], 'k', 'LineWidth', 0.3);
end
hold off;
xlabel('k');
ylabel('a (n = a * m)');
zlabel('Falsos Positivos');
title('Variação dos Falsos Positivos e Nº Colisões (BF-V1)', 'FontSize', 12, 'FontWeight', 'bold');
colorbar;
clim([min(sum_colisoes(:)), max(sum_colisoes(:))]);
ylabel(colorbar, 'Número de Colisões Total');

% gráfico receitas corretas
figure;
hold on;
for i = 1:length(a_values)
    plot(k_values, receitas_corretas(i, :), '-o', 'DisplayName', sprintf('n = %d*m', a_values(i)));
end
xlabel('k');
ylabel('Receitas Corretas');
title('Número Receitas Corretas (BF-V1)');
legend('show');
hold off;
grid on;
grid minor;

% gráfico receitas incorretas
figure;
hold on;
for i = 1:length(a_values)
    plot(k_values, receitas_incorretas(i, :), '-o', 'DisplayName', sprintf('n = %d*m', a_values(i)));
end
xlabel('k');
ylabel('Receitas Incorretas');
title('Número Receitas Incorretas (BF-V1)');
legend('show');
hold off;
grid on;
grid minor;

% gráfico tempos
figure;
hold on;
for i = 1:length(a_values)
    plot(k_values, tempos_verificacao(i, :), '-o', 'DisplayName', sprintf('n = %d*m', a_values(i)));
end
xlabel('k');
ylabel('tempo (s)');
title('Tempo de Verificação das Receitas de Teste (BF-V1)');
legend('show');
hold off;
grid on;
grid minor;
