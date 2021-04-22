function [H] = hessian(beta,X)
% Calcula la matriz Hessiana

% --------------------------------

H = zeros(8,8);


% 1) filtra por choice == 1

x = X(X(:,3)== 1,:); 

x = x(:,2); % ID's de los alumnos

aux = zeros(1,length(x));


for w = 1:8
    
    
    for a = 1:8
        
        
        for i = 1:length(x)
            
            aux(i) = -sum_e2(beta,X,x(i),w,a)/sum_e(beta,X,x(i),w,0) + (sum_e(beta,X,x(i),w,0)^(-2)) * sum_e(beta,X,x(i),w,1) * sum_e(beta,X,x(i),w,a) ;
            
        end
        
        
        H(w,a)  = sum(aux);
        
        
        
    end
    
   
end




end

