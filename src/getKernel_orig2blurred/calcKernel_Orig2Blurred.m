function [k,varargout] = calcKernel_Orig2Blurred(img_orig,img_blurred,kernelsz,display)
%% description 
% No one is liable for this function. If you wish , use it and redistibute
% it at your own risk. keep the license that comes along with this function.
% Dan Erez, Jan 2016
% hashtags: deconvolution, deblur, fast, ransac, blur kernel 
% purpose:
%   estimte quickly and effectively the kernel that was used to blur img_orig
%   into img_blurred. 
% method: 
%   This function treats the kernel as the solution to an overcontrained
%   problem. In other words :
%   1) blurred image = original image ** blur kernel ; where ** = convolution
%   2) hence for each pixel: 
%      blurred image(i,j) = original image( nieghborhood(i,j) .* blur kernel)
%   3) a set of equations (2) can be set for different i,j's to solve for
%      the blur kernel. 
%   4) there are many many more equations than neede to solve for the blur
%      kernel
%   A variation of the ransac algorithm is implemented in order to
%   find a good estimate of the blurr kernel. 
% inputs:
%   img_orig      - size: mxn, type: double(),range:[0,1],the original 
%                   unblurred image. 
%   img_blurred   - size: mxn, type: double(),range:[0,1],the blurred 
%                   version of img_orig that was blurred using kernel k
%   kernelsz      - size:1x2 double(),range: odd integers,the size of 
%                   kernel k used to blurr img_orig to produce img_blurred
%   display       - size:1x1, logical(),1 = display results, 0 = don't.
% outputs:
%   k             - size: kernelsz ,type: double(),range:[0,1], the 
%                   estimation of kernel used to blurr img_orig into
%                   img_blurred
%   img_deblurred - (optional),size: mxn ,type: double(),range:[0,1], 
%                   img_orig deconvoluted(deblurred) using the kernel found.   
% example:
%   close all; clear all;
%   img  = imread('peppers.png');
%   img_orig = im2double(img(:,:,2));
%   img_blurred = imfilter(img_orig , fspecial('gaussian',7,7));
%   profile on
%   [k,img_deblurred] = ...
%   calcKernel_Orig2Blurred(img_orig,img_blurred,[7,7],1);
%   profile viewer;profile off
% requires : 
%   1) Fortunato_Oliveira_FD_Script_our_method_only (matlab package)
%   http://www.inf.ufrgs.br/~oliveira/pubs_files/FD/FD_page.html
%   2) some mask functions ( end of this file )
% TODO: make this much much faster by running on gpu.
% TODO: run in fft space for better performance.

