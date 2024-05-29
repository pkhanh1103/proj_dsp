import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import wiener
import scipy.io

# Đọc ảnh nhiễu Gauss
I = cv2.imread('output/gaussian_noise.png', cv2.IMREAD_GRAYSCALE)

# Lọc nhiễu Gauss bằng hàm scipy.signal.wiener có sẵn và lưu kết quả
# Trường hợp mặc định
J1 = wiener(I, (3,3))
# Cung cấp tham số công suất nhiễu var=0.01
J2 = wiener(I, (3,3), 0.01)

# Lưu kết quả lọc theo định dạng của MATLAB
scipy.io.savemat('output/gaussian_denoised_rpi3.mat', 
                 {"J1_rpi3": J1, "J2_rpi3": J2})