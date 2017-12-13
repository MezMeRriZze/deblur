function [ result ] = my_fftconv( I, filt, str )
%MY_FFTCONV Summary of this function goes here
%   Detailed explanation goes here

    [n m k] = size(I);
    if (k == 1)
        result = fftconv(I, filt, str);
    else
        result = zeros(size(I));

        r = fftconv(I(:,:,1), filt, str);
        g = fftconv(I(:,:,2), filt, str);
        b = fftconv(I(:,:,3), filt, str);

        result = zeros(size(r,1), size(r,2), 3);

        result(:,:,1) = r;
        result(:,:,2) = g;
        result(:,:,3) = b;
    end
end

