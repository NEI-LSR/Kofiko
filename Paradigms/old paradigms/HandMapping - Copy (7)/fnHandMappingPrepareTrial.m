function strctTrial = fnHandMappingPrepareTrial()
%
% Copyright (c) 2015 Joshua Fuller-Deets, Massachusetts Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
global g_strctParadigm g_strctPTB
%fCurrTime = GetSecs;
ClockRandSeed();
% Give Kofiko something to chew on later
iNewStimulusIndex = 1;

trialDesignID =  get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'value');
cImageListNames = get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'string');
%trialDesignType = deblank(cImageListNames(trialDesignID,:));


% Add new paradigm types here. Stimulus blocks inside of a paradigm do not need their own case
switch deblank(cImageListNames(trialDesignID,:))
    case 'MRIStim'
        g_strctParadigm.m_strTrialType = 'Image';
        
    case 'MovieStim'
        g_strctParadigm.m_strTrialType = 'Movie';
        
    otherwise
        g_strctParadigm.m_strTrialType = g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(g_strctParadigm.m_iCurrentBlockIndexInOrderList).m_strBlockName;
end
g_strctParadigm.m_iLastShownTrialID = 1;
%{
if g_strctParadigm.m_bPlanTrialsInAdvance
    numTrialsToPlan = round(g_strctParadigm.PlanAheadTime.Buffer(1,:,g_strctParadigm.PlanAheadTime.BufferIdx) /...
        g_strctPTB.g_strctStimulusServer.m_RefreshRateMS);
    
    for iTrialsToPlan = 1:numTrialsToPlan
        strctTrial(iTrialsToPlan).m_strTrialType =  g_strctParadigm.m_strTrialType;
        strctTrial(iTrialsToPlan).m_iStimulusIndex = iNewStimulusIndex;
        strctTrial(iTrialsToPlan).m_strctMedia = g_strctParadigm.m_strctDesign.m_astrctMedia(iNewStimulusIndex);
        strctTrial(iTrialsToPlan).m_pt2iFixationSpot = g_strctParadigm.FixationSpotPix.Buffer(1,:,g_strctParadigm.FixationSpotPix.BufferIdx);
        strctTrial(iTrialsToPlan).m_pt2fStimulusPos = g_strctParadigm.StimulusPos.Buffer(1,:,g_strctParadigm.StimulusPos.BufferIdx);
        strctTrial(iTrialsToPlan).m_fFixationSizePix = g_strctParadigm.FixationSizePix.Buffer(1,:,g_strctParadigm.FixationSizePix.BufferIdx);
        strctTrial(iTrialsToPlan).m_fGazeBoxPix = g_strctParadigm.GazeBoxPix.Buffer(1,:,g_strctParadigm.GazeBoxPix.BufferIdx);
        strctTrial(iTrialsToPlan).m_fStimulusSizePix = g_strctParadigm.StimulusSizePix.Buffer(1,:,g_strctParadigm.StimulusSizePix.BufferIdx);
        strctTrial(iTrialsToPlan).m_bShowPhotodiodeRect = g_strctParadigm.m_bShowPhotodiodeRect;
        strctTrial(iTrialsToPlan).m_iLocalFrameCounter = 1;
        strctTrial(iTrialsToPlan).m_bColorUpdated = 0;
        strctTrial(iTrialsToPlan).m_bBlur = 0;
        strctTrial(iTrialsToPlan).m_bClipStimulusOutsideStimArea = g_strctParadigm.m_bClipStimulusOutsideStimArea;
        strctTrial(iTrialsToPlan).m_bUseBitsPlusPlus = 1;
        g_strctParadigm.m_strctCurrentTrial.m_bDrawScreenCoords = 1;
        strctTrial(iTrialsToPlan).m_bFlipForegroundBackground = g_strctParadigm.m_bFlipForegroundBackground;
        strctTrial(iTrialsToPlan).m_fImageFlipON_TS_StimulusServer = [];
        strctTrial(iTrialsToPlan).m_fImageFlipON_TS_Kofiko = [];
        strctTrial(iTrialsToPlan).m_bColorShift = 0;
        strctTrial(iTrialsToPlan).m_iShiftOffset = 0;
        strctTrial(iTrialsToPlan).m_bUseGaussianPulses  = g_strctParadigm.m_bUseGaussianPulses ;
        strctTrial(iTrialsToPlan).m_bRandomStimulusPosition = g_strctParadigm.m_bRandomStimulusPosition;
        strctTrial(iTrialsToPlan).m_iNumberOfBars = 1;
        strctTrial(iTrialsToPlan).m_acCurrentlyVariableFields = g_strctParadigm.m_acCurrentlyVariableFields;
        strctTrial(iTrialsToPlan).m_bDifferentColorsForDifferentBars = 0;
        strctTrial(iTrialsToPlan).m_bUseStrobes = 0;
        
        
        aiStimulusScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');
        strctTrial(iTrialsToPlan).m_aiNonStimulusAreas = [0,0, aiStimulusScreenSize(3), min(g_strctParadigm.m_aiStimulusRect(2),aiStimulusScreenSize(4));...
            0,0,min(aiStimulusScreenSize(3),g_strctParadigm.m_aiStimulusRect(1)),aiStimulusScreenSize(4);...
            0, min(aiStimulusScreenSize(4),g_strctParadigm.m_aiStimulusRect(4)), aiStimulusScreenSize(3), aiStimulusScreenSize(4);...
            min(aiStimulusScreenSize(3),g_strctParadigm.m_aiStimulusRect(3)), 0,aiStimulusScreenSize(3), aiStimulusScreenSize(4)]';
        strctTrial(iTrialsToPlan).m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
        
%}

% end
%else
tmpstrctTrial.m_strTrialType = g_strctParadigm.m_strTrialType ;
tmpstrctTrial.m_iStimulusIndex = iNewStimulusIndex;
tmpstrctTrial.m_strctMedia = g_strctParadigm.m_strctDesign.m_astrctMedia(iNewStimulusIndex);
tmpstrctTrial.m_pt2iFixationSpot = g_strctParadigm.FixationSpotPix.Buffer(1,:,g_strctParadigm.FixationSpotPix.BufferIdx);
tmpstrctTrial.m_pt2fStimulusPos = g_strctParadigm.StimulusPos.Buffer(1,:,g_strctParadigm.StimulusPos.BufferIdx);
tmpstrctTrial.m_fFixationSizePix = g_strctParadigm.FixationSizePix.Buffer(1,:,g_strctParadigm.FixationSizePix.BufferIdx);
tmpstrctTrial.m_fGazeBoxPix = g_strctParadigm.GazeBoxPix.Buffer(1,:,g_strctParadigm.GazeBoxPix.BufferIdx);
tmpstrctTrial.m_fStimulusSizePix = g_strctParadigm.StimulusSizePix.Buffer(1,:,g_strctParadigm.StimulusSizePix.BufferIdx);
tmpstrctTrial.m_iLocalFrameCounter = 1;
g_strctParadigm.m_strctCurrentTrial.m_bDrawScreenCoords = 1;
tmpstrctTrial.m_fImageFlipON_TS_StimulusServer = [];
tmpstrctTrial.m_fImageFlipON_TS_Kofiko = [];
%tmpstrctTrial.m_bColorShift = 0;
tmpstrctTrial.m_iShiftOffset = 0;
tmpstrctTrial.m_iNumberOfBars = 1;
tmpstrctTrial.m_acCurrentlyVariableFields = g_strctParadigm.m_acCurrentlyVariableFields;
tmpstrctTrial.m_iColorSteps = 0;

tmpstrctTrial.m_bIsColorWheelTrial = false;
tmpstrctTrial.m_bRandomOrientation = false;
tmpstrctTrial.m_bShiftOffsetTrial = false;
tmpstrctTrial.m_bUseGaussianPulses  = g_strctParadigm.m_bUseGaussianPulses ;
tmpstrctTrial.m_bRandomStimulusPosition = g_strctParadigm.m_bRandomStimulusPosition;
tmpstrctTrial.m_bDifferentColorsForDifferentBars = 0;
tmpstrctTrial.m_bUseStrobes = 0;
tmpstrctTrial.m_bUsingPresetColor = false;
tmpstrctTrial.m_bVariableTestObject = false;
tmpstrctTrial.m_bRandomStimulusOrientation = false;
tmpstrctTrial.m_bColorUpdated = 0;
tmpstrctTrial.m_bBlur = 0;
tmpstrctTrial.m_bClipStimulusOutsideStimArea = g_strctParadigm.m_bClipStimulusOutsideStimArea;
tmpstrctTrial.m_bUseBitsPlusPlus = 1;
tmpstrctTrial.m_bShowPhotodiodeRect = g_strctParadigm.m_bShowPhotodiodeRect;
tmpstrctTrial.m_bFlipForegroundBackground = g_strctParadigm.m_bFlipForegroundBackground;
tmpstrctTrial.m_bReverseColorOrder = false;
tmpstrctTrial.m_bRandomColor = false;


aiStimulusScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');
tmpstrctTrial.m_aiNonStimulusAreas = [0,0, aiStimulusScreenSize(3), min(g_strctParadigm.m_aiStimulusRect(2),aiStimulusScreenSize(4));...
    0,0,min(aiStimulusScreenSize(3),g_strctParadigm.m_aiStimulusRect(1)),aiStimulusScreenSize(4);...
    0, min(aiStimulusScreenSize(4),g_strctParadigm.m_aiStimulusRect(4)), aiStimulusScreenSize(3), aiStimulusScreenSize(4);...
    min(aiStimulusScreenSize(3),g_strctParadigm.m_aiStimulusRect(3)), 0,aiStimulusScreenSize(3), aiStimulusScreenSize(4)]';
tmpstrctTrial.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
%end

% DEFUNCT
% used for queued trial code, was not successful. bPlanTrialsInAdvance is set to false by default
if g_strctParadigm.m_bPlanTrialsInAdvance
    numTrialsToPlan = round(g_strctParadigm.PlanAheadTime.Buffer(1,:,g_strctParadigm.PlanAheadTime.BufferIdx) /...
        g_strctPTB.g_strctStimulusServer.m_RefreshRateMS);
    
    switch  g_strctParadigm.m_strTrialType
        % only two cases here with 1 frame / trial that we should plan ahead for
        % can change later for very short moving bar trials etc
        case 'Plain Bar'
            for iPlannedTrials = 1:numTrialsToPlan
                
                strctTrial(iPlannedTrials).trial = fnPreparePlainBarTrial(g_strctPTB, tmpstrctTrial);
                strctTrial(iPlannedTrials).trial.m_iPlanAheadTrialID = iPlannedTrials;
                
            end
        case 'Moving Bar'
            [strctTrial.trial] = fnPrepareMovingBarTrial(g_strctPTB, tmpstrctTrial);
        case 'Moving Disc'
            [g_strctParadigm, strctTrial.trial] = fnPrepareMovingDiscTrial(g_strctParadigm, g_strctPTB, tmpstrctTrial);
        case 'Gabor'
            for iPlannedTrials = 1:numTrialsToPlan
                [g_strctParadigm, strctTrial(iPlannedTrials).trial] = fnPrepareRealTimeGaborTrial(g_strctParadigm, g_strctPTB, tmpstrctTrial);
                strctTrial(iPlannedTrials).trial.m_iPlanAheadTrialID = iPlannedTrials;
            end
        case 'Two Bar'
            [strctTrial.trial] = fnPrepare2BarTrial(g_strctPTB, tmpstrctTrial);
            
        case 'Image'
            [strctTrial.trial] = fnPrepareImageTrial(g_strctPTB, tmpstrctTrial);
    end
    
    % for identifying this trial when the stimulus server reports it has been shown
    
    
else
    switch g_strctParadigm.m_strTrialType
        case 'Plain Bar'
            [strctTrial.trial] = fnPreparePlainBarTrial(g_strctPTB, tmpstrctTrial);
        case 'Moving Bar'
            [strctTrial.trial] = fnPrepareMovingBarTrial(g_strctPTB, tmpstrctTrial);
        case 'Moving Disc'
            [g_strctParadigm, strctTrial.trial] = fnPrepareMovingDiscTrial(g_strctParadigm, g_strctPTB, tmpstrctTrial);
        case 'Gabor'
            [g_strctParadigm, strctTrial.trial] = fnPrepareRealTimeGaborTrial(g_strctParadigm, g_strctPTB, tmpstrctTrial);
        case 'Two Bar'
            [strctTrial.trial] = fnPrepare2BarTrial(g_strctPTB, tmpstrctTrial);
            
        case 'Image'
            [strctTrial.trial] = fnPrepareImageTrial(g_strctPTB, tmpstrctTrial);
            
        case 'Movie'
            [strctTrial.trial] = fnPrepareMovieTrial(g_strctPTB, tmpstrctTrial);
    end
    
    
