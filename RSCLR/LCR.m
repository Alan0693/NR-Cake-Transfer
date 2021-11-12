
function im = LCR(src_img,S,P,PM,Para,U,V,r,c)

imrow = Para.imrow;
imcol = Para.imcol;
patch_size = Para.patch_size;
lambda        = Para.lambda ;

Img_SUM      = zeros(imrow,imcol);
overlap_FLAG = zeros(imrow,imcol);

for i = 1:U
   for j = 1:V      
        
        im_patch =  src_img(r(i):r(i)+patch_size-1,c(j):c(j)+patch_size-1,:);      
        im_patch =  double(reshape(im_patch,[],1));  
        
        XF = S{i,j};
        X  = P{i,j};
        
        im_patch = PM{i,j}'*im_patch;

        nbase  =  size(X',1);
        XX     =  sum(im_patch'.*im_patch', 2);        
        SX     =  sum(X'.*X', 2);
        D      =  repmat(XX, 1, nbase)-2*im_patch'*X+SX'; 
        
        %% if RSLCR, comment the following codes would speed up.
        if Para.fast 
            [Distance index] = sort(D);
            XF = XF(:,index(1:Para.K));
            X  = X(:,index(1:Para.K));
            nbase = Para.K;
            D  = D(index(1:Para.K));
        end
        %%
         
        z   =  X' - repmat(im_patch', nbase, 1);         
        C   =  z*z';                                                
        C   =  C + lambda*diag(D)+eye(nbase,nbase)*(1e-6)*trace(C); 
        w   =  C\ones(nbase,1); 
        w   =  w/sum(w); 
        
        Img  =  XF*w; 
         
        Img  =  reshape(Img,patch_size,patch_size);
        Img_SUM(r(i):r(i)+patch_size-1,c(j):c(j)+patch_size-1) =...
            Img_SUM(r(i):r(i)+patch_size-1,c(j):c(j)+patch_size-1)+Img;
        overlap_FLAG(r(i):r(i)+patch_size-1,c(j):c(j)+patch_size-1)=...
            overlap_FLAG(r(i):r(i)+patch_size-1,c(j):c(j)+patch_size-1)+1;
    end
end

im = Img_SUM./overlap_FLAG;
