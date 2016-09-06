% register the infrared image with Imec images 
function preprocessVIS(filename)
img = Load_Spec(filename);
[nrow, ncol, nb] = size(img);
% spectral calibration
white = importdata('white.mat');
dark = Load_Spec('dark frame.hdr');
mdark = mean(dark, 3);
dark = repmat( mdark,1,1, nb);
Rdatacube = double(img) - dark;
Rdatacube(Rdatacube<0) = 0;
temp = zeros(nrow,ncol,nb);
for i = 1:nb
   temp(:,:,i) = Rdatacube(:,:,i)/ white(i);
end
img = normalise(temp,'percent', 0.999);
% scale
simg = imresize(img, 1/2);
rfilename = strrep(filename, '.hdr', '_n.mat');
save(rfilename, 'simg');