end
return;


% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPrepareMovieTrial(g_strctPTB, strctTrial)
global g_strctParadigm

g_strctParadigm.m_bMovieStartedLocally = false;
g_strctParadigm.m_bFirstMovieFrameDisplayed = false;





strctTrial.m_iFixationColor = [255 255 255];


strctTrial.m_fMovieWidthMultiplier = squeeze(g_strctParadigm.MovieWidth.Buffer(1,:,g_strctParadigm.MovieWidth.BufferIdx))/100;
strctTrial.m_fMovieHeightMultiplier = squeeze(g_strctParadigm.MovieLength.Buffer(1,:,g_strctParadigm.MovieLength.BufferIdx))/100;
strctTrial.m_bAspectRatioLocked = g_strctParadigm.m_strctMovieStim.m_bLockAspectRatio;


currentBlockStimBGColorsR = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundRed'];
currentBlockStimBGColorsG = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundGreen'];
currentBlockStimBGColorsB = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundBlue'];

strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.MovieOrientation.Buffer(1,:,g_strctParadigm.MovieOrientation.BufferIdx));

strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
    squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
    squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];

strctTrial.m_afBackgroundColor = strctTrial.m_afLocalBackgroundColor;



[strctTrial.m_iMovieBlockIndex, g_strctParadigm.m_strctMovieStim.m_iSelectedMovieBlock] = deal(g_strctParadigm.m_iCurrentBlockIndexInOrderList);

if g_strctParadigm.m_strctMovieStim.m_bRandomOrder
    iSelectedStimulus = randi(numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths));
    %iSelectedStimulus = deal(randi(numel(g_strctParadigm.m_strctMovieStim.ahTextures)));
    %strctTrial.m_iMovieIndex = g_strctParadigm.m_strctMovieStim.m_iSelectedMovie;
elseif g_strctParadigm.m_strctMovieStim.m_bReverseOrder
    iSelectedStimulus = g_strctParadigm.m_strctMovieStim.m_iSelectedMovie - 1;
    if iSelectedStimulus < 1
        %iSelectedStimulus = numel(g_strctParadigm.m_strctMovieStim.m_ahMovieHandles);
        iSelectedStimulus = numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths);
    end
    %[strctTrial.m_iMovieIndex, g_strctParadigm.m_strctMovieStim.m_iSelectedMovie] = deal(iSelectedStimulus);
    
else
    iSelectedStimulus = g_strctParadigm.m_strctMovieStim.m_iSelectedMovie + 1;
    %if iSelectedStimulus > numel(g_strctParadigm.m_strctMovieStim.m_ahMovieHandles)
    if iSelectedStimulus > numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths)
        iSelectedStimulus = 1;
    end
end
[strctTrial.m_iMovieIndex, g_strctParadigm.m_strctMovieStim.m_iSelectedMovie] = deal(iSelectedStimulus);
if g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly
    %disp('loading movie')
    strctTrial.m_strMovieFilePath = g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths{iSelectedStimulus};
    [strctTrial.hLocalMovieHandle, strctTrial.fDuration, strctTrial.fFPS, strctTrial.iWidth, strctTrial.iHeight, strctTrial.iCount, strctTrial.fAspectRatio] = ...
        Screen('OpenMovie', g_strctPTB.m_hWindow, g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths{iSelectedStimulus});
    strctTrial.abIsMovie = true;
    strctTrial.a2iTextureSize = [strctTrial.iWidth, ...;
        strctTrial.iHeight];
    strctTrial.numFrames = round(strctTrial.fDuration / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
    strctTrial.afMovieLengthSec	= strctTrial.fDuration;
    strctTrial.m_fStimulusON_MS = strctTrial.fDuration;
    strctTrial.m_fStimulusOFF_MS = 200;
    
    %{
strctTrial.m_fStimulusON_MS = squeeze(g_strctParadigm.MovieStimulusOnTime.Buffer(1,:,g_strctParadigm.MovieStimulusOnTime.BufferIdx));
strctTrial.m_fStimulusOFF_MS = squeeze(g_strctParadigm.MovieStimulusOffTime.Buffer(1,:,g_strctParadigm.MovieStimulusOffTime.BufferIdx));
    %}
else
    
    
    %strctTrial. g_strctParadigm.m_strctMovieStim.ahTextures
    strctTrial.a2iTextureSize = [g_strctParadigm.m_strctMovieStim.m_acMovieData{iSelectedStimulus}.iWidth, ...;
        g_strctParadigm.m_strctMovieStim.m_acMovieData{iSelectedStimulus}.iHeight];
    
    strctTrial.hLocalMovieHandle = g_strctParadigm.m_strctMovieStim.m_ahMovieHandles{iSelectedStimulus};
    strctTrial.abIsMovie = g_strctParadigm.m_strctMovieStim.m_abIsMovie(iSelectedStimulus);
    if strctTrial.abIsMovie
        strctTrial.numFrames = g_strctParadigm.m_strctMovieStim.m_acMovieData{iSelectedStimulus}.aiApproxNumFrames;
    else
        strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
        
        
    end
    strctTrial.afMovieLengthSec	= g_strctParadigm.m_strctMovieStim.m_acMovieData{iSelectedStimulus}.fDuration;
    %strctTrial.Movie = g_strctParadigm.m_strctMovieStim.acMovies(iSelectedStimulus);
end
strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);

if g_strctParadigm.m_strctMovieStim.m_bOverrideMovieColors
    strctTrial.numberBlurSteps = 1;
    [strctTrial] = fnCycleColor(strctTrial);
    
else
    strctTrial.m_bUseBitsPlusPlus = false;
end


if g_strctParadigm.m_strctMovieStim.m_bFitDisplayAreaToMovieSize
    strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (strctTrial.a2iTextureSize(1)/2));
    strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (strctTrial.a2iTextureSize(2)/2));
    strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + strctTrial.a2iTextureSize(1);
    strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + strctTrial.a2iTextureSize(2);
    
elseif strctTrial.m_bAspectRatioLocked
    
    
    strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((strctTrial.a2iTextureSize(1)*strctTrial.m_fMovieWidthMultiplier)/2)));
    strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((strctTrial.a2iTextureSize(2)*strctTrial.m_fMovieWidthMultiplier)/2)));
    strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + strctTrial.a2iTextureSize(1)*strctTrial.m_fMovieWidthMultiplier;
    strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + strctTrial.a2iTextureSize(2)*strctTrial.m_fMovieWidthMultiplier;
else
    
    strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((strctTrial.a2iTextureSize(1)*strctTrial.m_fMovieWidthMultiplier)/2)));
    strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((strctTrial.a2iTextureSize(2)*strctTrial.m_fMovieHeightMultiplier)/2)));
    strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + strctTrial.a2iTextureSize(1)*strctTrial.m_fMovieWidthMultiplier;
    strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + strctTrial.a2iTextureSize(2)*strctTrial.m_fMovieHeightMultiplier;
    
    
    
end




return;


% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPrepareImageTrial(g_strctPTB, strctTrial)
global g_strctParadigm


strctTrial.m_strSelectedImageSet = g_strctParadigm.m_strctMRIStim.m_strCurrentlySelectedStimset;

strctTrial.m_fStimulusON_MS = squeeze(g_strctParadigm.ImageStimulusOnTime.Buffer(1,:,g_strctParadigm.ImageStimulusOnTime.BufferIdx));
strctTrial.m_fStimulusOFF_MS = squeeze(g_strctParadigm.ImageStimulusOffTime.Buffer(1,:,g_strctParadigm.ImageStimulusOffTime.BufferIdx));
strctTrial.m_iFixationColor = [255 255 255];


strctTrial.m_fImageWidthMultiplier = squeeze(g_strctParadigm.ImageWidth.Buffer(1,:,g_strctParadigm.ImageWidth.BufferIdx))/100;
strctTrial.m_fImageHeightMultiplier = squeeze(g_strctParadigm.ImageLength.Buffer(1,:,g_strctParadigm.ImageLength.BufferIdx))/100;
strctTrial.m_bAspectRatioLocked = g_strctParadigm.m_strctMRIStim.m_bLockAspectRatio;


currentBlockStimBGColorsR = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundRed'];
currentBlockStimBGColorsG = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundGreen'];
currentBlockStimBGColorsB = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundBlue'];

strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.ImageOrientation.Buffer(1,:,g_strctParadigm.ImageOrientation.BufferIdx));

strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
    squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
    squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];

strctTrial.m_afBackgroundColor = strctTrial.m_afLocalBackgroundColor;



[strctTrial.m_iImageBlockIndex, g_strctParadigm.m_strctMRIStim.m_iSelectedImageBlock] = deal(g_strctParadigm.m_iCurrentBlockIndexInOrderList);

if g_strctParadigm.m_strctMRIStim.m_bRandomOrder
    iSelectedStimulus = deal(randi(numel(g_strctParadigm.m_strctMRIStim.ahTextures)));
    %strctTrial.m_iImageIndex = g_strctParadigm.m_strctMRIStim.m_iSelectedImage;
elseif g_strctParadigm.m_strctMRIStim.m_bReverseOrder
    iSelectedStimulus = g_strctParadigm.m_strctMRIStim.m_iSelectedImage - 1;
    if iSelectedStimulus < 1
        iSelectedStimulus = numel(g_strctParadigm.m_strctMRIStim.ahTextures);
    end
    %[strctTrial.m_iImageIndex, g_strctParadigm.m_strctMRIStim.m_iSelectedImage] = deal(iSelectedStimulus);
    
else
    iSelectedStimulus = g_strctParadigm.m_strctMRIStim.m_iSelectedImage + 1;
    if iSelectedStimulus > numel(g_strctParadigm.m_strctMRIStim.ahTextures)
        iSelectedStimulus = 1;
    end
end
[strctTrial.m_iImageIndex, g_strctParadigm.m_strctMRIStim.m_iSelectedImage] = deal(iSelectedStimulus);
strctTrial.m_strImageName = g_strctParadigm.m_strctMRIStim.acFileNames{strctTrial.m_iImageIndex};
%strctTrial. g_strctParadigm.m_strctMRIStim.ahTextures
strctTrial.a2iTextureSize = g_strctParadigm.m_strctMRIStim.a2iTextureSize(:,iSelectedStimulus);
strctTrial.abIsMovie = g_strctParadigm.m_strctMRIStim.abIsMovie(iSelectedStimulus);
if strctTrial.abIsMovie
    strctTrial.numFrames = g_strctParadigm.m_strctMRIStim.aiApproxNumFrames;
else
    strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
    
    
end

strctTrial.afMovieLengthSec	= g_strctParadigm.m_strctMRIStim.afMovieLengthSec(iSelectedStimulus);
%strctTrial.Image = g_strctParadigm.m_strctMRIStim.acImages(iSelectedStimulus);

strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);

if g_strctParadigm.m_strctMRIStim.m_bOverrideImageColors
    strctTrial.numberBlurSteps = 1;
    [strctTrial] = fnCycleColor(strctTrial);
    
    
else
    strctTrial.m_bUseBitsPlusPlus = false;
end


if strctTrial.m_bAspectRatioLocked
    
    
    strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
    strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
    strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
    strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
else
    
    strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
    strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier)/2)));
    strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
    strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier;
    
    
    
end


return;
% ------------------------------------------------------------------------------------------------------------------------



function [strctTrial] = fnPreparePlainBarTrial(g_strctPTB, strctTrial)
global g_strctStimulusServer g_strctParadigm
strctTrial.m_bRandomStimulusPosition = 0;
strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];


strctTrial.m_afTrialIdentifier = round(rand(1,3)*1000);


strctTrial.m_iLength = squeeze(g_strctParadigm.PlainBarLength.Buffer(1,:,g_strctParadigm.PlainBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.PlainBarWidth.Buffer(1,:,g_strctParadigm.PlainBarWidth.BufferIdx));
strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.PlainBarOrientation.Buffer(1,:,g_strctParadigm.PlainBarOrientation.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.PlainBarBlurSteps.Buffer(1,:,g_strctParadigm.PlainBarBlurSteps.BufferIdx)));
strctTrial.m_bBlur  = squeeze(g_strctParadigm.PlainBarBlur.Buffer(1,:,g_strctParadigm.PlainBarBlur.BufferIdx));
%strctTrial.m_bBlur = g_strctParadigm.m_bBlur;

