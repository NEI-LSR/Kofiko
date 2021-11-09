function strctTrial = fnNTlabPrepareTrial()
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
    case 'Images'
        g_strctParadigm.m_strTrialType = 'Image';
        
    case 'Movies'
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

tmpstrctTrial.m_iNumberOfBars = 2;


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
            g_strctParadigm.m_strCurrentlySelectedBlock = 'PlainBar';
        case 'Moving Bar'
            [strctTrial.trial] = fnPrepareMovingBarTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'MovingBar';
        case 'Dual Stim'
            [strctTrial.trial] = fnPrepareDualstimTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'Dualstim';
        case 'Fivedot'
            [strctTrial.trial] = fnPrepareFivedotTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'Fivedot';
        case 'CI Handmapper'
            [strctTrial.trial] = fnPrepareCIHandmapperTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'CIHandmapper';
        case 'Ground Truth'
            [strctTrial.trial] = fnPrepareGroundtruthTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'Groundtruth';
        case 'Dense Noise'
            [strctTrial.trial] = fnPrepareDensenoiseTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'Densenoise';
        case 'OneD Noise'
            [strctTrial.trial] = fnPrepareOneDnoiseTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'OneDnoise';
            
        case 'Disc Probe'
            [strctTrial.trial] = fnPrepareDiscProbeTrial(g_strctPTB, tmpstrctTrial);
            g_strctParadigm.m_strCurrentlySelectedBlock = 'DiscProbe';
            
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
        case 'Many Bar'
            [strctTrial.trial] = fnPrepareManyBarTrial(g_strctPTB, tmpstrctTrial);
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



%[strctTrial.m_iMovieBlockIndex, g_strctParadigm.m_strctMovieStim.m_iSelectedMovieBlock] = deal(g_strctParadigm.m_iCurrentBlockIndexInOrderList);
[strctTrial.m_iMovieBlockIndex, g_strctParadigm.m_strctMovieStim.m_iSelectedMovieBlock] = deal(g_strctParadigm.m_iCurrentlyPlayingMovieList);

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
g_strctParadigm.m_strctMovieStim.m_iDisplayCount(iSelectedStimulus) = g_strctParadigm.m_strctMovieStim.m_iDisplayCount(iSelectedStimulus) + 1;
if g_strctParadigm.m_strctMovieStim.m_bContinueInMovieListWhenComplete && sum(g_strctParadigm.m_strctMovieStim.m_iDisplayCount) >= g_strctParadigm.m_strctMovieStim.m_iNumMoviesInThisBlock
    feval(g_strctParadigm.m_strCallbacks,'CycleToNextMovieList');
    
end
if g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly
    %disp('loading movie')
    strctTrial.m_bLoadOnTheFly = true;
    strctTrial.m_strMovieFilePath = g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths{iSelectedStimulus};
    strctTrial.m_strStimServerMovieFilePath = g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths{iSelectedStimulus};
    strctTrial.m_strStimServerMovieFilePath(1) = 'C';
    fnParadigmToStimulusServer('PreloadMovie',strctTrial.m_strStimServerMovieFilePath);
    %Screen('OpenMovie', g_strctPTB.m_hWindow, g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths{iSelectedStimulus},1)
    [strctTrial.hLocalMovieHandle, strctTrial.afMovieLengthSec, strctTrial.fFPS, strctTrial.iWidth, strctTrial.iHeight, strctTrial.iCount, strctTrial.fAspectRatio] = ...
        Screen('OpenMovie', g_strctPTB.m_hWindow, g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths{iSelectedStimulus});
    strctTrial.abIsMovie = true;
    strctTrial.a2iTextureSize = [strctTrial.iWidth, ...;
        strctTrial.iHeight];
    
    %strctTrial.a2iTextureSize = [1024, 768];
    % strctTrial.numFrames = 30;
    % strctTrial.afMovieLengthSec	= 500;
    %strctTrial.afMovieLengthSec	= strctTrial.fDuration;
    strctTrial.m_fStimulusON_MS = strctTrial.afMovieLengthSec*1e3;
    % strctTrial.m_fStimulusON_MS = 500;
    strctTrial.m_fStimulusOFF_MS = fnTsGetVar('g_strctParadigm' ,'MovieStimulusOffTime');
    Screen('CloseMovie',strctTrial.hLocalMovieHandle)
    strctTrial.fDuration =  (strctTrial.m_fStimulusON_MS +strctTrial.m_fStimulusOFF_MS)/1e3
    strctTrial.numFrames = round( strctTrial.afMovieLengthSec / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
    %strctTrial.fDuration
    %strctTrial.m_fStimulusOFF_MS
    %strctTrial.m_fStimulusON_MS
    %{
strctTrial.m_fStimulusON_MS = squeeze(g_strctParadigm.MovieStimulusOnTime.Buffer(1,:,g_strctParadigm.MovieStimulusOnTime.BufferIdx));
strctTrial.m_fStimulusOFF_MS = squeeze(g_strctParadigm.MovieStimulusOffTime.Buffer(1,:,g_strctParadigm.MovieStimulusOffTime.BufferIdx));
    %}
else
    strctTrial.m_bLoadOnTheFly = false;
    
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

%if g_strctParadigm.m_bRepeatNonFixatedImages
%strctTrial

%end
if isempty(g_strctParadigm.m_strctMRIStim.m_strCurrentlySelectedStimset)
    fnParadigmToKofikoComm('DisplayMessage','No Images Loaded! Load Image list in design panel!');
    fnPauseParadigm();
    return;
end
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

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
    strctTrial.m_afBackgroundColor = round(g_strctParadigm.m_strctCurrentBackgroundColors/255);
    strctTrial.m_afLocalBackgroundColor = strctTrial.m_afBackgroundColor;
    
else
    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    
    strctTrial.m_afBackgroundColor = strctTrial.m_afLocalBackgroundColor;
end


[strctTrial.m_iImageBlockIndex, g_strctParadigm.m_strctMRIStim.m_iSelectedImageBlock] = deal(g_strctParadigm.m_iCurrentBlockIndexInOrderList);

if g_strctParadigm.m_strctMRIStim.m_bRandomOrder
    leastDisplayedStimuliCount = min(g_strctParadigm.m_strctMRIStim.m_aiStimulusDisplayCount);
    
    leastDisplayStimuliIDX = g_strctParadigm.m_strctMRIStim.m_aiStimulusDisplayCount == leastDisplayedStimuliCount;
    maxCount = sum(leastDisplayStimuliIDX);
    % iSelectedStimulus = deal(randi(numel(g_strctParadigm.m_strctMRIStim.ahTextures)));
    
    iSelectedStimulus = randi(maxCount);
    leastDisplayedTrialIDs = find(leastDisplayStimuliIDX);
    iSelectedStimulus = leastDisplayedTrialIDs(iSelectedStimulus);
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
g_strctParadigm.m_strctMRIStim.m_aiStimulusDisplayCount(iSelectedStimulus) = ...
    g_strctParadigm.m_strctMRIStim.m_aiStimulusDisplayCount(iSelectedStimulus) + 1;
[strctTrial.m_iImageIndex, g_strctParadigm.m_strctMRIStim.m_iSelectedImage] = deal(iSelectedStimulus);
strctTrial.m_strImageName = g_strctParadigm.m_strctMRIStim.acFileNames{strctTrial.m_iImageIndex};
strctTrial.m_strFullImageFilePath = g_strctParadigm.m_strctMRIStim.acFileNames{strctTrial.m_iImageIndex};

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
    %dbstop if warning
    try
        %warning('stop')
        [ImageFilePath, strctTrial.m_strImageFileName, ~] = fileparts(strctTrial.m_strImageName);
        [strctTrial.m_strImageFileCategory, ~, ~] = fileparts(ImageFilePath);
        strComponents = strsplit(strctTrial.m_strImageFileName, '_');
        strctTrial.m_strImageCatStr = strComponents{1};
        imageCatStrIDX = regexp(strctTrial.m_strImageCatStr,'\d');
        strctTrial.m_iImageNameID = strctTrial.m_strImageCatStr(imageCatStrIDX);
        if ischar(strctTrial.m_iImageNameID)
            strctTrial.m_iImageNameID = str2double(strctTrial.m_iImageNameID);
        end
        strctTrial.m_strImageName = strctTrial.m_strImageCatStr(1:min(imageCatStrIDX)-1);
        
    end
    if isempty(strctTrial.m_strImageName)
        try
            strctTrial.m_strImageName = g_strctParadigm.m_strctMRIStim.acFileNames{strctTrial.m_iImageIndex};
            
            %warning('stop')
            [ImageFilePath, strctTrial.m_strImageFileName, ~] = fileparts(strctTrial.m_strImageName);
            [strctTrial.m_strImageFileCategory, ~, ~] = fileparts(ImageFilePath);
            strComponents = strsplit(strctTrial.m_strImageFileName, '-');
            strctTrial.m_strImageCatStr = strComponents{1};
            imageCatStrIDX = regexp(strctTrial.m_strImageCatStr,'\d');
            strctTrial.m_iImageNameID = strctTrial.m_strImageCatStr(imageCatStrIDX);
            if ischar(strctTrial.m_iImageNameID)
                strctTrial.m_iImageNameID = str2double(strctTrial.m_iImageNameID);
            end
            strctTrial.m_strImageName = strctTrial.m_strImageCatStr(1:min(imageCatStrIDX)-1);
            
        end
    end
    try
        if numel(strComponents) == 4 || numel(strComponents) == 5
            
            azimuthInfoIDX = regexp(strComponents(2),'\d');
            azimuthInfoString = strComponents(2);
            azimuthInfo = str2double(azimuthInfoString{1}(azimuthInfoIDX{1}));
            
            elevationInfoIDX = regexp(strComponents(4),'\d');
            elevationInfoString = strComponents(4);
            elevationInfo = str2double(elevationInfoString{1}(elevationInfoIDX{1}));
            if strcmp(elevationInfoString{1}(elevationInfoIDX{1}(1)-1), '-')
                elevationInfo = -elevationInfo;
            end
            
            saturationInfoIDX = regexp(strComponents(3),'\d');
            saturationInfoString = strComponents(3);
            saturationInfo = str2double(saturationInfoString{1}(saturationInfoIDX{1}));
            % [x, y, z] = sph2cart(deg2rad(azimuthInfo),elevationInfo/100,saturationInfo/100);
            % strctTrial.m_aiStimXYZ = [x,y,z]
            [strctTrial.m_aiStimXYZ(1), strctTrial.m_aiStimXYZ(2), strctTrial.m_aiStimXYZ(3)] = sph2cart(deg2rad(azimuthInfo),elevationInfo/100,saturationInfo/100);
            aiStimColorUncorrected = ldrgyv2rgb(elevationInfo/100, strctTrial.m_aiStimXYZ(1), strctTrial.m_aiStimXYZ(2));
            aiStimColorUncorrected(aiStimColorUncorrected > 1) = 1;
            aiStimColorUncorrected(aiStimColorUncorrected < 0) = 0;
            
            strctTrial.m_aiStimXYZ(3) = elevationInfo/100;
            strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(aiStimColorUncorrected(1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(aiStimColorUncorrected(2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(aiStimColorUncorrected(3) * 65535) + 1)];
        end
        %{
	if strcmpi(strComponents(3),'high_sat')
        rad = .9;
	elseif strcmpi(strComponents(3),'high_lum') || strcmpi(strComponents(3),'low_lum') ||  strcmpi(strComponents(3),'low_sat')
        rad = .5;
		if strcmpi(strComponents(3),'high_lum')
            el = .3;
		elseif strcmpi(strComponents(3),'low_lum')
            el = -.3;
        else
            el = 0;
		end
		azimuthInfoIDX = regexp(strComponents(4),'\d');
        azimuthInfoString = strComponents(4);
        azimuthInfo = azimuthInfoString{1}(azimuthInfoIDX{1});
       
		az = [str2double(azimuthInfo)];
	elseif  strcmpi(strComponents(3),'achromatic')
        rad = 0;
        elevationdigitIDX = regexp(strComponents(4),'\d');
        elevationInfoString = strComponents(4);
        elevationInfo = elevationInfoString{1}(elevationdigitIDX{1});
        %elevationInfo = elevationInfo{1};
        el = [str2double(elevationInfo)];
        az = 0;
	end
		[strctTrial.m_aiStimXYZ(1), strctTrial.m_aiStimXYZ(2), strctTrial.m_aiStimXYZ(3)] = sph2cart(az,el,rad);
		aiStimColorUncorrected = ldrgyv2rgb(strctTrial.m_aiStimXYZ(3), strctTrial.m_aiStimXYZ(1), strctTrial.m_aiStimXYZ(2));
         strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(aiStimColorUncorrected(1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(aiStimColorUncorrected(2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(aiStimColorUncorrected(3) * 65535) + 1)];
        %}
    catch
        [strctTrial.m_aiStimXYZ(1), strctTrial.m_aiStimXYZ(2), strctTrial.m_aiStimXYZ(3)] = deal(NaN);
        aiStimColorUncorrected   = [NaN, NaN, NaN];
        %aiStimColorUncorrected = ldrgyv2rgb(strctTrial.m_aiStimXYZ(3), strctTrial.m_aiStimXYZ(1), strctTrial.m_aiStimXYZ(2));
        %strctTrial.m_aiStimXYZ(3) = elevationInfo/100;
        strctTrial.m_aiStimColor = [NaN, NaN, NaN];
    end
    
    strctTrial.m_bUseBitsPlusPlus = false;
end


if strctTrial.m_bAspectRatioLocked
    
    
    
    if ~g_strctParadigm.m_strctMRIStim.m_bForceMatchImageSizes
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
    elseif g_strctParadigm.m_strctMRIStim.m_bMatchToMinimumImageSize
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(1)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(2)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(1)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(2)*strctTrial.m_fImageWidthMultiplier;
        
    elseif g_strctParadigm.m_strctMRIStim.m_bMatchToMaximumImageSize
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(1)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(2)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(1)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(2)*strctTrial.m_fImageWidthMultiplier;
        
    else
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier;
        
    end
    
else
    
    if ~g_strctParadigm.m_strctMRIStim.m_bForceMatchImageSizes
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier;
    elseif g_strctParadigm.m_strctMRIStim.m_bMatchToMinimumImageSize
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(1)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(2)*strctTrial.m_fImageHeightMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(1)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.m_aiMinImageSize(2)*strctTrial.m_fImageHeightMultiplier;
        
    elseif g_strctParadigm.m_strctMRIStim.m_bMatchToMaximumImageSize
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(1)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(2)*strctTrial.m_fImageHeightMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(1)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.m_aiMaxImageSize(2)*strctTrial.m_fImageHeightMultiplier;
        
        
    else
        strctTrial.m_aiStimulusArea(1) = round(strctTrial.location_x - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier)/2)));
        strctTrial.m_aiStimulusArea(2) = round(strctTrial.location_y - (((g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier)/2)));
        strctTrial.m_aiStimulusArea(3) = strctTrial.m_aiStimulusArea(1) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(1,strctTrial.m_iImageIndex)*strctTrial.m_fImageWidthMultiplier;
        strctTrial.m_aiStimulusArea(4) = strctTrial.m_aiStimulusArea(2) + g_strctParadigm.m_strctMRIStim.a2iTextureSize(2,strctTrial.m_iImageIndex)*strctTrial.m_fImageHeightMultiplier;
    end
    
    
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
        xrange= range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
        yrange= range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
            if yrange<=0; yrange=1; end; if xrange<=1; xrange=1; end

        strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ randi(xrange);
        strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ randi(yrange);
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
    
    
    
    % what's going on here?
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

% dbstop if warning
% warning('stop')

return;

% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPrepareFivedotTrial(g_strctPTB, strctTrial)

global g_strctParadigm
strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_afBackgroundColor = [127 127 127]; %squeeze(g_strctParadigm.FivedotBackgroundColor.Buffer(1,:,g_strctParadigm.FivedotBackgroundColor.BufferIdx));
strctTrial.m_afLocalBackgroundColor = strctTrial.m_afBackgroundColor;
    

strctTrial.m_fStimulusON_MS = g_strctParadigm.FivedotStimulusON_MS.Buffer(1,:,g_strctParadigm.FivedotStimulusON_MS.BufferIdx);
strctTrial.m_fStimulusOFF_MS = 10; %g_strctParadigm.DualstimStimulusOffTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOffTime.BufferIdx);
strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));

[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);

aiStimulusScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');
pt2iCenter = aiStimulusScreenSize(3:4)/2;
fSpreadPix = g_strctParadigm.SpreadPix.Buffer(1,:,g_strctParadigm.SpreadPix.BufferIdx);

strctTrial.apt2iFixationSpots =  [pt2iCenter;
    pt2iCenter + [-fSpreadPix,-fSpreadPix];
    pt2iCenter + [fSpreadPix,-fSpreadPix];
    pt2iCenter + [-fSpreadPix,fSpreadPix];
    pt2iCenter + [fSpreadPix,fSpreadPix]; ];

strctTrial.targspot=randi(5);
strctTrial.m_pt2iFixationSpot = strctTrial.apt2iFixationSpots(strctTrial.targspot,:);

linearclut=linspace(0,65535,256)';
strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);

% other variables (kept in to avoid random crashes during paradigm switch)
strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.MovingBarMoveSpeed.Buffer(1,:,g_strctParadigm.MovingBarMoveSpeed.BufferIdx));
strctTrial.m_bBlur  = squeeze(g_strctParadigm.MovingBarBlur.Buffer(1,:,g_strctParadigm.MovingBarBlur.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.MovingBarBlurSteps.Buffer(1,:,g_strctParadigm.MovingBarBlurSteps.BufferIdx)));
strctTrial.m_iLength = squeeze(g_strctParadigm.MovingBarLength.Buffer(1,:,g_strctParadigm.MovingBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.MovingBarWidth.Buffer(1,:,g_strctParadigm.MovingBarWidth.BufferIdx));
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.MovingBarNumberOfBars.Buffer(1,:,g_strctParadigm.MovingBarNumberOfBars.BufferIdx));

fnTsSetVar('g_strctParadigm','FixationSpotPix',strctTrial.m_pt2iFixationSpot);
strctTrial.pt2fFixationSpotPix = g_strctParadigm.FixationSpotPix.Buffer(1,:,g_strctParadigm.FixationSpotPix.BufferIdx);
strctTrial.fFixationSizePix = g_strctParadigm.FixationSizePix.Buffer(1,:,g_strctParadigm.FixationSizePix.BufferIdx);

% 
% strctTrial.m_iMoveDistance = (strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;
% strctTrial.m_bRandomStimulusOrientation = g_strctParadigm.m_bRandomStimulusOrientation;
% strctTrial.m_bCycleStimulusOrientation = g_strctParadigm.m_bCycleStimulusOrientation;
% strctTrial.m_bReverseCycleStimulusOrientation = g_strctParadigm.m_bReverseCycleStimulusOrientation;

return

% ------------------------------------------------------------------------------------------------------------------------
% Previous version of Dualstim
%{
function [strctTrial] = fnPrepareDualstimTrial(g_strctPTB, strctTrial)
%tic
global g_strctParadigm

try
if isempty(g_strctParadigm.hartleys_local) %~exist('g_strctParadigm.hartleyset','var') | 
    fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
    fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);
end
catch
    fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
    fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);
end

strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.DualstimLength.Buffer(1,:,g_strctParadigm.DualstimLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.DualstimWidth.Buffer(1,:,g_strctParadigm.DualstimWidth.BufferIdx));
%strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.MovingBarNumberOfBars.Buffer(1,:,g_strctParadigm.MovingBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = 1000; %g_strctParadigm.DualstimStimulusOnTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = 100; %g_strctParadigm.DualstimStimulusOffTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOffTime.BufferIdx);
strctTrial.numFrames=g_strctParadigm.DensenoiseTrialLength;
strctTrial.ContinuousDisplay = fnTsGetVar('g_strctParadigm','ContinuousDisplay');
strctTrial.CSDtrigframe = fnTsGetVar('g_strctParadigm','CSDtrigframe');
strctTrial.numberBlurSteps = 1; strctTrial.m_bBlur  = 0;

strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);

% dbstop if warning
% warning('stop')
[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);

%Felix added: primary stimulus rect
% strctTrial.secondarystim_location_x(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1);
% strctTrial.secondarystim_location_y(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2);
strctTrial.secondarystim_location_x(1) = g_strctParadigm.SecondaryStimulusPosition.Buffer(1,1,1);
strctTrial.secondarystim_location_y(1) = g_strctParadigm.SecondaryStimulusPosition.Buffer(1,2,1);

%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','DualstimStimulusArea');
% g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(strctTrial.m_aiStimulusArea/2);
% g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(strctTrial.m_aiStimulusArea/2);
% g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(strctTrial.m_aiStimulusArea/2);
% g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(strctTrial.m_aiStimulusArea/2);
% %g_strctParadigm.m_aiStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiStimulusRect);
% g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
% strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;

%winoffset = mod(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'), fnTsGetVar('g_strctParadigm','DualstimSecondaryBarWidth'));
winoffset = mod(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'), 25);
strctTrial.m_aiSecondaryStimulusArea = fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea')+winoffset;

strctTrial.m_aiCenterOfSecondaryStimulus = fnTsGetVar('g_strctParadigm','SecondaryStimulusPosition');
g_strctParadigm.m_aiSecondaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)+(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)+(strctTrial.m_aiSecondaryStimulusArea/2);
% g_strctParadigm.m_aiSecondaryStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiSecondaryStimulusRect);
g_strctParadigm.m_aiSecondaryStimulusRect = g_strctParadigm.m_aiSecondaryStimulusRect;
strctTrial.secondarystim_bar_rect(1,1:4) =  g_strctParadigm.m_aiSecondaryStimulusRect;

strctTrial.m_aiCenterOfTertiaryStimulus = fnTsGetVar('g_strctParadigm','TertiaryStimulusPosition');
g_strctParadigm.m_aiTertiaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)+(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)+(strctTrial.m_aiSecondaryStimulusArea/2);
% g_strctParadigm.m_aiTertiaryStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiTertiaryStimulusRect);
g_strctParadigm.m_aiTertiaryStimulusRect = g_strctParadigm.m_aiTertiaryStimulusRect;
strctTrial.tertiarystim_bar_rect(1,1:4) =  g_strctParadigm.m_aiTertiaryStimulusRect;

