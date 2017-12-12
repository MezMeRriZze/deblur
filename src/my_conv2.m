function result = my_conv2( I, filt, str )
%MY_CONV2 Summary of this function goes here
%   Detailed explanation goes here

    if (~exist('str','var'))
        str = 'full';
    end
    
    r = conv2(I(:,:,1), filt, str);
    g = conv2(I(:,:,2), filt, str);
    b = conv2(I(:,:,3), filt, str);
    
    result = zeros(size(r,1), size(r,2), 3);
    
    result(:,:,1) = r;
    result(:,:,2) = g;
    result(:,:,3) = b;

end

