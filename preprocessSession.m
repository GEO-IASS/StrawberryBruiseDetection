% preprocess session(calibration, registration, and calibration)
% it relys on the function "calTransMatrix", "findwhiteReference"

% work in a session folder
calTransMatrix;
cd('HSIIR');
findwhiteReference; 
batchRun(cd, '*.hdr', @preprocessIR);

