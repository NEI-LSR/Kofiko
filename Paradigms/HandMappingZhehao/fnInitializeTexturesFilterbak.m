function [strctStim, strctDisp, a2iTextureSize, abIsMovie, aiApproxNumFrames, afMovieLengthSec,acImages, aTextTable, aDispTable, aDispLut] = fnInitializeTexturesFilter(acFileNames)
%dbstop at 95
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global g_strctPTB 

%% initialize values 
% Load a mat file with matrices defining the ellipses and their indices,
% the SPD tables, and corresponding RGB values for a specific screen ...
% this mat file is generated with an other script (see SpotlightOpt_Main.m
% for details)

load([acFileNames,filesep,'2017-4-17-14g_strctParadigm.mat']);
%load([acFileNames,filesep,'MyList.mat']);

% define the quadrants and the filters
strctList.Quadrant.List = {'PP', 'NP', 'NN', 'PN', 'B1', 'B2', 'BW'};
%strctList.CC.List       = {'noFilter', 'r', 'g', 'b', 'c', 'm', 'y', 'nd'};
strctList.CC.List       = {'noFilter'};
for ii = 0 : 359
    temp = num2str(ii);
    strctList.CC.List = [strctList.CC.List temp];
end

%  strctList.Quadrant.Ind  = [1 3 6 7];
%  strctList.CC.Ind        = [1 4 8];
strctList.Quadrant.Ind  = 1 : length(strctList.Quadrant.List);
strctList.CC.Ind        = 1 : length(strctList.CC.List);
 
iNumImages = length(strctList.Quadrant.List) * length(strctList.CC.List);

ahTextures = zeros(1,iNumImages);
a2iTextureSize = zeros(2,iNumImages); %[x;y]
abIsMovie = zeros(1,iNumImages) > 0;
aiApproxNumFrames = zeros(1,iNumImages);
afMovieLengthSec= zeros(1,iNumImages);
acImages = cell(1,iNumImages);


%% Make textures for all backgrounds and filters and generate LUTs
% for each quadrants
for ii = 1 : length(strctList.Quadrant.Ind)
     % load the matrix of ellipses for the background and make a texture
     ImIndTemp = mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(1)).afMatrixC -1;
     strctStim(ii).Back.Disp     = Screen('MakeTexture', g_strctPTB.m_hWindow, uint8(ImIndTemp));
     
     % save the corresponding name from the quadrant list
     strctStim(ii).Back.DispName = strctList.Quadrant.List{ii};
     
     % find the colors to be used for this quadrant (extrated from a
     % complete list of 280 colors computed in SpotlightOpt_Main.m)
     ColorMin = 1 + (strctList.Quadrant.Ind(ii)-1)*40;
     ColorMax = strctList.Quadrant.Ind(ii)*40; 
     RGBtemp =  mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(1)).strctPic.strctObjectProperties.afRGB(ColorMin:ColorMax,:);
     
     % Normalize the RGB values for each quadrant
     RGBtempMax  = max(RGBtemp(:));
     RGBtempBack = RGBtemp/RGBtempMax;
     
