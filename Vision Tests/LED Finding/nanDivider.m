function [dataOut] = nanDivider(data)


dataOut{1} = [];
j = 1;
for i = 1:length(data)
    
    if (isnan(data(i,1)))
        j = j+1;
        dataOut{j} = [];
        continue
    end
    
    dataOut{j}(end+1,:) = data(i,:);
        
    
end