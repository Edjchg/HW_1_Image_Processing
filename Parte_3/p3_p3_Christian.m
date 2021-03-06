

clc; clear; close all;
pkg load image;
pkg load video;

v = VideoReader("video.mp4");

N_frames = v.NumberOfFrames
A = uint8([]);
for i=1:N_frames
  f = readFrame(v);
  f = imresize (f(:,:,1), 0.4);
  I = reshape(f,[],1);
  A(:, i) = I;
  if i == N_frames     
    [m, n]= size(f);
  endif
endfor

m
n 

k = 2;
c_0 = 0.07*m*n*N_frames;
epsilon = 10^(-3);

L = [];
S = [];

tic
[L, S, error] = godec_fast(im2double(A), k, c_0, epsilon);
t = toc;
 
video1_L = VideoWriter('video1_L.mp4');
video1_S = VideoWriter('video1_S.mp4');
open(video1_L);
open(video1_S);  

for i=1:N_frames
  writeVideo(video1_L, im2uint8(reshape(L(:,i),[m, n])));
  writeVideo(video1_S, im2uint8(reshape(~S(:,i),[m, n])));
endfor

close(video1_L);
close(video1_S);

t % Tiempo de ejecucion

subplot(1,3,1)
imshow(im2uint8(reshape(L(:,i),[m, n])), []); 
title("Fondo del frame 20")
subplot(1,3,2)
imshow(im2uint8(reshape(~S(:,i),[m, n])), []); 
title("Objetos en movimiento del frame 20")
subplot(1,3,3)
imshow(im2uint8(reshape((L+S)(:,i),[m, n])), []);
title("Frame 20")


