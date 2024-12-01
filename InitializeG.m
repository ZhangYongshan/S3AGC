function [Ini,inG0] = InitializeG(n,c)
% Initialize clustering indicator matrix G
% Ini denotes the initialize label vector

I = eye(c);
R = randperm(size(I,1));
inG0 = I(R,:);
r = n - floor(n/c)*c;
if r == 0;
    inG0 = repmat(inG0,n/c,1);
else
    inG0 = [repmat(inG0,floor(n/c),1);inG0(1:r,:)];
end

[row,col] = find(inG0);  % 非零元素的行和列索引
[~,idx] = sort(row,'ascend');
Ini = col(idx);

end