function out = cropStrawberry(file)
% crop strawberry out
% file = 'SSM4x4-VIS_49570354_20160316140604.hdr';
if ischar(file)
    dataCube = Load_Spec(file);
    ndataCube = normalise(dataCube, '', 1);
    dataCube = uint8(ndataCube*255);
    imgname = strrep(file, '.hdr', '.png');
    cubename = strrep(file, '.hdr', '.mat');
else dataCube = file;
end
[nrow, ncol, nband] = size(dataCube);
band571 = dataCube(:,:,9);
level = graythresh(band571);
mask = im2bw(band571,level);
mask = 1 - mask;
mask = imfill(mask,'holes');
P = 20; 
mask = bwareaopen(mask, P); % remove object whose size is less than 20
tepmask = repmat(uint8(mask), [1,1, nband]);
newCube = dataCube.*tepmask;
% find the region of the mask
projX = any( mask, 1 ); % projection of mask along x direction
projY = any( mask, 2 ); % projection of mask along y direction
fx = find( projX, 1, 'first' ); % first column with non-zero val in mask
tx = find( projX, 1, 'last' );  % last column with non-zero val in mask
fy = find( projY, 1, 'first' ); % first row with non-zero val in mask
ty = find( projY, 1, 'last' );  % last row with non-zero val in mask
indexWidth = [fx:tx];
indexHight = [fy:ty];
cropCube = newCube(round(indexHight),round(indexWidth),:);
cband571 = cropCube(:,:,9);
save(cubename, 'cropCube');
imwrite(cband571, imgname);
% imshow(cband571);





