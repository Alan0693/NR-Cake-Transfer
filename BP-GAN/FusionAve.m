function [ im ] = FusionAve( height,width,patchSize,overlapSize,Patches)
%FusionAve Summary of this function goes here
%   Fusing image patches into a whole image with overlapping area averaged
%   Input:
%      height      - the height of final image
%      width       - the width of final image
%      patchSize   - the patch size of each input patch
%      overlapSize - the overlapping size for neighboring patches
%      Patches     - the patches with which the fusion is implemented
%   Output:
%      im          - the output whole image
%==========================================================================

im    = zeros(height,width);
im_wei= zeros(height,width);
        
% counter  = 0;
stepSize = patchSize-overlapSize;
N        = height-patchSize+1;
M        = width-patchSize+1;
r        = [1:stepSize:N];
if r(end) == N
    ;
else
    r = [r N];
end
% r        = [r r(end)+1:N];
c        = [1:stepSize:M];
if c(end) == M
    ;
else
    c = [c M];
end
% c        = [c c(end)+1:M];
N        = length(r);
M        = length(c);
              
for i = 1:length(r)
    for j = 1:length(c)
        
        im(r(i):r(i)+patchSize-1,c(j):c(j)+patchSize-1) = im(r(i):r(i) +...
            patchSize-1,c(j):c(j)+patchSize-1)+reshape(Patches(:,(j-1)*length(r)+i),patchSize,patchSize);
        
        im_wei(r(i):r(i)+patchSize-1,c(j):c(j)+patchSize-1) = ...
            im_wei(r(i):r(i)+patchSize-1,c(j):c(j)+patchSize-1) +1;
    end
end
        
im = im./(im_wei+eps);
       

end

