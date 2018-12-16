function [H] = createAffinityH(theta,phi, tx, ty, scalex, scaley)
%CREATEAFFINITYH create homography matrix from rotation, translation and scale

H = zeros(3,3);

% R matrix
H(1,1) = scalex*cos(theta);
H(1,2) = scalex*(-1)*sin(theta);
H(2,1) = scaley*sin(phi);
H(2,2) = scaley*cos(phi);

% t vector
H(1,3) = tx;
H(2,3) = ty;

H(3,3) = 1;

end

