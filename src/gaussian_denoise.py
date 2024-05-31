import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import correlate
import scipy.io

# Đọc ảnh nhiễu Gauss
I = cv2.imread('output/gaussian_noise.png', cv2.IMREAD_GRAYSCALE)

# Ham loc Wiener
def wiener(im, mysize=None, noise=None):
    im = np.asarray(im)
    if mysize is None:
        mysize = [3] * im.ndim
    mysize = np.asarray(mysize)
    if mysize.shape == ():
        mysize = np.repeat(mysize.item(), im.ndim)

    # Uoc luong trung binh cuc bo
    lMean = correlate(im, np.ones(mysize), 'same') / np.prod(mysize, axis=0)

    # Uoc luong phuong sai cuc bo
    lVar = (correlate(im ** 2, np.ones(mysize), 'same') /
            np.prod(mysize, axis=0) - lMean ** 2)

    # Uoc luong cong suat nhieu neu can
    if noise is None:
        noise = np.mean(np.ravel(lVar), axis=0)

    res = (im - lMean)
    res *= (1 - noise / lVar)
    res += lMean
    out = np.where(lVar < noise, lMean, res)

    return [out, noise]

# Lọc nhiễu Gauss bằng hàm wiener() và lưu kết quả
# Trường hợp mặc định (tự ước lượng công suất nhiễu)
[J_default, J_default_noise] = wiener(I, (3,3))
# Cung cấp tham số công suất nhiễu var=0.01
[J_var0p01, J_var0p01_noise] = wiener(I, (3,3), 0.01)

# Lưu kết quả lọc theo định dạng của MATLAB
scipy.io.savemat('output/gaussian_denoised_rpi3.mat', 
                 {"J_default": J_default, 
                  "J_default_noise": J_default_noise,
                  "J_var0p01": J_var0p01})