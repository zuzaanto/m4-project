function [rotation1, rotation2, scale, translation] = decomposeAffinity(H)
%DECOMPOSEAFFINITY Summary of this function goes here
%   Detailed explanation goes here
translation=zeros(3,3);
translation(1:2,3)=H(1:2,3);
translation(1,1)=1;
translation(2,2)=1;
translation(3,3)=1;
H(1,3)=0;
H(2,3)=0;
A=H(1:2,1:2);
[U,D,V]=svd(A);
scale=zeros(3,3);
scale(1:2,1:2)=D;
rotation1=zeros(3,3);
rotation1(1:2,1:2)=U;
rotation2=zeros(3,3);
rotation2(1:2,1:2)=transpose(V);
scale(3,3)=1;
rotation1(3,3)=1;
rotation2(3,3)=1;
end