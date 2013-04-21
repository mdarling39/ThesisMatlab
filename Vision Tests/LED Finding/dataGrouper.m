function  [GROUPED_DATA] = dataGrouper(DATA)

j = 0;
fldnames = fieldnames(DATA);

for i = 1:length(DATA.blobNo)  % log file line
    
    if (DATA.blobNo(i) == 0 || isnan(DATA.blobNo(i)))  % new frame
        j = j + 1;
        i2 = 1;  %image point
    end
    
    
    for k = 1:length(fldnames)
        GROUPED_DATA{j}{i2}.(fldnames{k}) = DATA.(fldnames{k})(i);
    end
    i2 = i2 + 1;
    
end