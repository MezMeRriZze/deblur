close all;
clear all;

load './getKernel_orig2blurred/sprite.mat'
load './getKernel_orig2blurred/sprite_filts.mat'

mask = (label * 4 == 4);

[x y] = find(label * 4 == 2);
x1 = min(x); x2 = max(x);
y1 = min(y); y2 = max(y);

img1 = im1;
filts1 = reshape(filts(1, :, :, :), [], filter_size, filter_size);
img2 = im4;
filts2 = reshape(filts(4, :, :, :), [], filter_size, filter_size);

result = img1;

for i=3:3
    if (i > 2)
        [x y] = find(label * 4 == i);
        x1 = min(x); x2 = max(x);
        y1 = min(y); y2 = max(y);
        patch1 = img1(x1:x2, y1:y2, :);
        patch2 = img2(x1:x2, y1:y2, :);
        
        best = 1e100;
        
        for f1 = 2:4 
            filt1 = reshape(filts1(f1, :, :), [filter_size, filter_size]);
            for f2 = 1:4
                filt2 = reshape(filts2(f1, :, :), [filter_size, filter_size]);   
                [imOut, v] = ADMMForTwoPictures_value(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
                
                blur1 = imfilter(imOut, filt1) - patch1;
                blur2 = imfilter(imOut, filt2) - patch2;
                
                blur1 = blur1 .^ 2;
                blur2 = blur2 .^ 2;
                
                v = sum(sum(sum(blur1))) + sum(sum(sum(blur2)));
                
                if (v < best)
                    best = v;
                    k1 = f1; k2 = f2;
                    tmp = imOut;
                end
                k1
                k2
            end
        end
        
        imOut = tmp;
        
%         filt1 = reshape(filts1(i, :, :), [filter_size, filter_size]);
%         filt2 = reshape(filts2(i, :, :), [filter_size, filter_size]);
        
%         imOut = ADMMForTwoPictures(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
        result(x1:x2, y1:y2, :) = imOut;
    end
    if (i == 1)
        x1 = 7; y1 = 1; x2 = 417; y2 = 76;
        patch1 = img1(x1:x2, y1:y2, :);
        filt1 = reshape(filts1(i, :, :), [filter_size, filter_size]);
        patch2 = img2(x1:x2, y1:y2, :);
        filt2 = reshape(filts2(i, :, :), [filter_size, filter_size]);
        imOut = ADMMForTwoPictures(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
        result(x1:x2, y1:y2, :) = imOut;
        
        x1 = 7; y1 = 1; x2 = 264; y2 = 231;
        patch1 = img1(x1:x2, y1:y2, :);
        filt1 = reshape(filts1(i, :, :), [filter_size, filter_size]);
        patch2 = img2(x1:x2, y1:y2, :);
        filt2 = reshape(filts2(i, :, :), [filter_size, filter_size]);
        imOut = ADMMForTwoPictures(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
        result(x1:x2, y1:y2, :) = imOut;
    end
    if (i == 2)
        x1 = 1; y1 = 232; x2 = 264; y2 = 561;
        patch1 = img1(x1:x2, y1:y2, :);
        filt1 = reshape(filts1(i, :, :), [filter_size, filter_size]);
        patch2 = img2(x1:x2, y1:y2, :);
        filt2 = reshape(filts2(i, :, :), [filter_size, filter_size]);
        imOut = ADMMForTwoPictures(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
        result(x1:x2, y1:y2, :) = imOut;
        
        x1 = 1; y1 = 283; x2 = 461; y2 = 561;
        patch1 = img1(x1:x2, y1:y2, :);
        filt1 = reshape(filts1(i, :, :), [filter_size, filter_size]);
        patch2 = img2(x1:x2, y1:y2, :);
        filt2 = reshape(filts2(i, :, :), [filter_size, filter_size]);
        imOut = ADMMForTwoPictures(patch1, patch2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
        result(x1:x2, y1:y2, :) = imOut;
    end
    figure(3), imshow(result);
end

% imshow(img1);

% x = deconvL2(img1, filt1, 0.01);

% imOut = ADMMForTwoPictures(img1, img2, filt1, filt2, true, 2.0, 0.01, 50, 50, 5.0, 1e-4);
