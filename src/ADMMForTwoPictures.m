function [ imOut ] = ADMMForTwoPictures( im1, im2, filt1, filt2, terminator, rhoMax, we, iter, cgiter, mult, rhoInit, ADMMTerminater, CGTerminator, neat )

%   Detailed explanation goes here
% im1 and im2 should be of the same size
% rho is the parameter of the augmented lagrange multiplier
% filter1 should correspond to im1 filter2 should correspond to im2
% iter specifies the maximum number of iteration or it will stop when the
% residual is small
% this function will minimize the gaussian prior noise deconvolution by
% minimizing the joint loss of both im1 and im2 so make sure im1 and im2
% are aligned well. Conjugate gradient method is used when minimizing each
% individual problem and use the augmented lagrange multiplier to link the
% two problems together.
if (~exist('terminator','var'))
   terminator = true;
end
if (~exist('ADMMTerminater','var'))
   ADMMTerminater=1e-4;
   terminator = true;
end
if (~exist('CGTerminator','var'))
   CGTerminator=1e-4;
   terminator = true;
end
if (~exist('we','var'))
   we=0.001;
end
if (~exist('rhoMax','var'))
   rhoMax=4;
end
if (~exist('iter','var'))
   iter=50;
end
if (~exist('cgiter','var'))
   cgiter=50;
end
if (~exist('rhoInit','var'))
   rhoInit=1e-4;
end
if (~exist('mult','var'))
   mult=1.1;
end
if (~exist('neat','var'))
   neat=1;
end
[h , w] = size(im1);
lambda = zeros(size(im1));
x = zeros(size(im1));
z = im2;
% z = deconvL2(im2, filt2, we, cgiter);
rho = rhoInit;
g1 = [1 0 -1];
g2 = [1; 0; -1];
for i = 1 : iter
    x = deconvL_new(im1, filt1, we, cgiter, z, lambda, rho, 1, terminator, CGTerminator);
    z = deconvL_new(im2, filt2, we, cgiter, x, lambda, rho, -1, terminator, CGTerminator);
    lambda = lambda + (x - z) .* rho;
    disp('showing figure x press enter to show figure z')
%     figure(1), imshow(reshape(x, [h w 3]))
    figure(1), imshow(x);
    if ~neat
        pause;
    end
    disp('showing figure z press enter to run next iteration')
%     figure(2), imshow(reshape(z, [h w 3]))
    figure(2), imshow(z);
    if ~neat
        pause;
    end
    if terminator
        primalFeasi = x - z;
        xdualFeasi = - 2.0 * my_conv2(im1, filt1, 'same') + ...
            2.0 * my_conv2(my_conv2(x,rot90(filt1,2),'same'),  filt1,'same') + ...
            2.0 * w * my_conv2(my_conv2(x,rot90(g1,2),'same'),  g1,'same') + ...
            2.0 * w * my_conv2(my_conv2(x,rot90(g2,2),'same'),  g2,'same') + ...
            lambda;
        zdualFeasi = - 2.0 * my_conv2(im2, filt2, 'same') + ...
            2.0 * my_conv2(my_conv2(z,rot90(filt2,2),'same'),  filt2,'same') + ...
            2.0 * w * my_conv2(my_conv2(z,rot90(g1,2),'same'),  g1,'same') + ...
            2.0 * w * my_conv2(my_conv2(z,rot90(g2,2),'same'),  g2,'same') - ...
            lambda;
        primalFeasi = sum(sum(sum(primalFeasi.^2)))
        xdualFeasi = sum(sum(sum(xdualFeasi.^2)))
        zdualFeasi = sum(sum(sum(zdualFeasi.^2)))
        if primalFeasi <= ADMMTerminater && xdualFeasi <= ADMMTerminater && ...
               zdualFeasi <= ADMMTerminater
            break;
        end
    end
    rho = min(rho * mult, rhoMax);
end


figure(1), imshow(x)
if ~neat
    pause;
end
figure(2), imshow(z)
if ~neat
    pause;
end
imOut = x;
end




% [h , w] = size(im1);
% [fsh, fsw] = size(filt1);
% [l] = size(im1(:));
% g1 = [-1 0 1];
% g2 = [-1; 0; 1];
% size(convmtx2(filt1, h, w))
% Cf1 = clipCvMt(convmtx2(filt1, h, w), h, w, fsh, fsw);
% Cf2 = clipCvMt(convmtx2(filt2, h, w), h, w, fsh, fsw);
% Cg1 = clipCvMt(convmtx2(g1, h, w), h, w, 1, 3);
% Cg2 = clipCvMt(convmtx2(g2, h, w), h, w, 3, 1);
% 
% x = im1(:);
% z = im2(:);
% lambda = (im1(:) + im2(:)) ./ 2;
% y1 = im1(:);
% y2 = im2(:);
% A1 = Cf1' * Cf1 .* 2.0 + Cg1' * Cg1 .* we .* 2.0 + Cg2' * Cg2 .* we .* 2.0;
% A2 = Cf2' * Cf2 .* 2.0 + Cg1' * Cg1 .* we .* 2.0 + Cg2' * Cg2 .* we .* 2.0;
% rho = 1e-4;
% for i = 1 : iter
%     i
%     size(Cf1)
%     size(y1)
%     size(Cg1)
%     A = A1 + rho;
%     b1 = Cf1' * y1 .* 2.0 + z .* rho - lambda;
%     x = pcg(A, b1);
%     b2 = Cf2' * y2 .* 2.0 + x .* rho + lambda;
%     A = A2 + rho;
%     z = pcg(A, b2);
%     lambda = lambda + (x - z) .* rho;
%     rho = min(rho * 1.1, rhoMax);
%     figure(1), imshow(reshape(x, [h w]))
%     pause;
%     figure(2), imshow(reshape(z, [h w]))
%     pause;
% end
% 
% 
% figure(1), imshow(reshape(x, [h w]))
% pause;
% figure(2), imshow(reshape(z, [h w]))
% pause;
% imOut = reshape(x, [h w]);
% end
