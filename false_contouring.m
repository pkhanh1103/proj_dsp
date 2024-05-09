clc
clear all
close all

a=imread('misc\5.1.12.tiff');
imshow(a),title('original image')
saveas(gcf, 'tmp/orig.jpg')

%using 128 gray levels
figure,imshow(grayslice(a,128),gray(128)),
title('Image with 128 gray level')
saveas(gcf, 'tmp/g128.jpg')

%using 64 gray levels
figure,imshow(grayslice(a,64),gray(64)),
title('Image with 64 gray level')
saveas(gcf, 'tmp/g64.jpg')

%using 32 gray levels
figure,imshow(grayslice(a,32),gray(32)),
title('Image with 32 gray level')
saveas(gcf, 'tmp/g32.jpg')

%using 16 gray levels
figure,imshow(grayslice(a,16),gray(16)),
title('Image with 16 gray level')
saveas(gcf, 'tmp/g16.jpg')

%using 8 gray levels
figure,imshow(grayslice(a,8),gray(8)),
title('Image with 8 gray level')
saveas(gcf, 'tmp/g8.jpg')

% Use imagemagick to join images
% convert +append orig.jpg g128.jpg out1.jpg
% convert +append g64.jpg g32.jpg out2.jpg
% convert +append g16.jpg g8.jpg out3.jpg
% convert -append out* final.jpg