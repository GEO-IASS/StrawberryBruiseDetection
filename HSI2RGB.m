function imgrgb = HSI2RGB(datacube)
if max(datacube) > 1
    datacube = normalise(datacube, '', 1);
end
[nrow, ncol, nband] = size(datacube);
imgrgb = zeros(nrow, ncol, 3);
imgrgb(:,:,1) = datacube(:,:,16);
imgrgb(:,:,2) = datacube(:,:,9);
imgrgb(:,:,3) = datacube(:,:,1);