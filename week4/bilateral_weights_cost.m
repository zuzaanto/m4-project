function [cost] = bilateral_weights_cost(x1,x2, d, type)
%BILATERAL_WEIGHTS Summary of this function goes here
%   Detailed explanation goes here

[nrows, ncols] = size(x1);
gamma_c = 4;
gamma_g = ncols/2;
rowStep = (nrows-1)/2;
colStep = (ncols-1)/2;

x = -colStep:colStep;
y = -rowStep:rowStep;
[X,Y] = meshgrid(x,y);


delta_g = sqrt(X.^2+Y.^2);

delta_c1 = abs(x1-x1(colStep+1, rowStep+1));
w1 = exp(-delta_c1./gamma_c-delta_g./gamma_g);

delta_c2 = abs(x2-x2(colStep+1, rowStep+1));
w2 = exp(-delta_c2./gamma_c-delta_g./gamma_g);

w=w1.*w2;

if(strcmp(type,'NCC'))
    mean1 = mean(x1(:));
    mean2 = mean(x2(:));
    sigma1 = sqrt(sum(sum(w*(x1-mean1).^2)));
    sigma2 = sqrt(sum(sum(w*(x2-mean2).^2)));
    cost = sum(sum(w.*(x1-mean1).*(x2-mean2)))/(sigma1*sigma2);
else
    cost = sum(sum(w.*(x1-x2).^2))/sum(sum(w));


end
