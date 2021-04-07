%Empotrado y extraccion de marcas de agua en imagenes
%Utiliza la transformada discreta de coseno y descomposicion SVD
clc; clear; close all; %limpiesa inicial
pkg load image %cargado de paquete de imagenes

I=imread('imagen1.jpg'); %lectura de la imagen original
I=im2double(I); %conversion de los valores de uint8 a double

W=imread('marca.jpg'); %lectura de la marca de agua
W=im2double(W); %conversion de los valores de uint8 a double

[m,n]=size(I); %tamano de la imagen original (512x512)
M=8;N=8; %tamano del bloque NxM
F=zeros([m n]); %creacion de la matriz F (transformada)

M_offset=0;
N_offset=0;

tic
for block_line=1:(m/M)
  for block_col=1:(n/N)
    for p=1:M
      for q=1:N
        Cu=0;Cv=0;
        if p==0
          Cu=sqrt(1/M);
        else
          Cu=sqrt(2/M);
        endif
        if q==0
          Cv=sqrt(1/N);
        else
          Cv=sqrt(2/N);
        endif
        for i=1:M
          for j=1:N
            cos_u=cos(pi*(2*i+1)*p/(2*M));
            cos_v=cos(pi*(2*j+1)*q/(2*N));
            F(p+M_offset,q+N_offset)+=Cu*Cv*I(i+M_offset,j+N_offset)*cos_u*cos_v;
          endfor
        endfor
      endfor
    endfor
    N_offset+=8;
  endfor
  M_offset+=8;
  N_offset=0;
endfor
t1=toc

A=zeros([m/M n/N]);

[U,S,V]=svd(A);

alpha=0.1;

[U1,S1,V1]=svd(S+alpha*W);

Ad=U*S1*V';