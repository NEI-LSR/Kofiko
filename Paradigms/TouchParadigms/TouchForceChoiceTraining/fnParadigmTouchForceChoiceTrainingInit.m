function bSuccessful = fnParadigmTouchForceChoiceInit()
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global g_strctParadigm g_strctDynamicStimLog g_strctAppConfig g_strctPTB g_strctDAQParams g_strctCycle



 g_strctCycle.TIC = 0;
 g_strctCycle.TIC1 = 0;
g_strctParadigm.m_strctMonkeyInfo = g_strctAppConfig.m_strctMonkeyInfo;
% Default initializations...
g_strctParadigm.m_fStartTime = GetSecs;
g_strctParadigm.m_iMachineState = 0; % Always initialize first state to zero.
g_strctParadigm.m_bDebugModeEnabled = false;

g_strctParadigm.m_strctSubject = g_strctAppConfig.m_strctSubject;
g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath = [g_strctAppConfig.m_strctDirectories.m_strLogFolder, g_strctParadigm.m_strctSubject.m_strExperimentName];
mkdir(g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath);
g_strctParadigm.m_strctSubject.m_strExperimentHistoryFileName = [g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath,'\',g_strctParadigm.m_strctSubject.m_strExperimentName];

g_strctParadigm.m_strExperimentName = g_strctParadigm.m_strctMonkeyInfo.m_strExperimentName;
g_strctParadigm.m_strInitial_ExperimentName = g_strctParadigm.m_strExperimentName;

iSmallBuffer = 500;
iLargeBuffer = 50000;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StartingHue', g_strctParadigm.m_fInitial_StartingHue, iSmallBuffer);
fnInitializeColorsTouchForceChoiceTraining();


if isfield(g_strctParadigm, 'm_strInitial_BackgroundColor')
	%disp('found background color')
	g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BackgroundColor',  g_strctParadigm.m_fInitial_BackgroundColor, iSmallBuffer);
end
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BackgroundLUVCoordinates', g_strctParadigm.m_afInitial_BackgroundLUVCoordinates, iSmallBuffer);


g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');
g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter = [(g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenSize(3)-g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenSize(1))/2, ...
																		(g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenSize(4)-g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenSize(2))/2];
g_strctParadigm.m_strctStimuliVars = [];
% Clut stuff. init this once and then modify for trials.
g_strctParadigm.m_afMasterClut = zeros(256,3);
    uncorrectedGrayRGB = floor(ldrgyv2rgb(0,0,0)*65535);
	
	g_strctParadigm.m_aiBackgroundColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedGrayRGB(1,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedGrayRGB(2,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedGrayRGB(3,:)+1))];
    g_strctParadigm.m_aiLocalBackgroundColor = round((g_strctParadigm.m_aiBackgroundColor/65535)*255);
    %{
    g_strctParadigm.m_aiBackgroundColor = ...
                                                        [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedGrayRGB(1,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedGrayRGB(2,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedGrayRGB(3,:)+1))];
%}
g_strctParadigm.m_afMasterClut(2,:) = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedGrayRGB(1,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedGrayRGB(2,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedGrayRGB(3,:)+1))];
g_strctParadigm.m_afMasterClut(256,:) =  [65535 65535 65535];


% Stim Server Refresh for calculating stuff during prep
g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate = fnParadigmToKofikoComm('GetRefreshRate');





%% Pre Cue

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueFixationPeriodMS', g_strctParadigm.m_fInitial_PreCueFixationPeriodMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueFixationSpotPix', g_strctParadigm.m_fInitial_PreCueFixationSpotSize, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueFixationRegion', g_strctParadigm.m_fInitial_PreCueFixationRegion, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueJuiceTimeMS', g_strctParadigm.m_fInitial_PreCueJuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueRewardProbability', g_strctParadigm.m_fInitial_PreCueRewardProbability, iSmallBuffer);



g_strctParadigm.m_bPreCueReward = g_strctParadigm.m_fInitial_PreCueReward;


if isfield(g_strctParadigm,'m_strInitial_PreCueFixationSpotType')
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueFixationSpotType', g_strctParadigm.m_strInitial_PreCueFixationSpotType, iSmallBuffer);
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreCueFixationSpotType', 'Disc', iSmallBuffer);
end


%% Cue

% PTB GUI update of variables crap
g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
g_strctPTB.m_variableUpdating = false;
g_strctParadigm.m_bLocalDrawParamsInitialized = 0;
g_strctParadigm.m_bChoicePositionTypeUpdated = 0;

g_strctParadigm.m_strCueType = 'disc';

g_strctParadigm.m_strctEyeSmoothing.m_afEyeSmoothingArray = zeros(g_strctParadigm.m_fInitial_EyeSmoothingKernel,2);
g_strctParadigm.m_strctEyeSmoothing.m_iEyeSmoothingIndex = 1;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'EyeSmoothingKernel', g_strctParadigm.m_fInitial_EyeSmoothingKernel, iSmallBuffer);
g_strctParadigm.m_strctEyeSmoothing.m_bEyeSmoothingEnabled = g_strctParadigm.m_fInitial_EyeSmoothingEnabled;

% Statistics and onscreen feedback

% Nice 3d array for keeping track of correct, incorrect, timeout and abort by color and saturation

g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix = zeros(4,numel(g_strctParadigm.m_aiPresetDKLSaturations),16); % answer type, saturation, color
g_strctParadigm.m_aiSelectedSaturationsLookup = 1;

g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionCorrect = zeros(1,20);


