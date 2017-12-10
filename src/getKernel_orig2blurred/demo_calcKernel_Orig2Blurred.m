%demo_calcKernel_Orig2Blurred

  close all; clear all;
  filter_size = 15;
  half_size = 7;
  
  im1 = rgb2gray(im2double(imread('../../kernelData/11.jpg')));
  im2 = rgb2gray(im2double(imread('../../kernelData/12.jpg')));
  im3 = rgb2gray(im2double(imread('../../kernelData/13.jpg')));
  im4 = rgb2gray(im2double(imread('../../kernelData/14.jpg')));
  im5 = rgb2gray(im2double(imread('../../kernelData/15.jpg')));
  im6 = rgb2gray(im2double(imread('../../kernelData/16.jpg')));
  [h,w] = size(im1);
  h = 800; w = 570;
  im1 = imresize(im1,[h,w],'bilinear');
  im2 = imresize(im2,[h,w],'bilinear');
  im3 = imresize(im3,[h,w],'bilinear');
  im4 = imresize(im4,[h,w],'bilinear');
  im5 = imresize(im5,[h,w],'bilinear');
  im6 = imresize(im6,[h,w],'bilinear');
  
%   img  = imread('../../kernelData/11.jpg');
%   img_orig = im2double(img(:,:,2));
%   img_blurred = imfilter(img_orig , fspecial('gaussian',filter_size,7));
  
  img_orig = im1;
  img_blurred1 = im2;
  img_blurred2 = im3;
  
  filt1 = calc_filter(img_orig, img_blurred1, filter_size, half_size);
  filt2 = calc_filter(img_orig, img_blurred2, filter_size, half_size);

%   filt = fspecial('gaussian',filter_size,7);
%   img_blurred = imfilter(img_orig, filt);
  
%   
%   img_orig = im1;
%   img_blurred = imfilter(img_orig , fspecial('gaussian',19,11));
%   profile on
%   [k,img_deblurred] = calcKernel_Orig2Blurred(img_orig,img_blurred,[19,19],1);
%   profile viewer;profile off