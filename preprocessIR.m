% register the infrared image with Imec images 
function preprocessIR(filename)
img = Load_Spec(filename);
[nrow, ncol, nb] = size(img);
% spectral calibration
white = importdata('white.mat');
dark = Load_Spec('dark.mat');
mdark = mean(dark, 3);
dark = repmat( mdark,1,1, nb);
Rdatacube = double(img) - dark;
temp = zeros(nrow,ncol,nb);
for i = 1:nb
   temp(:,:,i) = Rdatacube(:,:,i)/ white(i);
end
img = normalise(temp,'percent', 0.999);

% spatial registration
nrow_VIS = 1040;
ncol_VIS = 1392;
T = importdata('../IR2VIS.mat');
tform = affine2d(T); 
%register
rimg = imwarp(img, tform, 'OutputView', imref2d([nrow_VIS, ncol_VIS])); 
% scale
srimg = imresize(rimg, 1/2);
rfilename = strrep(filename, '.hdr', '_r.mat');
save(rfilename, 'srimg');

