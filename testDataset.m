% test on dataset

p = mfilename('fullpath');
[fwd, name, ext] = fileparts(p);  % file path the file locate
cd(fwd);
datafile = '../data/strawberry/dataset/dataset.mat';
addpath('../tools/matlab2weka');
dataset = importdata(datafile);
% numerical class variable
feat = dataset(:,1:16);
label = dataset(:,17);

%% Performing K-fold Cross Validation
K = 100;
N = size(feat,1);
%indices for cross validation
idxCV = ceil(rand([1 N])*K); 
actualClass = zeros(size(feat,1),1);
predictedClass = zeros(size(feat,1),1);
classifier = 1;
for k = 1:K-1
    %defining training and testing sets
%     feature_train = feat(idxCV ~= k,:);
%     class_train = label(idxCV ~= k,1);
    feature_train = feat(idxCV == k+1,:);
    class_train = label(idxCV == k+1,1);
    feature_test = feat(idxCV == k,:);
    class_test = label(idxCV == k,1);
    % performing Random Forest Classifier 
%     [predicted_tmp] = wekaClassificationWarp(feature_train, class_train, feature_test, class_test);
    % performing SVM 
    [predicted_tmp] = SVMClassification(feature_train, class_train, feature_test, class_test);
    % classification accuracy
    results(k) = assessment(class_test, predicted_tmp, 'class');
end