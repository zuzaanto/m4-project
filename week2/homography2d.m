function [H] = homography2d(pts1, pts2)
%HOMOGRAPHY2D Summary of this function goes here
%   Detailed explanation goes here

n = size(pts1,2);
A = zeros(2*n,9);

x = pts1(1,:)';
y = pts1(2,:)';
u = pts2(1,:)';
v = pts2(2,:)';

A(1:2:2*n,1:3) = -pts1';
A(2:2:2*n,4:6) = -pts1';

A(1:2:2*n,7) = u.*x;
A(2:2:2*n,7) = v.*x;
A(1:2:2*n,8) = u.*y;
A(2:2:2*n,8) = v.*y;
A(1:2:2*n,9) = u;
A(2:2:2*n,9) = v;

[evec,~] = eig(A'*A);
H = reshape(evec(:,1),[3,3])';
H = H/H(end); % H(3,3) = 1

end

