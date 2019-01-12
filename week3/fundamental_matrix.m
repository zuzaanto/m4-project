function [F] = fundamental_matrix(x1,x2)
%FUNDAMENTAL_MATRIX Summary of this function goes here
%   Detailed explanation goes here
[x1,T1]=normalise2dpts(x1);
[x2,T2]=normalise2dpts(x2);
u1=x1(1,:)';
v1=x1(2,:)';
u2=x2(1,:)';
v2=x2(2,:)';
W=[u1.*u2 v1.*u2 u2 u1.*v2 v1.*v2 v2 u1 v1 ones(size(x1,2),1)];
[U, D, V] = svd(W);
f=V(:,end);
F3 = reshape(f, [3,3]);
[U, D, V] = svd(F3);
D(3,3)=0;
F=U*D*V';
F=T2'*F*T1;
end

