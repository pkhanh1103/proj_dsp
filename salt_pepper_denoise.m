% clc
clear all
close all

figure
tiledlayout(1,3)

% Đọc ảnh xám gốc và hiển thị
I = imread('images/salt_pepper_orig.bmp');
nexttile, imshow(I), title('Ảnh gốc')

% Đọc ảnh nhiễu muối tiêu và hiển thị
J = imread('images/salt_pepper_noise.bmp');
nexttile, imshow(J), title('Ảnh nhiễu muối tiêu')

% Lọc trung vị với bộ lọc 3x3 bằng hàm có sẵn và lưu kết quả
K = medfilt2(J, [3 3]);
nexttile, imshow(K), title('Lọc trung vị 3x3 (MATLAB)')
imwrite(K, 'images/salt_pepper_denoised_matlab.bmp')

% Sai số bình phương trung bình giữa ảnh gốc và ảnh đã lọc
fprintf("Sai số bình phương trung bình: %.4f\n", MSE(I, K));

% Sai so binh phuong trung binh
function out = MSE(im1, im2)
    [nRows, nCols] = size(im1);
    error = im1 - im2;
    out = sum(error.^2, 'all') / (nRows * nCols);
end