function [ before_angles, after_angles ] = metric_rect(Ia,Ha,r_l1,r_m1,r_l2,r_m2 )
r_l1 = (transpose(Ha)) \ r_l1;
r_m1 = (transpose(Ha)) \ r_m1;
r_l2 = (transpose(Ha)) \ r_l2;
r_m2 = (transpose(Ha)) \ r_m2;

hold on;
t=1:0.1:1000;
plot(t, -(r_l1(1)*t + r_l1(3)) / r_l1(2), 'r');
plot(t, -(r_m1(1)*t + r_m1(3)) / r_m1(2), 'b');
plot(t, -(r_l2(1)*t + r_l2(3)) / r_l2(2), 'w');
plot(t, -(r_m2(1)*t + r_m2(3)) / r_m2(2), 'w');

A_ = [r_l1(1)*r_m1(1) , r_l1(1)*r_m1(2)+r_l1(2)*r_m1(1) ;
      r_l2(1)*r_m2(1) , r_l2(1)*r_m2(2)+r_l2(2)*r_m2(1) ];
b_ = [-r_l1(2)*r_m1(2) , -r_l2(2)*r_m2(2)]';


s_vec = linsolve(A_,b_);
disp(s_vec)
S_mat = [s_vec(1),s_vec(2);s_vec(2),1];

A = chol(S_mat);
disp(A)
H = zeros(3,3);
H(1:2,1:2) = inv(A)';
H(3,3) = 1;

I3 = apply_H(Ia, H);
figure; imshow(uint8(I3*255));

before_angles = [angle_bet_lines(r_l1,r_m1), angle_bet_lines(r_l2,r_m2) ];

r_l1 = (transpose(H)) \ r_l1;
r_m1 = (transpose(H)) \ r_m1;
r_l2 = (transpose(H)) \ r_l2;
r_m2 = (transpose(H)) \ r_m2;

% show the transformed lines in the transformed image
hold on;
t=1:0.1:1000;
plot(t, -(r_l1(1)*t + r_l1(3)) / r_l1(2), 'r');
plot(t, -(r_m1(1)*t + r_m1(3)) / r_m1(2), 'b');
plot(t, -(r_l2(1)*t + r_l2(3)) / r_l2(2), 'w');
plot(t, -(r_m2(1)*t + r_m2(3)) / r_m2(2), 'w');


after_angles = [angle_bet_lines(r_l1,r_m1), angle_bet_lines(r_l2,r_m2) ];

end

