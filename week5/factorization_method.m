function [Pproj,Xproj] = factorization_method(x1,x2, initialization)
%FACTORIZATION_METHOD Summary of this function goes here
%   Detailed explanation goes here
nimages = 2;
npoints = size(x1,2);
[q1, T1] = normalise2dpts(x1);
[q2, T2] = normalise2dpts(x2);

[F1, ~] = ransac_fundamental_matrix(q1,q1, 3)
[F2, ~] = ransac_fundamental_matrix(q2,q1, 3)

% e1 = null(F1);
% e2 = null(F2);

[U, D, V] = svd(F1);
e1 = V(:,3) / V(3,3);
[U, D, V] = svd(F2);
e2 = V(:,3) / V(3,3);

%  initialization with ones
lambda1 = ones(npoints,1);
lambda2 = ones(npoints,1);

%      Initialization proposed by Sturm&Triggs
iterate = true;
if isequal(initialization, 'sturm')
    lambda_old1 = lambda1;
    lambda_old2 = lambda2;
    for i = 1:npoints
        lambda1(i) = (q1(:,i)'*F1*cross(e1,q1(:,i)))/(norm(cross(e1,q1(:,i)))^2)*lambda1(i);
    end
    for i = 1:npoints
        lambda2(i) = (q1(:,i)'*F2*cross(e2,q2(:,i)))/(norm(cross(e2,q2(:,i)))^2)*lambda1(i);
    end
end

    
convergence = false;
it = 0;
W = zeros(3*nimages, npoints);
x_err = Inf;
while convergence == false
    % construct W:
    for i = 1:npoints
        W(1:3,i) = lambda1(i)*q1(:,i);
        W(4:end,i) = lambda2(i)*q2(:,i);
    end
    % Balancing W
    balance = false;
    while balance == false
        Wold = W;
        % rescale columns
        WcolumnSum = sum(W.^2, 1);
        W = W./sqrt(WcolumnSum);
        WcolumnSum = sum(W.^2, 1);
        % rescale triplet rows
        WtripletSum1=sum(sum((W(1:3,:).^2)));
        WtripletSum2=sum(sum((W(4:end,:).^2)));
        W(1:3,:) = W(1:3,:)./sqrt(WtripletSum1);
        WtripletSum1 = sum(sum(W(1:3,:).^2));
        W(4:end,:) = W(4:end,:)./sqrt(WtripletSum2);
        WtripletSum2 = sum(sum(W(4:end,:).^2));
        
        Wdiff = sum(sum(Wold-W));
        Wsum = sum(sum(W));

        if abs(Wdiff/Wsum)<0.01
            balance= true;
        end
    end

    [U,D,V] = svd(W);

    Ur4 = U(:,1:4);
    Dr4 = D(1:4,1:4);
    Vt = V';
    Vr4 = Vt(1:4, :);
    Pprojnorm = Ur4*Dr4;
    P1proj = inv(T1)*Pprojnorm(1:3,:);
    P2proj = inv(T2)*Pprojnorm(4:6,:);
    Pproj = vertcat(P1proj, P2proj);
    Xproj = Vr4;

    % check reprojection error
    x_err_old = x_err;
    x1_err = sum(sum ((euclid(x1) - euclid(Pproj(3*1-2:3*1, :)*Xproj)).^2));
    x2_err = sum(sum ((euclid(x2) - euclid(Pproj(3*2-2:3*2, :)*Xproj)).^2));
    x_err = (x1_err + x2_err)/(npoints * 2)
    if abs(x_err-x_err_old)/x_err<0.001
        convergence = true;
    end
    
    lambda1 = Pprojnorm(3*1-2:3*1, :)*Xproj;
    lambda1 = lambda1(3,:);
    lambda2 = Pprojnorm(3*2-2:3*2, :)*Xproj;
    lambda2 = lambda2(3,:);
    
    it=it+1
end

end

