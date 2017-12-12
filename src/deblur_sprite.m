close all;
clear all;

load './getKernel_orig2blurred/sprite.mat'
load './getKernel_orig2blurred/sprite_filts.mat'

mask = (label * 4 == 4);

[x y] = find(label * 4 == 1);
x1 = min(x); x2 = max(x);
y1 = min(y); y2 = max(y);

img1 = im1(x1:x2, y1:y2, :);
filt1 = reshape(filts(1, 1, :, :), [filter_size, filter_size]);
img2 = im3(x1:x2, y1:y2, :);
filt2 = reshape(filts(3, 1, :, :), [filter_size, filter_size]);

% imshow(img1);

% x = deconvL2(img1, filt1, 0.01);

imOut = ADMMForTwoPictures(img1, img2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