g_strctParadigm.m_strctStatistics.m_aiCorrect = 0;
g_strctParadigm.m_strctStatistics.m_aiIncorrect = 0;
g_strctParadigm.m_strctStatistics.m_aiTimeout = 0;
g_strctParadigm.m_strctStatistics.m_aiBrokeFixationOrAborted = 0;
g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias = zeros(1,20);
g_strctParadigm.m_strctStatistics.m_aiAnswerColorBias= zeros(1,16);
g_strctParadigm.m_strctStatistics.m_afDirectionPolarRadius = 100;

g_strctParadigm.m_strctStatistics.m_aiDirectionBiasPolarLocation = [1200,400];
g_strctParadigm.m_strctStatistics.m_aiColorBiasPolarLocation = [1200,600];

g_strctParadigm.m_strctStatistics.m_afColorPolarRadius = 100;
g_strctPTB.m_afDirectionPolarRect = [1200-g_strctParadigm.m_strctStatistics.m_afDirectionPolarRadius,400-g_strctParadigm.m_strctStatistics.m_afDirectionPolarRadius,...
											1200+g_strctParadigm.m_strctStatistics.m_afDirectionPolarRadius,400+g_strctParadigm.m_strctStatistics.m_afDirectionPolarRadius];
g_strctPTB.m_afColorPolarRect = [1200-g_strctParadigm.m_strctStatistics.m_afColorPolarRadius,600-g_strctParadigm.m_strctStatistics.m_afColorPolarRadius,...
										1200+g_strctParadigm.m_strctStatistics.m_afColorPolarRadius,600+g_strctParadigm.m_strctStatistics.m_afColorPolarRadius];
g_strctParadigm.m_bPolarPlot = 1;
g_strctPTB.m_afPolarOutlineColors = [0, 255, 0];
g_strctPTB.m_afPolarColors = [255, 0, 0];



g_strctParadigm.CLUTOffset = g_strctParadigm.m_fInitial_CLUTOffset;





for i = 1:20
g_strctParadigm.m_strctStatistics.m_afDirectionRotAngle(i) = (i/20) * 2 * pi;
g_strctParadigm.m_strctStatistics.m_afDirectionPolarPlottingArray(i,:) = g_strctParadigm.m_strctStatistics.m_aiDirectionBiasPolarLocation;
end
for i = 1:16
g_strctParadigm.m_strctStatistics.m_afColorRotAngle(i) = (i/16) * 2 * pi;
g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray(i,:) = g_strctParadigm.m_strctStatistics.m_aiColorBiasPolarLocation;
end

% Correct for an offset of one in the color array
g_strctParadigm.m_strctStatistics.m_afColorRotAngle = circshift(g_strctParadigm.m_strctStatistics.m_afColorRotAngle,[0, 1]);


%% training mode 
g_strctParadigm.m_strctTrainingVars.m_bTrainingMode = 1;
g_strctParadigm.m_strctTrainingVars.m_bAutoBalance = 1;
g_strctParadigm.m_strctTrainingVars.m_bAutoBalanceJuiceReward = 0;
g_strctParadigm.m_strctTrainingVars.m_fJackpotChance = .005;
g_strctParadigm.m_strctTrainingVars.m_bCorrectEyeDrift = 1;
g_strctParadigm.m_iDriftCorrectIteration = 1;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TrialWeightingLimits', g_strctParadigm.m_fInitial_TrialWeightingLimits, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'EyeDriftCorrectionRate', g_strctParadigm.m_fInitial_EyeDriftCorrectionRate, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TrialsInBuffer', 200, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TrialsToUseForWeighting', 20, iSmallBuffer);

%g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularBuffer = zeros(4,numel(g_strctParadigm.m_cMasterColorTableLookup),16,200);
g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularDirectionBuffer = zeros(4,20,squeeze(g_strctParadigm.TrialsInBuffer.Buffer(1,:,g_strctParadigm.TrialsInBuffer.BufferIdx)));
g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularColorBuffer = zeros(4,16,squeeze(g_strctParadigm.TrialsInBuffer.Buffer(1,:,g_strctParadigm.TrialsInBuffer.BufferIdx)));

g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularColorBufferIDs = ones(16,1);
g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularDirectionBufferIDs = ones(20,1);

g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter = zeros(1,3); % color, saturation, direction
g_strctParadigm.m_strctTrainingVars.m_iMaxConsecutiveTrials = 2;

g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix = zeros(4,numel(g_strctParadigm.m_aiPresetDKLSaturations),16); % answer type, saturation, color

g_strctParadigm.m_strctTrainingVars.m_fColorBalance = .5;
g_strctParadigm.m_strctTrainingVars.m_bFirstTrial = 1;
g_strctParadigm.m_strctTrainingVars.m_iMinimumTrialsBeforeBalance = 15;
g_strctParadigm.m_strctTrainingVars.m_iMinimumDirectionCountBeforeBalance = 5;

%% Cue period/Stimulus
g_strctParadigm.m_fBlinkTimer = 0;
g_strctParadigm.m_bBlinkTimerActive = false;
g_strctParadigm.m_bDynamicStimuli = 1;
g_strctParadigm.m_bUseFixationSpotAsCue = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CuePeriodMS', g_strctParadigm.m_fInitial_CuePeriodMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueMemoryPeriodMS', g_strctParadigm.m_fInitial_CueMemoryPeriodMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueStimulusX', g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter(1), iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueStimulusY', g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter(2), iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueOrientation', g_strctParadigm.m_fInitial_CueOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueLength', g_strctParadigm.m_fInitial_CueLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueWidth', g_strctParadigm.m_fInitial_CueWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueFixationSpotPix', g_strctParadigm.m_fInitial_CueFixationSpotPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueFixationRegion', g_strctParadigm.m_fInitial_CueFixationRegion, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueJuiceTimeMS', g_strctParadigm.m_fInitial_CueJuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'IncludeGrayTrials', g_strctParadigm.m_fInitial_IncludeGrayTrials, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GrayTrialProbability', g_strctParadigm.m_fInitial_GrayTrialProbability, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueRhoDeviation', g_strctParadigm.m_fInitial_CueRhoDeviation, iSmallBuffer);

