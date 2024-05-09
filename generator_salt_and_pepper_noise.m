clc
clear all
close all

% Đọc ảnh, chuyển sang ảnh xám, và crop ảnh nếu kích thước lớn hơn 255
I = imread('dataset\4.1.03.tiff');
I = rgb2gray(I);
[rows, cols] = size(I);
size = [rows, cols];
if (rows > 256), I = imresize(I, [256 Nan]), end;
if (cols > 256), I = imresize(I, [Nan 256]), end;

% Thêm nhiễu muối tiêu với mật độ 0.05 và hiển thị ảnh
noise = rand(size);
J = zeros(size);
J = uint8(J) + I .* uint8(noise > 0.2) + 255 .* uint8(noise < 0.1);