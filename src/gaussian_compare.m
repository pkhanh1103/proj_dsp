% clc
clear all
close all

fig = figure("Position", [0 0 400 600]);
tiledlayout(3, 2)

% Đọc ảnh xám gốc và hiển thị
I = imread('../output/gaussian_orig.png');
nexttile, imshow(I), title('Ảnh gốc')

% Đọc ảnh nhiễu Gauss và hiển thị
J = imread('../output/gaussian_noise.png');
nexttile, imshow(J), title(["Ảnh nhiễu Gauss", "mu=0, var=0.05"])

% Lọc nhiễu Gauss bằng hàm wiener2 có sẵn và hiển thị
[K1, K1_noise] = wiener2(J);
nexttile, imshow(K1), title(["Lọc nhiễu Gauss", "(MATLAB, mặc định)"])
imwrite(K1, '../output/gaussian_denoised_matlab_default.png')

K2 = wiener2(J, [3,3], 0.01);
nexttile, imshow(K2), title(["Lọc nhiễu Gauss", "(MATLAB, var=0.01)"])
imwrite(K2, '../output/gaussian_denoised_matlab_var_0p01.png')

% Đọc kết quả lọc nhiễu Gauss từ Raspberry Pi 3 và hiển thị
load('../output/gaussian_denoised_rpi3.mat')
L1 = uint8(J_default);
L2 = uint8(J_var0p01);
nexttile, imshow(L1), title(["Lọc nhiễu Gauss", "(RPi 3, mặc định)"])
imwrite(L1, '../output/gaussian_denoised_rpi3_default.png')
nexttile, imshow(L2), title(["Lọc nhiễu Gauss", "(RPi 3, var=0.01)"])
imwrite(L2, '../output/gaussian_denoised_rpi3_var_0p01.png')

% Công suất nhiễu ước lượng và sai số trung bình bình phương
fprintf("Công suất nhiễu ước lượng (trường hợp không cung cấp trước tham số nhiễu):\n");
fprintf("MATLAB: %.4f\n", K1_noise);
fprintf("Raspberry Pi 3: %.4f\n", J_default_noise);
fprintf("\n");

fprintf("Sai số bình phương trung bình giữa ảnh gốc và ảnh đã lọc:\n");
fprintf("MSE (MATLAB, mặc định): %.4f\n", mse(I, K1));
fprintf("MSE (MATLAB, var=0.01): %.4f\n", mse(I, K2));
fprintf("MSE (RPi 3, mặc định): %.4f\n", mse(I, L1));
fprintf("MSE (RPi 3, var=0.01): %.4f\n", mse(I, L2));

exportgraphics(fig, '../output/gaussian_compare.png')