%{
if isfield(g_strctParadigm,'m_strInitial_SelectedCueColors')
    cAllColors = strsplit(g_strctParadigm.m_strInitial_SelectedCueColors,';');
    for iColors = 1:numel(cAllColors)
        g_strctParadigm.m_cAllCueColorsPerSat{iColors} = str2double(strsplit(cAllColors{iColors},' '));
        g_strctParadigm.m_cColorsDisplayedCount{iColors} = zeros(numel(g_strctParadigm.m_cAllCueColorsPerSat{iColors}),1);
    end
elseif isfield(g_strctParadigm,'m_fInitial_SelectedCueColors')
    cAllColors = {g_strctParadigm.m_fInitial_SelectedCueColors};
    for iColors = 1:numel(cAllColors)
        g_strctParadigm.m_cAllCueColorsPerSat{iColors} = cAllColors{iColors};
        g_strctParadigm.m_cColorsDisplayedCount{iColors} = zeros(numel(g_strctParadigm.m_cAllCueColorsPerSat{iColors}),1);
    end
elseif isfield(g_strctParadigm,'m_afInitial_SelectedCueColors')
    cAllColors = {g_strctParadigm.m_afInitial_SelectedCueColors};
    for iColors = 1:numel(cAllColors)
        g_strctParadigm.m_cAllCueColorsPerSat{iColors} = cAllColors{iColors};
        g_strctParadigm.m_cColorsDisplayedCount{iColors} = zeros(numel(g_strctParadigm.m_cAllCueColorsPerSat{iColors}),1);
    end
end

g_strctParadigm.m_aiColorsDisplayedCount = zeros(numel(aiAllSaturations),numel(cAllColors{:}));
%g_strctParadigm.m_aiColorsDisplayedCount = zeros(sum(cellfun(@numel,g_strctParadigm.m_cAllColorsPerSat)),1);% + fnTsGetVar('g_strctParadigm', 'IncludeGrayTrials'),1);
%}

if isfield(g_strctParadigm,'m_afInitial_SelectedCueSaturations')
    aiAllSaturations = g_strctParadigm.m_afInitial_SelectedCueSaturations;
   
elseif isfield(g_strctParadigm,'m_fInitial_SelectedCueSaturations')
    aiAllSaturations = g_strctParadigm.m_fInitial_SelectedCueSaturations;
    
end

if isfield(g_strctParadigm,'NTargets')
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NTargets', g_strctParadigm.m_fInitial_NTargets, iSmallBuffer);
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NTargets', 1, iSmallBuffer);
end

g_strctParadigm.m_bForceBalanceCueProbabilities = true;
if isfield(g_strctParadigm,'m_afInitial_numSelectionsPerSaturation')
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumSelectionsPerSaturation', g_strctParadigm.m_afInitial_numSelectionsPerSaturation, iSmallBuffer);
elseif isfield(g_strctParadigm,'m_fInitial_numSelectionsPerSaturation')
   g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumSelectionsPerSaturation', g_strctParadigm.m_fInitial_numSelectionsPerSaturation, iSmallBuffer); 
end
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumTexturesToPreparePerCue', g_strctParadigm.m_fInitial_NumTexturesToPreparePerCue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueLuminanceDeviation',g_strctParadigm.m_fInitial_CueLuminanceRange, iSmallBuffer);

% use the same number of luminance steps for the cue as for the choice
% numInitialChoices = numel(g_strctParadigm.m_afInitial_SelectedChoiceColors) * numel(g_strctParadigm.m_afInitial_SelectedChoiceSaturations);
% numInitialChoices_local = sum(cellfun(@numel,g_strctParadigm.m_cAllCueColorsPerSat));
numInitialChoices_local = 19; %hard-coded for 19-stimulus triangular tessalation

numInitialChoices = fnTsGetVar('g_strctParadigm','NTargets');

%numInitialChoices =  fnTsGetVar('g_strctParadigm', 'NTargets') * numel(g_strctParadigm.m_fInitial_SelectedCueSaturations);
numLuminanceStepsPerChoice = floor(253 / (numInitialChoices + 1));
if rem(numLuminanceStepsPerChoice,2) == 0
    numLuminanceStepsPerChoice = numLuminanceStepsPerChoice - 1;
end

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueLuminanceNoiseBlockSize', g_strctParadigm.m_fInitial_CueLuminanceNoiseBlockSize, iSmallBuffer);

fnParadigmToStimulusServer('ForceMessage', 'PrepareCueTextures', g_strctParadigm.m_strInitial_CueDisplayType,...
                                            fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'), 1,...
                                            [fnTsGetVar('g_strctParadigm', 'CueLength'),fnTsGetVar('g_strctParadigm', 'CueLength')], ...
                                            numLuminanceStepsPerChoice, ...
                                            g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'CueLuminanceNoiseBlockSize')) %,g_strctParadigm.m_cAllCueColorsPerSat);  

