%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lab 1: Image rectification


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Applying image transformations

% ToDo: create the function  "apply_H" that gets as input a homography and
% an image and returns the image transformed by the homography.
% The size of the transformed image has to be automatically set so as to 
% contain the whole transformed image.
% At some point you will need to interpolate the image values at some points,
% you may use the Matlab function "interp2" for that.


%% 1.1. Similarities
I=imread('Data/0005_s.png'); % we have to be in the proper folder

% ToDo: generate a matrix H which produces a similarity transformation
H = createSimilarityH(0.5, 2, 2, 0.5);
I2 = apply_H(I, H);
% figure; imshow(I); figure; imshow(uint8(I2*255));
% figure; 
% subplot(1,2,1),imshow(I);
% subplot(1,2,2),imshow(uint8(I2*255));
imwrite(uint8(I2*255),'similarity05_05.png');
H = createSimilarityH(0.5, 2, 2, -3);
I2 = apply_H(I, H);
% figure; imshow(I); figure; imshow(uint8(I2*255));
imwrite(uint8(I2*255),'similarity05_-3.png');
H = createSimilarityH(2.5, 2, 2, 0.5);
I2 = apply_H(I, H);
% figure; imshow(I); figure; imshow(uint8(I2*255));
imwrite(uint8(I2*255),'similarity25_05.png');
H = createSimilarityH(2.5, 2, 2, -3);
I2 = apply_H(I, H);
% figure; imshow(I); figure; imshow(uint8(I2*255));
imwrite(uint8(I2*255),'similarity25_-3.png');



%% 1.2. Affinities

% ToDo: generate a matrix H which produces an affine transformation
% createAffinityH(theta, phi, tx, ty, scalex, scaley)
H = createAffinityH(0.5, 2.5, 1, 10, 2, 0.2);
I2 = apply_H(I, H);
figure; imshow(I); figure; imshow(uint8(I2*255));

% ToDo: decompose the affinity in four transformations: two
% rotations, a scale, and a translation

[rotation1,rotation2,scale,translation]=decomposeAffinity(H);

% ToDo: verify that the product of the four previous transformations
% produces the same matrix H as above

Hrecomp=translation*rotation1*scale*rotation2;
difference=H-Hrecomp;
display(difference);

% ToDo: verify that the proper sequence of the four previous
% transformations over the image I produces the same image I2 as before
% Re1=apply_H(I,translation);
% imshow(uint8(Re1*255));
% Re2=apply_H(Re1,rotation2);
% imshow(uint8(Re1*255));
% Re3=apply_H(Re2,scale);
% imshow(uint8(Re3*255));
% Re4=apply_H(Re3,rotation2);
% imshow(uint8(Re3*255));
% Re5=apply_H(Re4,transpose(rotation2));
% imshow(uint8(Re3*255));
% Re6=apply_H(Re5,rotation1);
% figure; 
% subplot(1,2,1),imshow(uint8(Re6*255));
% subplot(1,2,2),imshow(uint8(I2*255));
% imwrite(uint8(I2*255),'recomposed1.png');
% imwrite(uint8(Re6*255),'recomposed2.png');

%% 1.3 Projective transformations (homographies)

% ToDo: generate a matrix H which produces a projective transformation

