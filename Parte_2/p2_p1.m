%Empotrado y extraccion de marcas de agua en imagenes
%Utiliza la transformada discreta de coseno y descomposicion SVD
%Entradas:
%   imagen1.jpg: imagen original
%   marca.jpg: marca de agua a incrustar
%Salida:
%   imagen_watermark.jpg: imagen con la marca de agua incrustada
%   marca_extraida.jpg: maraca de agua extraida de la imagen anterior

clc; clear; close all; %limpiesa inicial
pkg load image %cargado de paquete de imagenes
pkg load signal %cargado de paquete de senales

I=imread('imagen1.jpg'); %lectura de la imagen original
W=imread('marca.jpg'); %lectura de la marca de agua

M=8;N=8; %tamano del bloque NxM
alpha=0.1; %definicion de la constante alpha para el calculo de la transformada

[I_d,U1,V1,S]=watermark_embedding(I,W,M,N,alpha); %llamado a la funcion de marcado

W_d=watermark_extract(I_d,U1,V1,S,M,N,alpha); %llamado a la funcion de extraccion

imwrite(I_d,'imagen_watermark.jpg'); %escritura de la imagen con la marca
imwrite(W_d,'marca_extraida.jpg'); %escritura de la marca extraida

subplot(2,2,1) %posicionamiento de imagen en el grafico
imshow(I) %mostrar imagen original
title('Imagen original') %titulo a mostrar de imagen original

subplot(2,2,2) %posicionamiento de la marca de agua
imshow(W) %mostrar marca de agua
title(['Marca de agua'])

subplot(2,2,3) %posicionamiento de imagen incrustada
imshow(I_d) %mostrar imagen incrustada
title(['Imagen con la marca de agua incrustada'])

subplot(2,2,4) %posicionamiento de imagen incrustada
imshow(W_d) %mostrar imagen transformada
title(['Marca de agua extraida'])