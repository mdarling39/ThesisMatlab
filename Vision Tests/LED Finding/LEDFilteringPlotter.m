clear all
clc


filename = 'testfile2.txt';
fldnames = {'totalError' 'circularity' 'inertiaRatio'...
    'convexity' 'blobColor' 'area'};

[DATA, params] = LEDFilteringParser(filename);


% New Parameters  (uncomment to apply different weighting scheme)
% params.filter.error.by = false;
% params.filter.circularity.by = true;
% params.filter.inertiaRatio.by = true;
% params.filter.convexity.by = true;
% params.filter.blobColor.by = true;
% 
% params.filter.error.max = 0.3;
% params.filter.circularity.min = 0.5;
% params.filter.circularity.max = 1.1;
% params.filter.inertiaRatio.min = 0.33;
% params.filter.inertiaRatio.max = 1.1;
% params.filter.convexity.min = 0.6;
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
% params.w.circularity = 100;
% params.w.inertiaRatio = 75;
% params.w.convexity = 200;
% params.w.blobColor = 150;
% 
% [DATA] = Algorithm(DATA, params);



%% Plots


try
    d0 = (DATA.blobNo == 0);
    d1 = (DATA.blobNo == 1);
    d2 = (DATA.blobNo == 2);
    d3 = (DATA.blobNo == 3);
    d4 = (DATA.blobNo == 4);
    d5 = (DATA.blobNo == 5);
end
t = cumsum(DATA.blobNo == 0 | isnan(DATA.blobNo));


for i = 1:length(fldnames)
    
    fieldname = fldnames{i};
    
    if (rem(i,3) == 1)
        figure
    end
    h(i) = subplot(3,1,i - 3*floor(i/(3.1)));
    hold on
    plot(t(d5),DATA.(fieldname)(d5),'c.')
    plot(t(d4),DATA.(fieldname)(d4),'k.')
    plot(t(d3),DATA.(fieldname)(d3),'m.')
    plot(t(d2),DATA.(fieldname)(d2),'r.')
    plot(t(d1),DATA.(fieldname)(d1),'g.')
    plot(t(d0),DATA.(fieldname)(d0),'b.')
    try
        plot([t(1) t(end)],repmat(params.filter.(fieldname).min,1,2),'k--')
        plot([t(1) t(end)],repmat(params.filter.(fieldname).max,1,2),'k--')
    end
    try
        plot([t(1) t(end)],repmat(params.target.(fieldname),1,2),'r--')
    end
    
    title(fieldname)
end

linkaxes(h,'x')
