function [cost] = ncc_cost(x1,x2)
%SSD_COST Summary of this function goes here
%   Detailed explanation goes here

w = 1/(size(x1,1)*size(x1,2));

mean1 = mean(x1,'all');
mean2 = mean(x2,'all');

sigma1 = sqrt(sum(w*(x1-mean1).^2,'all'));
sigma2 = sqrt(sum(w*(x2-mean2).^2,'all'));

cost = sum(w*(x1-mean1).*(x2-mean2),'all')/(sigma1*sigma2);

end
