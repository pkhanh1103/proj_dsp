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

figure
tiledlayout(3,3)

% Hiển thị ảnh gốc
nexttile, imshow(I), title('Anh goc')

% Thêm nhiễu hạt với mật độ 0.05 và hiển thị ảnh
noise = rand(size);
J = zeros(size);
J = uint8(J) + I .* uint8(noise > 0.2) + 255 .* uint8(noise < 0.1);
nexttile, imshow(J), title('Nhieu muoi tieu')

% Lọc trung vị và hiển thị ảnh
Kcross5 = medFilterCross5(J);
nexttile, imshow(Kcross5), title('Loc trung vi chu thap 5 diem')

% Lọc trung vị bằng hàm có sẵn medfill2
K2x2 = medfilt2(J, [2 2]);
nexttile, imshow(K2x2), title('Loc trung vi kich thuoc 2x2')
K3x3 = medfilt2(J, [3 3]);
nexttile, imshow(K3x3), title('Loc trung vi kich thuoc 3x3')
K4x4 = medfilt2(J, [4 4]);
nexttile, imshow(K4x4), title('Loc trung vi kich thuoc 4x4')

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