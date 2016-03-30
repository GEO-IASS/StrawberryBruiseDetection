function out = cropLeaf(file)
% crop leaf out of strawberry
%  file = 'SSM4x4-VIS_49570354_20160316140604.mat';
if ischar(file)
    temp = importdata(file);
    ndatacube = normalise(temp, '', 1);
    datacube = uint8(ndatacube*255);
    imgname = strrep(file, '.mat', '_leaf.png');
%     cubename = strrep(file, '.hdr', '.mat');
else datacube = file;
end
[nrow, ncol, nband] = size(datacube);
vdatacube = reshape(ndatacube, [nrow*ncol, nband]);
band639 = datacube(:,:,15);
% figure, 
subplot(1,3,1),imshow(band639);
vband639 = reshape(band639, [nrow*ncol, 1]);
index = ~(any(vdatacube,2));
vband639(index) = 255; 
rband639 = reshape(vband639, [nrow, ncol]);
level = graythresh(rband639);
mask = im2bw(rband639,level);
mask = 1 - mask;
% figure, imshow(mask),
mask = imfill(mask,'holes');
% figure, imshow(mask),
CC = bwconncomp(mask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
tempmask = zeros(size(mask));
tempmask(CC.PixelIdxList{idx}) = 1;
mask = tempmask;
% P = 30; 
% mask = bwareaopen(mask, P); % remove object whose size is less than P
subplot(1,3,2), imshow(mask),
tepmask = repmat(uint8(mask), [1,1, nband]);
newcube = datacube.*tepmask;
cband639 = newcube(:,:,9);
subplot(1,3,3), imshow(cband639)
imwrite(cband639, imgname);
% imshow(cband571);





