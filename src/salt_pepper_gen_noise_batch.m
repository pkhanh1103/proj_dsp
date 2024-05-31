% clc
clear all
close all

path_to_dataset = "../dataset/";
path_to_preprocessed_img = "../dataset_preprocessed/";
path_to_noised_img = "../batch_input_salt_pepper/";
f = dir(strcat(path_to_dataset, "*.tiff"));

for i = 1:length(f)
    fullpath = strcat(path_to_dataset, f(i).name);
    [path, filename, ext] = fileparts(fullpath);

    % Đọc ảnh, chuyển sang ảnh xám, và crop ảnh nếu kích thước lớn hơn 255
    I = imread(fullpath);
    I = im2gray(I);
    [rows, cols] = size(I);
    if (rows > 256), I = imresize(I, [256 NaN]); end;
    if (cols > 256), I = imresize(I, [NaN 256]); end;

    % Lưu ảnh đã tiền xử lý
    imwrite(I, strcat(path_to_preprocessed_img, filename, ".png"));

    % Thêm nhiễu muối tiêu với mật độ 0.05
    J = imnoise(I, 'salt & pepper', 0.05);

    % Lưu ảnh đã được tạo nhiễu
    imwrite(J, strcat(path_to_noised_img, filename, ".png"));
end

