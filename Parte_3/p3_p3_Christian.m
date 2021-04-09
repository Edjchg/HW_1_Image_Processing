

clc; clear; close all;
pkg load image;
pkg load video;

v = VideoReader("video.mp4");
m = v.Height;
n = v.Width;
%N_frames = v.NumberOfFrames;
N_frames = v.NumberOfFrames
A = uint8([]);
for i=1:N_frames
  f = readFrame(v);
  f = imresize (f(:,:,1), [m, n]);
  %imshow(uint8(f))
  %pause(0.5)
  I = reshape(f,[],1);
  A(:, i) = I;
endfor

k = 2;
c_0 = 0.07*m*n*N_frames;
epsilon = 10^(-3);

L = [];
S = [];


imshow(A)
[L, S, error] = godec(im2double(A), k, c_0, epsilon);
 
 
video1_L = VideoWriter('video1_L.mp4');
video1_S = VideoWriter('video1_S.mp4');
open(video1_L);
open(video1_S);  

for i=1:N_frames
  writeVideo(video1_L, im2uint8(reshape(L(:,i),[m, n])));
  writeVideo(video1_S, im2uint8(reshape(L(:,i)-S(:,i),[m, n])));
  subplot(1,3,1)
  imshow(im2uint8(reshape(L(:,i),[m, n])), []); 
  subplot(1,3,2)
  imshow(im2uint8(reshape(S(:,i),[m, n])), []); 
  subplot(1,3,3)
  imshow(im2uint8(reshape((L+S)(:,i),[m, n])), []);
  pause(0.1)
endfor

close(video1_L);
close(video1_S);


%for i=1:v.NumberOfFrames-340
%  i
%  [L(:,:,:,i), S(:,:,:,i), error] = godec(f(:,:,1), k, c_0, epsilon);
%  f = readFrame(v);
%  f = imresize (f, [250 350]);
%  f = im2double(f);
%endfor