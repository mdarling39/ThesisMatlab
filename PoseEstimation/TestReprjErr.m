% Test the reprojection error computation in MATLAB because its easier than
% C++

clear all; close all; clc;
load TestPts.mat

for i = 1:5
    dist(i) = norm(imagePts(i,:) - projImagePts(i,:));
end

totalDist = sum(dist);

% I know in ths case points 1 and 5 are farthest from one another
maxDist = norm(imagePts(1,:) - imagePts(5,:)); 

totalDist/maxDist;