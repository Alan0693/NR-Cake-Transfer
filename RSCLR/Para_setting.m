function [U V r c] = Para_setting(Para)

imrow = Para.imrow;
imcol = Para.imcol;
patch_size = Para.patch_size;
overlap    = Para.overlap;

U = ceil((imrow-overlap)/(patch_size-overlap));  
V = ceil((imcol-overlap)/(patch_size-overlap)); 

N  =  imrow-patch_size+1;
M  =  imcol-patch_size+1;
s  =  patch_size - overlap;
r  =  [1:s:N];
c  =  [1:s:M];

if r(end) ~= N
    r = [r N];
end
if c(end) ~= M
    c = [c M];
end