strctTrial.m_fStimulusON_MS = 0;
strctTrial.m_fStimulusOFF_MS = 0;
strctTrial.numFrames = 1; % Tells Kofiko to update every frame




%Override the number of bars if this paradigm is selected. Might change this later.
strctTrial.m_iNumberOfBars = 1;
g_strctParadigm.m_strctHandMappingParameters.m_bRandomStimulusPosition = 0;

strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.PlainBarMoveDistance.Buffer(1,:,g_strctParadigm.PlainBarMoveDistance.BufferIdx));

strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);


if strctTrial.m_iMoveDistance
    strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.PlainBarMoveSpeed.Buffer(1,:,g_strctParadigm.PlainBarMoveSpeed.BufferIdx));
    
    [strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
    strctTrial.m_iNewBarPositionOffset = g_strctParadigm.m_fLastBarPositionOffset + (g_strctParadigm.m_fLastBarMovementDirection *...
        (strctTrial.m_iMoveSpeed/g_strctStimulusServer.m_fRefreshRateMS));
    
    if abs(strctTrial.m_iNewBarPositionOffset) >= strctTrial.m_iMoveDistance
        
        strctTrial.m_iNewBarPositionOffset = sign(strctTrial.m_iNewBarPositionOffset) * strctTrial.m_iMoveDistance;
        g_strctParadigm.bReverse = 1;
    end
    [strctTrial.m_iLineBegin(1),strctTrial.m_iLineBegin(2)] = fnRotateAroundPoint(strctTrial.location_x(1),round(strctTrial.location_y(1) - strctTrial.m_iMoveDistance),strctTrial.location_x(1),...
        strctTrial.location_y(1) ,strctTrial.m_fRotationAngle);
    
    [strctTrial.m_iLineEnd(1), strctTrial.m_iLineEnd(2)] = fnRotateAroundPoint(strctTrial.location_x(1),round(strctTrial.location_y(1)+ strctTrial.m_iMoveDistance),strctTrial.location_x(1),...
        strctTrial.location_y(1) ,strctTrial.m_fRotationAngle);
    
    [offSetX, offSetY] = fnRotateAroundPoint(strctTrial.location_x(1),round(strctTrial.location_y(1)+ strctTrial.m_iNewBarPositionOffset),strctTrial.location_x(1),...
        strctTrial.location_y(1) ,strctTrial.m_fRotationAngle);
    
    strctTrial.location_x(1) = offSetX;
    strctTrial.location_y(1) = offSetY;
    
    g_strctParadigm.m_fLastBarPositionOffset = strctTrial.m_iNewBarPositionOffset;
    if g_strctParadigm.bReverse
        g_strctParadigm.bReverse = 0;
        g_strctParadigm.m_fLastBarMovementDirection = -g_strctParadigm.m_fLastBarMovementDirection;
    end
    
    strctTrial.bar_rect(1,1:4) = [(offSetX - strctTrial.m_iLength/2),...
        (offSetY - strctTrial.m_iWidth/2),...
        (offSetX + strctTrial.m_iLength/2),...
        (offSetY + strctTrial.m_iWidth/2)];
    
else
    [strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
    
    strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2),...
        (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2),...
        (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2),...
        (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
end

[strctTrial] = fnCycleColor(strctTrial);





[strctTrial.point1(1,1), strctTrial.point1(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point2(1,1), strctTrial.point2(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point3(1,1), strctTrial.point3(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point4(1,1), strctTrial.point4(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);

if ~strctTrial.m_bBlur
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
    
    strctTrial.coordinatesX(1:4,:) = [strctTrial.point1(1), strctTrial.point2(1), strctTrial.point3(1),strctTrial.point4(1)];
    strctTrial.coordinatesY(1:4,:) = [strctTrial.point1(2), strctTrial.point2(2), strctTrial.point3(2),strctTrial.point4(2)];
    
else
    
    % min_distance = min((strctTrial.m_iLength/2)-1,(strctTrial.m_iWidth/2)-1);
    % Make sure our number of blur steps is sane
    
    %{
    strctTrial.m_aiBlurStepHolder(1,:) = linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(1),strctTrial.numberBlurSteps);
    strctTrial.m_aiBlurStepHolder(2,:) = linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(2),strctTrial.numberBlurSteps);
    strctTrial.m_aiBlurStepHolder(3,:) = linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(3),strctTrial.numberBlurSteps);
    %}
    
    strctTrial.blurRawScreenCoordinates = [strctTrial.bar_rect(1,1) + strctTrial.numberBlurSteps,...
        strctTrial.bar_rect(1,2) + strctTrial.numberBlurSteps,...
        strctTrial.bar_rect(1,3) - strctTrial.numberBlurSteps,...
        strctTrial.bar_rect(1,4) - strctTrial.numberBlurSteps];
    
    % We have to do the same math we did for the rectangle to rotate the
    % blur points into position
    
    
    [strctTrial.blurCorrectedScreenCoordinates(1,1), strctTrial.blurCorrectedScreenCoordinates(1,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,1),...
        strctTrial.blurRawScreenCoordinates(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blurCorrectedScreenCoordinates(2,1), strctTrial.blurCorrectedScreenCoordinates(2,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,1),...
        strctTrial.blurRawScreenCoordinates(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blurCorrectedScreenCoordinates(3,1), strctTrial.blurCorrectedScreenCoordinates(3,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,3),...
        strctTrial.blurRawScreenCoordinates(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blurCorrectedScreenCoordinates(4,1), strctTrial.blurCorrectedScreenCoordinates(4,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,3),...
        strctTrial.blurRawScreenCoordinates(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blur_starting_point(1,1),strctTrial.blur_starting_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),...
        strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blur_ending_point(1,1),strctTrial.blur_ending_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),...
        strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps+1));
    
    % Only 1 frame and 1 bar here, so we can ignore the middle two dimensions
    % We also add one to the linspace because we can't fillpoly a single pixel in the center of the stimulus
    % This means we'll have an extra entry on the end because I'm too lazy to do anything about it
    % But the fillpoly call in the draw function won't index to it anyway
    strctTrial.coordinatesX(1:4,:,:,1:strctTrial.numberBlurSteps+1) = vertcat(round(linspace(strctTrial.point1(1),strctTrial.blurCorrectedScreenCoordinates(1,1),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point2(1),strctTrial.blurCorrectedScreenCoordinates(2,1),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point3(1),strctTrial.blurCorrectedScreenCoordinates(3,1),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point4(1),strctTrial.blurCorrectedScreenCoordinates(4,1),strctTrial.numberBlurSteps+1)));
    
    
    
    strctTrial.coordinatesY(1:4,:,:,1:strctTrial.numberBlurSteps+1) = vertcat(round(linspace(strctTrial.point1(2),strctTrial.blurCorrectedScreenCoordinates(1,2),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point2(2),strctTrial.blurCorrectedScreenCoordinates(2,2),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point3(2),strctTrial.blurCorrectedScreenCoordinates(3,2),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point4(2),strctTrial.blurCorrectedScreenCoordinates(4,2),strctTrial.numberBlurSteps+1)));
    
end
return;


% ------------------------------------------------------------------------------------------------------------------------
function [strctTrial] = fnPrepareMovingBarTrial(g_strctPTB, strctTrial)

global g_strctParadigm
strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.MovingBarLength.Buffer(1,:,g_strctParadigm.MovingBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.MovingBarWidth.Buffer(1,:,g_strctParadigm.MovingBarWidth.BufferIdx));
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.MovingBarNumberOfBars.Buffer(1,:,g_strctParadigm.MovingBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.MovingBarStimulusOnTime.Buffer(1,:,g_strctParadigm.MovingBarStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.MovingBarStimulusOffTime.Buffer(1,:,g_strctParadigm.MovingBarStimulusOffTime.BufferIdx);

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
%strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.MovingBarMoveDistance.Buffer(1,:,g_strctParadigm.MovingBarMoveDistance.BufferIdx));
strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.MovingBarMoveSpeed.Buffer(1,:,g_strctParadigm.MovingBarMoveSpeed.BufferIdx));


strctTrial.m_bBlur  = squeeze(g_strctParadigm.MovingBarBlur.Buffer(1,:,g_strctParadigm.MovingBarBlur.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.MovingBarBlurSteps.Buffer(1,:,g_strctParadigm.MovingBarBlurSteps.BufferIdx)));



[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
[strctTrial] = fnCycleColor(strctTrial);

strctTrial.m_iMoveDistance = (strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;
strctTrial.m_bRandomStimulusOrientation = g_strctParadigm.m_bRandomStimulusOrientation;
strctTrial.m_bCycleStimulusOrientation = g_strctParadigm.m_bCycleStimulusOrientation;
strctTrial.m_bReverseCycleStimulusOrientation = g_strctParadigm.m_bReverseCycleStimulusOrientation;
if g_strctParadigm.m_bRandomStimulusOrientation
    
    % ClockRandSeed();
    %strctTrial.m_iOrientationBin = floor(((g_strctParadigm.m_iNumOrientationBins) * rand(1,1))) + 1;
    
    strctTrial.m_iOrientationBin = randi(g_strctParadigm.m_iNumOrientationBins,[1]);
    strctTrial.m_fRotationAngle = strctTrial.m_iOrientationBin * (360/g_strctParadigm.m_iNumOrientationBins) ;
elseif g_strctParadigm.m_bCycleStimulusOrientation
    if isempty(g_strctParadigm.m_iOrientationBin)
        g_strctParadigm.m_iOrientationBin = 1;
    end
    if ~g_strctParadigm.m_bReverseCycleStimulusOrientation
        strctTrial.m_iOrientationBin = g_strctParadigm.m_iOrientationBin + 1;
        if strctTrial.m_iOrientationBin >= 21
            strctTrial.m_iOrientationBin = 1;
        end
    else
        strctTrial.m_iOrientationBin = g_strctParadigm.m_iOrientationBin - 1;
        if strctTrial.m_iOrientationBin <= 0
            strctTrial.m_iOrientationBin = 20;
        end
    end
    strctTrial.m_fRotationAngle = strctTrial.m_iOrientationBin * (360/g_strctParadigm.m_iNumOrientationBins) ;
else
    strctTrial.m_iOrientationBin = [];
    strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.MovingBarOrientation.Buffer(1,:,g_strctParadigm.MovingBarOrientation.BufferIdx));
end
g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;

if strctTrial.m_bRandomStimulusPosition
    %minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iWidth)/2;
    for iNumBars = 1 : strctTrial.m_iNumberOfBars
        % Random center points
        
        
        
        strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ randi(range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
        strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ randi(range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
        %{
		 strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
        strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
        % Try not to draw bars on top of each other
		
        if iNumBars > 2
            for tries=1:5
                if abs(min(strctTrial.location_x(1:iNumBars-1)) - strctTrial.location_x(iNumBars)) < minimum_seperation ||...
                        abs(min(strctTrial.location_y(1:iNumBars-1)) - strctTrial.location_y(iNumBars)) < minimum_seperation
                    % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                    % So we'll just try 5 times and hope for the best
                    strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
                    strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
                else
                    break;
                end
            end
        end
        %}
        strctTrial.bar_rect(iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth/2), ...
            (strctTrial.location_x(iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth/2)];
        
    end
else
    strctTrial.m_iNumberOfBars = 1;
    strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
    strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);
    strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2), ...
        (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
end


if ~strctTrial.m_bBlur
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
    if strctTrial.m_iNumberOfBars == 1
        [strctTrial.point1(1,1), strctTrial.point1(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.point2(1,1), strctTrial.point2(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.point3(1,1), strctTrial.point3(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.point4(1,1), strctTrial.point4(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    else
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            [strctTrial.point1(iNumOfBars,1), strctTrial.point1(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point2(iNumOfBars,1), strctTrial.point2(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,4),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point3(iNumOfBars,1), strctTrial.point3(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,4),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point4(iNumOfBars,1), strctTrial.point4(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.bar_starting_point(iNumOfBars,1),strctTrial.bar_starting_point(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(iNumOfBars),(strctTrial.location_y(iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.bar_ending_point(iNumOfBars,1),strctTrial.bar_ending_point(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(iNumOfBars),(strctTrial.location_y(iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            
            
            % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
        end
    end
    % Check if the trial has more than 1 frame in it, so we can plan the trial
    if strctTrial.numFrames > 1
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            % Calculate coordinates for every frame
            
            strctTrial.coordinatesX(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,1) -...
                (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point1(iNumOfBars,1)-...
                (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                ...
                round(linspace(strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)));
            strctTrial.coordinatesY(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point1(iNumOfBars,2)-(strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point2(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point2(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point3(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point3(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point4(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point4(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)));
        end
    else
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            % Only one frame, so the coordinates are static
            
            strctTrial.coordinatesX(1:4,:,iNumOfBars) = [strctTrial.point1(iNumOfBars,1), strctTrial.point2(iNumOfBars,1), strctTrial.point3(iNumOfBars,1),strctTrial.point4(iNumOfBars,1)];
            strctTrial.coordinatesY(1:4,:,iNumOfBars) = [strctTrial.point1(iNumOfBars,2), strctTrial.point2(iNumOfBars,2), strctTrial.point3(iNumOfBars,2),strctTrial.point4(iNumOfBars,2)];
        end
    end
else
    
    
    
    
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps));
    
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars,strctTrial.numberBlurSteps+1));
    [strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
    for iNumOfBars = 1:strctTrial.m_iNumberOfBars
        blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
            round(linspace(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
        
        blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,2),strctTrial.bar_rect(iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
            round(linspace(strctTrial.bar_rect(iNumOfBars,4),strctTrial.bar_rect(iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
        
        [firstBlurCoordsPoint1(1, :), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [firstBlurCoordsPoint2(1,:), firstBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [firstBlurCoordsPoint3(1,:), firstBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [firstBlurCoordsPoint4(1,:), firstBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        
        [lastBlurCoordsPoint1(1,:), lastBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [lastBlurCoordsPoint2(1,:), lastBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [lastBlurCoordsPoint3(1,:), lastBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [lastBlurCoordsPoint4(1,:), lastBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        
        
        for iBlurSteps = 1: strctTrial.numberBlurSteps+1
            strctTrial.coordinatesX(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(1,iBlurSteps),lastBlurCoordsPoint1(1,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint2(1,iBlurSteps),lastBlurCoordsPoint2(1,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint3(1,iBlurSteps),lastBlurCoordsPoint3(1,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint4(1,iBlurSteps),lastBlurCoordsPoint4(1,iBlurSteps),strctTrial.numFrames)));
            strctTrial.coordinatesY(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(2,iBlurSteps),lastBlurCoordsPoint1(2,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint2(2,iBlurSteps),lastBlurCoordsPoint2(2,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint3(2,iBlurSteps),lastBlurCoordsPoint3(2,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint4(2,iBlurSteps),lastBlurCoordsPoint4(2,iBlurSteps),strctTrial.numFrames)));
        end
        
    end
    
end



return;



% ------------------------------------------------------------------------------------------------------------------------


function [strctTrial] = fnPrepare2BarTrial(g_strctPTB, strctTrial);
global g_strctStimulusServer g_strctParadigm
strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength(1) = squeeze(g_strctParadigm.TwoBarLengthBarOne.Buffer(1,:,g_strctParadigm.TwoBarLengthBarOne.BufferIdx));
strctTrial.m_iWidth(1) = squeeze(g_strctParadigm.TwoBarWidthBarOne.Buffer(1,:,g_strctParadigm.TwoBarWidthBarOne.BufferIdx));
strctTrial.m_iLength(2) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
strctTrial.m_iWidth(2) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
strctTrial.m_iBarOneLength = strctTrial.m_iLength;
strctTrial.m_iBarOneWidth= strctTrial.m_iWidth;
strctTrial.m_iBarTwoLength = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
strctTrial.m_iBarTwoWidth = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
strctTrial.m_iNumberOfBars = 2; %squeeze(g_strctParadigm.TwoBarNumberOfBars.Buffer(1,:,g_strctParadigm.TwoBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.TwoBarStimulusOnTime.Buffer(1,:,g_strctParadigm.TwoBarStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.TwoBarStimulusOffTime.Buffer(1,:,g_strctParadigm.TwoBarStimulusOffTime.BufferIdx);
strctTrial.m_fTwoBarOnsetDelay = g_strctParadigm.TwoBarStimulusOnsetDelay.Buffer(1,:,g_strctParadigm.TwoBarStimulusOnsetDelay.BufferIdx);

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.m_iBarTwoNumFrames = round((strctTrial.m_fStimulusON_MS - strctTrial.m_fTwoBarOnsetDelay) / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.TwoBarMoveDistance.Buffer(1,:,g_strctParadigm.TwoBarMoveDistance.BufferIdx));
strctTrial.m_iMinOffset = squeeze(g_strctParadigm.TwoBarMinOffset.Buffer(1,:,g_strctParadigm.TwoBarMinOffset.BufferIdx));
strctTrial.m_iMaxOffset = squeeze(g_strctParadigm.TwoBarMaxOffset.Buffer(1,:,g_strctParadigm.TwoBarMaxOffset.BufferIdx));
strctTrial.m_bDifferentColorsForDifferentBars = g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars;

strctTrial.numberBlurSteps(1) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarOne.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarOne.BufferIdx)));
strctTrial.numberBlurSteps(2) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarTwo.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarTwo.BufferIdx)));



[strctTrial] = fnCycleColor(strctTrial);

strctTrial.m_bRandomStimulusOrientation = g_strctParadigm.m_bRandomStimulusOrientation;
if g_strctParadigm.m_bRandomStimulusOrientation
    
    % ClockRandSeed();
    %strctTrial.m_iOrientationBin = floor(((g_strctParadigm.m_iNumOrientationBins) * rand(1,1))) + 1;
    strctTrial.m_iOrientationBin(1) = randi(g_strctParadigm.m_iNumOrientationBins);
    strctTrial.m_iOrientationBin(2) = strctTrial.m_iOrientationBin(1);
    strctTrial.m_fRotationAngle(1) = strctTrial.m_iOrientationBin(1) * (360/g_strctParadigm.m_iNumOrientationBins) ;
    strctTrial.m_fRotationAngle(2) = strctTrial.m_fRotationAngle(1) ;
elseif g_strctParadigm.m_bCycleStimulusOrientation
    if isempty(g_strctParadigm.m_iOrientationBin)
        g_strctParadigm.m_iOrientationBin(1) = 1;
    end
    if ~g_strctParadigm.m_bReverseCycleStimulusOrientation
        strctTrial.m_iOrientationBin(1) = g_strctParadigm.m_iOrientationBin + 1;
        if strctTrial.m_iOrientationBin >= 21
            strctTrial.m_iOrientationBin(1) = 1;
        end
    else
        strctTrial.m_iOrientationBin = g_strctParadigm.m_iOrientationBin - 1;
        if strctTrial.m_iOrientationBin(1) <= 0
            strctTrial.m_iOrientationBin(1) = 20;
        end
    end
    strctTrial.m_iOrientationBin(2) = strctTrial.m_iOrientationBin(1);
    strctTrial.m_fRotationAngle(1) = strctTrial.m_iOrientationBin(1) * (360/g_strctParadigm.m_iNumOrientationBins) ;
    strctTrial.m_fRotationAngle(2) = strctTrial.m_fRotationAngle(1);
else
    strctTrial.m_iOrientationBin = [];
    strctTrial.m_fRotationAngle(1) = squeeze(g_strctParadigm.TwoBarOrientationBarOne.Buffer(1,:,g_strctParadigm.TwoBarOrientationBarOne.BufferIdx));
    strctTrial.m_fRotationAngle(2) = squeeze(g_strctParadigm.TwoBarOrientationBarTwo.Buffer(1,:,g_strctParadigm.TwoBarOrientationBarTwo.BufferIdx));
end
g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;



if strctTrial.m_bRandomStimulusPosition
    strctTrial.location_x(1) = g_strctParadigm.m_aiStimulusRect(1)+ randi(range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
    strctTrial.location_y(1) = g_strctParadigm.m_aiStimulusRect(2)+ randi(range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
else
    strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
    strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);
    
end

strctTrial.bar_rect(1,1:4) = [(strctTrial.location_x(1) - strctTrial.m_iLength(1)/2), (strctTrial.location_y(1)  - strctTrial.m_iWidth(1)/2), ...
    (strctTrial.location_x(1) + strctTrial.m_iLength(1)/2), (strctTrial.location_y(1) + strctTrial.m_iWidth(1)/2)];
for iNumBars = 2 : strctTrial.m_iNumberOfBars
    % Random center points
    
    strctTrial.barXOffSet(iNumBars-1) = (((randi(101)-1)/100)-.5);
    xSign = sign(strctTrial.barXOffSet(iNumBars-1));
    strctTrial.barYOffSet(iNumBars-1) = (((randi(101)-1)/100)-.5);
    ySign = sign(strctTrial.barYOffSet(iNumBars-1));
    
    strctTrial.location_x(iNumBars) = round(strctTrial.location_x(1) + (xSign * strctTrial.m_iMinOffset) + (strctTrial.barXOffSet(iNumBars-1) * range([strctTrial.m_iMaxOffset, strctTrial.m_iMinOffset])));
    strctTrial.location_y(iNumBars) = round(strctTrial.location_y(1) + (ySign * strctTrial.m_iMinOffset) + (strctTrial.barYOffSet(iNumBars-1) * range([strctTrial.m_iMaxOffset, strctTrial.m_iMinOffset])));
    %strctTrial.location_y(iNumBars) = round(strctTrial.location_y(1) + (randi(100)/100) * range([strctTrial.m_iMaxOffset, strctTrial.m_iMinOffset])));
    
    strctTrial.bar_rect(iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength(iNumBars)/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth(iNumBars)/2), ...
        (strctTrial.location_x(iNumBars) + strctTrial.m_iLength(iNumBars)/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth(iNumBars)/2)];
    
end
%{
    strctTrial.m_iNumberOfBars = 1;
    strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
    strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);
    strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2), ...
        (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
%}



% Check if the trial has more than 1 frame in it, so we can plan the trial






%[strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps));

[strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars,strctTrial.numberBlurSteps+1));
[strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
for iNumOfBars = 1:strctTrial.m_iNumberOfBars
    switch iNumOfBars
        case 1
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
            
            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,2),strctTrial.bar_rect(iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,4),strctTrial.bar_rect(iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
            
            [firstBlurCoordsPoint1(1, :), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            [firstBlurCoordsPoint2(1,:), firstBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            [firstBlurCoordsPoint3(1,:), firstBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            [firstBlurCoordsPoint4(1,:), firstBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            
            [lastBlurCoordsPoint1(1,:), lastBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            [lastBlurCoordsPoint2(1,:), lastBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            [lastBlurCoordsPoint3(1,:), lastBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            [lastBlurCoordsPoint4(1,:), lastBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(1));
            
            
            for iBlurSteps = 1: strctTrial.numberBlurSteps+1
                strctTrial.coordinatesX(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(1,iBlurSteps),lastBlurCoordsPoint1(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint2(1,iBlurSteps),lastBlurCoordsPoint2(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint3(1,iBlurSteps),lastBlurCoordsPoint3(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint4(1,iBlurSteps),lastBlurCoordsPoint4(1,iBlurSteps),strctTrial.numFrames)));
                strctTrial.coordinatesY(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(2,iBlurSteps),lastBlurCoordsPoint1(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint2(2,iBlurSteps),lastBlurCoordsPoint2(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint3(2,iBlurSteps),lastBlurCoordsPoint3(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint4(2,iBlurSteps),lastBlurCoordsPoint4(2,iBlurSteps),strctTrial.numFrames)));
            end
        otherwise
            
            
            
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
            
            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,2),strctTrial.bar_rect(iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,4),strctTrial.bar_rect(iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
            
            [firstBlurCoordsPoint1(1, :), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            [firstBlurCoordsPoint2(1,:), firstBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            [firstBlurCoordsPoint3(1,:), firstBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            [firstBlurCoordsPoint4(1,:), firstBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            
            [lastBlurCoordsPoint1(1,:), lastBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            [lastBlurCoordsPoint2(1,:), lastBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            [lastBlurCoordsPoint3(1,:), lastBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            [lastBlurCoordsPoint4(1,:), lastBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(2));
            
            
            for iBlurSteps = 1: strctTrial.numberBlurSteps+1
                strctTrial.coordinatesX(1:4,strctTrial.numFrames + 1 - strctTrial.m_iBarTwoNumFrames : strctTrial.numFrames,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(1,iBlurSteps),lastBlurCoordsPoint1(1,iBlurSteps),strctTrial.m_iBarTwoNumFrames)),...
                    round(linspace(firstBlurCoordsPoint2(1,iBlurSteps),lastBlurCoordsPoint2(1,iBlurSteps),strctTrial.m_iBarTwoNumFrames)),...
                    round(linspace(firstBlurCoordsPoint3(1,iBlurSteps),lastBlurCoordsPoint3(1,iBlurSteps),strctTrial.m_iBarTwoNumFrames)),...
                    round(linspace(firstBlurCoordsPoint4(1,iBlurSteps),lastBlurCoordsPoint4(1,iBlurSteps),strctTrial.m_iBarTwoNumFrames)));
                strctTrial.coordinatesY(1:4,strctTrial.numFrames + 1 - strctTrial.m_iBarTwoNumFrames : strctTrial.numFrames,iNumOfBars,iBlurSteps) = ...
                    vertcat(round(linspace(firstBlurCoordsPoint1(2,iBlurSteps),lastBlurCoordsPoint1(2,iBlurSteps),strctTrial.m_iBarTwoNumFrames)),...
                    round(linspace(firstBlurCoordsPoint2(2,iBlurSteps),lastBlurCoordsPoint2(2,iBlurSteps),strctTrial.m_iBarTwoNumFrames)),...
                    round(linspace(firstBlurCoordsPoint3(2,iBlurSteps),lastBlurCoordsPoint3(2,iBlurSteps),strctTrial.m_iBarTwoNumFrames)),...
                    round(linspace(firstBlurCoordsPoint4(2,iBlurSteps),lastBlurCoordsPoint4(2,iBlurSteps),strctTrial.m_iBarTwoNumFrames)));
            end
            
            
    end
    
end





return;

% ----------------------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------




function [g_strctParadigm, strctTrial] = fnPrepareRealTimeGaborTrial(g_strctParadigm, g_strctPTB, strctTrial)

% DOES NOT WORK WITH BITS ++
% as near as I can tell, enabling the alphablending necessary for the gabor code to work also screws with the
% CLUT encoding that bits ++ reads during the trial display

strctTrial.m_iFixationColor = [255 255 255];
strctTrial.numberBlurSteps = 0;
strctTrial.m_fStimulusON_MS = 0;
strctTrial.m_fStimulusOFF_MS = 0;
strctTrial.numFrames = 1; % Tells the stimulus server to update every frame
strctTrial.m_bUseStrobes = 0;
strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.GaborOrientation.Buffer(1,:,g_strctParadigm.GaborOrientation.BufferIdx));
strctTrial.m_iLength = squeeze(g_strctParadigm.GaborBarLength.Buffer(1,:,g_strctParadigm.GaborBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.GaborBarWidth.Buffer(1,:,g_strctParadigm.GaborBarWidth.BufferIdx));
%strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.NumberOfBars.Buffer(1,:,g_strctParadigm.GaborNumberOfBars.BufferIdx));


strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.GaborMoveDistance.Buffer(1,:,g_strctParadigm.GaborMoveDistance.BufferIdx));

[strctTrial] = fnCycleColor(strctTrial);
%strctTrial.m_aiStimColor = round((strctTrial.m_aiStimColor/65535)*255);
strctTrial.Clut(:,1) = round(linspace(0,65535,256));
strctTrial.Clut(:,2) = round(linspace(0,65535,256));
strctTrial.Clut(:,3) = round(linspace(0,65535,256));
strctTrial.m_afCenterScreen = [1024/2,768/2];

strctTrial.m_iSigma = squeeze(g_strctParadigm.GaborSigma.Buffer(1,:,g_strctParadigm.GaborSigma.BufferIdx));
strctTrial.m_iGaborFreq = squeeze(g_strctParadigm.GaborFreq.Buffer(1,:,g_strctParadigm.GaborFreq.BufferIdx))*1e-3;

strctTrial.m_iContrast = squeeze(g_strctParadigm.GaborContrast.Buffer(1,:,g_strctParadigm.GaborContrast.BufferIdx));
strctTrial.m_bNonsymmetric = g_strctParadigm.m_strctGaborParams.m_bNonsymmetric ;

if g_strctPTB.m_variableUpdating && strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, 'GaborPhase')
    strctTrial.m_fGaborPhase = (squeeze(g_strctParadigm.GaborPhase.Buffer(1,:,g_strctParadigm.GaborPhase.BufferIdx))); % The fnUpdateParadigmWithPTBSlider function will take care of wraparound in this case
elseif strctTrial.m_iMoveDistance > 0
    if g_strctParadigm.m_strctGaborParams.m_bReversePhaseDirection
        strctTrial.m_fGaborPhase = g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase - strctTrial.m_iMoveDistance/100;
    else
        strctTrial.m_fGaborPhase = g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase + strctTrial.m_iMoveDistance/100;
    end
    if strctTrial.m_fGaborPhase > 360 || strctTrial.m_fGaborPhase < 0
        strctTrial.m_fGaborPhase = strctTrial.m_fGaborPhase - floor(strctTrial.m_fGaborPhase/359)*359; % wrap around to other side
    end
    
    g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase = strctTrial.m_fGaborPhase;
    
    
    fnTsSetVarParadigm('GaborPhase', strctTrial.m_fGaborPhase);
    set(eval(['g_strctParadigm.m_strctControllers.m_hGaborPhaseSlider']),'value',strctTrial.m_fGaborPhase,'max', max(360,strctTrial.m_fGaborPhase), 'min',min(0,strctTrial.m_fGaborPhase));
    set(eval('g_strctParadigm.m_strctControllers.m_hGaborPhaseEdit'),'String', num2str(strctTrial.m_fGaborPhase));
    
else
    strctTrial.m_fGaborPhase = g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase;
end

% Size of support in pixels, derived from si:

strctTrial.AspectRatio = strctTrial.m_iLength/strctTrial.m_iWidth; % Not really sure what this does, but we can play with it
strctTrial.m_afDestRectangle = g_strctParadigm.m_aiStimulusRect;


if ~g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized
    strctTrial.tw = 1024;
    strctTrial.th = 768;
    fnParadigmToStimulusServer('InitializeGaborTexture', strctTrial.tw, strctTrial.th, strctTrial.m_bNonsymmetric);% [0.5, 0.5, 0.5, 0])
    %PsychImaging('PrepareConfiguration');
    %PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    g_strctParadigm.m_hGabortex = CreateProceduralGabor(g_strctPTB.m_hWindow, strctTrial.tw, strctTrial.th, strctTrial.m_bNonsymmetric);%, [0.5, 0.5, 0.5, 1]);
    
    % Screen('BlendFunction', g_strctPTB.m_hWindow, GL_SRC_ALPHA, GL_ONE);
    Screen('BlendFunction', g_strctPTB.m_hWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %[sfOLD, dfOLD, cmOLD] = Screen('BlendFunction', g_strctPTB.m_hWindow, GL_ONE, GL_ONE);
    %sfOLD
    %dfOLD
    %cmOLD
    g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 1;
end

% we're going to futz with the colors using bits++ on the stimulus server, but we need to calibrate them for local display at some point
return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------

function [g_strctParadigm, strctTrial] = fnPrepareMovingDiscTrial(g_strctParadigm, g_strctPTB, strctTrial)

strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iDiscDiameter = squeeze(g_strctParadigm.DiscDiameter.Buffer(1,:,g_strctParadigm.DiscDiameter.BufferIdx));

if g_strctParadigm.m_strctHandMappingParams.m_bPerfectCircles == 1
    %always on for now
    strctTrial.m_iLength = strctTrial.m_iDiscDiameter;
    
else
    strctTrial.m_iLength = squeeze(g_strctParadigm.BarLength.Buffer(1,:,g_strctParadigm.BarLength.BufferIdx));
    
end
strctTrial.m_iWidth = 0;


strctTrial.NumberOfDots = squeeze(g_strctParadigm.DiscNumberOfDiscs.Buffer(1,:,g_strctParadigm.DiscNumberOfDiscs.BufferIdx));


%strctTrial.m_fStimulusON_MS = g_strctParadigm.StimulusON_MS.Buffer(1,:,g_strctParadigm.StimulusON_MS.BufferIdx);



%g_strctParadigm.StimulusON_MS.Buffer(1,:,g_strctParadigm.StimulusON_MS.BufferIdx);


strctTrial.m_fStimulusOFF_MS = g_strctParadigm.DiscStimulusOffTime.Buffer(1,:,g_strctParadigm.DiscStimulusOffTime.BufferIdx);


strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.DiscMoveDistance.Buffer(1,:,g_strctParadigm.DiscMoveDistance.BufferIdx));
strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.DiscMoveSpeed.Buffer(1,:,g_strctParadigm.DiscMoveSpeed.BufferIdx));
if any(strctTrial.m_iMoveDistance) && any(strctTrial.m_iMoveSpeed)
    strctTrial.m_fStimulusON_MS = (strctTrial.m_iMoveDistance/strctTrial.m_iMoveSpeed)*1e3;
    % strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
    
    
else
    
    strctTrial.m_fStimulusON_MS = g_strctParadigm.DiscStimulusOnTime.Buffer(1,:,g_strctParadigm.DiscStimulusOnTime.BufferIdx);
    %strctTrial.m_fStimulusON_MS = g_strctPTB.g_strctStimulusServer.m_RefreshRateMS;
    %strctTrial.m_fStimulusOFF_MS = 0;
    %strctTrial.numFrames = 1;
    
end

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
if ~strctTrial.numFrames
    % Sanity check, in case speed and distance are too low
    strctTrial.numFrames = 1;
end

strctTrial.m_bBlur  = squeeze(g_strctParadigm.DiscBlur.Buffer(1,:,g_strctParadigm.DiscBlur.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.DiscBlurSteps.Buffer(1,:,g_strctParadigm.DiscBlurSteps.BufferIdx)));

[strctTrial] = fnCycleColor(strctTrial);

if g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation
    %strctTrial.m_fRotationAngle = round(19.*rand(1,1) + 1) * 18;
    strctTrial.m_iOrientationBin = randi(g_strctParadigm.m_iNumOrientationBins,[1]);
    
else
    strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.DiscOrientation.Buffer(1,:,g_strctParadigm.DiscOrientation.BufferIdx));
end


if g_strctParadigm.m_bRandomDiscStimulusPosition
    minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iDiscDiameter)/2;
    for iNumOfDots = 1 : strctTrial.NumberOfDots
        % Random center points
        
        strctTrial.m_aiStimCenter(iNumOfDots,2) = g_strctParadigm.m_aiStimulusRect(1)+ randi(range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
        strctTrial.m_aiStimCenter(iNumOfDots,2) = g_strctParadigm.m_aiStimulusRect(2)+ randi(range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
        
        %strctTrial.m_aiStimCenter(iNumOfDots,2) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
        %strctTrial.m_aiStimCenter(iNumOfDots,2) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
        
    end
else
    for iNumOfDots = 1:strctTrial.NumberOfDots
        [strctTrial.m_aiStimCenter(iNumOfDots,[1:2])] = [(g_strctParadigm.m_aiStimulusRect(1) +...
            (.5*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]))),...
            (g_strctParadigm.m_aiStimulusRect(2) +...
            (.5*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)])))];
    end
end
for iNumOfDots = 1:strctTrial.NumberOfDots
    
    
    
    [strctTrial.dot_starting_point(iNumOfDots,1),strctTrial.dot_starting_point(iNumOfDots,2)] = fnRotateAroundPoint(strctTrial.m_aiStimCenter(iNumOfDots,1),(strctTrial.m_aiStimCenter(iNumOfDots,2) -...
        strctTrial.m_iMoveDistance/2),strctTrial.m_aiStimCenter(iNumOfDots,1),strctTrial.m_aiStimCenter(iNumOfDots,2),strctTrial.m_fRotationAngle);
    
    [strctTrial.dot_ending_point(iNumOfDots,1),strctTrial.dot_ending_point(iNumOfDots,2)] = fnRotateAroundPoint(strctTrial.m_aiStimCenter(iNumOfDots,1),(strctTrial.m_aiStimCenter(iNumOfDots,2) +...
        strctTrial.m_iMoveDistance/2),strctTrial.m_aiStimCenter(iNumOfDots,1),strctTrial.m_aiStimCenter(iNumOfDots,2),strctTrial.m_fRotationAngle);
    
    strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,:) = [(strctTrial.dot_starting_point(iNumOfDots,1) - strctTrial.m_iLength/2), (strctTrial.dot_starting_point(iNumOfDots,2) - strctTrial.m_iDiscDiameter/2), ...
        (strctTrial.dot_starting_point(iNumOfDots,1) + strctTrial.m_iLength/2), (strctTrial.dot_starting_point(iNumOfDots,2) + strctTrial.m_iDiscDiameter/2)];
    
    strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,:) = [(strctTrial.dot_ending_point(iNumOfDots,1) - strctTrial.m_iLength/2), (strctTrial.dot_ending_point(iNumOfDots,2) - strctTrial.m_iDiscDiameter/2), ...
        (strctTrial.dot_ending_point(iNumOfDots,1) + strctTrial.m_iLength/2), (strctTrial.dot_ending_point(iNumOfDots,2) + strctTrial.m_iDiscDiameter/2)];
    
    strctTrial.m_aiCoordinates(1:4,:,iNumOfDots) = vertcat(round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,1),strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,1),strctTrial.numFrames)),...
        round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,2),strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,2),strctTrial.numFrames)),...
        round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,3), strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,3),strctTrial.numFrames)),...
        round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,4), strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,4),strctTrial.numFrames)));
    
end


return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------




function [g_strctParadigm, strctTrial] = fnChooseOrientation(g_strctParadigm, strctTrial)

% Picks new orientation if called by prepare trial blocks

strctTrial.OrientationID = g_strctParadigm.m_strctOrientationFunctionParams.fOrientationID;

% Random order?
if g_strctParadigm.m_strctOrientationFunctionParams.m_bRandomOrientation
    % strctTrial.OrientationID = ceil(rand*g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest);
    strctTrial.OrientationID = randi(g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest,1);
    %(360/g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest).*ceil(rand*g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest);
    strctTrial.m_bRandomOrientation = true;
elseif g_strctParadigm.m_strctOrientationFunctionParams.m_bReverseOrientationOrder
    if strctTrial.OrientationID == 1
        strctTrial.OrientationID = g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest;
    else
        strctTrial.OrientationID = strctTrial.OrientationID-1;
    end
    
else
    if strctTrial.OrientationID == g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest
        strctTrial.OrientationID = 1;
    else
        strctTrial.OrientationID = strctTrial.OrientationID + 1;
    end
end
strctTrial.m_fRotationAngle = round(strctTrial.OrientationID * 360/g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest);
g_strctParadigm.m_strctOrientationFunctionParams.fOrientationID = strctTrial.OrientationID;
g_strctParadigm.m_iTrialStrobeID = g_strctParadigm.m_strctOrientationFunctionParams.fOrientationID;
return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------


function [strctTrial] = fnCycleColor(strctTrial)
global g_strctParadigm

% General purpose color choosing function. If called during trial preparation, will parse user settings for color type, order,
% blurriness, etc, and return the completed trial.
% DKL colors based on Qasim/Romain's solver is the most dynamic.
% All settings are saved in the trial structure for online or offline analysis.

%tic
strctTrial.m_bUseBitsPlusPlus = 1;

if ~g_strctParadigm.m_bRandomColor && ~g_strctParadigm.m_bCycleColors
    strctTrial.m_bUseGaussianPulses  = 0;
    % strctTrial.m_bFlipForegroundBackground = 0;
    
end
if ~strcmp(strctTrial.m_strTrialType,'Image')
    min_distance = min((strctTrial.m_iLength/2),(strctTrial.m_iWidth/2));
    
    if strctTrial.numberBlurSteps > min_distance
        strctTrial.numberBlurSteps = floor(min_distance);
    elseif strctTrial.numberBlurSteps == 0
        strctTrial.numberBlurSteps = 1;
    elseif strctTrial.numberBlurSteps > 250
        % don't exceed the number of CLUT slots
        strctTrial.numberBlurSteps = 250;
    end
end
currentBlockStimBGColorsR = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundRed'];
currentBlockStimBGColorsG = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundGreen'];
currentBlockStimBGColorsB = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundBlue'];

currentBlockStimulusColorsR = [g_strctParadigm.m_strCurrentlySelectedBlock,'StimulusRed'];
currentBlockStimulusColorsG = [g_strctParadigm.m_strCurrentlySelectedBlock,'StimulusGreen'];
currentBlockStimulusColorsB = [g_strctParadigm.m_strCurrentlySelectedBlock,'StimulusBlue'];




strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
    squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
    squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];

strctTrial.m_afBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/255) * 65535);


%x(1,1) = [1,2]
numSaturations = numel(g_strctParadigm.m_strctCurrentSaturation);

% Prevent crash if user changed saturations between trials
if g_strctParadigm.m_iSelectedSaturationIndex > numSaturations
    g_strctParadigm.m_iSelectedSaturationIndex = numSaturations;
end
if ~iscell(g_strctParadigm.m_strctCurrentSaturation)
    g_strctParadigm.m_strctCurrentSaturation = {g_strctParadigm.m_strctCurrentSaturation};
end
if strcmp(strctTrial.m_strTrialType,'Plain Bar') && g_strctParadigm.m_bUsePlainBarPresetColors ||...
        strcmp(strctTrial.m_strTrialType,'Moving Bar') && g_strctParadigm.m_bUseMovingBarPresetColors ||...
        strcmp(strctTrial.m_strTrialType,'Moving Dots') && g_strctParadigm.m_bUseDiscPresetColors ||...
        strcmp(strctTrial.m_strTrialType,'Gabor') && g_strctParadigm.m_bUseGaborPresetColors
    
    switch strctTrial.m_strTrialType
        case 'Plain Bar'
            PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'PlainBarStimulusPresetColor');
            strctTrial.m_bUsingPresetColor = true;
        case 'Moving Bar'
            PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'MovingBarStimulusPresetColor');
            
        case 'Moving Dots'
            PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'DiscStimulusPresetColor');
            
        case 'Gabor'
            PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'GaborStimulusPresetColor');
            
    end
    
    if PresetColorIndex > size(g_strctParadigm.m_cPresetColors,1)
        PresetColorIndex = size(g_strctParadigm.m_cPresetColors,1);
    elseif PresetColorIndex <= 0
        PresetColorIndex = 1;
    end
    
    
    
    
    strctTrial.m_aiLocalStimColor = g_strctParadigm.m_cPresetColors{PresetColorIndex,1};
    strctTrial.m_afLocalBackgroundColor = g_strctParadigm.m_cPresetColors{PresetColorIndex,2};
    
    
    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor/255) * 65535);
    strctTrial.m_afBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/255) * 65535);
    
    
    
    
    
elseif g_strctParadigm.m_bUseCartesianCoordinates
    strctTrial.m_bUseCartesianCoordinates = g_strctParadigm.m_bUseCartesianCoordinates;
    if ~g_strctParadigm.m_bCycleColors && ~g_strctParadigm.m_bRandomColor
        strctTrial.m_bUseBitsPlusPlus = 1;
        strctTrial.m_aiCLUT = zeros(256,3);
        if g_strctParadigm.m_bUseLUVCoordinates
            
            XYZ2LMS_mat=[% transform xyz to lms
                0.2420  0.8526 -0.0445
                -0.3896  1.1601  0.0853
                0.0034 -0.0018  0.5643];
            M=calculate_matrix_M();
            inv_M=inv(M);
            
            XCoord = squeeze(g_strctParadigm.CartesianXCoord.Buffer(1,:,g_strctParadigm.CartesianXCoord.BufferIdx));
            YCoord = squeeze(g_strctParadigm.CartesianYCoord.Buffer(1,:,g_strctParadigm.CartesianYCoord.BufferIdx));
            ZCoord = squeeze(g_strctParadigm.CartesianZCoord.Buffer(1,:,g_strctParadigm.CartesianZCoord.BufferIdx));
            circ = [.2904,.3724];
            circRad = .1694;
            x_diff =((XCoord/1000)-1) * circRad*10;
            y_diff =((YCoord/1000)-1) * circRad*10;
            %z_diff =((ZCoord/1000)-1) * circRad;
            %xyz=luv2xyz([(ZCoord/1000), circ(1) + x_diff, circ(2) + y_diff],'D65/2');
            xyz=luv2xyz([(ZCoord/2000), (XCoord/1000)-1, (YCoord/1000)-1],'D65/2');
            xyz
            lms=XYZ2LMS_mat*xyz';
            rgb = lms
            %{
			%xyz=luvp2xyz([(ZCoord/100), circ(1) + x_diff, circ(2) + y_diff],'D65/2');
			%xyz=luv2xyz([(ZCoord/200), (XCoord/1000)-1, (YCoord/1000)-1],'D65/2');
			XCoord = xyz(1);
			YCoord = xyz(2);
			ZCoord = xyz(3);
            %}
            XCoord = xyz(1);
            ZCoord = xyz(2);
            YCoord = xyz(3);
            %[rgb] = ldrgyv2rgb(ZCoord, XCoord, YCoord);
        else
            YCoord = squeeze(g_strctParadigm.CartesianYCoord.Buffer(1,:,g_strctParadigm.CartesianYCoord.BufferIdx));
            XCoord = squeeze(g_strctParadigm.CartesianXCoord.Buffer(1,:,g_strctParadigm.CartesianXCoord.BufferIdx));
            ZCoord = squeeze(g_strctParadigm.CartesianZCoord.Buffer(1,:,g_strctParadigm.CartesianZCoord.BufferIdx));
            
            [rgb] = ldrgyv2rgb((ZCoord/1000), (XCoord/1000), (YCoord/1000));
            %[rgb] = ldrgyv2rgb(ld,rg,yv)
        end
        
        
        
        if any(rgb > 1) || any(rgb < 0)
            fnParadigmToKofikoComm('DisplayMessage', 'Colors outside of range, mapped to nearest real color!!')
            rgb(rgb >= 1) = 1;
            rgb(rgb <= 0) = 0;
            
            
        end
        
        
        strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(round(rgb(1) * 65535)+1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(round(rgb(2) * 65535)+1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(round(rgb(3) * 65535)+1)];
        strctTrial.m_aiLocalStimColor =  round((strctTrial.m_aiStimColor/65535) * 255);
        
        if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
            strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
            
            
            
        else
            % strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
            
            
            
            temp = ldrgyv2rgb(0,0,0);
            
            strctTrial.m_afBackgroundColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(temp(1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(temp(2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(temp(3) * 65535) + 1)];
        end
        strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535) * 255);
        % g_strctParadigm.m_strctConversionMatrices
        
        
        strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
        strctTrial.m_aiCLUT(3,:) = strctTrial.m_aiStimColor;
        strctTrial.m_aiCLUT(256,:) = ones(1,3) * 65535;
    else
        %sprintf('block 1 %f', toc)
        if g_strctParadigm.m_bRandomColor
            strctTrial.m_bRandomColor = true;
            % g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = ceil(rand(1,1) * round(squeeze(g_strctParadigm.DKLAzimuthSteps.Buffer(1,:,g_strctParadigm.DKLAzimuthSteps.BufferIdx))));
            g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = randi(squeeze(g_strctParadigm.DKLAzimuthSteps.Buffer(1,:,g_strctParadigm.DKLAzimuthSteps.BufferIdx)),1);%
            if g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID < 1
                g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = 1;
            end
            
        elseif ~g_strctParadigm.m_bReverseColorOrder
            strctTrial.m_bReverseColorOrder = g_strctParadigm.m_bReverseColorOrder;
            g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID + 1;
        elseif g_strctParadigm.m_bReverseColorOrder
            strctTrial.m_bReverseColorOrder = g_strctParadigm.m_bReverseColorOrder;
            g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID - 1;
        end
        
        if g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID > squeeze(g_strctParadigm.DKLAzimuthSteps.Buffer(1,:,g_strctParadigm.DKLAzimuthSteps.BufferIdx))
            g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = 1;
        elseif g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID < 1
            
            g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = round(squeeze(g_strctParadigm.DKLAzimuthSteps.Buffer(1,:,g_strctParadigm.DKLAzimuthSteps.BufferIdx)));
            
        end
        strctTrial.m_iCurrentlySelectedDKLCoordinateID = g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID ;
        strctTrial.dklRadius = squeeze(g_strctParadigm.DKLRadius.Buffer(1,:,g_strctParadigm.DKLRadius.BufferIdx));
        strctTrial.dklElevation = squeeze(g_strctParadigm.DKLElevation.Buffer(1,:,g_strctParadigm.DKLElevation.BufferIdx));
        strctTrial.dklAzimuthSteps = squeeze(g_strctParadigm.DKLAzimuthSteps.Buffer(1,:,g_strctParadigm.DKLAzimuthSteps.BufferIdx));
        if strctTrial.dklAzimuthSteps < 1
            strctTrial.dklAzimuthSteps = 1;
        end
        
        strctTrial.DKLElevationSteps = squeeze(g_strctParadigm.DKLElevationSteps.Buffer(1,:,g_strctParadigm.DKLElevationSteps.BufferIdx));
        if strctTrial.DKLElevationSteps > 1
            %strctTrial.DKLElevationSteps
            
        end
        
        strctTrial.ai_dklAzimuthSteps = 0:360/strctTrial.dklAzimuthSteps:359.99;
        strctTrial.dklElevationSteps = 0:360/strctTrial.dklAzimuthSteps:359.99;
        %[strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate, ] = sph2cart(deg2rad(strctTrial.ai_dklAzimuthSteps),(strctTrial.dklElevation/100)-1,strctTrial.dklRadius/100);
        % sin theta plus pi/2
        
        if strctTrial.m_bUseGaussianPulses
            %[strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate, ] = sph2cart(deg2rad(strctTrial.ai_dklAzimuthSteps),deg2rad(strctTrial.dklElevationSteps),strctTrial.dklRadius/100);
            
            [strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate ] = sph2cart(deg2rad(strctTrial.ai_dklAzimuthSteps(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID)),...
                ones(1,strctTrial.numFrames)*(strctTrial.dklElevation/100),sin(linspace(0,pi,strctTrial.numFrames))*strctTrial.dklRadius/100);
            
        else
            %[strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate, ] = sph2cart(deg2rad(strctTrial.ai_dklAzimuthSteps),deg2rad(strctTrial.dklElevation),strctTrial.dklRadius/100);
            [strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate ] = sph2cart(deg2rad(strctTrial.ai_dklAzimuthSteps),(strctTrial.dklElevation/100),strctTrial.dklRadius/100);
            strctTrial.m_iZCoordinate = (strctTrial.dklElevation/100);
        end
        
        %[strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate, ] = sph2cart(0,0,sin(linspace(0,2*pi,60)+.5));
        %[strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate, ] = sph2cart(zeros(1,60*5), zeros(1,60*5), max(0,sin(linspace(0,pi*2,60*5))*strctTrial.dklRadius/100));
        %[strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate, ] = sph2cart(zeros(1,60*5), zeros(1,60*5), max(0,sin(linspace(0,pi*2,60*5))*strctTrial.dklRadius/100));
        
        %{
        for i = 1:numel(strctTrial.m_iXCoordinate)
            if numel(strctTrial.m_iZCoordinate) == numel(strctTrial.m_iXCoordinate)
                FullCycleRGB(i,:) = ldrgyv2rgb(strctTrial.m_iZCoordinate(i),strctTrial.m_iXCoordinate(i),strctTrial.m_iYCoordinate(i));
            else
                FullCycleRGB(i,:) = ldrgyv2rgb(strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate(i),strctTrial.m_iYCoordinate(i));
            end
            %theta = deg2rad(40);
            
            %FullCycleRGB(i,:) = ldrgyv2rgb(sin(theta),cos(theta),0);
            %FullCycleRGB(i,:) = ldrgyv2rgb(z,sin(x(i)),cos(y(i)));
        end
        %}
        
        if numel(strctTrial.m_iZCoordinate) == numel(strctTrial.m_iXCoordinate)
            FullCycleRGB = ldrgyv2rgb(strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate,strctTrial.m_iYCoordinate)';
        else
            FullCycleRGB = ldrgyv2rgb(ones(1,numel(strctTrial.m_iXCoordinate)) * strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate,strctTrial.m_iYCoordinate)';
        end
        
        if size(FullCycleRGB,2) < 3
            FullCycleRGB = FullCycleRGB';
            
        end
        if any(any(FullCycleRGB > 1)) || any(any(FullCycleRGB < 0));
            FullCycleRGB(FullCycleRGB >= 1) = 1;
            FullCycleRGB(FullCycleRGB <= 0) = 0;
            fnParadigmToKofikoComm('DisplayMessage', 'Colors outside of range, mapped to nearest real color!!')
        end
        %sprintf('block 2 %f', toc)
        
        if strctTrial.m_bUseGaussianPulses
            for iFrames = 1:strctTrial.numFrames
                strctTrial.m_aiStimColor(iFrames,:) = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(FullCycleRGB(iFrames, 1) * 65535) + 1),...
                    g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(FullCycleRGB(iFrames, 2) * 65535) + 1),...
                    g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(FullCycleRGB(iFrames, 3) * 65535) + 1)];
                strctTrial.m_aiLocalStimColor(iFrames,:) = round((strctTrial.m_aiStimColor(iFrames,:)/65535) * 255);
                
                
            end
            % strctTrial.m_iXCoordinate = strctTrial.m_iXCoordinate(round(strctTrial.numFrames/2));
            %strctTrial.m_iYCoordinate = strctTrial.m_iYCoordinate(round(strctTrial.numFrames/2));
            %strctTrial.m_iZCoordinate = strctTrial.m_iZCoordinate(round(strctTrial.numFrames/2));
        else
            
            strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 3) * 65535) + 1)];
            strctTrial.m_aiLocalStimColor = round((strctTrial.m_aiStimColor/65535) * 255);
            %strctTrial.m_iXCoordinate = strctTrial.m_iXCoordinate(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID);
            %strctTrial.m_iYCoordinate = strctTrial.m_iYCoordinate(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID);
            %strctTrial.m_iZCoordinate = strctTrial.m_iZCoordinate;
        end
        if g_strctParadigm.m_bPhaseShiftOffset
            strctTrial.m_bShiftOffsetTrial = true;
            strctTrial.m_iShiftOffset = squeeze(g_strctParadigm.ShiftOffsetDegrees.Buffer(1,:,g_strctParadigm.ShiftOffsetDegrees.BufferIdx));
            [strctTrial.m_iXOffsetCoordinate, strctTrial.m_iYOffsetCoordinate, strctTrial.m_iZOffsetCoordinate ] =...
                sph2cart(deg2rad(strctTrial.m_iShiftOffset)+...
                deg2rad(strctTrial.ai_dklAzimuthSteps(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID)),...
                (strctTrial.dklElevation/100)-1, strctTrial.dklRadius/100);
            
            shiftOffsetRGB = ldrgyv2rgb( strctTrial.m_iZOffsetCoordinate,strctTrial.m_iXOffsetCoordinate,strctTrial.m_iYOffsetCoordinate);
            
            if any(any(shiftOffsetRGB > 1)) || any(any(shiftOffsetRGB < 0));
                shiftOffsetRGB(shiftOffsetRGB >= 1) = 1;
                shiftOffsetRGB(shiftOffsetRGB <= 0) = 0;
                fnParadigmToKofikoComm('DisplayMessage', 'Colors outside of range, mapped to nearest real color!!')
            end
            
            %shiftOffsetRGB(shiftOffsetRGB >= 1) = 1;
            % shiftOffsetRGB(shiftOffsetRGB <= 0) = 0;
            %g_strctParadigm.m_iCurrentlySelectedDKLOffsetCoordinateID = round(rem((g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID+ (dklAzimuthSteps/4)),dklAzimuthSteps ));
            strctTrial.m_afBackgroundColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(shiftOffsetRGB(1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(shiftOffsetRGB(2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(shiftOffsetRGB(3) * 65535) + 1)];
            
        else
            if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
                strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
                
                
                
                
                
            else
                
                strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
                
            end
            
            
        end
        %sprintf('block 3 %f', toc)
        strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535) * 255);
        % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
        %{
        strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
        if strctTrial.m_bFlipForegroundBackground
            % tempColor = strctTrial.m_aiStimColor ;
            tempLocalColor = strctTrial.m_aiLocalStimColor;
            tempBackgroundColor = strctTrial.m_afBackgroundColor;
            strctTrial.m_afBackgroundColor = strctTrial.m_aiStimColor ;
            strctTrial.m_afLocalBackgroundColor = tempLocalColor;
            
            strctTrial.m_aiStimColor = tempBackgroundColor;
            strctTrial.m_aiLocalStimColor = round((tempBackgroundColor/65535)*255);
            
            
        else
            
        end
        %}
    end
