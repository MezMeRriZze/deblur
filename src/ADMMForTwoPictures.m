function [ imOut ] = ADMMForTwoPictures( im1, im2, we, rhoMax, filt1, filt2, iter, cgiter, neat )

if (~exist('neat','var'))
   neat=1;
end
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
[h , w] = size(im1);
lambda = zeros(size(im1));
x = rand(size(im1));
z = rand(size(im1));
rho = 1e-4
for i = 1 : iter
    x = deconvL(im1, filt1, we, cgiter, z, lambda, rho);
    z = deconvL(im2, filt2, we, cgiter, x, lambda, rho);
    lambda = lambda + (x - z) .* rho;
    disp('showing figure x press enter to show figure z')
    figure(1), imshow(reshape(x, [h w]))
    if ~neat
        pause;
    end
    disp('showing figure z press enter to run next iteration')
    figure(2), imshow(reshape(z, [h w]))
    if ~neat
        pause;
    end
    rho = min(rho * 1.1, rhoMax);
end


figure(1), imshow(reshape(x, [h w]))
if ~neat
    pause;
end
figure(2), imshow(reshape(z, [h w]))
if ~neat
    pause;
end
imOut = reshape(x, [h w]);
end




% [h , w] = size(im1);
% [fsh, fsw] = size(filt1);
% [l] = size(im1(:));
% g1 = [-1 0 1];
% g2 = [-1; 0; 1];
% 
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
% A1 = Cf1' * Cf1 .* 2.0 + Cg1' * Cg1 .* we .* 2.0 + Cg2' * Cg2 .* we .* 2.0 + rho;
% A2 = Cf2' * Cf2 .* 2.0 + Cg1' * Cg1 .* we .* 2.0 + Cg2' * Cg2 .* we .* 2.0 + rho;
% 
% for i = 1 : iter
%     i
%     size(Cf1)
%     size(y1)
%     size(Cg1)
%     b1 = Cf1' * y1 .* 2.0 + z .* rho - lambda;
%     x = pcg(A1, b1);
%     b2 = Cf2' * y2 .* 2.0 + x .* rho - lambda;
%     z = pcg(A2, b2);
%     lambda = lambda + (x - z) .* rho;
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
