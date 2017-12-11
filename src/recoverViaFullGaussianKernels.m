
% arr1 = 1 : 144;
% arr1
% reshape(arr1, [3 3] +[10 10]-1)
% pause;
im1 = rgb2gray(im2double(imread('../kernelData/11.jpg')));
im2 = rgb2gray(im2double(imread('../kernelData/12.jpg')));
im3 = rgb2gray(im2double(imread('../kernelData/13.jpg')));
im4 = rgb2gray(im2double(imread('../kernelData/14.jpg')));
im5 = rgb2gray(im2double(imread('../kernelData/15.jpg')));
im6 = rgb2gray(im2double(imread('../kernelData/16.jpg')));
size(im1)
% figure(1), imshow(im3)
[h,w] = size(im1);
% h = floor(h / 10);
% w = floor(w / 10);
fs = 16;
im1 = imresize(im1,[h,w],'bilinear');
im2 = imresize(im2,[h,w],'bilinear');
im3 = imresize(im3,[h,w],'bilinear');
im4 = imresize(im4,[h,w],'bilinear');
im5 = imresize(im5,[h,w],'bilinear');
im6 = imresize(im6,[h,w],'bilinear');
ims = cat(3, im2, im3, im4, im5, im6);
size(deconvL2(im3, filt2, 0.001, 50))
load('getKernel_orig2blurred/filt.mat');
load('demo_inp')
% imOut = ADMMForTwoPictures(I, I, 0.01, 2.0, filt, filt, 500, 200);
imOut = ADMMForTwoPictures(im2, im3, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
% imOut = ADMMForTwoPictures(im2, im3, 0.01, 0.1, filt1, filt2, 100, 50);
% 
% size(filt1)
% figure(2), imshow(deconvL2(im3, filt2, 0.001, 50));
% pause;
% rho = 0.5
% Cf = convmtx2(filt1, h, w);
% imshow(conv2(im1, filt1))
% pause;
% size(im1)
% imshow(reshape(Cf*im1(:), size(filt1)+[h w]-1))
% size(reshape(Cf*im1(:), size(filt1)+[h w]-1))
% size(conv2(im2, filt1))
% size(filter2(filt1, im2))
% pause;


