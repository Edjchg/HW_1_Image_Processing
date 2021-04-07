clc; clear; close all;
pkg load image
pkg load video


%Cargando el video en RAM:
V = VideoReader('video.mp4');
%Obteniendo la cantidad de frames que contiene el video.
%frames = V.NumberOfFrames;
frames = 60;
%Obteniendo el alto o la cantidad de filas
m = round(V.Height);
%Obteniendo el alto o la cantidad de columnas
n = round(V.Width);

Video_L = uint8(zeros(m,n,3,frames));
Video_S = uint8(zeros(m,n,3,frames));

k = 2; epsilon = 10**(-9); c_0 = round(0.07*m*n*frames);
%Iterando el video y aplicando godec:
tic
for i = 1:frames
  i
  frame_i = readFrame(V);
  %frame_i(:,:,1) = imresize(frame_i(:,:,1), [m n]);
  %f1_i = imresize(frame_i(:,:,1), [m n]);
  %f2_i = imresize(frame_i(:,:,2), [m n]);
  %f3_i = imresize(frame_i(:,:,3), [m n]);
  %Aplicando godec al canal 1:
  [L_1, S_1, error] = godec(im2double(frame_i(:,:,1)), k, c_0, epsilon);
  %Aplicando godec al canal 2:
  [L_2, S_2, error] = godec(im2double(frame_i(:,:,2)), k, c_0, epsilon);
  %Aplicando godec al canal 3:
  [L_3, S_3, error] = godec(im2double(frame_i(:,:,3)), k, c_0, epsilon);
  %Guardando el frame_i analizado en la lista que corresponde al video de L:
  Video_L(:,:,1,i) = im2uint8(L_1(:,:));
  Video_L(:,:,2,i) = im2uint8(L_2(:,:));
  Video_L(:,:,3,i) = im2uint8(L_3(:,:));
  %Guardando el frame_i analizado en la lista que corresponde al video de S:
  Video_S(:,:,1,i) = im2uint8(S_1(:,:));
  Video_S(:,:,2,i) = im2uint8(S_2(:,:));
  Video_S(:,:,3,i) = im2uint8(S_3(:,:)); 
endfor
t1=toc
video1_L = VideoWriter('video1_L.mp4');
video1_S = VideoWriter('video1_S.mp4');
for i=1:frames
  writeVideo(video1_L, Video_L(:,:,:,i));
  writeVideo(video1_S, Video_S(:,:,:,i));
endfor
close(video1_L);
close(video1_S);
