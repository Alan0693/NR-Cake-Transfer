function [S P PM Para] = TrainingData(Path,Para)

patch_size = Para.patch_size;
overlap    = Para.overlap;
rnum       = Para.rnum;
searchregion = Para.searchregion;

imlist = readImageNames(Path.trimg_src);
nTraining = length(imlist);

disp('Constructing the random sampled dictionary...');
for i=1:nTraining
    
    tarimg = (imread([Path.trimg_tar,imlist(i).name]));
    if size(tarimg,3) == 3
        tarimg = rgb2gray(tarimg);
    end
    Tar(:,:,i) = double(tarimg);

    srcimg = double(imread([Path.trimg_src,imlist(i).name]));
    Src(:,:,:,i) = srcimg;
    
end

[imrow imcol nTraining] = size(Tar);

Para.imrow = imrow;
Para.imcol = imcol;

U = ceil((imrow-overlap)/(patch_size-overlap));  
V = ceil((imcol-overlap)/(patch_size-overlap)); 

for i = 1:U
    fprintf('Processing %d/%d row!\n',i,U);
   for j = 1:V
       
       BlockSize  =  GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);    
       
       XF = ExtractData(Tar,BlockSize,searchregion,imrow,imcol);
       X  = ExtractDataP(Src,BlockSize,searchregion,imrow,imcol);
       
       if size(XF,2) > Para.rnum
           r_index = randperm(size(XF,2));
           XF = XF(:,r_index(1:rnum));
           X  = X(:,r_index(1:rnum));
       end
       
       options.ReducedDim = 300;
       [EVec EVal] = PCA(X',options);
       
       ratio = cumsum(EVal)/sum(EVal);
       temp_index = find(ratio>0.99);
       EVec = EVec(:,1:temp_index(1));
       
       S{i,j} = XF;
       P{i,j} = EVec'*X;
       PM{i,j} = EVec;
       
   end
end

disp('Done!');