%% define some veriables / prep
addpath(genpath('.\Fortunato_Oliveira_FD_Script_our_method_only\our_method\'));
Halfkernelsz = floor(kernelsz./2);
kernelsz = Halfkernelsz.*2+1; %in case that the kernel input is not odd sized
nPoints2use = 2000;
nSigmasAwayFromMean = 1; % stricter kernel score = smaller nSigmasAwayFromMean
nBestKsToSelect = 1;%5; > 1 = a potential way to get rid of noise / ringging 
img = img_orig;% easier to deal with smaller name
%% get A,B in order to solve for k
%given the above A,B - > A = B*k ( blurred = original(Neigborhood)*k)

%This following part can for sure be done more efficiently. but good enough.
counter = 0;
for ii = -Halfkernelsz(1):Halfkernelsz(1)
    for jj = -Halfkernelsz(2):Halfkernelsz(2)
        counter = counter+1;
        partialImg =  img(Halfkernelsz(1)+ii+1:size(img,1)-Halfkernelsz(1)+ii,...
                        Halfkernelsz(2)+jj+1:size(img,2)-Halfkernelsz(2)+jj);
        B(1:numel(partialImg),counter) = partialImg(:);
    end
end
A = img_blurred(Halfkernelsz(1)+1:size(img,1)-Halfkernelsz(1),...
                        Halfkernelsz(2)+1:size(img,2)-Halfkernelsz(2));
A_vec = A(:);  

%% ransac 
% use random minimaly sized samples to find canidates for k
ind2use = randi(size(B,1),[size(B,2),nPoints2use]);
X = zeros(size(B,2),nPoints2use);
for ii = 1:nPoints2use 
% for ii = 1:round(nPoints2use)/10  % faster but less accurate
     X(:,ii) = double(A_vec(ind2use(:,ii)))\double(B(ind2use(:,ii),:));
end
X = X/size(X,1); % normalize
% calculate the error each k would produce on a large number of samples
predictedPixelVals = double(B(ind2use(1,:),:))*X;
errorInPrediction = predictedPixelVals - double(repmat(A_vec(ind2use(1,:)),[1,size(X,2)]));%numel(Img)x nKernels

% find the sample with the smallest Z values.( assuming that the mean error should be zero)
SDFromZero = sqrt(sum(errorInPrediction(:).^2)/(numel(errorInPrediction)-1));
SE = SDFromZero/sqrt(numel(errorInPrediction));
Z = errorInPrediction/SE; % normalized statistical score
kernelScore = sum(Z<=nSigmasAwayFromMean); % ransac score (which k has the most inliers)  
[~,I] = sort(kernelScore,'descend');
KbestInd = I(1:nBestKsToSelect);
Ks = reshape(X(:,KbestInd),[kernelsz(1),kernelsz(2),nBestKsToSelect]);
k = Ks(:,:,1);

if nargout > 1 || display
%% reproduce image
img_deblurreds = zeros(size(img_blurred));
if nBestKsToSelect > 1
    for ii = 1:nBestKsToSelect
          img_deblurreds(:,:,ii) = deconv_fast_mask(edgetaper(im2double(img_blurred),Ks(:,:,ii)),Ks(:,:,ii));
    end
    img_deblurred = mode(img_deblurreds,3);
else
    img_deblurred = deconv_fast_mask(edgetaper(im2double(img_blurred),k),k);
end
if (display)
    varargout{1} = img_deblurred;
    figure; imshow([img_orig,img_blurred,img_deblurred],[]) % if you want preview the output
    title ( 'original image, blurred image, deblurred image');
end

end


end

% functions Aux 
function [im_out] = deconv_fast_mask(im_blurred,kernel)
% addpath(genpath('.\Fortunato_Oliveira_FD_Script_our_method_only\our_method\'));

%% prep variables
small_kernel = kernel;
KR = floor((size(small_kernel, 1) - 1)/2); 
KC = floor((size(small_kernel, 2) - 1)/2); 
pad_size = 2 * max(KR, KC);
wev   = [0.001, 20, 0.033, 0.05]; 

%% prep img and kernel
[im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
[R, C, CH] = size(im_blurred_padded);   
big_kernel = getBigKernel(R, C, small_kernel);

%% get deconvolved img
im_out_padded = our_method_bifilter(im_blurred_padded, big_kernel, wev);       
im_out        = imUnpad(im_out_padded, mask_pad, pad_size);

end
function kernel = getBigKernel(R, C, small_kernel)
% Resize kernel to match image size

kernel = zeros(R,C); 
RC     = floor(R/2); 
CC     = floor(C/2); 

[RF,CF] = size(small_kernel); 
RCF = floor(RF/2); CCF = floor(CF/2); 

kernel(RC-RCF+1:RC-RCF+RF,CC-CCF+1:CC-CCF+CF) = small_kernel;
kernel = ifftshift(kernel);
kernel = kernel ./ sum(kernel(:));
end
function [im_out, mask] = imPad(im_in, pad)
% Pad image to remove border ringing atifacts (see section 4.1 of our paper)

im_pad   = padarray(im_in, [pad, pad],'replicate','both');
[R,C,CH] = size(im_pad);

[X Y] = meshgrid (1:C, 1:R);

X0 = 1 + floor ( C / 2); Y0 = 1 + floor ( R / 2);
DX = abs( X - X0 )     ; DY = abs( Y - Y0 );
C0 = X0 - pad          ; R0 = Y0 - pad;

alpha = 0.01;
% force mask value at the borders aprox equal to alpha
% this makes the transition smoother for large kernels
nx = ceil(0.5 * log((1-alpha)/alpha) / log(X0 / C0));
ny = ceil(0.5 * log((1-alpha)/alpha) / log(Y0 / R0));

mX = 1 ./ ( 1 + ( DX ./ C0 ).^ (2 * nx));
mY = 1 ./ ( 1 + ( DY ./ R0 ).^ (2 * ny));
mask_0 = mX .* mY;

mask   = zeros(R,C,CH);
for ch = 1:CH
    mask(:,:,ch) = mask_0;
end;

im_out = zeros(R,C,CH);
im_out = im_pad .* mask;
end
function im_out = imUnpad(im_in, mask_pad, pad)
% Remove padding (see section 4.1 of our paper)

im_out1 = im_in ./ mask_pad;
im_out = im_out1(pad+1:end-pad, pad+1:end-pad, :);
end