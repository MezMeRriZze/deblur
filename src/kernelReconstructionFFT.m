im1 = rgb2gray(im2double(imread('../kernelData/11.jpg')));
im2 = rgb2gray(im2double(imread('../kernelData/12.jpg')));
im3 = rgb2gray(im2double(imread('../kernelData/13.jpg')));
im4 = rgb2gray(im2double(imread('../kernelData/14.jpg')));
im5 = rgb2gray(im2double(imread('../kernelData/15.jpg')));
im6 = rgb2gray(im2double(imread('../kernelData/16.jpg')));
size(im1)
imshow(im6)
[h,w] = size(im1);
fs = 16;
im2 = imresize(im2,[h,w],'bilinear');
im3 = imresize(im3,[h,w],'bilinear');
im4 = imresize(im4,[h,w],'bilinear');
im5 = imresize(im5,[h,w],'bilinear');
im6 = imresize(im6,[h,w],'bilinear');
ims = cat(3, im2, im3, im4, im5, im6);
im1f = fft2(im1, h, w);
figure(1), hold off, imagesc(log(abs(fftshift(im1f)))), axis off, colormap jet, axis image
im2f = fft2(im6, h, w);
figure(2), hold off, imagesc(log(abs(fftshift(im2f)))), axis off, colormap jet, axis image
filf = im2f ./ im1f;
figure(3), hold off, imagesc(log(abs(fftshift(filf)))), axis off, colormap jet, axis image
% % filf
% imshow(ifft2(im1f .* filf))
% fil = ifft2(filf, fs, fs);
% imshow(filter2(fil, im1))
% fil = ifft2(filf);
% imshow(filter2( fil, im1))
% % fil
% imshow(fil)
