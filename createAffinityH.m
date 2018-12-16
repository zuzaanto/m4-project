function [H] = createAffinityH(theta,tx, ty, scale)
%CREATEH create homography matrix from rotation, translation and scale

H = zeros(3,3);

% R matrix
H(1,1) = scale*cos(theta);
H(1,2) = scale*(-1)*sin(theta);
H(2,1) = scale*sin(theta);
H(2,2) = scale*cos(theta);

% t vector
H(1,3) = tx;
H(2,3) = ty;

H(3,3) = 1;

end

