

clc; clear; close all;
pkg load image;
pkg load video;

v = VideoReader("untitled.mp4");

video2 = VideoWriter('video2.mp4');
open(video2);
N_frames = v.NumberOfFrames
for i=1:N_frames - 2
  f = readFrame(v);
  f = rgb2gray (f);
  %f = imresize (f(:,:,1), [360 430]);
  writeVideo(video2, f(:,:,1));
endfor
video2.Width
video2.Height
close(video2);



