%==========================================================================
% an example for sketch <-> photo transformation using back projection
% Written by Nannan Wang, Feb. 2017,
% Reference:
% Nannan Wang et al. Back Projection: An Effective Postprocessing Method ...
% for GAN-based Face Sketch Synthesis, submitted to Pattern Recognition
% Letters, 2017.
%==========================================================================

%--------------------------------------------------------------------------
clc;
clear;
close all;

addpath('Codes');

% Sketch synthesis or photo synthesis
photo2sketch  = true;
Database      = 'CUHK FERET';
patchsize     = 20;
overlap       = 14;
searchregion  = 5;
NN            = 5;
step          = patchsize - overlap;

trpathphoto   = ['Data/',Database,'/Photo/Training/',];
trpathsketch  = ['Data/',Database,'/Sketch/Training/'];
tepath        = ['Data/',Database,'/Photo/Testing/'];
tarpath       = ['Data/',Database,'/Sketch/Testing/'];
repath        = ['Data/',Database,'/Result/'];
dicpath       = ['Data/',Database,'/Dictionary/'];

filelist_p = readImageNames(trpathphoto);  %Photo/Training
filelist_s = readImageNames(trpathsketch);  %Sketch/Training
filelist   = readImageNames(tepath);    %Photo/Testing
filelist_ref = readImageNames(tarpath);  %Sketch/Testing

[imp ims] = trainingImageRead(trpathphoto,trpathsketch,filelist_p,filelist_s);

Time_Consuming = zeros(length(filelist),1);
SSIM_Score     = zeros(length(filelist),1);

for i = 1:length(filelist)
    
    fprintf('\nProcessing %s...\n',filelist(i).name);
    filename = fullfile(repath,filelist(i).name(1:end-4));  %Result
    im = imread(fullfile(tepath,filelist(i).name));    %Photo/Testing
    
    tic;
    [height width ch] = size(im);
    if ch == 3
        tempim = rgb2gray(im);
        im     = double(tempim);
    else
        im     = double(im);
    end
    
    Patches   = Get_patches(im,patchsize,step);  %Split test photos into patches
    [dim,h,w] = size(Patches);
    
    [path string ~] = fileparts(filelist(i).name);
    %Select five nearest neighbours from the training sketch
    [candidates] = neighborSelect(h,w,length(filelist_p),patchsize,...    
        step,searchregion,height,width,NN,Patches,imp,ims,photo2sketch);
    
    k = 1;
    Rpatches = [];
    for jj = 1:w
        for ii = 1:h
            Rpatches(:,k) = candidates(ii,jj).patches'*candidates(ii,jj).W;
            k = k+1;
        end
    end
    
    Im  = FusionAve(height,width,patchsize,overlap,Rpatches); %Reconstruct sketch
    Im  = uint8(Im);
    Time_Consuming(i) = toc;
    rim = imread([tarpath,filelist_ref(i).name]);   %Sketch/Testing
    if size(rim,3) == 3
        rim = rgb2gray(rim);
    end
    SSIM_Score(i) = ssim(rim,Im);    %Sketch/Testing v.s Reconstruct sketch
    imwrite(Im,[filename,'.jpg'],'quality',100);
    
    fprintf('Elasped time is %f\n',Time_Consuming(i));
    fprintf('SSIM score is %f\n',SSIM_Score(i));
    
end

fprintf('The mean SSIM Score on the %s database is %f\n',Database,...
    mean(SSIM_Score));
fprintf('The mean time-consuming on the %s database is %f\n',...
    Database,mean(Time_Consuming));

save([repath,'SSIM_Time.mat'],'SSIM_Score','Time_Consuming');

