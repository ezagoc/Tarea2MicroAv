function [f,g,H] = ml_CG(beta,X)

f = LogLik(beta,X);

if nargout>1
    g = gradiente_AUX(beta,X);
    if nargout>2
        H = hessian(beta,X);
    end
end
end
