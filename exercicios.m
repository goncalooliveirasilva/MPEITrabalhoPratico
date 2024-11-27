clear
clc

% a)
csv_data = readcell("PL5Ex2.xlsx");

palavras = regexp(csv_data{1}, "\s*;\s*", "split");
palavras = palavras(2:(end-1));

dados = regexp(csv_data(2:end), "\s*;\s*", "split");
for c=1:length(dados)
    dados{c} = dados{c}(2:(end-1));
    dados{c} = str2double(dados{c});
end
dados = cell2mat(dados);

categorias = regexp(csv_data(2:end), "\s*;\s*", "split");
for c=1:length(categorias)
    categorias{c} = cell2mat(categorias{c}(end));
end


% b)
aux = randperm(length(dados)); % Array com os indices em ordem aleatoria

categorias_treino = categorias(aux(1:(length(categorias)*0.7)), :);
dados_treino = dados(aux(1:(length(dados)*0.7)), :);

categorias_teste = categorias(aux((length(categorias)*0.7)+1:end), :);
dados_teste = dados(aux((length(dados)*0.7)+1:end), :);


% c)
prob_spam = sum(strcmp("SPAM", categorias_teste))/length(categorias);
prob_ok = sum(strcmp("OK", categorias_teste))/length(categorias);


% d)
dados_spam = sum(dados_treino(strcmp("SPAM", categorias_treino), :));
dados_ok = sum(dados_treino(strcmp("OK", categorias_treino), :));

probs_spam_treino = dados_spam / sum(dados_spam);
probs_ok_treino = dados_ok / sum(dados_ok);


% e)
probs_spam_teste = zeros(length(dados)*0.3, 1);
for c=1:length(probs_spam_teste)
    probs_spam_teste(c) = prod(probs_spam_treino(dados_teste(c, :) == 1)) * prob_spam;
end


probs_ok_teste = zeros(length(dados)*0.3, 1);
for c=1:length(probs_ok_teste)
    probs_ok_teste(c) = prod(probs_ok_treino(dados_teste(c, :) == 1)) * prob_ok;
end

categorias_estimadas = cell(length(dados)*0.3, 1);
for c=1:length(categorias_estimadas)
    categorias_estimadas{c} = 'SPAM';
    if probs_ok_teste(c) > probs_spam_teste(c)
        categorias_estimadas{c} = 'OK';
    end
end

% f)
% precision = tp / (tp + fp)
% recall = tp / (tp + fn)
% f1 = 2*precision*recall / (precision + recall)

tp = sum(strcmp("SPAM", categorias_estimadas) & strcmp("SPAM", categorias_teste));
fp = sum(strcmp("SPAM", categorias_estimadas) & strcmp("OK", categorias_teste));
fn = sum(strcmp("OK", categorias_estimadas) & strcmp("SPAM", categorias_teste));
tn = sum(strcmp("OK", categorias_estimadas) & strcmp("OK", categorias_teste));

precisao = tp / (tp + fp);
recall = tp / (tp + fn);
f1 = 2*precisao*recall / (precisao + recall);

fprintf("Precisao: %f\n", precisao);
fprintf("Recall: %f\n", recall);
fprintf("F1: %f\n", f1);


