% build the dataset
p = mfilename('fullpath');
[fwd, name, ext] = fileparts(p);  % file path the file locate
cd(fwd);
datapath = '../data/strawberry/dataset';
cd(datapath);
categories = {'good', 'overripe', 'underripe'}; % fourth category: 'leaf'
dataset = [];
for i = 1:length(categories);
   folder = categories{i};
   cd(folder);
   filelist = dir('*.mat');
   data = [];
   for j = 1:length(filelist)
       filename = filelist(j).name;
       leaffile= strrep(filename, '.mat', '_leaf.png');
       datacube = importdata(filename);
       leafmap = imread(leaffile);
       [nrow, ncol, nband] = size(datacube);
       % extract features
       ndatacube = normalise(datacube, '', 1);
       vdatacube = reshape(ndatacube, [nrow*ncol, nband]);
       cIdx = any(vdatacube,2); % cropped object index
       vleafmap = reshape(leafmap, [nrow*ncol, 1]); 
       leafIdx = any(vleafmap, 2);
       stbIdx = logical(cIdx - leafIdx);
       feat = vdatacube(cIdx,:);
       templabel = stbIdx*i + leafIdx*4;
       imagesc(reshape(templabel, [nrow, ncol]));
       label = templabel(cIdx, 1);
       temp = cat(2, feat, label);
       data = cat(1, data, temp);
   end
   dataset = cat(1, dataset, data);
   cd ..
end
save('dataset.mat', 'dataset');
       