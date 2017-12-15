im1 = im2double(imread('../../kernelData/11.jpg'));
im2 = im2double(imread('../../kernelData/12.jpg'));
im3 = im2double(imread('../../kernelData/13.jpg'));
im4 = im2double(imread('../../kernelData/14.jpg'));

filt1 = calc_gaussian_filter(im1, im1, 31, 15);
filt1 = imresize(filt1 / min(min(filt1)),20);

imshow(filt1);