strctTrial.DualStimSecondaryori = zeros(1,strctTrial.numFrames);
spatialscale = round(sqrt(fnTsGetVar('g_strctParadigm','DualstimSecondaryBarWidth')));
strctTrial.DualstimPrimaryuseRGBCloud = fnTsGetVar('g_strctParadigm','DualstimPrimaryuseRGBCloud');

% Loop start
if strctTrial.DualstimPrimaryuseRGBCloud==0 % Ground truth
    %/{
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.GroundtruthNumberOfBars.Buffer(1,:,g_strctParadigm.GroundtruthNumberOfBars.BufferIdx));
if g_strctParadigm.m_bGroundtruthCISonly==1
%curcols = RandSample(3:8,[1,strctTrial.m_iNumberOfBars]);
strctTrial.m_iNumberOfBars=12;
curcols = [randperm(6,6),randperm(6,6)]+2;
else
curcols = randi(16,strctTrial.m_iNumberOfBars,1);
end

strctTrial.m_aiLocalBlurStepHolder = zeros(3,strctTrial.m_iNumberOfBars,strctTrial.numFrames);
strctTrial.m_aiBlurStepHolder = zeros(3,strctTrial.m_iNumberOfBars,strctTrial.numFrames);

for iNumBars = 1 : strctTrial.m_iNumberOfBars
% Felix note; replace THIS with semirandom sequence
strctTrial.m_aiLocalBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = repmat(g_strctParadigm.m_cPresetColorList(curcols(iNumBars),:),strctTrial.numFrames,1)';
strctTrial.m_aiBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = deal(curcols(iNumBars)-1);
end
if strctTrial.m_iNumberOfBars > 3
strctTrial.m_aiLocalBlurStepHolder(1:3,2,1:strctTrial.numFrames) = repmat(g_strctParadigm.m_cPresetColorList(curcols(1),:),strctTrial.numFrames,1)';
strctTrial.m_aiBlurStepHolder(1:3,2,1:strctTrial.numFrames) = deal(curcols(1)-1);
end

%        strctTrial.m_iMoveDistance = (strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;
strctTrial.m_bRandomStimulusOrientation = g_strctParadigm.m_bRandomStimulusOrientation;
strctTrial.m_bCycleStimulusOrientation = g_strctParadigm.m_bCycleStimulusOrientation;
strctTrial.m_bReverseCycleStimulusOrientation = g_strctParadigm.m_bReverseCycleStimulusOrientation;
strctTrial.m_iOrientationBin = [];
strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.CIHandmapperOrientation.Buffer(1,:,g_strctParadigm.CIHandmapperOrientation.BufferIdx));
g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;

xrange=range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
yrange=range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
if yrange<=0; yrange=1; end; if xrange<=1; xrange=1; end

n_xpos=floor(xrange/strctTrial.m_iLength);
n_ypos=floor(yrange/strctTrial.m_iWidth);
if n_xpos<=0; n_xpos=1; end; if n_ypos<=1; n_ypos=1; end

strctTrial.m_fspatialoffset = g_strctParadigm.GroundtruthOffset.Buffer(1,:,g_strctParadigm.GroundtruthOffset.BufferIdx);
for iNumBars = 1 : strctTrial.m_iNumberOfBars
    strctTrial.location_x(1:strctTrial.numFrames,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ strctTrial.m_iLength*randi(n_xpos)+strctTrial.m_iLength/2+strctTrial.m_fspatialoffset;
    strctTrial.location_y(1:strctTrial.numFrames,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth*randi(n_ypos)+strctTrial.m_iWidth/2;
%strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth.*temp_ypos(ff)+strctTrial.m_iWidth/2;
    for ff=1:1:strctTrial.numFrames
    strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(ff,iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars)  - strctTrial.m_iWidth/2), ...
        (strctTrial.location_x(ff,iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars) + strctTrial.m_iWidth/2)];
    end
end

[strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
for ff=1:strctTrial.numFrames
    for iNumOfBars = 1:strctTrial.m_iNumberOfBars
        [strctTrial.point1(ff,iNumOfBars,1), strctTrial.point1(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.point2(ff,iNumOfBars,1), strctTrial.point2(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.point3(ff,iNumOfBars,1), strctTrial.point3(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.point4(ff,iNumOfBars,1), strctTrial.point4(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.bar_starting_point(ff,iNumOfBars,1),strctTrial.bar_starting_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.bar_ending_point(ff,iNumOfBars,1),strctTrial.bar_ending_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);

        % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
    end
end
        % Check if the trial has more than 1 frame in it, so we can plan the trial
%        strctTrial.coordinatesX(1:4,:,:) = [strctTrial.point1(:,:,1); strctTrial.point2(:,:,1); strctTrial.point3(:,:,1);strctTrial.point4(:,:,1)];
%        strctTrial.coordinatesY(1:4,:,:) = [strctTrial.point1(:,:,2), strctTrial.point2(:,:,2), strctTrial.point3(:,:,2),strctTrial.point4(:,:,2)];
%                     
        strctTrial.coordinatesX(1,:,:) = shiftdim(strctTrial.point1(:,:,1));
        strctTrial.coordinatesX(2,:,:) = shiftdim(strctTrial.point2(:,:,1));
        strctTrial.coordinatesX(3,:,:) = shiftdim(strctTrial.point3(:,:,1));
        strctTrial.coordinatesX(4,:,:) = shiftdim(strctTrial.point4(:,:,1));
        strctTrial.coordinatesY(1,:,:) = shiftdim(strctTrial.point1(:,:,2));
        strctTrial.coordinatesY(2,:,:) = shiftdim(strctTrial.point2(:,:,2));
        strctTrial.coordinatesY(3,:,:) = shiftdim(strctTrial.point3(:,:,2));
        strctTrial.coordinatesY(4,:,:) = shiftdim(strctTrial.point4(:,:,2));
    % }
        linearclut=linspace(0,65535,256)';
        strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
        
elseif strctTrial.DualstimPrimaryuseRGBCloud==1 % achromatic cloud
    if ~isfield(g_strctParadigm,'DensenoiseAchromcloud')
        feval(g_strctParadigm.m_strCallbacks,'PregenACloudStimuli');
    end
    
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
         linearclut=linspace(0,65535,256)';
         strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
    strctTrial.stimuli=g_strctParadigm.DensenoiseAchromcloud(:,:,strctTrial.stimseq,:);
    
elseif strctTrial.DualstimPrimaryuseRGBCloud==2 %use color cloud 
    if ~isfield(g_strctParadigm,'DensenoiseChromcloud')
        feval(g_strctParadigm.m_strCallbacks,'PregenCCloudStimuli');
    end
    
    strctTrial.Cur_CCloud_loaded = g_strctParadigm.Cur_CCloud_loaded;
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,1,ceil(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
    strctTrial.stimuli=g_strctParadigm.DensenoiseChromcloud_DKlspace(:,:,strctTrial.stimseq,:);
    strctTrial.stimuli_RGB=g_strctParadigm.DensenoiseChromcloud(:,:,strctTrial.stimseq,:);

    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);

elseif strctTrial.DualstimPrimaryuseRGBCloud==3 %use bar stimuli
    strctTrial.cur_ori=fnTsGetVar('g_strctParadigm' ,'DensenoiseOrientation'); 
    strctTrial.cur_oribin=floor(strctTrial.cur_ori./15)+1;
    
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chrombar_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
    
    nbars=25;
    randseed=rand(1,g_strctParadigm.Dualstim_pregen_chrombar_n*nbars);
    randseed2 = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    strctTrial.barmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    pvec_edges=[0 cumsum(g_strctParadigm.barprobs_lum)];
    for pp=1:7
        cur_indxs=find(randseed>=pvec_edges(pp) & randseed<pvec_edges(pp+1));
        randseed2(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKLCLUT(pp,:),length(cur_indxs),1);
        strctTrial.barmat(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKL(pp,:),length(cur_indxs),1);
    end
    strctTrial.m_aiCLUT=zeros(g_strctParadigm.Dualstim_pregen_chrombar_n,256,3);
    strctTrial.m_aiCLUT(:,2,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,3:nbars+2,:)=reshape(randseed2,g_strctParadigm.Dualstim_pregen_chrombar_n,nbars,3);
    strctTrial.m_aiCLUT(:,126:255,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,256,:) = deal(65535);
% }
elseif strctTrial.DualstimPrimaryuseRGBCloud==4 %use bar stimuli
    strctTrial.cur_ori=fnTsGetVar('g_strctParadigm' ,'DensenoiseOrientation'); 
    strctTrial.cur_oribin=floor(strctTrial.cur_ori./15)+1;
        
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chrombar_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);

%/{
    nbars=25;
    randseed=rand(1,g_strctParadigm.Dualstim_pregen_chrombar_n*nbars);
    randseed2 = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    strctTrial.barmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    pvec_edges=[0 cumsum(g_strctParadigm.barprobs)];
    for pp=1:7
        cur_indxs=find(randseed>=pvec_edges(pp) & randseed<pvec_edges(pp+1));
        randseed2(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKLCLUT(pp,:),length(cur_indxs),1);
        strctTrial.barmat(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKL(pp,:),length(cur_indxs),1);
    end
    strctTrial.m_aiCLUT=zeros(g_strctParadigm.Dualstim_pregen_chrombar_n,256,3);
    strctTrial.m_aiCLUT(:,2,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,3:nbars+2,:)=reshape(randseed2,g_strctParadigm.Dualstim_pregen_chrombar_n,nbars,3);
    strctTrial.m_aiCLUT(:,126:255,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,256,:) = deal(65535);
% }
elseif strctTrial.DualstimPrimaryuseRGBCloud==5 %use Lum-axis hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);
%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DualstimPrimaryuseRGBCloud==6 %use L-M axis hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2))+length(g_strctParadigm.hartleyset.hartleys_binned),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);
%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DualstimPrimaryuseRGBCloud==7 %use S-axis hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2))+2*length(g_strctParadigm.hartleyset.hartleys_binned),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);
%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DualstimPrimaryuseRGBCloud==8 %use all color hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned)*3,1,ceil(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
    
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);

%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);


end

strctTrial.DualstimSecondaryUseCloud = g_strctParadigm.DualstimSecondaryUseCloud.Buffer(1,:,g_strctParadigm.DualstimSecondaryUseCloud.BufferIdx);
if strctTrial.DualstimSecondaryUseCloud==1 % achromatic cloud
    if ~isfield(g_strctParadigm,'DensenoiseAchromcloud')
        feval(g_strctParadigm.m_strCallbacks,'PregenACloudStimuli');
    end
    
    strctTrial.stimseq_ET=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq_ET=strctTrial.stimseq(:);
    strctTrial.stimuli_ET=g_strctParadigm.DensenoiseAchromcloud(:,:,strctTrial.stimseq,:);
    
elseif strctTrial.DualstimSecondaryUseCloud==2 %use color cloud 
    if ~isfield(g_strctParadigm,'DensenoiseChromcloud')
        feval(g_strctParadigm.m_strCallbacks,'PregenCCloudStimuli');
    end
    strctTrial.Cur_CCloud_loaded = g_strctParadigm.Cur_CCloud_loaded;
    strctTrial.stimseq_ET=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,1,ceil(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq_ET=strctTrial.stimseq(:);
    strctTrial.stimuli_ET=g_strctParadigm.DensenoiseChromcloud_DKlspace(:,:,strctTrial.stimseq,:);
    strctTrial.stimuli_ET_RGB=g_strctParadigm.DensenoiseChromcloud(:,:,strctTrial.stimseq,:);
end
%{
strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.DualstimLength.Buffer(1,:,g_strctParadigm.DualstimLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.DualstimWidth.Buffer(1,:,g_strctParadigm.DualstimWidth.BufferIdx));
%strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.MovingBarNumberOfBars.Buffer(1,:,g_strctParadigm.MovingBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = 1000; %g_strctParadigm.DualstimStimulusOnTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = 100; %g_strctParadigm.DualstimStimulusOffTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOffTime.BufferIdx);
strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));

strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.DualstimMoveDistance.Buffer(1,:,g_strctParadigm.DualstimMoveDistance.BufferIdx));
strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.DualstimMoveSpeed.Buffer(1,:,g_strctParadigm.DualstimMoveSpeed.BufferIdx));
%    strctTrial.m_iMoveDistance = (strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;

%Felix kludge - not worrying about blur for now
if strctTrial.m_iMoveDistance >=1 && strctTrial.m_iMoveSpeed >=1
    strctTrial.numberBlurSteps = round(strctTrial.m_iMoveDistance/strctTrial.m_iMoveSpeed);
else 
    strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.DualstimBlurSteps.Buffer(1,:,g_strctParadigm.DualstimBlurSteps.BufferIdx)));
end

if strctTrial.numberBlurSteps >1
    strctTrial.m_bBlur  = 1;
else
    strctTrial.numberBlurSteps = 1; strctTrial.m_bBlur  = 0;
end

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
    %strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
    %         %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
    
    % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    
    currentBlockStimBGColorsR = ['DualstimBackgroundRed'];
    currentBlockStimBGColorsG = ['DualstimBackgroundGreen'];
    currentBlockStimBGColorsB = ['DualstimBackgroundBlue'];

    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    strctTrial.m_afBackgroundColor = floor(strctTrial.m_afLocalBackgroundColor/255)*65535;
else
    strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
end
% dbstop if warning
% warning('stop')
[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);


% strctTrial.secondarystim_location_x(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1);
% strctTrial.secondarystim_location_y(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2);
strctTrial.secondarystim_location_x(1) = g_strctParadigm.SecondaryStimulusPosition.Buffer(1,1,1);
strctTrial.secondarystim_location_y(1) = g_strctParadigm.SecondaryStimulusPosition.Buffer(1,2,1);

%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','DualstimStimulusArea');
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(strctTrial.m_aiStimulusArea/2);
%g_strctParadigm.m_aiStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiStimulusRect);
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;

%winoffset = mod(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'), fnTsGetVar('g_strctParadigm','DualstimSecondaryBarWidth'));
winoffset = mod(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'), 25);
strctTrial.m_aiSecondaryStimulusArea = fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea')+winoffset;

strctTrial.m_aiCenterOfSecondaryStimulus = fnTsGetVar('g_strctParadigm','SecondaryStimulusPosition');
g_strctParadigm.m_aiSecondaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)+(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)+(strctTrial.m_aiSecondaryStimulusArea/2);
%g_strctParadigm.m_aiSecondaryStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiSecondaryStimulusRect);
g_strctParadigm.m_aiSecondaryStimulusRect = g_strctParadigm.m_aiSecondaryStimulusRect;
strctTrial.secondarystim_bar_rect(1,1:4) =  g_strctParadigm.m_aiSecondaryStimulusRect;

strctTrial.m_aiCenterOfTertiaryStimulus = fnTsGetVar('g_strctParadigm','TertiaryStimulusPosition');
g_strctParadigm.m_aiTertiaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)+(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)+(strctTrial.m_aiSecondaryStimulusArea/2);
%g_strctParadigm.m_aiTertiaryStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiTertiaryStimulusRect);
g_strctParadigm.m_aiTertiaryStimulusRect = g_strctParadigm.m_aiTertiaryStimulusRect;
strctTrial.tertiarystim_bar_rect(1,1:4) =  g_strctParadigm.m_aiTertiaryStimulusRect;

strctTrial.DualStimSecondaryori = zeros(1,strctTrial.numFrames);
spatialscale = round(sqrt(fnTsGetVar('g_strctParadigm','DualstimSecondaryBarWidth')));
strctTrial.DualstimSecondaryUseCloud = g_strctParadigm.DualstimSecondaryUseCloud.Buffer(1,:,g_strctParadigm.DualstimSecondaryUseCloud.BufferIdx);
if strctTrial.DualstimSecondaryUseCloud==0
    %    strctTrial.DualStimSecondary = mk_TernaryStim(.3, fnTsGetVar('g_strctParadigm','DualstimSecondaryBarWidth'), 0, strctTrial.numFrames, round(sqrt(g_strctParadigm.DualstimSecondaryStimulusArea.Buffer(1,:,g_strctParadigm.DualstimSecondaryStimulusArea.BufferIdx)))); %felix note - comment out just to see if this runs through?
    strctTrial.DualStimSecondary = mk_TernaryStim(.3, 1, 0, strctTrial.numFrames, 25);
    strctTrial.DualStimSecondary_disp = strctTrial.DualStimSecondary; 
    strctTrial.DualStimSecondary_disp(find(strctTrial.DualStimSecondary_disp(:))==0)=1;
    strctTrial.DualStimSecondary_disp(find(strctTrial.DualStimSecondary_disp(:))==127)=2;
    strctTrial.DualStimSecondary_disp(find(strctTrial.DualStimSecondary_disp(:))==255)=256;
    strctTrial.DualStimSecondaryori(2:2:end)=90;
    