elseif g_strctParadigm.m_bCycleColors || g_strctParadigm.m_bRandomColor
    if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
        strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
        %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
        
        
        
    else
        strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    end
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    strctTrial.m_bUseBitsPlusPlus = 1;
    if g_strctParadigm.m_bRandomColor
        strctTrial.m_bRandomColor = true;
        % g_strctParadigm.m_iSelectedSaturationIndex = ceil(rand(1) * numSaturations);
        g_strctParadigm.m_iSelectedSaturationIndex = randi(numSaturations,1);% * numSaturations);
        
        % g_strctParadigm.m_iSelectedColorIndex = ceil(rand(1)* size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1));
        g_strctParadigm.m_iSelectedColorIndex = randi(size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1),1);%* size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1));
        
        strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_aiStimXYZ = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.XYZ(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex;
        strctTrial.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex;
        strctTrial.m_strSelectedSaturationName = g_strctParadigm.m_strctCurrentSaturationLookup{g_strctParadigm.m_iSelectedSaturationIndex};
        
    elseif ~g_strctParadigm.m_bReverseColorOrder
        g_strctParadigm.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex + 1;
        if g_strctParadigm.m_iSelectedColorIndex > size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1)
            
            g_strctParadigm.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex + 1;
            if g_strctParadigm.m_iSelectedSaturationIndex > numSaturations
                
                g_strctParadigm.m_iSelectedSaturationIndex = 1;
            end
            g_strctParadigm.m_iSelectedColorIndex = 1;
            
            
        end
        strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_aiStimXYZ = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.XYZ(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex;
        strctTrial.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex;
        strctTrial.m_strSelectedSaturationName = g_strctParadigm.m_strctCurrentSaturationLookup{g_strctParadigm.m_iSelectedSaturationIndex};
        
        
    elseif g_strctParadigm.m_bReverseColorOrder
        g_strctParadigm.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex - 1;
        
        if g_strctParadigm.m_iSelectedColorIndex < 1
            g_strctParadigm.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex - 1;
            if g_strctParadigm.m_iSelectedSaturationIndex < 1
                
                g_strctParadigm.m_iSelectedSaturationIndex = numSaturations;
            end
            g_strctParadigm.m_iSelectedColorIndex = size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1);
            
            
        end
        strctTrial.m_bReverseColorOrder = true;
        strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_aiStimXYZ = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.XYZ(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex;
        strctTrial.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex;
        strctTrial.m_strSelectedSaturationName = g_strctParadigm.m_strctCurrentSaturationLookup{g_strctParadigm.m_iSelectedColorIndex};
    end
    
    if strctTrial.m_bUseGaussianPulses && ~strcmp(strctTrial.m_strSelectedSaturationName,'gray')
        
        [strctTrial.m_iXCoordinate, strctTrial.m_iYCoordinate, strctTrial.m_iZCoordinate ] = ...
            sph2cart(g_strctParadigm.m_strctCurrentSaturation{strctTrial.m_iSelectedSaturationIndex}.azimuthSteps(strctTrial.m_iSelectedColorIndex),...
            ones(1,strctTrial.numFrames)* ...
            (g_strctParadigm.m_strctCurrentSaturation{strctTrial.m_iSelectedSaturationIndex}.Elevation), ...
            sin(linspace(0,pi,strctTrial.numFrames))*g_strctParadigm.m_strctCurrentSaturation{strctTrial.m_iSelectedSaturationIndex}.Radius);
        
        if numel(strctTrial.m_iZCoordinate) == numel(strctTrial.m_iXCoordinate)
            FullCycleRGB = ldrgyv2rgb(strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate,strctTrial.m_iYCoordinate)';
        else
            FullCycleRGB = ldrgyv2rgb(ones(1,numel(strctTrial.m_iXCoordinate)) * strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate,strctTrial.m_iYCoordinate)';
        end
        
        if size(FullCycleRGB,2) < 3
            FullCycleRGB = FullCycleRGB';
            
        end
        if any(any(FullCycleRGB > 1)) || any(any(FullCycleRGB < 0));
            FullCycleRGB(FullCycleRGB >= 1) = 1;
            FullCycleRGB(FullCycleRGB <= 0) = 0;
            fnParadigmToKofikoComm('DisplayMessage', 'Colors outside of range, mapped to nearest real color!!')
        end
        
        for iFrames = 1:strctTrial.numFrames
            strctTrial.m_aiStimColor(iFrames,:) = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(FullCycleRGB(iFrames, 1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(FullCycleRGB(iFrames, 2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(FullCycleRGB(iFrames, 3) * 65535) + 1)];
            strctTrial.m_aiLocalStimColor(iFrames,:) = round((strctTrial.m_aiStimColor(iFrames,:)/65535) * 255);
            
            %strctTrial.m_aiLocalStimColor = round((strctTrial.m_aiStimColor/65535)*255);
        end
    else
        strctTrial.m_bUseGaussianPulses = 0;
        strctTrial.m_aiLocalStimColor = round((strctTrial.m_aiStimColor/65535)*255);
        
    end
    
    
    
    
    
elseif strctTrial.m_bUseBitsPlusPlus
    
    strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.(currentBlockStimulusColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimulusColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimulusColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsB).BufferIdx))];
    
    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor /255)*65535);
    
