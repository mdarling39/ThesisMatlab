function [DATA, params] = LEDFilteringParser(filename)

fileID = fopen(filename,'r');
fgetl(fileID);

line = fgetl(fileID);
c = sscanf(line,'%*s %f %f %f %f');
params.w.circularity = c(1);
params.w.inertiaRatio = c(2);
params.w.convexity = c(3);
params.w.blobColor = c(4);


fgetl(fileID);
fgetl(fileID);
line = fgetl(fileID);
c = sscanf(line,'%f %f %f %f %f %f');
params.filter.error.by = c(1);
params.filter.circularity.by = c(2);
params.filter.inertiaRatio.by = c(3);
params.filter.convexity.by = c(4);
params.filter.blobColor.by = c(5);
params.filter.area.by = c(6);

fgetl(fileID);
line = fgetl(fileID);
c = sscanf(line,'%*s %f %f %f %f %f %f');
params.filter.error.min = c(1);
params.filter.circularity.min = c(2);
params.filter.inertiaRatio.min = c(3);
params.filter.convexity.min = c(4);
params.filter.blobColor.min = c(5);
params.filter.area.min = c(6);

line = fgetl(fileID);
c = sscanf(line,'%*s %f %f %f %f %f %f');
params.filter.error.max = c(1);
params.filter.circularity.max = c(2);
params.filter.inertiaRatio.max = c(3);
params.filter.convexity.max = c(4);
params.filter.blobColor.max = c(5);
params.filter.area.max = c(6);

fgetl(fileID);
fgetl(fileID);
line = fgetl(fileID);
c = sscanf(line,'%f %f %f %f %f');
params.target.circularity = c(1);
params.target.inertiaRatio = c(2);
params.target.convexity = c(3);
params.target.blobColor = c(4);
%params.target.area = c(5);

fclose(fileID);


M = dlmread(filename, '', 13, 0);

DATA.blobNo = M(:,1);
DATA.totalError = M(:,2);
DATA.circularity = M(:,3);
DATA.inertiaRatio = M(:,4);
DATA.convexity = M(:,5);
DATA.blobColor = M(:,6);
DATA.area = M(:,7);

if size(M,2) > 7
    DATA.imageXpt = M(:,8);
    DATA.imageYpt = M(:,9);
end

