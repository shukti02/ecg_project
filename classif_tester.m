% check if pushed 

clear all; clc;
matObj = matfile('~/Desktop/SHUKTI_new/Patients/WG 015.mat');

brady = 1000*matObj.arrBradycardia_x;
MSpos = 1000*matObj.MSmodelsX;
beatpos = 1000*matObj.beatpos;
models = matObj.MSmodels;

bradyPos = zeros(length(brady),1);
MSbradyPos = zeros(length(brady),1);

for i = 1:length(brady)
    bradyPos(i) = beatpos(beatpos==brady(i));
    MSbradyPos(i) = MSpos(MSpos<brady(i)+20 & MSpos>brady(i)-20);
end

[correctedData, remIndices] = removeOutliers (models');
totalRemIndices = [];
for i = 1 : length(remIndices)
totalRemIndices = union(totalRemIndices,remIndices{i});
end

models_n = models;
models_n(:,totalRemIndices) = [];
MS_n = MSpos;
MS_n(totalRemIndices) = [];

MS_n(isnan(MS_n)) = [];
MSinterval = [[1;MSbradyPos] [MSbradyPos;MS_n(end)+1]];
healthy = []; risk = [];
for i = 1:length(MSbradyPos)
    healthy = [healthy models([1 2 4 5 24 25 26 27 100],(MS_n>MSinterval(i,1) & MS_n<MSinterval(i,2)-1800000*(i~=length(MSbradyPos))))];
    risk = [risk models([1 2 4 5 24 25 26 27 100],(MS_n>=MSbradyPos(i)-1800000 & MS_n<MSbradyPos(i)))];
end

%------------------- data for all beats without outlier removal----------------------------------------- 
x = find(isnan(MSpos));
MSpos(x) = [];
MSinterval = [[1;MSbradyPos] [MSbradyPos;MSpos(end)+1]];
healthy = []; risk = [];
for i = 1:length(MSbradyPos)
    healthy = [healthy models(:,(MSpos>MSinterval(i,1) & MSpos<MSinterval(i,2)-1800000*(i~=length(MSbradyPos))))];
    risk = [risk models(:,(MSpos>=MSbradyPos(i)-1800000 & MSpos<MSbradyPos(i)))];
end

clearvars -except healthy risk

%------------------------------test classification------------------------
% h = randperm(length(healthy),500);
% ht = randperm(500,50);
% h_te = h(ht); %indices of testing set :healthy
% h_tr = h; h_tr(ht) = []; %indices of training set: healthy
% 
% r = randperm(length(risk),500);
% rt = randperm(500,50);
% r_te = r(rt); %indices of testing set: risk
% r_tr = r; r_tr(rt) = []; %indices of training set: risk

h = randperm(length(healthy),1000);
r = randperm(length(risk),1000);

h_te = h;
h_tr = 1:length(healthy); h_tr(h) = [];

r_te = r;
r_tr = 1:length(risk); r_tr(r) = [];


trainData = [healthy(:,h_tr) risk(:,r_tr)]';
trainLabels = [-1.*ones(length(h_tr),1); ones(length(r_tr),1)];

testData = [healthy(:,h_te) risk(:,r_te)]';
testLabels = [-1.*ones(length(h_te),1); ones(length(r_te),1)];

% % ------------------------------optimization---------------------
% LossMat = zeros(11,11);
% tic;
% for i = 1:11
%     for j = 1:11
%         clear SVMmodels CVmodel
%         SVMmodels = fitcsvm(trainData,trainLabels, 'KernelScale',82.0391*10^(-5+j-1),'BoxConstraint',10^(-5+i-1));
%         CVmodel = crossval(SVMmodels);
%         LossMat(i,j) = kfoldLoss(CVmodel);
%     end
% end
% toc;


SVMmodels = fitcsvm(trainData,trainLabels, 'KernelScale','auto');
CVmodel = crossval(SVMmodels);
L = kfoldLoss(CVmodel)
rbf_sigma = SVMmodels.KernelParameters.Scale

 
% rbf_sigma = 2.3151e+03;
boxconstraint = 1;


c = cvpartition(length(trainData),'KFold',10);
z=[rbf_sigma,boxconstraint];

minfn = @(z)kfoldLoss(fitcsvm(trainData,trainLabels,'CVPartition',c,...
    'BoxConstraint',exp(z(2)), 'KernelScale',exp(z(1))));

opts = optimset('TolX',5e-4,'TolFun',5e-4);

tic
[searchmin,fval] = fminsearch(minfn,randn(2,1),opts);
toc

%------------------------classification-------------------------------

z_new = exp(searchmin);
SVMmodels_new = fitcsvm(trainData,trainLabels, 'BoxConstraint',z_new(2), 'KernelScale',z_new(1));
labels = predict(SVMmodels_new,testData);

%------------------------efficiency------------------------------------
100*sum(abs(testLabels-labels)==0)/length(testData)


% %--------------------save pairwaise figures------------------------
% for i = 1:101
%     for j = i:101
%         if (i~=j)
%             clf; close all;
%             gscatter(trainData(:,i),trainData(:,j),trainLabels); 
%             hold on; 
%             plot(sv(:,i),sv(:,j),'ko','MarkerSize',10); 
%             legend('healthy','risk','Support Vector')
%             xlabel(strcat('param\_',num2str(i)));
%             ylabel(strcat('param\_',num2str(j)))
%             title(strcat('pairwise\_plot\_',num2str(i),'\_',num2str(j)));
%             saveas(gcf,strcat('pairwise_plot_',num2str(i),'_',num2str(j),'.jpg'));
%         end
%     end
% end
