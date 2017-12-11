function [ t ] = clipCvMt( mt ,h ,w, fsh, fsw )
%CLIPCVMT Summary of this function goes here
%   Detailed explanation goes here
t = zeros(h*w, h*w);
nh = h + fsh - 1;
nw = w + fsw - 1;
ptr = 1;
fsh = (fsh - 1) / 2;
fsw = (fsw - 1) / 2;
for i = 1 : nh * nw
    ny = mod(i - 1, nh);
    nx = floor((i - 1) / nh);
    ny = ny + 1;
    nx = nx + 1;
    if ( nx <= fsw ) || ( nx > nw - fsw ) || ( ny <= fsh ) || ( ny > nh - fsh ) 
        continue;
    end
    t(ptr, :) = mt(i, :);
    ptr = ptr + 1;
end


end