else
    
    strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.MovingBarStimulusRed.Buffer(1,:,g_strctParadigm.MovingBarStimulusRed.BufferIdx)), ...
        squeeze(g_strctParadigm.MovingBarStimulusGreen.Buffer(1,:,g_strctParadigm.MovingBarStimulusGreen.BufferIdx)),...
        squeeze(g_strctParadigm.MovingBarStimulusBlue.Buffer(1,:,g_strctParadigm.MovingBarStimulusBlue.BufferIdx))];
    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor/255)*65535);
end


if strctTrial.m_bFlipForegroundBackground
    %strctTrial.m_bFlipForegroundBackgroundMovingBar = g_strctParadigm.m_bFlipForegroundBackgroundMovingBar;
    stimcolortemp = strctTrial.m_aiStimColor;
    strctTrial.m_aiStimColor = strctTrial.m_afBackgroundColor;
    strctTrial.m_aiLocalStimColor = round((strctTrial.m_aiStimColor/65535)*255);
    strctTrial.m_afBackgroundColor = stimcolortemp;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    strctTrial.m_bFlipForegroundBackground = 1;
    %strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
    %strctTrial.m_aiStimxyY = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.xyY(g_strctParadigm.m_iSelectedColorIndex,:);
end

%if strctTrial.m_bUseBitsPlusPlus
if ~strcmp(strctTrial.m_strTrialType,'Image') && strctTrial.numberBlurSteps > 0
    strctTrial.m_aiCLUT = zeros(256,3,strctTrial.numFrames);
    if strctTrial.m_bUseGaussianPulses && size(strctTrial.m_aiStimColor,1) == strctTrial.numFrames
        
        for iFrames = 1:strctTrial.numFrames
            
            strctTrial.m_aiCLUT(2,:,iFrames) = strctTrial.m_afBackgroundColor;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,1,iFrames) = round(linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(iFrames,1),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,2,iFrames) = round(linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(iFrames,2),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,3,iFrames) = round(linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(iFrames,3),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(256,:,iFrames) = deal(65535);
        end
    elseif strctTrial.m_bUseGaussianPulses && strctTrial.m_bFlipForegroundBackground && size(strctTrial.m_afBackgroundColor,1) == strctTrial.numFrames
        for iFrames = 1:strctTrial.numFrames
            
            strctTrial.m_aiCLUT(2,:,iFrames) = strctTrial.m_afBackgroundColor(iFrames,:);
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,1,iFrames) = round(linspace(strctTrial.m_afBackgroundColor(iFrames,1),strctTrial.m_aiStimColor(1),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,2,iFrames) = round(linspace(strctTrial.m_afBackgroundColor(iFrames,2),strctTrial.m_aiStimColor(2),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,3,iFrames) = round(linspace(strctTrial.m_afBackgroundColor(iFrames,3),strctTrial.m_aiStimColor(3),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(256,:) = deal(65535);
        end
        
        
    else
        
        strctTrial.m_aiCLUT = zeros(256,3);
        strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
        strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,1) = round(linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(1),strctTrial.numberBlurSteps)) ;
        strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,2) = round(linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(2),strctTrial.numberBlurSteps)) ;
        strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,3) = round(linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(3),strctTrial.numberBlurSteps)) ;
        strctTrial.m_aiCLUT(256,:) = deal(65535);
    end
    
