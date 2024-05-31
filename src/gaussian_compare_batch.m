% clc
clear all
close all

path_to_dataset = "../dataset_preprocessed/";
path_to_input = "../batch_input_gaussian/";
path_to_output_rpi3_default = "../batch_output_gaussian_rpi3_default/";
path_to_output_rpi3_var0p01 = "../batch_output_gaussian_rpi3_var0p01/";
path_to_output_matlab_default = "../batch_output_gaussian_matlab_default/";
path_to_output_matlab_var0p01 = "../batch_output_gaussian_matlab_var0p01/";

load('../output/gaussian_denoised_rpi3_batch.mat')
f = dir(strcat(path_to_dataset, "*.png"));

fprintf("%-15s%-45s%-20s\n", "", "Mac dinh", "Noise = 0.01");
fprintf("%-15s%-20s%-25s%-10s%-10s\n", ...
     "", "MATLAB", "RPi3", "MATLAB", "RPi3");
fprintf("%-15s%-10s%-10s%-15s%-10s%-10s%-10s\n", ...
     "Filename", "Noise", "MSE", "Noise", "MSE", "MSE", "MSE");

arr_K1_noise = [];
arr_K1_mse   = [];
arr_L1_noise = [];
arr_L1_mse   = [];
arr_K2_mse   = [];
arr_L2_mse   = [];

for i = 1:length(f)
    fullpath = strcat(path_to_dataset, f(i).name);
    [path, filename, ext] = fileparts(fullpath);

    % Đọc ảnh xám gốc
    I = imread(strcat(path_to_dataset, filename, ".png"));

    % Đọc ảnh nhiễu Gauss
    J = imread(strcat(path_to_input, filename, ".png"));

    % Lọc nhiễu Gauss bằng hàm wiener2 có sẵn
    [K1, K1_noise] = wiener2(J);
    imwrite(K1, strcat(path_to_output_matlab_default, filename, ".png"))
    K2 = wiener2(J, [3,3], 0.01);
    imwrite(K2, strcat(path_to_output_matlab_var0p01, filename, ".png"))

    % Đọc kết quả lọc nhiễu Gauss từ Raspberry Pi 3
    L1 = uint8(J_default(i,:,:));
    L1 = reshape(L1, 256, 256);
    L1_noise = J_default_noise(i);
    imwrite(L1, strcat(path_to_output_rpi3_default, filename, ".png"))

    L2 = uint8(J_var0p01(i,:,:));
    L2 = reshape(L2, 256, 256);
    imwrite(L2, strcat(path_to_output_rpi3_var0p01, filename, ".png"))

    % Tính MSE
    K1_mse = mse(I,K1);
    K2_mse = mse(I,K2);
    L1_mse = mse(I,L1);
    L2_mse = mse(I,L2);

    % So sánh
    fprintf("%-15s%-10.4f%-10.4f%-15.4f%-10.4f%-10.4f%-10.4f\n", ...
     filename, K1_noise, mse(I,K1), L1_noise, mse(I,L1), ...
     mse(I,K2), mse(I,L2));

    % Lưu vào mảng
    arr_K1_noise = [arr_K1_noise [K1_noise]];
    arr_K1_mse   = [arr_K1_mse   [K1_mse]];
    arr_L1_noise = [arr_L1_noise [L1_noise]];
    arr_L1_mse   = [arr_L1_mse   [L1_mse]];
    arr_K2_mse   = [arr_K2_mse   [K2_mse]];
    arr_L2_mse   = [arr_L2_mse   [L2_mse]];
end

fig1 = figure("Position", [0 0 600 300]);
histogram(arr_K1_noise, 20);
title('Phân phối nhiễu ước lượng bởi MATLAB');
exportgraphics(fig1, '../output/hist_gaussian_compare_matlab_noise.png');

fig2 = figure("Position", [0 0 600 300]);
histogram(arr_K1_mse, 20);
hold on;
histogram(arr_L1_mse, 20);
title('Phân phối MSE (Trường hợp mặc định)');
legend('MATLAB', 'RPi 3');
exportgraphics(fig2, '../output/hist_gaussian_compare_default_mse.png');

fig3 = figure("Position", [0 0 600 300]);
histogram(arr_K2_mse, 20);
hold on;
histogram(arr_L2_mse, 20);
title('Phân phối MSE (Trường hợp cung cấp tham số nhiễu)');
legend('MATLAB', 'RPi 3');
exportgraphics(fig3, '../output/hist_gaussian_compare_var0p01_mse.png');

fig4 = figure("Position", [0 0 500 400]);
pie(categorical(arr_L2_mse < arr_K2_mse, [true false], {'RPi 3' 'MATLAB'}));
title(["Tỉ lệ lọc cho kết quả tốt hơn", ...
    "(Trường hợp cung cấp tham số nhiễu)"]);
exportgraphics(fig4, '../output/pie_gaussian_compare_var0p01_mse.png');