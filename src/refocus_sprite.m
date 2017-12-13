close all;
clear all;

load './getKernel_orig2blurred/sprite.mat';
load './getKernel_orig2blurred/sprite_filts.mat';
load 'sprite_refined_label.mat';

foc = 1;
apt = 1.4;

for foc=1:4
    orig = im2double(imread('../result/sprite1-4.jpg'));
    result = orig;
    for i=1:4
        if (i ~= foc)
            sig = sigmas(foc, 5 - i);
            filt = fspecial('gaussian', filter_size, sig * apt);
            blur = imfilter(orig, filt);
            mask = (label * 4 == 5 - i);
            result = result .* (1 - mask) + blur .* mask;
        end
        imshow(result);
    end
    imwrite(result, sprintf('../result/refocus/big-%d.jpg', foc));
end
% figure(1), imshow(orig);
% for i=1:4
%     for j=1:1
% [py px] = getline(figure(1));
% for x=1:size(orig,1)
%     for y=1:size(orig,2)
%         if (inpolygon(x,y,px,py))
%             k=i/4;
%             if(i>2)k=0;end
%             label(x,y) = k;
%         end
%     end
% end
%     end
% end

% rect = round(getrect(figure(1)));
% x1 = rect(2) 
% x2 = rect(2)+rect(4)-1
% y1 = rect(1) 
% y2 = rect(1)+rect(3)-1
% 
% label(x1:x2, y1:y2) = 0.25;
