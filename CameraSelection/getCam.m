function [Cam] = getCam(CamName)


switch CamName
    case 'PS3Eye'
        % PS3 Eye
        
        Cam(1).name = 'Sony PS3 Eye (320x240) - 56 deg';
        Cam(1).W = 320;
        Cam(1).H = 240;
        Cam(1).theta = 56;
        Cam(1).plotColor = 'g--';
        
        Cam(2).name = 'Sony PS3 Eye (320x240) - 75 deg';
        Cam(2).W = 320;
        Cam(2).H = 240;
        Cam(2).theta = 75;
        Cam(2).plotColor = 'm--';
        
        Cam(3).name = 'Sony PS3 Eye (640x480) - 56 deg';
        Cam(3).W = 640;
        Cam(3).H = 480;
        Cam(3).theta = 56;
        Cam(3).plotColor = 'r--';
        
        Cam(4).name = 'Sony PS3 Eye (640x480) - 75 deg';
        Cam(4).W = 640;
        Cam(4).H = 480;
        Cam(4).theta = 75;
        Cam(4).plotColor = 'b--';
    otherwise
        disp('Invalid camera name');
end;