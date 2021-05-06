function bSuccessful = fnNTlabInit()
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


g_strctParadigm.m_bInvertPresetColors = false;

g_strctParadigm.m_strctGammaCorrectedLookupTable = load('gammaCorrectedLookUpTable');
%g_strctParadigm.m_strctConversionMatrices = load('ConversionMatrices');
% g_strctParadigm.m_strctConversionMatrices.ldgyb = [1	1	0.156888838783085;
% 			1	-0.233347782674963	-0.142960334308503;
% 			1	0.020310076560882	1]; %felix added calibration as of oct 2018
% g_strctParadigm.m_strctConversionMatrices.ldgyb = [    1.0000    1.0000    0.2506
%     1.0000   -0.2337   -0.2166
%     1.0000   0.0135    1.0000]; %felix added calibration as of april 2019
% g_strctParadigm.m_strctConversionMatrices.ldgyb = [    1.0000    1.0000    0.2215
%     1.0000   -0.3629   -0.3466
%     1.0000   0.0093    1.0000]; %felix added calibration as of feb 2020
g_strctParadigm.m_strctConversionMatrices.ldgyb = [    1.0000    1.0000    0.2116
    1.0000   -0.2335   -0.1862
    1.0000   0.0108    1.0000]; %felix added calibration as of jan 2021

g_strctParadigm.m_cPresetColors{1,1} = [97,150,12];     %round(255*ldrgyv2rgb(-0.0146,0,-.89)); % S-; % [52, 209, 0];
g_strctParadigm.m_cPresetColors{1,2} = [161,102,255];   %round(255*ldrgyv2rgb(0.0145,0,.985));  % S+; %[148, 0, 255];
g_strctParadigm.m_cPresetColors{2,1} = [197,106,124];   %round(255*ldrgyv2rgb(-0.0351,.5804,0));% M-; %[255, 0, 55];
g_strctParadigm.m_cPresetColors{2,2} = [73,146,131];    %round(255*ldrgyv2rgb(.0351,-.4635,0)); % M+; %[0, 252, 0];
g_strctParadigm.m_cPresetColors{3,1} = [56,138,122];    %round(255*ldrgyv2rgb(-0.04,.522,0));   % L-; %[0,154,38]; 
g_strctParadigm.m_cPresetColors{3,2} = [255,103,134];   %round(255*ldrgyv2rgb(0.0351,.97,0));   % L+; %[255, 0, 0];

Probe_ii=1;
for theta = 1:15
    for satur = [0.33 0.66 1]
        [x,y,z]=pol2cart(floor(100*theta*pi/8)/100,satur,0);
        g_strctParadigm.m_cPresetProbeColors(Probe_ii,:) = round(255*ldrgyv2rgb(0,x,y));
        g_strctParadigm.m_cPresetProbeColorIDS(Probe_ii,:) = [theta, satur, 0, x, y, z];
        Probe_ii=Probe_ii+1;
    end
end
for theta = 1:15
    for elev = [-.8 -.5 -.2 .2 .5 .8]
        if abs(elev)==.8
            satur=.2;
        elseif abs(elev) == .5
            satur = .5;
        elseif abs(elev) == .2
            satur = .8;
        end
        [x,y,z]=pol2cart(floor(100*theta*pi/8)/100,satur,elev);
        g_strctParadigm.m_cPresetProbeColors(Probe_ii,:) = round(255*ldrgyv2rgb(z,x,y));
        g_strctParadigm.m_cPresetProbeColorIDS(Probe_ii,:) = [theta, satur, elev, x, y, z];
        Probe_ii=Probe_ii+1;
    end
end
g_strctParadigm.m_cPresetProbeColors_N = size(g_strctParadigm.m_cPresetProbeColors,1);
g_strctParadigm.m_cPresetProbeColors(g_strctParadigm.m_cPresetProbeColors<0)=0;

g_strctParadigm.m_cPresetColors{4,1} = round(255*ldrgyv2rgb(0,0,1));        %DKL0
g_strctParadigm.m_cPresetColors{4,2} = round(255*ldrgyv2rgb(0,.7,.7));      %DKL45
g_strctParadigm.m_cPresetColors{4,3} = round(255*ldrgyv2rgb(0,1,0));        %DKL90
g_strctParadigm.m_cPresetColors{4,4} = round(255*ldrgyv2rgb(0,.7,-.7));     %DKL135
g_strctParadigm.m_cPresetColors{4,5} = round(255*ldrgyv2rgb(0,0,-1));       %DKL180
g_strctParadigm.m_cPresetColors{4,6} = round(255*ldrgyv2rgb(0,-.7,-.7));    %DKL225
g_strctParadigm.m_cPresetColors{4,7} = round(255*ldrgyv2rgb(0,-1,0));       %DKL270
g_strctParadigm.m_cPresetColors{4,8} = round(255*ldrgyv2rgb(0,-.7,.7));     %DKL315

g_strctParadigm.m_cPresetColorList(1,:) = g_strctParadigm.m_cPresetColors{1,1};
g_strctParadigm.m_cPresetColorList(2,:) = g_strctParadigm.m_cPresetColors{1,2};
g_strctParadigm.m_cPresetColorList(3,:) = g_strctParadigm.m_cPresetColors{2,1};
g_strctParadigm.m_cPresetColorList(4,:) = g_strctParadigm.m_cPresetColors{2,2};
g_strctParadigm.m_cPresetColorList(5,:) = g_strctParadigm.m_cPresetColors{3,1};
g_strctParadigm.m_cPresetColorList(6,:) = g_strctParadigm.m_cPresetColors{3,2};
g_strctParadigm.m_cPresetColorList(7,:) = g_strctParadigm.m_cPresetColors{4,1};
g_strctParadigm.m_cPresetColorList(8,:) = g_strctParadigm.m_cPresetColors{4,2};
g_strctParadigm.m_cPresetColorList(9,:) = g_strctParadigm.m_cPresetColors{4,3};
g_strctParadigm.m_cPresetColorList(10,:) = g_strctParadigm.m_cPresetColors{4,4};
g_strctParadigm.m_cPresetColorList(11,:) = g_strctParadigm.m_cPresetColors{4,5};
g_strctParadigm.m_cPresetColorList(12,:) = g_strctParadigm.m_cPresetColors{4,6};
g_strctParadigm.m_cPresetColorList(13,:) = g_strctParadigm.m_cPresetColors{4,7};
g_strctParadigm.m_cPresetColorList(14,:) = g_strctParadigm.m_cPresetColors{4,8};
g_strctParadigm.m_cPresetColorList(15,:) = [0 0 0];
g_strctParadigm.m_cPresetColorList(16,:) = [255 255 255];

