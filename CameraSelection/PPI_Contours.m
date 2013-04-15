% Michael Darling
% PPI Contours
%
%
% This script creates contours of Pixels Per Square Inch (PPI) for varying
% distances and image resolution.  Image aspect ratio, and the lens focal
% angle are held constant.


clear all
close all
clc

%% Camera Parameters

WINGSPAN = 56/12;   %ft
MAXPOSABLE = 37/12; %ft  (Distance from wingtip to opposite horizontal tail)

theta = 56;     % degrees
W_eye = 640;    % Image resolution for 75 fps operation of PS3 eye - Wide
H_eye = 480;


%% Resolution
Cam = getCam('PS3Eye');
Cam = [Cam(1) Cam(3)];

% Loops

% Resolution
MP_show = [0.05: 0.1: 1];     % Resolution (megapixels)
d = linspace(1, 100, 40);     % distance to object (ft)
MP = linspace(0.01, 1,45);
[d, MP] = meshgrid(d, MP);


% Assume same aspect ratio as given by H_eye and W_eye
[PPI, ~, ~] = PPI_fun(d, theta, MP*1e6/H_eye, MP*1e6/W_eye);



PPI_Cam = NaN(size(d,2), length(Cam));
for i = 1:size(d,2)
    for j = 1:length(Cam);
        
        [PPI_Cam(i,j), ~, ~] = PPI_fun(d(1,i), Cam(j).theta, Cam(j).W, Cam(j).H);
        
    end
end


% Plots

% Restructure matrix using interp
F = TriScatteredInterp(d(:), PPI(:), MP(:));
[d_plot, PPI_plot] = meshgrid(d(1,:),linspace(0,50,55));
MP_plot = F(d_plot, PPI_plot);


figure
[C,h] = contour(d_plot, PPI_plot, MP_plot, MP_show, 'k','DisplayName',...
    sprintf('Megapixels (MP)\n assuming %1.4f AR\n and %d deg lens focal angle',...
    W_eye/H_eye, theta));

title('Effect of Resolution on Pixel Density')
xlabel('Distance to Target  (ft)')
ylabel('Pixels Per Square Inch  (PPI)')
clabel(C,h)
hold on
legend('-DynamicLegend')

linetype = {Cam.plotColor};
for i = 1:length(Cam)
    
    plot(d(1,:), PPI_Cam(:,i), linetype{i}, 'DisplayName', Cam(i).name)
    
end

clearvars -except H_eye W_eye WINGSPAN MAXPOSABLE theta W_Eye H_eye

%% Field of View -- Far
Cam = getCam('PS3Eye');
Cam = [Cam(3) Cam(4)];

% Loops

% Focal Angle
FA_show = [20:20:140];     % Focal Angle (degrees)
d = linspace(5, 100, 40);     % distance to object (ft)
FA = linspace(3, 180, 55);
[d, FA] = meshgrid(d, FA);


% Assume same aspect ratio as given by H_eye and W_eye
[PPI, ~, ~] = PPI_fun(d, FA, W_eye, H_eye);



PPI_Cam = NaN(size(d,2), length(Cam));
for i = 1:size(d,2)
    for j = 1:length(Cam);
        
        [PPI_Cam(i,j), ~, ~] = PPI_fun(d(1,i), Cam(j).theta, Cam(j).W, Cam(j).H);
        
    end
end


% Plots

% Restructure matrix using interp
F = TriScatteredInterp(d(:), PPI(:), FA(:));
[d_plot, PPI_plot] = meshgrid(linspace(0,100,50),linspace(0,50,55));
FA_plot = F(d_plot, PPI_plot);


figure
[C,h] = contour(d_plot, PPI_plot, FA_plot, FA_show, 'k','DisplayName',...
   sprintf('Focal Angle (deg)\n assuming %dx%d resolution',...
   W_eye, H_eye));

