function [x]=deconvL_new(I,filt1,we,max_it,z,lambda, rhot, isx, terminator, threshold)
%note: size(filt1) is expected to be odd in both dimensions 

if (~exist('max_it','var'))
   max_it=200;
end

[n,m,k]=size(I);




hfs1_x1=floor((size(filt1,2)-1)/2);
hfs1_x2=ceil((size(filt1,2)-1)/2);
hfs1_y1=floor((size(filt1,1)-1)/2);
hfs1_y2=ceil((size(filt1,1)-1)/2);
shifts1=[-hfs1_x1  hfs1_x2  -hfs1_y1  hfs1_y2];

hfs_x1=hfs1_x1;
hfs_x2=hfs1_x2;
hfs_y1=hfs1_y1;
hfs_y2=hfs1_y2;


m=m+hfs_x1+hfs_x2;
n=n+hfs_y1+hfs_y2;
N=m*n;
mask=zeros(n,m);
mask(hfs_y1+1:n-hfs_y2,hfs_x1+1:m-hfs_x2)=1;



tI=I;
I=zeros(n,m);
% I(hfs_y1+1:n-hfs_y2,hfs_x1+1:m-hfs_x2)=tI; 
x=tI([ones(1,hfs_y1),1:end,end*ones(1,hfs_y2)],[ones(1,hfs_x1),1:end,end*ones(1,hfs_x2)],:);
z=z([ones(1,hfs_y1),1:end,end*ones(1,hfs_y2)],[ones(1,hfs_x1),1:end,end*ones(1,hfs_x2)],:);
lambda = lambda([ones(1,hfs_y1),1:end,end*ones(1,hfs_y2)],[ones(1,hfs_x1),1:end,end*ones(1,hfs_x2)],:);

% disp('matrix sizes')
% size(x)
% size(x.* mask)
b=2.0*my_conv2(x.*mask,filt1,'same');
b= b + rhot * z - isx * lambda;



dxf=[1 0 -1];
dyf=[1; 0; -1];


if (max(size(filt1)<25))
  Ax=my_conv2(my_conv2(x,rot90(filt1,2),'same').*mask,  filt1,'same');
else
  Ax=my_fftconv(my_fftconv(x,rot90(filt1,2),'same').*mask,  filt1,'same');
end

% disp('ax size')
% size(Ax)
Ax=Ax+we*my_conv2(my_conv2(x,rot90(dxf,2),'valid'),dxf);
Ax=Ax+we*my_conv2(my_conv2(x,rot90(dyf,2),'valid'),dyf);
Ax= 2.0 * Ax + rhot * x;