elseif strctTrial.DualstimSecondaryUseCloud==1
    %     strctTrial.DualStimSecondary = mk_spatialcloud(round(sqrt(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'))), ...
    %         round(sqrt(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'))), strctTrial.numFrames, spatialscale);
    strctTrial.DualStimSecondary = mk_spatialcloud(25,25, strctTrial.numFrames, spatialscale).*255;
    strctTrial.DualStimSecondary_disp = strctTrial.DualStimSecondary;
    
elseif strctTrial.DualstimSecondaryUseCloud==2 %use hartleys
    curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
    strctTrial.DualStimSecondary = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
    strctTrial.DualStimSecondary_disp = g_strctParadigm.hartleyset.hartleys50_binned(:,:,curseq)+8;

elseif strctTrial.DualstimSecondaryUseCloud==3 %use color hartleys
    %replace with correct indices
    curseq=randi(size(g_strctParadigm.hartleyset.Colhartleys50,3),1,strctTrial.numFrames);
    strctTrial.DualStimSecondary = g_strctParadigm.hartleyset.Colhartleys50(:,:,curseq,:).*255;
    strctTrial.DualStimSecondary_disp = g_strctParadigm.hartleyset.Colhartleys50_binned(:,:,curseq)+8;

elseif strctTrial.DualstimSecondaryUseCloud==4 %use color cloud 
    strctTrial.DualStimSecondary = 2*(mk_spatialcloudRGB(25, 25, strctTrial.numFrames, spatialscale)-.5);
    lv_in=strctTrial.DualStimSecondary(:,:,:,1);
    rg_in=strctTrial.DualStimSecondary(:,:,:,2);
    yv_in=strctTrial.DualStimSecondary(:,:,:,3);
    strctTrial.DualStimSecondary = shiftdim(reshape(ldrgyv2rgb(lv_in(:)',rg_in(:)',yv_in(:)'),3,25,25,strctTrial.numFrames),1).*255;
    strctTrial.DualStimSecondary_disp = strctTrial.DualStimSecondary;
end

strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;

%     clutseq=[-1 -.6 -.3 0 .3 .6 1];
%     for curclut=1:7
%     strctTrial.m_aiCLUT(9+curclut,:) = ldrgyv2rgb(0,clutseq(curclut),0);
%     strctTrial.m_aiCLUT(16+curclut,:) = ldrgyv2rgb(0,0,clutseq(curclut));
%     end
strctTrial.m_aiCLUT(256,:) = deal(65535);

%strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));

strctTrial.DualstimPrimaryuseRGBCloud = fnTsGetVar('g_strctParadigm','DualstimPrimaryuseRGBCloud');

if strctTrial.DualstimPrimaryuseRGBCloud==0
    
    strctTrial.DualstimNSminus = g_strctParadigm.DualstimNSminus;
    strctTrial.DualstimNSplus = g_strctParadigm.DualstimNSplus;
    strctTrial.DualstimNMminus = g_strctParadigm.DualstimNMminus;
    strctTrial.DualstimNMplus = g_strctParadigm.DualstimNMplus;
    strctTrial.DualstimNLminus = g_strctParadigm.DualstimNLminus;
    strctTrial.DualstimNLplus = g_strctParadigm.DualstimNLplus;
    strctTrial.m_iNumberOfBars = ... %.Buffer(1,:,g_strctParadigm.DualstimNumberOfBars.BufferIdx)
        (strctTrial.DualstimNSminus.Buffer(1,:,g_strctParadigm.DualstimNSminus.BufferIdx)+...
        strctTrial.DualstimNSplus.Buffer(1,:,g_strctParadigm.DualstimNSplus.BufferIdx)+...
        strctTrial.DualstimNMminus.Buffer(1,:,g_strctParadigm.DualstimNMminus.BufferIdx)+...
        strctTrial.DualstimNMplus.Buffer(1,:,g_strctParadigm.DualstimNMplus.BufferIdx)+...
        strctTrial.DualstimNLminus.Buffer(1,:,g_strctParadigm.DualstimNLminus.BufferIdx)+...
        strctTrial.DualstimNLplus.Buffer(1,:,g_strctParadigm.DualstimNLplus.BufferIdx));
    %fprintf([num2str(strctTrial.m_iNumberOfBars) '/']) %felix added as sanity check
    
    % populate Color lookup table
    NSm=fnTsGetVar('g_strctParadigm','DualstimNSminus');%g_strctParadigm.DualstimNSminus.Buffer(1,:,g_strctParadigm.DualstimNSminus.BufferIdx);
    NSp=fnTsGetVar('g_strctParadigm','DualstimNSplus');%g_strctParadigm.DualstimNSplus.Buffer(1,:,g_strctParadigm.DualstimNSplus.BufferIdx);
    NMm=fnTsGetVar('g_strctParadigm','DualstimNMminus');%g_strctParadigm.DualstimNMminus.Buffer(1,:,g_strctParadigm.DualstimNMminus.BufferIdx);
    NMp=fnTsGetVar('g_strctParadigm','DualstimNMplus');%g_strctParadigm.DualstimNMplus.Buffer(1,:,g_strctParadigm.DualstimNMplus.BufferIdx);
    NLm=fnTsGetVar('g_strctParadigm','DualstimNLminus');%g_strctParadigm.DualstimNLminus.Buffer(1,:,g_strctParadigm.DualstimNLminus.BufferIdx);
    NLp=fnTsGetVar('g_strctParadigm','DualstimNLplus');%g_strctParadigm.DualstimNLplus.Buffer(1,:,g_strctParadigm.DualstimNLplus.BufferIdx);
    strctTrial.numofeachCIS=[NSm,NSp,NMm,NMp,NLm,NLp];
    
    iLastUsedCLUTOffset = g_strctParadigm.m_iCLUTOffset;
strctTrial.m_iActiveStimulusBars = length(find(strctTrial.numofeachCIS)); % = 0;
strctTrial.m_iBarPresentationOrder = randperm(6);
%{
    strctTrial.m_aiCLUT = zeros(256,3);
    strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
    %dbstop if warning
    %warning('stop')
    iLastUsedCLUTOffset = g_strctParadigm.m_iCLUTOffset;
    strctTrial.m_iActiveStimulusBars = length(find(strctTrial.numofeachCIS)); % = 0;
    strctTrial.m_iBarPresentationOrder = randperm(6);
    
    % if NSm>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
    strctTrial.NSmClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NSp>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
    strctTrial.NSpClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NMm>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
    strctTrial.NMmClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NMp>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
    strctTrial.NMpClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NLm>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
    strctTrial.NLmClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NLp>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
    strctTrial.NLpClutIndex = iLastUsedCLUTOffset-1;

    strctTrial.m_aiCLUT(256,:) = deal(65535);
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end

if NSm>0; strctTrial.m_aiCLUT(3:3+NSm,:) = repmat((65535/255)*[255, 0, 0], NSm+1,1); end
if NSp>0; strctTrial.m_aiCLUT(3+NSm:3+NSm+NSp,:) = repmat((65535/255)*[0,154,38],NSp+1,1); end
if NMm>0; strctTrial.m_aiCLUT(3+NSm+NSp:3+NSm+NSp+NMm,:) = repmat((65535/255)*[0, 252, 0], NMm+1,1); end
if NMp>0; strctTrial.m_aiCLUT(3+NSm+NSp+NMm:3+NSm+NSp+NMm+NMp,:) = repmat((65535/255)*[255, 0, 55], NMp+1,1); end
if NLm>0; strctTrial.m_aiCLUT(3+NSm+NSp+NMm+NMp:3+NSm+NSp+NMm+NMp+NLm,:) = repmat((65535/255)*[148, 0, 255], NLm+1,1); end
if NLp>0; strctTrial.m_aiCLUT(3+NSm+NSp+NMm+NMp+NLm:3+NSm+NSp+NMm+NMp+NLm+NLp,:) = repmat((65535/255)*[52, 209, 0], NLp+1,1); end
    %}
    strctTrial.m_aiLocalBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
    strctTrial.m_aiBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
    for iFrames = 1:strctTrial.numFrames
        strctTrial.m_aiLocalBlurStepHolder(1:3,1,iFrames) = g_strctParadigm.m_cPresetColors{1,1};
        strctTrial.m_aiBlurStepHolder(1:3,1,iFrames) = deal(3);

        strctTrial.m_aiLocalBlurStepHolder(1:3,2,iFrames) = g_strctParadigm.m_cPresetColors{1,2};
        strctTrial.m_aiBlurStepHolder(1:3,2,iFrames) = deal(4);

        strctTrial.m_aiLocalBlurStepHolder(1:3,3,iFrames) = g_strctParadigm.m_cPresetColors{2,1};
        strctTrial.m_aiBlurStepHolder(1:3,3,iFrames) = deal(5);

        strctTrial.m_aiLocalBlurStepHolder(1:3,4,iFrames) = g_strctParadigm.m_cPresetColors{2,2};
        strctTrial.m_aiBlurStepHolder(1:3,4,iFrames) = deal(6);

        strctTrial.m_aiLocalBlurStepHolder(1:3,5,iFrames) = g_strctParadigm.m_cPresetColors{3,1};
        strctTrial.m_aiBlurStepHolder(1:3,5,iFrames) = deal(7);

        strctTrial.m_aiLocalBlurStepHolder(1:3,6,iFrames) = g_strctParadigm.m_cPresetColors{3,2};
        strctTrial.m_aiBlurStepHolder(1:3,6,iFrames) = deal(8);

    end
    
    
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
        strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.DualstimOrientation.Buffer(1,:,g_strctParadigm.DualstimOrientation.BufferIdx));
    end
    g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;
    
    xrange=range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
    yrange=range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
    if yrange==0; yrange=1; end
    
   
    if strctTrial.m_bRandomStimulusPosition == 1
        minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iWidth)/2;
        
%{
        if g_strctParadigm.m_bRandPosEachFrame == 1;
            [strctTrial.location_x,strctTrial.location_y] = deal(zeros(strctTrial.numFrames, strctTrial.m_iNumberOfBars));
            strctTrial.location_x(1,:) = strctTrial.bar_rect(1)+ round(rand*range([strctTrial.bar_rect(1),strctTrial.bar_rect(3)]));
            strctTrial.location_y(1,:) = strctTrial.bar_rect(2)+ round(rand*range([strctTrial.bar_rect(2),strctTrial.bar_rect(4)]));

            for ff=1:strctTrial.numFrames
                for iNumBars = 2 : strctTrial.m_iNumberOfBars
                    for tries=1:10
                        if abs(min(strctTrial.location_x(ff,1:iNumBars-1)) - strctTrial.location_x(ff,iNumBars)) < minimum_seperation ||...
                                abs(min(strctTrial.location_y(ff,1:iNumBars-1)) - strctTrial.location_y(ff,iNumBars)) < minimum_seperation
                            % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                            % So we'll just try 5 times and hope for the best
                            strctTrial.location_x(ff,iNumBars) = strctTrial.bar_rect(1)+ randi(range([strctTrial.bar_rect(1),strctTrial.bar_rect(3)]));
                            strctTrial.location_y(ff,iNumBars) = strctTrial.bar_rect(2)+ randi(range([strctTrial.bar_rect(2),strctTrial.bar_rect(4)]));
                        else
                            break;
                        end
                    end
                end
            end
%}
        if g_strctParadigm.m_bRandPosEachFrame == 1;
            
            for ff=1:strctTrial.numFrames
                strctTrial.location_x(ff,1) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
                strctTrial.location_y(ff,1) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
                strctTrial.bar_rect(ff,1,1:4) = [(strctTrial.location_x(ff,1) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,1)  - strctTrial.m_iWidth/2), ...
                    (strctTrial.location_x(ff,1) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,1) + strctTrial.m_iWidth/2)];
                
                for iNumBars = 2 : strctTrial.m_iNumberOfBars
                    strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
                    strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
                    
                    for tries=1:10
                        if abs(min(strctTrial.location_x(ff,1:iNumBars-1)) - strctTrial.location_x(ff,iNumBars)) < minimum_seperation ||...
                                abs(min(strctTrial.location_y(ff,1:iNumBars-1)) - strctTrial.location_y(ff,iNumBars)) < minimum_seperation
                            % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                            % So we'll just try 5 times and hope for the best
                            strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
                            strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
                        else
                            break;
                        end
                    end
                    strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(ff,iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars)  - strctTrial.m_iWidth/2), ...
                        (strctTrial.location_x(ff,iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars) + strctTrial.m_iWidth/2)];
                    
                end
            end           
        else
            strctTrial.location_x(1) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
            strctTrial.location_y(1) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
            strctTrial.bar_rect(1,1,1:4) = [(strctTrial.location_x(1) - strctTrial.m_iLength/2), (strctTrial.location_y(1)  - strctTrial.m_iWidth/2), ...
                (strctTrial.location_x(1) + strctTrial.m_iLength/2), (strctTrial.location_y(1) + strctTrial.m_iWidth/2)];
            
            for iNumBars = 2 : strctTrial.m_iNumberOfBars
                % Random center points
                if g_strctParadigm.m_bStimulusCollisions == 0; maxtries = 15; else maxtries=5; end %Felix kludge
                strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
                strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
                for tries=1:10
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
                strctTrial.bar_rect(1,iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth/2), ...
                    (strctTrial.location_x(iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth/2)];
                
            end
        end
    else %only draw one bar, in the middle of the rect
        strctTrial.m_iNumberOfBars = 1;
        strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
        strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);
        strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2), ...
            (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
    end
    
    if ~strctTrial.m_bBlur
        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
        %{
        if strctTrial.m_iNumberOfBars == 1
            [strctTrial.point1(1,1), strctTrial.point1(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.point2(1,1), strctTrial.point2(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.point3(1,1), strctTrial.point3(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.point4(1,1), strctTrial.point4(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            
        elseif strctTrial.numFrames > 1;% && g_strctParadigm.m_bRandPosEachFrame == 1;
        %}
        for ff=1:strctTrial.numFrames
            for iNumOfBars = 1:strctTrial.m_iNumberOfBars
                [strctTrial.point1(ff,iNumOfBars,1), strctTrial.point1(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point2(ff,iNumOfBars,1), strctTrial.point2(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point3(ff,iNumOfBars,1), strctTrial.point3(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point4(ff,iNumOfBars,1), strctTrial.point4(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.bar_starting_point(ff,iNumOfBars,1),strctTrial.bar_starting_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.bar_ending_point(ff,iNumOfBars,1),strctTrial.bar_ending_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);

                % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
            end
        end

        % Check if the trial has more than 1 frame in it, so we can plan the trial
        if strctTrial.numFrames > 1 && g_strctParadigm.m_bRandPosEachFrame == 1; %Felix note: where the magic may not be happening
            %        strctTrial.coordinatesX(1:4,:,:) = [strctTrial.point1(:,:,1), strctTrial.point2(:,:,1), strctTrial.point3(:,:,1),strctTrial.point4(:,:,1)];
            %        strctTrial.coordinatesY(1:4,:,:) = [strctTrial.point1(:,:,2), strctTrial.point2(:,:,2), strctTrial.point3(:,:,2),strctTrial.point4(:,:,2)];
                    strctTrial.coordinatesX(1,:,:) = shiftdim(strctTrial.point1(:,:,1));
                    strctTrial.coordinatesX(2,:,:) = shiftdim(strctTrial.point2(:,:,1));
                    strctTrial.coordinatesX(3,:,:) = shiftdim(strctTrial.point3(:,:,1));
                    strctTrial.coordinatesX(4,:,:) = shiftdim(strctTrial.point4(:,:,1));
                    strctTrial.coordinatesY(1,:,:) = shiftdim(strctTrial.point1(:,:,2));
                    strctTrial.coordinatesY(2,:,:) = shiftdim(strctTrial.point2(:,:,2));
                    strctTrial.coordinatesY(3,:,:) = shiftdim(strctTrial.point3(:,:,2));
                    strctTrial.coordinatesY(4,:,:) = shiftdim(strctTrial.point4(:,:,2));
            
  
       elseif strctTrial.numFrames > 1 && g_strctParadigm.m_bRandPosEachFrame == 0;
            for iNumOfBars = 1:strctTrial.m_iNumberOfBars
                % Calculate coordinates for every frame
                
                strctTrial.coordinatesX(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,1) -...
                    (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point1(iNumOfBars,1)-...
                    (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                    ...
                    round(linspace(strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                    round(linspace(strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                    round(linspace(strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)));
                
                strctTrial.coordinatesY(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,2) - ...
                    (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point1(iNumOfBars,2)-...
                    (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
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
%        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps));
        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps+1));
        [strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
        
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(1,iNumOfBars,1),strctTrial.bar_rect(1,iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(1,iNumOfBars,3),strctTrial.bar_rect(1,iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));

            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(1,iNumOfBars,2),strctTrial.bar_rect(1,iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(1,iNumOfBars,4),strctTrial.bar_rect(1,iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));

            [firstBlurCoordsPoint1(1,:), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
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
    %Felix added for cloud stimuli
elseif strctTrial.DualstimPrimaryuseRGBCloud==1
    %   strctTrial.DualStimPrimaryCloud = mk_spatialcloudRGB(strctTrial.m_iWidth, strctTrial.m_iLength, strctTrial.numFrames, spatialscale);
    %   strctTrial.DualStimPrimaryCloud = mk_spatialcloudRGB(round(sqrt(g_strctParadigm.DualstimStimulusArea.Buffer(1,:,g_strctParadigm.DualstimStimulusArea.BufferIdx))), ...
    %         round(sqrt(g_strctParadigm.DualstimStimulusArea.Buffer(1,:,g_strctParadigm.DualstimStimulusArea.BufferIdx))), strctTrial.numFrames, spatialscale);
%     strctTrial.DualStimPrimaryCloud = mk_spatialcloudRGB(25, 25, strctTrial.numFrames, spatialscale)-.5;
%     Cloud_temp=reshape(strctTrial.DualStimPrimaryCloud,3,strctTrial.numFrames*25*25);
%     strctTrial.DualStimPrimaryCloud = reshape(ldrgyv2rgb(Cloud_temp(1,:),Cloud_temp(2,:),Cloud_temp(3,:)),3,25,25,strctTrial.numFrames);
    %     [Cloud_temp(1,:),Cloud_temp(2,:),Cloud_temp(3,:)] =rgb2ldrgyv(reshape(strctTrial.DualStimPrimaryCloud,3,strctTrial.numFrames*25*25));
    %     strctTrial.DualStimPrimaryCloud = reshape(Cloud_temp,25,25,strctTrial.numFrames,3);
    spatialscale2 = round(sqrt(fnTsGetVar('g_strctParadigm','DualstimScale')));

    strctTrial.DualStimPrimaryCloud = 2*(mk_spatialcloudRGB(25, 25, strctTrial.numFrames, spatialscale2)-.5);
    lv_in=strctTrial.DualStimPrimaryCloud(:,:,:,1);
    rg_in=strctTrial.DualStimPrimaryCloud(:,:,:,2);
    yv_in=strctTrial.DualStimPrimaryCloud(:,:,:,3);
    strctTrial.DualStimPrimaryCloud = shiftdim(reshape(ldrgyv2rgb(lv_in(:)',rg_in(:)',yv_in(:)'),3,25,25,strctTrial.numFrames),1).*255;

    % Felix note: linear clut: for testing purposes only
%         linearclut=linspace(0,65535,256)';
%         strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);

    
end
%}
%toc
% dbstop if warning
% warning('test')
return;
%}

% New version of Dualstim:
function [strctTrial] = fnPrepareDualstimTrial(g_strctPTB, strctTrial)
tic
global g_strctParadigm

% try
% if isempty(g_strctParadigm.hartleys_local) %~exist('g_strctParadigm.hartleyset','var') | 
%     fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
%     fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);
% end
% catch
%     fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
%     fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);
% end

strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.DualstimWidth.Buffer(1,:,g_strctParadigm.DualstimWidth.BufferIdx)); %keep stimuli squared
strctTrial.m_iWidth = squeeze(g_strctParadigm.DualstimWidth.Buffer(1,:,g_strctParadigm.DualstimWidth.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.DualstimStimulusOnTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.DualstimStimulusOffTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOffTime.BufferIdx);
strctTrial.numFrames=g_strctParadigm.DualstimTrialLength;
strctTrial.ContinuousDisplay = fnTsGetVar('g_strctParadigm','ContinuousDisplay');
strctTrial.CSDtrigframe = fnTsGetVar('g_strctParadigm','CSDtrigframe');

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
    %strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
    %         %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
    
    % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    
    currentBlockStimBGColorsR = ['DualstimBackgroundRed'];
    currentBlockStimBGColorsG = ['DualstimBackgroundGreen'];
    currentBlockStimBGColorsB = ['DualstimBackgroundBlue'];

    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    strctTrial.m_afBackgroundColor = floor(strctTrial.m_afLocalBackgroundColor/255)*65535;
else
    strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
end
% dbstop if warning
% warning('stop')

[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);
toc

tic
%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','DualstimStimulusArea');
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;

winoffset = mod(fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea'), fnTsGetVar('g_strctParadigm','cloudpix'));
strctTrial.m_aiSecondaryStimulusArea = fnTsGetVar('g_strctParadigm','DualstimSecondaryStimulusArea')+winoffset;

strctTrial.m_aiCenterOfSecondaryStimulus = fnTsGetVar('g_strctParadigm','SecondaryStimulusPosition');
g_strctParadigm.m_aiSecondaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)+(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiSecondaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)+(strctTrial.m_aiSecondaryStimulusArea/2);
% g_strctParadigm.m_aiSecondaryStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiSecondaryStimulusRect);
g_strctParadigm.m_aiSecondaryStimulusRect = g_strctParadigm.m_aiSecondaryStimulusRect;
strctTrial.secondarystim_bar_rect(1,1:4) =  g_strctParadigm.m_aiSecondaryStimulusRect;

strctTrial.m_aiCenterOfTertiaryStimulus = fnTsGetVar('g_strctParadigm','TertiaryStimulusPosition');
g_strctParadigm.m_aiTertiaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)-(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)+(strctTrial.m_aiSecondaryStimulusArea/2);
g_strctParadigm.m_aiTertiaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)+(strctTrial.m_aiSecondaryStimulusArea/2);
% g_strctParadigm.m_aiTertiaryStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiTertiaryStimulusRect);
g_strctParadigm.m_aiTertiaryStimulusRect = g_strctParadigm.m_aiTertiaryStimulusRect;
strctTrial.tertiarystim_bar_rect(1,1:4) =  g_strctParadigm.m_aiTertiaryStimulusRect;

strctTrial.DualStimSecondaryori = zeros(1,strctTrial.numFrames);
%spatialscale = round(sqrt(fnTsGetVar('g_strctParadigm','DualstimSecondaryBarWidth')));
strctTrial.DualstimPrimaryuseRGBCloud = fnTsGetVar('g_strctParadigm','DualstimPrimaryuseRGBCloud');
toc


switch strctTrial.DualstimPrimaryuseRGBCloud
    case 0 %use ground truth
    
        strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.DualstimNumberOfBars.Buffer(1,:,g_strctParadigm.DualstimNumberOfBars.BufferIdx));
            if g_strctParadigm.m_bGroundtruthCISonly==1
            strctTrial.m_iNumberOfBars=12;
            curcols = [randperm(6,6),randperm(6,6)]+2;
            else
            curcols = randi(16,strctTrial.m_iNumberOfBars,1);
            end

        strctTrial.m_aiLocalBlurStepHolder = zeros(3,strctTrial.m_iNumberOfBars,strctTrial.numFrames);
        strctTrial.m_aiBlurStepHolder = zeros(3,strctTrial.m_iNumberOfBars,strctTrial.numFrames);

        for iNumBars = 1 : strctTrial.m_iNumberOfBars
        % Felix note; replace THIS with semirandom sequence
        strctTrial.m_aiLocalBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = repmat(g_strctParadigm.m_cPresetColorList(curcols(iNumBars),:),strctTrial.numFrames,1)';
%        strctTrial.m_aiBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = deal(curcols(iNumBars)-1);
        strctTrial.m_aiBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = (65535/255)*repmat(g_strctParadigm.m_cPresetColorList(curcols(iNumBars),:),strctTrial.numFrames,1)';
        end
        
%         if strctTrial.m_iNumberOfBars > 3
%         strctTrial.m_aiLocalBlurStepHolder(1:3,2,1:strctTrial.numFrames) = repmat(g_strctParadigm.m_cPresetColorList(curcols(1),:),strctTrial.numFrames,1)';
%         strctTrial.m_aiBlurStepHolder(1:3,2,1:strctTrial.numFrames) = deal(curcols(1)-1);
%         end

        %/{
        strctTrial.m_iMoveDistance = 0; %(strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;
        strctTrial.m_bRandomStimulusOrientation = g_strctParadigm.m_bRandomStimulusOrientation;
        strctTrial.m_bCycleStimulusOrientation = g_strctParadigm.m_bCycleStimulusOrientation;
        strctTrial.m_bReverseCycleStimulusOrientation = g_strctParadigm.m_bReverseCycleStimulusOrientation;
        strctTrial.m_iOrientationBin = [];
        strctTrial.m_fRotationAngle = 0; %squeeze(g_strctParadigm.CIHandmapperOrientation.Buffer(1,:,g_strctParadigm.CIHandmapperOrientation.BufferIdx));
        g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;
        %}

        xrange=range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
        yrange=range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
        if yrange<=0; yrange=1; end; if xrange<=1; xrange=1; end

        n_xpos=floor(xrange/strctTrial.m_iLength);
        n_ypos=floor(yrange/strctTrial.m_iWidth);
        if n_xpos<=0; n_xpos=1; end; if n_ypos<=1; n_ypos=1; end
        
        %add frame-by-frame pixel shifts

        strctTrial.m_fspatialXoffset = randi(strctTrial.m_iLength)-1;
        strctTrial.m_fspatialYoffset = randi(strctTrial.m_iWidth)-1;
        
        for iNumBars = 1 : strctTrial.m_iNumberOfBars
            strctTrial.location_x(1:strctTrial.numFrames,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+strctTrial.m_iLength*randi(n_xpos)+strctTrial.m_iLength/2+strctTrial.m_fspatialXoffset;
            strctTrial.location_y(1:strctTrial.numFrames,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+strctTrial.m_iWidth*randi(n_ypos)+strctTrial.m_iWidth/2+strctTrial.m_fspatialYoffset;
        %strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth.*temp_ypos(ff)+strctTrial.m_iWidth/2;
            for ff=1:1:strctTrial.numFrames
            strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(ff,iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars)  - strctTrial.m_iWidth/2), ...
                (strctTrial.location_x(ff,iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars) + strctTrial.m_iWidth/2)];
            end
        end

        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
        for ff=1:strctTrial.numFrames
            for iNumOfBars = 1:strctTrial.m_iNumberOfBars
                [strctTrial.point1(ff,iNumOfBars,1), strctTrial.point1(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point2(ff,iNumOfBars,1), strctTrial.point2(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point3(ff,iNumOfBars,1), strctTrial.point3(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point4(ff,iNumOfBars,1), strctTrial.point4(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.bar_starting_point(ff,iNumOfBars,1),strctTrial.bar_starting_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.bar_ending_point(ff,iNumOfBars,1),strctTrial.bar_ending_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
            end
        end
                     
        strctTrial.coordinatesX(1,:,:) = shiftdim(strctTrial.point1(:,:,1));
        strctTrial.coordinatesX(2,:,:) = shiftdim(strctTrial.point2(:,:,1));
        strctTrial.coordinatesX(3,:,:) = shiftdim(strctTrial.point3(:,:,1));
        strctTrial.coordinatesX(4,:,:) = shiftdim(strctTrial.point4(:,:,1));
        strctTrial.coordinatesY(1,:,:) = shiftdim(strctTrial.point1(:,:,2));
        strctTrial.coordinatesY(2,:,:) = shiftdim(strctTrial.point2(:,:,2));
        strctTrial.coordinatesY(3,:,:) = shiftdim(strctTrial.point3(:,:,2));
        strctTrial.coordinatesY(4,:,:) = shiftdim(strctTrial.point4(:,:,2));
    % }
        linearclut=linspace(0,65535,256)';
        strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
        
    case 1 %use bar stimuli

    strctTrial.cur_ori=fnTsGetVar('g_strctParadigm' ,'DualstimOrientation'); 
    strctTrial.cur_oribin=floor(strctTrial.cur_ori./15)+1;
        
%     strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chrombar_n,1,round(strctTrial.numFrames/2)),2,1);
%     strctTrial.stimseq=strctTrial.stimseq(:);
% 
%     nbars=60;
%     randseed=rand(1,g_strctParadigm.Dualstim_pregen_chrombar_n*nbars);
%     randseed2 = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
%     strctTrial.barmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
%     pvec_edges=[0 cumsum(g_strctParadigm.barprobs_lum)];
%     for pp=1:7
%         cur_indxs=find(randseed>=pvec_edges(pp) & randseed<pvec_edges(pp+1));
%         randseed2(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKLCLUT(pp,:),length(cur_indxs),1);
%         strctTrial.barmat(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKL(pp,:),length(cur_indxs),1);
%     end
%     strctTrial.m_aiCLUT=zeros(g_strctParadigm.Dualstim_pregen_chrombar_n,256,3);
%     strctTrial.m_aiCLUT(:,2,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
%     strctTrial.m_aiCLUT(:,3:nbars+2,:)=reshape(randseed2,g_strctParadigm.Dualstim_pregen_chrombar_n,nbars,3);
%     strctTrial.m_aiCLUT(:,126:255,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
%     strctTrial.m_aiCLUT(:,256,:) = deal(65535);
    
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_ETbars_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);

    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);

    case 2 %use color bar stimuli

    strctTrial.cur_ori=fnTsGetVar('g_strctParadigm' ,'DualstimOrientation'); 
    strctTrial.cur_oribin=floor(strctTrial.cur_ori./15)+1;
        
%     strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chrombar_n,1,round(strctTrial.numFrames/2)),2,1);
%     strctTrial.stimseq=strctTrial.stimseq(:);



% new code - just uses one set of textures and generates new CLUT for display texture
%     nbars=60;
%     randseed=rand(1,g_strctParadigm.Dualstim_pregen_chrombar_n*nbars);
%     randseed2 = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
%     strctTrial.barmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
%     pvec_edges=[0 cumsum(g_strctParadigm.barprobs)];
%     for pp=1:7
%         cur_indxs=find(randseed>=pvec_edges(pp) & randseed<pvec_edges(pp+1));
%         randseed2(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKLCLUT(pp,:),length(cur_indxs),1);
%         strctTrial.barmat(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKL(pp,:),length(cur_indxs),1);
%     end
%     strctTrial.m_aiCLUT=zeros(g_strctParadigm.Dualstim_pregen_chrombar_n,256,3);
%     strctTrial.m_aiCLUT(:,2,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
%     strctTrial.m_aiCLUT(:,3:nbars+2,:)=reshape(randseed2,g_strctParadigm.Dualstim_pregen_chrombar_n,nbars,3);
%     strctTrial.m_aiCLUT(:,126:255,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
%     strctTrial.m_aiCLUT(:,256,:) = deal(65535);
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_ETbars_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);

    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
            
    case 3 %use Lum-axis hartleys
            strctTrial.stimseq=repmat(randi(384,1,round(strctTrial.numFrames/2)),2,1);
%            strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2)),2,1);
            strctTrial.stimseq=strctTrial.stimseq(:);
        %   curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
        %    strctTrial.Dualstimstim = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
        %    strctTrial.Dualstimstim_disp = g_strctParadigm.hartleyset.hartleys_binned(:,:,curseq)+8;
%         strctTrial.m_aiCLUT = zeros(256,3);
%         strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
%         strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
%         strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
%         strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
%         strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
%         strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
%         strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
%         strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
%         strctTrial.m_aiCLUT(256,:) = deal(65535);
            linearclut=linspace(0,65535,256)';
            strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
            
        %strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

    case 4 %use L-M axis hartleys
            strctTrial.stimseq=repmat(randi(384,1,round(strctTrial.numFrames/2))+384,2,1);
%            strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2))+length(g_strctParadigm.hartleyset.hartleys_binned),2,1);
            strctTrial.stimseq=strctTrial.stimseq(:);
        %   curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
        %    strctTrial.Dualstimstim = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
        %    strctTrial.Dualstimstim_disp = g_strctParadigm.hartleyset.hartleys_binned(:,:,curseq)+8;
%         strctTrial.m_aiCLUT = zeros(256,3);
%         strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
%         strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
%         strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
%         strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
%         strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
%         strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
%         strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
%         strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
%         strctTrial.m_aiCLUT(256,:) = deal(65535);
            linearclut=linspace(0,65535,256)';
            strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
            
        %strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

    case 5 %use S-axis hartleys
            strctTrial.stimseq=repmat(randi(384,1,round(strctTrial.numFrames/2))+2*384,2,1);
            strctTrial.stimseq=strctTrial.stimseq(:);
        %   curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
        %    strctTrial.Densenoisestim = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
        %    strctTrial.Densenoisestim_disp = g_strctParadigm.hartleyset.hartleys_binned(:,:,curseq)+8;
        
%         strctTrial.m_aiCLUT = zeros(256,3);
%         strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
%         strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
%         strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
%         strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
%         strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
%         strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
%         strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
%         strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
%         strctTrial.m_aiCLUT(256,:) = deal(65535);
            linearclut=linspace(0,65535,256)';
            strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
            
        %strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

    case 6 %use all color hartleys
            strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2)),2,1);
            strctTrial.stimseq=strctTrial.stimseq(:);

%         strctTrial.m_aiCLUT = zeros(256,3);
%         strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
%         strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
%         strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
%         strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
%         strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
%         strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
%         strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
%         strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
%         strctTrial.m_aiCLUT(256,:) = deal(65535);
        
            linearclut=linspace(0,65535,256)';
            strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
        %strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

    case 7 % achromatic cloud
            if ~isfield(g_strctParadigm,'DensenoiseAchromcloud_binned')
                feval(g_strctParadigm.m_strCallbacks,'PregenACloudStimuli');
            end

        if g_strctParadigm.DualstimAchromcloudTrialnum > g_strctParadigm.DualstimBlockSizeTotal
                spatialscale=fnTsGetVar('g_strctParadigm' ,'DualstimScale');
                cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
        %        g_strctParadigm.DensenoiseAchromcloud = round((mk_spatialcloud(cloudpix,cloudpix, g_strctParadigm.Dualstim_pregen_achromcloud_n, spatialscale)./2 +.5).*255);
        %        [~,g_strctParadigm.DensenoiseAchromcloud_binned] = histc(g_strctParadigm.DensenoiseAchromcloud,linspace(0,255,256));

        %        fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
        %        fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned);

            g_strctParadigm.DualstimAchromcloud_stimseqs=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,g_strctParadigm.DualstimBlockSize,ceil(g_strctParadigm.DualstimTrialLength/2)),2,1);
            g_strctParadigm.DualstimAchromcloud_trialindex = [randperm(g_strctParadigm.DualstimBlockSize),randperm(g_strctParadigm.DualstimBlockSize)];
            g_strctParadigm.DualstimAchromcloudBlocknum=g_strctParadigm.DualstimAchromcloudBlocknum+1;
                    if g_strctParadigm.DualstimChromcloudBlocknum>g_strctParadigm.maxblocks; g_strctParadigm.DualstimChromcloudBlocknum=1; end
            g_strctParadigm.DualstimAchromcloudTrialnum=1;

            load([g_strctParadigm.NoiseStimDir '\' sprintf('Cloudstims_Achrom_size%d_scale%d_%02d.mat', cloudpix, spatialscale, 1)],'DensenoiseAchromcloud_binned');
            g_strctParadigm.DensenoiseAchromcloud_binned = DensenoiseAchromcloud_binned; clearvars DensenoiseAchromcloud_binned

            fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud_binned, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
            fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud_binned, g_strctParadigm.DensenoiseAchromcloud_binned);

        end

        strctTrial.BlockID = g_strctParadigm.DualstimAchromcloudBlocknum;
        strctTrial.TrialID = g_strctParadigm.DualstimAchromcloudTrialnum;
        strctTrial.stimseq=repmat(g_strctParadigm.DualstimAchromcloud_stimseqs(g_strctParadigm.DualstimAchromcloud_trialindex(g_strctParadigm.DualstimAchromcloudTrialnum),:),2,1);
        strctTrial.stimseq=strctTrial.stimseq(:);
        g_strctParadigm.DualstimAchromcloudTrialnum = g_strctParadigm.DualstimAchromcloudTrialnum+1;

            linearclut=linspace(0,65535,256)';
            strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
        %    strctTrial.stimuli=g_strctParadigm.DensenoiseAchromcloud_binned(:,:,strctTrial.stimseq,:);

    case 8 %use color cloud 
        if ~isfield(g_strctParadigm,'DensenoiseChromcloud')
            feval(g_strctParadigm.m_strCallbacks,'PregenCCloudStimuli');
        end

        % % Just generate sequence of prelaoded color frames (no repeats)
        %    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
        %    strctTrial.stimseq=strctTrial.stimseq(:);

        if g_strctParadigm.DualstimChromcloudTrialnum > g_strctParadigm.DualstimBlockSizeTotal
            %{
                g_strctParadigm.Cur_CCloud_loaded = 'randpregen';
                spatialscale=fnTsGetVar('g_strctParadigm' ,'DualstimScale');
                cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
                g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(mk_spatialcloudRGB(cloudpix, cloudpix, g_strctParadigm.Dualstim_pregen_chromcloud_n, spatialscale),cloudpix*cloudpix*g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
                DensenoiseChromcloud_sums=sum(abs(g_strctParadigm.DensenoiseChromcloud_DKlspace),2); DensenoiseChromcloud_sums(DensenoiseChromcloud_sums < 1)=1;
                g_strctParadigm.DensenoiseChromcloud_DKlspace=g_strctParadigm.DensenoiseChromcloud_DKlspace./[DensenoiseChromcloud_sums,DensenoiseChromcloud_sums,DensenoiseChromcloud_sums];
                g_strctParadigm.DensenoiseChromcloud=reshape(round(255.*ldrgyv2rgb(g_strctParadigm.DensenoiseChromcloud_DKlspace(:,1)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,2)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,3)'))',cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
                g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(g_strctParadigm.DensenoiseChromcloud_DKlspace,cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);

            fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
            fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);
            %}
            g_strctParadigm.DualstimChromcloud_stimseqs=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,g_strctParadigm.DualstimBlockSize,ceil(g_strctParadigm.DualstimTrialLength/2)),2,1);
            g_strctParadigm.DualstimChromcloud_trialindex = [randperm(g_strctParadigm.DualstimBlockSize),randperm(g_strctParadigm.DualstimBlockSize)];
            g_strctParadigm.DualstimChromcloudBlocknum=g_strctParadigm.DualstimChromcloudBlocknum+1;
                if g_strctParadigm.DualstimChromcloudBlocknum>g_strctParadigm.maxblocks; g_strctParadigm.DualstimChromcloudBlocknum=1; end
            g_strctParadigm.DualstimChromcloudTrialnum=1;

            %/{
                g_strctParadigm.Cur_CCloud_loaded = g_strctParadigm.NoiseStimDir;
                spatialscale=fnTsGetVar('g_strctParadigm' ,'DensenoiseScale');
                cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
                load([g_strctParadigm.NoiseStimDir '\' sprintf('Cloudstims_Chrom_size%d_scale%d_%02d.mat', cloudpix, spatialscale, g_strctParadigm.DualstimChromcloudBlocknum)], 'DensenoiseChromcloud');
                g_strctParadigm.DensenoiseChromcloud = DensenoiseChromcloud; clearvars DensenoiseChromcloud
                fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
                fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);
            %}
end

%tic
strctTrial.BlockID = g_strctParadigm.DualstimChromcloudBlocknum;
strctTrial.TrialID = g_strctParadigm.DualstimChromcloudTrialnum;
strctTrial.stimseq=repmat(g_strctParadigm.DualstimChromcloud_stimseqs(g_strctParadigm.DualstimChromcloud_trialindex(g_strctParadigm.DualstimChromcloudTrialnum),:),2,1);
strctTrial.stimseq=strctTrial.stimseq(:);
g_strctParadigm.DualstimChromcloudTrialnum = g_strctParadigm.DualstimChromcloudTrialnum+1;

    strctTrial.Cur_CCloud_loaded = g_strctParadigm.Cur_CCloud_loaded;
%    strctTrial.stimuli=g_strctParadigm.DensenoiseChromcloud_DKlspace(:,:,strctTrial.stimseq,:);
%    strctTrial.stimuli_RGB=g_strctParadigm.DensenoiseChromcloud(:,:,strctTrial.stimseq,:);

    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
   
end


%spatialscale = round(sqrt(fnTsGetVar('g_strctParadigm','DualstimScale')));
strctTrial.DualstimSecondaryUseCloud = fnTsGetVar('g_strctParadigm','DualstimSecondaryUseCloud');
%switch strctTrial.DualstimSecondaryUseCloud

% Note: just pregenerating all sequences to avoid bugs when switching. No
% repeats to avoid bugs

% case 0: single-ori bars in each window 
       strctTrial.stimseq_ET_bars=repmat(randi(g_strctParadigm.Dualstim_pregen_ETbars_n,1,round(strctTrial.numFrames/2)),2,1);
       strctTrial.stimseq_ET_bars=strctTrial.stimseq_ET_bars(:);    
    
% case 1: alternating-ori bars in each window 
       %same as above  
       strctTrial.stimseq_ET_baroris = repmat([0 0 90 90],[1,ceil(strctTrial.numFrames/4)]);
       
% case 2: alternating-ori bars and achromatic cloud
        % same as above, plus:
        if ~isfield(g_strctParadigm,'DensenoiseAchromcloud_binned')
            feval(g_strctParadigm.m_strCallbacks,'PregenACloudStimuli');
        end

        if g_strctParadigm.DualstimAchromcloudTrialnum > g_strctParadigm.DualstimBlockSizeTotal
            %{
                spatialscale=fnTsGetVar('g_strctParadigm' ,'DualstimScale');
                cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
                g_strctParadigm.DensenoiseAchromcloud = round((mk_spatialcloud(cloudpix,cloudpix, g_strctParadigm.Dualstim_pregen_achromcloud_n, spatialscale)./2 +.5).*255);
                [~,g_strctParadigm.DensenoiseAchromcloud_binned] = histc(g_strctParadigm.DensenoiseAchromcloud,linspace(0,255,256));

                fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
                fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned);

            g_strctParadigm.DualstimAchromcloud_stimseqs=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,g_strctParadigm.DualstimBlockSize,ceil(g_strctParadigm.DualstimTrialLength/2)),2,1);
            g_strctParadigm.DualstimAchromcloud_trialindex = [randperm(g_strctParadigm.DualstimBlockSize),randperm(g_strctParadigm.DualstimBlockSize)];
            g_strctParadigm.DualstimAchromcloudBlocknum=g_strctParadigm.DualstimAchromcloudBlocknum+1;
            g_strctParadigm.DualstimAchromcloudTrialnum=1;
            %}
            spatialscale=fnTsGetVar('g_strctParadigm' ,'DualstimScale');
            cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');

            load([g_strctParadigm.NoiseStimDir '\' sprintf('Cloudstims_Achrom_size%d_scale%d_%02d.mat', cloudpix, spatialscale, 1)],'DensenoiseAchromcloud_binned');
            g_strctParadigm.DensenoiseAchromcloud_binned = DensenoiseAchromcloud_binned; clearvars DensenoiseAchromcloud_binned

            fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud_binned, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
            fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud_binned, g_strctParadigm.DensenoiseAchromcloud_binned);

        end

        % Just generate sequence of prelaoded color frames (no repeats)
       strctTrial.stimseq_ET_Aclouds=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
       strctTrial.stimseq_ET_Aclouds=strctTrial.stimseq_ET_Aclouds(:);
% case 3: achromatic cloud in both
    % everything set
% case 4: alternating-ori bars and color cloud
        if g_strctParadigm.DualstimChromcloudTrialnum > g_strctParadigm.DualstimBlockSizeTotal
            %{
                g_strctParadigm.Cur_CCloud_loaded = 'randpregen';
                spatialscale=fnTsGetVar('g_strctParadigm' ,'DualstimScale');
                cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
                g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(mk_spatialcloudRGB(cloudpix, cloudpix, g_strctParadigm.Dualstim_pregen_chromcloud_n, spatialscale),cloudpix*cloudpix*g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
                DensenoiseChromcloud_sums=sum(abs(g_strctParadigm.DensenoiseChromcloud_DKlspace),2); DensenoiseChromcloud_sums(DensenoiseChromcloud_sums < 1)=1;
                g_strctParadigm.DensenoiseChromcloud_DKlspace=g_strctParadigm.DensenoiseChromcloud_DKlspace./[DensenoiseChromcloud_sums,DensenoiseChromcloud_sums,DensenoiseChromcloud_sums];
                g_strctParadigm.DensenoiseChromcloud=reshape(round(255.*ldrgyv2rgb(g_strctParadigm.DensenoiseChromcloud_DKlspace(:,1)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,2)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,3)'))',cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
                g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(g_strctParadigm.DensenoiseChromcloud_DKlspace,cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);

            fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
            fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);

        %     g_strctParadigm.DualstimChromcloud_stimseqs=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,g_strctParadigm.DualstimBlockSize,ceil(g_strctParadigm.DualstimTrialLength/2)),2,1);
        %     g_strctParadigm.DualstimChromcloud_trialindex = [randperm(g_strctParadigm.DualstimBlockSize),randperm(g_strctParadigm.DualstimBlockSize)];
        %     g_strctParadigm.DualstimChromcloudBlocknum=g_strctParadigm.DualstimChromcloudBlocknum+1;
        %     g_strctParadigm.DualstimChromcloudTrialnum=1;
            %}    
            %/{
                g_strctParadigm.Cur_CCloud_loaded = g_strctParadigm.NoiseStimDir;
                spatialscale=fnTsGetVar('g_strctParadigm' ,'DensenoiseScale');
                cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
                load([g_strctParadigm.NoiseStimDir '\' sprintf('Cloudstims_Chrom_size%d_scale%d_%02d.mat', cloudpix, spatialscale, g_strctParadigm.DualstimChromcloudBlocknum)], 'DensenoiseChromcloud');
                g_strctParadigm.DensenoiseChromcloud = DensenoiseChromcloud; clearvars DensenoiseChromcloud
                fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
                fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);
            %}

        end
     % Just generate sequence of prelaoded color frames (no repeats)
       strctTrial.stimseq_ET_Cclouds=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
       strctTrial.stimseq_ET_Cclouds=strctTrial.stimseq_ET_Cclouds(:);
       
% case 5: color cloud in both
    % everything set
    
% case 6: color cloud in one, achromatic cloud in other
    % everything set
% end
toc

% dbstop if warning
% warning('stop')
return

% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPrepareCIHandmapperTrial(g_strctPTB, strctTrial)

global g_strctParadigm

strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.CIHandmapperLength.Buffer(1,:,g_strctParadigm.CIHandmapperLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.CIHandmapperWidth.Buffer(1,:,g_strctParadigm.CIHandmapperWidth.BufferIdx));
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.CIHandmapperNumberOfBars.Buffer(1,:,g_strctParadigm.CIHandmapperNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.CIHandmapperStimulusOnTime.Buffer(1,:,g_strctParadigm.CIHandmapperStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.CIHandmapperStimulusOffTime.Buffer(1,:,g_strctParadigm.CIHandmapperStimulusOffTime.BufferIdx);
strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));

strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.CIHandmapperMoveDistance.Buffer(1,:,g_strctParadigm.CIHandmapperMoveDistance.BufferIdx));
strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.CIHandmapperMoveSpeed.Buffer(1,:,g_strctParadigm.CIHandmapperMoveSpeed.BufferIdx));

