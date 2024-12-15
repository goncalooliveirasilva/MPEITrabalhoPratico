%% Correr este código antes de cada teste
clear
clc
rng("shuffle")
load("dataset.mat")

data_split = 0.8;                   % Percentagem dos dados que são para treino

n_recipes = size(full_data, 1);

n_disp = 50;       % Funções de dispersão
shingle_size = 3;   % Número de caracteres de cada shingle
limiar = 0.4;       % Limiar da disttância dos pares similares

n_pairs = 15;        % Número de pares similares para comparar

%% Teste 1 (comparar versões)

n_tests = 10;                          % Número de testes a fazer
test_corretos = cell(1, 3);             % Número de testes corretos_v1 para cada versão em cada teste
test_corretos{1} = zeros(1, n_tests);
test_corretos{2} = zeros(1, n_tests);
test_corretos{3} = zeros(1, n_tests);

for test = 1:n_tests
    fprintf("Teste nº%d\n", test)
    
    perm = randperm(n_recipes);

    % Dados de treino
    train_data = full_data(perm(1 : ceil(n_recipes*data_split)), :);

    % Dados de teste
    test_data = full_data(perm((ceil(n_recipes*data_split) + 1) : n_recipes), :);

    for v = 1:3
        % Assinaturas
        if v == 1
            sigs = minhash(train_data, n_disp, shingle_size);
            sigs_test = minhash(test_data, n_disp, shingle_size);
        elseif v == 2
            sigs = minhashWords(train_data, n_disp);
            sigs_test = minhashWords(test_data, n_disp);
        else
            sigs = minhashBoth(train_data, n_disp, shingle_size);
            sigs_test = minhashBoth(test_data, n_disp, shingle_size);
        end

        % Distâncias de Jaccard
        J = jaccardDistances(sigs, sigs_test, n_disp);

        % Pares similares
        pairs = simPairs(train_data, test_data, J, limiar);
        pairs = pairs(1:n_pairs, :);
        
        for pairIdx=1:size(pairs, 1)
            elem1 = train_data(pairs{pairIdx, 1}, :);
            elem2 = test_data(pairs{pairIdx, 2}, :);

            if strcmp(elem1{2}, elem2{2}) == 1
                test_corretos_v = test_corretos{v};
                test_corretos_v(test) = test_corretos_v(test) + 1;
                test_corretos{v} = test_corretos_v;
            end
        end
        % Função anónima para fazer print de um elemento.
        %printElement = @(el) fprintf('%s: {%s}\n', el{2}, join(string(el{1}), ', '));
        
        % Print dos pares
        %for pairIdx=1:size(pairs, 1)
        %    fprintf("Par nº %d:\n", pairIdx)
        %
        %    printElement(train_data(pairs{pairIdx, 1}, :))
        %    printElement(test_data(pairs{pairIdx, 2}, :))
        %
        %    fprintf("Distância: %f\n\n", pairs{pairIdx, 3})
        %end
    end
end

test_corretos_mean = cellfun(@(x) mean(x), test_corretos);
disp(test_corretos_mean)

%% Teste 2 (gráfico)

n_disp_range = 20:20:160;
corretos_v1 = zeros(1, length(n_disp_range));
corretos_v2 = zeros(1, length(n_disp_range));
corretos_v3 = zeros(1, length(n_disp_range));

perm = randperm(n_recipes);

% Dados de treino
train_data = full_data(perm(1 : ceil(n_recipes*data_split)), :);

% Dados de teste
test_data = full_data(perm((ceil(n_recipes*data_split) + 1) : n_recipes), :);

for v = 1:3
    fprintf("Versão %d\n", v)
    for dispIdx = 1:length(n_disp_range)
        n_disp = n_disp_range(dispIdx);

        fprintf("Funções de dispersão: %d\n", n_disp)

        perm = randperm(n_recipes);

        % Assinaturas
        if v == 1
            sigs = minhash(train_data, n_disp, shingle_size);
            sigs_test = minhash(test_data, n_disp, shingle_size);
        elseif v == 2
            sigs = minhashWords(train_data, n_disp);
            sigs_test = minhashWords(test_data, n_disp);
        else
            sigs = minhashBoth(train_data, n_disp, shingle_size);
            sigs_test = minhashBoth(test_data, n_disp, shingle_size);
        end

        % Distâncias de Jaccard
        J = jaccardDistances(sigs, sigs_test, n_disp);

        % Pares similares
        pairs = simPairs(train_data, test_data, J, limiar);
        pairs = pairs(1:n_pairs, :);

        for pairIdx=1:size(pairs, 1)
            elem1 = train_data(pairs{pairIdx, 1}, :);
            elem2 = test_data(pairs{pairIdx, 2}, :);

            if strcmp(elem1{2}, elem2{2}) == 1
                if v == 1
                    corretos_v1(dispIdx) = corretos_v1(dispIdx) + 1;
                elseif v == 2
                    corretos_v2(dispIdx) = corretos_v2(dispIdx) + 1;
                else
                    corretos_v3(dispIdx) = corretos_v3(dispIdx) + 1;
                end        
            end
        end
    end
end

hold on
for v = 1:3
    if v == 1
        plot(n_disp_range, corretos_v1, "-r")
    elseif v == 2
        plot(n_disp_range, corretos_v2, "-g")
    else
        plot(n_disp_range, corretos_v3, "-b")
    end
end
xlabel("Funções de hash")
ylabel("Pares corretos (máximo = " + n_pairs + ")")
title("Número de pares corretos em função do número de funções de hash (versão " + v + ")")
legend("Versão 1", "Versão 2", "Versão 3")
hold off
