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

% Hàm lọc trung vị dạng 5 điểm chữ thập (5-point cross-shaped)
function out = medFilterCross5(in)
    [rows, cols] = size(in);
    out = zeros([rows, cols]);
    for i = 2:rows-1
        for j = 2:cols-1
            x = [in(i,j), in(i-1,j), in(i+1,j), ...
                in(i,j-1), in(i,j+1)];
            out(i,j) = median(x);
        end
    end
    out = uint8(out);
end

% Sai số trung bình bình phương
function out = myMSE(im1, im2)
    [rows, cols] = size(im1);
    error = im1 - im2;
    out = sum(error.^2, 'all') / (rows * cols);
end