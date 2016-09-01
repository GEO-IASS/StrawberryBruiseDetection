% register the infrared image with Imec images 
img1 = Load_Spec('E:\ARC\BruiseDataSet\session1\HSIVIS\g01.hdr');
img2 = Load_Spec('E:\ARC\BruiseDataSet\session1\HSIIR\g01.hdr');
T = importdata('E:\ARC\BruiseDataSet\session1\IR2VIS.mat');
[nrow, ncol, nband] = size(img1);
tform = affine2d(T); 
rimg2 = imwarp(img2, tform, 'OutputView', imref2d([nrow, ncol]));
maximg1 = max(img1(:)), 
minimg1 = min(img1(:)),
maximg2 = max(img2(:)), 
minimg2 = min(img2(:)),
nimg1 = normalise(img1, [], 1);
slice1 = nimg1(:,:,41);
nimg2 = normalise(img2, [], 1);
slice2 = nimg2(:,:,31);
nrimg2 = normalise(rimg2, [], 1);
nrslice2 = nrimg2(:,:,31);
figure, imshowpair(slice1, slice2,'montage');
figure, imshowpair(slice1, nrslice2,'montage');
newdata = cat(3, nimg1, nrimg2);
save('temp/Visible&IR.mat', 'newdata');

