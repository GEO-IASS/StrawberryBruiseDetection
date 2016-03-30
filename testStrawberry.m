% test on a single strawberry
% select a strawberry from three categories
p = mfilename('fullpath');
[fwd, name, ext] = fileparts(p);  % file path the file locate
cd(fwd);
addpath(fwd);
addpath(fullfile(fwd, '..\tools\libsvm-3.20\matlab'));
svm = importdata('SVMClassifier.mat');
datapath = '../data/strawberry/dataset';
cd(datapath);
categories = {'good', 'overripe', 'underripe', 'test'};
dataset = [];
colorMap = zeros(256, 3);
colorMap(2,:) = [1, 0, 0];
colorMap(3,:) = [0.5, 0, 0];
colorMap(4,:) = [0, 1, 0];
% for i = 1:length(categories);
for i = 4:length(categories); % test dataset
   folder = categories{i};
   cd(folder);
   filelist = dir('*.mat');
   data = [];
%    j = randi(length(filelist), 1); 
   j = 1; 
   filename = filelist(j).name;
   datacube = importdata(filename);
   rawfilename = strrep(filename, '.mat', '.hdr'); % raw hyperspectral image without cropping
   rawdatacube =  Load_Spec(rawfilename);
   [nrow, ncol, nband] = size(datacube);
   ndatacube = normalise(datacube, '', 1);
   vdatacube = reshape(ndatacube, [nrow*ncol, nband]);
   index = any(vdatacube,2);
   feat = vdatacube(index,:);
   label = ones(size(feat,1),1)*i;   
   % SVM classification
   [predicted_labels, ~, ~] = svmpredict(label, feat, svm); 
   % classification accuracy
   results(i) = assessment(label, predicted_labels, 'class');
   temp = zeros(nrow*ncol, 1);
%    temp(index) = randi(3, [size(feat,1), 1]);
   temp(index) = predicted_labels;
   clamap = reshape(temp, [nrow, ncol]);
   rawImgrgb = HSI2RGB(rawdatacube); 
   imggray = mean(ndatacube,3);
   figure, 
   subplot(2,1,1), imshow(rawImgrgb);
   subplot(2,1,2), imshow(uint8(clamap), colorMap);
   cd ..;
end
cd(fwd);
   
   




