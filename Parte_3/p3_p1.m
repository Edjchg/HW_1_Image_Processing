

clc; clear; close all;
%Definicion de martiz de entrada y parametros del ejemplo
A = [19 10 8 11; -15 7 4 -13; -5 -8 17 2; 21 11 -6 23; 22 -12 9 1];
k = 2;
c_0 = 8;
epsilon = 0.0001;

%Aplicacion del algoritmo
[L, S, error] = godec(A, k, c_0, epsilon)