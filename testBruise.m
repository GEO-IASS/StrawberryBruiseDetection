% test bruise detection
addpath(genpath('../tools/scyllarus-matlab'));
addpath('..\tools\libsvm-3.20\matlab');
% import hyperspectral image
img = Load_Spec('E:\ARC\bruiseTest\r3_22d_3h.hdr');
img = normalise(img, [], 1);
[nrow, ncol, nband] = size(img);
% import the strawberry classification results
img_label = imread('r3_22d_3h_materials.png');
imshow(img_label);
img_label = rgb2gray(img_label);
imshow(img_label);
level = graythresh(img_label);
mask = im2bw(img_label,level);
imshow(mask);
mask = 1 - mask;
figure, imshow(mask);
mask = imclearborder(mask);
figure, imshow(mask);
mask = imfill(mask,'holes');
figure, imshow(mask),
P = 100; 
mask = bwareaopen(mask, P);
figure, imshow(mask),
tepmask = repmat(double(mask), [1,1, nband]);
img_str = img.*tepmask;
% import the spectral library for the bruise detection
bruiseLibrary = normalise(bruiseLibrary, [], 1); 
[numInst, numfeat] = size(bruiseLibrary);
feature_train = bruiseLibrary;
class_train = double(strcmp(label, 'bru'));
vimg = reshape(img_str, [nrow*ncol, nband]);
feature_test = vimg(mask>0);
class_test = zeros(size(feature_test), 1);
[predicted_tmp] = SVMClassification(feature_train, class_train, feature_test, class_test);
