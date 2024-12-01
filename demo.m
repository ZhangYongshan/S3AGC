
clear all; clc;

addpath('./lib');
addpath('D:\matlab_code\datasets\datasets_single');
addpath('./Entropy Rate Superpixel Segmentation')
% dataset='Trento';
dataset='Salinas';
% dataset='Pavia';

switch dataset
    case 'Salinas'
        load Salinas_corrected;load Salinas_gt;
        data3D = salinas_corrected;        
        gt = salinas_gt;
        parameter.alpha=0.9;
        parameter.ro= 0.0514;
        valcandi_Candi=13000;
        numNearestAnchor_Candi=3;
        GRAPH_BK_Candi=5;
    case 'Pavia'
        load Pavia;load Pavia_gt;
        data3D = pavia;        
        gt = pavia_gt;
        parameter.alpha= 0.6;
        parameter.ro= 0.0964;
        valcandi_Candi=11000;
        numNearestAnchor_Candi=5;
        GRAPH_BK_Candi=5;
    case 'Trento'
        load trento_data;
        data3D = HSI_data;        
        gt = ground;
        parameter.alpha=0.2;
        parameter.ro= 0.0629;
        numNearestAnchor_Candi=10;
        valcandi_Candi=1500;
        GRAPH_BK_Candi=5;
end

start = tic;
parameter.val= parameter.ro*valcandi_Candi;
parameter.numNearestAnchor=numNearestAnchor_Candi;
parameter.GRAPH_BK= GRAPH_BK_Candi;
[y_pred]=main(data3D,gt,parameter);

gt = double(gt(:));
ind = find(gt);
results = evaluate_results_clustering(gt(ind),y_pred(ind));
fprintf("acc:%.4f,total time:%.2f\n",results(1),toc(start));


