im1 = rgb2gray(im2double(imread('../kernelData/11.jpg')));
im2 = rgb2gray(im2double(imread('../kernelData/12.jpg')));
im3 = rgb2gray(im2double(imread('../kernelData/13.jpg')));
im4 = rgb2gray(im2double(imread('../kernelData/14.jpg')));
im5 = rgb2gray(im2double(imread('../kernelData/15.jpg')));
im6 = rgb2gray(im2double(imread('../kernelData/16.jpg')));
imshow(im6)
[h,w] = size(im1);
h = h / 3.0;
w = w / 3.0;
fs = 1024;
im2 = imresize(im2,[h,w],'bilinear');
im3 = imresize(im3,[h,w],'bilinear');
im4 = imresize(im4,[h,w],'bilinear');
im5 = imresize(im5,[h,w],'bilinear');
im6 = imresize(im6,[h,w],'bilinear');
[sdI1]=deconvSps(im4,fspecial('gaussian', 19, 3 ) ,0.001,1);
imshow(sdI1)
disp('aaa')
pause;
size(im1)
ims = cat(3, im2, im3, im4, im5, im6);
% gs = [17,38,33,43,46];
gs = [5,5,11,17,17];
% for j = 1 : 5
%     minLoss = -1;
%     for i = 1 : 500
%     %     i
%         g = fspecial('gaussian', i * 6 + 1, i);
%         imt = filter2(g, im1);
%         imt = ssim(imt, ims(:,:,j));
%         if imt > minLoss 
%             minLoss = imt;
%             gs(j) = i
%         else 
%             break;
%         end
%     end
% end
gs
for j = 1 : 5
    g = fspecial('gaussian', gs(j) * 6 + 1, gs(j));
    figure(1), imshow(filter2(g,im1));
    figure(2), imshow(ims(:,:,j));
    pause;
end
% im1f = fft2(im1, h, w);
% im2f = fft2(im2, h, w);
% filf = im2f ./ im1f;
% % % filf
% imshow(ifft2(im1f .* filf))
% % fil = ifft2(filf);
% imshow(filter2( fil, im1))
% % % fil
% % imshow(fil)
% blurred = zeros(h,w,c);
% for i = 1 : c
%     blurred(:,:,i) = filter2(im1(:,:,i),fil);
% end
% % blurred = filter2(im1,fil);
% imshow(blurred)