clear all
close all
clc

%% "defines"
XMAX = 1000;
dtMult = 1;
n_MAVG = 120;



t = linspace(0,100,1000);
x = @(t_in) (XMAX/t(end) - 0)*t_in + normrnd(0,2);

dt = dtMult*median(diff(t));

%% Kalman Filter Parameters


% initial a posteriori estimator
xk = [0; 0];

% transitionMatrix
A = [1 dt; 0 1];

% measurementMatrix
H = [1 0];

% processNoiseCovariance
Q = 1*eye(2,2);

% measurementNoiseCovariance
R = 15*eye(1,1);

% initial a posteriori error covariance
Pk = eye(2,2);



%% Kalman Filtering
zk = 0;
vel_arr = zeros(n_MAVG,1);

for i = 1:length(t)
    
    pos = x(t(i));  % current true positon
    
    
    if t(i) <= mean(t)
        
        % KF predict
        xkm = A*xk;     % (no control)
        Pkm = A*Pk*A' + Q;
        
        zkold = zk;
        zk = pos + normrnd(0,10);    % measurement = true pos + noise
        
        % approximate velocity
%         vel_arr = circshift(vel_arr,1);
%         vel_arr(1,:) = (zk - zkold)/dt;
%         vel_est = mean(vel_arr);
        
        % KF correct
        Kk = (Pkm*H')/(H*Pkm*H' + R);
        xk = xkm + Kk * (zk - H*xkm);
        Pkm = (eye(2,2) - Kk*H) * Pkm;
    
    else
        zk = [];
        
        % KF predict
        xkm = A*xk;
        %xkm(2) = vel_est;
        
        % Fake no-measurement -- use a priori estimate
        xk = xkm;
        
    end

    
%% Plot results
    cla
    hold on
    plot(pos,0,'o','MarkerSize',14);
    if ~isempty(zk) 
        plot(zk,0,'go','MarkerSize',14);
    end
    plot(xk(1),0,'r+','MarkerSize',14);
    xlim([0 XMAX]);
    
    pause(0.01);
end
close all

