function  [GROUPED_DATA] = dataGrouper(DATA)

j = 0;
GROUPED_DATA = cell(0,0);
fldnames = fieldnames(DATA);

for i = 1:length(DATA.blobNo)
    
    if (DATA.blobNo(i) == 0)
        j = j + 1;
        for k = 1:length(fldnames)
            tmpStruct.(fldnames{k}) = [];
        end
    end
    
    for k = 1:length(fldnames)
        tmpStruct.(fldnames{k})(end+1) = DATA.(fldnames{k})(i);
    end
    
    GROUPED_DATA{j} = tmpStruct;
    
end