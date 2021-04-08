clc; clear; close all;
pkg load image

%A = [19 10 8 11; -15 7 4 -13; -5 -8 17 2; 21 11 -6 23; 22 -12 9 1];
A = imread("barbara.jpg");
A = double(A);
m = size(A, 2);
n = size(A,1);
k = 2;
c_0 = 0.01*m*n;
epsilon = 10e-9;

[L1, S1, error] = godec(A(:,:,1), k, c_0, epsilon);
[L2, S2, error] = godec(A(:,:,2), k, c_0, epsilon);
[L3, S3, error] = godec(A(:,:,3), k, c_0, epsilon);
  


L = uint8(zeros(m,n,3));
L(:,:,1) = uint8(L1(:,:));
L(:,:,2) = uint8(L2(:,:));
L(:,:,3) = uint8(L3(:,:));

S = uint8(zeros(m,n,3));
S(:,:,1) = uint8(S1(:,:));
S(:,:,2) = uint8(S2(:,:));
s(:,:,3) = uint8(S3(:,:));

 
subplot(2,2,1)
imshow(L);

subplot(2,2,2)
imshow(S);

##[L, S, error] = godec(A, k, c_0, epsilon)