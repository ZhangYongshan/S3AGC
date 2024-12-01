function [y_pred] =main(data3D,label_gt,parameter)
mu=parameter.alpha;
numNearestAnchor=parameter.numNearestAnchor;
numAnchor=parameter.val;
data=data3D;
data = double(data);

labelsA = cubseg(data3D,numAnchor);
groundtruth=label_gt;
[~,~,dim] = size(data);
data = reshape(data,[],dim);
data=mapminmax(data,0,1);
gt= reshape(groundtruth,[],1);
X=data;

[Xm,XmB,XmA,Anchor] = getXm(X,labelsA,parameter);
c = size(unique(gt),1)-1;
rand('twister',3600);

sig=2;
[F,Ini] =get_label(Xm,XmB,Anchor,numAnchor,c,numNearestAnchor,mu,sig);
y_pred = kmeans_ldj(F,Ini);
  
end