satString = strsplit(g_strctParadigm.m_strInitial_ChromaLookupLUV);
g_strctParadigm.m_strChromaLookupLUV = satString; 
for i = 1:numel(aiAllSaturations)
    activeSaturationsStr{i} = deblank(satString{aiAllSaturations(i)});
end

%{
[~, controlComputerColors] = fnCalculateColorsForChoiceDisplay(g_strctParadigm.m_afInitial_SelectedCueSaturations,...
                                                                                   g_strctParadigm.m_afInitial_SelectedCueColors, ...
                                                                                    activeSaturationsStr, ...
                                                                                    g_strctParadigm.m_fInitial_SelectedCueConversionID, ...
																					fnTsGetVar('g_strctParadigm', 'CueLuminanceDeviation'), ...
                                                                                    numLuminanceStepsPerChoice,...
                                                                                    g_strctParadigm.m_cAllColorsPerSat);
%}
[~, controlComputerColors] = fnCalculateColorsForChoiceTrainingAFCDisplay(aiAllSaturations,...
                                                                                    activeSaturationsStr, ...
                                                                                    g_strctParadigm.m_fInitial_SelectedCueConversionID, ...
																					fnTsGetVar('g_strctParadigm', 'CueLuminanceDeviation'), ...
                                                                                    numLuminanceStepsPerChoice);

fnInitializeCueTrainingTextures(g_strctParadigm.m_strInitial_CueDisplayType, fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'), ...
                                            numInitialChoices, [fnTsGetVar('g_strctParadigm', 'CueLength'),fnTsGetVar('g_strctParadigm', 'CueLength')], ...
                                            numLuminanceStepsPerChoice, g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'CueLuminanceNoiseBlockSize'), ...
											controlComputerColors)
g_strctParadigm.m_bCueTexturesInitialized = true;
g_strctParadigm.m_aiStimulusRect = [g_strctParadigm.m_fInitial_CueStimulusX - g_strctParadigm.m_fInitial_CueLength,...
									g_strctParadigm.m_fInitial_CueStimulusY - g_strctParadigm.m_fInitial_CueWidth,...
									g_strctParadigm.m_fInitial_CueStimulusX + g_strctParadigm.m_fInitial_CueLength,...
									g_strctParadigm.m_fInitial_CueStimulusY + g_strctParadigm.m_fInitial_CueWidth];
									
g_strctParadigm.m_aiCenterOfStimulus = [g_strctParadigm.m_fInitial_CueStimulusX, g_strctParadigm.m_fInitial_CueStimulusY];
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusPosition', [g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter(1),...
																		g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter(2)], iSmallBuffer);

g_strctParadigm.m_bCueReward = g_strctParadigm.m_fInitial_CueReward;
g_strctParadigm.m_strctStimuliVars.m_bCueHighlight = g_strctParadigm.m_fInitial_CueHighlight;
g_strctParadigm.m_strctStimuliVars.m_bDisplayCue = g_strctParadigm.m_fInitial_DisplayCue;
g_strctParadigm.m_strctStimuliVars.m_bLuminanceMaskedCueStimuli = true;
g_strctParadigm.m_strctStimuliVars.m_bOverrideGrayProbability = true;
g_strctParadigm.m_iInitial_IndexInSaturationList = aiAllSaturations;
for iSaturations = 1:numel(g_strctParadigm.m_iInitial_IndexInSaturationList)
    g_strctParadigm.m_cCurrentSaturationsLookup{iSaturations} = g_strctParadigm.m_cMasterColorTableLookup{g_strctParadigm.m_iCurrentColorConversionID}{g_strctParadigm.m_iInitial_IndexInSaturationList(iSaturations)};
end
for iSaturations = 1:numel(g_strctParadigm.m_iInitial_IndexInSaturationList)
    g_strctParadigm.m_strctCurrentSaturations{iSaturations} = ...
        {g_strctParadigm.m_strctMasterColorTable{g_strctParadigm.m_iCurrentColorConversionID}.(g_strctParadigm.m_cCurrentSaturationsLookup{iSaturations})};
end

if isfield(g_strctParadigm,'m_fInitial_CueNoiseLevel')
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueNoiseLevel', g_strctParadigm.m_fInitial_CueNoiseLevel, iSmallBuffer);
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueNoiseLevel', 0, iSmallBuffer);
end
if isfield( g_strctParadigm,'m_fInitial_CueSizePix')
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueSizePix', g_strctParadigm.m_fInitial_CueSizePix, iSmallBuffer);
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CueSizePix', 100, iSmallBuffer);
end

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'AbortTrialIfBreakFixationDuringCue', g_strctParadigm.m_fInitial_AbortTrialIfBreakFixationDuringCue, iSmallBuffer);

%% Memory
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryPeriodMS', g_strctParadigm.m_fInitial_MemoryPeriodMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryPeriodMinMS', g_strctParadigm.m_fInitial_MemoryPeriodMinMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryPeriodMaxMS', g_strctParadigm.m_fInitial_MemoryPeriodMaxMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryPeriodFixationSpotPix', g_strctParadigm.m_fInitial_MemoryPeriodFixationSpotPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryPeriodFixationRegionPix', g_strctParadigm.m_fInitial_MemoryPeriodFixationRegionPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryPeriodJuiceTimeMS', g_strctParadigm.m_fInitial_MemoryPeriodJuiceTimeMS, iSmallBuffer);
g_strctParadigm.m_bMemoryPeriodReward = g_strctParadigm.m_fInitial_MemoryPeriodReward;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryChoicePeriodMinMS', g_strctParadigm.m_fInitial_MemoryChoicePeriodMinMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryChoicePeriodMaxMS', g_strctParadigm.m_fInitial_MemoryChoicePeriodMaxMS, iSmallBuffer);
g_strctParadigm.bMemory = 0; 
g_strctParadigm.bMemoryChoice = 0; 

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryChoiceJuiceTimeMS', g_strctParadigm.m_fInitial_MemoryChoiceJuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MemoryChoiceRewardProbability', g_strctParadigm.m_fInitial_MemoryChoiceRewardProbability, iSmallBuffer);
g_strctParadigm.m_bMemoryChoiceReward = g_strctParadigm.m_fInitial_MemoryChoiceReward;


