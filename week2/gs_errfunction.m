function [ diff ] = gs_errfunction( P0, Xobs )
%% P0(vector) ==> H (first 9 elemnets) & x (rest of the elements)
H = P0(1:9);
H = reshape(H,[3,3]);
xHat = P0(10:end);
nPoints = size(xHat,1)/2;
xHat = [reshape(xHat, [2,nPoints]) ; ones(1,nPoints)]; % to homogeneous

%% Xobs ==> x and xp
x  = reshape(Xobs(1:nPoints*2)      , [2,nPoints]);
xp = reshape(Xobs((nPoints*2)+1:end), [2,nPoints]); 
    
%% Reprojection error
xHatProjected = H*xHat;  % xHatProjected = x_Hat_Prime in the reference
diff = [ d(x-euclid(xHat)) ; d(xp-euclid(xHatProjected)) ];

end


function euclid_dist = d(x)
    euclid_dist = sqrt(sum(x.^2, 1));  % Euclid distance for each column
end