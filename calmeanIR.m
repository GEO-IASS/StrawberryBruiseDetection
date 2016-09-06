% calcualte the average spectral response in the region of strawberries 
function [sp, label] = calmeanIR(filename)

%filename = 'b01_r.mat';
groundTruthFile = strrep(filename, '_r.mat', '_groundTruth.png');
gt = imread(groundTruthFile);
ind = gt == 255;
img = importdata(filename);
[nrow, ncol, nb] = size(img);
vimg = reshape(img, [nrow*ncol, nb]);
spregion = vimg(ind,:);
sp = mean(spregion);
% if the strawberry is bruised, the label is 1, otherwise 0;
label = strcmp(filename(1), 'b');
if label == 1
    plot(900:10:1700, sp, 'b');
else
    plot(900:10:1700, sp, 'r');
end
    