%% Choices
g_strctParadigm.m_strNullCategoryName = g_strctParadigm.m_strInitial_NullCategoryName;
g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial = g_strctParadigm.m_fInitial_RotateChoiceRingOnEachTrial;
g_strctParadigm.m_strctChoiceVars.m_bProgressiveRingRotation = true;
g_strctParadigm.m_strctChoiceVars.m_afLastRingRotationAngle = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'AFCChoiceLocation', g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter,iSmallBuffer);       %fnTsAddVar(g_strctParadigm, 'AFCChoiceLocation', g_strctParadigm.m_afInitial_AFCChoiceLocation,iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'SaturationBoundaryWidthMultiplier', g_strctParadigm.m_fInitial_SaturationBoundaryWidthMultiplier,iSmallBuffer);
g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors = g_strctParadigm.m_fInitial_InsertGrayBoundaryBetweenChoiceColors;
g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations = g_strctParadigm.m_fInitial_InsertGrayBoundaryBetweenChoiceSaturations;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceRingSize', g_strctParadigm.m_fInitial_ChoiceRingSize, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceRingChoices', g_strctParadigm.m_fInitial_ChoiceRingChoices, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceRingSaturation', g_strctParadigm.m_afInitial_ChoiceRingSaturation, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceRingElevation', g_strctParadigm.m_afInitial_ChoiceRingElevation, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceRingNumRings', g_strctParadigm.m_fInitial_NumChoiceRings, iSmallBuffer);
g_strctParadigm.m_strctChoiceVars.m_strChoiceRingOffsetType = g_strctParadigm.m_strInitial_ChoiceRingOffset;
g_strctParadigm.m_strctChoiceVars.m_strChoiceType = g_strctParadigm.m_strInitial_ChoiceType;
g_strctParadigm.m_iMaxChoiceRingSize = g_strctParadigm.m_fInitial_MaxChoiceRingSize; 
g_strctParadigm.m_iMinChoiceRingSize = g_strctParadigm.m_fInitial_MinChoiceRingSize;
g_strctParadigm.m_bSeparateRingChoicesBySaturation = g_strctParadigm.m_fInitial_SeparateRingChoicesBySaturation;
g_strctParadigm.m_bRewardCorrectNullTrials = true;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'AnnulusCenterOffset', g_strctParadigm.m_fInitial_AnnulusCenterOffset,iSmallBuffer);      
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'AnnulusSaturationSeparation', g_strctParadigm.m_fInitial_AnnulusSaturationSeparation,iSmallBuffer);      
g_strctParadigm.m_strctStimuliVars.m_bDirectMatchCueChoices = g_strctParadigm.m_fInitial_DirectMatchCueChoices;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ProbeTrialProbability', g_strctParadigm.m_fInitial_ProbeTrialProbability,iSmallBuffer); 

g_strctParadigm.m_iAzimuthRoundToDec = -2;
%g_strctParadigm.m_fChoiceLuminanceDeviation = g_strctParadigm.m_fInitial_ChoiceLuminanceRange;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceLuminanceDeviation',g_strctParadigm.m_fInitial_ChoiceLuminanceRange, iSmallBuffer);


g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceSize', g_strctParadigm.m_fInitial_ChoiceSize, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceWidth', g_strctParadigm.m_fInitial_ChoiceWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceLength', g_strctParadigm.m_fInitial_ChoiceLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceEccentricity', g_strctParadigm.m_fInitial_ChoiceEccentricity, iSmallBuffer); % How far from center screen are choices displayed
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'InsideChoiceRegion', g_strctParadigm.m_fInitial_InsideChoiceRegion, iSmallBuffer); % How far from center screen are choices displayed
g_strctParadigm.m_strctChoiceVars.m_bFrameChoiceAreas = g_strctParadigm.m_fInitial_FrameChoiceAreas;

g_strctParadigm.m_acAvailableChoiceDisplayTypes = strsplit(g_strctParadigm.m_strInitial_ChoiceDisplayTypes);
g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType = deblank(g_strctParadigm.m_acAvailableChoiceDisplayTypes{g_strctParadigm.m_fInitial_ChoiceDisplayID});

