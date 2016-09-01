% two steps classification
% firstly classify the strawberry
% secondly classify the bruise region
close all, 
clear;
addpath('..\tools\libsvm-3.20\matlab');

%% import data
filename = 'C:\Users\s2882161\Desktop\classification1\strawberry6bruise.hdr';
[datacube, bandname, description] = Load_Spec(filename);
[nrow, ncol, nb] = size(datacube);
% normalise
datacube = normalise(datacube,'percent', 0.999);
vdatacube = reshape(datacube, nrow*ncol, nb);
slice = datacube(:,:, 30);
imshow(slice);
%% calibration
% white calibration
% dark calibration

%% training 
if exist('temp/classifiers.mat', 'file')
else
% select strawberry region to train the classifier1
i = 0;
feat = cell(10,1);
label = cell(10,1);
labelStr = cell(10,1);
while 1
   rect = getrect(gca);
   if rect(1) <0 || rect(1)>ncol || rect(2) <0 || rect(2)>nrow% if the region is outside the image
       break; 
   end
   rectangle('Position',rect);
   i = i + 1;
   roi = datacube(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)),:);      
   [m, n, ~] = size(roi); 
   feat{i} = reshape(roi, [m*n, nb]);
   answer = inputdlg('Label: (numerrical 0-9)','Input', [1 50]);
   x = str2double(answer{1});
   labelStr{i} = answer{1};
   disp(['class',  labelStr{i}]);
   label{i} = ones(m*n,1)*x; 
%   region{i} = cat(2,x, rect);
end
disp('training samples have been selected!');
feat = cell2mat(feat);
label = cell2mat(label);
[predicted_labels, svm1] = SVMClassify(feat, label, vdatacube);
mask1 = reshape(predicted_labels, [nrow, ncol]);
figure, imshow(mask1,[]);
filename1 = strrep(filename, '.hdr', '_straw.png');
imwrite(mask1, filename1);
% crop strawberry out
tepmask = repmat(double(mask1), [1,1, nb]);
datacube = datacube.*tepmask;

% select bruise region to train the classifier2
slice = datacube(:,:, 30);
imshow(slice);
i = 0;
feat = cell(10,1);
label = cell(10,1);
labelStr = cell(10,1);
while 1
   rect = getrect(gca);
   if rect(1) <0 || rect(1)>ncol || rect(2) <0 || rect(2)>nrow% if the region is outside the image
       break; 
   end
   rectangle('Position',rect);
   i = i + 1;
   roi = datacube(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)),:);      
   [m, n, ~] = size(roi); 
   feat{i} = reshape(roi, [m*n, nb]);
   answer = inputdlg('Label: (numerrical 0-9)','Input', [1 50]);
   x = str2double(answer{1});
   labelStr{i} = answer{1};
   disp(['class',  labelStr{i}]);
   label{i} = ones(m*n,1)*x; 
%   region{i} = cat(2,x, rect);
end
disp('training samples have been selected!');
feat = cell2mat(feat);
label = cell2mat(label);
vdatacube = reshape(datacube, nrow*ncol, nb);
[predicted_labels, svm2] = SVMClassify(feat, label, vdatacube);
mask2 = reshape(predicted_labels, [nrow, ncol]);
figure, imshow(mask2,[]);
filename2 = strrep(filename, '.hdr', '_bruise.png');
imwrite(mask2, filename2);
% save classifiers
classifierName = strrep(filename, '.hdr', '_svm.mat');
save(classifierName, 'svm1', 'svm2');
return;
end
%% test
 
% import the SVM classifier1 and classifier2
load('temp/classifiers.mat');
testingLabels = zeros(size(vdatacube,1), 1);
[predicted_labels, ~, ~] = svmpredict(testingLabels, vdatacube, svm1); 
mask = reshape(predicted_labels, [nrow, ncol]);
figure, imshow(mask,[]);
% crop strawberry out
tepmask = repmat(double(mask), [1,1, nb]);
datacube = datacube.*tepmask;
vdatacube = reshape(datacube, nrow*ncol, nb);
[predicted_labels, ~, ~] = svmpredict(testingLabels, vdatacube, svm2); 
mask = reshape(predicted_labels, [nrow, ncol]);
figure, imshow(mask,[]);