title('Effect of Focal Angle on Pixel Density')
xlabel('Distance to Target  (ft)')
ylabel('Pixels Per Square Inch  (PPI)')
clabel(C,h)
hold on
legend('-DynamicLegend')

linetype = {Cam.plotColor};
for i = 1:length(Cam)
    
    plot(d(1,:), PPI_Cam(:,i), linetype{i}, 'DisplayName', Cam(i).name)
    
end

clearvars -except H_eye W_eye WINGSPAN MAXPOSABLE
%% Field of View -- Close
Cam = getCam('PS3Eye');
Cam = [Cam(3) Cam(4)];

theta_plot = [20:20:100];
x = linspace(0,10,200);

FOV = NaN(length(theta_plot),length(x));
idx = floor(length(x)/2);
figure
hold on
for i = 1:length(theta_plot);
    FOV(i,:) = 2*x*tand(theta_plot(i)/2);
    h(1) = plot(x,FOV(i,:),'k');
    
    
    text(x(idx), FOV(i,idx), sprintf('%d',theta_plot(i)),...
        'HorizontalAlignment','Center','VerticalAlignment','Middle',...
        'BackgroundColor','w');
    
end

linetype = {Cam.plotColor};
for i = 1:length(Cam)
    
    h(i+1) = plot(x, 2*x*tand(Cam(i).theta/2), linetype{i}, 'DisplayName', Cam(i).name);
    
end
ylim([0 5*WINGSPAN])
H1 = hatchedline(x,WINGSPAN*ones(1,length(x)),'k',pi/4);
H2 = hatchedline(x,MAXPOSABLE*ones(1,length(x)),'r',pi/4);
set(H1,'Color',[255 150 40]./255);
h(4) = H1(1);
h(5) = H2(1);

legend(h,'Focal Angle',Cam(1).name,Cam(2).name,...
    'Wingspan of Lead Plane',...
    sprintf('Pose estimate with one\nwingtip out of frame'),'Location','NW')
title('Effect of Focal Angle on Field of View')
xlabel('Distance to Target  (ft)')
ylabel('Horizontal Field of View  (ft)')



%{
% Loops

% Resolution

theta_show = [0:10:110];     % focal angle (degrees)
d = linspace(1, 30, 40);     % distance to object (ft)
theta = linspace(0,130,45);
[d, theta] = meshgrid(d, theta);


% Assume same aspect ratio as given by H_eye and W_eye
[~, w, h] = PPI_fun(d, theta, H_eye, W_eye);
FOV_dia = sqrt(w.^2 + h.^2);



w_cam = NaN(size(d,2), length(Cam));
h_cam = NaN(size(d,2), length(Cam));
for i = 1:size(d,2)
    for j = 1:length(Cam);
        
        [~, w_cam(i,j), h_cam(i,j)] = PPI_fun(d(1,i), Cam(j).theta, Cam(j).W, Cam(j).H);
        
    end
end
FOV_dia_cam = sqrt(w_cam.^2 + h_cam.^2);


% Plots

% Restructure matrix using interp
F = TriScatteredInterp(d(:), FOV_dia(:), theta(:));
[d_plot, FOV_dia_plot] = meshgrid(d(1,:),linspace(0,50,50));
theta_plot = F(d_plot, FOV_dia_plot);


figure
[C,h] = contour(d_plot, FOV_dia_plot, theta_plot, theta_show, 'k','DisplayName',...
    sprintf('Focal Angle\n assuming %1.4f AR',...
    W_eye/H_eye));

title('Effect of Focal Angle on Field of View')
xlabel('Distance to target  (ft)')
ylabel('Diagonal Field of View  (ft)')
clabel(C,h)
hold on
legend('-DynamicLegend','Location','NW')

linetype = {'b--' 'r--' 'g--' 'm--' 'c--' 'k--'};
for i = 1:length(Cam)
    
    plot(d(1,:), FOV_dia_cam(:,i), linetype{i}, 'DisplayName', Cam(i).name)
    
end
xlim([0 inf])
ylim([0 inf])
%}
