clear all
close all
clc


imagePath = '/Users/michaeldarling/Dropbox/Thesis/OpenCV/Calibration/Zoomed In/Test Images/';
images = {[imagePath '/Test2.jpg'], [imagePath '/Test3.jpg'], [imagePath 'Test5.jpg']};

% All units in inches and degrees
distTotVision = [   137.659,...
                    107.964,...
                    191.993];

distTotTrue = [ norm([138 0 20.6250]),...
                norm([104 39 10.6250]),...
                norm([191 30 20.3750])];
            

Error = distTotVision - distTotTrue;
pctError = Error./distTotTrue*100;