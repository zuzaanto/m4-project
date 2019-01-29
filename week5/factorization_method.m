function [Pproj,Xproj] = factorization_method(x1,x2)
%FACTORIZATION_METHOD Summary of this function goes here
%   Detailed explanation goes here
nimages = 2;
[x1norm, T1] = normalise2dpts(x1);
[x2norm, T2] = normalise2dpts(x2);

[F, ~] = ransac_fundamental_matrix(x1norm,x2norm, 3);
e1 = x1(:,1);
e2 = x2(:,1);

it = 0;
max_it = 20;

while it < max_it
    for i = 1:nimages
        lambda(i
    end
end

end

