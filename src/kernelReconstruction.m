im1 = im2double(imread('../kernelData/1.jpg'));
im2 = im2double(imread('../kernelData/1.jpg'));
[h,w,c] = size(im1);
pa = 20;
im2 = imresize(im2,[h,w],'bilinear');
initPSF = zeros(pa,pa);
for i = 1 : pa
    for j = 1 : pa
        if sqrt((abs(i - pa / 2 - 0.5)) ^ 2 + (abs(j - pa / 2 - 0.5)) ^ 2) <= 8 
            initPSF(j,i) = 1;
        end
    end
end
imshow(initPSF)
[~,PSF] = deconvblind(im2, initPSF, 50);
imshow(PSF)