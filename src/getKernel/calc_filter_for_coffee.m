close all; clear all;
filter_size = 31;
half_size = 15;
patch_size = 128;

gt = im2double(imread('../../data/coffee/gt.jpg'));
im1 = im2double(imread('../../data/coffee/1.jpg'));
im2 = im2double(imread('../../data/coffee/2.jpg'));
im3 = im2double(imread('../../data/coffee/3.jpg'));
im4 = im2double(imread('../../data/coffee/4.jpg'));
[h, w, t] = size(gt);
h = 700; w = 950;
gt = imresize(gt, [h,w],'bilinear');
im1 = imresize(im1,[h,w],'bilinear');
im2 = imresize(im2,[h,w],'bilinear');
im3 = imresize(im3,[h,w],'bilinear');
im4 = imresize(im4,[h,w],'bilinear');

% ords = zeros(4, 4);
% 
% ords(1, 1:4) = [1080, 1253, 2360, 2766];
% 
% x1 = ords(1,1); x2 = ords(1,2); y1 = ords(1, 3); y2 = ords(1, 4);
% 
% im_orig = gt(x1-half_size:x2+half_size, y1-half_size:y2+half_size,:);
% im_blurred = im2(x1-half_size:x2+half_size, y1-half_size:y2+half_size,:);
% 
% figure, imshow(im_orig);
% figure, imshow(im_blurred);

% filt = calc_filter(im_orig, im_blurred, filter_size, half_size);
% [filt, sigma] = calc_gaussian_filter(im_orig, im_blurred, filter_size, half_size);

im1 = imfilter(gt, fspecial('gaussian', filter_size, 1.0));

dep = zeros(h, w);
for x = 1+half_size:patch_size:h-patch_size-half_size
    for y = 1+half_size:patch_size:w-patch_size-half_size
        close all;
        
        x1 = x; y1 = y;
        x2 = x + patch_size; y2 = y + patch_size;
        im_orig = gt(x1-half_size:x2+half_size, y1-half_size:y2+half_size,:);
        im_blurred = im1(x1-half_size:x2+half_size, y1-half_size:y2+half_size,:);
        
        figure, imshow(im_orig);
        figure, imshow(im_blurred);
        
        [filt, sigma] = calc_gaussian_filter(im_orig, im_blurred, filter_size, half_size);
        
        dep(x1:x2, y1:y2) = sigma;
        pause;
    end
end

dep = (dep - min(min(dep))) / (max(max(dep)) - min(min(dep)));

figure, imshow(dep);

% [k,img_deblurred] = calcKernel_Orig2Blurred(im_orig,im_blurred,[filter_size,filter_size],1);

% sigma = 0.1;
% filt = fspecial('gaussian', filter_size, sigma);
% figure(3), imshow(imfilter(gt(x1:x2, y1:y2), filt));
% 
% figure, imshow(imresize(filt,20));