if strctTrial.m_iMoveDistance >=1 && strctTrial.m_iMoveSpeed >=1
    strctTrial.numberBlurSteps = round(strctTrial.m_iMoveDistance/strctTrial.m_iMoveSpeed);
else 
    strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.CIHandmapperBlurSteps.Buffer(1,:,g_strctParadigm.CIHandmapperBlurSteps.BufferIdx)));
end

%Felix kludge - not worrying about blur for now
if strctTrial.numberBlurSteps >1
    strctTrial.m_bBlur  = 1;
else
    strctTrial.numberBlurSteps = 1; strctTrial.m_bBlur  = 0;
end

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
%     strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
    %         %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
    
    % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    
    currentBlockStimBGColorsR = ['CIHandmapperBackgroundRed'];
    currentBlockStimBGColorsG = ['CIHandmapperBackgroundGreen'];
    currentBlockStimBGColorsB = ['CIHandmapperBackgroundBlue'];
    
    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    strctTrial.m_afBackgroundColor = floor(strctTrial.m_afLocalBackgroundColor/255)*65535;
else
    strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
end

[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);



%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','CIHandmapperStimulusArea');
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(strctTrial.m_aiStimulusArea/2);
%g_strctParadigm.m_aiStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiStimulusRect);
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;

%{
    strctTrial.CIHandmapperNSminus = g_strctParadigm.CIHandmapperNSminus;
    strctTrial.CIHandmapperNSplus = g_strctParadigm.CIHandmapperNSplus;
    strctTrial.CIHandmapperNMminus = g_strctParadigm.CIHandmapperNMminus;
    strctTrial.CIHandmapperNMplus = g_strctParadigm.CIHandmapperNMplus;
    strctTrial.CIHandmapperNLminus = g_strctParadigm.CIHandmapperNLminus;
    strctTrial.CIHandmapperNLplus = g_strctParadigm.CIHandmapperNLplus;
    strctTrial.m_iNumberOfBars = ... %.Buffer(1,:,g_strctParadigm.CIHandmapperNumberOfBars.BufferIdx)
        (strctTrial.CIHandmapperNSminus.Buffer(1,:,g_strctParadigm.CIHandmapperNSminus.BufferIdx)+...
        strctTrial.CIHandmapperNSplus.Buffer(1,:,g_strctParadigm.CIHandmapperNSplus.BufferIdx)+...
        strctTrial.CIHandmapperNMminus.Buffer(1,:,g_strctParadigm.CIHandmapperNMminus.BufferIdx)+...
        strctTrial.CIHandmapperNMplus.Buffer(1,:,g_strctParadigm.CIHandmapperNMplus.BufferIdx)+...
        strctTrial.CIHandmapperNLminus.Buffer(1,:,g_strctParadigm.CIHandmapperNLminus.BufferIdx)+...
        strctTrial.CIHandmapperNLplus.Buffer(1,:,g_strctParadigm.CIHandmapperNLplus.BufferIdx));
    %fprintf([num2str(strctTrial.m_iNumberOfBars) '/']) %felix added as sanity check
    
    % populate Color lookup table
    NSm=fnTsGetVar('g_strctParadigm','CIHandmapperNSminus');%g_strctParadigm.CIHandmapperNSminus.Buffer(1,:,g_strctParadigm.CIHandmapperNSminus.BufferIdx);
    NSp=fnTsGetVar('g_strctParadigm','CIHandmapperNSplus');%g_strctParadigm.CIHandmapperNSplus.Buffer(1,:,g_strctParadigm.CIHandmapperNSplus.BufferIdx);
    NMm=fnTsGetVar('g_strctParadigm','CIHandmapperNMminus');%g_strctParadigm.CIHandmapperNMminus.Buffer(1,:,g_strctParadigm.CIHandmapperNMminus.BufferIdx);
    NMp=fnTsGetVar('g_strctParadigm','CIHandmapperNMplus');%g_strctParadigm.CIHandmapperNMplus.Buffer(1,:,g_strctParadigm.CIHandmapperNMplus.BufferIdx);
    NLm=fnTsGetVar('g_strctParadigm','CIHandmapperNLminus');%g_strctParadigm.CIHandmapperNLminus.Buffer(1,:,g_strctParadigm.CIHandmapperNLminus.BufferIdx);
    NLp=fnTsGetVar('g_strctParadigm','CIHandmapperNLplus');%g_strctParadigm.CIHandmapperNLplus.Buffer(1,:,g_strctParadigm.CIHandmapperNLplus.BufferIdx);
    strctTrial.numofeachCIS=[NSm,NSp,NMm,NMp,NLm,NLp];

    strctTrial.m_aiCLUT = zeros(256,3);
    strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
    dbstop if warning
    %warning('stop')
    iLastUsedCLUTOffset = g_strctParadigm.m_iCLUTOffset;
    strctTrial.m_iActiveStimulusBars = length(find(strctTrial.numofeachCIS)); % = 0;
    strctTrial.m_iBarPresentationOrder = randperm(6);
    
    % if NSm>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*[255, 0, 0];
    strctTrial.NSmClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NSp>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*[0,154,38];
    strctTrial.NSpClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NMm>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*[0, 252, 0];
    strctTrial.NMmClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NMp>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*[255, 0, 55];
    strctTrial.NMpClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NLm>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*[148, 0, 255];
    strctTrial.NLmClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    % if NLp>0
    iLastUsedCLUTOffset = iLastUsedCLUTOffset + 1;
    strctTrial.m_aiCLUT(iLastUsedCLUTOffset,:) = (65535/255)*[52, 209, 0];
    strctTrial.NLpClutIndex = iLastUsedCLUTOffset-1;
    % 	strctTrial.m_iActiveStimulusBars = strctTrial.m_iActiveStimulusBars + 1;
    % end
    strctTrial.m_aiCLUT(256,:) = deal(65535);
    strctTrial.m_aiLocalBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
    strctTrial.m_aiBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
    for iFrames = 1:strctTrial.numFrames
        %	if NSm>0
        strctTrial.m_aiLocalBlurStepHolder(1:3,strctTrial.NSmClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = floor(strctTrial.m_aiCLUT(strctTrial.NSmClutIndex,:)/255);
        strctTrial.m_aiBlurStepHolder(1:3,strctTrial.NSmClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = deal(strctTrial.NSmClutIndex);
        %     end
        % 	if NSp>0
        strctTrial.m_aiLocalBlurStepHolder(1:3,strctTrial.NSpClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = floor(strctTrial.m_aiCLUT(strctTrial.NSpClutIndex,:)/255);
        strctTrial.m_aiBlurStepHolder(1:3,strctTrial.NSpClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = deal(strctTrial.NSpClutIndex);
        %     end
        % 	if NMm>0
        strctTrial.m_aiLocalBlurStepHolder(1:3,strctTrial.NMmClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = floor(strctTrial.m_aiCLUT(strctTrial.NMmClutIndex,:)/255);
        strctTrial.m_aiBlurStepHolder(1:3,strctTrial.NMmClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = deal(strctTrial.NMmClutIndex);
        %     end
        % 	if NMp>0
        strctTrial.m_aiLocalBlurStepHolder(1:3,strctTrial.NMpClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = floor(strctTrial.m_aiCLUT(strctTrial.NMpClutIndex,:)/255);
        strctTrial.m_aiBlurStepHolder(1:3,strctTrial.NMpClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = deal(strctTrial.NMpClutIndex);
        %     end
        % 	if NLm>0
        strctTrial.m_aiLocalBlurStepHolder(1:3,strctTrial.NLmClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = floor(strctTrial.m_aiCLUT(strctTrial.NLmClutIndex,:)/255);
        strctTrial.m_aiBlurStepHolder(1:3,strctTrial.NLmClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = deal(strctTrial.NLmClutIndex);
        %     end
        % 	if NLp>0
        strctTrial.m_aiLocalBlurStepHolder(1:3,strctTrial.NLpClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = floor(strctTrial.m_aiCLUT(strctTrial.NLpClutIndex,:)/255);
        strctTrial.m_aiBlurStepHolder(1:3,strctTrial.NLpClutIndex-(g_strctParadigm.m_iCLUTOffset-1),iFrames) = deal(strctTrial.NLpClutIndex);
        %     end
    end  
%}  
    % Felix added replacement for many CI stim inputs
    strctTrial.m_aiCLUT = zeros(256,3);
    strctTrial.m_aiCLUT(2,:) = [128 128 128]*(65535/255);
%    strctTrial.m_aiCLUT(3,:) = (65535/255)*[fnTsGetVar('g_strctParadigm' ,'CIHandmapperStimulusRed'),fnTsGetVar('g_strctParadigm' ,'CIHandmapperStimulusGreen'),fnTsGetVar('g_strctParadigm' ,'CIHandmapperStimulusBlue')];
     strctTrial.m_aiCLUT(3,:) = g_strctParadigm.m_cPresetColors{1,1}*(65535/255);
    strctTrial.m_aiCLUT(4,:) = g_strctParadigm.m_cPresetColors{1,2}*(65535/255);
    strctTrial.m_aiCLUT(5,:) = g_strctParadigm.m_cPresetColors{2,1}*(65535/255);
    strctTrial.m_aiCLUT(6,:) = g_strctParadigm.m_cPresetColors{2,2}*(65535/255);
    strctTrial.m_aiCLUT(7,:) = g_strctParadigm.m_cPresetColors{3,1}*(65535/255);
    strctTrial.m_aiCLUT(8,:) = g_strctParadigm.m_cPresetColors{3,2}*(65535/255);
strctTrial.m_aiCLUT(9,:) = g_strctParadigm.m_cPresetColors{4,1}*(65535/255); % DKL0
strctTrial.m_aiCLUT(10,:) = g_strctParadigm.m_cPresetColors{4,2}*(65535/255); % DKL45
strctTrial.m_aiCLUT(11,:) = g_strctParadigm.m_cPresetColors{4,3}*(65535/255); % DKL90
strctTrial.m_aiCLUT(12,:) = g_strctParadigm.m_cPresetColors{4,4}*(65535/255); % DKL135
strctTrial.m_aiCLUT(13,:) = g_strctParadigm.m_cPresetColors{4,5}*(65535/255); % DKL180
strctTrial.m_aiCLUT(14,:) = g_strctParadigm.m_cPresetColors{4,6}*(65535/255); % DKL225
strctTrial.m_aiCLUT(15,:) = g_strctParadigm.m_cPresetColors{4,7}*(65535/255); % DKL270
strctTrial.m_aiCLUT(16,:) = g_strctParadigm.m_cPresetColors{4,8}*(65535/255); % DKL315
strctTrial.m_aiCLUT(17,:) = deal(65535);

strctTrial.m_aiCLUT(256,:) = deal(65535);
    %dbstop if warning
    %warning('stop')
    iLastUsedCLUTOffset = g_strctParadigm.m_iCLUTOffset;

    strctTrial.m_aiLocalBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
    strctTrial.m_aiBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
    
    FGtargcolor=fnTsGetVar('g_strctParadigm','CIHandmapperStimulusIndex');
    strctTrial.BGtargcolor=fnTsGetVar('g_strctParadigm','CIHandmapperBackgroundIndex');

        for iFrames = 1:strctTrial.numFrames
        strctTrial.m_aiLocalBlurStepHolder(1:3,1,iFrames) = floor(strctTrial.m_aiCLUT(FGtargcolor+1,:)*(255/65535));
        strctTrial.m_aiBlurStepHolder(1:3,1,iFrames) = deal(FGtargcolor);
        end

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
    strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.CIHandmapperOrientation.Buffer(1,:,g_strctParadigm.CIHandmapperOrientation.BufferIdx));
end
g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;

if strctTrial.m_bRandomStimulusPosition
    %minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iWidth)/2;
    for iNumBars = 1 : strctTrial.m_iNumberOfBars
        % Random center points
        xrange= range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
        yrange= range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
        if yrange<=0; yrange=1; end; if xrange<=1; xrange=1; end

        strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ randi(xrange);
        strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ randi(yrange);
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
    
    
    
    % what's going on here?
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
%{
%        strctTrial.m_iMoveDistance = (strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;
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
        strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.CIHandmapperOrientation.Buffer(1,:,g_strctParadigm.CIHandmapperOrientation.BufferIdx));
    end
    g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;
    
    xrange=range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
    yrange=range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
    if yrange<=0; yrange=1; end; if xrange<=1; xrange=1; end
    
   
    if strctTrial.m_bRandomStimulusPosition == 1
        minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iWidth)/2;
        
%{
        if g_strctParadigm.m_bRandPosEachFrame == 1;
            [strctTrial.location_x,strctTrial.location_y] = deal(zeros(strctTrial.numFrames, strctTrial.m_iNumberOfBars));
            strctTrial.location_x(1,:) = strctTrial.bar_rect(1)+ round(rand*range([strctTrial.bar_rect(1),strctTrial.bar_rect(3)]));
            strctTrial.location_y(1,:) = strctTrial.bar_rect(2)+ round(rand*range([strctTrial.bar_rect(2),strctTrial.bar_rect(4)]));

            for ff=1:strctTrial.numFrames
                for iNumBars = 2 : strctTrial.m_iNumberOfBars
                    for tries=1:10
                        if abs(min(strctTrial.location_x(ff,1:iNumBars-1)) - strctTrial.location_x(ff,iNumBars)) < minimum_seperation ||...
                                abs(min(strctTrial.location_y(ff,1:iNumBars-1)) - strctTrial.location_y(ff,iNumBars)) < minimum_seperation
                            % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                            % So we'll just try 5 times and hope for the best
                            strctTrial.location_x(ff,iNumBars) = strctTrial.bar_rect(1)+ randi(range([strctTrial.bar_rect(1),strctTrial.bar_rect(3)]));
                            strctTrial.location_y(ff,iNumBars) = strctTrial.bar_rect(2)+ randi(range([strctTrial.bar_rect(2),strctTrial.bar_rect(4)]));
                        else
                            break;
                        end
                    end
                end
            end
%}
        if g_strctParadigm.m_bRandPosEachFrame == 1;
            
            for ff=1:strctTrial.numFrames
                strctTrial.location_x(ff,1) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
                strctTrial.location_y(ff,1) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
                strctTrial.bar_rect(ff,1,1:4) = [(strctTrial.location_x(ff,1) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,1)  - strctTrial.m_iWidth/2), ...
                    (strctTrial.location_x(ff,1) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,1) + strctTrial.m_iWidth/2)];
                
                for iNumBars = 2 : strctTrial.m_iNumberOfBars
                    strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
                    strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
                    
                    for tries=1:10
                        if abs(min(strctTrial.location_x(ff,1:iNumBars-1)) - strctTrial.location_x(ff,iNumBars)) < minimum_seperation ||...
                                abs(min(strctTrial.location_y(ff,1:iNumBars-1)) - strctTrial.location_y(ff,iNumBars)) < minimum_seperation
                            % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                            % So we'll just try 5 times and hope for the best
                            strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
                            strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
                        else
                            break;
                        end
                    end
                    strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth/2), ...
                        (strctTrial.location_x(iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth/2)];
                    
                end
            end           
        else
            strctTrial.location_x(1) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
            strctTrial.location_y(1) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
            strctTrial.bar_rect(1,1,1:4) = [(strctTrial.location_x(1) - strctTrial.m_iLength/2), (strctTrial.location_y(1)  - strctTrial.m_iWidth/2), ...
                (strctTrial.location_x(1) + strctTrial.m_iLength/2), (strctTrial.location_y(1) + strctTrial.m_iWidth/2)];
            
            for iNumBars = 2 : strctTrial.m_iNumberOfBars
                % Random center points
                if g_strctParadigm.m_bStimulusCollisions == 0; maxtries = 15; else maxtries=5; end %Felix kludge
                strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
                strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
                for tries=1:10
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
                strctTrial.bar_rect(1,iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth/2), ...
                    (strctTrial.location_x(iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth/2)];
                
            end
        end
    else %only draw one bar, in the middle of the rect
        strctTrial.m_iNumberOfBars = 1;
        strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
        strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);
        strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2), ...
            (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
    end
    
    if ~strctTrial.m_bBlur
        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
        %{
        if strctTrial.m_iNumberOfBars == 1
            [strctTrial.point1(1,1), strctTrial.point1(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.point2(1,1), strctTrial.point2(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.point3(1,1), strctTrial.point3(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.point4(1,1), strctTrial.point4(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            [strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
            
        elseif strctTrial.numFrames > 1;% && g_strctParadigm.m_bRandPosEachFrame == 1;
        %}
        if strctTrial.m_iNumberOfBars>1
        for ff=1:strctTrial.numFrames
            for iNumOfBars = 1:strctTrial.m_iNumberOfBars
                [strctTrial.point1(ff,iNumOfBars,1), strctTrial.point1(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point2(ff,iNumOfBars,1), strctTrial.point2(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point3(ff,iNumOfBars,1), strctTrial.point3(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.point4(ff,iNumOfBars,1), strctTrial.point4(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.bar_starting_point(ff,iNumOfBars,1),strctTrial.bar_starting_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
                [strctTrial.bar_ending_point(ff,iNumOfBars,1),strctTrial.bar_ending_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);

                % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
            end
        end
        else
        for ff=1:strctTrial.numFrames
            iNumOfBars=1;
            [strctTrial.point1(ff,iNumOfBars,1), strctTrial.point1(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,1),strctTrial.bar_rect(ff,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point2(ff,iNumOfBars,1), strctTrial.point2(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,1),strctTrial.bar_rect(ff,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point3(ff,iNumOfBars,1), strctTrial.point3(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,3),strctTrial.bar_rect(ff,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point4(ff,iNumOfBars,1), strctTrial.point4(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,3),strctTrial.bar_rect(ff,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.bar_starting_point(ff,iNumOfBars,1),strctTrial.bar_starting_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.bar_ending_point(ff,iNumOfBars,1),strctTrial.bar_ending_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);

            % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
        end            
        end
   
        %end
        % Check if the trial has more than 1 frame in it, so we can plan the trial
        if strctTrial.numFrames > 1 && g_strctParadigm.m_bRandPosEachFrame == 1; %Felix note: where the magic may not be happening
            %        strctTrial.coordinatesX(1:4,:,:) = [strctTrial.point1(:,:,1), strctTrial.point2(:,:,1), strctTrial.point3(:,:,1),strctTrial.point4(:,:,1)];
            %        strctTrial.coordinatesY(1:4,:,:) = [strctTrial.point1(:,:,2), strctTrial.point2(:,:,2), strctTrial.point3(:,:,2),strctTrial.point4(:,:,2)];
                    strctTrial.coordinatesX(1,:,:) = shiftdim(strctTrial.point1(:,:,1));
                    strctTrial.coordinatesX(2,:,:) = shiftdim(strctTrial.point2(:,:,1));
                    strctTrial.coordinatesX(3,:,:) = shiftdim(strctTrial.point3(:,:,1));
                    strctTrial.coordinatesX(4,:,:) = shiftdim(strctTrial.point4(:,:,1));
                    strctTrial.coordinatesY(1,:,:) = shiftdim(strctTrial.point1(:,:,2));
                    strctTrial.coordinatesY(2,:,:) = shiftdim(strctTrial.point2(:,:,2));
                    strctTrial.coordinatesY(3,:,:) = shiftdim(strctTrial.point3(:,:,2));
                    strctTrial.coordinatesY(4,:,:) = shiftdim(strctTrial.point4(:,:,2));
            
       elseif strctTrial.numFrames > 1 && g_strctParadigm.m_bRandPosEachFrame == 0;
            for iNumOfBars = 1:strctTrial.m_iNumberOfBars
                % Calculate coordinates for every frame
                
                strctTrial.coordinatesX(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,1) -...
                    (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point1(iNumOfBars,1)-...
                    (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                    ...
                    round(linspace(strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                    round(linspace(strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                    round(linspace(strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)));
                
                strctTrial.coordinatesY(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,2) - ...
                    (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point1(iNumOfBars,2)-...
                    (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
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
%        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps));
        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps+1));
        [strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
        
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(1,iNumOfBars,1),strctTrial.bar_rect(1,iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(1,iNumOfBars,3),strctTrial.bar_rect(1,iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));

            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(1,iNumOfBars,2),strctTrial.bar_rect(1,iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(1,iNumOfBars,4),strctTrial.bar_rect(1,iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));

            [firstBlurCoordsPoint1(1,:), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
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
    %Felix added for cloud stimuli
%}


return;

% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPrepareGroundtruthTrial(g_strctPTB, strctTrial)

global g_strctParadigm

strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

%strctTrial.m_iLength = squeeze(g_strctParadigm.GroundtruthLength.Buffer(1,:,g_strctParadigm.GroundtruthLength.BufferIdx));
strctTrial.m_iLength = squeeze(g_strctParadigm.GroundtruthWidth.Buffer(1,:,g_strctParadigm.GroundtruthWidth.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.GroundtruthWidth.Buffer(1,:,g_strctParadigm.GroundtruthWidth.BufferIdx));
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.GroundtruthNumberOfBars.Buffer(1,:,g_strctParadigm.GroundtruthNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.GroundtruthStimulusOnTime.Buffer(1,:,g_strctParadigm.GroundtruthStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.GroundtruthStimulusOffTime.Buffer(1,:,g_strctParadigm.GroundtruthStimulusOffTime.BufferIdx);
strctTrial.numFrames = ceil(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));

strctTrial.m_fspatialoffset = g_strctParadigm.GroundtruthOffset.Buffer(1,:,g_strctParadigm.GroundtruthOffset.BufferIdx);

strctTrial.m_iMoveDistance = 0;%squeeze(g_strctParadigm.CIHandmapperMoveDistance.Buffer(1,:,g_strctParadigm.CIHandmapperMoveDistance.BufferIdx));
strctTrial.m_iMoveSpeed = 0;%squeeze(g_strctParadigm.CIHandmapperMoveSpeed.Buffer(1,:,g_strctParadigm.CIHandmapperMoveSpeed.BufferIdx));
strctTrial.m_fRotationAngle = 0;
% 
% if strctTrial.m_iMoveDistance >=1 && strctTrial.m_iMoveSpeed >=1
%     strctTrial.numberBlurSteps = round(strctTrial.m_iMoveDistance/strctTrial.m_iMoveSpeed);
% else 
%     strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.CIHandmapperBlurSteps.Buffer(1,:,g_strctParadigm.CIHandmapperBlurSteps.BufferIdx)));
% end

%Felix kludge - not worrying about blur for now
% if strctTrial.numberBlurSteps >1
%     strctTrial.m_bBlur  = 1;
% else
    strctTrial.numberBlurSteps = 1; strctTrial.m_bBlur  = 0;
% end

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
%     strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
    %         %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
    
    % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    
    currentBlockStimBGColorsR = ['GroundtruthBackgroundRed'];
    currentBlockStimBGColorsG = ['GroundtruthBackgroundGreen'];
    currentBlockStimBGColorsB = ['GroundtruthBackgroundBlue'];
    
    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    strctTrial.m_afBackgroundColor = floor(strctTrial.m_afLocalBackgroundColor/255)*65535;
else
    strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
end

[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);

%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','GroundtruthStimulusArea');
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(strctTrial.m_aiStimulusArea/2);
%g_strctParadigm.m_aiStimulusRect = round(g_strctPTB.m_fScale * g_strctParadigm.m_aiStimulusRect);
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;

% Felix added replacement for many CI stim inputs
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = g_strctParadigm.m_cPresetColors{1,1}*(65535/255);
strctTrial.m_aiCLUT(4,:) = g_strctParadigm.m_cPresetColors{1,2}*(65535/255);
strctTrial.m_aiCLUT(5,:) = g_strctParadigm.m_cPresetColors{2,1}*(65535/255);
strctTrial.m_aiCLUT(6,:) = g_strctParadigm.m_cPresetColors{2,2}*(65535/255);
strctTrial.m_aiCLUT(7,:) = g_strctParadigm.m_cPresetColors{3,1}*(65535/255);
strctTrial.m_aiCLUT(8,:) = g_strctParadigm.m_cPresetColors{3,2}*(65535/255);
%strctTrial.m_aiCLUT(9,:) = g_strctParadigm.m_cPresetColors{4,1}*(65535/255); % DKL0
strctTrial.m_aiCLUT(9,:) = g_strctParadigm.m_cPresetColors{4,2}*(65535/255); % DKL45
strctTrial.m_aiCLUT(10,:) = g_strctParadigm.m_cPresetColors{4,3}*(65535/255); % DKL90
strctTrial.m_aiCLUT(11,:) = g_strctParadigm.m_cPresetColors{4,4}*(65535/255); % DKL135
%strctTrial.m_aiCLUT(13,:) = g_strctParadigm.m_cPresetColors{4,5}*(65535/255); % DKL180
strctTrial.m_aiCLUT(12,:) = g_strctParadigm.m_cPresetColors{4,6}*(65535/255); % DKL225
strctTrial.m_aiCLUT(13,:) = g_strctParadigm.m_cPresetColors{4,7}*(65535/255); % DKL270
strctTrial.m_aiCLUT(14,:) = g_strctParadigm.m_cPresetColors{4,8}*(65535/255); % DKL315
strctTrial.m_aiCLUT(15,:) = deal(65535);

strctTrial.m_aiCLUT(256,:) = deal(65535);

%dbstop if warning
%warning('stop')
iLastUsedCLUTOffset = g_strctParadigm.m_iCLUTOffset;

% strctTrial.m_aiLocalBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
% strctTrial.m_aiBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
strctTrial.m_aiLocalBlurStepHolder = zeros(3,strctTrial.m_iNumberOfBars,strctTrial.numFrames);
strctTrial.m_aiBlurStepHolder = zeros(3,strctTrial.m_iNumberOfBars,strctTrial.numFrames);

if g_strctParadigm.m_bGroundtruthCISonly==1
%curcols = RandSample(3:8,[1,strctTrial.m_iNumberOfBars]);
strctTrial.m_iNumberOfBars=12;
curcols = [randperm(6,6),randperm(6,6)]+2;
else
curcols = randi(15,strctTrial.m_iNumberOfBars,1);
end
%{
    for iFrames = 1:strctTrial.numFrames
        for iNumBars = 1 : strctTrial.m_iNumberOfBars
        % Felix note; replace THIS with semirandom sequence
        strctTrial.m_aiLocalBlurStepHolder(1:3,iNumBars,iFrames) = floor(strctTrial.m_aiCLUT(curcols(iNumBars),:)*(255/65535));
        strctTrial.m_aiBlurStepHolder(1:3,iNumBars,iFrames) = deal(curcols(iNumBars)-1);
        end
        if strctTrial.m_iNumberOfBars > 3
        strctTrial.m_aiLocalBlurStepHolder(1:3,2,iFrames) = floor(strctTrial.m_aiCLUT(curcols(1),:)*(255/65535));
        strctTrial.m_aiBlurStepHolder(1:3,2,iFrames) = deal(curcols(1)-1);
        end
    end
%}
        for iNumBars = 1 : strctTrial.m_iNumberOfBars
        % Felix note; replace THIS with semirandom sequence
        strctTrial.m_aiLocalBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = repmat(floor(strctTrial.m_aiCLUT(curcols(iNumBars),:)*(255/65535)),strctTrial.numFrames,1)';
        strctTrial.m_aiBlurStepHolder(1:3,iNumBars,1:strctTrial.numFrames) = deal(curcols(iNumBars)-1);
        end
        if strctTrial.m_iNumberOfBars > 3
        strctTrial.m_aiLocalBlurStepHolder(1:3,2,1:strctTrial.numFrames) = repmat(floor(strctTrial.m_aiCLUT(curcols(1),:)*(255/65535)),strctTrial.numFrames,1)';
        strctTrial.m_aiBlurStepHolder(1:3,2,1:strctTrial.numFrames) = deal(curcols(1)-1);
        end

%        strctTrial.m_iMoveDistance = (strctTrial.m_iMoveSpeed / (1000/g_strctPTB.g_strctStimulusServer.m_RefreshRateMS)) * strctTrial.numFrames;
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
    strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.CIHandmapperOrientation.Buffer(1,:,g_strctParadigm.CIHandmapperOrientation.BufferIdx));
end
g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;

xrange=range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]);
yrange=range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]);
if yrange<=0; yrange=1; end; if xrange<=1; xrange=1; end

n_xpos=floor(xrange/strctTrial.m_iLength);
n_ypos=floor(yrange/strctTrial.m_iWidth);
if n_xpos<=0; n_xpos=1; end; if n_ypos<=1; n_ypos=1; end

%temp_ypos=round(linspace(1,n_ypos,strctTrial.numFrames));
%{ 
% very old version
minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iWidth)/2;
for ff=1:strctTrial.numFrames
    strctTrial.location_x(ff,1) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange));
    strctTrial.location_y(ff,1) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
    strctTrial.bar_rect(ff,1,1:4) = [(strctTrial.location_x(ff,1) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,1)  - strctTrial.m_iWidth/2), ...
        (strctTrial.location_x(ff,1) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,1) + strctTrial.m_iWidth/2)];

    for iNumBars = 2 : strctTrial.m_iNumberOfBars
        strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange))+strctTrial.m_fspatialoffset;
        strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));

        for tries=1:10
            if abs(min(strctTrial.location_x(ff,1:iNumBars-1)) - strctTrial.location_x(ff,iNumBars)) < minimum_seperation ||...
                    abs(min(strctTrial.location_y(ff,1:iNumBars-1)) - strctTrial.location_y(ff,iNumBars)) < minimum_seperation
                % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                % So we'll just try 5 times and hope for the best
                strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(randi(xrange))+strctTrial.m_fspatialoffset;
                strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(randi(yrange));
            else
                break;
            end
        end
        strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth/2), ...
            (strctTrial.location_x(iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth/2)];

    end
end            
%}

%{
%more recent version
for ff=1:strctTrial.numFrames
    for iNumBars = 1 : strctTrial.m_iNumberOfBars
        strctTrial.location_x(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ strctTrial.m_iLength*randi(n_xpos)+strctTrial.m_iLength/2+strctTrial.m_fspatialoffset;
        strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth*randi(n_ypos)+strctTrial.m_iWidth/2;
%strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth.*temp_ypos(ff)+strctTrial.m_iWidth/2;
        strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(ff,iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars)  - strctTrial.m_iWidth/2), ...
            (strctTrial.location_x(ff,iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars) + strctTrial.m_iWidth/2)];
    end
end
%}
    for iNumBars = 1 : strctTrial.m_iNumberOfBars
        strctTrial.location_x(1:strctTrial.numFrames,iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ strctTrial.m_iLength*randi(n_xpos)+strctTrial.m_iLength/2+strctTrial.m_fspatialoffset;
        strctTrial.location_y(1:strctTrial.numFrames,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth*randi(n_ypos)+strctTrial.m_iWidth/2;
%strctTrial.location_y(ff,iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ strctTrial.m_iWidth.*temp_ypos(ff)+strctTrial.m_iWidth/2;
        for ff=1:1:strctTrial.numFrames
        strctTrial.bar_rect(ff,iNumBars,1:4) = [(strctTrial.location_x(ff,iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars)  - strctTrial.m_iWidth/2), ...
            (strctTrial.location_x(ff,iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(ff,iNumBars) + strctTrial.m_iWidth/2)];
        end
    end

[strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
for ff=1:strctTrial.numFrames
    for iNumOfBars = 1:strctTrial.m_iNumberOfBars
        [strctTrial.point1(ff,iNumOfBars,1), strctTrial.point1(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.point2(ff,iNumOfBars,1), strctTrial.point2(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,1),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.point3(ff,iNumOfBars,1), strctTrial.point3(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,4),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.point4(ff,iNumOfBars,1), strctTrial.point4(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(ff,iNumOfBars,3),strctTrial.bar_rect(ff,iNumOfBars,2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.bar_starting_point(ff,iNumOfBars,1),strctTrial.bar_starting_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);
        [strctTrial.bar_ending_point(ff,iNumOfBars,1),strctTrial.bar_ending_point(ff,iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(ff,iNumOfBars),(strctTrial.location_y(ff,iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(ff,iNumOfBars),strctTrial.location_y(ff,iNumOfBars),strctTrial.m_fRotationAngle);

        % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
    end
end
        % Check if the trial has more than 1 frame in it, so we can plan the trial
%        strctTrial.coordinatesX(1:4,:,:) = [strctTrial.point1(:,:,1); strctTrial.point2(:,:,1); strctTrial.point3(:,:,1);strctTrial.point4(:,:,1)];
%        strctTrial.coordinatesY(1:4,:,:) = [strctTrial.point1(:,:,2), strctTrial.point2(:,:,2), strctTrial.point3(:,:,2),strctTrial.point4(:,:,2)];
%                     
        strctTrial.coordinatesX(1,:,:) = shiftdim(strctTrial.point1(:,:,1));
        strctTrial.coordinatesX(2,:,:) = shiftdim(strctTrial.point2(:,:,1));
        strctTrial.coordinatesX(3,:,:) = shiftdim(strctTrial.point3(:,:,1));
        strctTrial.coordinatesX(4,:,:) = shiftdim(strctTrial.point4(:,:,1));
        strctTrial.coordinatesY(1,:,:) = shiftdim(strctTrial.point1(:,:,2));
        strctTrial.coordinatesY(2,:,:) = shiftdim(strctTrial.point2(:,:,2));
        strctTrial.coordinatesY(3,:,:) = shiftdim(strctTrial.point3(:,:,2));
        strctTrial.coordinatesY(4,:,:) = shiftdim(strctTrial.point4(:,:,2));
            

%{    
    else
%        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps));
        [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps+1));
        [strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
        
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(1,iNumOfBars,1),strctTrial.bar_rect(1,iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(1,iNumOfBars,3),strctTrial.bar_rect(1,iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));

            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(1,iNumOfBars,2),strctTrial.bar_rect(1,iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
                round(linspace(strctTrial.bar_rect(1,iNumOfBars,4),strctTrial.bar_rect(1,iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));

            [firstBlurCoordsPoint1(1,:), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
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

%}

return;

%--------------------------------------------------

function [strctTrial] = fnPrepareDensenoiseTrial(g_strctPTB, strctTrial)
%tic
global g_strctParadigm

try
if isempty(g_strctParadigm.hartleys_local) %~exist('g_strctParadigm.hartleyset','var') | 
    fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
    fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);
end
catch
    fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
    fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);
end
strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.DensenoiseLength.Buffer(1,:,g_strctParadigm.DensenoiseLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.DualstimWidth.Buffer(1,:,g_strctParadigm.DualstimWidth.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.DensenoiseStimulusOnTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.DensenoiseStimulusOffTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOffTime.BufferIdx);
%strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.numFrames=g_strctParadigm.DensenoiseTrialLength;
strctTrial.ContinuousDisplay = fnTsGetVar('g_strctParadigm','ContinuousDisplay');
strctTrial.CSDtrigframe = fnTsGetVar('g_strctParadigm','CSDtrigframe');

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
    %strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
    %         %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
    
    % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    
    currentBlockStimBGColorsR = 'DualstimBackgroundRed';
    currentBlockStimBGColorsG = 'DualstimBackgroundGreen';
    currentBlockStimBGColorsB = 'DualstimBackgroundBlue';

    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    strctTrial.m_afBackgroundColor = floor(strctTrial.m_afLocalBackgroundColor/255)*65535;
else
    strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
end
% dbstop if warning
% warning('stop')
[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);

%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','DensenoiseStimulusArea');
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;

%spatialscale = round(sqrt(fnTsGetVar('g_strctParadigm','DensenoiseScale')));
strctTrial.DensenoisePrimaryuseRGBCloud = fnTsGetVar('g_strctParadigm','DensenoisePrimaryuseRGBCloud');

if strctTrial.DensenoisePrimaryuseRGBCloud==1 %use bar stimuli
%     if ~exist('g_strctParadigm.DensenoiseChromBar','var')
%     feval(g_strctParadigm.m_strCallbacks,'PregenBarStimuli');
%     end
    strctTrial.cur_ori=fnTsGetVar('g_strctParadigm' ,'DensenoiseOrientation'); 
    strctTrial.cur_oribin=floor(strctTrial.cur_ori./15)+1;
        
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chrombar_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
    % previous version - memory errors

%/{
    nbars=25;
    randseed=rand(1,g_strctParadigm.Dualstim_pregen_chrombar_n*nbars);
    randseed2 = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    strctTrial.barmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    pvec_edges=[0 cumsum(g_strctParadigm.barprobs_lum)];
    for pp=1:7
        cur_indxs=find(randseed>=pvec_edges(pp) & randseed<pvec_edges(pp+1));
        randseed2(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKLCLUT(pp,:),length(cur_indxs),1);
        strctTrial.barmat(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKL(pp,:),length(cur_indxs),1);
    end
    strctTrial.m_aiCLUT=zeros(g_strctParadigm.Dualstim_pregen_chrombar_n,256,3);
    strctTrial.m_aiCLUT(:,2,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,3:nbars+2,:)=reshape(randseed2,g_strctParadigm.Dualstim_pregen_chrombar_n,nbars,3);
    strctTrial.m_aiCLUT(:,126:255,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,256,:) = deal(65535);
%}
elseif strctTrial.DensenoisePrimaryuseRGBCloud==2 %use color bar stimuli
%     if ~exist('g_strctParadigm.DensenoiseChromBar','var')
%     feval(g_strctParadigm.m_strCallbacks,'PregenBarStimuli');
%     end
    strctTrial.cur_ori=fnTsGetVar('g_strctParadigm' ,'DensenoiseOrientation'); 
    strctTrial.cur_oribin=floor(strctTrial.cur_ori./15)+1;
        
    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chrombar_n,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
    % previous version - memory errors
    %{
    strctTrial.stimuli=g_strctParadigm.chrombarmat(strctTrial.stimseq,:);
    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
    %}

% new code - just uses one set of textures and generates new CLUT for
% display texture
%/{
    nbars=25;
    randseed=rand(1,g_strctParadigm.Dualstim_pregen_chrombar_n*nbars);
    randseed2 = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    strctTrial.barmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n*nbars,3);
    pvec_edges=[0 cumsum(g_strctParadigm.barprobs)];
    for pp=1:7
        cur_indxs=find(randseed>=pvec_edges(pp) & randseed<pvec_edges(pp+1));
        randseed2(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKLCLUT(pp,:),length(cur_indxs),1);
        strctTrial.barmat(cur_indxs,:)=repmat(g_strctParadigm.barcolsDKL(pp,:),length(cur_indxs),1);
    end
    strctTrial.m_aiCLUT=zeros(g_strctParadigm.Dualstim_pregen_chrombar_n,256,3);
    strctTrial.m_aiCLUT(:,2,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,3:nbars+2,:)=reshape(randseed2,g_strctParadigm.Dualstim_pregen_chrombar_n,nbars,3);
    strctTrial.m_aiCLUT(:,126:255,:)=deal((65535/255)*127);%strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(:,256,:) = deal(65535);
%}
elseif strctTrial.DensenoisePrimaryuseRGBCloud==3 %use Lum-axis hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
%   curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
%    strctTrial.Densenoisestim = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
%    strctTrial.Densenoisestim_disp = g_strctParadigm.hartleyset.hartleys_binned(:,:,curseq)+8;
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);
		 
%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DensenoisePrimaryuseRGBCloud==4 %use L-M axis hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2))+length(g_strctParadigm.hartleyset.hartleys_binned),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
%   curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
%    strctTrial.Densenoisestim = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
%    strctTrial.Densenoisestim_disp = g_strctParadigm.hartleyset.hartleys_binned(:,:,curseq)+8;
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);
		 
%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DensenoisePrimaryuseRGBCloud==5 %use S-axis hartleys
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned),1,round(strctTrial.numFrames/2))+2*length(g_strctParadigm.hartleyset.hartleys_binned),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
%   curseq=randi(size(g_strctParadigm.hartleyset.hartleys,3),1,strctTrial.numFrames);
%    strctTrial.Densenoisestim = g_strctParadigm.hartleyset.hartleys(:,:,curseq);
%    strctTrial.Densenoisestim_disp = g_strctParadigm.hartleyset.hartleys_binned(:,:,curseq)+8;
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);
		 
%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DensenoisePrimaryuseRGBCloud==6 %use all color hartleys
    %replace with correct indices
%    curseq=randi(size(g_strctParadigm.hartleyset.Colhartleys50,3),1,strctTrial.numFrames);
%     strctTrial.Densenoisestim = g_strctParadigm.hartleyset.Colhartleys50(:,:,curseq,:).*255;
%     strctTrial.Densenoisestim_disp = g_strctParadigm.hartleyset.Colhartleys50_binned(:,:,curseq)+8;
    strctTrial.stimseq=repmat(randi(length(g_strctParadigm.hartleyset.hartleys_binned)*3,1,round(strctTrial.numFrames/2)),2,1);
    strctTrial.stimseq=strctTrial.stimseq(:);
    
strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut),:) = (65535/255)*g_strctParadigm.DKLclut;
strctTrial.m_aiCLUT(256,:) = deal(65535);

%strctTrial.stimuli=g_strctParadigm.hartleyset.hartleys_binned(:,:,strctTrial.stimseq,:);

elseif strctTrial.DensenoisePrimaryuseRGBCloud==7 % achromatic cloud
    if ~isfield(g_strctParadigm,'DensenoiseAchromcloud')
        feval(g_strctParadigm.m_strCallbacks,'PregenACloudStimuli');
    end
% % Generate stimuli each trial (too slow)   
%     strctTrial.Densenoisestim = mk_spatialcloud(25,25, strctTrial.numFrames, spatialscale).*255;
%     [~,strctTrial.Densenoisestim_disp] = histc(strctTrial.Densenoisestim,linspace(0,255,256));

% % Generate seqence of pregen stimuli (no repeats)
%     strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
%     strctTrial.stimseq=strctTrial.stimseq(:);

if g_strctParadigm.DensenoiseAchromcloudTrialnum > g_strctParadigm.DensenoiseBlockSizeTotal
        spatialscale=fnTsGetVar('g_strctParadigm' ,'DensenoiseScale');
        cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
        g_strctParadigm.DensenoiseAchromcloud = round((mk_spatialcloud(cloudpix,cloudpix, g_strctParadigm.Dualstim_pregen_achromcloud_n, spatialscale)./2 +.5).*255);
        [~,g_strctParadigm.DensenoiseAchromcloud_binned] = histc(g_strctParadigm.DensenoiseAchromcloud,linspace(0,255,256));

        fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
        fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned);

    g_strctParadigm.DensenoiseAchromcloud_stimseqs=repmat(randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,g_strctParadigm.DensenoiseBlockSize,ceil(g_strctParadigm.DensenoiseTrialLength/2)),2,1);
    g_strctParadigm.DensenoiseAchromcloud_trialindex = [randperm(g_strctParadigm.DensenoiseBlockSize),randperm(g_strctParadigm.DensenoiseBlockSize)];
    g_strctParadigm.DensenoiseAchromcloudBlocknum=g_strctParadigm.DensenoiseAchromcloudBlocknum+1;
    g_strctParadigm.DensenoiseAchromcloudTrialnum=1;
end

strctTrial.BlockID = g_strctParadigm.DensenoiseAchromcloudBlocknum;
strctTrial.TrialID = g_strctParadigm.DensenoiseAchromcloudTrialnum;
strctTrial.stimseq=repmat(g_strctParadigm.DensenoiseAchromcloud_stimseqs(g_strctParadigm.DensenoiseAchromcloud_trialindex(g_strctParadigm.DensenoiseAchromcloudTrialnum),:),2,1);
strctTrial.stimseq=strctTrial.stimseq(:);
g_strctParadigm.DensenoiseAchromcloudTrialnum = g_strctParadigm.DensenoiseAchromcloudTrialnum+1;
    
    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
    strctTrial.stimuli=g_strctParadigm.DensenoiseAchromcloud(:,:,strctTrial.stimseq,:);
    
 
elseif strctTrial.DensenoisePrimaryuseRGBCloud==8 %use color cloud 
    if ~isfield(g_strctParadigm,'DensenoiseChromcloud')
        feval(g_strctParadigm.m_strCallbacks,'PregenCCloudStimuli');
    end
    
%     strctTrial.Densenoisestim = 2*(mk_spatialcloudRGB(25, 25, strctTrial.numFrames, spatialscale)-.5);
%     lv_in=strctTrial.Densenoisestim(:,:,:,1);
%     rg_in=strctTrial.Densenoisestim(:,:,:,2);
%     yv_in=strctTrial.Densenoisestim(:,:,:,3);
%     strctTrial.Densenoisestim = shiftdim(reshape(ldrgyv2rgb(lv_in(:)',rg_in(:)',yv_in(:)'),3,25,25,strctTrial.numFrames),1).*255;
%     strctTrial.Densenoisestim_disp = strctTrial.Densenoisestim; %this needs adjustment still
%          linearclut=linspace(0,65535,256)';
%          strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut); 

% % Just generate sequence of prelaoded color frames (no repeats)
%    strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
%    strctTrial.stimseq=strctTrial.stimseq(:);

if g_strctParadigm.DensenoiseChromcloudTrialnum > g_strctParadigm.DensenoiseBlockSizeTotal
        g_strctParadigm.Cur_CCloud_loaded = 'randpregen';
        spatialscale=fnTsGetVar('g_strctParadigm' ,'DensenoiseScale');
        cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
        g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(mk_spatialcloudRGB(cloudpix, cloudpix, g_strctParadigm.Dualstim_pregen_chromcloud_n, spatialscale),cloudpix*cloudpix*g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
        DensenoiseChromcloud_sums=sum(abs(g_strctParadigm.DensenoiseChromcloud_DKlspace),2); DensenoiseChromcloud_sums(DensenoiseChromcloud_sums < 1)=1;
        g_strctParadigm.DensenoiseChromcloud_DKlspace=g_strctParadigm.DensenoiseChromcloud_DKlspace./[DensenoiseChromcloud_sums,DensenoiseChromcloud_sums,DensenoiseChromcloud_sums];
        g_strctParadigm.DensenoiseChromcloud=reshape(round(255.*ldrgyv2rgb(g_strctParadigm.DensenoiseChromcloud_DKlspace(:,1)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,2)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,3)'))',cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
        g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(g_strctParadigm.DensenoiseChromcloud_DKlspace,cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);

    fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
    fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);

    g_strctParadigm.DensenoiseChromcloud_stimseqs=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,g_strctParadigm.DensenoiseBlockSize,ceil(g_strctParadigm.DensenoiseTrialLength/2)),2,1);
    g_strctParadigm.DensenoiseChromcloud_trialindex = [randperm(g_strctParadigm.DensenoiseBlockSize),randperm(g_strctParadigm.DensenoiseBlockSize)];
    g_strctParadigm.DensenoiseChromcloudBlocknum=g_strctParadigm.DensenoiseChromcloudBlocknum+1;
    g_strctParadigm.DensenoiseChromcloudTrialnum=1;
end

strctTrial.BlockID = g_strctParadigm.DensenoiseChromcloudBlocknum;
strctTrial.TrialID = g_strctParadigm.DensenoiseChromcloudTrialnum;
strctTrial.stimseq=repmat(g_strctParadigm.DensenoiseChromcloud_stimseqs(g_strctParadigm.DensenoiseChromcloud_trialindex(g_strctParadigm.DensenoiseChromcloudTrialnum),:),2,1);
strctTrial.stimseq=strctTrial.stimseq(:);
g_strctParadigm.DensenoiseChromcloudTrialnum = g_strctParadigm.DensenoiseChromcloudTrialnum+1;

    strctTrial.Cur_CCloud_loaded = g_strctParadigm.Cur_CCloud_loaded;
    strctTrial.stimuli=g_strctParadigm.DensenoiseChromcloud_DKlspace(:,:,strctTrial.stimseq,:);
    strctTrial.stimuli_RGB=g_strctParadigm.DensenoiseChromcloud(:,:,strctTrial.stimseq,:);

    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);
    %{
%     strctTrial.m_aiCLUT = zeros(256,3);
% strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
% strctTrial.m_aiCLUT(3,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,1};
% strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{1,2};
% strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,1};
% strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{2,2};
% strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,1};
% strctTrial.m_aiCLUT(8,:) = (65535/255)*g_strctParadigm.m_cPresetColors{3,2};
% strctTrial.m_aiCLUT(9:8+length(g_strctParadigm.DKLclut_colcloud),:) = (65535/255)*g_strctParadigm.DKLclut_colcloud;
%     strctTrial.m_aiCLUT(256,:) = deal(65535);
%}
end

%     clutseq=[-1 -.6 -.3 0 .3 .6 1];
%     for curclut=1:7
%     strctTrial.m_aiCLUT(9+curclut,:) = ldrgyv2rgb(0,clutseq(curclut),0);
%     strctTrial.m_aiCLUT(16+curclut,:) = ldrgyv2rgb(0,0,clutseq(curclut));
%     end
	
return

%--------------------------------------------------

function [strctTrial] = fnPrepareOneDnoiseTrial(g_strctPTB, strctTrial)
%tic
global g_strctParadigm


strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.DensenoiseLength.Buffer(1,:,g_strctParadigm.DensenoiseLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.DualstimWidth.Buffer(1,:,g_strctParadigm.DualstimWidth.BufferIdx));
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.OneDnoiseNumberofBars.Buffer(1,:,g_strctParadigm.OneDnoiseNumberofBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.DensenoiseStimulusOnTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.DensenoiseStimulusOffTime.Buffer(1,:,g_strctParadigm.DualstimStimulusOffTime.BufferIdx);

%strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.numFrames = 120;
%strctTrial.stimseq=repmat(randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,1,round(strctTrial.numFrames/2)),2,1);
strctTrial.stimseq=repmat([1:strctTrial.numFrames],2,1);
strctTrial.stimseq=strctTrial.stimseq(:);

strctTrial.orientation = fnTsGetVar('g_strctParadigm','OneDnoiseOrientation');

if g_strctParadigm.m_bUseChosenBackgroundColor && size(g_strctParadigm.m_strctCurrentBackgroundColors,1) == 1
    %strctTrial.m_afBackgroundColor = g_strctParadigm.m_strctCurrentBackgroundColors;
    %         %strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/65535) * 255);
    
    % strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    
    currentBlockStimBGColorsR = ['DualstimBackgroundRed'];
    currentBlockStimBGColorsG = ['DualstimBackgroundGreen'];
    currentBlockStimBGColorsB = ['DualstimBackgroundBlue'];

    strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];
    strctTrial.m_afBackgroundColor = floor(strctTrial.m_afLocalBackgroundColor/255)*65535;
else
    strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
    strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
end
% dbstop if warning
% warning('stop')
[strctTrial] = fnCheckVariableSettings(g_strctPTB, strctTrial);
%[strctTrial] = fnCycleColor(strctTrial);

%Felix added: primary stimulus rect
strctTrial.m_aiStimulusArea = fnTsGetVar('g_strctParadigm','DensenoiseStimulusArea');
if mod(strctTrial.m_aiStimulusArea,strctTrial.m_iNumberOfBars)>0;
    strctTrial.m_aiStimulusArea=ceil(strctTrial.m_aiStimulusArea./strctTrial.m_iNumberOfBars)*strctTrial.m_iNumberOfBars;
end
if mod(strctTrial.m_aiStimulusArea,2)>0
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-floor(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-floor(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+floor(strctTrial.m_aiStimulusArea/2)+1;
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+floor(strctTrial.m_aiStimulusArea/2)+1;
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;    
else
g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-round(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-round(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+round(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+round(strctTrial.m_aiStimulusArea/2);
g_strctParadigm.m_aiStimulusRect = g_strctParadigm.m_aiStimulusRect;
strctTrial.m_aiStimulusRect =  g_strctParadigm.m_aiStimulusRect;
strctTrial.bar_rect = g_strctParadigm.m_aiStimulusRect;
end

%spatialscale = round(sqrt(fnTsGetVar('g_strctParadigm','DensenoiseScale')));
strctTrial.OneDnoiseDistType = fnTsGetVar('g_strctParadigm','OneDnoiseDistType');
if strctTrial.OneDnoiseDistType==1
    probvec=[.2, .2, .2, .1, .1, .1, .1];
elseif strctTrial.OneDnoiseDistType==2
    probvec=[.1, .1, .1, .1, .1, .1, .1]./.7;
end

[outmat, strctTrial.stimseed]=mk_ColorBarStim(probvec, 1, strctTrial.numFrames, strctTrial.m_iNumberOfBars);
%%
outmattemp(outmat==1)=0;    %k
outmattemp(outmat==2)=0.5;  %gray
outmattemp(outmat==3)=1;    %w
outmattemp(outmat==4)=1;    %L+
outmattemp(outmat==5)=0;    %l-
outmattemp(outmat==6)=.5;    %s+
outmattemp(outmat==7)=.5;    %s-

outmattemp2(outmat==1)=0;    %k
outmattemp2(outmat==2)=0.5;  %gray
outmattemp2(outmat==3)=1;    %w
outmattemp2(outmat==4)=0;    %L+
outmattemp2(outmat==5)=1;    %l-
outmattemp2(outmat==6)=.5;    %s+
outmattemp2(outmat==7)=.5;    %s-

outmattemp3(outmat==1)=0;    %k
outmattemp3(outmat==2)=0.5;  %gray
outmattemp3(outmat==3)=1;    %w
outmattemp3(outmat==4)=1;    %L+
outmattemp3(outmat==5)=0;    %l-
outmattemp3(outmat==6)=1;    %s+
outmattemp3(outmat==7)=0;    %s-


% strctTrial.stimuli_RGB(:,:,:,1)=reshape(outmattemp,[strctTrial.numFrames,strctTrial.m_iNumberOfBars,strctTrial.m_iNumberOfBars,1]).*255;
% strctTrial.stimuli_RGB(:,:,:,2)=reshape(outmattemp2,[strctTrial.numFrames,strctTrial.m_iNumberOfBars,strctTrial.m_iNumberOfBars,1]).*255;
% strctTrial.stimuli_RGB(:,:,:,3)=reshape(outmattemp3,[strctTrial.numFrames,strctTrial.m_iNumberOfBars,strctTrial.m_iNumberOfBars,1]).*255;
strctTrial.stimuli_RGB(:,:,:,1)=reshape(outmattemp,[strctTrial.numFrames,strctTrial.m_iNumberOfBars,2,1]).*255;
strctTrial.stimuli_RGB(:,:,:,2)=reshape(outmattemp2,[strctTrial.numFrames,strctTrial.m_iNumberOfBars,2,1]).*255;
strctTrial.stimuli_RGB(:,:,:,3)=reshape(outmattemp3,[strctTrial.numFrames,strctTrial.m_iNumberOfBars,2,1]).*255;
strctTrial.stimuli_RGB=permute(strctTrial.stimuli_RGB,[2 3 1 4]);
strctTrial.stimuli=permute(outmat-1,[2 3 1]);
% strctTrial.stimuli(:,:,:,1)=outmat-1;
% strctTrial.stimuli(:,:,:,2)=outmat-1;
% strctTrial.stimuli(:,:,:,3)=outmat-1;

strctTrial.m_aiCLUT = zeros(256,3);
strctTrial.m_aiCLUT(2,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
strctTrial.m_aiCLUT(3,:) = (65535/255)*[255 255 255];
strctTrial.m_aiCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,1};
strctTrial.m_aiCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,5};
strctTrial.m_aiCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,3};
strctTrial.m_aiCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,7};
strctTrial.m_aiCLUT(256,:) = deal(65535);

fnInitializeChromBarTextures(strctTrial.numFrames, 0, strctTrial.stimuli_RGB, strctTrial.stimuli) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeChromBarTextures', strctTrial.numFrames, 0, strctTrial.stimuli_RGB, strctTrial.stimuli);

return

% ------------------------------------------------------------------------------------------------------------------------


function [strctTrial] = fnPrepareDiscProbeTrial(g_strctPTB, strctTrial)
global g_strctParadigm g_strctStimulusServer

strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iDiscDiameter = squeeze(g_strctParadigm.DiscProbeDiameter.Buffer(1,:,g_strctParadigm.DiscProbeDiameter.BufferIdx));

strctTrial.m_iLength = strctTrial.m_iDiscDiameter;
strctTrial.m_iWidth = strctTrial.m_iLength;
strctTrial.m_aiDiscProbeStimulusArea = strctTrial.m_iDiscDiameter;

strctTrial.DiscprobeColor = g_strctParadigm.m_cPresetProbeColors(g_strctParadigm.Discprobe_trialindex(g_strctParadigm.DiscprobeTrialnum),:);
strctTrial.DiscprobeColorID = g_strctParadigm.m_cPresetProbeColorIDS(g_strctParadigm.DiscprobeTrialnum,:);
strctTrial.DiscprobeBlocknum = g_strctParadigm.DiscprobeBlocknum;
strctTrial.DiscprobeTrialnum = g_strctParadigm.DiscprobeTrialnum;

strctTrial.m_fStimulusON_MS = g_strctParadigm.DiscProbeStimulusOnTime.Buffer(1,:,g_strctParadigm.DiscProbeStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.DiscProbeStimulusOffTime.Buffer(1,:,g_strctParadigm.DiscProbeStimulusOffTime.BufferIdx);

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
if ~strctTrial.numFrames
    strctTrial.numFrames = 1;  % Sanity check, in case speed and distance are too low
end

strctTrial.m_bBlur  = squeeze(g_strctParadigm.DiscBlur.Buffer(1,:,g_strctParadigm.DiscBlur.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.DiscBlurSteps.Buffer(1,:,g_strctParadigm.DiscBlurSteps.BufferIdx)));

[strctTrial] = fnCycleColor(strctTrial);

strctTrial.m_aiStimCenter = g_strctParadigm.m_aiCenterOfStimulus;

% strctTrial.m_aiCoordinates(1:4,:,1) = vertcat(round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(1,1),strctTrial.m_aiStimRectangleEndingCoordinates(1,1),strctTrial.numFrames)),...
%     round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(1,2),strctTrial.m_aiStimRectangleEndingCoordinates(1,2),strctTrial.numFrames)),...
%     round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(1,3), strctTrial.m_aiStimRectangleEndingCoordinates(1,3),strctTrial.numFrames)),...
%     round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(1,4), strctTrial.m_aiStimRectangleEndingCoordinates(1,4),strctTrial.numFrames)));

    linearclut=linspace(0,65535,256)';
    strctTrial.m_aiCLUT=cat(2,linearclut,linearclut,linearclut);

    g_strctParadigm.DiscprobeTrialnum = g_strctParadigm.DiscprobeTrialnum+1;
        if g_strctParadigm.DiscprobeTrialnum > g_strctParadigm.DiscprobeBlockSize;
            g_strctParadigm.Discprobe_trialindex = randperm(g_strctParadigm.DiscprobeBlockSize);
            g_strctParadigm.DiscprobeBlocknum=g_strctParadigm.DiscprobeBlocknum+1;
            g_strctParadigm.DiscprobeTrialnum=1;
        end
        
