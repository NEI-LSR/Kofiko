function bSuccessful = fnParadigmHandMappingInit()
%
% Copyright (c) 2015 Joshua Fuller-Deets, Massachusetts Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

% Add new variables here if extra trial types are added.
% Import variables from config xml using the format outlined below. 
% e.g. g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeMS', g_strctParadigm.m_fInitial_JuiceTimeMS, iSmallBuffer);

global g_strctParadigm g_strctStimulusServer g_strctPTB g_strctAppConfig g_strctPlexon g_strctLocalExperimentRecording g_strctSystemCodes g_strctCycle g_strctRealTimeStatServer

iSmallBuffer = 500;
iLargeBuffer = 50000;

g_strctParadigm.m_iTrialNumber = 1;

%Add field 'numberOfBarsManyBar' to the structure 'g_strctParadigm'%('numberOfBarsManyBar' is the max number of bars can be created) 
g_strctParadigm=fnTsAddVar(g_strctParadigm,'numberOfBarsManyBar',10,iSmallBuffer); % numberOfBarsManyBar can be changed to any value

% g_strctParadigm.numberOfBarsManyBar = 1; 



g_strctParadigm.m_strctSubject = g_strctAppConfig.m_strctSubject;
g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath = [g_strctAppConfig.m_strctDirectories.m_strLogFolder, g_strctParadigm.m_strctSubject.m_strExperimentName];
mkdir(g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath);
g_strctParadigm.m_strctSubject.m_strExperimentHistoryFileName = [g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath,'\',g_strctParadigm.m_strctSubject.m_strExperimentName];
g_strctParadigm.m_strctSubject.m_iBackupIter = 1;
g_strctParadigm.m_fStartTime = GetSecs;
g_strctLocalExperimentRecording = cell(20000,1);
g_strctParadigm.m_iLocalExperimentIter = 1;
g_strctParadigm.m_bSetDynamicTrialMode = 1;
g_strctParadigm.m_iLocalExperimentIterSinceLastBackup = 0;
% Default initializations...
g_strctParadigm.m_iMachineState = 0; % Always initialize first state to zero.

g_strctParadigm.m_iUserCommentIteration = 1;
g_strctParadigm.m_bFlipJustOccurred = false;
%{
g_strctParadigm.m_cPresetColors{1,1} = [255, 0, 0];
g_strctParadigm.m_cPresetColors{1,2} = [0,154,38]; 
g_strctParadigm.m_cPresetColors{2,1} = [0, 252, 0];
g_strctParadigm.m_cPresetColors{2,2} = [255, 0, 55];
g_strctParadigm.m_cPresetColors{3,1} = [148, 0, 255];
g_strctParadigm.m_cPresetColors{3,2} = [52, 209, 0]; 
g_strctParadigm.m_bInvertPresetColors = false;
%}
g_strctParadigm.m_strctGammaCorrectedLookupTable = load('gammaCorrectedLookUpTable');
g_strctParadigm.m_strctConversionMatrices = load('ConversionMatrices');

g_strctParadigm.m_aiPresetSaturations = g_strctParadigm.m_afInitial_Saturations;

%Initial_Saturations = 90 50 30 10 5
%Initial_SaturationsAzimuthSteps = "16"
%g_strctParadigm.Initial_SaturationsEleveation = "0"
g_strctParadigm.m_acstrSaturationsLookup = strsplit(g_strctParadigm.m_strInitial_SaturationsLookup);

%g_strctParadigm.m_strctGammaCorrectedLookupTable = load('gammaCorrectedLookUpTable');
%g_strctParadigm.m_strctConversionMatrices = load('ConversionMatrices');
for iSaturations = 1:numel(g_strctParadigm.m_aiPresetSaturations)

	g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).azimuthSteps = ...
									deg2rad(0:360/g_strctParadigm.m_fInitial_SaturationsAzimuthSteps:359.99);
                                
    g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).Radius = g_strctParadigm.m_aiPresetSaturations(iSaturations)/100;
    
	%g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).Elevation = 0;
    
	[x,y,z] = sph2cart(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).azimuthSteps, ...
		ones(1,numel(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).azimuthSteps)) * ...
			(0 ), ...
			g_strctParadigm.m_aiPresetSaturations(iSaturations)/100) ;
        
    g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(:,1) = x;
	g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(:,2) = y;
	g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(:,3) = g_strctParadigm.m_afInitial_SaturationsElevation(iSaturations);
    g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).afSphereCoordinates = ...
        [g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).azimuthSteps',...
        ones(numel(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).azimuthSteps),1) * g_strctParadigm.m_afInitial_SaturationsElevation(iSaturations),...
        ones(numel(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).azimuthSteps),1) * g_strctParadigm.m_aiPresetSaturations(iSaturations)/100];
        
	%g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).Elevation;
    %g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.SaturationsLookup{iSaturations}).rgb 
    uncorrectedRGB = floor(ldrgyv2rgb(ones(1,numel(x)) * g_strctParadigm.m_afInitial_SaturationsElevation(iSaturations),x,y)*65535);
    g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).RGB = ...
                                                        [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedRGB(1,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedRGB(2,:)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedRGB(3,:)+1))];
       
    %g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(strctTrial.m_aiUncorrectedCLUT(1,:)*65535)+1);
    %{
     for iColors = 1:size(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ,1)
            
            [g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).az(iColors), ...
                g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).el(iColors),...
                g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).rad(iColors)] = ...
                cart2sph(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,1),...
                g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,2),...
                g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,3));
                
             g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).el(iColors) = ...
                g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,3);
         
                theta(iSaturations,iColors) = tan(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,3) ...
                        /(sqrt(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,1)^2 ...
                        + g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,2)^2)));
                    rad(iSaturations,iColors) = cos(theta(iColors))*sqrt(g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,1)^2 ...
                        + g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,2)^2 ... 
                        + g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_acstrSaturationsLookup{iSaturations}).XYZ(iColors,3)^2);
				%rad = cos(theta)*sqrt(X^2 + Y^2 + Z^2);
         %{
    
                [az, el, rad] = cart2sph(X,Y,Z);
                el = Z;
				 %[az, el, rad] = cart2sph(X,Y,Z);
				%el = Z;
				theta = tan(Z/sqrt(X^2 + Y^2));
				rad = cos(theta)*sqrt(X^2 + Y^2 + Z^2);
				if isnan(theta)
                   theta = 0; 
                end
				if isnan(rad)
                   rad = 0; 
                end
			%}	
    
     end
    %}
    
	%g_strctParadigm.m_strctCurrentSaturation{iSaturations}.rgb = ldrgyv2rgb(z,x,y);
end
g_strctParadigm.m_cstrBackgroundLookup = strsplit(num2str(g_strctParadigm.m_afInitial_BackgroundColorPresets));
g_strctParadigm.m_afBackgroundPresets = g_strctParadigm.m_afInitial_BackgroundColorPresets;

