function [ X ] = triangulate( x1, x2, P1, P2, dim )
%Triangulation of the 3D point X given the correspondences x1<->x2 and
%the corresponding P1 and P2 projection matrices using the DLT algorithm.

% H = [2/dim(1), 0,        -1;
%      0,        2/dim(2), -1;
%      0,        0,         1];
% 
% x1 = [x1;1];
% x2 = [x2;1];
% 
% x1 = H*x1;
% x2 = H*x2;
% P1 = H*P1;
% P2 = H*P2;

A = [(x1(1) * P1(3,:)) - P1(1,:);
     (x1(2) * P1(3,:)) - P1(2,:);
     (x2(1) * P2(3,:)) - P2(1,:);
     (x2(2) * P2(3,:)) - P2(2,:)];

[U, S, V] = svd(A);

X = V(:,4);
X = X./X(4);

end

