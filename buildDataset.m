% build the dataset
p = mfilename('fullpath');
[fwd, name, ext] = fileparts(p);  % file path the file locate
cd(fwd);
datapath = '../data/strawberry/dataset';
cd(datapath);
categories = {'good', 'overripe', 'underripe'};
dataset = [];
for i = 1:length(categories);
   folder = categories{i};
   cd(folder);
   filelist = dir('*.mat');
   data = [];
   for j = 1:length(filelist)
       filename = filelist(j).name;
       datacube = importdata(filename);
       [nrow, ncol, nband] = size(datacube);
       % extract features
       ndatacube = normalise(datacube, '', 1);
       vdatacube = reshape(ndatacube, [nrow*ncol, nband]);
       feat = vdatacube(any(vdatacube,2),:);
       label = ones(size(feat,1),1)*i;
       temp = cat(2, feat, label);
       data = cat(1, data, temp);
   end
   dataset = cat(1, dataset, data);
   cd ..
end
save('dataset.mat', 'dataset');
       