function [ candidates ] = neighborSelect(h,w,ntr,patchSize,step,R,height,width,NN,Patches,imp,ims,photo2sketch) 

if ntr < NN
    error('The number of nearest neighbors must be samller than the number of training images!');
end

N         =  height - patchSize + 1;
M         =  width - patchSize + 1;
r         =  [1:step:N];
if r(end) == N
    ;
else
    r = [r N];
end
c         =  [1:step:M];
if c(end) == M
    ;
else
    c = [c M];
end

for i=1:h
    fprintf('\tRow %d (out of %d)...',i,h);
%     tic;
    for j=1:w

        indexpatches    = zeros(ntr,3);
        neighborpatches = zeros(ntr,patchSize*patchSize);

        for kk = 1:ntr

            temp = [];
            indextemp = [];

            startRow = r(i) - R; 
            startCol = c(j) - R;
            endRow   = r(i) + patchSize - 1;
            endCol   = c(j) + patchSize - 1;
            Rstart   = -R;
            Rend     = R;
            Cstart   = -R;
            Cend     = R;

            if startRow < 1
                startRow  = 1;
                Rstart    = 1 - startRow; 
            end

            if endRow > height - R
                endRow  = height;
                Rend    = height - endRow;
            end

            if startCol < 1
                startCol  = 1;
                Cstart    = 1 - startCol;
            end

            if endCol > width - R
                 endCol = width;
                 Cend   = width - endCol;
            end

                for i0 = Rstart:Rend
                    for j0 = Cstart:Cend

                        blk = imp(r(i)+i0:r(i)+i0+patchSize-1,c(j)+j0:c(j)+j0+patchSize-1,kk); 
                        blk = blk(:)';

                        temp = [temp;blk];
                        indextemp = [indextemp;i0,j0,kk];
                    end
                end

                Dist1 = sum(((repmat(Patches(:,i,j)',[size(temp,1),1])-temp).^2),2); %Euclidean distance of photo
                [foo, idx] = sort(Dist1,'ascend');
                indexpatches(kk,:) = indextemp(idx(1),:);
                neighborpatches(kk,:) = temp(idx(1),:);

        end

        Dist       = sum(((repmat(Patches(:,i,j)',[ntr,1])-neighborpatches).^2),2);
        [foo, idx] = sort(Dist,'ascend');
        idx        = idx(1:NN);
        
        tol = 10^(-3);
        C = zeros(NN,NN);
        C = (-repmat(Patches(:,i,j),[1,NN])+neighborpatches(idx,:)')'*(-repmat(Patches(:,i,j),[1,NN])+neighborpatches(idx,:)');
        
        if rank(C) ~= NN
            C = C + 10^(-4)*eye(NN);
        end
        W_Kneighbor = C\ones(NN,1);
        W_Kneighbor = W_Kneighbor/sum(W_Kneighbor);
                 
        candidates(i,j).W = W_Kneighbor;
        candidates(i,j).idx     = indexpatches(idx,:);
        candidates(i,j).patches = [];
        candidates(i,j).ppatches= [];
        candidates(i,j).patches3= [];
        

        for nn = 1:NN

            i0 = candidates(i,j).idx(nn,1);
            j0 = candidates(i,j).idx(nn,2);
            qq = candidates(i,j).idx(nn,3);

            blk = ims(r(i)+i0:r(i)+i0+patchSize-1,c(j)+j0:c(j)+j0+patchSize-1,qq); 
            blk = blk(:)';
            candidates(i,j).patches = [candidates(i,j).patches;blk];   %sketch patch

            blk = imp(r(i)+i0:r(i)+i0+patchSize-1,c(j)+j0:c(j)+j0+patchSize-1,qq);
            blk = blk(:)';
            candidates(i,j).ppatches = [candidates(i,j).ppatches;blk];  %photo patch

        end
    end
%     t = toc;
    fprintf('done!\n');
end