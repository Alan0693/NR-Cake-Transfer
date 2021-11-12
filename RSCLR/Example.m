
% =========================================================================
% Random Sampling and Locality Constraint for Face Sketch Synthesis
% Nannan Wang 
% nnwang@xidian.edu.cn
% 2016.10.26
%=========================================================================

clc;close all;
clear all;
addpath('./Codes');

%%=========================================================================
% set parameters
% Database
Para.Database = 'CUHK Student';
% trade-off between reconstruction fidelity and locality constraint
Para.lambda      = 0.5;
% Patch Size
Para.patch_size  = 20;
% Overlap Size
Para.overlap     = 14;
% Search Length
Para.searchregion = 5;
% Number for Random Sampling
Para.rnum         = 800;
% RSLCR or Fast-RSLCR
Para.fast = true;
% Number of Nearest Neighbors for Fast-RSLCR
Para.K = 200;

% set path
Path.datadir   = ['Data/',Para.Database,'/'];
Path.trimg_src = [Path.datadir,'Training Photos/'];
Path.trimg_tar = [Path.datadir,'Training Sketches/'];
Path.teimg_src = [Path.datadir,'Testing Photos/'];
Path.teimg_tar = [Path.datadir,'Testing Sketches/'];
Path.dict      = [Path.datadir,'Dictionary/'];
Path.tarimg    = [Path.datadir,'Results/'];
%%=========================================================================

%%=========================================================================
% Training
if exist([Path.dict,'Dictionary.mat'],'file') ~=2
    tic;
    [S P PM Para] = TrainingData(Path,Para);
    toc;
    save([Path.dict,'Dictionary.mat'],'S','P','PM','Para','-v7.3');  
else
    disp('Loading Data...');
    load([Path.dict,'Dictionary.mat']);
    disp('Done!');
end
%%=========================================================================
% Test

imlist = readImageNames(Path.teimg_src);
nTesting = length(imlist);

[U V r c] = Para_setting(Para);

SSIM_Score = zeros(nTesting,1);
Time_Consuming = zeros(nTesting,1);

for i = 1:nTesting

    fprintf('\nProcessing  %d/%d-th image: %s\n',i,nTesting,imlist(i).name);

    im    = imread([Path.teimg_src,imlist(i).name]);
    im    = double(im);

    tic;
    [tar_im] = LCR(im,S,P,PM,Para,U,V,r,c);
    Time_Consuming(i) = toc;
    [tar_im] = uint8(tar_im);
    
    rim = imread([Path.teimg_tar,imlist(i).name]);
    if size(rim,3) == 3
        rim = rgb2gray(rim);
    end
    SSIM_Score(i) = ssim(tar_im,rim);
    
    % save the result
    imwrite(uint8(tar_im),[Path.tarimg,imlist(i).name]);
end

fprintf('The mean SSIM Score on the %s database is %f\n',Para.Database,...
    mean(SSIM_Score));
fprintf('The mean time-consuming on the %s database is %f\n',...
    Para.Database,mean(Time_Consuming));

save([Path.datadir,'SSIM_Time.mat'],'SSIM_Score','Time_Consuming');