return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPrepare2BarTrial(g_strctPTB, strctTrial)

% dbstop if warning
% warning ('Sivas warning')

global g_strctStimulusServer g_strctParadigm
strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

% strctTrial.m_iLength(1) = squeeze(g_strctParadigm.TwoBarLengthBarOne.Buffer(1,:,g_strctParadigm.TwoBarLengthBarOne.BufferIdx));
% strctTrial.m_iWidth(1) = squeeze(g_strctParadigm.TwoBarWidthBarOne.Buffer(1,:,g_strctParadigm.TwoBarWidthBarOne.BufferIdx));
% strctTrial.m_iLength(2) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% strctTrial.m_iWidth(2) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));

% %Siva's edit start (added)
% strctTrial.m_iLength(3) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% strctTrial.m_iWidth(3) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
% strctTrial.m_iLength(4) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% strctTrial.m_iWidth(4) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));

for i=1:4%squeeze(g_strctParadigm.TwoBarNumberOfBars.Buffer(1,:,g_strctParadigm.TwoBarNumberOfBars.BufferIdx))
    strctTrial.m_iLength(i) = squeeze(g_strctParadigm.TwoBarLengthBarOne.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
    strctTrial.m_iWidth(i) = squeeze(g_strctParadigm.TwoBarLengthBarOne.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
    
    strctTrial.numberBlurSteps(i) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarOne.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarOne.BufferIdx)));
    
    strctTrial.m_iOrientationBin(i) = randi(g_strctParadigm.m_iNumOrientationBins);
    strctTrial.m_fRotationAngle(i) = strctTrial.m_iOrientationBin(1) * (360/g_strctParadigm.m_iNumOrientationBins) ;
