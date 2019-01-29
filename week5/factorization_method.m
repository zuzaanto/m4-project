function [Pproj,Xproj] = factorization_method(x1,x2)
%FACTORIZATION_METHOD Summary of this function goes here
%   Detailed explanation goes here
nimages = 2;
npoints = size(x1,2);
[q1, T1] = normalise2dpts(x1);
[q2, T2] = normalise2dpts(x2);

[F1, ~] = ransac_fundamental_matrix(q1,q2, 3);
[F2, ~] = ransac_fundamental_matrix(q2,q1, 3);

e1 = null(F1);
e2 = null(F2);

lambda1 = ones(npoints);
lambda2 = ones(npoints);

it = 0;

max_it = 20;
while it < max_it
    for i = 1:npoints
            wedge(e1,q1(:,i))*(F1*q1(:,i))
            temp1=wedge(e1,q1(:,i))
            F1*q1(:,i)
            norm(wedge(e1,q1(:,i))^2)
            (wedge(e1,q1(:,i))*(F1*q1(:,i)))/norm(wedge(e1,q1(:,i))^2)
            lambda1(i) = ((wedge(e1,q1(:,i))*(F1*q1(:,i)))/norm(wedge(e1,q1(:,i))^2))*lambda2(i);
            lambda2(i) = (dot(wedge(e2,q2(:,i)),(F2*q2(:,i)))/norm(wedge(e2,q2(:,i))^2))*lambda1(i);
    end
end

end

