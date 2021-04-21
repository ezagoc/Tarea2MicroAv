function [D] = denominador3(delta_b, X, st_id)

aux = X(X(:,2) == st_id,:);

n = size(aux, 1);
%disp(n);

denom = zeros(1, n);
beta = delta_b(1:4);
delta = delta_b(5:size(delta_b,2));


for i = 1:n
    if aux(i, 2) == 1
        denom(i) = 1;
    else
        denom(i) = exp(beta(1)*aux(i,3) + beta(2)*aux(i,4) + beta(3)*aux(i,5) +...
            beta(4)*aux(i,6) + dot(aux(i,8:size(aux,2)),delta));
    end
    %disp(denom(i));
end

D = sum(denom);
end
