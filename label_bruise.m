function rect=label_bruise(filename,varargin)
% label the bruise region on the strawberry
datacube = importdata(filename);
img = datacube(:,:,31);
imshow(img, []);
if isempty(varargin)
    rect = getrect();
else rect = importdata (varargin{1});
end
hold on;
rectangle('Position',rect,'EdgeColor','r', 'LineWidth',2);
F = getframe;
savename = regexprep(filename,'_r.mat','_labeled.png', 'ignorecase');
imwrite(F.cdata, savename);

BW=zeros(size(img,1),size(img,2));
BW(round(rect(2)):round(rect(2)+rect(4)),round(rect(1)):round(rect(1)+rect(3)))=1;
savename = regexprep(filename,'_r.mat','_groundTruth.png', 'ignorecase');
imwrite(BW,savename);

