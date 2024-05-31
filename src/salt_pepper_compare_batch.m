% clc
clear all
close all

load('../output/salt_pepper_denoised_rpi3_batch.mat')

path_to_dataset = "../dataset_preprocessed/";
path_to_input = "../batch_input_salt_pepper/";
path_to_output_rpi3 = "../batch_output_salt_pepper_rpi3/";
path_to_output_matlab = "../batch_output_salt_pepper_matlab/";
f = dir(strcat(path_to_dataset, "*.png"));

fprintf("MSE:\n%15s %10s %10s\n", "Filename", "MATLAB", "RPi 3");

for i = 1:length(f)
    fullpath = strcat(path_to_dataset, f(i).name);
    [path, filename, ext] = fileparts(fullpath);

    % Đọc ảnh xám gốc
    I = imread(strcat(path_to_dataset, filename, ".png"));

    % Đọc ảnh nhiễu muối tiêu
    J = imread(strcat(path_to_input, filename, ".png"));
    
    % Lọc trung vị với bộ lọc 3x3 bằng hàm có sẵn
    K = medfilt2(J, [3 3]);
    imwrite(K, strcat(path_to_output_matlab, filename, ".png"))
    
    % Đọc kết quả lọc trung vị 3x3 từ Raspberry Pi 3
    L = uint8(rpiDenoisedImgs(i,:,:));
    L = reshape(L, 256, 256);
    imwrite(L, strcat(path_to_output_rpi3, filename, ".png"))
    
    % Sai số bình phương trung bình giữa ảnh gốc và ảnh đã lọc
    fprintf('%15s %10.4f %10.4f\n', filename, mse(I, K), mse(I,L));
end