for iBackgrounds = 1:numel(g_strctParadigm.m_afBackgroundPresets)

	[x,y,z] = sph2cart(0, g_strctParadigm.m_afBackgroundPresets(iBackgrounds), 0) ;
    z = g_strctParadigm.m_afBackgroundPresets(iBackgrounds);

	g_strctParadigm.m_strctMasterColorTable.gray.XYZ(iBackgrounds,1) = x;
	g_strctParadigm.m_strctMasterColorTable.gray.XYZ(iBackgrounds,2) = y;
	g_strctParadigm.m_strctMasterColorTable.gray.XYZ(iBackgrounds,3) = z;
	uncorrectedBG = floor(ldrgyv2rgb(z,x,y)*65535);
	g_strctParadigm.m_strctMasterColorTable.gray.RGB(iBackgrounds,:) = ...
															[g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedBG(1,:)+1)),...
															g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedBG(1,:)+1)),...
															g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedBG(1,:)+1))];
	g_strctParadigm.m_strctMasterColorTable.gray.afSphereCoordinates(iBackgrounds,:) = [0, g_strctParadigm.m_afBackgroundPresets(iBackgrounds),0];
															
end
g_strctParadigm.m_acstrSaturationsLookup{end+1} = 'gray';
g_strctParadigm.m_strctCurrentBackgroundColors = g_strctParadigm.m_strctMasterColorTable.gray.RGB(1,:);

%Initial_BackgroundColorPresets = [-1 -.75 -.5 -.25 0 .25 .5 .75 1]



g_strctParadigm.m_iSelectedColorList = 1;


g_strctParadigm.m_cPresetColors{1,1} = [255, 0, 0];
g_strctParadigm.m_cPresetColors{1,2} = [0,154,38]; 
g_strctParadigm.m_cPresetColors{2,1} = [0,154,38]; 
g_strctParadigm.m_cPresetColors{2,2} = [255, 0, 0]; 
g_strctParadigm.m_cPresetColors{3,1} = [0, 252, 0];
g_strctParadigm.m_cPresetColors{3,2} = [255, 0, 55];
g_strctParadigm.m_cPresetColors{4,1} = [255, 0, 55];
g_strctParadigm.m_cPresetColors{4,2} = [0, 252, 0];
g_strctParadigm.m_cPresetColors{5,1} = [148, 0, 255];
g_strctParadigm.m_cPresetColors{5,2} = [52, 209, 0];
g_strctParadigm.m_cPresetColors{6,1} = [52, 209, 0]; 	
g_strctParadigm.m_cPresetColors{6,2} = [148, 0, 255]; 	
g_strctParadigm.m_cPresetColors{7,1} = [255, 255, 255];
g_strctParadigm.m_cPresetColors{7,2} = [0, 0, 0];
g_strctParadigm.m_cPresetColors{8,1} = [0, 0, 0]; 	
g_strctParadigm.m_cPresetColors{8,2} = [255, 255, 255]; 	
				

g_strctParadigm.m_cParadigmSpecificKeyCodes{1,1} = 32;
g_strctParadigm.m_cParadigmSpecificKeyCodes{1,2} = 'g_strctParadigm.m_strCurrentlySelectedVariable = ''StimulusPosition'';';
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,1} = 80;
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,2} = 'g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;feval(g_strctParadigm.m_strCallbacks,''JumpToBlock'');feval(g_strctParadigm.m_strCallbacks,''PlainBarPanel'')';
%{
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,1} = 80;
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,2} = 'feval(g_strctParadigm.m_strCallbacks,''PlainBarPanel'')';
%}

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlanAheadTime', g_strctParadigm.m_fInitial_PlanAheadTime, iSmallBuffer);
g_strctParadigm.m_bPlanTrialsInAdvance = false;
g_strctParadigm.m_bSendTrialInfoImmediately = false;
g_strctParadigm.m_bLastShownTrialCheckSent = false;
g_strctParadigm.m_bCheckStimServerForDisplayedTrials = false;


%{
if fnParadigmToKofikoComm('IsTouchMode')
    bSuccessful = false;
    return;
end
%}
g_strctParadigm.m_strBlockDoneAction = 'Repeat Same Order';
g_strctParadigm.m_iNumTimesBlockShown = 0;
g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;
g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
g_strctParadigm.m_iCurrentOrder = 1;
g_strctParadigm.m_bBlockLooping = true;

%g_strctParadigm.m_bDoNotDrawThisCycle = false;

% Finite State Machine related parameters
g_strctParadigm.m_bRandom = g_strctParadigm.m_fInitial_RandomStimuli; 

g_strctParadigm.m_bRepeatNonFixatedImages = true;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeMS', g_strctParadigm.m_fInitial_JuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeHighMS', g_strctParadigm.m_fInitial_JuiceTimeHighMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeTimeMS', g_strctParadigm.m_fInitial_GazeTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeTimeLowMS', g_strctParadigm.m_fInitial_GazeTimeLowMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BlinkTimeMS', g_strctParadigm.m_fInitial_BlinkTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PositiveIncrement', g_strctParadigm.m_fInitial_PositiveIncrementPercent, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'SyncTime', [0,0,0], iLargeBuffer);

% Stimulus related parameters. These will be sent to the stimulus server,
% so make sure all required stimulus parameters (that can change) are
% represented in this structure.

g_strctParadigm.m_iPhotoDiodeWindowPix = 0; % Very important if you want to get a signal from the photodiode to plexon

% calibrated colors were removed
% All colors are now calculated in realtime using Qasim/Romain's solver
%{
try
	g_strctParadigm.m_strctMasterColorTable = load('colorVals.mat');
	%g_strctParadigm.m_strctPresetColorTable = load('presetColors.mat');
catch
	warning('could not find color file in root folder, specify location')
	g_strctParadigm.m_strctMasterColorTable = uiopen;
	%warning('could not find preset color file in root folder, specify location')
	%g_strctParadigm.m_strctPresetColorTable = uiopen;
end
%}
g_strctParadigm.m_bUseChosenBackgroundColor = g_strctParadigm.m_fInitial_UserChosenBackgroundColor;
%g_strctParadigm.m_strctCurrentBackgroundColors = [49670  49841  49965];
uncorrectedBGColor = ldrgyv2rgb(0,0,0);
g_strctParadigm.m_aiCalibratedBackgroundColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedBGColor(1)*65535)+1),...
                                                 g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedBGColor(2)*65535)+1),...
                                                 g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedBGColor(3)*65535)+1)];


%round(ldrgyv2rgb(0,0,0)*65535);

% MRI stim directory path 
g_strctParadigm.m_strImageListDirectoryPath = g_strctParadigm.m_strInitial_ImageListsetPath;
[g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths] = fnLoadImageSet({'FindImageSets'},g_strctParadigm.m_strImageListDirectoryPath);

% Movie stim directory path
g_strctParadigm.m_strMovieListDirectoryPath = g_strctParadigm.m_strInitial_MovieListsetPath;
[g_strctParadigm.m_strctMovieStim.m_acMovieStimPaths] = fnLoadImageSet({'FindMovieSets'},g_strctParadigm.m_strMovieListDirectoryPath);