end
% %Siva's edit end (added)



strctTrial.m_iBarOneLength = strctTrial.m_iLength;
strctTrial.m_iBarOneWidth= strctTrial.m_iWidth;
strctTrial.m_iBarTwoLength = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
strctTrial.m_iBarTwoWidth = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
strctTrial.m_iNumberOfBars = 4; %squeeze(g_strctParadigm.TwoBarNumberOfBars.Buffer(1,:,g_strctParadigm.TwoBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.TwoBarStimulusOnTime.Buffer(1,:,g_strctParadigm.TwoBarStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.TwoBarStimulusOffTime.Buffer(1,:,g_strctParadigm.TwoBarStimulusOffTime.BufferIdx);
strctTrial.m_fTwoBarOnsetDelay = g_strctParadigm.TwoBarStimulusOnsetDelay.Buffer(1,:,g_strctParadigm.TwoBarStimulusOnsetDelay.BufferIdx);

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.m_iBarTwoNumFrames = round((strctTrial.m_fStimulusON_MS - strctTrial.m_fTwoBarOnsetDelay) / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.TwoBarMoveDistance.Buffer(1,:,g_strctParadigm.TwoBarMoveDistance.BufferIdx));
strctTrial.m_iMinOffset = squeeze(g_strctParadigm.TwoBarMinOffset.Buffer(1,:,g_strctParadigm.TwoBarMinOffset.BufferIdx));
strctTrial.m_iMaxOffset = squeeze(g_strctParadigm.TwoBarMaxOffset.Buffer(1,:,g_strctParadigm.TwoBarMaxOffset.BufferIdx));
strctTrial.m_bDifferentColorsForDifferentBars = g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars;

% strctTrial.numberBlurSteps(1) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarOne.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarOne.BufferIdx)));
% strctTrial.numberBlurSteps(2) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarTwo.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarTwo.BufferIdx)));
% strctTrial.numberBlurSteps(3) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarOne.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarOne.BufferIdx)));
% strctTrial.numberBlurSteps(4) = round(squeeze(g_strctParadigm.TwoBarBlurStepsBarTwo.Buffer(1,:,g_strctParadigm.TwoBarBlurStepsBarTwo.BufferIdx)));



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
if strctTrial.m_iNumberOfBars > 1
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

