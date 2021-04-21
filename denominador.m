function [D] = denominador(beta, X, st_id)

aux = X(X(:,3) == st_id,:);

n = size(aux, 1);
%disp(n);

denom = zeros(1, n);

for i = 1:n
    if aux(i, 2) == 1
        denom(i) = 1;
    else
        denom(i) = exp(beta(1) + beta(2)*aux(i, 4) + beta(3)*aux(i, 5) + ...
            beta(4)*aux(i, 6) + beta(5)*aux(i,7) + beta(6)*aux(i,8) + ...
            beta(7)*aux(i,9) + beta(8)*aux(i,10));
    end
    %disp(denom(i));
end

D = sum(denom);