g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier = g_strctParadigm.m_fInitial_ChoiceMinimumSeparationMultiplier;
g_strctParadigm.m_strctChoicesVars.m_afChoicesLocationWeights = [50,50;50,50]; %left right top bottom 
g_strctParadigm.m_strctChoicesVars.m_aiChoiceSelectedCounter = zeros(2,2); % Keeps track of how many times the monkey selected a choice at each location
																		  % We'll use this to weight the choices so the monkey doesn't choose the same place every time
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceLocationWeights', [50], iSmallBuffer);
g_strctParadigm.m_strctChoicesVars.m_bChoicesLocationsWeightingOverride = 1;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'RetainSelectedChoicePeriodMS', g_strctParadigm.m_fInitial_RetainSelectedChoicePeriodMS, iSmallBuffer);
g_strctParadigm.m_strctPostTrialVars.m_bExtinguishNonSelectedChoicesAfterChoice = 1;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumberOfChoices', g_strctParadigm.m_fInitial_NumberOfChoices, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceFixationSpotPix', g_strctParadigm.m_fInitial_ChoiceFixationSpotPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceFixationRegion', g_strctParadigm.m_fInitial_ChoiceFixationRegion, iSmallBuffer);
g_strctParadigm.m_strctChoiceVars.m_bShowFixationSpot = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSpotPersistPeriodMS', g_strctParadigm.m_fInitial_FixationSpotPersistPeriodMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'HoldToSelectChoiceMS', g_strctParadigm.m_fInitial_HoldToSelectChoiceMS, iSmallBuffer);
g_strctParadigm.m_strctChoiceVars.m_strChoicePositionType = 'LeftRight';
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'minChoiceAngleDeg', g_strctParadigm.m_fInitial_minChoiceAngleDeg, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'maxChoiceAngleDeg', g_strctParadigm.m_fInitial_maxChoiceAngleDeg, iSmallBuffer);

%g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceColors = g_strctParadigm.m_afInitial_SelectedChoiceColors;
if isfield(g_strctParadigm,'m_strInitial_SelectedChoiceColors')
    cAllColors = strsplit(g_strctParadigm.m_strInitial_SelectedChoiceColors,';');
    for iColors = 1:numel(cAllColors)
        g_strctParadigm.m_cAllChoiceColorsPerSat{iColors} = str2double(strsplit(cAllColors{iColors},' '));
        g_strctParadigm.m_cColorsDisplayedCount{iColors} = zeros(numel(g_strctParadigm.m_cAllChoiceColorsPerSat{iColors}),1);
    end
elseif isfield(g_strctParadigm,'m_fInitial_SelectedChoiceColors')
    cAllColors = {g_strctParadigm.m_fInitial_SelectedChoiceColors};
    for iColors = 1:numel(cAllColors)
        g_strctParadigm.m_cAllChoiceColorsPerSat{iColors} = cAllColors{iColors};
        g_strctParadigm.m_cColorsDisplayedCount{iColors} = zeros(numel(g_strctParadigm.m_cAllChoiceColorsPerSat{iColors}),1);
    end
elseif isfield(g_strctParadigm,'m_afInitial_SelectedChoiceColors')
    cAllColors = {g_strctParadigm.m_afInitial_SelectedChoiceColors};
    for iColors = 1:numel(cAllColors)
        g_strctParadigm.m_cAllChoiceColorsPerSat{iColors} = cAllColors{iColors};
        g_strctParadigm.m_cColorsDisplayedCount{iColors} = zeros(numel(g_strctParadigm.m_cAllChoiceColorsPerSat{iColors}),1);
    end
end
if isfield(g_strctParadigm,'m_afInitial_SelectedChoiceSaturations')
g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations = g_strctParadigm.m_afInitial_SelectedChoiceSaturations;
elseif isfield(g_strctParadigm,'m_fInitial_SelectedChoiceSaturations')
g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations = g_strctParadigm.m_fInitial_SelectedChoiceSaturations;
end
%{
if isfield(g_strctParadigm,'m_afInitial_SelectedChoiceColors')
g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceColors = g_strctParadigm.m_afInitial_SelectedChoiceColors;
elseif isfield(g_strctParadigm,'m_fInitial_SelectedChoiceColors')
g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceColors = g_strctParadigm.m_fInitial_SelectedChoiceColors;
end
%}



g_strctParadigm.m_strctChoiceVars.m_bForceChoiceColorConversionMatchToCueType = 1;
g_strctParadigm.m_strctChoiceVars.m_iInitialChoiceColorConversionType = g_strctParadigm.m_fInitial_SelectedChoiceConversionType;
g_strctParadigm.m_strctChoiceVars.m_aiNumChoiceColorsPerSaturations = g_strctParadigm.m_afInitial_NumChoiceColorsPerSaturations;
g_strctParadigm.m_strctChoiceVars.m_aiChoiceSaturationsDKL = g_strctParadigm.m_afInitial_ChoiceSaturationsDKL;
g_strctParadigm.m_strctChoiceVars.m_strSaturationsLookupDKL	= g_strctParadigm.m_strInitial_ChoiceSaturationsLookupDKL;
g_strctParadigm.m_strctChoiceVars.m_aiChoiceSaturationsElevationDKL	= g_strctParadigm.m_afInitial_ChoiceSaturationsElevationDKL;

g_strctParadigm.m_strctChoiceVars.m_strNullConditionName = g_strctParadigm.m_strInitial_NullConditionName;
g_strctParadigm.m_strctChoiceVars.m_aiChoiceChromaLUV =	g_strctParadigm.m_afInitial_ChoiceChromaLUV;
g_strctParadigm.m_strctChoiceVars.m_aiChoiceChromaLookupLUV = g_strctParadigm.m_strInitial_ChoiceChromaLookupLUV;
g_strctParadigm.m_strctChoiceVars.m_aiChoiceChromaElevationsLUV = g_strctParadigm.m_afInitial_ChoiceChromaElevationsLUV;

g_strctParadigm.m_strctChoiceVars.m_bForceMatchChoiceShapeParametersToCue = g_strctParadigm.m_fInitial_ForceMatchChoiceShapeParamsToCue;

