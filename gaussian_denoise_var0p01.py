import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import wiener

fig, axs = plt.subplots(1, 3)

# Đọc ảnh xám gốc và hiển thị
I = cv2.imread('images/gaussian_orig.bmp', cv2.IMREAD_GRAYSCALE)
axs[0].imshow(I, cmap='gray', vmin=0, vmax=255)
axs[0].set_title('Ảnh gốc')

# Đọc ảnh nhiễu Gauss và hiển thị
J = cv2.imread('images/gaussian_noise.bmp', cv2.IMREAD_GRAYSCALE)
axs[1].imshow(J, cmap='gray', vmin=0, vmax=255)
axs[1].set_title('Nhiễu Gauss')

# Lọc nhiễu Gauss bằng hàm scipy.signal.wiener có sẵn và lưu kết quả
# Cung cấp tham số công suất nhiễu var=0.01
K = wiener(J, (3,3), 0.01)
axs[2].imshow(K, cmap='gray', vmin=0, vmax=255)
axs[2].set_title('Lọc nhiễu Gauss \n (RPi 3, var=0.01)')

# Vẽ các ảnh
for ax in axs:
  ax.set_xticks([])
  ax.set_yticks([])

fig.tight_layout(h_pad=2)
fig.show()

# Lưu ảnh đã lọc
cv2.imwrite('images/gaussian_denoised_rpi3.bmp', K)
