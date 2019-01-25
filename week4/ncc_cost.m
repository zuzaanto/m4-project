function [cost] = ncc_cost(x1,x2)
%SSD_COST Summary of this function goes here
%   Detailed explanation goes here

w = 1/(size(x1,1)*size(x1,2));
disp(size(x1))


mean1 = mean(x1(:));
mean2 = mean(x2(:));



sigma1 = sqrt(sum(sum(w*(x1-mean1).^2)));
sigma2 = sqrt(sum(sum(w*(x2-mean2).^2)));

cost = sum(w*(x1-mean1).*(x2-mean2))/(sigma1*sigma2);

end
