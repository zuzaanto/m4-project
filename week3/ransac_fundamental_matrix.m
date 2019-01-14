function [H, idx_inliers] = ransac_fundamental_matrix(x1, x2, th)

[Ncoords, Npoints] = size(x1);

% ransac
it = 0;
best_inliers = [];
% probability that at least one random sample set is free of outliers
p = 0.999; 
max_it = 10000;
while it < max_it
    
    points = randomsample(Npoints, 8);
    H = fundamental_matrix(x1(:,points), x2(:,points));
    inliers = compute_inliers(H, x1, x2, th);
        
    % test if it is the best model so far
    if length(inliers) > length(best_inliers)
        best_inliers = inliers;
    end    
    
    % update estimate of max_it (the number of trials) to ensure we pick, 
    % with probability p, an initial data set with no outliers
    fracinliers =  length(inliers)/Npoints;
    pNoOutliers = 1 -  fracinliers^4;
    pNoOutliers = max(eps, pNoOutliers);  % avoid division by -Inf
    pNoOutliers = min(1-eps, pNoOutliers);% avoid division by 0
    max_it = log(1-p)/log(pNoOutliers);
    
    it = it + 1;
end

% compute H from all the inliers
H = fundamental_matrix(x1(:,best_inliers), x2(:,best_inliers));
idx_inliers = best_inliers;


function idx_inliers = compute_inliers(F, x1, x2, th)
    % normalise homogeneous coordinates (third coordinate to 1)
    x1 = normalise(x1);
    x2 = normalise(x2);     

    % compute the sampson error
    Fx1 = F*x1;
    Fx2 = F'*x2;
    
    x2Fx1 = x2'*F*x1;
    x2Fx1 = diag(x2Fx1)';
       
    d2=((x2Fx1).^2./...
        (Fx1(1,:).^2 + Fx1(2,:).^2 + Fx2(1,:).^2 + Fx2(2,:).^2));
    
    idx_inliers = find(d2 < th^2);


function xn = normalise(x)    
    xn = x ./ repmat(x(end,:), size(x,1), 1);

    
function item = randomsample(npts, n)
	a = [1:npts]; 
    item = zeros(1,n);    
    for i = 1:n
	  % Generate random value in the appropriate range 
	  r = ceil((npts-i+1).*rand);
	  item(i) = a(r);       % Select the rth element from the list
	  a(r)    = a(end-i+1); % Overwrite selected element
    end                       % ... and repeat