% clc
clear all
close all

figure
tiledlayout(1,3)

% Đọc ảnh xám gốc và hiển thị
I = imread('../output/gaussian_orig.png');
nexttile, imshow(I), title('Ảnh gốc')

% Đọc ảnh nhiễu Gauss và hiển thị
J = imread('../output/gaussian_noise.png');
nexttile, imshow(J), title('Ảnh nhiễu Gauss')

% Lọc nhiễu Gauss bằng hàm wiener2 có sẵn và lưu kết quả
[K, noise] = wiener2(J);
nexttile, imshow(K), title('Lọc nhiễu Gauss (MATLAB)')
imwrite(K, '../output/gaussian_denoised_matlab.png')

% Công suất nhiễu ước lượng
fprintf("Công suất nhiễu ước lượng: %.4f\n", noise);