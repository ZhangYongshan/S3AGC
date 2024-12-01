function [XM1,XM2,XMA,Anchor] = getXm(X,label,parameter)
%GETXM 
%  对x进行超像素分割后对每个超像素内进行均值滤波 
%  label:超像素标签
data_col=X;
[n,p]=size(data_col);
XM1=zeros(n,p);
XM2=zeros(n,p);
XMA=zeros(n,p);

gt_col=label;
gt_cla=unique(gt_col);
gt_num = length(gt_cla);
Anchor=zeros(gt_num,p);
gk_b = parameter.GRAPH_BK;
clear X;

for i=1:gt_num
    [indix]=find(gt_col==gt_cla(i));  
    datai = data_col(indix,:);
    [ni,mi]=size(datai);
    k=round(1/2*ni);

    IDX = knnsearch(datai,datai,'k',k);
    data_wmf=zeros(ni,mi);
    for nk=1:ni
        knndata=datai(IDX(nk,:),:);
        data_wmf(nk,:)=sum(knndata,1)/k;
    end
    XM1(indix,:)=data_wmf;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Anchor(i,:)=sum(datai,1)/ni;
    Anchor(i,:)=sum(datai,1)/ni;


    [options] = [];
    options.k =gk_b;

    SB = constructW(datai',options);
    B_bar = SB + speye(mi);
    d1 = sum(B_bar);
    d_sqrt1 = 1.0./sqrt(d1);
    d_sqrt1(d_sqrt1 == Inf) = 0;

    DHB = diag(d_sqrt1);
    DHB = sparse(DHB);
    B_n = DHB * sparse(B_bar) * DHB;

    XM2(indix,:)=datai*B_n;

 
end

end

