function [Pproj,Xproj] = factorization_method(x1,x2)
%FACTORIZATION_METHOD Summary of this function goes here
%   Detailed explanation goes here

[x1norm, T1] = normalise2dpts(x1);
[x1norm, T1] = normalise2dpts(x2);

[F, ~] = ransac_fundamental_matrix(x1norm,x2norm, 3);


end