% general stuff
g_strctParadigm.m_bRandomTestValue = false;
g_strctParadigm.m_strCurrentlySelectedBlock = 'PlainBar';
 g_strctParadigm.m_strHandMappingCommandToStatServer = [];
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BlinkTimeMS', g_strctParadigm.m_fInitial_BlinkTimeMS, iSmallBuffer);
g_strctParadigm.m_fBlinkTimer = 0;
g_strctParadigm.m_bReverseCycleStimulusOrientation = 0;
g_strctParadigm.m_bCycleStimulusOrientation = 0;
g_strctParadigm.m_iOrientationBin = 0;
g_strctParadigm.m_iTrialSaveInterval = 1000;
g_strctParadigm.m_iExperimentBackupIter = 1;
g_strctParadigm.m_iCLUTOffset = 2; % Don't change unless you know what you're doing
g_strctParadigm.m_bUseCalibratedColors =  0; 
g_strctParadigm.m_bUsePresetColors =  0; 
g_strctParadigm.m_bCycleColors = 0;
g_strctParadigm.m_bRealTimeCycleColors = 0;
g_strctParadigm.m_iSelectedColorIndex = 1;
g_strctParadigm.m_iSelectedSaturationIndex = 1;
g_strctParadigm.m_bColorUpdated = 0;
g_strctParadigm.m_fLastColorCycleUpdate = GetSecs();
g_strctParadigm.m_iSelectedColorList = 1;
g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect = [1100,400,1300,600];
g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter = round([range([g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(1),g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(3)])/2 + ...
																		g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(1),...		
																		range([g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(2),g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(4)])/2 + ...
																		g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(2)]);
g_strctParadigm.m_strctColorPicker.m_iColorPickerRadius = range([g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(1),g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(3)])/2;
g_strctParadigm.m_iNumOrientationBins = 20;

g_strctParadigm.m_strctColorPicker.m_bColorPickerUpdating = 0;
g_strctParadigm.m_strctColorPicker.m_bShowColorPicker = 1;
g_strctParadigm.m_strctColorPicker.m_afColorPickerScreenCoordinates = [1200,500];

g_strctDAQParams.m_bMouseGazeEmulator = true;
g_strctParadigm.m_acCurrentlyVariableFields = {};
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);



g_strctParadigm.m_bUseCartesianCoordinates = 0;
g_strctParadigm.m_bUseLUVCoordinates = false;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CartesianXCoord', g_strctParadigm.m_fInitial_CartesianXCoord, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CartesianYCoord', g_strctParadigm.m_fInitial_CartesianYCoord, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CartesianZCoord', g_strctParadigm.m_fInitial_CartesianZCoord, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLRadius', g_strctParadigm.m_fInitial_DKLRadius, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLAzimuthSteps', g_strctParadigm.m_fInitial_DKLAzimuthSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLElevationSteps', g_strctParadigm.m_fInitial_DKLAzimuthSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLElevation', g_strctParadigm.m_fInitial_DKLElevation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ShiftOffsetDegrees', g_strctParadigm.m_fInitial_ShiftOffsetDegrees, iSmallBuffer);
g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = 1;
g_strctParadigm.m_bFlipForegroundBackground = false;
g_strctParadigm.m_bPhaseShiftOffset = false;
g_strctParadigm.m_bColorShift = false;
g_strctParadigm.m_bUseGaussianPulses = false;




%g_strctParadigm= fnTsAddVar(g_strctParadigm, 'CartesianZCoord', g_strctParadigm.m_fInitial_SelectedColorList, iSmallBuffer);


%g_strctParadigm.m_iSelectedColorList = find(strcmp(fields(g_strctParadigm.m_strctMasterColorTable), g_strctParadigm.m_strInitial_SelectedColorList));
[a2cCharMatrix, g_strctParadigm.m_strctMasterColorTableLookup] = fnStructToCharShort(g_strctParadigm.m_strctMasterColorTable);

g_strctParadigm.m_strctCurrentSaturation = g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList});
g_strctParadigm.m_strctCurrentSaturationLookup = {g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList}};


g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusPosition', g_strctParadigm.m_afInitial_StimulusPosition, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CurrStimulusIndex', 0, iLargeBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSizePix', g_strctParadigm.m_fInitial_FixationSizePix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSpotPix', g_strctStimulusServer.m_aiScreenSize(3:4)/2, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeBoxPix', g_strctParadigm.m_fInitial_GazeBoxPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusPos', g_strctStimulusServer.m_aiScreenSize(3:4)/2, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusSizePix', g_strctParadigm.m_fInitial_StimulusSizePix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusON_MS', g_strctParadigm.m_fInitial_StimulusON_MS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusOFF_MS', g_strctParadigm.m_fInitial_StimulusOFF_MS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ColorCycleRate', g_strctParadigm.m_fInitial_ColorCycleRate, iSmallBuffer);




% For hand mapping
%% Static Bar Stimuli
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarWidth', g_strctParadigm.m_fInitial_PlainBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarLength', g_strctParadigm.m_fInitial_PlainBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarOrientation', g_strctParadigm.m_fInitial_PlainBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarMoveDistance', g_strctParadigm.m_fInitial_PlainBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarStimulusArea', g_strctParadigm.m_fInitial_PlainBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarStimulusRed', g_strctParadigm.m_fInitial_PlainBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarStimulusGreen', g_strctParadigm.m_fInitial_PlainBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarStimulusBlue', g_strctParadigm.m_fInitial_PlainBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarBackgroundRed', g_strctParadigm.m_fInitial_PlainBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarBackgroundGreen', g_strctParadigm.m_fInitial_PlainBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarBackgroundBlue', g_strctParadigm.m_fInitial_PlainBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarBlur', g_strctParadigm.m_fInitial_PlainBarBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarBlurSteps', g_strctParadigm.m_fInitial_PlainBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarMoveSpeed', g_strctParadigm.m_fInitial_PlainBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarStimulusPresetColor', g_strctParadigm.m_fInitial_PlainBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PlainBarCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

g_strctParadigm.bReverse = 0;
g_strctParadigm.m_fLastBarPositionOffset = 0;
g_strctParadigm.m_fLastBarMovementDirection = 1; % 1 or -1
g_strctParadigm.m_bUsePlainBarPresetColors = 0;





%% Moving Bar Stimuli
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarNumberOfBars', g_strctParadigm.m_fInitial_MovingBarNumberOfBars, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarWidth', g_strctParadigm.m_fInitial_MovingBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarLength', g_strctParadigm.m_fInitial_MovingBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarOrientation', g_strctParadigm.m_fInitial_MovingBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarMoveDistance', g_strctParadigm.m_fInitial_MovingBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarMoveSpeed', g_strctParadigm.m_fInitial_MovingBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusArea', g_strctParadigm.m_fInitial_MovingBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusRed', g_strctParadigm.m_fInitial_MovingBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusGreen', g_strctParadigm.m_fInitial_MovingBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusBlue', g_strctParadigm.m_fInitial_MovingBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBackgroundRed', g_strctParadigm.m_fInitial_MovingBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBackgroundGreen', g_strctParadigm.m_fInitial_MovingBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBackgroundBlue', g_strctParadigm.m_fInitial_MovingBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBlur', g_strctParadigm.m_fInitial_MovingBarBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBlurSteps', g_strctParadigm.m_fInitial_MovingBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusOffTime', g_strctParadigm.m_fInitial_MovingBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusOnTime', g_strctParadigm.m_fInitial_MovingBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusPresetColor', g_strctParadigm.m_fInitial_MovingBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

