function [imp ims] = trainingImageRead(pPath,sPath,filelist_p,filelist_s)

if isempty(filelist_p)
    error(['No images detected in ' pPath '!']);
end

if isempty(filelist_s)
    error(['No images detected in ' sPath '!']);
end

if length(filelist_p) ~= length(filelist_s)
    error(['The number of images in ' pPath ...
        'should equals that in ' sPath]);
else
    for iii = 1:length(filelist_p)
        if filelist_p(iii).name ~= filelist_s(iii).name
            error('Images does not match!');
        end
    end
end

for kk = 1:length(filelist_p)
    
    imp0 = imread(fullfile(pPath,filelist_p(kk).name));
    ims0 = imread(fullfile(sPath,filelist_s(kk).name));
    
    if size(imp0,3) == 3
          imp0 = rgb2gray(imp0);
    end
    
    if size(ims0,3) == 3
          ims0 = rgb2gray(ims0);
    end  
    
    imp(:,:,kk) = double(imp0);
    ims(:,:,kk) = double(ims0);
    
end