g_strctParadigm.m_aiPresetSaturations = g_strctParadigm.m_afInitial_Saturations;

% Felix add: comment: these are cone-isolating stimulus values...
% apparently?
% edit as needed for correct luminance callibration vals on screen
% g_strctParadigm.m_cPresetColors{1,1} = [255, 0, 0];
% g_strctParadigm.m_cPresetColors{1,2} = [0,154,38]; 
% g_strctParadigm.m_cPresetColors{2,1} = [0,154,38]; 
% g_strctParadigm.m_cPresetColors{2,2} = [255, 0, 0]; 
% g_strctParadigm.m_cPresetColors{3,1} = [0, 252, 0];
% g_strctParadigm.m_cPresetColors{3,2} = [255, 0, 55];
% g_strctParadigm.m_cPresetColors{4,1} = [255, 0, 55];
% g_strctParadigm.m_cPresetColors{4,2} = [0, 252, 0];
% g_strctParadigm.m_cPresetColors{5,1} = [148, 0, 255];
% g_strctParadigm.m_cPresetColors{5,2} = [52, 209, 0];
% g_strctParadigm.m_cPresetColors{6,1} = [52, 209, 0]; 	
% g_strctParadigm.m_cPresetColors{6,2} = [148, 0, 255]; 	
% g_strctParadigm.m_cPresetColors{7,1} = [255, 255, 255];
% g_strctParadigm.m_cPresetColors{7,2} = [0, 0, 0];
% g_strctParadigm.m_cPresetColors{8,1} = [0, 0, 0]; 	
% g_strctParadigm.m_cPresetColors{8,2} = [255, 255, 255]; 	

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


% 				

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

g_strctParadigm.m_bRepeatNonFixatedImages = false;

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
% g_strctParadigm.m_aiCalibratedBackgroundColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedBGColor(1)*65535)+1),...
%                                                  g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedBGColor(2)*65535)+1),...
%                                                  g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedBGColor(3)*65535)+1)];
g_strctParadigm.m_aiCalibratedBackgroundColor = round(ldrgyv2rgb(0,0,0)*65535);

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
g_strctParadigm.m_iNumOrientationBins = 36;

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
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'SecondaryStimulusPosition', g_strctParadigm.m_afInitial_SecondaryStimulusPosition, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TertiaryStimulusPosition', g_strctParadigm.m_afInitial_SecondaryStimulusPosition, iSmallBuffer);
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

%% Five Dot

g_strctParadigm.m_bShowEyeTraces = 1;

iBufferLen = 30000;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'initFixationSpotPix', g_strctStimulusServer.m_aiScreenSize(3:4)/2, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSpotPix', g_strctStimulusServer.m_aiScreenSize(3:4)/2, iBufferLen);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSizePix', g_strctParadigm.m_fInitial_FixationSizePix, 100);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'SpreadPix', g_strctParadigm.m_fInitial_SpreadPix, 100);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeBoxPix', g_strctParadigm.m_fInitial_GazeBoxPix, 100);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotBackgroundColor', g_strctParadigm.m_afInitial_BackgroundColor, 100);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusON_MS', g_strctParadigm.m_fInitial_FivedotStimulusON_MS, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusArea', g_strctParadigm.m_fInitial_SpreadPix*2, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotWidth', g_strctParadigm.m_fInitial_GroundtruthWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotLength', g_strctParadigm.m_fInitial_GroundtruthLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotOffset', g_strctParadigm.m_fInitial_GroundtruthOffset, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotOrientation', g_strctParadigm.m_fInitial_MovingBarOrientation, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotNumberOfBars', g_strctParadigm.m_fInitial_GroundtruthNumberOfBars, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotCISonly', g_strctParadigm.m_fInitial_GroundtruthCISonly, iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarStimulusArea as width

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotMoveDistance', g_strctParadigm.m_fInitial_MovingBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotMoveSpeed', g_strctParadigm.m_fInitial_MovingBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusRed', g_strctParadigm.m_fInitial_MovingBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusGreen', g_strctParadigm.m_fInitial_MovingBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusBlue', g_strctParadigm.m_fInitial_MovingBarStimulusBlue, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotBackgroundRed', g_strctParadigm.m_fInitial_DualstimBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotBackgroundGreen', g_strctParadigm.m_fInitial_DualstimBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotBackgroundBlue', g_strctParadigm.m_fInitial_DualstimBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotBlur', g_strctParadigm.m_fInitial_DualstimBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotBlurSteps', g_strctParadigm.m_fInitial_DualstimBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusOffTime', g_strctParadigm.m_fInitial_GroundtruthStimulusOffTime , iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusOnTime', g_strctParadigm.m_fInitial_GroundtruthStimulusOnTime, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotStimulusPresetColor', g_strctParadigm.m_fInitial_PlainBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FivedotCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

%% For discs
g_strctParadigm.m_bUseCenterSurroundProbe = 0;
g_strctParadigm.m_strctHandMappingParams.m_bPerfectCircles = 1;