g_strctParadigm.m_bClipStimulusOutsideStimArea = false;
g_strctParadigm.m_bUseMovingBarPresetColors = 0;
g_strctParadigm.m_bFlipForegroundBackgroundMovingBar = false;


%% two bar

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarNumberOfBars', g_strctParadigm.m_fInitial_TwoBarNumberOfBars, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarWidthBarOne', g_strctParadigm.m_fInitial_TwoBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarLengthBarOne', g_strctParadigm.m_fInitial_TwoBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarWidthBarTwo', g_strctParadigm.m_fInitial_TwoBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarLengthBarTwo', g_strctParadigm.m_fInitial_TwoBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarOrientationBarOne', g_strctParadigm.m_fInitial_TwoBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarOrientationBarTwo', g_strctParadigm.m_fInitial_TwoBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarMoveDistance', g_strctParadigm.m_fInitial_TwoBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusArea', g_strctParadigm.m_fInitial_TwoBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusRed', g_strctParadigm.m_fInitial_TwoBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusGreen', g_strctParadigm.m_fInitial_TwoBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusBlue', g_strctParadigm.m_fInitial_TwoBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarBackgroundRed', g_strctParadigm.m_fInitial_TwoBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarBackgroundGreen', g_strctParadigm.m_fInitial_TwoBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarBackgroundBlue', g_strctParadigm.m_fInitial_TwoBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarBlurStepsBarOne', g_strctParadigm.m_fInitial_TwoBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarBlurStepsBarTwo', g_strctParadigm.m_fInitial_TwoBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusOffTime', g_strctParadigm.m_fInitial_TwoBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusOnTime', g_strctParadigm.m_fInitial_TwoBarStimulusOnTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusOnsetDelay', g_strctParadigm.m_fInitial_TwoBarStimulusOnsetDelay, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarStimulusPresetColor', g_strctParadigm.m_fInitial_TwoBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarMinOffset', g_strctParadigm.m_fInitial_TwoBarMinOffset, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TwoBarMaxOffset', g_strctParadigm.m_fInitial_TwoBarMaxOffset, iSmallBuffer);
g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars = 0;


%% Siva added starts here for Many bars
%Create buffer space for each variables (index 0 is used to set the parameter for all the bars)
%Initialise these Struct fields using the values from the XML file.
for numBars=0:fnTsGetVar(g_strctParadigm,'numberOfBarsManyBar')% 20
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarWidthBar',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarWidth, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarLengthBar',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarLength, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarOrientationBar',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarOrientation, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarMoveDistance',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarMoveDistance, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarStimulusRed',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarStimulusRed, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarStimulusGreen',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarStimulusGreen, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarStimulusBlue',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarStimulusBlue, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarBlurStepsBar',num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarBlurSteps, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarStimulusOnsetDelay', num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarStimulusOnsetDelay, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarStimulusPresetColor', num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarStimulusPresetColor, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarMinOffset', num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarMinOffset, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, ['ManyBarMaxOffset', num2str(numBars)], g_strctParadigm.m_fInitial_ManyBarMaxOffset, iSmallBuffer);
end

    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarHueFullWidth', g_strctParadigm.m_fInitial_ManyBarHueFullWidth, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarSatFullWidth', g_strctParadigm.m_fInitial_ManyBarSatFullWidth, iSmallBuffer);
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarLumFullWidth', g_strctParadigm.m_fInitial_ManyBarLumFullWidth, iSmallBuffer);



g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarNumberOfBars', g_strctParadigm.m_fInitial_ManyBarNumberOfBars, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarWidthBarAll', g_strctParadigm.m_fInitial_ManyBarWidth, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarLengthBarAll', g_strctParadigm.m_fInitial_ManyBarLength, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarLengthBarMany', g_strctParadigm.m_fInitial_ManyBarLength, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarOrientationBarAll', g_strctParadigm.m_fInitial_ManyBarOrientation, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarOrientationBarTwo', g_strctParadigm.m_fInitial_ManyBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarMoveDistance', g_strctParadigm.m_fInitial_ManyBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusArea', g_strctParadigm.m_fInitial_ManyBarStimulusArea, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusRed', g_strctParadigm.m_fInitial_ManyBarStimulusRed, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusGreen', g_strctParadigm.m_fInitial_ManyBarStimulusGreen, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusBlue', g_strctParadigm.m_fInitial_ManyBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarBackgroundRed', g_strctParadigm.m_fInitial_ManyBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarBackgroundGreen', g_strctParadigm.m_fInitial_ManyBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarBackgroundBlue', g_strctParadigm.m_fInitial_ManyBarBackgroundBlue, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarBlurStepsBarAll', g_strctParadigm.m_fInitial_ManyBarBlurSteps, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarBlurStepsBarMany', g_strctParadigm.m_fInitial_ManyBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusOffTime', g_strctParadigm.m_fInitial_ManyBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusOnTime', g_strctParadigm.m_fInitial_ManyBarStimulusOnTime, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusOnsetDelay', g_strctParadigm.m_fInitial_ManyBarStimulusOnsetDelay, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarStimulusPresetColor', g_strctParadigm.m_fInitial_ManyBarStimulusPresetColor, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarMinOffset', g_strctParadigm.m_fInitial_ManyBarMinOffset, iSmallBuffer);
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarMaxOffset', g_strctParadigm.m_fInitial_ManyBarMaxOffset, iSmallBuffer);
g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarSelectedBar',0, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ManyBarNumberOfBarsSelected', g_strctParadigm.m_fInitial_ManyBarNumberOfBars, iSmallBuffer);


% Siva added ends here for Many bars

%% For Gabors
g_strctParadigm.m_strctGaborParams.m_bNonsymmetric = g_strctParadigm.m_fInitial_Gabor_Nonsymmetric;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBarWidth', g_strctParadigm.m_fInitial_GaborBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBarLength', g_strctParadigm.m_fInitial_GaborBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborOrientation', g_strctParadigm.m_fInitial_GaborOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusArea', g_strctParadigm.m_fInitial_GaborStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborMoveDistance', g_strctParadigm.m_fInitial_GaborMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusRed', g_strctParadigm.m_fInitial_GaborStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusGreen', g_strctParadigm.m_fInitial_GaborStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusBlue', g_strctParadigm.m_fInitial_GaborStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBackgroundRed', g_strctParadigm.m_fInitial_GaborBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBackgroundGreen', g_strctParadigm.m_fInitial_GaborBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBackgroundBlue', g_strctParadigm.m_fInitial_GaborBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborPhase', g_strctParadigm.m_fInitial_GaborPhase, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborFreq', g_strctParadigm.m_fInitial_GaborFreq, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborContrast', g_strctParadigm.m_fInitial_GaborContrast, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborSigma', g_strctParadigm.m_fInitial_GaborSigma, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborFreq', g_strctParadigm.m_fInitial_GaborFreq, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusPresetColor', g_strctParadigm.m_fInitial_GaborStimulusPresetColor, iSmallBuffer);

