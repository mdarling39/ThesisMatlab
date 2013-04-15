function [xout] = mavg(x,n)

persistent xBuff idx;

if (~isvarname('xBuff') || (length(xBuff) ~= n))
    xBuff = zeros(1,n);
    xout = nan(size(x));
end

for idx = 1:length(x)
        tmpBuff = xBuff;
        xBuff = circshift(tmpBuff(:),1);
        xBuff(1) = x(idx);
        xout(idx) = mean(xBuff);
end

clear xBuff;