g_strctParadigm.DiscprobeBlockSize = g_strctParadigm.m_cPresetProbeColors_N;
g_strctParadigm.Discprobe_trialindex = randperm(g_strctParadigm.DiscprobeBlockSize);
g_strctParadigm.DiscprobeBlocknum=1;
g_strctParadigm.DiscprobeTrialnum=1;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeDiameter', g_strctParadigm.m_fInitial_DiscDiameter, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusOnTime', g_strctParadigm.m_fInitial_DiscStimulusOnTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusOffTime', g_strctParadigm.m_fInitial_DiscStimulusOffTime, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusArea', g_strctParadigm.m_fInitial_DiscStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeBackgroundRed', g_strctParadigm.m_fInitial_DiscBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeBackgroundGreen', g_strctParadigm.m_fInitial_DiscBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeBackgroundBlue', g_strctParadigm.m_fInitial_DiscBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusRed', g_strctParadigm.m_fInitial_DiscStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusGreen', g_strctParadigm.m_fInitial_DiscStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusBlue', g_strctParadigm.m_fInitial_DiscStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscProbeStimulusPresetColor', g_strctParadigm.m_fInitial_DiscStimulusPresetColor, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscDiameter', g_strctParadigm.m_fInitial_DiscDiameter, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusArea', g_strctParadigm.m_fInitial_DiscStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusRed', g_strctParadigm.m_fInitial_DiscStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusGreen', g_strctParadigm.m_fInitial_DiscStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusBlue', g_strctParadigm.m_fInitial_DiscStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundRed', g_strctParadigm.m_fInitial_DiscBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundGreen', g_strctParadigm.m_fInitial_DiscBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundBlue', g_strctParadigm.m_fInitial_DiscBackgroundBlue, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusOnTime', g_strctParadigm.m_fInitial_DiscStimulusOnTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusOffTime', g_strctParadigm.m_fInitial_DiscStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusPresetColor', g_strctParadigm.m_fInitial_DiscStimulusPresetColor, iSmallBuffer);
g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation = 0;
g_strctParadigm.m_bRandomDiscStimulusPosition = 0;
g_strctParadigm.m_bUseDiscPresetColors = 0;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscNumberOfDiscs', g_strctParadigm.m_fInitial_DiscNumberOfDiscs, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscOrientation', g_strctParadigm.m_fInitial_DiscOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscMoveDistance', g_strctParadigm.m_fInitial_DiscMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscMoveSpeed', g_strctParadigm.m_fInitial_DiscMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBlur', g_strctParadigm.m_fInitial_DiscBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBlurSteps', g_strctParadigm.m_fInitial_DiscBlurSteps, iSmallBuffer);

%disc colors
%[x,y,z]=pol2cart(pi/4,1,0);

%% Dualstim Stimuli
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ContinuousDisplay', g_strctParadigm.m_fInitial_ContinuousDisplay, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CSDtrigframe', g_strctParadigm.m_fInitial_CSDtrigframe, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'cloudpix', g_strctParadigm.m_fInitial_cloudpix, iSmallBuffer);

tic
g_strctParadigm.DKLref=[];
% for lvch=[-1 -0.5 0 0.5 1]
%     for rgch=[-1 -0.6 -0.3 0 0.3 0.6 1]
%         for yvch=[-1 -0.6 -0.3 0 0.3 0.6 1]
%             g_strctParadigm.DKLref=[g_strctParadigm.DKLref, [lvch;rgch;yvch]];
%         end
%     end
% end
for lvch=[-1 -0.6 -0.3 0 0.3 0.6 1]
    g_strctParadigm.DKLref=[g_strctParadigm.DKLref, [lvch;0;0]];
end
for rgch=[-1 -0.6 -0.3 0 0.3 0.6 1]
    g_strctParadigm.DKLref=[g_strctParadigm.DKLref, [0;rgch;0]];
end
for yvch=[-1 -0.6 -0.3 0 0.3 0.6 1]
    g_strctParadigm.DKLref=[g_strctParadigm.DKLref, [0;0;yvch]];
