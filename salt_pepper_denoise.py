import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage import median_filter

# Đọc ảnh và chuyển sang ảnh xám
I = cv2.imread('dataset/4.1.03.tiff', cv2.IMREAD_GRAYSCALE)
nRows, nCols = I.shape
size = (nRows, nCols)

fig, axs = plt.subplots(2, 3)

# Vẽ ảnh gốc
axs[0][0].imshow(I, cmap='gray', vmin=0, vmax=255)
axs[0][0].set_title('Ảnh gốc')

# Tạo nhiễu muối tiêu với mật độ 0.05 và hiển thị ảnh
noise = np.random.random(size)
J = np.zeros(size, dtype=int)
J = J + I * (noise > 0.2) + 255 * (noise < 0.1)
axs[0][1].imshow(J, cmap='gray', vmin=0, vmax=255)
axs[0][1].set_title('Nhiễu muối tiêu')

# Hàm lọc trung vị dạng 5 điểm chữ thập (5-point cross-shaped)
def medFilterCross5(X):
  nRows, nCols = X.shape
  Y = np.zeros((nRows,nCols))
  for i in range(1,nRows-1):
    for j in range(1,nCols-1):
      x = (X[i][j], X[i-1][j], X[i+1][j], X[i][j-1], X[i][j+1])
      x = sorted(x)
      # Lấy trung vị bằng cách sắp xếp theo thứ tự lớn dần
      # và chọn phần tử thứ 3 trong 5 phần tử
      Y[i][j] = x[2]
  return Y

# Lọc trung vị 5 điểm chữ thập và hiển thị ảnh
Kcross5 = medFilterCross5(J)
axs[0][2].imshow(Kcross5, cmap='gray', vmin=0, vmax=255)
axs[0][2].set_title('Lọc trung vị \n5 điểm chữ thập')

# Lọc trung vị bằng hàm có sẵn scipy.ndimage.median_filter
K2x2 = median_filter(J, size=(2,2))
axs[1][0].imshow(K2x2, cmap='gray', vmin=0, vmax=255)
axs[1][0].set_title('Lọc trung vị \nkích thước 2x2')

K3x3 = median_filter(J, size=(3,3))
axs[1][1].imshow(K3x3, cmap='gray', vmin=0, vmax=255)
axs[1][1].set_title('Lọc trung vị \nkích thước 3x3')

K4x4 = median_filter(J, size=(4,4))
axs[1][2].imshow(K4x4, cmap='gray', vmin=0, vmax=455)
axs[1][2].set_title('Lọc trung vị \nkích thước 4x4')

for rowAxs in axs:
  for ax in rowAxs:
    ax.set_xticks([])
    ax.set_yticks([])

fig.tight_layout(h_pad=2)
fig.show()
fig.savefig("figures/MedianFiltering.png", bbox_inches='tight')
