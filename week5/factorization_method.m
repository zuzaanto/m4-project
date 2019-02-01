function [Pproj,Xproj] = factorization_method(x1,x2)
%FACTORIZATION_METHOD Summary of this function goes here
%   Detailed explanation goes here
nimages = 2;
npoints = size(x1,2);
[q1, T1] = normalise2dpts(x1);
[q2, T2] = normalise2dpts(x2);

[F1, ~] = ransac_fundamental_matrix(q1,q2, 3)
[F2, ~] = ransac_fundamental_matrix(q2,q1, 3)

e1 = null(F1);
e2 = null(F2);

I = diag([1,1,1]);
P1 = zeros(3,4);
P1(:,1:3) = I;

P2 = zeros(3,4);
sm = e1;
ssm=[0 -sm(3) sm(2); sm(3) 0 -sm(1); -sm(2) sm(1) 0];
P2part = ssm*F1;
P2(:,1:3) = P2part;
P2(:,4) = e1;


lambda1 = ones(npoints,1);
lambda2 = ones(npoints,1);

convergence = false;
it = 0;
W = zeros(3*nimages, npoints);

while convergence == false
    for i = 1:npoints
        if it == -1
%             lambda2(i) = (transpose(q1(:,i))*F1*cross(e2,q2(:,i)))/(norm(cross(e2,q2(:,i)))^2)*lambda1(i);
            lambda2(i) = ((transpose(cross(e1,q2(:,i)))*(F1*q1(:,i)))/norm(cross(e1,q2(:,i))).^2)*lambda1(i);

        else
%             lambda2(i) = (transpose(q1(:,i))*F1*cross(e2,q2(:,i)))/(norm(cross(e2,q2(:,i)))^2)*lambda1(i);
%             lambda1(i) = (transpose(q2(:,i))*F2*cross(e1,q1(:,i)))/(norm(cross(e1,q1(:,i)))^2)*lambda2(i);
            lambda2(i) = ((transpose(cross(e1,q2(:,i)))*(F1*q1(:,i)))/norm(cross(e1,q2(:,i))).^2)*lambda1(i);
            lambda1(i) = ((transpose(cross(e2,q1(:,i)))*(F2*q2(:,i)))/norm(cross(e2,q1(:,i))).^2)*lambda2(i);
        end
    end


    % construct W:
    for i = 1:npoints
        W(1:3,i) = lambda1(i)*q1(:,i);
        W(4:end,i) = lambda2(i)*q2(:,i);
    end
    itW=1;
    % Balancing W
    balance = true;
    while balance == true
        Wold = W;
        % rescale columns
        WcolumnSum = sum(W.^2, 1);
        W = W./sqrt(WcolumnSum);
        WcolumnSum = sum(W.^2, 1);

        WtripletSum1=sum(sum((W(1:3,:).^2)));
        WtripletSum2=sum(sum((W(4:end,:).^2)));

        W(1:3,:) = W(1:3,:)./sqrt(WtripletSum1);
        WtripletSum1 = sum(sum(W(1:3,:).^2));
        W(4:end,:) = W(4:end,:)./sqrt(WtripletSum2);
        WtripletSum2 = sum(sum(W(4:end,:).^2));
        Wdiff = sum(sum(Wold-W));
        if itW==1
            Wdiff1=Wdiff;
        end
        if Wdiff<0.0001*Wdiff1
            balance= false;
        end
        itW=itW+1;

    end

    [U,D,V] = svd(W);
%     D1 = zeros(6);
%     D2 = zeros(npoints);

%     D1(1:4,1:4) = D(1:4,1:4).^(1)
%     D2(1:4,1:4) = D1(1:4,1:4);

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
    x1_err = sum(sum ((euclid(x1) - euclid(Pproj(3*1-2:3*1, :)*Xproj)).^2));
    x2_err = sum(sum ((euclid(x2) - euclid(Pproj(3*2-2:3*2, :)*Xproj)).^2));
    x_err = (x1_err + x2_err)/(npoints * 2);
    if x_err<100
        convergence = true;
    end
%     convergence = true;
    
    lambda1 = Pprojnorm(3*1-2:3*1, :)*Xproj;
    lambda1 = lambda1(3,:);

%     lambda1 = sqrt(sum(lambd
    lambda2 = Pprojnorm(3*2-2:3*2, :)*Xproj;
    lambda2 = lambda2(3,:);
    
    it=it+1
end

end

