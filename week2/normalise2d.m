function [normPts, T] = normalise2d(pts)
    
% compute center of a set of points
center = mean(pts(1:2,:)')';

% shift points to the center
shiftedPts(1,:) = pts(1,:)-center(1);
shiftedPts(2,:) = pts(2,:)-center(2);

% compute distance of each point to the center
dist = sqrt(shiftedPts(1,:).^2 + shiftedPts(2,:).^2);

% calculate mean distance           
meanDistance = mean(dist(:));

% determine the scale factor to achieve mean distance equal to sqrt(2)
scale = sqrt(2)/meanDistance;

% create the homography matrix for similarity transform     
T = [scale   0   -scale*center(1)
     0     scale -scale*center(2)
     0       0      1      ];

% transform points     
normPts = T*pts;

end