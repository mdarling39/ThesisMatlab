% Display 3-D representation of airplane LED model


clear all
close all
clc

load LEDPos.mat
xCV = LEDPoscopy2(:,1);
yCV = LEDPoscopy2(:,2);
zCV = LEDPoscopy2(:,3);



% convert to typical NED frame
x = zCV;
y = xCV;
z = yCV;


% plot the LED positions in 3D space
plot3(x,y,z,'ro','LineWidth',3,'MarkerFaceColor','r');
hold on
plot3([x(1) x(5)],[y(1) y(5)],[z(1) z(5)],'g','LineWidth',2)
plot3([x(2) x(4)],[y(2) y(4)],[z(2) z(4)],'b','LineWidth',2)
plot3([mean([x(2) x(4)]) x(3)],...
[mean([y(2) y(4)]) y(3)],...
[mean([z(2) z(4)]) z(3)],'m','LineWidth',2)
plot3([mean([x(2) x(4)]) 0],...
[mean([y(2) y(4)]) 0],...
[0 0],'k','LineWidth',4)
%plot3([x(2) x(3)],[y(2) y(3)],[z(2) z(3)],'k','LineWidth',1)
%plot3([x(4) x(3)],[y(4) y(3)],[z(4) z(3)],'k','LineWidth',1)
%plot3([x(1) x(3)],[y(1) y(3)],[z(1) z(3)],'k','LineWidth',1)

grid on
axis equal
set(gca,'ZDir','reverse','YDir','reverse')
xlabel('x')
ylabel('y')
zlabel('z')



% First guesses at identifying LEDs:
%
% 1) Compute the mean piont of all 5 LEDs  (will be pulled near the tail)
% 2) Choose the point that lies the farthest distance from the mean point
%    (this must be a wingtip)
% 3) Decide if this is a left or right wingtip (left or right of mean point?)
% 4) Find the closest point to this wingtip -- this will be the horizontal of
% the same side
% 5) 

% 5) Compute the slope (angle) of the line connecting these two points
% 6) Pick any two of the remaining 3 LEDs and for each, compute the slope
% (angle) made by connecting this point to the two otheres
% 7) The closest to being colinear with the wings is the horizontal stabilizer
% 8) Left stabilizer will be closest to left wingtip