elseif strcmp(strctTrial.m_strTrialType,'Image') && g_strctParadigm.m_bCycleColors || g_strctParadigm.m_bRandomColor
     
    strctTrial.m_aiUncorrectedColorValues =  FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID,:);
    strctTrial.m_aiUncorrectedCLUT(1,:) = linspace(0,strctTrial.m_aiUncorrectedColorValues(1),248) ;
    strctTrial.m_aiUncorrectedCLUT(2,:) = linspace(0,strctTrial.m_aiUncorrectedColorValues(2),248) ;
    strctTrial.m_aiUncorrectedCLUT(3,:) = linspace(0,strctTrial.m_aiUncorrectedColorValues(3),248) ;
    
    strctTrial.m_aiCLUT(3:250,1) = g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(strctTrial.m_aiUncorrectedCLUT(1,:)*65535)+1);
    strctTrial.m_aiCLUT(3:250,2) = g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(strctTrial.m_aiUncorrectedCLUT(2,:)*65535)+1);
    strctTrial.m_aiCLUT(3:250,3) = g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(strctTrial.m_aiUncorrectedCLUT(3,:)*65535)+1);
    %{
 strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 3) * 65535) + 1)];
    %}
    %strctTrial.m_aiCLUT = zeros(256,3);
    %strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
    
    %strctTrial.m_aiCLUT(3:250,1) = round(linspace(0,strctTrial.m_aiStimColor(1),248)) ;
    %strctTrial.m_aiCLUT(3:250,2) = round(linspace(0,strctTrial.m_aiStimColor(2),248)) ;
    %strctTrial.m_aiCLUT(3:250,3) = round(linspace(0,strctTrial.m_aiStimColor(3),248)) ;
    
    strctTrial.m_aiCLUT(256,:) = deal(65535);
    