end
g_strctParadigm.DKLclut=round(255*ldrgyv2rgb(g_strctParadigm.DKLref(1,:), g_strctParadigm.DKLref(2,:), g_strctParadigm.DKLref(3,:))');

fnInitializeHartleyTextures('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7)
fnParadigmToStimulusServer('ForceMessage', 'InitializeHartleyTextures', 'Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat', 7);

% pregen Achromcloud - commented out for time
%{
% 		fnParadigmToStimulusServer('ForceMessage', 'PrepareChoiceTextures', g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType,...
% 										fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'), numInitialChoices,...
% 										[fnTsGetVar('g_strctParadigm', 'ChoiceLength'),fnTsGetVar('g_strctParadigm', 'ChoiceWidth')], ...
% 										numLuminanceStepsPerChoice, ...
% 										g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceNoiseBlockSize'));

% g_strctParadigm.hartleyset=load('Z:\StimulusSet\NTlab_cis\hartleys_50_wbins.mat');
% g_strctParadigm.hartleyset.hartleys=shiftdim(127.5*(1+(g_strctParadigm.hartleyset.hartleys50./max(max(max(g_strctParadigm.hartleyset.hartleys50))))),1);
% g_strctParadigm.hartleyset.hartleys_binned=shiftdim(g_strctParadigm.hartleyset.hartleys50_binned,1);
% 
% g_strctParadigm.hartleyset.Colhartleys50=cat(3,cat(4,g_strctParadigm.hartleyset.hartleys,ones(size(g_strctParadigm.hartleyset.hartleys))*127,ones(size(g_strctParadigm.hartleyset.hartleys))*127),...
%     cat(4,ones(size(g_strctParadigm.hartleyset.hartleys))*127,g_strctParadigm.hartleyset.hartleys,ones(size(g_strctParadigm.hartleyset.hartleys))*127),...
%     cat(4,ones(size(g_strctParadigm.hartleyset.hartleys))*127,ones(size(g_strctParadigm.hartleyset.hartleys))*127,g_strctParadigm.hartleyset.hartleys));
% 
% g_strctParadigm.hartleyset.Colhartleys50_binned=cat(3,g_strctParadigm.hartleyset.hartleys_binned, g_strctParadigm.hartleyset.hartleys_binned+7,g_strctParadigm.hartleyset.hartleys_binned+14);

% Initialize cloud stimuli
%}
%{
cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'Dualstim_pregen_achromcloud_n', g_strctParadigm.m_fInitial_DualstimPregen_achromcloud_n, iSmallBuffer);
g_strctParadigm.DensenoiseScale=g_strctParadigm.m_fInitial_DualstimPrimaryCloudScale;
g_strctParadigm.Dualstim_pregen_achromcloud_n =  g_strctParadigm.m_fInitial_DualstimPregen_achromcloud_n; %number of unique frames; 6000 in pregen code
g_strctParadigm.DensenoiseAchromcloud = (mk_spatialcloud(cloudpix,cloudpix, g_strctParadigm.Dualstim_pregen_achromcloud_n, g_strctParadigm.DensenoiseScale)./2 +.5).*255;
[~,g_strctParadigm.DensenoiseAchromcloud_binned] = histc(g_strctParadigm.DensenoiseAchromcloud,linspace(0,255,256));

fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud, g_strctParadigm.DensenoiseAchromcloud_binned);
%}



%/{
g_strctParadigm.NoiseStimDir = 'Z:\StimulusSet\NTlab_cis\Cloudstims_calib_02_2021';
g_strctParadigm.Cur_CCloud_loaded = g_strctParadigm.NoiseStimDir;
g_strctParadigm.Dualstim_pregen_chromcloud_n = 4000;
g_strctParadigm.Dualstim_pregen_achromcloud_n = 4000;
g_strctParadigm.maxblocks = 10;

cloudpix=fnTsGetVar('g_strctParadigm' ,'cloudpix');
g_strctParadigm.DensenoiseScale = g_strctParadigm.m_fInitial_DualstimPrimaryCloudScale;
load([g_strctParadigm.NoiseStimDir '\' sprintf('Cloudstims_Achrom_size%d_scale%d_%02d.mat', cloudpix, g_strctParadigm.DensenoiseScale, 1)],'DensenoiseAchromcloud_binned');
g_strctParadigm.DensenoiseAchromcloud_binned = DensenoiseAchromcloud_binned; clearvars DensenoiseAchromcloud_binned
fnInitializeAchromCloudTextures(g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud_binned, g_strctParadigm.DensenoiseAchromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeAchromCloudTextures', g_strctParadigm.Dualstim_pregen_achromcloud_n, 0, g_strctParadigm.DensenoiseAchromcloud_binned, g_strctParadigm.DensenoiseAchromcloud_binned);
%}

Nreps=2;
g_strctParadigm.DualstimTrialLength = g_strctParadigm.m_fInitial_DualstimTrialLength;
g_strctParadigm.DualstimBlockSize = g_strctParadigm.m_fInitial_DualstimBlockSize;
g_strctParadigm.DualstimBlockSizeTotal = g_strctParadigm.DualstimBlockSize*Nreps;
g_strctParadigm.DualstimAchromcloud_stimseqs=randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,g_strctParadigm.DualstimBlockSize,ceil(g_strctParadigm.DualstimTrialLength/2));
g_strctParadigm.DualstimAchromcloud_trialindex = [randperm(g_strctParadigm.DualstimBlockSize),randperm(g_strctParadigm.DualstimBlockSize)];
g_strctParadigm.DualstimAchromcloudBlocknum=1;
g_strctParadigm.DualstimAchromcloudTrialnum=1;

g_strctParadigm.DensenoiseTrialLength = g_strctParadigm.m_fInitial_DensenoiseTrialLength;
g_strctParadigm.DensenoiseBlockSize = g_strctParadigm.m_fInitial_DensenoiseBlockSize;
g_strctParadigm.DensenoiseBlockSizeTotal = g_strctParadigm.DensenoiseBlockSize*Nreps;
g_strctParadigm.DensenoiseAchromcloud_stimseqs=randi(g_strctParadigm.Dualstim_pregen_achromcloud_n,g_strctParadigm.DensenoiseBlockSize,ceil(g_strctParadigm.DensenoiseTrialLength/2));
g_strctParadigm.DensenoiseAchromcloud_trialindex = [randperm(g_strctParadigm.DensenoiseBlockSize),randperm(g_strctParadigm.DensenoiseBlockSize)];
g_strctParadigm.DensenoiseAchromcloudBlocknum=1;
g_strctParadigm.DensenoiseAchromcloudTrialnum=1;

% Initialize color cloud stimuli
% g_strctParadigm = fnTsAddVar(g_strctParadigm, 'Dualstim_pregen_chromcloud_n', g_strctParadigm.m_fDualstimpregen_chromcloud_n, iSmallBuffer);
% pregen chromcloud - commented out for time
%{ 
%tic
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseScale', g_strctParadigm.m_fInitial_DualstimSecondaryBarWidth, iSmallBuffer);
        g_strctParadigm.Cur_CCloud_loaded = 'randpregen';
        spatialscale=fnTsGetVar('g_strctParadigm' ,'DensenoiseScale');
        g_strctParadigm.Dualstim_pregen_chromcloud_n =  g_strctParadigm.m_fInitial_DualstimPregen_chromcloud_n;
        g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(mk_spatialcloudRGB(cloudpix, cloudpix, g_strctParadigm.Dualstim_pregen_chromcloud_n, spatialscale),cloudpix*cloudpix*g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
        DensenoiseChromcloud_sums=sum(abs(g_strctParadigm.DensenoiseChromcloud_DKlspace),2); DensenoiseChromcloud_sums(DensenoiseChromcloud_sums < 1)=1;
        g_strctParadigm.DensenoiseChromcloud_DKlspace=g_strctParadigm.DensenoiseChromcloud_DKlspace./[DensenoiseChromcloud_sums,DensenoiseChromcloud_sums,DensenoiseChromcloud_sums];
        g_strctParadigm.DensenoiseChromcloud=reshape(round(255.*ldrgyv2rgb(g_strctParadigm.DensenoiseChromcloud_DKlspace(:,1)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,2)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,3)'))',cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
        g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(g_strctParadigm.DensenoiseChromcloud_DKlspace,cloudpix,cloudpix,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
%{
g_strctParadigm.DensenoiseScale=g_strctParadigm.m_fInitial_DualstimSecondaryBarWidth;
g_strctParadigm.Cur_CCloud_loaded = 'randpregen';
g_strctParadigm.Dualstim_pregen_chromcloud_n =  g_strctParadigm.m_fInitial_DualstimPregen_chromcloud_n;
DensenoiseChromcloud1 = (mk_spatialcloudRGB(25, 25, g_strctParadigm.Dualstim_pregen_chromcloud_n, g_strctParadigm.DensenoiseScale));
DensenoiseChromcloud2=reshape(DensenoiseChromcloud1,25*25*g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
DensenoiseChromcloud_sums=sum(abs(DensenoiseChromcloud2),2); DensenoiseChromcloud_sums(DensenoiseChromcloud_sums < 1)=1;
g_strctParadigm.DensenoiseChromcloud_DKlspace=DensenoiseChromcloud2./[DensenoiseChromcloud_sums,DensenoiseChromcloud_sums,DensenoiseChromcloud_sums];
DensenoiseChromcloud3=round(255.*ldrgyv2rgb(g_strctParadigm.DensenoiseChromcloud_DKlspace(:,1)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,2)',g_strctParadigm.DensenoiseChromcloud_DKlspace(:,3)'));
g_strctParadigm.DensenoiseChromcloud=reshape(DensenoiseChromcloud3',25,25,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
g_strctParadigm.DensenoiseChromcloud_DKlspace=reshape(g_strctParadigm.DensenoiseChromcloud_DKlspace',25,25,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);
%}
        %toc
fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);
%}

load([g_strctParadigm.NoiseStimDir '\' sprintf('Cloudstims_Chrom_size%d_scale%d_%02d.mat', cloudpix, g_strctParadigm.DensenoiseScale, 1)], 'DensenoiseChromcloud');
g_strctParadigm.DensenoiseChromcloud = DensenoiseChromcloud; clearvars DensenoiseChromcloud
fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud);

g_strctParadigm.DensenoiseChromcloud_stimseqs=randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,g_strctParadigm.DensenoiseBlockSize,ceil(g_strctParadigm.DensenoiseTrialLength/2));
g_strctParadigm.DensenoiseChromcloud_trialindex = [randperm(g_strctParadigm.DensenoiseBlockSize),randperm(g_strctParadigm.DensenoiseBlockSize)];
g_strctParadigm.DensenoiseChromcloudBlocknum=1;
g_strctParadigm.DensenoiseChromcloudTrialnum=1;

g_strctParadigm.DualstimChromcloud_stimseqs=randi(g_strctParadigm.Dualstim_pregen_chromcloud_n,g_strctParadigm.DualstimBlockSize,ceil(g_strctParadigm.DualstimTrialLength/2));
g_strctParadigm.DualstimChromcloud_trialindex = [randperm(g_strctParadigm.DualstimBlockSize),randperm(g_strctParadigm.DualstimBlockSize)];
g_strctParadigm.DualstimChromcloudBlocknum=1;
g_strctParadigm.DualstimChromcloudTrialnum=1;
%}

%old code for the same thing:
%{ 
% % this is the old, long way (but hey, it worked)

%g_strctParadigm.DensenoiseChromcloud = 2*(mk_spatialcloudRGB(25, 25, g_strctParadigm.Dualstim_pregen_chromcloud_n, 4)-.5);
g_strctParadigm.Dualstim_pregen_chromcloud_n=1000;
g_strctParadigm.Cur_Cloud_loaded = 'randgen';
g_strctParadigm.DensenoiseChromcloud = (mk_spatialcloudRGB(25, 25, g_strctParadigm.Dualstim_pregen_chromcloud_n, 4));
g_strctParadigm.DKLref_colcloud=[];
lvinds=[-0.6 -0.3 0 0.3 0.6];
rgyvinds=[-1 -0.6 -0.3 0 0.3 0.6 1];
for lvch=lvinds
    for rgch=rgyvinds
        for yvch=rgyvinds
            g_strctParadigm.DKLref_colcloud=[g_strctParadigm.DKLref_colcloud, [lvch;rgch;yvch]];
        end
    end
end

g_strctParadigm.DKLclut_colcloud=round(255*ldrgyv2rgb(g_strctParadigm.DKLref_colcloud(1,:), g_strctParadigm.DKLref_colcloud(2,:), g_strctParadigm.DKLref_colcloud(3,:))');

lv_in=g_strctParadigm.DensenoiseChromcloud(:,:,:,1);
[~,lv_bin]=histc(g_strctParadigm.DensenoiseChromcloud(:,:,:,1),[-1, -.45, -.15, .15, .45, 1]);
for bb=1:5; lv_in(lv_bin==bb)=lvinds(bb); end

rg_in=g_strctParadigm.DensenoiseChromcloud(:,:,:,2);
[~,rg_bin]=histc(g_strctParadigm.DensenoiseChromcloud(:,:,:,2),[-1, -.75, -.45, -.15, .15, .45, .75, 1]);
for bb=1:7; rg_in(rg_bin==bb)=rgyvinds(bb); end

yv_in=g_strctParadigm.DensenoiseChromcloud(:,:,:,3);
[~,yv_bin]=histc(g_strctParadigm.DensenoiseChromcloud(:,:,:,3),[-1, -.75, -.45, -.15, .15, .45, .75, 1]);
for bb=1:7; yv_in(yv_bin==bb)=rgyvinds(bb); end

g_strctParadigm.DensenoiseChromcloud = shiftdim(reshape(ldrgyv2rgb(lv_in(:)',rg_in(:)',yv_in(:)'),3,25,25,g_strctParadigm.Dualstim_pregen_chromcloud_n),1).*255;	
%[~,g_strctParadigm.DensenoiseChromcloud_binned] = histc(g_strctParadigm.DensenoiseChromcloud,linspace(0,255,256));

g_strctParadigm.DensenoiseChromcloud_binned=[lv_in(:),rg_in(:),yv_in(:)];
for bb=1:length(g_strctParadigm.DKLref_colcloud)
    [~,index]=ismember(g_strctParadigm.DensenoiseChromcloud_binned, g_strctParadigm.DKLref_colcloud(:,bb)','rows');
    g_strctParadigm.DensenoiseChromcloud_binned(find(index),:)=bb+8; %adjust for color offset
end
g_strctParadigm.DensenoiseChromcloud_binned = reshape(g_strctParadigm.DensenoiseChromcloud_binned,25,25,g_strctParadigm.Dualstim_pregen_chromcloud_n,3);

%}
%{
g_strctParadigm.Cur_CCloud_expt=1;
%g_strctParadigm.Cur_CCloud_loaded=['Z:\StimulusSet\NTlab_cis\' sprintf('Cloudstims_size25scale2v2_%02d.mat',g_strctParadigm.Cur_Cloud_expt)];
g_strctParadigm.Cur_CCloud_loaded=['Z:\StimulusSet\NTlab_cis\' sprintf('Cloudstims_size25scale2_%02d.mat',g_strctParadigm.Cur_CCloud_expt)];
load(g_strctParadigm.Cur_CCloud_loaded)
g_strctParadigm.Dualstim_pregen_chromcloud_n = length(cloudstim_disp);

g_strctParadigm.ColCloudOffset=0;

g_strctParadigm.DensenoiseChromcloud_binned = cloudstim_disp+g_strctParadigm.ColCloudOffset;
g_strctParadigm.DensenoiseChromcloud = 255*((cloudstim_local+1)./2);
g_strctParadigm.DKLref_colcloud = cloudstim_dklrefLUT';
g_strctParadigm.DKLclut_colcloud = round(255.*ldrgyv2rgb(g_strctParadigm.DKLref_colcloud(:,1)', g_strctParadigm.DKLref_colcloud(:,2)', g_strctParadigm.DKLref_colcloud(:,3)')');

fnInitializeChromCloudTextures(g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeChromCloudTextures', g_strctParadigm.Dualstim_pregen_chromcloud_n, 0, g_strctParadigm.DensenoiseChromcloud, g_strctParadigm.DensenoiseChromcloud_binned);
%}

% load bar stimulus textures
g_strctParadigm.barstims_base=load('Z:\StimulusSet\NTlab_cis\barstims_base25.mat');
g_strctParadigm.Dualstim_pregen_chrombar_n =  g_strctParadigm.m_fInitial_DualstimPregen_chrombars_n;
g_strctParadigm.barprobs=[.2 .2 .2 .1 .1 .1 .1];
g_strctParadigm.barprobs_lum = [.34 .33 .33 0 0 0 0];
g_strctParadigm.barcolsDKL = [0 0 0; -1 0 0; 1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
g_strctParadigm.barcolsRGB = [127 127 127; 0 0 0; 255 255 255; g_strctParadigm.m_cPresetColors{4,3}'; g_strctParadigm.m_cPresetColors{4,7}'; g_strctParadigm.m_cPresetColors{4,1}'; g_strctParadigm.m_cPresetColors{4,5}'];


g_strctParadigm.barcolsDKLCLUT = zeros(256,3);
g_strctParadigm.barcolsDKLCLUT(1,:) = (65535/255)*[127 127 127];%strctTrial.m_afBackgroundColor;
g_strctParadigm.barcolsDKLCLUT(3,:) = (65535/255)*[255 255 255];
g_strctParadigm.barcolsDKLCLUT(4,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,3};
g_strctParadigm.barcolsDKLCLUT(5,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,7};
g_strctParadigm.barcolsDKLCLUT(6,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,1};
g_strctParadigm.barcolsDKLCLUT(7,:) = (65535/255)*g_strctParadigm.m_cPresetColors{4,5};

% pregen bar stimuli - old version commented out for time
%{
%tic
cur_ori=0; cur_oribin=floor(cur_ori./15)+1;

DensenoiseChromBar=reshape(repmat(squeeze(g_strctParadigm.barstims_base.barmat_n50s2(cur_oribin,:,:)),1,1,g_strctParadigm.Dualstim_pregen_chrombar_n),50*50,g_strctParadigm.Dualstim_pregen_chrombar_n);
nbars=25;
randseed=rand(g_strctParadigm.Dualstim_pregen_chrombar_n, nbars);
g_strctParadigm.chrombarmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n, nbars);
pvec_edges=[0 cumsum(g_strctParadigm.barprobs)];
for pp=1:7
    g_strctParadigm.chrombarmat(randseed>pvec_edges(pp) & randseed<pvec_edges(pp+1))=pp;
end

for ff=1:g_strctParadigm.Dualstim_pregen_chrombar_n
    g_strctParadigm.DensenoiseChromBar(find(DensenoiseChromBar(:,ff)==0),ff,1:3)=repmat(g_strctParadigm.barcolsRGB(1,:),length(find(DensenoiseChromBar(:,ff)==0)),1);
    for pp=1:7
        curbars=find(g_strctParadigm.chrombarmat(ff,:)==pp);
        g_strctParadigm.DensenoiseChromBar(find(ismember(DensenoiseChromBar(:,ff),curbars)),ff,1:3)=repmat(g_strctParadigm.barcolsRGB(pp,:),length(find(ismember(DensenoiseChromBar(:,ff),curbars))),1);
    end
end
g_strctParadigm.DensenoiseChromBar=reshape(g_strctParadigm.DensenoiseChromBar,50,50,g_strctParadigm.Dualstim_pregen_chrombar_n,3);
%toc

fnInitializeChromBarTextures(g_strctParadigm.Dualstim_pregen_chrombar_n, 0, g_strctParadigm.DensenoiseChromBar, g_strctParadigm.DensenoiseChromBar) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeChromBarTextures', g_strctParadigm.Dualstim_pregen_chrombar_n, 0, g_strctParadigm.DensenoiseChromBar, g_strctParadigm.DensenoiseChromBar);
%}

% pregen bar stimuli to only use simple textures
%/{
cur_ori=0; cur_oribin=floor(cur_ori./15)+1;

DensenoiseChromBar=reshape(repmat(squeeze(g_strctParadigm.barstims_base.barmat_n50s2(cur_oribin,:,:)),1,1,g_strctParadigm.Dualstim_pregen_chrombar_n),50*50,g_strctParadigm.Dualstim_pregen_chrombar_n);
nbars=25;
randseed=rand(g_strctParadigm.Dualstim_pregen_chrombar_n, nbars);
g_strctParadigm.chrombarmat = zeros(g_strctParadigm.Dualstim_pregen_chrombar_n, nbars);
pvec_edges=[0 cumsum(g_strctParadigm.barprobs)];
for pp=1:7
    g_strctParadigm.chrombarmat(randseed>pvec_edges(pp) & randseed<pvec_edges(pp+1))=pp;
end

for ff=1:g_strctParadigm.Dualstim_pregen_chrombar_n
    g_strctParadigm.DensenoiseChromBar(find(DensenoiseChromBar(:,ff)==0),ff,1:3)=repmat(g_strctParadigm.barcolsRGB(1,:),length(find(DensenoiseChromBar(:,ff)==0)),1);
    for pp=1:7
        curbars=find(g_strctParadigm.chrombarmat(ff,:)==pp);
        g_strctParadigm.DensenoiseChromBar(find(ismember(DensenoiseChromBar(:,ff),curbars)),ff,1:3)=repmat(g_strctParadigm.barcolsRGB(pp,:),length(find(ismember(DensenoiseChromBar(:,ff),curbars))),1);
    end
end
g_strctParadigm.DensenoiseChromBar=reshape(g_strctParadigm.DensenoiseChromBar,50,50,g_strctParadigm.Dualstim_pregen_chrombar_n,3);
g_strctParadigm.DensenoiseChromBarbase=permute(g_strctParadigm.barstims_base.barmat_n50s2+1,[2 3 1]);
g_strctParadigm.DensenoiseChromBarbase=g_strctParadigm.DensenoiseChromBarbase(:,:,[1 12:-1:2]);

fnInitializeChromBarTextures(g_strctParadigm.Dualstim_pregen_chrombar_n, 0, g_strctParadigm.DensenoiseChromBar, g_strctParadigm.DensenoiseChromBarbase) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)
fnParadigmToStimulusServer('ForceMessage', 'InitializeChromBarTextures', g_strctParadigm.Dualstim_pregen_chrombar_n, 0, g_strctParadigm.DensenoiseChromBar, g_strctParadigm.DensenoiseChromBarbase);
%}

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimPrimaryuseRGBCloud', g_strctParadigm.m_fInitial_DualstimPrimaryuseRBGCloud, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusArea', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimScale', g_strctParadigm.m_fInitial_DualstimPrimaryCloudScale, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimWidth', g_strctParadigm.m_fInitial_MovingBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimLength', g_strctParadigm.m_fInitial_MovingBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimOrientation', g_strctParadigm.m_fInitial_MovingBarOrientation, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNSminus', g_strctParadigm.m_fInitial_DualstimNSminus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNSplus', g_strctParadigm.m_fInitial_DualstimNSplus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNMminus', g_strctParadigm.m_fInitial_DualstimNMminus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNMplus', g_strctParadigm.m_fInitial_DualstimNMplus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNLminus', g_strctParadigm.m_fInitial_DualstimNLminus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNLplus', g_strctParadigm.m_fInitial_DualstimNLplus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimNumberOfBars', g_strctParadigm.m_fInitial_DualstimNumberOfBars, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimSecondaryUseCloud', g_strctParadigm.m_fInitial_DualstimSecondaryUseCloud, iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarStimulusArea as width
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimSecondaryStimulusArea', g_strctParadigm.m_fInitial_DualstimSecondaryStimulusArea, iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarStimulusArea as width
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimSecondaryBarWidth', g_strctParadigm.m_fInitial_DualstimSecondaryBarWidth , iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarWidth as width
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimSecondaryWidth', 256, iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarWidth as width
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimSecondaryLength', 256, iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarLength 

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimMoveDistance', g_strctParadigm.m_fInitial_MovingBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimMoveSpeed', g_strctParadigm.m_fInitial_MovingBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusRed', g_strctParadigm.m_fInitial_MovingBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusGreen', g_strctParadigm.m_fInitial_MovingBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusBlue', g_strctParadigm.m_fInitial_MovingBarStimulusBlue, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimBackgroundRed', g_strctParadigm.m_fInitial_DualstimBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimBackgroundGreen', g_strctParadigm.m_fInitial_DualstimBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimBackgroundBlue', g_strctParadigm.m_fInitial_DualstimBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimBlur', g_strctParadigm.m_fInitial_DualstimBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimBlurSteps', g_strctParadigm.m_fInitial_DualstimBlurSteps, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimPrimaryStimulusOffTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOffTime , iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimPrimaryStimulusOnTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOnTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusOffTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOffTime , iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusOnTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOnTime , iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimStimulusPresetColor', g_strctParadigm.m_fInitial_MovingBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DualstimCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

toc
% dbstop if warning
% warning('stop')
%% CI handmapper

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusArea', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperWidth', g_strctParadigm.m_fInitial_MovingBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperLength', g_strctParadigm.m_fInitial_MovingBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperOrientation', g_strctParadigm.m_fInitial_MovingBarOrientation, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNSminus', g_strctParadigm.m_fInitial_DualstimNSminus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNSplus', g_strctParadigm.m_fInitial_DualstimNSplus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNMminus', g_strctParadigm.m_fInitial_DualstimNMminus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNMplus', g_strctParadigm.m_fInitial_DualstimNMplus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNLminus', g_strctParadigm.m_fInitial_DualstimNLminus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNLplus', g_strctParadigm.m_fInitial_DualstimNLplus, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperNumberOfBars', g_strctParadigm.m_fInitial_MovingBarNumberOfBars, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperMoveDistance', g_strctParadigm.m_fInitial_MovingBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperMoveSpeed', g_strctParadigm.m_fInitial_MovingBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusRed', g_strctParadigm.m_fInitial_MovingBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusGreen', g_strctParadigm.m_fInitial_MovingBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusBlue', g_strctParadigm.m_fInitial_MovingBarStimulusBlue, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusIndex', 17, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperBackgroundIndex', 1, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperBackgroundRed', g_strctParadigm.m_fInitial_DualstimBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperBackgroundGreen', g_strctParadigm.m_fInitial_DualstimBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperBackgroundBlue', g_strctParadigm.m_fInitial_DualstimBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperBlur', g_strctParadigm.m_fInitial_DualstimBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperBlurSteps', g_strctParadigm.m_fInitial_DualstimBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusOffTime', g_strctParadigm.m_fInitial_MovingBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CIHandmapperStimulusOnTime', g_strctParadigm.m_fInitial_MovingBarStimulusOnTime, iSmallBuffer);

%% Ground truth

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusArea', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthWidth', g_strctParadigm.m_fInitial_GroundtruthWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthLength', g_strctParadigm.m_fInitial_GroundtruthLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthOffset', g_strctParadigm.m_fInitial_GroundtruthOffset, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthOrientation', g_strctParadigm.m_fInitial_MovingBarOrientation, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthNumberOfBars', g_strctParadigm.m_fInitial_GroundtruthNumberOfBars, iSmallBuffer);
%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthCISonly', g_strctParadigm.m_fInitial_GroundtruthCISonly, iSmallBuffer); % formerly used g_strctParadigm.m_fInitial_MovingBarStimulusArea as width

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthMoveDistance', g_strctParadigm.m_fInitial_MovingBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthMoveSpeed', g_strctParadigm.m_fInitial_MovingBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusRed', g_strctParadigm.m_fInitial_MovingBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusGreen', g_strctParadigm.m_fInitial_MovingBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusBlue', g_strctParadigm.m_fInitial_MovingBarStimulusBlue, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthBackgroundRed', g_strctParadigm.m_fInitial_DualstimBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthBackgroundGreen', g_strctParadigm.m_fInitial_DualstimBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthBackgroundBlue', g_strctParadigm.m_fInitial_DualstimBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthBlur', g_strctParadigm.m_fInitial_DualstimBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthBlurSteps', g_strctParadigm.m_fInitial_DualstimBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusOffTime', g_strctParadigm.m_fInitial_GroundtruthStimulusOffTime , iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusOnTime', g_strctParadigm.m_fInitial_GroundtruthStimulusOnTime, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthStimulusPresetColor', g_strctParadigm.m_fInitial_PlainBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GroundtruthCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

%% Dense noise
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoisePrimaryuseRGBCloud', g_strctParadigm.m_fInitial_DualstimPrimaryuseRBGCloud, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusArea', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseScale', g_strctParadigm.m_fInitial_DualstimPrimaryCloudScale, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseWidth', g_strctParadigm.m_fInitial_MovingBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseLength', g_strctParadigm.m_fInitial_MovingBarLength, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusOffTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOffTime , iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusOnTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOnTime, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseOrientation', g_strctParadigm.m_fInitial_PlainBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseMoveDistance', g_strctParadigm.m_fInitial_PlainBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusArea', g_strctParadigm.m_fInitial_PlainBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusRed', g_strctParadigm.m_fInitial_PlainBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusGreen', g_strctParadigm.m_fInitial_PlainBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusBlue', g_strctParadigm.m_fInitial_PlainBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseBackgroundRed', g_strctParadigm.m_fInitial_PlainBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseBackgroundGreen', g_strctParadigm.m_fInitial_PlainBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseBackgroundBlue', g_strctParadigm.m_fInitial_PlainBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseBlur', g_strctParadigm.m_fInitial_PlainBarBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseBlurSteps', g_strctParadigm.m_fInitial_PlainBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseMoveSpeed', g_strctParadigm.m_fInitial_PlainBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseStimulusPresetColor', g_strctParadigm.m_fInitial_PlainBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DensenoiseCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

%% 1D noise
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseDistType', 1, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusArea', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseNumberofBars', 25, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseScale', g_strctParadigm.m_fInitial_DualstimSecondaryBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseWidth', g_strctParadigm.m_fInitial_MovingBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseLength', g_strctParadigm.m_fInitial_MovingBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseOrientation', g_strctParadigm.m_fInitial_PlainBarOrientation, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusOffTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOffTime , iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusOnTime', g_strctParadigm.m_fInitial_DualstimPrimaryStimulusOnTime, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusArea', g_strctParadigm.m_fInitial_PlainBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusRed', g_strctParadigm.m_fInitial_PlainBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusGreen', g_strctParadigm.m_fInitial_PlainBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusBlue', g_strctParadigm.m_fInitial_PlainBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseBackgroundRed', g_strctParadigm.m_fInitial_PlainBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseBackgroundGreen', g_strctParadigm.m_fInitial_PlainBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseBackgroundBlue', g_strctParadigm.m_fInitial_PlainBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseStimulusPresetColor', g_strctParadigm.m_fInitial_PlainBarStimulusPresetColor, iSmallBuffer);

% only included for continuity
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseBlur', g_strctParadigm.m_fInitial_PlainBarBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseBlurSteps', g_strctParadigm.m_fInitial_PlainBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseMoveSpeed', g_strctParadigm.m_fInitial_PlainBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseMoveDistance', g_strctParadigm.m_fInitial_PlainBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseCurrentVariableModifySpeedHz', g_strctParadigm.m_fInitial_CurrentVariableModifySpeedHz, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'OneDnoiseCurrentVariableModifyRange', g_strctParadigm.m_fInitial_CurrentVariableModifyRange, iSmallBuffer);

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

%% For Movies
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


%%
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

% Felix add - second stimulus field
g_strctPTB.g_strctStimulusServer.m_RefreshRateMS = fnParadigmToKofikoComm('GetRefreshRate');
g_strctPTB.m_strctControlInputs.m_bLastStimulusPositionCheck = 0;

% g_strctParadigm.m_aiCenterOfSecondaryStimulus(1) = g_strctStimulusServer.m_aiScreenSize(3)/4;
% g_strctParadigm.m_aiCenterOfSecondaryStimulus(2) = g_strctStimulusServer.m_aiScreenSize(4)/4;
g_strctParadigm.m_aiCenterOfSecondaryStimulus(1) = g_strctParadigm.SecondaryStimulusPosition.Buffer(1,1,1);
g_strctParadigm.m_aiCenterOfSecondaryStimulus(2) = g_strctParadigm.SecondaryStimulusPosition.Buffer(1,2,1);
g_strctParadigm.g_strctStimulusServer.m_aiSecondaryScreenSize = g_strctStimulusServer.m_aiScreenSize;

g_strctParadigm.m_aiSecondaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiSecondaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiSecondaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(1)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiSecondaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfSecondaryStimulus(2)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
 
g_strctParadigm.m_aiCenterOfTertiaryStimulus(1) = 3*(g_strctStimulusServer.m_aiScreenSize(3)/4);
g_strctParadigm.m_aiCenterOfTertiaryStimulus(2) = 3*(g_strctStimulusServer.m_aiScreenSize(4)/4);
g_strctParadigm.g_strctStimulusServer.m_aiTertiaryScreenSize = g_strctStimulusServer.m_aiScreenSize;

g_strctParadigm.m_aiTertiaryStimulusRect(1) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiTertiaryStimulusRect(2) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiTertiaryStimulusRect(3) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(1)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiTertiaryStimulusRect(4) = g_strctParadigm.m_aiCenterOfTertiaryStimulus(2)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));

% primary stimulus info
% Start the object at the fovea (center of screen). This is handled separately from the other variables during the paradigm
g_strctParadigm.m_aiCenterOfStimulus(1) = g_strctStimulusServer.m_aiScreenSize(3)/2;
g_strctParadigm.m_aiCenterOfStimulus(2) = g_strctStimulusServer.m_aiScreenSize(4)/2;
g_strctParadigm.g_strctStimulusServer.m_aiScreenSize = g_strctStimulusServer.m_aiScreenSize;

g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(squeeze(g_strctParadigm.PlainBarStimulusArea.Buffer(1,:,g_strctParadigm.PlainBarStimulusArea.BufferIdx)/2));


g_strctPTB.m_stimulusAreaUpdating = false;

g_strctParadigm.m_bRandomStimulusPosition = true; %felix added - changed default to true
g_strctParadigm.m_bRandomStimulusOrientation = false;
g_strctParadigm.m_bStimulusCollisions = 0; 
g_strctParadigm.m_bRandPosEachFrame = true;
g_strctParadigm.m_bGroundtruthCISonly = 0;

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
    % Felix uncommented
    % g_strctParadigm.m_strctDesign = [];
end;

acFavoriteLists = {'HandMapper','Images','Movies'};
% felix comment - what does this even do?
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
return;manag