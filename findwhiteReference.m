% findwhiteReference interacts with user to find white reference in color 
% board data
% has not been tested
[datacube, bandname] = Load_Spec('color board.hdr');
img = datacube(:,:,31);
[nrow, ncol] = size(img);
f = figure;
imshow(img, []);
rect = getrect(f);
while rect(1) <0 || rect(1)>ncol || rect(2) <0 || rect(2)>nrow% if the region is outside the image
    rect = getrect(h);
end
roi = datacube(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)),:);      
sp = squeeze(mean(mean(roi,1),2))';
figure, plot(bandname', sp);
save('white.mat', 'sp');






