% construct similarity matrix with probabilistic k-nearest neighbors. It is
% a parameter free, distance consistent similarity.
function Z = constructz(X,Xm,locAnchor,mu,k,sign)
% X: each column is a data point k: number of neighbors W: similarity
% matrix

if nargin < 4
    k = 5;
end

[~, num] = size(X);
[~,numAnchor] = size(locAnchor);

%% ------------------- 1. DIST generation ------------------
tic;
if sign == 0 % X
    distX = L2_distance_1(X,locAnchor);
    dist = distX;
elseif  sign ==1 % X_XM
    distX = L2_distance_1(Xm,locAnchor);
    dist = distX;
elseif sign == 2 %
    distX = (pdist2((X)',locAnchor')).^2;
    distXm = (pdist2((Xm)',locAnchor')).^2;
    dist = distX+mu*distXm;
end
toc;
clear distX;
clear distXm;
[~, idx] = sort(dist,2);

Z = zeros(num,numAnchor);

for i = 1:num
    id = idx(i,1:k+1);
    di = dist(i,id);
    Z(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
end
end

