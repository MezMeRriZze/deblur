clear all;
close all;

load './getKernel_orig2blurred/sprite_filts.mat'

gt = im2double(imread('../data/graphics/gt.jpg'));
[h w k] = size(gt);

x1 = 26; y1 = 1979;
x2 = x1 + 545; y2 = y1 + 801;

gt = gt(x1:x2, y1:y2, :);
[h w k] = size(gt);

h = 275; w = 400;
gt = imresize(gt,[h,w],'bilinear');

patch1 = imfilter(gt, fspecial('gaussian', filter_size, 3.8));
filt1 = fspecial('gaussian', filter_size,4.8);

patch2 = imfilter(gt, fspecial('gaussian', filter_size, 6));
filt2 = fspecial('gaussian', filter_size, 5.7);

imwrite(patch1, '../result/compare/patch1.jpg');
imwrite(patch2, '../result/compare/patch2.jpg');

f1 = imresize(filt1/max(filt1(:)),20);
f2 = imresize(filt2/max(filt2(:)),20);

imwrite(f1, '../result/compare/f1.jpg');
imwrite(f2, '../result/compare/f2.jpg');

figure(1), imshow(patch1);
figure(2), imshow(patch2);

[imOut, v] = ADMMForTwoPictures_value(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 25, 50, 5.0, 1e-4);
