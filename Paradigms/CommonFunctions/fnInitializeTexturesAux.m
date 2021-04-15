function [ahTextures,a2iTextureSize,abIsMovie,aiApproxNumFrames, afMovieLengthSec,acImages] = fnInitializeTexturesAux(acFileNames, bShowWhileLoading, bPing)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
if ~exist('bShowWhileLoading','var')
    bShowWhileLoading = false;
end;
if ~exist('bPing','var')
    bPing = false;
end;
global g_strctPTB 
iNumImages = length(acFileNames);

ahTextures = zeros(1,iNumImages);
a2iTextureSize = zeros(2,iNumImages); %[x;y]
abIsMovie = zeros(1,iNumImages) > 0;
abIsMatrix = zeros(1,iNumImages) > 0;
aiApproxNumFrames = zeros(1,iNumImages);
afMovieLengthSec= zeros(1,iNumImages);
acImages = cell(1,iNumImages);
for iFileIter=1:iNumImages
    abIsMovie(iFileIter) = fnIsMovie(acFileNames{iFileIter});
	abIsMatrix(iFileIter) = fnIsMatrix(acFileNames{iFileIter});
	%abIsMatlabCommand(iFileIter) = fnIsMatlabCommand(acFileNames{iFileIter});
    if abIsMovie(iFileIter) 
        % Load movie
       [hMovie,fDuration,fFramesPerSeconds,iWidth,iHeight]=Screen('OpenMovie', g_strctPTB.m_hWindow, acFileNames{iFileIter});
       aiApproxNumFrames(iFileIter) = ceil(fDuration*fFramesPerSeconds);
       afMovieLengthSec(iFileIter) = fDuration;
       ahTextures(iFileIter) = hMovie;
       a2iTextureSize(1,iFileIter) = iWidth;
       a2iTextureSize(2,iFileIter) = iHeight;
	elseif abIsMatrix(iFileIter)
		
        I = load(acFileNames{iFileIter},'im','Clut');
		if isfield(I.im, 'commandToRun')
			% im is a struct in this case; the substructs holds the parameters for the trial
			a2iTextureSize(1,iFileIter) = 1;% placeholder
			a2iTextureSize(2,iFileIter) = 1;% placeholder
            acImages{iFileIter} = I.im; % Holds the actual commands
			acImages{iFileIter}.Clut = I.Clut;
		else
			a2iTextureSize(1,iFileIter) = size(I.im,2);
			a2iTextureSize(2,iFileIter) = size(I.im,1);
			if strcmp(class(I.im),'uint16')
				acImages{iFileIter} = I.Clut;
				acImages{iFileIter} = I;
				I = double(I.im);
				
				ahTextures(iFileIter) = Screen('MakeTexture', g_strctPTB.m_hWindow,  I);
			elseif strcmp(class(I.im),'uint8')
				acImages{iFileIter} = I.Clut;
				acImages{iFileIter} = I;
				I = double(I.im);
				ahTextures(iFileIter) = Screen('MakeTexture', g_strctPTB.m_hWindow,  I);
			elseif strcmp(class(I.im),'double')
				acImages{iFileIter} = I.Clut;
				I = I.im;
				ahTextures(iFileIter) = Screen('MakeTexture', g_strctPTB.m_hWindow,  I);
			end
		end
    else
        % Image
        [I,C] = imread(acFileNames{iFileIter});
        if strcmp(class(I),'uint16')
            % Rescale to uint8
            warning off;
            I = uint8(double(I) / 65535 * 255);
            warning on;
        end
        if g_strctPTB.m_bNonRectMakeTexture == false
            I = imresize(I,[128 128],'bilinear');
        end
        a2iTextureSize(1,iFileIter) = size(I,2);
        a2iTextureSize(2,iFileIter) = size(I,1);
        acImages{iFileIter} = I;
        ahTextures(iFileIter) = Screen('MakeTexture', g_strctPTB.m_hWindow,  I);
    end
    if (iNumImages < 1000 && bShowWhileLoading && ~abIsMovie(iFileIter) )  || (iNumImages > 1000  && mod(iFileIter,50) == 0 && bShowWhileLoading && ~abIsMovie(iFileIter) )
           Screen('DrawTexture', g_strctPTB.m_hWindow, ahTextures(iFileIter));
         Screen('Flip', g_strctPTB.m_hWindow, 0, 0, 2);
    end
    if bPing
            fnStimulusServerToKofikoParadigm('LoadedImage',iFileIter );
    end
end;
if bShowWhileLoading
%if ~isempty(g_strctParadigm) && isfield(g_strctParadigm,'m_bShowWhileLoading') && g_strctParadigm.m_bShowWhileLoading
     Screen('Flip', g_strctPTB.m_hWindow, 0, 0, 2);
end
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

% Changelog 1/23/14 Josh - initializing background gray CLUT for the end of each trial display period, so that ITI does not display the stim CLUT
%[g_strctPTB.m_hBGClut(1:256,1) g_strctPTB.m_hBGClut(1:256,2) g_strctPTB.m_hBGClut(1:256,3)]= deal(linspace(0,65535,256));
% End Changelog
return

function bMovie = fnIsMovie(strFileName)
[strPath,strFile,strExt]=fileparts(strFileName);
bMovie = strcmpi(strExt,'.mov') || strcmpi(strExt,'.avi') || strcmpi(strExt,'.mp4') ;

return;

% Changelog 11/17/13 Josh - adding check for .mat file extension. 
function bMatrix = fnIsMatrix(strFileName)
[strPath,strFile,strExt]=fileparts(strFileName);
bMatrix = strcmpi(strExt,'.mat');
return;
% End Changelog

function bIsMatlabCommand = fnIsMatlabCommand(file)
if isfield(file, 'command_to_run')
	bIsMatlabCommand = 1;
else
	bIsMatlabCommand = 0;
end
return;