g_strctParadigm.m_strctChoiceVars.m_bProgressiveChoiceRingRotation = 0;
g_strctParadigm.m_strctChoiceVars.m_fLastChoiceRingRotation = 0;
g_strctParadigm.m_strctChoiceVars.m_iChoiceRingRotationIncrement= 22.5;
g_strctParadigm.m_strctChoiceVars.m_bRandomRingOrderInversion = g_strctParadigm.m_fInitial_RandomRingOrderInversion;
%g_strctParadigm.m_strctChoiceVars.m_QuadrantsSelected = strsplit(g_strctParadigm.m_strInitial_QuadrantsSelected);
g_strctParadigm.m_strctChoicePeriod.m_bSortChoiceHues = g_strctParadigm.m_fInitial_SortChoiceHues;
% g_strctParadigm.m_strctChoiceVars.m_NTargets = 1;  



%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NTargets', g_strctParadigm.m_fInitial_NTargets, iSmallBuffer)
%g_strctParadigm.NTargets = g_strctParadigm.m_fInitial_NTargets; 


%g_strctParadigm.m_ciQuadrantsSelected = {1 2 3 4}; 

%% noise patterns

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumTexturesToPreparePerChoice', g_strctParadigm.m_fInitial_NumTexturesToPreparePerChoice, iSmallBuffer);

%numInitialChoices = numel(g_strctParadigm.m_afInitial_SelectedChoiceColors) * numel(g_strctParadigm.m_afInitial_SelectedChoiceSaturations);
%numInitialChoices = sum(cellfun(@numel,g_strctParadigm.m_cAllChoiceColorsPerSat));
%numInitialChoices =  fnTsGetVar('g_strctParadigm', 'NTargets')
numLuminanceStepsPerChoice = floor(253 / (numInitialChoices + 1)); 

if rem(numLuminanceStepsPerChoice,2) == 0
    numLuminanceStepsPerChoice = numLuminanceStepsPerChoice - 1;
end

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ChoiceLuminanceNoiseBlockSize', g_strctParadigm.m_fInitial_ChoiceLuminanceNoiseBlockSize, iSmallBuffer);

fnParadigmToStimulusServer('ForceMessage', 'PrepareChoiceTextures', g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType,...
                                            fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'), numInitialChoices,...
                                            [fnTsGetVar('g_strctParadigm', 'ChoiceLength'),fnTsGetVar('g_strctParadigm', 'ChoiceWidth')], ...
                                            numLuminanceStepsPerChoice, ...
                                            g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceNoiseBlockSize'));
                                        
satString = strsplit(g_strctParadigm.m_strctChoiceVars.m_aiChoiceChromaLookupLUV);
for i = 1:numel(g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations)
    activeSaturationsStr{i} = deblank(satString{g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations(i)});
end

[~, controlComputerColors] = fnCalculateColorsForChoiceTrainingAFCDisplay(g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations, ...
                                                                                    activeSaturationsStr,...
                                                                                    g_strctParadigm.m_strctChoiceVars.m_iInitialChoiceColorConversionType, ...
																					fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceDeviation'),...
                                                                                    numLuminanceStepsPerChoice);
			
                                                                                

fnInitializeChoiceTextures(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'), ...
                                            numInitialChoices_local, [fnTsGetVar('g_strctParadigm', 'ChoiceLength'),fnTsGetVar('g_strctParadigm', 'ChoiceWidth')], ...
                                            numLuminanceStepsPerChoice, g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceNoiseBlockSize'), ...
											controlComputerColors)
g_strctParadigm.m_bChoiceTexturesInitialized = true;

%% Post-Choice
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'InterTrialIntervalMinMS', g_strctParadigm.m_fInitial_InterTrialIntervalMinMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'InterTrialIntervalMaxMS', g_strctParadigm.m_fInitial_InterTrialIntervalMaxMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PostTrialJuiceTimeMS', g_strctParadigm.m_fInitial_PostTrialJuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TrialTimeoutMS', g_strctParadigm.m_fInitial_TrialTimeoutMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'IncorrectTrialPunishmentDelayMS', g_strctParadigm.m_fInitial_IncorrectTrialPunishmentDelayMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'AbortedTrialPunishmentDelayMS', g_strctParadigm.m_fInitial_AbortedTrialPunishmentDelayMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PostTrialFixationSpotPix', g_strctParadigm.m_fInitial_PostTrialFixationSpotPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PostTrialFixationRegion', g_strctParadigm.m_fInitial_PostTrialFixationRegion, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PostTrialReward', g_strctParadigm.m_fInitial_PostTrialReward, iSmallBuffer);

if isfield(g_strctParadigm,'m_fInitial_TimeoutMS')
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TimeoutMS', g_strctParadigm.m_fInitial_TimeoutMS, iSmallBuffer);
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TimeoutMS', 2000, iSmallBuffer);
end

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'IncorrectTrialDelayMS ', g_strctParadigm.m_fInitial_IncorrectTrialDelayMS, iSmallBuffer);
 
