% Michael Darling
% Pixels Per Inch


function [PPI, w, h] = PPI_fun(d, theta, W, H)

% d         distance to target (ft)
% theta     lens focal angle (deg)
% W         # of pixels wide
% H         # of pixels high

% PPI       Pixels Per Inch
% w         visible field of view  (width)
% h         visible field of view  (height)


% Physical dimensions
dia = 2*d.*tand(theta/2);       % physical diameter
alpha = atan(H./W);             % angle of rectangle (depends on AR)
h = dia.*sin(alpha);            % visible height (ft)
w = dia.*cos(alpha);            % visible width (ft)
a = h.*w;                       % area of rectangle circumscribed by circle

% Image dimensions
%DIA = sqrt(H.^2 + W.^2);        % diameter of image (pixels)
A = H.*W;                       % number of pixels


PPI = A./(a*12);                % pixels per square inch

end





