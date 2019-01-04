function [H] = createProjectiveH(h1,h2,h3,h4,h5,h6,h7,h8)
%CREATEPROJECTIVEH create homography matrix from 8 params
H = ones(3,3);
H(1,1)=h1;
H(1,2)=h2;
H(1,3)=h3;
H(2,1)=h4;
H(2,2)=h5;
H(2,3)=h6;
H(3,1)=h7;
H(3,2)=h8;
end
