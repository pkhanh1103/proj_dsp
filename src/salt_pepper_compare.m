% clc
clear all
close all

fig = figure("Position", [0 0 800 200]);
tiledlayout(1,4)

% Đọc ảnh xám gốc và hiển thị
I = imread('../output/salt_pepper_orig.png');
nexttile, imshow(I), title('Ảnh gốc')

% Đọc ảnh nhiễu muối tiêu và hiển thị
J = imread('../output/salt_pepper_noise.png');
nexttile, imshow(J), title('Ảnh nhiễu muối tiêu')

% Lọc trung vị với bộ lọc 3x3 bằng hàm có sẵn và hiển thị
K = medfilt2(J, [3 3]);
nexttile, imshow(K), title(["Lọc trung vị 3x3", "(MATLAB)"])
imwrite(K, '../output/salt_pepper_denoised_matlab.png')

% Đọc kết quả lọc trung vị 3x3 từ Raspberry Pi 3 và hiển thị
load('../output/salt_pepper_denoised_rpi3.mat')
L = uint8(rpiDenoisedImg);
nexttile, imshow(L), title(["Lọc trung vị 3x3", "(RPi 3)"])
imwrite(L, '../output/salt_pepper_denoised_rpi3.png')

% Sai số bình phương trung bình giữa ảnh gốc và ảnh đã lọc
fprintf('MSE (MATLAB): %.4f\n', mse(I, K));
fprintf('MSE (RPi 3): %.4f\n', mse(I, L));

exportgraphics(fig, '../output/salt_peper_compare.png')
