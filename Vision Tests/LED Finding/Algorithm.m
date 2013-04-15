function [DATA_OUT] = Algorithm(DATA_IN, params)

%% Group Data
[DATA] = dataGrouper(DATA_IN);

fldnames = fieldnames(DATA_IN);
tmpstr = [];

for k = 1:length(fldnames)
    if k > 1
        tmpstr = [tmpstr ','];
    end
    tmpstr = [tmpstr '''' fldnames{k} '''' ', []'];
end

DATA_OUT = eval(['struct(' tmpstr ')']);





for i = 1:length(DATA);
    
    
    %% Algorithm implementatation
    
    % compute deltas
    d_circularity = abs(params.target.circularity - DATA{i}.circularity);
    d_inertiaRatio = abs(params.target.inertiaRatio - DATA{i}.inertiaRatio);
    d_convexity = abs(params.target.convexity - DATA{i}.convexity);
    d_blobColor = abs(params.target.blobColor - DATA{i}.blobColor)/...
        (params.filter.blobColor.max - params.filter.blobColor.min);
    
    % compute total error
    
    num = (params.filter.circularity.by * params.w.circularity * d_circularity...
        + params.filter.inertiaRatio.by * params.w.inertiaRatio * d_inertiaRatio...
        + params.filter.convexity.by * params.w.convexity * d_convexity...
        + params.filter.blobColor.by * params.w.blobColor * d_blobColor);
    
    den = (params.filter.circularity.by * params.w.circularity...
        + params.filter.inertiaRatio.by * params.w.inertiaRatio...
        + params.filter.convexity.by * params.w.convexity...
        + params.filter.blobColor.by * params.w.blobColor);
    
    totErr = num/den;
    
    [~, idx] = sort(totErr);
    
    
    
    %% regroup into usual structure
    for j = 1:length(totErr)
        for k = 1:length(fldnames)
            
            %% Filter Data
            
            if (params.filter.error.by...
                    &&( DATA{i}.totalError(idx(j)) < params.filter.error.min...
                    || DATA{i}.totalError(idx(j)) >= params.filter.error.max))
                DATA_OUT.(fldnames{k})(end+1,1) =  NaN;
                continue;
            end
            
            if (params.filter.circularity.by...
                    &&( DATA{i}.circularity(idx(j)) < params.filter.circularity.min...
                    || DATA{i}.circularity(idx(j)) >= params.filter.circularity.max))
                DATA_OUT.(fldnames{k})(end+1,1) =  NaN;
                continue;
            end
            
            if (params.filter.inertiaRatio.by...
                    &&( DATA{i}.inertiaRatio(idx(j)) < params.filter.inertiaRatio.min...
                    || DATA{i}.inertiaRatio(idx(j)) >= params.filter.inertiaRatio.max))
                DATA_OUT.(fldnames{k})(end+1,1) =  NaN;
                continue;
            end
            
            if (params.filter.convexity.by...
                    &&( DATA{i}.convexity(idx(j)) < params.filter.convexity.min...
                    || DATA{i}.convexity(idx(j)) >= params.filter.convexity.max))
                DATA_OUT.(fldnames{k})(end+1,1) =  NaN;
                continue;
            end
            
            if (params.filter.blobColor.by...
                    && DATA{i}.blobColor(idx(j)) < params.filter.blobColor.min)
                DATA_OUT.(fldnames{k})(end+1,1) =  NaN;
                continue;
            end
            
            
            DATA_OUT.(fldnames{k})(end+1,1) =  DATA{i}.(fldnames{k})(idx(j));
            
        end
    end
    
end