g_strctParadigm.m_strctGaborParams.m_bReversePhaseDirection = 0;
g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 0;
g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase = 0;
g_strctParadigm.m_bUseGaborPresetColors = 0;

%% For Images
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageWidth', g_strctParadigm.m_fInitial_ImageWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageLength', g_strctParadigm.m_fInitial_ImageLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageOrientation', g_strctParadigm.m_fInitial_ImageOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageMoveDistance', g_strctParadigm.m_fInitial_ImageMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusArea', g_strctParadigm.m_fInitial_ImageStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusOffTime', g_strctParadigm.m_fInitial_ImageStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusOnTime', g_strctParadigm.m_fInitial_ImageStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusRed', g_strctParadigm.m_fInitial_ImageStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusGreen', g_strctParadigm.m_fInitial_ImageStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusBlue', g_strctParadigm.m_fInitial_ImageStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageBackgroundRed', g_strctParadigm.m_fInitial_ImageBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageBackgroundGreen', g_strctParadigm.m_fInitial_ImageBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageBackgroundBlue', g_strctParadigm.m_fInitial_ImageBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageBlur', g_strctParadigm.m_fInitial_ImageBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageBlurSteps', g_strctParadigm.m_fInitial_ImageBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageMoveSpeed', g_strctParadigm.m_fInitial_ImageMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageStimulusPresetColor', g_strctParadigm.m_fInitial_ImageStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);
g_strctParadigm.m_strctMRIStim.m_iSelectedImage = 1;
g_strctParadigm.m_strctMRIStim.m_bRandomOrder = g_strctParadigm.m_fInitial_ImageDisplayRandomOrder;
g_strctParadigm.m_strctMRIStim.m_bReverseOrder =  false;
g_strctParadigm.m_strctMRIStim.m_bLockAspectRatio =  true;
g_strctParadigm.m_strctMRIStim.m_bOverrideImageColors = false;
g_strctParadigm.m_strctMRIStim.ahTextures = [];
g_strctParadigm.m_strctMRIStim.m_bForceMatchImageSizes = g_strctParadigm.m_fInitial_ForceMatchImageSizes;
g_strctParadigm.m_strctMRIStim.m_bMatchToMinimumImageSize = true;
g_strctParadigm.m_strctMRIStim.m_bMatchToMaximumImageSize = false;

% For Movies
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieWidth', g_strctParadigm.m_fInitial_MovieWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieLength', g_strctParadigm.m_fInitial_MovieLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieOrientation', g_strctParadigm.m_fInitial_MovieOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieMoveDistance', g_strctParadigm.m_fInitial_MovieMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusArea', g_strctParadigm.m_fInitial_MovieStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusOffTime', g_strctParadigm.m_fInitial_MovieStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusOnTime', g_strctParadigm.m_fInitial_MovieStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusRed', g_strctParadigm.m_fInitial_MovieStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusGreen', g_strctParadigm.m_fInitial_MovieStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusBlue', g_strctParadigm.m_fInitial_MovieStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieBackgroundRed', g_strctParadigm.m_fInitial_MovieBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieBackgroundGreen', g_strctParadigm.m_fInitial_MovieBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieBackgroundBlue', g_strctParadigm.m_fInitial_MovieBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieBlur', g_strctParadigm.m_fInitial_MovieBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieBlurSteps', g_strctParadigm.m_fInitial_MovieBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieMoveSpeed', g_strctParadigm.m_fInitial_MovieMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieStimulusPresetColor', g_strctParadigm.m_fInitial_MovieStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovieCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);
g_strctParadigm.m_strctMovieStim.m_iSelectedMovie = 1;
g_strctParadigm.m_strctMovieStim.m_bRandomOrder = false;
g_strctParadigm.m_strctMovieStim.m_bReverseOrder =  false;
g_strctParadigm.m_strctMovieStim.m_bLockAspectRatio =  true;
g_strctParadigm.m_strctMovieStim.m_bOverrideMovieColors = false;
g_strctParadigm.m_strctMovieStim.m_acMovieHandles = {};
g_strctParadigm.m_strctMovieStim.m_bFitDisplayAreaToMovieSize = true;
g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly = true;
g_strctParadigm.m_strctMovieStim.m_bContinueInMovieListWhenComplete = true;
g_strctParadigm.m_iCurrentlyPlayingMovieList = 1;
g_strctParadigm.m_iCurrentlyPlayingMovieListID = 1;
% For discs
g_strctParadigm.m_strctHandMappingParams.m_bPerfectCircles = 1;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscNumberOfDiscs', g_strctParadigm.m_fInitial_DiscNumberOfDiscs, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscDiameter', g_strctParadigm.m_fInitial_DiscDiameter, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscOrientation', g_strctParadigm.m_fInitial_DiscOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscMoveDistance', g_strctParadigm.m_fInitial_DiscMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscMoveSpeed', g_strctParadigm.m_fInitial_DiscMoveSpeed, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusArea', g_strctParadigm.m_fInitial_DiscStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusRed', g_strctParadigm.m_fInitial_DiscStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusGreen', g_strctParadigm.m_fInitial_DiscStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusBlue', g_strctParadigm.m_fInitial_DiscStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundRed', g_strctParadigm.m_fInitial_DiscBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundGreen', g_strctParadigm.m_fInitial_DiscBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundBlue', g_strctParadigm.m_fInitial_DiscBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBlur', g_strctParadigm.m_fInitial_DiscBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBlurSteps', g_strctParadigm.m_fInitial_DiscBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusOffTime', g_strctParadigm.m_fInitial_DiscStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusOnTime', g_strctParadigm.m_fInitial_DiscStimulusOnTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusPresetColor', g_strctParadigm.m_fInitial_DiscStimulusPresetColor, iSmallBuffer);
g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation = 0;
g_strctParadigm.m_bRandomDiscStimulusPosition = 0;
g_strctParadigm.m_bUseDiscPresetColors = 0;

%{
g_strctParadigm.m_strctGaborParams.m_afDestinationRectangle = [g_strctParadigm.m_afInitial_StimulusPosition(1) - g_strctParadigm.m_fInitial_StimulusArea,...
																g_strctParadigm.m_afInitial_StimulusPosition(2) - g_strctParadigm.m_fInitial_StimulusArea,...
																g_strctParadigm.m_afInitial_StimulusPosition(1) + g_strctParadigm.m_fInitial_StimulusArea,...
																g_strctParadigm.m_afInitial_StimulusPosition(2)  g_strctParadigm.m_fInitial_StimulusArea];
%}

% Seed the randomness
g_strctParadigm.g_fRandomSeedWaitMS = g_strctParadigm.m_fInitial_RandomSeedWaitMS;
ClockRandSeed;
g_strctParadigm.m_fLastRandSeed = GetSecs();


