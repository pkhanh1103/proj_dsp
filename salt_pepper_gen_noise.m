% clc
clear all
close all

figure
tiledlayout(1,2)

% Đọc ảnh, chuyển sang ảnh xám, và crop ảnh nếu kích thước lớn hơn 255
I = imread('dataset\4.1.03.tiff');
I = rgb2gray(I);
[rows, cols] = size(I);
size = [rows, cols];
if (rows > 256), I = imresize(I, [256 Nan]), end;
if (cols > 256), I = imresize(I, [Nan 256]), end;

% Lưu ảnh xám đã crop và hiển thị ảnh
imwrite(I, 'images/salt_pepper_orig.bmp')
nexttile, imshow(I), title('Ảnh gốc')

% Thêm nhiễu muối tiêu với mật độ 0.05
J = imnoise(I, 'salt & pepper', 0.05);

% Lưu ảnh đã được tạo nhiễu và hiển thị ảnh
imwrite(J, 'images/salt_pepper_noise.bmp')
nexttile, imshow(J), title('Ảnh nhiễu muối tiêu 5%')