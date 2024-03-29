function [L] = log_lik_fs_2(delta_b, X)
%We need dist, student_id, choice
%COLUMN ORDER: 1 mkt, 2 school id, 3, student_id, 4 choice, 5 outside, 10
%dist, dummies 20
% dist : 1
% student_id:  2
% choice: 3
y = X(X(:, 4) == 1, :);

beta = delta_b(1:4);
delta = delta_b(5:size(delta_b,2));
log_proba = exp(beta(1)*y(:, 3) + beta(2)*y(:, 4) + beta(3)*y(:,5) + ...
    beta(4)*y(:,6) + y(:,8:size(X,2))*delta');

for i = 1:size(y,1)
    log_proba(i) = log(log_proba(i) / denominador2(delta_b, X, y(i,2)));
end
L = -sum(log_proba);
end