% ------------------------------------------------------------------------------------------------------------------------


function [strctTrial] = fnPrepareManyBarTrial(g_strctPTB, strctTrial)

% dbstop if warning
% warning ('Sivas warning')

global g_strctStimulusServer g_strctParadigm
strctTrial.m_bUseStrobes = 0;
strctTrial.m_iFixationColor = [255 255 255];

% strctTrial.m_iLength(1) = squeeze(g_strctParadigm.TwoBarLengthBarOne.Buffer(1,:,g_strctParadigm.TwoBarLengthBarOne.BufferIdx));
% strctTrial.m_iWidth(1) = squeeze(g_strctParadigm.TwoBarWidthBarOne.Buffer(1,:,g_strctParadigm.TwoBarWidthBarOne.BufferIdx));
% strctTrial.m_iLength(2) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% strctTrial.m_iWidth(2) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));

% %Siva's edit start (added)
% strctTrial.m_iLength(3) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% strctTrial.m_iWidth(3) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
% strctTrial.m_iLength(4) = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% strctTrial.m_iWidth(4) = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
strctTrial.m_iNumberOfBars = fnTsGetVar('g_strctParadigm','ManyBarNumberOfBarsSelected');

for i=1:strctTrial.m_iNumberOfBars
    %squeeze(g_strctParadigm.TwoBarNumberOfBars.Buffer(1,:,g_strctParadigm.TwoBarNumberOfBars.BufferIdx))
    
    
    [strctTrial.m_iWidth(i),...
        strctTrial.m_iLength(i),...
        strctTrial.m_fRotationAngle(i),...
        strctTrial.m_iMoveDistance(i),...
        strctTrial.numberBlurSteps(i),...
        strctTrial.m_fTwoBarOnsetDelay(i),...
        strctTrial.m_iMinOffset(i),...
        strctTrial.m_iMaxOffset(i)] = fnTsGetVar('g_strctParadigm',...
        ['ManyBarWidthBar' num2str(i)],...
        ['ManyBarLengthBar' num2str(i)],...
        ['ManyBarOrientationBar' num2str(i)],...
        ['ManyBarMoveDistance' num2str(i)],...
        ['ManyBarBlurStepsBar' num2str(i)],...
        ['ManyBarStimulusOnsetDelay' num2str(i)],...
        ['ManyBarMinOffset' num2str(i)],...
        ['ManyBarMaxOffset' num2str(i)]);
    %['ManyBarStimulusPresetColor' num2str(i)],...
    %['ManyBarStimulusRed' num2str(i)],...
    %['ManyBarStimulusGreen' num2str(i)],...
    %['ManyBarStimulusBlue' num2str(i)],...
    %strctTrial.m_iLength(i),...
    %strctTrial.m_iLength(i),...
    %strctTrial.m_iLength(i),...
    %strctTrial.numberBlurSteps(i),...
    %strctTrial.m_fTwoBarOnsetDelay(i),...
    %strctTrial.m_iLength(i),...
    %     strctTrial.m_iLength(i) = squeeze(g_strctParadigm.(['ManyBarLengthBar' num2str(i)]).Buffer(1,:,g_strctParadigm.(['ManyBarLengthBar' num2str(i)]).BufferIdx));
    %     strctTrial.m_iWidth(i) = squeeze(g_strctParadigm.(['ManyBarWidthBar' num2str(i)]).Buffer(1,:,g_strctParadigm.(['ManyBarWidthBar' num2str(i)]).BufferIdx));
    %     strctTrial.numberBlurSteps(i) = round(squeeze(g_strctParadigm.(['ManyBarLengthBar' num2str(i)]).Buffer(1,:,g_strctParadigm.(['ManyBarLengthBar' num2str(i)]).BufferIdx)));
    %     strctTrial.m_iOrientationBin(i) = randi(g_strctParadigm.m_iNumOrientationBins);
    %     strctTrial.m_fRotationAngle(i) = strctTrial.m_iOrientationBin(1) * (360/g_strctParadigm.m_iNumOrientationBins) ;
end
% %Siva's edit end (added)