else
    strctTrial.m_aiCLUT = zeros(256,3);
    strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(3,:) = strctTrial.m_aiStimColor;
    strctTrial.m_aiCLUT(256,:) = deal(65535);
    
end
strctTrial.m_aiLocalBlurStepHolder = zeros(3,strctTrial.numberBlurSteps,strctTrial.numFrames);
strctTrial.m_aiBlurStepHolder = zeros(3,strctTrial.numberBlurSteps,strctTrial.numFrames);
if strctTrial.m_bUseGaussianPulses && size(strctTrial.m_aiStimColor,1) == strctTrial.numFrames
    for iFrames = 1:strctTrial.numFrames
        
        strctTrial.m_aiLocalBlurStepHolder(1,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(1),strctTrial.m_aiLocalStimColor(iFrames,1),strctTrial.numberBlurSteps));
        strctTrial.m_aiLocalBlurStepHolder(2,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(2),strctTrial.m_aiLocalStimColor(iFrames,2),strctTrial.numberBlurSteps));
        strctTrial.m_aiLocalBlurStepHolder(3,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(3),strctTrial.m_aiLocalStimColor(iFrames,3),strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(1,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(2,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(3,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
    end
    
elseif strctTrial.m_bUseGaussianPulses && size(strctTrial.m_afLocalBackgroundColor,1) == strctTrial.numFrames
    
    for iFrames = 1:strctTrial.numFrames
        
        strctTrial.m_aiLocalBlurStepHolder(1,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(iFrames,1),strctTrial.m_aiLocalStimColor(1),strctTrial.numberBlurSteps));
        strctTrial.m_aiLocalBlurStepHolder(2,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(iFrames,2),strctTrial.m_aiLocalStimColor(2),strctTrial.numberBlurSteps));
        strctTrial.m_aiLocalBlurStepHolder(3,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(iFrames,3),strctTrial.m_aiLocalStimColor(3),strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(1,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(2,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(3,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
    end
    
    
else
    for iFrames = 1:strctTrial.numFrames
        strctTrial.m_aiLocalBlurStepHolder(1,:,iFrames) = deal(round(linspace(strctTrial.m_afLocalBackgroundColor(1),strctTrial.m_aiLocalStimColor(1),strctTrial.numberBlurSteps)));
        strctTrial.m_aiLocalBlurStepHolder(2,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(2),strctTrial.m_aiLocalStimColor(2),strctTrial.numberBlurSteps));
        strctTrial.m_aiLocalBlurStepHolder(3,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(3),strctTrial.m_aiLocalStimColor(3),strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(1,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(2,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(3,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
    end
end
%sprintf('block 4 %f', toc)
return;

% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------



function [strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial)
global g_strctStimulusServer g_strctParadigm

% Check for user specified variable settings. Parse variable settings if they exist, and replace
% default value if variable setting corresponds to a setting we actually want to change. Width, height, speed
% implemented currently. Add new settings in the switch below.

trialLength = (strctTrial.m_fStimulusON_MS + strctTrial.m_fStimulusOFF_MS)/1000;
if trialLength == 0
    trialLength =  g_strctStimulusServer.m_fRefreshRateMS/1000;
    
end
TestObjects = size(strctTrial.m_acCurrentlyVariableFields,1);
if any(TestObjects)
    strctTrial.m_bVariableTestObject = true;
    for iTestObjects = 1:TestObjects
        testRange = (strctTrial.m_acCurrentlyVariableFields{iTestObjects,6}*strctTrial.m_acCurrentlyVariableFields{iTestObjects,2})*4;
        fullCycleTimeS = 1/strctTrial.m_acCurrentlyVariableFields{iTestObjects,3};
        
        %for iTestObjects = 1:TestObjects
        if strctTrial.m_acCurrentlyVariableFields{iTestObjects,7}
            newVal = ((randi(1000)/1000) * (testRange * .5)) + (strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} - (testRange * .25));
        else
            changeBy = strctTrial.m_acCurrentlyVariableFields{iTestObjects,5} * ...
                (testRange / (fullCycleTimeS / (g_strctStimulusServer.m_fRefreshRateMS/1000))) * ...
                (trialLength / (g_strctStimulusServer.m_fRefreshRateMS/1000));
            
            newVal = strctTrial.m_acCurrentlyVariableFields{iTestObjects,4} + changeBy;
        end
        
        
        if newVal <= strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2} + strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} && ...
                newVal >= max(1,strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} - strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2})
            
            
            strctTrial.m_acCurrentlyVariableFields{iTestObjects,4} = newVal;
            
            
            
        elseif  newVal > strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2} + strctTrial.m_acCurrentlyVariableFields{iTestObjects,6}
            
            g_strctParadigm.m_acCurrentlyVariableFields{iTestObjects,5} = -g_strctParadigm.m_acCurrentlyVariableFields{iTestObjects,5};
            
            
            newVal = (strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2} + strctTrial.m_acCurrentlyVariableFields{iTestObjects,6}) - ...
                rem(newVal, strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2} + strctTrial.m_acCurrentlyVariableFields{iTestObjects,6}) ;
            
            
            %abs(strctTrial.m_acCurrentlyVariableFields{iTestObjects,4} - (strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
            %strctTrial.m_acCurrentlyVariableFields{iTestObjects,2} + strctTrial.m_acCurrentlyVariableFields{iTestObjects,6})))
            
            
        elseif  newVal < max(1,strctTrial.m_acCurrentlyVariableFields{iTestObjects,6}  - ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2})
            g_strctParadigm.m_acCurrentlyVariableFields{iTestObjects,5} = -g_strctParadigm.m_acCurrentlyVariableFields{iTestObjects,5};
            
            bottomCap = max(1,strctTrial.m_acCurrentlyVariableFields{iTestObjects,6}  - ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
                strctTrial.m_acCurrentlyVariableFields{iTestObjects,2}) ;
            if newVal == 0
                newVal = 1e-4;
                % no divide by zero plz
                
            end
            newVal = bottomCap + rem(bottomCap,newVal) ;
            
            
            
            %newVal = strctTrial.m_acCurrentlyVariableFields{iTestObjects,6} * ...
            %strctTrial.m_acCurrentlyVariableFields{iTestObjects,2};
            
            
        end
        %{
			if isinf(newVal) || isnan(newVal)
				assert(error)
			end
        %}
        g_strctParadigm.m_acCurrentlyVariableFields{iTestObjects,4} = newVal;
        
        
        switch strctTrial.m_acCurrentlyVariableFields{iTestObjects,1}
            case {'PlainBarLength', 'MovingBarLength'}
                strctTrial.m_iLength = round(newVal);
                
            case {'PlainBarWidth', 'MovingBarWidth'}
                strctTrial.m_iWidth = round(newVal);
                
            case {'PlainBarMoveSpeed', 'MovingBarMoveSpeed'}
                strctTrial.m_iMoveSpeed = round(newVal);
                
                
                
        end
        %end
    end
    
end



return;


