% calculate the tranform matrix between HSIVIS and HSIIR for the subsequent
% registration

imgVIS = Load_Spec('.\HSIVIS\checker.hdr');
imgIR = Load_Spec('.\HSIIR\checker.hdr');
imgAnchor = imadjust(imgVIS(:,:,31)); 
imgTarget = imadjust(imgIR(:,:,31));
[pointsAnchor,~] = detectCheckerboardPoints(imgAnchor);
[pointsTarget,~] = detectCheckerboardPoints(imgTarget);
figure; imshow(imgAnchor);
hold on; plot(floor(pointsAnchor(:,1)), floor(pointsAnchor(:,2)),'ro');
figure; imshow(imgTarget);
hold on; plot(floor(pointsTarget(:,1)), floor(pointsTarget(:,2)),'ro');

MaxNumTrials = 2000;
Confidence = 99;
MaxDistance = 3; 
[tform, x2, x1, status] = estimateGeometricTransform(pointsTarget,pointsAnchor, 'affine',...
     'MaxNumTrials',MaxNumTrials,'Confidence',Confidence, 'MaxDistance',MaxDistance ); % MSAC algorithm,a variant of the RANSAC algorithm
T = tform.T;
save('IR2VIS.mat', 'T');
