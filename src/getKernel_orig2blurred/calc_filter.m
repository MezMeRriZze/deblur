function f = calc_filter( img_orig, img_blurred, filter_size, half_size )
%CALC_FILTER Summary of this function goes here
%   Detailed explanation goes here

    [h,w] = size(img_orig);
    
    A = zeros(h * w, filter_size * filter_size);
    b = zeros(h * w, 1);
    e = 0;
    for i = 1+half_size:h-half_size
        for j = 1+half_size:w-half_size
            tmp = img_orig(i-half_size:i+half_size, j-half_size:j+half_size);
            e = e + 1;
            A(e, 1:filter_size*filter_size) = tmp(1:filter_size*filter_size);
            b(e) = img_blurred(i,j);
        end
    end
  
    v = A\b;

    f = zeros(filter_size,filter_size);
    f(1:filter_size*filter_size) = v(1:filter_size*filter_size);
    
    figure, imshow(img_blurred(1+half_size:end-half_size, 1+half_size:end-half_size));
    im_ck = imfilter(img_orig, f);
    figure, imshow(im_ck(1+half_size:end-half_size, 1+half_size:end-half_size));
    f_show = (f-min(f(:))) / (max(f(:))-min(f(:)));
    figure, imshow(imresize(f_show,20));

end

