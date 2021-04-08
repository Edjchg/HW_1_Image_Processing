%Extraccion de marcas de agua de la imagen2 
%Utiliza la transformada discreta de coseno y descomposicion SVD
%Entradas:
%   imagen2.jpg: imagen con la marca de agua incrustada
%   imagen3.jpg: imagen original
%Salida:
%   marca_extraida1.jpg: maraca de agua extraida de la imagen2

clc; clear; close all; %limpiesa inicial
pkg load image %cargado de paquete de imagenes
pkg load signal %cargado de paquete de senales

I2=imread('imagen2.jpg'); %lectura de la imagen con la marca incrustada
I3=imread('imagen3.jpg'); %lectura de la imagen original

%Cargado de las matrices proveidas por el profesor de tamano 256x256
load 'U1.mat'
load 'V1.mat'

M=4;N=4; %tamano del bloque NxM
alpha=0.1; %definicion de la constante alpha para el calculo de la transformada

I2=im2double(I2); %conversion de los valores de uint8 a double
I3=im2double(I3); %conversion de los valores de uint8 a double

[m,n]=size(I2); %tamano de la imagen original (1024x1024)

F2=zeros([m n]); %creacion de la matriz F2 (transformada de I2)
F3=zeros([m n]); %creacion de la matriz F3 (transformada de I3)
A2=zeros([m/M n/N]); %creacion de la matrix A2 (valores DC de F2)
A3=zeros([m/M n/N]); %creacion de la matrix A3 (valores DC de F3)

%Aplicacion de la transformada discreta de coseno en bloques de MxN
%Transformada de dos dimensiones usando la funcion de Octave dct2
% for block_line=0:(m/M)-1
%   for block_col=0:(n/N)-1
%       lpos=block_line*M;
%       cpos=block_col*N;
%       %Aplicacion de las transformaciones en paralelo
%       F2(lpos+1:lpos+M,cpos+1:cpos+N)=dct2(I2(lpos+1:lpos+M,cpos+1:cpos+N));
%       F3(lpos+1:lpos+M,cpos+1:cpos+N)=dct2(I3(lpos+1:lpos+M,cpos+1:cpos+N));
%   endfor
% endfor

%Transformada manual (tiene un rendimiento peor que la funcion de octave)
%definicion de variables para la ubicacion de los bloques
M_offset=0;
N_offset=0;
for block_line=1:(m/M)
for block_col=1:(n/N)
    for p=1:M
    for q=1:N
        Cu=0;Cv=0;
        if p==1
        Cu=sqrt(1/M);
        else
        Cu=sqrt(2/M);
        endif
        if q==1
        Cv=sqrt(1/N);
        else
        Cv=sqrt(2/N);
        endif
        for i=1:M
        for j=1:N
            %Aplicacion de las transformaciones en paralelo
            cos_u=cos(pi*(2*(i-1)+1)*(p-1)/(2*M));
            cos_v=cos(pi*(2*(j-1)+1)*(q-1)/(2*N));
            I_mn2=I2(i+M_offset,j+N_offset);
            I_mn3=I3(i+M_offset,j+N_offset);
            F2(p+M_offset,q+N_offset)+=Cu*Cv*I_mn2*cos_u*cos_v;
            F3(p+M_offset,q+N_offset)+=Cu*Cv*I_mn3*cos_u*cos_v;
        endfor
        endfor
    endfor
    endfor
    N_offset+=M;
endfor
M_offset+=M;
N_offset=0;
endfor

%Obtencion de la matriz A2 y A3 por medio de los primeros valores (valores DC) 
% de F2 y F3 en bloques de MxN. F(1,1)(1<=m<=64,1<=n<=64)
for block_line=0:(m/M)-1
  for block_col=0:(n/N)-1
      %calculo de posiciones de block_line(0,1,2,...,63) * M(8) + ajuste(1 o M)
      A2(block_line+1,block_col+1)=F2(block_line*M+1,block_col*N+1);
      A3(block_line+1,block_col+1)=F3(block_line*M+1,block_col*N+1);
  endfor
endfor

%Descomposicion de valores singulares de A usando la funcion de octave svd
[U,S,V]=svd(A3);
[U_d,S_d,V_d]=svd(A2);

%Obtencion de D por medio de los valores singulares de A_d
D=U1*S_d*V1';
%Obtencion de la marca de agua
W_d=(D-S).*(1/alpha);

W_d=im2uint8(W_d);

imwrite(W_d,'marca_extraida1.jpg'); %escritura de la marca extraida

subplot(1,2,1) %posicionamiento de imagen en el grafico
imshow(I2) %mostrar imagen con la marca de agua
title('Imagen con la marca de agua') %titulo a mostrar de imagen original

subplot(1,2,2) %posicionamiento de la marca de agua
imshow(W_d) %mostrar marca de agua
title(['Marca de agua extraida']) %titulo a mostrar de la marca de agua