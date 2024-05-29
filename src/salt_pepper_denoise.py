import cv2
import numpy as np
import matplotlib.pyplot as plt

fig, axs = plt.subplots(1, 3)

# Đọc ảnh xám gốc và hiển thị
I = cv2.imread('output/salt_pepper_orig.png', cv2.IMREAD_GRAYSCALE)
axs[0].imshow(I, cmap='gray', vmin=0, vmax=255)
axs[0].set_title('Ảnh gốc')

# Đọc ảnh nhiễu muối tiêu và hiển thị
J = cv2.imread('output/salt_pepper_noise.png', cv2.IMREAD_GRAYSCALE)
axs[1].imshow(J, cmap='gray', vmin=0, vmax=255)
axs[1].set_title('Nhiễu muối tiêu')

# Hàm lọc trung vị kích thước 3x3
def medFilter3x3(X):
  nRows, nCols = X.shape

  # Padding cho ảnh ngõ vào
  hpad = np.zeros((1, nCols))
  X = np.vstack((hpad, X, hpad))
  vpad = np.zeros((nRows+2, 1))
  X = np.hstack((vpad, X, vpad))
  
  # Lấy trung vị bằng cách sắp xếp theo thứ tự lớn dần
  # và chọn phần tử thứ 5 trong 9 phần tử
  Y = np.zeros((nRows,nCols))
  for i in range(1,nRows+1):
    for j in range(1,nCols+1):
      x = [X[i-1,j-1],
           X[i-1,j],
           X[i-1,j+1],
           X[i,j-1],
           X[i,j],
           X[i,j+1],
           X[i+1,j-1],
           X[i+1,j],
           X[i+1,j+1]]
      x = sorted(x)
      Y[i-1][j-1] = x[4]
  return Y

# Sai số trung bình bình phương
def MSE(im1, im2):
  nRows, nCols = im1.shape
  squareError = 0;
  for i in range(nRows):
    for j in range(nCols):
      squareError += (im1[i,j] - im2[i,j])**2
  return squareError / (nRows * nCols)
  
# Lọc trung vị với bộ lọc 3x3 và lưu kết quả
K = medFilter3x3(J)
axs[2].imshow(K, cmap='gray', vmin=0, vmax=255)
axs[2].set_title('Lọc trung vị 3x3 (RPi 3)')

# Sai số bình phương trung bình giữa ảnh gốc và ảnh đã lọc
print("Sai số bình phương trung bình: %.4f\n" % MSE(I,K))

# Vẽ các ảnh
for ax in axs:
  ax.set_xticks([])
  ax.set_yticks([])

fig.tight_layout(h_pad=2)
plt.show()

# Lưu ảnh đã lọc
cv2.imwrite('output/salt_pepper_denoised_rpi3.png', K)