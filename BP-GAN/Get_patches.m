function  [Patches]  =  Get_patches( im,b,s )
%-------------------------------------------------------------------------
% This function divide the input image into some patches size of bxb
%  im: input image
%  b:  the size of each patch
%  s:  s = b - overlap
%  Patches: b^2 x nrow x ncol where nrow is the number of patches each
%  row, ncol is the number of patches each column; Patches(:,i,j) denotes 
%  the patch located in ith row, jth column
%-------------------------------------------------------------------------
[h w ch]  =  size(im);

if  ch==3
    tempim =  rgb2ycbcr( uint8(im) );
    im     =  double( tempim(:,:,1));
end
 
N         =  h-b+1;
M         =  w-b+1;
r         =  [1:s:N];
if r(end) == N
    ;
else
    r = [r N];
end
% r         =  [r r(end)+1:N];
c         =  [1:s:M];
if c(end) == M
    ;
else
    c = [c M];
end
% c         =  [c c(end)+1:M];
L         =  length(r)*length(c);
% Patches   =  zeros(b*b, L, 'double');
Patches = zeros(b*b,length(r),length(c));

for i = 1:length(r)
    for j = 1:length(c)
        
        blk = im(r(i):r(i)+b-1,c(j):c(j)+b-1);
        blk = blk(:);
        Patches(:,i,j) = blk;
%         Patches(:,(i-1)*length(c)+j) = blk;

    end
end