% r = b - Ax;
% 
% for iter = 1:max_it  
%      rho = (r(:)'*r(:));
% 
%      if ( iter > 1 ),                       % direction vector
%         beta = rho / rho_1;
%         p = r + beta*p;
%      else
%         p = r;
%      end
%      if (max(size(filt1)<25))
%        Ap=my_conv2(my_conv2(p,rot90(filt1,2),'same').*mask,  filt1,'same');
%      else  
%        Ap=my_fftconv(my_fftconv(p,rot90(filt1,2),'same').*mask,  filt1,'same');
%      end
% 
%      Ap=Ap+we*my_conv2(my_conv2(p,rot90(dxf,2),'valid'),dxf);
%      Ap=Ap+we*my_conv2(my_conv2(p,rot90(dyf,2),'valid'),dyf);
%      Ap = 2.0 * Ap + rhot * p;
% 
% 
%      q = Ap;
%      alpha = rho / (p(:)'*q(:) );
%      x = x + alpha * p;                    % update approximation vector
% 
%      r = r - alpha*q;                      % compute residual
%      residual = sum(sum(r.^2));
%      if terminator
%          if residual < threshold
%              residual
%              break;
%          end
%      end
%      
%      rho_1 = rho;
% end

% size(b)
r = b - Ax;
r0h = r;
rho = 1;
alpha = 1;
omega = 1;
v = zeros(size(r0h));
p = zeros(size(r));
for iter = 1:max_it  
     rhoim = rho;
     rho = (r0h(:)'*r(:));
        
     beta = (rho / rhoim) * (alpha / omega);
     p = r + beta * (p - omega*v);
     
     if (max(size(filt1)<25))
       Ap=my_conv2(my_conv2(p,rot90(filt1,2),'same').*mask,  filt1,'same');
     else  
       Ap=my_fftconv(my_fftconv(p,rot90(filt1,2),'same').*mask,  filt1,'same');
     end

     Ap=Ap+we*my_conv2(my_conv2(p,rot90(dxf,2),'valid'),dxf);
     Ap=Ap+we*my_conv2(my_conv2(p,rot90(dyf,2),'valid'),dyf);
     Ap = 2.0 * Ap + rhot * p;


     v = Ap;
     alpha = rho / (r0h(:)' * v(:));
     h = x + alpha * p;
     
     s = r - alpha * v;
     if (max(size(filt1)<25))
       As=my_conv2(my_conv2(s,rot90(filt1,2),'same').*mask,  filt1,'same');
     else  
       As=my_fftconv(my_fftconv(s,rot90(filt1,2),'same').*mask,  filt1,'same');
     end

     As=As+we*my_conv2(my_conv2(s,rot90(dxf,2),'valid'),dxf);
     As=As+we*my_conv2(my_conv2(s,rot90(dyf,2),'valid'),dyf);
     As = 2.0 * As + rhot * s;
     t = As;
     
     omega = (t(:)' * s(:)) / (t(:)' * t(:));
     x = h + omega * s;
     r = s - omega * t;
     residual = sum(sum(r.^2));
     if terminator
         if residual < threshold
             residual
             break;
         end
     end
end



x=x(hfs_y1+1:n-hfs_y2,hfs_x1+1:m-hfs_x2,:);
% 
% function [x]=deconvL(I,filt1,we,max_it,z,lambda, rhot, isx)
% %note: size(filt1) is expected to be odd in both dimensions 
% 
% if (~exist('max_it','var'))
%    max_it=200;
% end
% 
% [n,m]=size(I);
% 
% b=2.0*my_conv2(I.*mask,filt1,'same');
% b= b + rhot * z - isx * lambda;
% 
% dxf=[1 0 -1];
% dyf=[1; 0; -1];
% 
% if (max(size(filt1)<25))
%   Ax=2.0 * my_conv2(my_conv2(I,rot90(filt1,2),'same'),  filt1,'same');
% else
%   Ax=2.0 * fftconv(fftconv(I,rot90(filt1,2),'same'),  filt1,'same');
% end
% 
% % disp('ax size')
% % size(Ax)
% Ax=Ax+2.0 * we*my_conv2(my_conv2(I,rot90(dxf,2),'same'),dxf);
% Ax=Ax+2.0 * we*my_conv2(my_conv2(I,rot90(dyf,2),'same'),dyf);
% Ax=Ax + rhot * I;
% 
% % size(b)
% r = b - Ax;
% 
% for iter = 1:max_it  
%      rho = (r(:)'*r(:));
% 
%      if ( iter > 1 ),                       % direction vector
%         beta = rho / rho_1;
%         p = r + beta*p;
%      else
%         p = r;
%      end
%      if (max(size(filt1)<25))
%        Ap=my_conv2(my_conv2(p,fliplr(flipud(filt1)),'same').*mask,  filt1,'same');
%      else  
%        Ap=fftconv(fftconv(p,fliplr(flipud(filt1)),'same').*mask,  filt1,'same');
%      end
% 
%      Ap=Ap+we*my_conv2(my_conv2(p,fliplr(flipud(dxf)),'valid'),dxf);
%      Ap=Ap+we*my_conv2(my_conv2(p,fliplr(flipud(dyf)),'valid'),dyf);
%      Ap = 2.0 * Ap + rhot;
% 
% 
%      q = Ap;
%      alpha = rho / (p(:)'*q(:) );
%      x = x + alpha * p;                    % update approximation vector
% 
%      r = r - alpha*q;                      % compute residual
% 
%      rho_1 = rho;
% end
% 
% 
% 
% x=x(hfs_y1+1:n-hfs_y2,hfs_x1+1:m-hfs_x2);

