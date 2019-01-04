function [H] = homography2d(x1, x2)
%HOMOGRAPHY2D Summary of this function goes here
%   Detailed explanation goes here
pts1 = euclid(x1);
pts2 = euclid(x2);
n = size(pts1,2);
A = zeros(2*n,9);
A(1:2:2*n,1:2) = pts1';
A(1:2:2*n,3) = 1;
A(2:2:2*n,4:5) = pts1';
A(2:2:2*n,6) = 1;
x1 = pts1(1,:)';
y1 = pts1(2,:)';
x2 = pts2(1,:)';
y2 = pts2(2,:)';
A(1:2:2*n,7) = -x2.*x1;
A(2:2:2*n,7) = -y2.*x1;
A(1:2:2*n,8) = -x2.*y1;
A(2:2:2*n,8) = -y2.*y1;
A(1:2:2*n,9) = -x2;
A(2:2:2*n,9) = -y2;
[evec,~] = eig(A'*A);
H = reshape(evec(:,1),[3,3])';
H = H/H(end); % make H(3,3) = 1



% x = x1;
% y = x2;
% 
% [n,k ] = size(x);
% [m,ky] = size(y);
% q = m
% % dimensionality check
% assert(k == ky);
% assert(q > 0 && q <= m);
% % make y inhomogeneous
% r = setdiff(1:m,q);
% y = bsxfun(@rdivide,y(r,:),y(q,:));
% % build the homogeneous linear system
% A = zeros(m,n,k,m-1);
% for i = 1:numel(r)
%     j = r(i);
%     b = -bsxfun(@times,x,y(i,:));
%     A(j,:,:,i) = reshape(x,1,n,k);
%     A(q,:,:,i) = reshape(b,1,n,k);
% end
% % convert to a big flat matrix
% A = reshape(A,m*n,[]);
% % solve the homogeneous linear system using SVD
% [~,~,V] = svd(A*A');
% % the solution minimising |A'A| is the right singular vector
% % corresponding to the smallest singular value
% A = reshape(V(:,end),m,n);
% % some normalisation, optional
% A = A / norm(A) * sign(A(1,1));
% 
% H = A;
end

