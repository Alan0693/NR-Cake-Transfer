function [Y] = ExtractDataP(X,BlockSize,searchregion,imrow,imcol)

patch_size = BlockSize(2)+1-BlockSize(1);
if searchregion == 0
    tX  = X(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4),:,:);
    Y = reshape(tX,patch_size*patch_size*size(tX,3),size(tX,4));
    return;
end

tX  = [];

for i = max(1,BlockSize(1)-searchregion):min(BlockSize(1)+ searchregion,imrow+1-patch_size)
    for j = max(1,BlockSize(3)-searchregion):min(BlockSize(3)+searchregion,imcol+1-patch_size)
        temp_patch = X(i:i+patch_size-1,j:j+patch_size-1,:,:);
        tX = cat(4,tX,temp_patch);
    end
end

Y = reshape(tX,patch_size*patch_size*size(tX,3),size(tX,4));