% Log stuff
g_strctDynamicStimLog = [];
g_strctParadigm.m_strctLogVars.m_iLogEntryCounter = 0;
g_strctParadigm.m_strctLogVars.m_iLogCounterBeforeSave = g_strctParadigm.m_fInitial_LogCounterBeforeSave;
g_strctParadigm.m_strctLogVars.m_bSaveAfterThisTrial = 0;
g_strctParadigm.m_strctLogVars.m_iLogSaves = 0; 
g_strctParadigm.m_strLogPath = g_strctParadigm.m_strInitial_LogDirectoryPath;
% Create this experiment's log folder
mkdir([g_strctParadigm.m_strLogPath,'\',g_strctParadigm.m_strExperimentName]);

% Fixation 

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationRadiusPix', g_strctParadigm.m_fInitial_FixationRadiusPix, iSmallBuffer);


%% Micro stim
g_strctParadigm.m_bParadigmActive = 0;
g_strctParadigm.m_bMicroStimThisTrial = 0;
g_strctParadigm.m_bMicroStimThisEpoch = 0;
g_strctParadigm.m_strCurrentEpoch = '';
g_strctParadigm.m_strctMicroStim.m_cEpochs = {'cue'};
g_strctParadigm.m_strctMicroStim.StimChannels = '1';
g_strctParadigm.m_strctMicroStim.m_fMicroStimChance = 1;
g_strctParadigm.m_strMicroStimSource = g_strctParadigm.m_strInitial_MicroStimSource;
g_strctParadigm.m_strMicroStimType = g_strctParadigm.m_strInitial_MicroStimType;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimActive', g_strctParadigm.m_fInitial_MicroStimActive, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimBiPolar', g_strctParadigm.m_fInitial_MicroStimBiPolar, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimAmplitude', g_strctParadigm.m_fInitial_MicroStimAmplitude, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimDelayMS', g_strctParadigm.m_fInitial_MicroStimDelayMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimPulseWidthMS', g_strctParadigm.m_fInitial_MicroStimPulseWidthMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimSecondPulseWidthMS', g_strctParadigm.m_fInitial_MicroStimSecondPulseWidthMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimBipolarDelayMS', g_strctParadigm.m_fInitial_MicroStimBipolarDelayMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimPulseRateHz', g_strctParadigm.m_fInitial_MicroStimPulseRateHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimTrainRateHz', g_strctParadigm.m_fInitial_MicroStimTrainRateHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimTrainDurationMS', g_strctParadigm.m_fInitial_MicroStimTrainDurationMS, iSmallBuffer);
%g_strctParadigm.m_bDoNotDrawDueToCriticalSection = 0; % Set to one while stimulation is active and we need the flip function to not block our timing



%% Reward

% Juice increment
g_strctParadigm.m_iPositiveJuiceIncrement = 0;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeMS', g_strctParadigm.m_fInitial_JuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BlinkTimeMS', g_strctParadigm.m_fInitial_BlinkTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeHighMS', g_strctParadigm.m_fInitial_JuiceTimeHighMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PositiveIncrement', g_strctParadigm.m_fInitial_PositiveIncrementPercent, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumberOfJuiceDrops', g_strctParadigm.m_fInitial_NumberOfJuiceDrops, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceDropInterval', g_strctParadigm.m_fInitial_JuiceDropInterval, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ProbeTrialRewardProbability', g_strctParadigm.m_fInitial_ProbeTrialRewardProbability, iSmallBuffer);

g_strctParadigm.m_bBinaryReward = g_strctParadigm.m_fInitial_BinaryReward; 


%%% Main output variable...

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'acTrials',{},iLargeBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ExperimentDesigns',{},iSmallBuffer);

%% Load initial design if available....
g_strctParadigm.m_acMedia = [];
g_strctParadigm.m_strctCurrentTrial = [];

%% Sync with stimulus server
if ~fnParadigmToKofikoComm('IsTouchMode')
    [fLocalTime, fServerTime, fJitter] = fnSyncClockWithStimulusServer(100);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'SyncTime',[fLocalTime,fServerTime,fJitter],iLargeBuffer);
end

g_strctParadigm.m_strAlignTo = 'CueOnset'; % TrialOnset / CueOnset / ChoicesOnset

fnParadigmToKofikoComm('SetFixationPosition',g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter);
g_strctParadigm.m_pt2fFixationSpot = g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter;




g_strctParadigm.m_strctPrevTrial = [];

g_strctParadigm.m_ahPTBHandles = [];
g_strctParadigm.m_bEmulatorON = 0;

g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = 0;
g_strctParadigm.m_strctTrialCounter.m_iTrialCounter = 0;
g_strctParadigm.m_iTrialCounter = 1;
g_strctParadigm.m_iTrialRep = 0;
g_strctParadigm.m_iSelectedBlockInDesignTable = 0;
g_strctParadigm.m_bTrialRepetitionOFF = false;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TR', 2000, iSmallBuffer);

g_strctParadigm.m_bMRI_Mode = false;
g_strctParadigm.m_fFirstTriggerTS = NaN;
g_strctParadigm.m_iTriggerCounter = 0;
g_strctParadigm.m_fRunLengthSec_fMRI = NaN;
g_strctParadigm.m_iActiveBlock = 1;
g_strctParadigm.m_aiCumulativeTRs = NaN;
g_strctParadigm.m_iActiveBlock = 0;
g_strctParadigm.m_fMicroStimTimer = 0;

g_strctParadigm.m_strState = 'Doing Nothing';
g_strctParadigm = fnCleanup(g_strctParadigm);
bSuccessful = true;
return;

function g_strctParadigm = fnCleanup(g_strctParadigm)
 % Packs all the "initial" variables into a structure to clean up the
 % g_stractParadigm structure
fields = fieldnames(g_strctParadigm);
idx = strfind(fields,'Initial_');
idxLogical = ~cellfun(@isempty,idx);
fieldsToRM = fields(idxLogical);
for i = 1:numel(fieldsToRM)
	g_strctParadigm.m_strctInitialValues.(fieldsToRM{i}) = g_strctParadigm.(fieldsToRM{i});
end
g_strctParadigm = rmfield(g_strctParadigm,fieldsToRM);
return;