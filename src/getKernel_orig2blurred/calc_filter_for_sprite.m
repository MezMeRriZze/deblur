close all; clear all;
filter_size = 31;
half_size = 15;
patch_size = 60;

load 'sprite.mat';

imshow(label);
pause;

filts = zeros(4,4,filter_size, filter_size);
sigmas = zeros(4,4);

for i=1:4
    [filt, sigma] = calc_gaussian_filter_mask(gt, im1, filter_size, half_size, label*4==i);
    filts(1,i,:,:) = filt;
    sigmas(1,i) = sigma;
end

for i=1:4
    [filt, sigma] = calc_gaussian_filter_mask(gt, im2, filter_size, half_size, label*4==i);
    filts(2,i,:,:) = filt;
    sigmas(2,i) = sigma;
end

for i=1:4
    [filt, sigma] = calc_gaussian_filter_mask(gt, im3, filter_size, half_size, label*4==i);
    filts(3,i,:,:) = filt;
    sigmas(3,i) = sigma;
end

for i=1:4
    [filt, sigma] = calc_gaussian_filter_mask(gt, im4, filter_size, half_size, label*4==i);
    filts(4,i,:,:) = filt;
    sigmas(4,i) = sigma;
end




% gt = im2double(imread('../../data/sprite/gt.jpg'));
% im1 = im2double(imread('../../data/sprite/1.jpg'));
% im2 = im2double(imread('../../data/sprite/2.jpg'));
% im3 = im2double(imread('../../data/sprite/3.jpg'));
% im4 = im2double(imread('../../data/sprite/4.jpg'));
% [h, w, t] = size(gt);
% h = 600; w = 900;
% gt = imresize(gt, [h,w],'bilinear');
% im1 = imresize(im1,[h,w],'bilinear');
% im2 = imresize(im2,[h,w],'bilinear');
% im3 = imresize(im3,[h,w],'bilinear');
% im4 = imresize(im4,[h,w],'bilinear');
% 
% label = zeros(h, w);
% figure(1), imshow(gt);
% for i = 1:6
%     rect = round(getrect(figure(1)));
%     x1 = rect(2)
%     x2 = rect(2)+rect(4)-1
%     y1 = rect(1) 
%     y2 = rect(1)+rect(3)-1
%     x1 = max(1, x1);
%     x2 = min(h, x2);
%     y1 = max(1, y1);
%     y2 = min(w, y2);
%     if (i <= 2)
%         j = 1;
%     elseif (i <= 4)
%         j = 2;
%     else
%         j = i - 2;
%     end
%     label(x1:x2,y1:y2) = j;
% end
% 
% ori_label = label;
% label = (label-min(min(label))) / (max(max(label)) - min(min(label)));
% imshow(label);


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

% im1 = imfilter(gt, fspecial('gaussian', filter_size, 1.0));
% 
% dep = zeros(h, w);
% for x = 1+half_size:patch_size:h-patch_size-half_size
%     for y = 1+half_size:patch_size:w-patch_size-half_size
%         close all;
%         
%         x1 = x; y1 = y;
%         x2 = x + patch_size; y2 = y + patch_size;
%         im_orig = gt(x1-half_size:x2+half_size, y1-half_size:y2+half_size,:);
%         im_blurred = im1(x1-half_size:x2+half_size, y1-half_size:y2+half_size,:);
%         
%         figure, imshow(im_orig);
%         figure, imshow(im_blurred);
%         
%         [filt, sigma] = calc_gaussian_filter(im_orig, im_blurred, filter_size, half_size);
%         
%         dep(x1:x2, y1:y2) = sigma;
% %         pause;
%     end
% end
% 
% dep = (dep - min(min(dep))) / (max(max(dep)) - min(min(dep)));
% 
% figure, imshow(dep);

% [k,img_deblurred] = calcKernel_Orig2Blurred(im_orig,im_blurred,[filter_size,filter_size],1);

% sigma = 0.1;
% filt = fspecial('gaussian', filter_size, sigma);
% figure(3), imshow(imfilter(gt(x1:x2, y1:y2), filt));
% 
% figure, imshow(imresize(filt,20));
