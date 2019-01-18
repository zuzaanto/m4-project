function [cost] = ssd_cost(x1,x2)
%SSD_COST Summary of this function goes here
%   Detailed explanation goes here
w = 1/(size(x1,1)*size(x1,2));

cost = sum(w*(x1-x2).^2,'all');

end

