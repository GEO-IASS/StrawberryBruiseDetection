function [predicted_labels, svm] = SVMClassify(trainingData, trainingLabels, testingData, testingLabels)
% SVMClassifer
addpath('..\tools\libsvm-3.20\matlab');
if ~exist('testingLabels', 'var');
    testingLabels = zeros(size(testingData,1),1);
end
log2cList = -1:2:3;
log2gList = -1:2:3;
cv = zeros(length(log2cList), length(log2gList) );
parfor indexC = 1:length(log2cList)
    log2c = log2cList(indexC);
    tempcv = zeros(1,length(log2gList));
    for indexG = 1:length(log2gList)
       log2g =  log2gList(indexG);
       cmd = ['-q -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
       tempcv(indexG) = svmtrain(trainingLabels, trainingData, cmd);
    end
    cv(indexC,:) = tempcv;
end
[~, indexcv]= max(cv(:));
[bestindexC, bestindexG] = ind2sub(size(cv), indexcv);
bestc = 2^log2cList(bestindexC);
bestg = 2^log2gList(bestindexG);
optPara = [ '-q -c ', num2str(bestc), ' -g ', num2str(bestg)];
svm = svmtrain(trainingLabels, trainingData, optPara);    % [, 'libsvm_options']);
[predicted_labels, ~, ~] = svmpredict(testingLabels, testingData, svm); 