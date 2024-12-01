 % %=================================================º∆À„labelæÿ’Û=======================================================================
function [F,Ini] = get_label(X,Xm,locAnchor,numAnchor,c,numNearestAnchor,mu,sign)
% Input
% X:                num*dim data matrix
% c:                class number
% numAnchor:        number of anchors
% numNearestAnchor: number of nearest anchors
% downsampling:     decimation of downsampling for kmeans
% sign:             1 for kmeans anchor generation, 0 for random selection

% Output
% finalInd:              class indicator matrix 
% sumTime:          running time
% numAnchor=500;
[num,~] = size(X);

%%
[Ini,inG0] = InitializeG(num,c);

% % ------------------- 1. anchor generation ------------------
tic;
if sign == 0 % random
    sample_anchor = randperm(num,fix(numAnchor));
    locAnchor = X(sample_anchor,:);
elseif sign == 1 % kmeans
    [StartIni,~] = InitializeG(num,fix(numAnchor));
    [~, ~, locAnchor] = kmeans_ldj(X,StartIni);
elseif sign ==2 % supermeans
     
end
toc;

time(1) = toc;

%% ------------------- 2. anchor based graph ------------------
tic;

Z = constructz(X',Xm',locAnchor',mu,numNearestAnchor,2);
Z = sparse(Z);
sumZ = sum(Z);
sqrtZ = sumZ.^(-0.5);
regZ = (Z)*(diag(sqrtZ));%µ√µΩBæÿ’Û
% res = myBipartiteGraphParitioin(regZ, c, 100, 10);
toc;
time(2) = toc;
%% ------------------ 3. eigenvalue decomposition ------------------
tic
[F, ~, ~] = svds(regZ,c);
% F = diag(diag(F*F').^(-1/2))*F;
% res = kmeans_ldj(F,Ini);
% res =litekmeans(F,c, 'MaxIter', 100, 'Replicates', 5);
toc
time(3) = toc;
%%

end

