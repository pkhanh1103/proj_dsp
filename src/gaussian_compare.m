% clc
clear all
close all

figure
tiledlayout(2,3)

% Đọc ảnh xám gốc và hiển thị
I = imread('../output/gaussian_orig.png');
nexttile, imshow(I), title('Ảnh gốc')

% Đọc ảnh nhiễu Gauss và hiển thị
J = imread('../output/gaussian_noise.png');
nexttile, imshow(J), title(["Ảnh nhiễu Gauss", "mu=0, var=0.05"])

% Lọc nhiễu Gauss bằng hàm wiener2 có sẵn và hiển thị
[K, noise] = wiener2(J);
nexttile, imshow(K), title(["Lọc nhiễu Gauss", "(MATLAB)"])
imwrite(K, '../output/gaussian_denoised_matlab.png')

% Đọc kết quả lọc nhiễu Gauss từ Raspberry Pi 3 và hiển thị
load('../output/gaussian_denoised_rpi3.mat')
L1 = uint8(J1_rpi3);
L2 = uint8(J2_rpi3);
nexttile, imshow(L1), title(["Lọc nhiễu Gauss", "(RPi 3, mặc định)"])
imwrite(L1, '../output/gaussian_denoised_rpi3_default.png')
nexttile, imshow(L2), title(["Lọc nhiễu Gauss", "(RPi 3, var=0.01)"])
imwrite(L2, '../output/gaussian_denoised_rpi3_var_0p01.png')

% Công suất nhiễu ước lượng
fprintf("Công suất nhiễu ước lượng: %.4f\n", noise);