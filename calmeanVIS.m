% calcualte the average spectral response in the region of strawberries 
function [sp, label] = calmeanVIS(filename)

%filename = 'b01_r.mat';
groundTruthFile = strrep(filename, '_n.mat', '_groundTruth.png');
folder = '../HSIIR/';
gt = imread(fullfile(folder, groundTruthFile));
ind = gt == 255;
img = importdata(filename);
[nrow, ncol, nb] = size(img);
vimg = reshape(img, [nrow*ncol, nb]);
spregion = vimg(ind,:);
sp = mean(spregion);
% if the strawberry is bruised, the label is 1, otherwise 0;
label = strcmp(filename(1), 'b');
if label == 1
    plot(400:10:1000, sp, 'b');
else
    plot(400:10:1000, sp, 'r');
end
    






