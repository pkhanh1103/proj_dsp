import cv2
import numpy as np
import matplotlib.pyplot as plt
import scipy.io

# Đọc ảnh nhiễu muối tiêu
I = cv2.imread('output/salt_pepper_noise.png', cv2.IMREAD_GRAYSCALE)

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

# Lọc trung vị với bộ lọc 3x3
J = medFilter3x3(I)

# Lưu kết quả theo định dạng của MATLAB
scipy.io.savemat('output/salt_pepper_denoised_rpi3.mat', {"rpiDenoisedImg": J})