clear all
clc


filename = 'testfile5.txt';

%% Load the desired Data
[DATA, params] = LEDFilteringParser(filename);
fldnames = fieldnames(DATA);
fldnames(strcmpi(fldnames,'blobNo')) = [];

%% Modify paramaters and/or sorting Algorithm, if desired
% New Parameters  (uncomment to apply different weighting scheme)
% params.filter.error.by = true;
% params.filter.circularity.by = true;
% params.filter.inertiaRatio.by = true;
% params.filter.convexity.by = true;
% params.filter.blobColor.by = true;
% 
% params.filter.error.max = 0.26;
% params.filter.area.min = 2;
% params.filter.area.max = 75;
% params.filter.circularity.min = 0.2;
% params.filter.circularity.max = 1.1;
% params.filter.inertiaRatio.min = 0.1;
% params.filter.inertiaRatio.max = 1.1;
% params.filter.convexity.min = 0.4;
% params.filter.convexity.max = 1.1;
% params.filter.blobColor.min = 250;
% 
% params.target.circularity = 1;
% params.target.inertiaRatio = 1;
% params.target.convexity = 1;
% params.target.blobColor = 255;
% 
% params.filter.blobColor.min = 255;
% 
% params.w.circularity = 200;
% params.w.inertiaRatio = 75;
% params.w.convexity = 200;
% params.w.blobColor = 150;
% 
% [DATA] = Algorithm(DATA, params);



%% Generate Plots

colorcycle = {'b' 'g' 'r' 'm' 'c' 'y' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k' 'k'};

% organize by priority
for ii = 1:max(DATA.blobNo)
    i2 = (max(DATA.blobNo) - ii);
    eval(['d' num2str(i2) '= DATA.blobNo ==' num2str(i2) ';']);
end
%     d0 = (DATA.blobNo == 0);

% generate a "timestep" vector (each t is a new frame)
t = cumsum((DATA.blobNo == 0) | (isnan(DATA.blobNo)));


% generate figures with subplots for each field
for i = 1:length(fldnames)
    
    fieldname = fldnames{i};
    
    % open figure, if needed & create new subplot axes
    if (rem(i,3) == 1)
        figure
    end
    h(i) = subplot(3,1,i - 3*floor(i/(3.1)));
    hold on
    
    % Plot each "priority" of data
    for ii = 1:max(DATA.blobNo)
        i2 = (max(DATA.blobNo) - ii);
        eval(['plot(t(d' num2str(i2) '),DATA.(fieldname)(d'...
            num2str(i2) '),' '''' colorcycle{i2+1} '.' '''' ')'])

        %         plot(t(d5),DATA.(fieldname)(d5),'c.')

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
    end
end

linkaxes(h,'x')
