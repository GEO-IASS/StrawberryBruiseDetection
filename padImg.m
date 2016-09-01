% padarray hyperspectral image to make it same size as infrared image
function padImg(filename)

padsize = [(1200-248)/2, (1920-512)/2];
img = imread(filename);
pimg = padarray(img,padsize);
imgname = filename;
imwrite(pimg,['..\pSingleBand\', imgname]);    
