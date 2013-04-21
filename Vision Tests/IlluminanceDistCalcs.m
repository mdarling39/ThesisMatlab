clear all; close all; clc;
%setgcadefaults();

d2r = pi/180;
r2d = 180/pi;
f2m = 0.3048;
m2f = 3.28084;


% 50 Lumen LED Characteristics  (SuperBrightLEDs.com)
LED1.theta = 90/2*d2r;  % degrees
LED1.lumens = 50;       % lumens
LED1.candelas = NaN;    % candelas
LED1.angularSpan = NaN; % steradians
LED1.lux = NaN;         % lux


% Luxeon Star LEDs:
LED2.theta = 120/2*d2r;     % degrees
LED2.lumens = [50:50:750];
LED2.candelas = NaN;
LED2.angularSpan = NaN;
LED2.lux = NaN;


% Freaking Laser Beam LED
LED3.theta = 120/2*d2r;
LED3.lumens = 1625;
LED3.candelas = NaN;
LED3.angularSpan = NaN;
LED3.lux = NaN;


% Function for computing Illuminance
luxCalcFun = @(lum,angSpn,dist_ft) lum./(angSpn.*(dist_ft*f2m).^2);
lumensCalcFun = @(lux,angSpn,dist_ft) lux.*(angSpn.*(dist_ft*f2m).^2);



distance = linspace(2,65,150);
luxgrid = linspace(0,2.0,100);
[distMesh,luxMesh] = meshgrid(distance,luxgrid);


LED1.angularSpan = 2*pi*(1-cos(LED1.theta));
LED1.candelas = LED1.lumens/LED1.angularSpan;
LED1.lux =  luxCalcFun(LED1.lumens,LED1.angularSpan,distance);

for i = 1:length(distance);
    for j = 1:length(luxgrid);
        LED2.angularSpan = 2*pi*(1-cos(LED2.theta));
        LED2.candelas = LED2.lumens/LED2.angularSpan;
        lumensContour(i,j) =  lumensCalcFun(luxgrid(j),LED2.angularSpan,distance(i));
    end
end

LED3.angularSpan = 2*pi*(1-cos(LED3.theta));
LED3.candelas = LED3.lumens/LED3.angularSpan;
LED3.lux =  luxCalcFun(LED3.lumens,LED3.angularSpan,distance);



figure
hold all
h1 = plot(distance,LED1.lux,'b');
[C,h2] = contour(distMesh,luxMesh,lumensContour',LED2.lumens,'k');
clabel(C,h2,'margin',0.1);
h3 = plot(distance,LED3.lux,'r');
title('Illuminance as a function of Distance');
xlabel('Distance  (ft)');
ylabel('Illuminance  (lux)');
ylim([0 max(luxgrid)]);
legend([h1 h2 h3],'50 Lumen SuperBright LED','Luxeon Star LEDs',sprintf('2000 Lumen LED\nused by Mahboubi et al.'))
uistack(h3,'top');
uistack(h1,'top');
grid on
