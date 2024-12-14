% Calcula as componentes da matriz de confusão do Naïve Bayes.
% Argumentos:
%   - data: matriz de dados
%   - categories: matriz das categorias para cada dado
%   - categories_unique: vetor com as categorias únicas (probs e base_probs seguem a ordem de categorias deste vetor)
%   - base_probs: vetor de probabilidades de cada categoria
%   - probs: vetor de probabilidades de cada ingrediente para cada categoria
% Retorna:
%   - confElements: cell array com uma matriz para cada categoria da forma:
%       [TP TN FP FN]
function confElements = NaiveBayesConfElements(data, categories, categories_unique, base_probs, probs)
    % Inicializar
    confElements = cell(1, length(categories_unique));
    conf_matrix = zeros(length(categories_unique));

    % Popular a matriz de confusão multiclass
    for test_index=1:length(categories)
        [cat, ~] = testCategory(data(test_index, :), categories_unique, base_probs, probs);
        
        % Adicionar 1 aos valores relativos à categoria calculada e à dada
        conf_matrix(categories_unique == cat, categories_unique == categories(test_index)) = conf_matrix(categories_unique == cat, categories_unique == categories(test_index)) + 1;
    end

    % Calcular os componentes para cada categoria
    for i=1:length(confElements)
        elements = zeros(1, 4);
        % 1 -> TP
        % 2 -> TN
        % 3 -> FP
        % 4 -> FN
        elements(1) = conf_matrix(i, i);
        elements(2) = sum(conf_matrix(setdiff(1:end,i), setdiff(1:end,i)), "all");
        
        elements(3) = sum(conf_matrix(setdiff(1:end,i), i), "all");
        elements(4) =  sum(conf_matrix(i, setdiff(1:end,i)), "all");

        confElements{i} = elements;
    end
end