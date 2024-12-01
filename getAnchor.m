function [Anchor] = getAnchor(X,label,parameter)
numAnchor = round(parameter.val);
    [num,dim] = size(X);
    sample_anchor = randperm(num,numAnchor);
    Anchor = X(sample_anchor,:);
end



