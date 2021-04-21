function [D] = denominador2(delta_b, X, st_id)

aux = X(X(:,2) == st_id,:);

n = size(aux, 1);
%disp(n);

denom = zeros(1, n);
beta = delta_b(1);
delta = delta_b(2:size(delta_b,2));


for i = 1:n
    if aux(i, 2) == 1
        denom(i) = 1;
    else
        denom(i) = exp(beta*aux(i,3) + dot(aux(i,5:size(aux,2)),delta));
    end
    %disp(denom(i));
end

D = sum(denom);
end
