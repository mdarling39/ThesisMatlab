clear all
close all
clc


%% Filenames, Logs, etc
mostRecentinEclipseWS = '~/Dropbox/Thesis/workspace/LEDDetectorTest/testfile.txt';


%filename = mostRecentinEclipseWS;
filename = 'testfile5.txt'%'inc5ft-0.txt';
filename

digitizedPlotData = 'Digi3'  % set equal to 'false' to manually digitize
totErrTolerance = 15;   % pixels  (accounts for plot digitization error)

%% Load the desired Data
disp('PARSING DATA...')
[DATA, params] = LEDFilteringParser(filename);

if(isempty(DATA))
    disp('NO DATA!!!')
    return
end

fldnames = fieldnames(DATA{1}{1});
fldnames(strcmpi(fldnames,'blobNo')) = [];


%% Modify paramaters and/or sorting Algorithm, if desired
% New Parameters  (uncomment to apply different weighting scheme)

params.maxPoints = 5;
% params.filter.error.max = 0.30;
% params.filter.area.min = 2;
% params.filter.area.max = 100;
% params.filter.circularity.min = 0.2;
% params.filter.circularity.max = 1.1;
% params.filter.inertiaRatio.min = 0.0;
% params.filter.inertiaRatio.max = 1.1;
% params.filter.convexity.min = 0.2;
% params.filter.convexity.max = 1.1;
% params.filter.blobColor.min = 250;
% 
% params.target.circularity = 1;
% params.target.inertiaRatio = 1;
% params.target.convexity = 1;
% params.target.blobColor = 255;
% 
% params.w.circularity = 200;
% params.w.inertiaRatio = 100;
% params.w.convexity = 200;
% params.w.blobColor = 150;
% 
% params.filter.error.by = false;
% params.filter.circularity.by = true;
% params.filter.inertiaRatio.by = true;
% params.filter.convexity.by = true;`
% params.filter.blobColor.by = true;
% 
% 
 [DATA] = Algorithm(DATA, params);













%% Generate Plots
colorcycle = {'b' 'g' 'r' 'm' 'c' 'y'...
    'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k'};

% generate a "timestep" vector (each t is a new frame)
t = 1:length(DATA);

% generate figures with subplots for each field
for k = 1:length(fldnames)
    
    fieldname = fldnames{k};
    
    % open figure, if needed & create new subplot axes
    if (rem(k,3) == 1)
        figure
    end
    h(k) = subplot(3,1,k - 3*floor(k/(3.1)));
    hold on
    
    
    %determine number of points at each timestep
    numPts = cellfun(@(x) length(x),DATA);
    
    % Plot each "priority" of data in decreasing order
    for j = fliplr(1:max(numPts))
        
        % Only plot the frames for which j image points exist
        tj = t(numPts>=j);
        xj = cellfun(@(x) x{j}.(fieldname),DATA(numPts>=j));
        if strcmpi(fieldname,'totalError')
            plot(tj,xj,'.','Color',colorcycle{j},...
                'DisplayName',sprintf('Priority = %3.0f',j));
        else
            plot(tj,xj,'.','Color',colorcycle{j});
        end
        
    end
    
    % plot filter lines (min/max)
    try
        plot([t(1) t(end)],repmat(params.filter.(fieldname).min,1,2),'k--')
        plot([t(1) t(end)],repmat(params.filter.(fieldname).max,1,2),'k--')
    end
    
    % plot target values
    try
        plot([t(1) t(end)],repmat(params.target.(fieldname),1,2),'r--')
    end
    
    % print title on figure
    title(fieldname)
    
    if strcmpi(fieldname,'totalError')
        legend('-DynamicLegend','Location','NorthEast');
    end
end

linkaxes(h,'x')



%% Ask to plot digitize if no file specified
if (~digitizedPlotData & any(strcmpi(fldnames,'imageXpt')))
    if(~strcmpi(input('Would you like to digitize (x,y) pixel data trends?(y/n)','s'),'y'))
        break
    end;
    digitizedPlotData = input('What would you like to name your file?','s');
    
    % Plot digitize x-pixels
    axes(h(7))
    fid = fopen([digitizedPlotData '_x.txt'],'w');
    disp('Please select a set of x-points to digitize:')
    while 1
        [x_in,y_in,button] = ginput(1);
        
        switch button
            case 1 % left-mouse click
                fprintf(fid,'%6.0f,%6.0f\n',x_in,y_in);
                plot(x_in,y_in,'r+');
                fprintf(1,'(%f,%f)%s\n',x_in,y_in,' -- Press ''x'' to stop recording points, or ''n'' for NaN');
            case char('n') %n-key pressed
                fprintf(fid,'%6s,%6s\n','NaN','NaN');
                fprintf(1,'(%s,%s)%s\n','NaN','NaN',' -- Press ''x'' to stop recording points, or ''n'' for NaN');
            case char('x') % x-key pressed
                newDigitizedPlotData = input('Would you like to return to digitizing x-points?(y/n)','s');
                if ~strcmpi(newDigitizedPlotData,'y')
                    fprintf(1,'\n\n');
                    break
                end
            otherwise
                disp('Plese press the left mouse button, ''x'', or ''n''')
        end
    end
    fclose(fid);
    
    
    % Plot digitize y-pixels
    axes(h(8))
    fid = fopen([digitizedPlotData '_y.txt'],'w');
    disp('Please select a set of y-points to digitize:')
    while 1
        [x_in,y_in,button] = ginput(1);
        
        switch button
            case 1 % left-mouse click
                fprintf(fid,'%6.0f,%6.0f\n',x_in,y_in);
                plot(x_in,y_in,'r+');
                fprintf(1,'(%f,%f)%s\n',x_in,y_in,' -- Press ''x'' to stop recording points, or ''n'' for NaN');
            case char('n') %n-key pressed
                fprintf(fid,'%6s,%6s\n','NaN','NaN');
                fprintf(1,'(%s,%s)%s\n','NaN','NaN',' -- Press ''x'' to stop recording points, or ''n'' for NaN');
            case char('x') % x-key pressed
                newDigitizedPlotData = input('Would you like to return to digitizing y-points?(y/n)','s');
                if ~strcmpi(newDigitizedPlotData,'y')
                    fprintf(1,'\n\n');
                    break
                end
            otherwise
                disp('Plese press the left mouse button, ''x'', or ''n''')
        end
    end
    fclose(fid);
    
end



if digitizedPlotData
    disp('DIGITIZED PLOT DATA AVAILALBE:')
    disp(digitizedPlotData)
    
    
    % Overlay interpolated data:
    axes(h(7))  % x-pixel locations
    Xdata = dlmread([digitizedPlotData '_x.txt'],',');
    plot(Xdata(:,1),Xdata(:,2),'r','LineWidth',3);
    
    
    
    axes(h(8))  % y-pixel locations
    Ydata = dlmread([digitizedPlotData '_y.txt'],',');
    plot(Ydata(:,1),Ydata(:,2),'r','LineWidth',3);
    
    
    % Break up data by index
    idxX = find(isnan(Xdata(:,1)));
    idxY = find(isnan(Ydata(:,1)));
    idxX = [0; idxX; length(Xdata)+1];
    idxY = [0; idxY; length(Ydata)+1];
    
    
    
    % compute x-error, y-error, and total (norm) error
    figure
    
    h(9) = subplot(3,1,1);
    
    % Need to modify this to keep track of minimum error at each frame
    % and which blob returns the lowest error add up errors to get a
    % total error value.  Use this information to quantify
    % false-identification rates and failure to detect rates. Use x and y
    % errors to compute a total error -- this will be the most helpful.
    
    for m = 1:(length(idxX)-1)
        
        % get range of t values and correspoinding expected pixel location
        t_trend = Xdata(idxX(m)+1,1) : Xdata(idxX(m+1)-1,1);
        x_trend = interp1(Xdata(idxX(m)+1:idxX(m+1)-1,1),Xdata(idxX(m)+1:idxX(m+1)-1,2),t_trend);
        
        subDATA = DATA(t_trend);
        
        %determine number of points at each timestep
        numPts = cellfun(@(x) length(x),subDATA);
        
        % Plot each "priority" of data in decreasing order
        for j = fliplr(1:max(numPts))
            
            % Only plot the frames for which j image points exist
            tj = t_trend(numPts>=j);
            xj = cellfun(@(x) x{j}.imageXpt,subDATA(numPts>=j));
            
            % compute error and save the times and errors for each m group
            % and "priority" j.
            XError{m}{j}.t = tj;
            XError{m}{j}.err = abs(xj - x_trend(numPts>=j));
            
            plot(tj,XError{m}{j}.err,'.','Color',colorcycle{j});
            hold on
            ylabel('| x-error |')
            
        end
        
    end
    
    
    h(10) = subplot(3,1,2);
    for m = 1:(length(idxY)-1)
        
        % get range of t values and correspoinding expected pixel location
        t_trend = Ydata(idxY(m)+1,1) : Ydata(idxY(m+1)-1,1);
        y_trend = interp1(Ydata(idxY(m)+1:idxY(m+1)-1,1),Ydata(idxY(m)+1:idxY(m+1)-1,2),t_trend);
        
        subDATA = DATA(t_trend);
        
        %determine number of points at each timestep
        numPts = cellfun(@(x) length(x),subDATA);
        
        % Plot each "priority" of data in decreasing order
        for j = fliplr(1:max(numPts))
            
            % Only plot the frames for which j image points exist
            tj = t_trend(numPts>=j);
            yj = cellfun(@(y) y{j}.imageYpt,subDATA(numPts>=j));
            
            % compute error and save the times and errors for each m group
            % and "priority" j.
            YError{m}{j}.t = tj;
            YError{m}{j}.err = abs(yj - y_trend(numPts>=j));
            
            plot(tj,YError{m}{j}.err,'.','Color',colorcycle{j});
            hold on
            ylabel('| y-error |')
            
        end
        
    end
    
    
    if length(XError) ~= length(YError)
        disp('x- and y- digitized data should have the same number of groups')
        return
    end
    
    h(11) = subplot(3,1,3);
    
    % find only the frames that we have x and y error data
    xdata = cellfun(@(x) x.t, [XError{:}],'UniformOutput',false);
    xdata = [xdata{:}];
    ydata = cellfun(@(x) x.t, [YError{:}],'UniformOutput',false);
    ydata = [ydata{:}];
    t_both = intersect(xdata,ydata);
    
    
    for m = 1:length(XError)    % step through each group
        
        %             %determine number of points at each timestep
        %             numPts = cellfun(@(x) length(x),XError{m});
        
        
        % Plot each "priority" of data in decreasing order
        for j = fliplr(1:length(XError{m}))
            
            % Only plot the frames for which j image points exist
            [TotError{m}{j}.t, ix, iy] = intersect(XError{m}{j}.t, YError{m}{j}.t);
            TotError{m}{j}.err = sqrt((XError{m}{j}.err(ix)).^2 + (YError{m}{j}.err(iy)).^2);
            
            plot(TotError{m}{j}.t,TotError{m}{j}.err,'.','Color',colorcycle{j});
            hold on
            ylabel('| total error |')
            
        end
    end
    plot(get(gca,'XLim'),[totErrTolerance totErrTolerance],'k--')
    
    linkaxes(h(9:11),'x')
    
    % turn all grids on
    set(h,'XGrid','on','YGrid','on')
    
    %% compute error statistics
    disp('Computing error statistics')
    
    fid2 = 1;
    
    fprintf(fid2,'%s\n','===== LED Finding Statistics =====');
    for m = 1:length(TotError)   %for each group
        fprintf(1,'\n%s%2d:','Group  #',m);
        
        %number of frames in this group
        nFrames(m) = TotError{m}{1}.t(end) - TotError{m}{1}.t(1) + 1;
        fprintf(fid2,'%6d    %s\n',nFrames(m),' total frames');
        
        
        % number of frames that LED was identified correctly (1st priority)
        idxIdentifiedLED = find(TotError{m}{1}.err < totErrTolerance);
        nIdentifiedLED(m) = length(idxIdentifiedLED);
        tIdentifiedLED{m} = TotError{m}{1}.t(idxIdentifiedLED);
        
        
        % number of frames we detected the LED at all
        clear tmp
        tmp.t = [cellfun(@(x) x.t,TotError{m},'UniformOutput',false)];
        tmp.err = [cellfun(@(x) x.err,TotError{m},'UniformOutput',false)];
        tmp = sortrows([[tmp.t{:}]' [tmp.err{:}]'],1);

        tDetectedLED{m} = unique(tmp(:,1));
        nDetectedLED(m) = 0;
        for cc = 1:length(tDetectedLED{m})
           idx = find(tmp(:,1) == tDetectedLED{m}(cc));
           if min(tmp(idx,2)) < totErrTolerance;
              nDetectedLED(m) = nDetectedLED(m) + 1; 
           end
        end
        
        
        
        propIdentifiedLED(m) = 100*nIdentifiedLED(m)/nFrames(m);
        propDetectedLED(m) = 100*nDetectedLED(m)/nFrames(m);
        
        fprintf(fid2,'\t%9.0f     %10s\n',nIdentifiedLED(m),'LEDs identified correclty');
        fprintf(fid2,'\t%9.0f     %10s\n',nDetectedLED(m),'LEDs detected');
        fprintf(fid2,'\t%9.2f     %10s\n',propIdentifiedLED(m),'percent of LEDs identified correclty');
        fprintf(fid2,'\t%9.2f     %10s\n',propDetectedLED(m),'percent of LEDs detected');
    end

    
end




