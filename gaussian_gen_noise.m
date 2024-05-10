% clc
clear all
close all

figure
tiledlayout(1,2)

% Đọc ảnh, chuyển sang ảnh xám, và crop ảnh nếu kích thước lớn hơn 255
I = imread('dataset\4.2.01.tiff');
I = rgb2gray(I);
[rows, cols] = size(I);
size = [rows, cols];
if (rows > 256), I = imresize(I, [256 NaN]); end;
if (cols > 256), I = imresize(I, [NaN 256]); end;

% Lưu ảnh xám đã crop và hiển thị ảnh
imwrite(I, 'images/gaussian_orig.bmp');
nexttile, imshow(I), title('Ảnh gốc');

% Thêm nhiễu Gauss với trung bình 0, phương sai 0.05
J = imnoise(I, 'gaussian');

% Lưu ảnh đã được tạo nhiễu và hiển thị ảnh
imwrite(J, 'images/gaussian_noise.bmp');
nexttile, imshow(J), title('Ảnh nhiễu Gauss mu=0, var=0.05');