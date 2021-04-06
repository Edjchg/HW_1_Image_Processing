clc; clear; close all;
pkg load image

A = [19 10 8 11; -15 7 4 -13; -5 -8 17 2; 21 11 -6 23; 22 -12 9 1];
k = 2;
c_0 = 8;
epsilon = 0.0001;

%[L, S, error] = godec(A, k, c_0, epsilon)
[L, S, error] = godec_fast(A, k, c_0, epsilon)