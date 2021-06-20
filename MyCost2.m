
function [costF,sol]=MyCost2(position,X,K)
        
    temp = floor(position);
    Centers = X(temp,:);    

    [varargout,model,costF] = gmmC(X, K,Centers);
    sol.varargout = varargout;
    sol.model = model;
    sol.cost = costF;
end