function [L] = log_like(beta, X)

y = X(X(:, 11) == 1, :);

log_proba = exp((1 - y(:,2))*beta(1) + beta(2)*y(:, 4) + beta(3)*y(:, 5) + ...
            beta(4)*y(:, 6) + beta(5)*y(:,7) + beta(6)*y(:,8) + ...
            beta(7)*y(:,9) + beta(8)*y(:,10));
for i = 1:size(y,1)
    log_proba(i) = log(log_proba(i) / denominador(beta, X, y(i,3)));
end
L = -sum(log_proba);

end