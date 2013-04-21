function [DATA_OUT] = Algorithm(DATA, params)

disp('APPLYING MATLAB-BASED FILTERING ALGORITHM...')

fldnames = fieldnames(DATA{1}{1});


for i = 1:length(DATA);  % for each frame
    
    thisFrame = DATA{i};
    frameOut = {};
    jj = 0;  % thresholded point index
    
    for j = 1:length(thisFrame)  % for each imagePoint
        
        
        % Filter Data
        
        % filter by circularity
        if (params.filter.circularity.by...
                &&( thisFrame{j}.circularity < params.filter.circularity.min...
                || thisFrame{j}.circularity >= params.filter.circularity.max))
            break
        end
        d_circularity = abs(params.target.circularity - thisFrame{j}.circularity);
        
        % filter by inertiaRatio
        if (params.filter.inertiaRatio.by...
                &&( thisFrame{j}.inertiaRatio < params.filter.inertiaRatio.min...
                || thisFrame{j}.inertiaRatio >= params.filter.inertiaRatio.max))
            break
        end
        d_inertiaRatio = abs(params.target.inertiaRatio - thisFrame{j}.inertiaRatio);
        
        % filter by convexity
        if (params.filter.convexity.by...
                &&( thisFrame{j}.convexity < params.filter.convexity.min...
                || thisFrame{j}.convexity >= params.filter.convexity.max))
            break
        end
        d_convexity = abs(params.target.convexity - thisFrame{j}.convexity);
        
        % filter by blob color
        if (params.filter.blobColor.by...
                && thisFrame{j}.blobColor < params.filter.blobColor.min)
            break
        end
        d_blobColor = abs(params.target.blobColor - thisFrame{j}.blobColor)/...
            (255 - params.filter.blobColor.min);
        
        
        % compute total error
        num = (params.filter.circularity.by * params.w.circularity * d_circularity...
            + params.filter.inertiaRatio.by * params.w.inertiaRatio * d_inertiaRatio...
            + params.filter.convexity.by * params.w.convexity * d_convexity...
            + params.filter.blobColor.by * params.w.blobColor * d_blobColor);
        
        den = (params.filter.circularity.by * params.w.circularity...
            + params.filter.inertiaRatio.by * params.w.inertiaRatio...
            + params.filter.convexity.by * params.w.convexity...
            + params.filter.blobColor.by * params.w.blobColor);
        
        if den == 0
            den = 1;
        end
        
        thisFrame{j}.totalError = num/den;
        
        
        % filter by total error
        if (params.filter.error.by...
                &&( thisFrame{j}.totalError < params.filter.error.min...
                || thisFrame{j}.totalError >= params.filter.error.max))
            break
        end
        
        
        % Meets threshold requirements
        for k = 1:length(fldnames)
            if k == 1
                jj =  jj + 1;
            end
            frameOut{jj}.(fldnames{k}) = thisFrame{j}.(fldnames{k});
        end
        
    end  % image point
    
    
    
    if isempty(frameOut)
        DATA_OUT{i} = emptyFrame();
    else
        % Sort by increasing total error
        frameOut = errorSort(frameOut);
        
        if isfield(params,'maxPoints')
            rng = [1 : min([params.maxPoints length(frameOut)]) ];
            DATA_OUT{i} = frameOut(rng);
        else
        DATA_OUT{i} = frameOut;
        end
    end
    
    
end  % frame




    function [sortedFrame_] = errorSort(frameIn_)
        
        for j_ = 1:length(frameIn_)
            totalErrorVec_(j_) = frameIn_{j_}.totalError;
        end
        
        [~,idx_] = sort(totalErrorVec_);
        
        for j_ = 1:length(frameIn_)
            for k_ = 1:length(fldnames)
                sortedFrame_{j_}.(fldnames{k_}) = frameIn_{idx_(j_)}.(fldnames{k_});
            end
        end
        
    end


    function [emptyFrame_] = emptyFrame()
        
        for k_ = 1:length(fldnames)
            emptyFrame_.(fldnames{k}) = NaN;
        end
        
    end


end