% For tuning function
g_strctParadigm.m_bRandomColor = g_strctParadigm.m_fInitial_RandomColorOrder;
g_strctParadigm.m_bReverseColorOrder = g_strctParadigm.m_fInitial_ReverseColorOrder;
g_strctParadigm.m_bRandomColorOrder = g_strctParadigm.m_fInitial_RandomColorOrder;
g_strctParadigm.m_strctTuningFunctionParams.m_afMasterClut = zeros(256,3);
g_strctParadigm.m_strctTuningFunctionParams.m_strBGColor = g_strctParadigm.m_strInitial_DefaultBGColor;
g_strctParadigm.m_strctTuningFunctionParams.m_iBGColorRGBIndex = g_strctParadigm.m_fInitial_BGColorRGBIndex;
g_strctParadigm.m_strctTuningFunctionStats.m_afPolarPlottingHolder = {}; % Holder for polar plotting data if it is cleared

g_strctPlexon = [];

% For orientation Tuning
g_strctParadigm.m_bReverseOrientationOrder = 0;
g_strctParadigm.m_bRandomOrientation = 0;
g_strctParadigm.m_fOrientationID = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumberOfOrientationsToTest', g_strctParadigm.m_fInitial_NumberOfOrientationsToTest, iSmallBuffer);

% For position Tuning
g_strctParadigm.m_strctPositionTuningFunction.m_fNumFrames = 16;
g_strctParadigm.m_strctPositionTuningFunction.m_fStimulusOnTime = 200;
g_strctParadigm.m_strctPositionTuningFunction.m_fStimulusOffTime = 200;

% For PTB Plotting

g_strctPlexon.m_iPolarUpdateMS = g_strctParadigm.m_fInitial_PolarUpdateMS;
g_strctParadigm.m_bPolarPlot = g_strctParadigm.m_fInitial_PolarPlot;
g_strctParadigm.m_bUpdatePolar = 0;

g_strctPlexon.m_strctStatistics.m_afPolarPlottingArray = zeros(20,2);
g_strctPlexon.m_strctStatistics.m_afPolarColors  = g_strctParadigm.m_afInitial_PolarColors;
g_strctPlexon.m_strctStatistics.m_afPolarOutlineColors  = g_strctParadigm.m_afInitial_PolarOutlineColors;
g_strctPlexon.m_strctStatistics.m_afPolarRect = g_strctParadigm.m_afInitial_PolarPosition;



% Neutralize any previous Cluts we may have loaded
fnParadigmToStimulusServer('LoadDefaultClut');

try
	g_strctParadigm.m_aiSpikeChannels = g_strctParadigm.m_afInitial_SpikeChannels;
catch
	g_strctParadigm.m_aiSpikeChannels = g_strctParadigm.m_fInitial_SpikeChannels;
end

fCurrTime = GetSecs();
% Plexony stuff
% DEFUNCT
% handled by stat server
g_strctPlexon.m_aiTrials = [];
g_strctPlexon.m_aiTrialsIteration = 1;
g_strctPlexon.m_bTrialInTempBuffer = 0;
g_strctPlexon.m_bDrawToPTBScreen = 1;

%[g_strctPlexon.m_iServerID] = PL_InitClient(0);


%if isempty(g_strctPlexon.m_iServerID)
	% Do something. I dunno. Cry, maybe.
%end
%g_strctPlexon.m_iSpikeUpdateHz = g_strctParadigm.m_fInitial_SpikeUpdateHz;
g_strctPlexon.m_iSpikeUpdateHz = 10;
g_strctPlexon.m_strctStatistics.m_iHeatUpdateHz = 1;
g_strctPlexon.m_strctStatistics.m_fLastHeatUpdate = fCurrTime;
g_strctPlexon.m_strctStatistics.m_iPolarUpdateHz = 1;
g_strctPlexon.m_strctStatistics.m_fLastPolarUpdate = fCurrTime;
g_strctPlexon.m_strctStatistics.m_iRasterUpdateHz = 10;
g_strctPlexon.m_strctStatistics.m_fLastRasterUpdate = fCurrTime;
g_strctPlexon.m_strctStatistics.m_fRasterTrailMS = 30000;
g_strctPlexon.m_fLastTimeStampSync = zeros(1,2);
g_strctPlexon.m_strctStatistics.m_aiRasterColors = [0,255,0];
g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect = [1200,300,1500,400];

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'rasterPlotX', 1200, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'rasterPlotY', 300, iSmallBuffer);

% Get the current server time
fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iSync);
g_strctCycle.m_fSyncTimer = fCurrTime;
if g_strctRealTimeStatServer.m_bConnected
            mssend(g_strctRealTimeStatServer.m_iSocket,{'SyncWithKofiko',g_strctCycle.m_fSyncTimer});
            %afCycleDebugTimers(12) = GetSecs();
            
end

[g_strctPlexon.m_fLastPlexonUpdate] = fCurrTime;

g_strctParadigm.m_bRasterPlot = 1;

g_strctParadigm.m_bHeatPlot = 0;


g_strctParadigm.m_bPolarPlot = 0;
% STAT SERVER STUFF
% handles local variables for controlling stat server
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PreTrialPlottingWindow', g_strctParadigm.m_fInitial_PreTrialPlottingWindow, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PostTrialPlottingWindow', g_strctParadigm.m_fInitial_PostTrialPlottingWindow, iSmallBuffer);

g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 0;
g_strctParadigm.m_strctStatServerComm.m_bUpdatePostTrialWindow = 0;

g_strctParadigm.m_strctStatServerComm.m_bUpdatePreTrialWindow = 0;
g_strctParadigm.m_strctStatServerComm.m_bClearOrientationBuffer = 0;
g_strctParadigm.m_strctStatServerComm.m_bClearColorBuffer = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleLUVPsthPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bClearLUVPSTHPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bClearPositionBuffer = 0;	
g_strctParadigm.m_strctStatServerComm.m_bTogglePsthPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleOrientationPolar = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleISIPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bTogglePositionPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleWidthPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleLengthPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleSpeedPlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bToggleImagePlot = 0;
g_strctParadigm.m_strctStatServerComm.m_bClearImageBuffer = 0;
g_strctParadigm.m_strctStatServerComm.m_bPrintStatFigure = 0;
g_strctParadigm.m_strctStatServerComm.m_bDebugStatServer = 0;
 
g_strctPlexon.m_afRollingSpikeBuffer.Buf = zeros(50000,4);
g_strctPlexon.m_afRollingSpikeBuffer.BufID = 0;

g_strctPlexon.m_afWaveFormBuffer.m_iTrialsToKeepInBuffer = 400;
g_strctPlexon.m_afSpikeBuffer.m_iTrialsToKeepInBuffer = 400;
  
g_strctPlexon.m_afWaveFormBuffer.m_aiCircularBufferIndices = ones(20,1);
g_strctPlexon.m_afSpikeBuffer.m_aiCircularBufferIndices = ones(20,1);