% % 
%      cLUTtemp = mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(1)).strctPic.strctSPDNC;
%      cLUTtemp = cLUTtemp(~cellfun('isempty',{cLUTtemp.afSPD})); 
% %     
%     ImTemp = ((mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(1)).strctPic.afRGB(:,:,:)*255));
%     ImText(ii).Back.Disp = Screen('MakeTexture',number, uint8(round(ImTemp)));

    % generate for each quadrant kk scrambled vectors of indices for
    % scrambled cluts
    randInd = zeros(10,40);
    randInd(1,:) = 1 : 40;
    for kk = 2 : 10
        randInd(kk,:) = randperm(40);  
    end
    
    % For each filter
    for jj = 1 :  length(strctList.CC.Ind)
         % load the matrix of ellipses for the background and make a texture
         % In order to display those textures with the background, add a
         % constant value to the indices so there is no overlap of values
         % when we will define the clut.
         ImIndTemp = mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(1)).afMatrixC + 40 -1;
         acImages{(ii-1)*length(strctList.CC.Ind) + jj} =  uint8(ImIndTemp);

         a2iTextureSize(1,(ii-1)*length(strctList.CC.Ind) + jj) = size(uint8(ImIndTemp),2);
         a2iTextureSize(2,(ii-1)*length(strctList.CC.Ind) + jj) = size(uint8(ImIndTemp),1);  
        
         strctStim(ii).Filter(jj).Disp = Screen('MakeTexture',g_strctPTB.m_hWindow, uint8(ImIndTemp)); 
         
         % save the corresponding name from the CC list         
         strctStim(ii).Filter(jj).DispName = [strctList.Quadrant.List{ii},'-',strctList.CC.List{jj}];
         
        % find the colors to be used for this quadrant AND filter (extrated from a
        % complete list of 280 colors computed in SpotlightOpt_Main.m)        
         RGBtemp =  mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(jj)).strctPic.strctObjectProperties.afRGB(ColorMin:ColorMax,:);
         RGBtemp = RGBtemp/RGBtempMax;
         
         % define a "master" clut for both background and filter
         cLUTtemp = zeros(256, 3);
         cLUTtemp(1 : 40, :) = RGBtempBack;
         cLUTtemp(41 : 80, :) = RGBtemp;
         cLUT = BitsPlusEncodeClutRow(round((cLUTtemp.^(1/2.2)) .* ((2^16) -1))); %, repmat(((linspace(0,1,256)').^(1/2.2)) .* 2^16 -1,1,1),  zeros(256,1)]);
         strctStim(ii).Filter(jj).cLUT = cLUT;
         
         % scrambling the "master" clut for kk color distributions
         for kk = 1 : 10
            cLUTtemprand = zeros(256, 3);
            cLUTtemprand(1 : 40, :) = RGBtempBack(randInd(kk,:),:);
            cLUTtemprand(41 : 80, :) = RGBtemp(randInd(kk,:), :);
            cLUTrand = BitsPlusEncodeClutRow(round((cLUTtemprand.^(1/2.2)) .* ((2^16) -1))); %, repmat(((linspace(0,1,256)').^(1/2.2)) .* 2^16 -1,1,1),  zeros(256,1)]);
            strctStim(ii).Filter(jj).cLUTrand(kk).cLUT = cLUTrand;            
         end
     
%         ImTemp = ((mstrctPic(strctList.Quadrant.Ind(ii)).mstrctQuadrant(strctList.CC.Ind(jj)).strctPic.afRGB(:,:,:)*255));
%         ImText(ii).Filter(jj).Disp = Screen('MakeTexture',number, uint8(round(ImTemp)));

    end   
end

%% make a simple table linking textures windows with corresponding background names
for ii = 1 : length(strctList.Quadrant.Ind)
        aTextTable{ii, 1} = strctStim(ii).Back.Disp;
        aTextTable{ii, 2} = strctStim(ii).Back.DispName;        
        for jj = 1 :  length(strctList.CC.Ind)
            aTextTable{length(strctList.Quadrant.Ind) + length(strctList.CC.Ind)*(ii-1) + jj, 1} = strctStim(ii).Filter(jj).Disp;
            aTextTable{length(strctList.Quadrant.Ind) + length(strctList.CC.Ind)*(ii-1) + jj, 2} = strctStim(ii).Filter(jj).DispName;
        end
end

%% make a table for all combinations that need to be displayed
for ii = 1 : length(strctList.Quadrant.Ind)
        for jj = 1 :  length(strctList.CC.Ind)
            DispNameTable{length(strctList.CC.Ind)*(ii-1) + jj} = strctStim(ii).Filter(jj).DispName;
            for kk = 1 : 10
                aDispLut{length(strctList.CC.Ind)*(ii-1) + jj, kk} = strctStim(ii).Filter(jj).cLUTrand(kk).cLUT;
            end
        end
end

for ii = 1 : iNumImages
    indTemp         =  find(strcmp(aTextTable(:, 2),DispNameTable(ii)));
    BackTemp        = DispNameTable{ii};
    aDispTable(ii, :) = [aTextTable{find(strcmp(aTextTable(:, 2),BackTemp(1:2))), 1} aTextTable{indTemp, 1}];   
end

strctDisp.aTextTable = aTextTable;
strctDisp.aDispLut   = aDispLut;
strctDisp.aDispTable = aDispTable;

% %% Test for list of stim to be displayed
% indNN      = find(strcmp(aTextTable(:, 2),'NN'));
% indNNc     = find(strcmp(aTextTable(:, 2),'NN-c'));
% indNNr     = find(strcmp(aTextTable(:, 2),'NN-r'));
% indNP      = find(strcmp(aTextTable(:, 2),'NP'));
% indNPnd    = find(strcmp(aTextTable(:, 2),'NP-nd'));
% aDispTable = [aTextTable{indNN, 1} aTextTable{indNNc, 1}; ...
%               aTextTable{indNN, 1} aTextTable{indNNr, 1}; ...
%               aTextTable{indNP, 1} aTextTable{indNPnd, 1}];


% Load all textures into VRAM
[bSuccess, abInVRAM] = Screen('PreloadTextures', g_strctPTB.m_hWindow);
if (bSuccess)
    fnLog('All textures were loaded to VRAM');
else
    fnLog('Warning, only %d out of %d textures were loaded to VRAM', sum(abInVRAM>0), length(abInVRAM) );
end

if g_strctPTB.m_bNonRectMakeTexture == false
    fnParadigmToKofikoComm('DisplayMessage','WARNING. Images rescaled. Non nViDIA Card!');
end

return
