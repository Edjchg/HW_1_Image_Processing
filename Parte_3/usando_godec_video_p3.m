clc; clear; close all;
pkg load image
pkg load video


%Cargando el video en RAM:
V = VideoReader('video.mp4');

%Obteniendo la cantidad de frames que contiene el video.
%frames = V.NumberOfFrames;
frames = 30;
%Obteniendo el alto o la cantidad de filas
m = round(V.Height);
%Obteniendo el alto o la cantidad de columnas
n = round(V.Width);
%Creando los arrays que van a contener los frames procesados del algoritmo godec.
Video_L = uint8(zeros(m,n,3,frames)); Video_S = uint8(zeros(m,n,3,frames));
%Parametros iniciales como los que se muestran en el ejemplo del papaer.
k = 2; epsilon = 10^(-9); c_0 = 0.07*m*n;
%Iterando el video y aplicando godec:
tic
for i = 1:frames
  i

  frame_i = readFrame(V);
  [L_1, S_1, ~] = godec(double(frame_i(:,:,1)), k, c_0, epsilon);
  %Al frame original se le quitan los objetos moviendose.
  L_t = double(frame_i(:,:,1)) - S_1;
  L_1 = 255-L_1;
  %Al frame original se le pone el fondo.
  S_t = double(frame_i(:,:,1)) + L_1; %+ S_1;
  L_t = uint8(L_t);
  S_t = uint8(S_t);
  
  Video_L(:,:,1,i) = L_t(:,:);
  Video_L(:,:,2,i) = L_t(:,:);
  Video_L(:,:,3,i) = L_t(:,:);
  
  Video_S(:,:,1,i) = S_t(:,:);
  Video_S(:,:,2,i) = S_t(:,:);
  Video_S(:,:,3,i) = S_t(:,:); 
endfor
t1=toc
video1_L = VideoWriter('video1_L.mp4');
video1_S = VideoWriter('video1_S.mp4');
open(video1_L);
open(video1_S);
for i=1:frames
  writeVideo(video1_L, Video_L(:,:,:,i));
  writeVideo(video1_S, Video_S(:,:,:,i));
endfor
close(video1_L);
close(video1_S);