g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer = zeros(20,g_strctPlexon.m_afWaveFormBuffer.m_iTrialsToKeepInBuffer,50,4);
g_strctPlexon.m_afWaveFormBuffer.m_aiCircularBuffer = zeros(20,g_strctPlexon.m_afWaveFormBuffer.m_iTrialsToKeepInBuffer,50,32);

g_strctPlexon.m_strctStatistics.m_hHistogram = [];
g_strctPlexon.m_strctStatistics.m_iPreTrialTime = -.05;
g_strctPlexon.m_strctStatistics.m_iPostTrialTime = .200;



g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TrialsForPlotting', g_strctParadigm.m_fInitial_TrialsForPlotting, iSmallBuffer);






g_strctParadigm.m_iInitialIndexInColorList = 1;

% Set the initial variable as the stimulus position. 
g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
g_strctPTB.m_variableUpdating = false;

%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BackgroundColor',  [g_strctParadigm.m_fInitial_BackgroundRed,...
% g_strctParadigm.m_fInitial_BackgroundGreen, g_strctParadigm.m_fInitial_BackgroundBlue], iSmallBuffer);

 
 
g_strctPTB.g_strctStimulusServer.m_RefreshRateMS = (1/120)*1000;%fnParadigmToKofikoComm('GetRefreshRate');
g_strctPTB.m_strctControlInputs.m_bLastStimulusPositionCheck = 0;
% Start the object at the fovea (center of screen). This is handled separately from the other variables during the paradigm
g_strctParadigm.m_aiCenterOfStimulus(1) = g_strctStimulusServer.m_aiScreenSize(3)/2;
g_strctParadigm.m_aiCenterOfStimulus(2) = g_strctStimulusServer.m_aiScreenSize(4)/2;
g_strctParadigm.g_strctStimulusServer.m_aiScreenSize = g_strctStimulusServer.m_aiScreenSize;

g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));


g_strctPTB.m_stimulusAreaUpdating = false;


g_strctParadigm.m_bRandomStimulusPosition = false;
g_strctParadigm.m_bRandomStimulusOrientation = false;



g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimulationAmplitude', 0, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicrostimDelayMS', 0, iSmallBuffer);

bForceStereoOnMonocularInitialValue = false;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ForceStereoOnMonocularLists', bForceStereoOnMonocularInitialValue, iSmallBuffer);

%{
g_strctParadigm.m_strctSavedParam.m_pt2fStimulusPosition = fnTsGetVar('g_strctParadigm','StimulusPos');
g_strctParadigm.m_strctSavedParam.m_fTheta = fnTsGetVar('g_strctParadigm','RotationAngle');
g_strctParadigm.m_strctSavedParam.m_fSize = fnTsGetVar('g_strctParadigm','StimulusSizePix');
%}
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'Trials',[0;0;0;0;0;0;0],iLargeBuffer);

g_strctParadigm.m_strctCurrentTrial = [];
g_strctParadigm.m_bShowPhotodiodeRect = g_strctParadigm.m_fInitial_ShowPhotodiodeRect;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageList', '',20);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'Designs', {},20);

g_strctParadigm.m_iNumStimuli = 0;
g_strctParadigm.m_bStimulusDisplayed = false;
g_strctParadigm.m_aiCurrentRandIndices = [];

g_strctParadigm.m_strSavedImageList = '';
g_strctParadigm.m_fInsideGazeRectTimer = 0; 
g_strctParadigm.m_bUpdateFixationSpot = false;
g_strctParadigm.m_bUpdateStimulusPos = false;

g_strctParadigm.m_strLocalStereoMode = 'Side by Side (Large)';
    
g_strctParadigm.m_strState = 'Doing Nothing;';

g_strctParadigm.m_strImageList = '';
% g_strctParadigm.m_strOnlyFacesImageList = g_strctParadigm.m_strInitial_FacesImageList;
% g_strctParadigm.m_strFOBImageList = g_strctParadigm.m_strInitial_FOBImageList;

g_strctParadigm.m_bDisplayStimuliLocally = true;
g_strctParadigm.m_bMovieInitialized = false;

g_strctParadigm.m_iRandFixCounter = 0;
g_strctParadigm.m_bRandFixPos = g_strctParadigm.m_fInitial_RandomPosition;
g_strctParadigm.m_fRandFixPosMin = g_strctParadigm.m_fInitial_RandomPositionMin;
g_strctParadigm.m_fRandFixPosMax = g_strctParadigm.m_fInitial_RandomPositionMax;
g_strctParadigm.m_fRandFixRadius = g_strctParadigm.m_fInitial_RandomPositionRadius;
g_strctParadigm.m_iRandFixCounterMax = g_strctParadigm.m_fRandFixPosMin + round(rand() * (g_strctParadigm.m_fRandFixPosMax-g_strctParadigm.m_fRandFixPosMin));
g_strctParadigm.m_bRandFixSyncStimulus = true;

g_strctParadigm.m_bHideStimulusWhenNotLooking = g_strctParadigm.m_fInitial_HideStimulusWhenNotLooking;
g_strctParadigm.m_fLastFixatedTimer = 0; 

g_strctParadigm.m_a2bStimulusCategory = [];
g_strctParadigm.m_acCatNames = [];

% Initialize Dynamic Juice Reward System
g_strctParadigm.m_strctDynamicJuice.m_fTotalFixationTime = 0;
g_strctParadigm.m_strctDynamicJuice.m_fTotalNonFixationTime = 0;
g_strctParadigm.m_strctDynamicJuice.m_iState = 1;
g_strctParadigm.m_strctDynamicJuice.m_iFixationCounter = 0;

g_strctParadigm.m_bPausedDueToMotion = false;


acFieldNames = fieldnames(g_strctParadigm);
acFavoriteLists = cell(1,0);
iListCounter = 1;
for k=1:length(acFieldNames)
    if strncmpi(acFieldNames{k},'m_strInitial_FavroiteList',25)
        strImageListFileName = getfield(g_strctParadigm,acFieldNames{k});
        if exist(strImageListFileName,'file')
           acFavoriteLists{iListCounter} = strImageListFileName;
           iListCounter = iListCounter + 1;
        end
    end
end
% Changelog 10/21/13 josh - initializes fit to screen parameter
g_strctParadigm.m_bFitToScreen = g_strctParadigm.m_fInitial_FitToScreen;

% End Changelog
g_strctParadigm.m_bParameterSweep = g_strctParadigm.m_fInitial_ParameterSweep;
%g_strctParadigm.m_iParameterSweepMode = 1;

