function [f, sig] = calc_gaussian_filter_mask( im_orig, im_blurred, filter_size, half_size, mask )
%CALC_GAUSSIAN_FILTER Summary of this function goes here
%   Detailed explanation goes here

    best = 1e100;
    sig = 0;

    imshow(mask);
    
    for sigma=0.1:0.25:7
        img_ck = imfilter(im_orig, fspecial('gaussian', filter_size, sigma));
        img_ck = img_ck - im_blurred;
        img_ck = img_ck .* img_ck;
        img_ck = img_ck .* mask;
        img_ck = img_ck(1+half_size:end-half_size,1+half_size:end-half_size, :);
        error = sum(sum(sum(img_ck)));
        
        error;
        
        if (error < best)
            best = error;
            sig = sigma;
        end
    end
    
    f = fspecial('gaussian', filter_size, sig);
    sig;
    
%     im_blurred = im_blurred(1+half_size:end-half_size, 1+half_size:end-half_size, :);

%     figure, imshow(im_blurred(1+half_size:end-half_size, 1+half_size:end-half_size, :));
%     im_ck = imfilter(im_orig, f);
%     figure, imshow(im_ck(1+half_size:end-half_size, 1+half_size:end-half_size, :));
%     f_show = (f-min(f(:))) / (max(f(:))-min(f(:)));
%     figure, imshow(imresize(f_show,20));

end

