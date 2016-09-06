% build the dataset of spectral response for good/bruise strawberry
list1 = dir('b*.mat');
list2 = dir('g*.mat');
list = [list1;list2];
filename = list(1).name;
img = importdata(filename);
[~, ~, nb] = size(img);
dataset = zeros(length(list), nb+1);
figure, hold all,
for i = 1:length(list)
    filename = list(i).name;
    [sp, label] = calmeanIR(filename);
    dataset(i,:) = [sp, label];
end
save('spDataset', 'dataset');
    
    