I2 = apply_H(I, H);
figure; imshow(I); figure; imshow(uint8(I2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Affine Rectification

% choose the image points
I=imread('Data/0000_s.png');
A = load('Data/0000_s_info_lines.txt');

% indices of lines
i = 424;
p1 = [A(i,1) A(i,2) 1]';
p2 = [A(i,3) A(i,4) 1]';
i = 240;
p3 = [A(i,1) A(i,2) 1]';
p4 = [A(i,3) A(i,4) 1]';
i = 712;
p5 = [A(i,1) A(i,2) 1]';
p6 = [A(i,3) A(i,4) 1]';
i = 565;
p7 = [A(i,1) A(i,2) 1]';
p8 = [A(i,3) A(i,4) 1]';

% ToDo: compute the lines l1, l2, l3, l4, that pass through the different pairs of points
l1 = cross(p1, p2);
l2 = cross(p3, p4); %l1//l2
l3 = cross(p5, p6);
l4 = cross(p7, p8); %l3//l4

% show the chosen lines in the image
figure;imshow(I);
hold on;
t=1:0.1:1000;
plot(t, -(l1(1)*t + l1(3)) / l1(2), 'r');
plot(t, -(l2(1)*t + l2(3)) / l2(2), 'b');
plot(t, -(l3(1)*t + l3(3)) / l3(2), 'g');
plot(t, -(l4(1)*t + l4(3)) / l4(2), 'y');

% ToDo: compute the homography that affinely rectifies the image
v1 = cross(l1, l2);
v2 = cross(l3, l4);
l = cross(v1, v2);
l = l / l(3);

H = eye(3,3);
H(3,:) = l;

I2 = apply_H(I, H);
figure; imshow(uint8(I2*255));

% ToDo: compute the transformed lines lr1, lr2, lr3, lr4
lr1 = inv(transpose(H)) * l1;
lr2 = inv(transpose(H)) * l2;
lr3 = inv(transpose(H)) * l3;
lr4 = inv(transpose(H)) * l4;

% show the transformed lines in the transformed image
figure;imshow(uint8(I2*255));
hold on;
t=1:0.1:1000;
plot(t, -(lr1(1)*t + lr1(3)) / lr1(2), 'r');
plot(t, -(lr2(1)*t + lr2(3)) / lr2(2), 'b');
plot(t, -(lr3(1)*t + lr3(3)) / lr3(2), 'g');
plot(t, -(lr4(1)*t + lr4(3)) / lr4(2), 'y');

% ToDo: to evaluate the results, compute the angle between the different pair 
% of lines before and after the image transformation


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Metric Rectification

%% 3.1 Metric rectification after the affine rectification (stratified solution)

% ToDo: Metric rectification (after the affine rectification) using two non-parallel orthogonal line pairs
%       As evaluation method you can display the images (before and after
%       the metric rectification) with the chosen lines printed on it.
%       Compute also the angles between the pair of lines before and after
%       rectification.
r_l1 = cross(p1, p4);  %r_l1 is perpendicular to r_m1
r_m1 = cross(p2, p3);
r_l2 = l1;             %r_l2 is perpendicular to r_m2
r_m2 = l3;

% r_l1 = inv(transpose(H)) * r_l1; %??????????? why is this here?
% r_m1 = inv(transpose(H)) * r_m1;
% r_l2 = inv(transpose(H)) * r_l2;
% r_m2 = inv(transpose(H)) * r_m2;

figure;imshow(I);
hold on;
t=1:0.1:1000;
plot(t, -(r_l1(1)*t + r_l1(3)) / r_l1(2), 'r');
plot(t, -(r_m1(1)*t + r_m1(3)) / r_m1(2), 'b');
plot(t, -(r_l2(1)*t + r_l2(3)) / r_l2(2), 'w');
plot(t, -(r_m2(1)*t + r_m2(3)) / r_m2(2), 'w');
hold off;

A_ = [r_l1(1)*r_m1(1) , r_l1(1)*r_m1(2)+r_l1(2)*r_m1(1) ;
      r_l2(1)*r_m2(1) , r_l2(1)*r_m2(2)+r_l2(2)*r_m2(1) ];
b_ = [-r_l1(2)*r_m1(2) , -r_l2(2)*r_m2(2)]';


s_vec = linsolve(A_,b_);
disp(s_vec)
S_mat = [s_vec(1),s_vec(2);s_vec(2),1];

A = chol(S_mat);
disp(A)
H = zeros(3,3);
H(1:2,1:2) = inv(A.'); % transpose?
H(3,3) = 1;

I3 = apply_H(I, H);
figure; imshow(uint8(I3*255));

l1_ang = atan(((-(r_l2(1)*100 + r_l2(3)) / r_l2(2)) + ((r_l2(3)) / r_l2(2)))/(100));
l2_ang = atan(((-(r_m2(1)*100 + r_m2(3)) / r_m2(2)) +((r_m2(3)) / r_m2(2)))/(100));
before_angle = (l1_ang - l2_ang)* 180/pi;
disp(abs(before_angle))

r_l1 = inv(transpose(H)) * r_l1;
r_m1 = inv(transpose(H)) * r_m1;
r_l2 = inv(transpose(H)) * r_l2;
r_m2 = inv(transpose(H)) * r_m2;

% show the transformed lines in the transformed image
hold on;
t=1:0.1:1000;
plot(t, -(r_l1(1)*t + r_l1(3)) / r_l1(2), 'r');
plot(t, -(r_m1(1)*t + r_m1(3)) / r_m1(2), 'b');
plot(t, -(r_l2(1)*t + r_l2(3)) / r_l2(2), 'w');
plot(t, -(r_m2(1)*t + r_m2(3)) / r_m2(2), 'w');
hold off

l1_ang = atan(((-(r_l2(1)*100 + r_l2(3)) / r_l2(2)) + ((r_l2(3)) / r_l2(2)))/(100));
l2_ang = atan(((-(r_m2(1)*100 + r_m2(3)) / r_m2(2)) +((r_m2(3)) / r_m2(2)))/(100));
after_angle = (l1_ang - l2_ang)* 180/pi;
disp(abs(after_angle))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Affine and Metric Rectification of the left facade of image 0001

% ToDo: Write the code that rectifies the left facade of image 0001 with
%       the stratified method (affine + metric). 
%       Crop the initial image so that only the left facade is visible.
%       Show the (properly) transformed lines that use in every step.
clear all
close all

I=imread('Data/0001_s.png');
I = I(:,1:477,:); %crop
A = load('Data/0001_s_info_lines.txt');

i = 645;
p1 = [A(i,1) A(i,2) 1]';
p2 = [A(i,3) A(i,4) 1]';
i = 541;
p3 = [A(i,1) A(i,2) 1]';
p4 = [A(i,3) A(i,4) 1]';
i = 159;
p5 = [A(i,1) A(i,2) 1]';
p6 = [A(i,3) A(i,4) 1]';
i = 614;
p7 = [A(i,1) A(i,2) 1]';
p8 = [A(i,3) A(i,4) 1]';

%affine rectification

l1 = cross(p1, p2);
l2 = cross(p3, p4);
l3 = cross(p5, p6);
l4 = cross(p7, p8);

figure;imshow(I);
hold on;
t=1:0.1:1000;
plot(t, -(l1(1)*t + l1(3)) / l1(2), 'r');
plot(t, -(l2(1)*t + l2(3)) / l2(2), 'b');
plot(t, -(l3(1)*t + l3(3)) / l3(2), 'g');
plot(t, -(l4(1)*t + l4(3)) / l4(2), 'y');
text(p1(1), p1(2), 'p1', 'Color', 'red');
text(p2(1), p2(2), 'p2', 'Color', 'red');
text(p3(1), p3(2), 'p3', 'Color', 'red');
text(p4(1), p4(2), 'p4', 'Color', 'red');
text(p5(1), p5(2), 'p5', 'Color', 'red');
text(p6(1), p6(2), 'p6', 'Color', 'red');
text(p7(1), p7(2), 'p7', 'Color', 'red');
text(p8(1), p8(2), 'p8', 'Color', 'red');
hold off;

v1 = cross(l1, l2);
v2 = cross(l3, l4);
l = cross(v1, v2);
l = l / l(3);

H_affine = eye(3,3);
H_affine(3,:) = l;

lr1 = inv(transpose(H_affine)) * l1;
lr2 = inv(transpose(H_affine)) * l2;
lr3 = inv(transpose(H_affine)) * l3;
lr4 = inv(transpose(H_affine)) * l4;

I2 = apply_H(I, H_affine);
figure; imshow(uint8(I2*255));
hold on;
t=1:0.1:1000;
plot(t, -(lr1(1)*t + lr1(3)) / lr1(2), 'r');
plot(t, -(lr2(1)*t + lr2(3)) / lr2(2), 'b');
plot(t, -(lr3(1)*t + lr3(3)) / lr3(2), 'g');
plot(t, -(lr4(1)*t + lr4(3)) / lr4(2), 'y');
hold off;

%metric rectification

r_l1 = cross(p1, p4);  %r_l1 is perpendicular to r_m1
r_m1 = cross(cross(l1, l3), p3);
r_l2 = l1;             %r_l2 is perpendicular to r_m2
r_m2 = l4;

figure;imshow(I);
hold on;
t=1:0.1:1000;
plot(t, -(r_l1(1)*t + r_l1(3)) / r_l1(2), 'r');
plot(t, -(r_m1(1)*t + r_m1(3)) / r_m1(2), 'b');
plot(t, -(r_l2(1)*t + r_l2(3)) / r_l2(2), 'w');
plot(t, -(r_m2(1)*t + r_m2(3)) / r_m2(2), 'w');
hold off;

A_ = [r_l1(1)*r_m1(1) , r_l1(1)*r_m1(2)+r_l1(2)*r_m1(1) ;
      r_l2(1)*r_m2(1) , r_l2(1)*r_m2(2)+r_l2(2)*r_m2(1) ];
b_ = [-r_l1(2)*r_m1(2) , -r_l2(2)*r_m2(2)]';

s_vec = linsolve(A_,b_);
S_mat = [s_vec(1),s_vec(2);s_vec(2),1];

A = chol(S_mat);
disp(A)
H_met = zeros(3,3);
H_met(1:2,1:2) = inv(A.'); % transpose????
H_met(3,3) = 1;

l1_ang = atan(((-(r_l2(1)*100 + r_l2(3)) / r_l2(2)) + ((r_l2(3)) / r_l2(2)))/(100));
l2_ang = atan(((-(r_m2(1)*100 + r_m2(3)) / r_m2(2)) +((r_m2(3)) / r_m2(2)))/(100));
before_angle = (l1_ang - l2_ang)* 180/pi;
disp(abs(before_angle))

H = H_met * H_affine;

%can't plot these lines right
r_l1 = inv(transpose(H)) * r_l1;
r_m1 = inv(transpose(H)) * r_m1;
r_l2 = inv(transpose(H)) * r_l2;
r_m2 = inv(transpose(H)) * r_m2;

% show the transformed lines in the transformed image
% I3 = apply_H(I, H_affine);
% I3 = apply_H(I3, H_met);
% figure; imshow(uint8(I3*255));

I3 = apply_H(I, H);
figure; imshow(uint8(I3*255));

hold on;
t=1:0.1:1000;
plot(t, -(r_l1(1)*t + r_l1(3)) / r_l1(2), 'r');
plot(t, -(r_m1(1)*t + r_m1(3)) / r_m1(2), 'b');
plot(t, -(r_l2(1)*t + r_l2(3)) / r_l2(2), 'w');
plot(t, -(r_m2(1)*t + r_m2(3)) / r_m2(2), 'w');
hold off

l1_ang = atan(((-(r_l2(1)*100 + r_l2(3)) / r_l2(2)) + ((r_l2(3)) / r_l2(2)))/(100));
l2_ang = atan(((-(r_m2(1)*100 + r_m2(3)) / r_m2(2)) +((r_m2(3)) / r_m2(2)))/(100));
after_angle = (l1_ang - l2_ang)* 180/pi;
disp(abs(after_angle))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. OPTIONAL: Metric Rectification in a single step
% Use 5 pairs of orthogonal lines (pages 55-57, Hartley-Zisserman book)