g_strctParadigm.m_astrctParameterSweepModes(1).m_strName = 'Fixed';
g_strctParadigm.m_astrctParameterSweepModes(1).m_afX  = 0;
g_strctParadigm.m_astrctParameterSweepModes(1).m_afY  = 0;
g_strctParadigm.m_astrctParameterSweepModes(1).m_afSize  = [];
g_strctParadigm.m_astrctParameterSweepModes(1).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(2).m_strName = '7x7 Position Only';
g_strctParadigm.m_astrctParameterSweepModes(2).m_afX  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(2).m_afY  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(2).m_afSize  = [];
g_strctParadigm.m_astrctParameterSweepModes(2).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(3).m_strName = '7x7x3 Position & Scale';
g_strctParadigm.m_astrctParameterSweepModes(3).m_afX  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(3).m_afY  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(3).m_afSize  = [32 64 128];
g_strctParadigm.m_astrctParameterSweepModes(3).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(4).m_strName = '21x21 Position Only';
g_strctParadigm.m_astrctParameterSweepModes(4).m_afX  = -400:40:400;
g_strctParadigm.m_astrctParameterSweepModes(4).m_afY  = -300:30:300;
g_strctParadigm.m_astrctParameterSweepModes(4).m_afSize  = [];
g_strctParadigm.m_astrctParameterSweepModes(4).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(5).m_strName = '21x21x3 Position Only';
g_strctParadigm.m_astrctParameterSweepModes(5).m_afX  = -400:40:400;
g_strctParadigm.m_astrctParameterSweepModes(5).m_afY  = -300:30:300;
g_strctParadigm.m_astrctParameterSweepModes(5).m_afSize  = [32 64 128];
g_strctParadigm.m_astrctParameterSweepModes(5).m_afTheta  = [];

% Search for noise patterns...
astrctNoisePatternsFiles = dir('\\kofiko-23b\StimulusSet\NoisePatterns\*.mat');
g_strctParadigm.m_acNoisePatternsFiles = {astrctNoisePatternsFiles.name};
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseOverlayActive', false, iSmallBuffer);
if ~isempty(g_strctParadigm.m_acNoisePatternsFiles) && exist(['\\kofiko-23b\StimulusSet\NoisePatterns\\',g_strctParadigm.m_acNoisePatternsFiles{1}],'file')
    try
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseFile', g_strctParadigm.m_acNoisePatternsFiles{1}, 20);
    strctTmp = load(['\\kofiko-23b\StimulusSet\NoisePatterns\\',g_strctParadigm.m_acNoisePatternsFiles{1}]);
    g_strctParadigm.m_a3fRandPatterns = strctTmp.a3fRand;
    g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = size(g_strctParadigm.m_a3fRandPatterns,3);
    catch
        g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseFile', '', 20);
        g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = 0 ;
    end
    
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseFile', '', 20);
    g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = 0 ;
end
g_strctParadigm.m_strctNoiseOverlay.m_iNoiseIndex = 0;
g_strctParadigm.m_strctNoiseOverlay.m_fNoiseIntensity = 0;

g_strctParadigm.m_acImageFileNames = [];


g_strctParadigm.m_strctMiroSctim.m_bActive = false;


TRIAL_START_CODE = 32700;
TRIAL_END_CODE = 32699;
TRIAL_ALIGN_CODE = 32698;
TRIAL_OUTCOME_MISS = 32695;
TRIAL_INCORRECT_FIX = 32696;
TRIAL_CORRECT_FIX = 32697;

strctDesign.TrialStartCode = TRIAL_START_CODE;
strctDesign.TrialEndCode = TRIAL_END_CODE;
strctDesign.TrialAlignCode = TRIAL_ALIGN_CODE;
strctDesign.TrialOutcomesCodes = [TRIAL_OUTCOME_MISS,TRIAL_INCORRECT_FIX,TRIAL_CORRECT_FIX];
strctDesign.KeepTrialOutcomeCodes = [TRIAL_CORRECT_FIX];
strctDesign.TrialTypeToConditionMatrix = [];
strctDesign.ConditionOutcomeFilter = cell(0);
strctDesign.NumTrialsInCircularBuffer = 200;
strctDesign.TrialLengthSec = 1.1 * (g_strctParadigm.m_fInitial_StimulusON_MS+g_strctParadigm.m_fInitial_StimulusOFF_MS)/1e3; % multiple by 10% to account for possible jitter
strctDesign.Pre_TimeSec = 0.5;
strctDesign.Post_TimeSec = 0.5;
g_strctParadigm.m_strctStatServerDesign = strctDesign;
g_strctParadigm.m_bJustLoaded = true;
g_strctParadigm.m_bGUILoaded = false;
iInitialIndex = -1;

if ~isempty(g_strctParadigm.m_strInitial_DefaultImageList) && exist(g_strctParadigm.m_strInitial_DefaultImageList,'file')
   if fnLoadHandMappingDesign(g_strctParadigm.m_strInitial_DefaultImageList)
    
    for k=1:length(acFavoriteLists)
        if strcmpi(acFavoriteLists{k}, g_strctParadigm.m_strInitial_DefaultImageList)
            iInitialIndex = k;
            break;
        end
    end
    if iInitialIndex == -1
        acFavoriteLists = [g_strctParadigm.m_strInitial_DefaultImageList,acFavoriteLists];
        iInitialIndex = 1;
    end
   end
else
   % g_strctParadigm.m_strctDesign = [];
end;

acFavoriteLists = {'HandMapper','Images','Movies'};
g_strctParadigm.m_strctHandMappingDesignBackup = g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder;
g_strctParadigm.m_strWhatToReset = 'Unit';
fnInitializeHandMappingCommandStructure();
g_strctParadigm.g_strctStatistics.m_acFavoriteLists = acFavoriteLists;
g_strctParadigm.m_iInitialIndexInFavroiteList = iInitialIndex;
g_strctParadigm.m_bShowWhileLoading = true;
g_strctParadigm.m_fLastStatServerMemoryDumpTS = GetSecs();
g_strctParadigm = fnCleanup(g_strctParadigm);
g_strctParadigm.m_fMaxStatServerUpdateInterval = 300;
g_strctParadigm.m_fLastStatServerUpdateTS  = GetSecs();
g_strctRealTimeStatServer.m_iLastStatServerUpdateTS = GetSecs();
g_strctRealTimeStatServer.m_iStatServerUpdateInterval = 1;
g_strctRealTimeStatServer.m_iStatServerUpdateWarningElapsedTime = [];
g_strctRealTimeStatServer.m_iStatServerUpdateWarningLeadTime = .3;
g_strctRealTimeStatServer.m_bTrialInfoWait = 0;
g_strctParadigm.m_iLastStatServerSentTrialIndex = 1;
g_strctParadigm.m_iMaxTrialsToKeepInBuffer = 4000;

%g_strctRealTimeStatServer.m_btogglePSTH = true;
if g_strctRealTimeStatServer.m_bConnected
	fnParadigmToStatServerComm('setdynamictrialmode',g_strctParadigm.m_bSetDynamicTrialMode);
end


%fnGetSpikesFromPlexon();
bSuccessful = true;
return;

function g_strctParadigm = fnCleanup(g_strctParadigm)
 
fields = fieldnames(g_strctParadigm);
idx = strfind(fields,'Initial_');
idxLogical = ~cellfun(@isempty,idx);
fieldsToRM = fields(idxLogical);
for i = 1:numel(fieldsToRM)
	g_strctParadigm.m_strctInitialValues.(fieldsToRM{i}) = g_strctParadigm.(fieldsToRM{i});
end
g_strctParadigm = rmfield(g_strctParadigm,fieldsToRM);
return;