% extract the first band of hyperspectral images
function hyper2band(filename)
if strcmp(filename(end-3:end), '.mat')
    mat=importdata(filename);
    extention = '.mat';
else
    datacube = Load_Spec(filename);
    mat = normalise(datacube, '', 0.999);
    extention = '.hdr';
end
slice = mat(:,:,1);
imgname = regexprep(filename, extention,  '.png', 'ignorecase');
imwrite(slice,['..\SingleBand\', imgname]);    
