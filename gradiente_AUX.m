function [G] = gradiente_AUX(beta,X)
T = X(X(:,11) == 1,:);
m = size(T,1);
n = size(beta,2);

Z = T(:,4:10);
z = ones(1,m)';

Z = [z Z];
Z = sparse(Z);

G = zeros(1,n);
p = zeros(1,m);
g = zeros(1,m);

p = exp((1 - T(:,2))*beta(1) + beta(2)*T(:, 4) + beta(3)*T(:, 5) + ...
            beta(4)*T(:, 6) + beta(5)*T(:,7) + beta(6)*T(:,8) + ...
            beta(7)*T(:,9) + beta(8)*T(:,10));
for i = 1:size(T,1)
    p(i) = p(i) / denominador(beta, X, T(i,3));
end

for i = 1:n
    for j=1:m
    g(j) = Z(j,i) - p(j)*Z(j,i);
    end
G(i) = sum(g);
G
end
end

