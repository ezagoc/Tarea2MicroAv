function [D] = logit_d(beta, X,id)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
T = X(X(:,3) == id,:);
n = size(T,1);

d = zeros(1,n);

for i = 1:n
    d(i) = exp(beta(1)*T(i,3) + beta(2)*T(i,4) + beta(3)*T(i,5) + beta(4)*T(i,6) + beta(5)*T(i,7) + beta(6)*T(i,8) + beta(7)*T(i,9) + beta(8)*T(i,10));
end

D = sum(d);
end