% % % % % strctTrial.m_iBarOneLength = strctTrial.m_iLength;
% % % % % strctTrial.m_iBarOneWidth= strctTrial.m_iWidth;
% % % % % strctTrial.m_iBarTwoLength = squeeze(g_strctParadigm.TwoBarLengthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarLengthBarTwo.BufferIdx));
% % % % % strctTrial.m_iBarTwoWidth = squeeze(g_strctParadigm.TwoBarWidthBarTwo.Buffer(1,:,g_strctParadigm.TwoBarWidthBarTwo.BufferIdx));
% 4; %squeeze(g_strctParadigm.TwoBarNumberOfBars.Buffer(1,:,g_strctParadigm.TwoBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.ManyBarStimulusOnTime.Buffer(1,:,g_strctParadigm.ManyBarStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.ManyBarStimulusOffTime.Buffer(1,:,g_strctParadigm.ManyBarStimulusOffTime.BufferIdx);

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));

strctTrial.m_bDifferentColorsForDifferentBars = g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars;

% strctTrial.numberBlurSteps(1) = round(squeeze(g_strctParadigm.ManyBarBlurStepsBarOne.Buffer(1,:,g_strctParadigm.ManyBarBlurStepsBarOne.BufferIdx)));
% strctTrial.numberBlurSteps(2) = round(squeeze(g_strctParadigm.ManyBarBlurStepsBarMany.Buffer(1,:,g_strctParadigm.ManyBarBlurStepsBarMany.BufferIdx)));
% strctTrial.numberBlurSteps(3) = round(squeeze(g_strctParadigm.ManyBarBlurStepsBarOne.Buffer(1,:,g_strctParadigm.ManyBarBlurStepsBarOne.BufferIdx)));
% strctTrial.numberBlurSteps(4) = round(squeeze(g_strctParadigm.ManyBarBlurStepsBarMany.Buffer(1,:,g_strctParadigm.ManyBarBlurStepsBarMany.BufferIdx)));

[strctTrial] = fnCycleColor(strctTrial);

strctTrial.m_bRandomStimulusOrientation = g_strctParadigm.m_bRandomStimulusOrientation;
if g_strctParadigm.m_bRandomStimulusOrientation
    for iBars = 1:strctTrial.m_iNumberOfBars
        % ClockRandSeed();
        %strctTrial.m_iOrientationBin = floor(((g_strctParadigm.m_iNumOrientationBins) * rand(1,1))) + 1;
        strctTrial.m_iOrientationBin(iBars) = randi(g_strctParadigm.m_iNumOrientationBins);
        %strctTrial.m_iOrientationBin(2) = strctTrial.m_iOrientationBin(1);
        strctTrial.m_fRotationAngle(iBars) = strctTrial.m_iOrientationBin(iBars) * (360/g_strctParadigm.m_iNumOrientationBins) ;
        %strctTrial.m_fRotationAngle(2) = strctTrial.m_fRotationAngle(1) ;
    end
elseif g_strctParadigm.m_bCycleStimulusOrientation
    
    if isempty(g_strctParadigm.m_iOrientationBin(1))
        g_strctParadigm.m_iOrientationBin(1) = 1;
    end
    if ~g_strctParadigm.m_bReverseCycleStimulusOrientation
        strctTrial.m_iOrientationBin(iBars) = g_strctParadigm.m_iOrientationBin + 1;
        if strctTrial.m_iOrientationBin(1) >= 21
            strctTrial.m_iOrientationBin(1) = 1;
        end
    else
        strctTrial.m_iOrientationBin = g_strctParadigm.m_iOrientationBin - 1;
        if strctTrial.m_iOrientationBin(1) <= 0
            strctTrial.m_iOrientationBin(1) = 20;
        end
    end
    
    strctTrial.m_fRotationAngle(1) = strctTrial.m_iOrientationBin(1) * (360/g_strctParadigm.m_iNumOrientationBins) ;
    
    for iBars = 2:strctTrial.m_iNumberOfBars
        strctTrial.m_iOrientationBin(iBars) = strctTrial.m_iOrientationBin(1);
        strctTrial.m_fRotationAngle(iBars) = strctTrial.m_fRotationAngle(1);
    end
else
    strctTrial.m_iOrientationBin(1:strctTrial.m_iNumberOfBars) = deal(NaN);
    for iBars = 1:strctTrial.m_iNumberOfBars
        
        strctTrial.m_fRotationAngle(iBars) = fnTsGetVar('g_strctParadigm',['ManyBarOrientationBar', num2str(iBars)])  ;
        %strctTrial.m_fRotationAngle(iBars) = squeeze(g_strctParadigm.ManyBarOrientationBarMany.Buffer(1,:,g_strctParadigm.ManyBarOrientationBarMany.BufferIdx));
    end
    
end

g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin(1);

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
    
    strctTrial.location_x(iNumBars) = round(strctTrial.location_x(1) + (xSign * strctTrial.m_iMinOffset(iNumBars-1)) + (strctTrial.barXOffSet(iNumBars-1) * range([strctTrial.m_iMaxOffset(iNumBars-1), strctTrial.m_iMinOffset(iNumBars-1)])));
    strctTrial.location_y(iNumBars) = round(strctTrial.location_y(1) + (ySign * strctTrial.m_iMinOffset(iNumBars-1)) + (strctTrial.barYOffSet(iNumBars-1) * range([strctTrial.m_iMaxOffset(iNumBars-1), strctTrial.m_iMinOffset(iNumBars-1)])));
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
for iBars = 1:strctTrial.m_iNumberOfBars
    [strctTrial.coordinatesX(iBars).Coords, strctTrial.coordinatesY(iBars).Coords]  = deal(zeros(4, strctTrial.numFrames, strctTrial.numberBlurSteps(iBars)+1));
end
[strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
for iNumOfBars = 1:strctTrial.m_iNumberOfBars
    blurXCoords = [];
    
    blurYCoords = [];
    firstBlurCoordsPoint1 = [];
    firstBlurCoordsPoint2 = [];
    firstBlurCoordsPoint3 = [];
    firstBlurCoordsPoint4 = [];
    lastBlurCoordsPoint1 = [];
    lastBlurCoordsPoint2 = [];
    lastBlurCoordsPoint3 = [];
    lastBlurCoordsPoint4 = [];
    
    switch iNumOfBars
        case 1
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,1) + strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,3) - strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)));
            
            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,2),strctTrial.bar_rect(iNumOfBars,2) + strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,4),strctTrial.bar_rect(iNumOfBars,4) - strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)));
            
            [firstBlurCoordsPoint1(1, :), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [firstBlurCoordsPoint2(1,:), firstBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [firstBlurCoordsPoint3(1,:), firstBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [firstBlurCoordsPoint4(1,:), firstBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            
            [lastBlurCoordsPoint1(1,:), lastBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [lastBlurCoordsPoint2(1,:), lastBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [lastBlurCoordsPoint3(1,:), lastBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [lastBlurCoordsPoint4(1,:), lastBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            
            
            for iBlurSteps = 1: strctTrial.numberBlurSteps(iNumOfBars)+1
                strctTrial.coordinatesX(iNumOfBars).Coords(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(1,iBlurSteps),lastBlurCoordsPoint1(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint2(1,iBlurSteps),lastBlurCoordsPoint2(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint3(1,iBlurSteps),lastBlurCoordsPoint3(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint4(1,iBlurSteps),lastBlurCoordsPoint4(1,iBlurSteps),strctTrial.numFrames)));
                strctTrial.coordinatesY(iNumOfBars).Coords(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(2,iBlurSteps),lastBlurCoordsPoint1(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint2(2,iBlurSteps),lastBlurCoordsPoint2(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint3(2,iBlurSteps),lastBlurCoordsPoint3(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint4(2,iBlurSteps),lastBlurCoordsPoint4(2,iBlurSteps),strctTrial.numFrames)));
            end
        otherwise
            
            
            
            blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,1) + strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,3) - strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)));
            
            blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,2),strctTrial.bar_rect(iNumOfBars,2) + strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)),...
                round(linspace(strctTrial.bar_rect(iNumOfBars,4),strctTrial.bar_rect(iNumOfBars,4) - strctTrial.numberBlurSteps(iNumOfBars)+1,strctTrial.numberBlurSteps(iNumOfBars)+1)));
            
            [firstBlurCoordsPoint1(1, :), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [firstBlurCoordsPoint2(1,:), firstBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [firstBlurCoordsPoint3(1,:), firstBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [firstBlurCoordsPoint4(1,:), firstBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) -...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            
            [lastBlurCoordsPoint1(1,:), lastBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [lastBlurCoordsPoint2(1,:), lastBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [lastBlurCoordsPoint3(1,:), lastBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            [lastBlurCoordsPoint4(1,:), lastBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) +...
                strctTrial.m_iMoveDistance(iNumOfBars)/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle(iNumOfBars));
            
            
            for iBlurSteps = 1: strctTrial.numberBlurSteps(iNumOfBars)+1
                
                strctTrial.coordinatesX(iNumOfBars).Coords(1:4,strctTrial.numFrames + 1 - strctTrial.numFrames : strctTrial.numFrames,iNumOfBars,iBlurSteps) =...
                    vertcat(round(linspace(firstBlurCoordsPoint1(1,iBlurSteps),lastBlurCoordsPoint1(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint2(1,iBlurSteps),lastBlurCoordsPoint2(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint3(1,iBlurSteps),lastBlurCoordsPoint3(1,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint4(1,iBlurSteps),lastBlurCoordsPoint4(1,iBlurSteps),strctTrial.numFrames)));
                
                strctTrial.coordinatesY(iNumOfBars).Coords(1:4,strctTrial.numFrames + 1 - strctTrial.numFrames : strctTrial.numFrames,iNumOfBars,iBlurSteps) = ...
                    vertcat(round(linspace(firstBlurCoordsPoint1(2,iBlurSteps),lastBlurCoordsPoint1(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint2(2,iBlurSteps),lastBlurCoordsPoint2(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint3(2,iBlurSteps),lastBlurCoordsPoint3(2,iBlurSteps),strctTrial.numFrames)),...
                    round(linspace(firstBlurCoordsPoint4(2,iBlurSteps),lastBlurCoordsPoint4(2,iBlurSteps),strctTrial.numFrames)));
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
    
    
    % dbstop if warning
    % warning ('sivas warning')
    if(strcmp(strctTrial.m_strTrialType,'Many Bar'))
        if sum(strctTrial.numberBlurSteps) > 250
            for iBars = 1:fnTsGetVar('g_strctParadigm','ManyBarNumberOfBarsSelected' )
                strctTrial.numberBlurSteps(iBars) = 1;
                
            end
            fnParadigmToKofikoComm('DisplayMessage', 'More BlurSteps than CLUT entries, reduce total number of blur steps!')
            
        end
        for iBars = 1:fnTsGetVar('g_strctParadigm','ManyBarNumberOfBarsSelected' )
            min_distance = min((strctTrial.m_iLength(iBars)/2),(strctTrial.m_iWidth(iBars)/2));
            if strctTrial.numberBlurSteps(iBars) > min_distance
                strctTrial.numberBlurSteps(iBars) = floor(min_distance);
            elseif strctTrial.numberBlurSteps(iBars) == 0
                strctTrial.numberBlurSteps(iBars) = 1;
            elseif strctTrial.numberBlurSteps(iBars) > 250
                % don't exceed the number of CLUT slots
                strctTrial.numberBlurSteps(iBars) = 250;
            end
            
            
        end
        
    else
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
        strctTrial.m_afSphereCoordinates =  g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.afSphereCoordinates(g_strctParadigm.m_iSelectedColorIndex,:);
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
        strctTrial.m_afSphereCoordinates =  g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.afSphereCoordinates(g_strctParadigm.m_iSelectedColorIndex,:);
        
        
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
        strctTrial.m_strSelectedSaturationName = g_strctParadigm.m_strctCurrentSaturationLookup{g_strctParadigm.m_iSelectedSaturationIndex};
        strctTrial.m_afSphereCoordinates =  g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.afSphereCoordinates(g_strctParadigm.m_iSelectedColorIndex,:);
        
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
    if strcmp(g_strctParadigm.m_strTrialType,'Many Bar')
        for iBars = 1:fnTsGetVar('g_strctParadigm','ManyBarNumberOfBars')
            [strctTrial.m_aiLocalStimColor(iBars,1),strctTrial.m_aiLocalStimColor(iBars,2),strctTrial.m_aiLocalStimColor(iBars,3)] = ...
                fnTsGetVar('g_strctParadigm',[currentBlockStimulusColorsR,num2str(iBars)],...
                [currentBlockStimulusColorsG,num2str(iBars)],...
                [currentBlockStimulusColorsB,num2str(iBars)]);
        end
        
        strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor /255)*65535);
        
        
        %fnTsGetVar('g_strctParadigm',[currentBlockStimulusColorsR,'0'])
        %strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.([currentBlockStimulusColorsR,'0']).Buffer(1,:,g_strctParadigm.([currentBlockStimulusColorsR,'0']).BufferIdx))...
        %  squeeze(g_strctParadigm.([currentBlockStimulusColorsG,'0']).Buffer(1,:,g_strctParadigm.([currentBlockStimulusColorsG,'0']).BufferIdx))...
        % squeeze(g_strctParadigm.([currentBlockStimulusColorsB,'0']).Buffer(1,:,g_strctParadigm.([currentBlockStimulusColorsB,'0']).BufferIdx))];
        % end
        %  strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor /255)*65535);
        
    else
        strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.(currentBlockStimulusColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsR).BufferIdx))...
            squeeze(g_strctParadigm.(currentBlockStimulusColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsG).BufferIdx))...
            squeeze(g_strctParadigm.(currentBlockStimulusColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsB).BufferIdx))];
        
        strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor /255)*65535);
    end
else
    
    strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.MovingBarStimulusRed.Buffer(1,:,g_strctParadigm.MovingBarStimulusRed.BufferIdx)), ...
        squeeze(g_strctParadigm.MovingBarStimulusGreen.Buffer(1,:,g_strctParadigm.MovingBarStimulusGreen.BufferIdx)),...
        squeeze(g_strctParadigm.MovingBarStimulusBlue.Buffer(1,:,g_strctParadigm.MovingBarStimulusBlue.BufferIdx))];
    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor/255)*65535);
end



if strcmp(strctTrial.m_strTrialType,'Many Bar') && (g_strctParadigm.m_bCycleColors || g_strctParadigm.m_bRandomColor)
    %strctTrial.m_aiStimXYZ
    %strctTrial.m_iCurrentlySelectedDKLCoordinateID
    
    xCoord = strctTrial.m_iXCoordinate(strctTrial.m_iCurrentlySelectedDKLCoordinateID);
    yCoord = strctTrial.m_iYCoordinate(strctTrial.m_iCurrentlySelectedDKLCoordinateID);
    zCoord = strctTrial.m_iZCoordinate;
    
    sphCoords(3) = sqrt(xCoord^2+yCoord^2+zCoord^2);
    sphCoords(1) = atan(yCoord/xCoord);
    sphCoords(2) = atan(zCoord/sqrt(xCoord^2+yCoord^2));
    
    hue = atan(yCoord/xCoord);
    sat = sqrt(xCoord^2+yCoord^2);
    lum = 	sphCoords(3) * sin(sphCoords(2));
    
    
    numBars = fnTsGetVar('g_strctParadigm','ManyBarNumberOfBarsSelected');
    
    %fnTsGetVar('g_strctParadigm' ,'ManyBarLumFullWidth')
    hueSpreadCoords = 	hue + ((rand(numBars,1)-.5) *...
        (fnTsGetVar('g_strctParadigm' ,'ManyBarHueFullWidth')*pi)/180);
    
    
    
    lumSpreadCoords = 	lum + ((rand(numBars,1)-.5) *...
        (fnTsGetVar('g_strctParadigm' ,'ManyBarLumFullWidth'))/100);
    
    satSpreadCoords = 	sat + ((rand(numBars,1)-.5) *...
        (fnTsGetVar('g_strctParadigm' ,'ManyBarSatFullWidth'))/100);
    
    radiusSpread = sqrt(lumSpreadCoords.^2 + satSpreadCoords.^2);
    elevationSpread = atan(lumSpreadCoords./ satSpreadCoords);
    
    %sphCoords(3) = sqrt(xCoord^2+yCoord^2+zCoord^2);
    %sphCoords(1) = atan(yCoord/xCoord);
    %sphCoords(2) = atan(zCoord/sqrt(xCoord^2+yCoord^2));
    
    [spreadXYZCoords(1,:),spreadXYZCoords(2,:),spreadXYZCoords(3,:)] = sph2cart(hueSpreadCoords, elevationSpread, radiusSpread);
    
    spreadRGBVals(1:numBars,:) = ldrgyv2rgb(spreadXYZCoords(3,:),spreadXYZCoords(1,:), spreadXYZCoords(2,:))';
    
    spreadRGBVals(spreadRGBVals > 1) = 1;
    spreadRGBVals(spreadRGBVals < 0) = 0;
    
    for iBars = 1:numBars
        strctTrial.m_aiStimColor(iBars,:) = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(spreadRGBVals(iBars, 1) * 65535) + 1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(spreadRGBVals(iBars, 2) * 65535) + 1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(spreadRGBVals(iBars, 3) * 65535) + 1)];
        strctTrial.m_aiLocalStimColor(iBars,:) = 	round((strctTrial.m_aiStimColor(iBars,:) / 65535) * 255);
        
    end
    strctTrial.m_bFlipForegroundBackground = false;
end
%strctTrial.m_iXCoordinate(strctTrial.m_iCurrentlySelectedDKLCoordinateID)
%strctTrial.m_iYCoordinate(strctTrial.m_iCurrentlySelectedDKLCoordinateID)
%strctTrial.m_iZCoordinate
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
if ~strcmp(strctTrial.m_strTrialType,'Image') && any(strctTrial.numberBlurSteps > 0)
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
        if(strcmp(strctTrial.m_strTrialType,'Many Bar'))
            strctTrial.m_aiCLUT = zeros(256,3);
            strctTrial.m_aiCLUT(256,:) = deal(65535);
            iLastCLUTIDX = 1;
            
            for iBars=1:1:fnTsGetVar('g_strctParadigm','ManyBarNumberOfBarsSelected' )
                %blurSteps = strctTrial.numberBlurSteps(numBars);
                
                strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
                strctTrial.m_aiCLUT(3+iLastCLUTIDX-1:3+strctTrial.numberBlurSteps(iBars)-1+ iLastCLUTIDX-1,1) = round(linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(iBars,1),strctTrial.numberBlurSteps(iBars))) ;
                strctTrial.m_aiCLUT(3+iLastCLUTIDX-1:3+strctTrial.numberBlurSteps(iBars)-1+ iLastCLUTIDX-1,2) = round(linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(iBars,2),strctTrial.numberBlurSteps(iBars))) ;
                strctTrial.m_aiCLUT(3+iLastCLUTIDX-1:3+strctTrial.numberBlurSteps(iBars)-1+ iLastCLUTIDX-1,3) = round(linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(iBars,3),strctTrial.numberBlurSteps(iBars))) ;
                strctTrial.m_iCLUTIDX(iBars,:) = [3+iLastCLUTIDX-1,3+strctTrial.numberBlurSteps(iBars)-1+ iLastCLUTIDX-1];
                iLastCLUTIDX = iLastCLUTIDX + strctTrial.numberBlurSteps(iBars);
            end
        else
            strctTrial.m_aiCLUT = zeros(256,3);
            strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,1) = round(linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(1),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,2) = round(linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(2),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,3) = round(linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(3),strctTrial.numberBlurSteps)) ;
            strctTrial.m_aiCLUT(256,:) = deal(65535);
        end
        
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
strctTrial.m_aiLocalBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
strctTrial.m_aiBlurStepHolder = zeros(3,sum(strctTrial.numberBlurSteps),strctTrial.numFrames);
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
    if ~strcmp(strctTrial.m_strTrialType,'Many Bar')
        for iFrames = 1:strctTrial.numFrames
            
            strctTrial.m_aiLocalBlurStepHolder(1,:,iFrames) = deal(round(linspace(strctTrial.m_afLocalBackgroundColor(1),strctTrial.m_aiLocalStimColor(1),strctTrial.numberBlurSteps)));
            strctTrial.m_aiLocalBlurStepHolder(2,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(2),strctTrial.m_aiLocalStimColor(2),strctTrial.numberBlurSteps));
            strctTrial.m_aiLocalBlurStepHolder(3,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(3),strctTrial.m_aiLocalStimColor(3),strctTrial.numberBlurSteps));
            strctTrial.m_aiBlurStepHolder(1,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
            strctTrial.m_aiBlurStepHolder(2,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
            strctTrial.m_aiBlurStepHolder(3,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        end
    else
        
        
        for iFrames = 1:strctTrial.numFrames
            lastBlurStepIDX = 1;
            
            for iBars = 1:strctTrial.m_iNumberOfBars
                strctTrial.m_aiLocalBlurStepHolder(1,lastBlurStepIDX:strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1,iFrames) = deal(round(linspace(strctTrial.m_afLocalBackgroundColor(1),strctTrial.m_aiLocalStimColor(iBars,1),strctTrial.numberBlurSteps(iBars))));
                strctTrial.m_aiLocalBlurStepHolder(2,lastBlurStepIDX:strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(2),strctTrial.m_aiLocalStimColor(iBars,2),strctTrial.numberBlurSteps(iBars)));
                strctTrial.m_aiLocalBlurStepHolder(3,lastBlurStepIDX:strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(3),strctTrial.m_aiLocalStimColor(iBars,3),strctTrial.numberBlurSteps(iBars)));
                strctTrial.m_aiBlurStepHolder(1,lastBlurStepIDX:strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset+lastBlurStepIDX-1,g_strctParadigm.m_iCLUTOffset+lastBlurStepIDX-1+strctTrial.numberBlurSteps(iBars)-1,strctTrial.numberBlurSteps(iBars)));
                strctTrial.m_aiBlurStepHolder(2,lastBlurStepIDX:strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset+lastBlurStepIDX-1,g_strctParadigm.m_iCLUTOffset+lastBlurStepIDX-1+strctTrial.numberBlurSteps(iBars)-1,strctTrial.numberBlurSteps(iBars)));
                strctTrial.m_aiBlurStepHolder(3,lastBlurStepIDX:strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset+lastBlurStepIDX-1,g_strctParadigm.m_iCLUTOffset+lastBlurStepIDX-1+strctTrial.numberBlurSteps(iBars)-1,strctTrial.numberBlurSteps(iBars)));
                strctTrial.m_iBlurStepIDX(iBars,:) = [lastBlurStepIDX,strctTrial.numberBlurSteps(iBars)+lastBlurStepIDX-1];
                lastBlurStepIDX = lastBlurStepIDX + strctTrial.numberBlurSteps(iBars);
            end
        end
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


