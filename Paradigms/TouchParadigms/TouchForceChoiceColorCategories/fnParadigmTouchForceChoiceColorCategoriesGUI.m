function fnParadigmTouchForceChoiceGUI() 
%
% Copyright (c) 2018 Joshua Fuller-Deets, National Eye Institute.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global g_strctParadigm   
    
[hParadigmPanel, iPanelHeight, iPanelWidth] = fnCreateParadigmPanel();
strctControllers.m_hPanel = hParadigmPanel;
strctControllers.m_iPanelHeight = iPanelHeight;
strctControllers.m_iPanelWidth = iPanelWidth;

iNumButtonsInRow = 3;
iButtonWidth = iPanelWidth / iNumButtonsInRow - 20;


[strctTrainingControllers.m_hPanel, strctTrainingControllers.m_iPanelHeight,strctTrainingControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(hParadigmPanel,90,iPanelHeight-5,'Training');


[strctStimuliControllers.m_hPanel, strctStimuliControllers.m_iPanelHeight,strctStimuliControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(hParadigmPanel,90,iPanelHeight-5,'Stimuli');


[strctRewardControllers.m_hPanel, strctRewardControllers.m_iPanelHeight,strctRewardControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(hParadigmPanel,90,iPanelHeight-5,'Reward');

[strctMicroStimControllers.m_hPanel, strctMicroStimControllers.m_iPanelHeight,strctMicroStimControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(hParadigmPanel,90,iPanelHeight-5,'Microstim');

[strctDesignControllers.m_hPanel, strctDesignControllers.m_iPanelHeight,strctDesignControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(hParadigmPanel,90,iPanelHeight-5,'Design');

[strctStatControllers.m_hPanel, strctStatControllers.m_iPanelHeight,strctStatControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(hParadigmPanel,90,iPanelHeight-5,'Statistics');

strctControllers.m_hSubPanels = [strctTrainingControllers.m_hPanel;strctStimuliControllers.m_hPanel;strctRewardControllers.m_hPanel;...
    strctMicroStimControllers.m_hPanel;strctDesignControllers.m_hPanel;strctStatControllers.m_hPanel];

 strctControllers.m_hSetTimingPanel = uicontrol('Parent',hParadigmPanel, 'Style', 'pushbutton', 'String', 'Training',...
      'Position', [5 iPanelHeight-40 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''TrainingPanel'');'],'enable','on');
    
 strctControllers.m_hSetStimuliPanel = uicontrol('Parent',hParadigmPanel, 'Style', 'pushbutton', 'String', 'Stimuli',...
      'Position', [iButtonWidth+10 iPanelHeight-40 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''StimuliPanel'');'],'enable','on');

 strctControllers.m_hSetRewardPanel = uicontrol('Parent',hParadigmPanel, 'Style', 'pushbutton', 'String', 'Reward',...
      'Position', [2*iButtonWidth+20 iPanelHeight-40 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''RewardPanel'');'],'enable','on');

   strctControllers.m_hSetMicroStimPanel = uicontrol('Parent',hParadigmPanel, 'Style', 'pushbutton', 'String', 'Microstim',...
      'Position', [5 iPanelHeight-80 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''MicrostimPanel'');'],'enable','on');

     strctControllers.m_hDesignPanel = uicontrol('Parent',hParadigmPanel, 'Style', 'pushbutton', 'String', 'Design',...
      'Position', [iButtonWidth+10 iPanelHeight-80 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''DesignPanel'');']);

strctControllers.m_hStatPanel = uicontrol('Parent',hParadigmPanel, 'Style', 'pushbutton', 'String', 'Statistics',...
      'Position', [2*iButtonWidth+20 iPanelHeight-80 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''StatPanel'');']);
	  
%% Juice

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctRewardControllers.m_hPanel, 40+30*1, ...
    'Juice Time (ms):', 'JuiceTimeMS',25, 100, [1, 5], fnTsGetVar('g_strctParadigm','JuiceTimeMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctRewardControllers.m_hPanel, 40+30*2, ...
    'Juice Time (High):', 'JuiceTimeHighMS', 25, 100, [1, 5], fnTsGetVar('g_strctParadigm','JuiceTimeHighMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctRewardControllers.m_hPanel, 40+30*3, ...
    'Blink Time (ms):', 'BlinkTimeMS', 10, 500, [1, 50], fnTsGetVar('g_strctParadigm','BlinkTimeMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctRewardControllers.m_hPanel,40+30*4, ...
    'Positive Increment (%):', 'PositiveIncrement', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','PositiveIncrement'));

% How big is the area the animal can fixate in?
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctRewardControllers.m_hPanel,40+30*5, ...
    'Fixation Area radius (pix):', 'FixationRadiusPix', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','FixationRadiusPix'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctRewardControllers.m_hPanel,40+30*6, ...
    'Number Juice Drops:', 'NumberOfJuiceDrops', 0, 4, [1, 5], fnTsGetVar('g_strctParadigm','NumberOfJuiceDrops'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctRewardControllers.m_hPanel,40+30*7, ...
    'Juice Drop Interval (ms):', 'JuiceDropInterval', 0, 1000, [1, 5], fnTsGetVar('g_strctParadigm','JuiceDropInterval'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctRewardControllers.m_hPanel,40+30*8, ...
    '% Probe Trial Reward:', 'ProbeTrialRewardProbability', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','ProbeTrialRewardProbability'));
  
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctRewardControllers.m_hPanel,40+30*9, ...
	'Eye Smoothing Kernel:', 'EyeSmoothingKernel', 0, 60, [1, 5], fnTsGetVar('g_strctParadigm','EyeSmoothingKernel'));
  
  
strctControllers.m_hBinaryReward = uicontrol('Parent',strctRewardControllers.m_hPanel,'Style', 'checkbox', 'String', 'Binary Reward','value',...
	g_strctParadigm.m_bBinaryReward,...
    'Position', [5 strctTrainingControllers.m_iPanelHeight-400 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''BinaryReward'');']);
 
strctControllers.m_hEnableEyeSmoothing = uicontrol('Parent',strctRewardControllers.m_hPanel,'Style', 'checkbox', 'String', 'Eye Smoothing','value',...
	g_strctParadigm.m_strctEyeSmoothing.m_bEyeSmoothingEnabled,...
    'Position', [5 strctTrainingControllers.m_iPanelHeight-430 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''EnableEyeSmoothing'');']); 

  
set(strctRewardControllers.m_hPanel,'visible','off');



%% Training


strctControllers.m_hTrainingMode = uicontrol('Parent',strctTrainingControllers.m_hPanel,'Style', 'checkbox', 'String', 'Training Mode','value',...
	g_strctParadigm.m_strctTrainingVars.m_bTrainingMode,...
    'Position', [5 strctTrainingControllers.m_iPanelHeight-260 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''TrainingMode'');']);
	
strctControllers.m_hAutoBalance = uicontrol('Parent',strctTrainingControllers.m_hPanel,'Style', 'checkbox', 'String', 'AutoBalance','value',...
	g_strctParadigm.m_strctTrainingVars.m_bAutoBalance,...
    'Position', [5 strctTrainingControllers.m_iPanelHeight-290 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''AutoBalance'');']);
	
	
strctControllers.m_hAutoBalanceJuiceReward = uicontrol('Parent',strctTrainingControllers.m_hPanel,'Style', 'checkbox', 'String', 'Balance Juice','value',...
	g_strctParadigm.m_strctTrainingVars.m_bAutoBalanceJuiceReward,...
    'Position', [5 strctTrainingControllers.m_iPanelHeight-320 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''AutoBalanceJuiceReward'');']);
	
strctControllers.m_hEyeDriftCorrection = uicontrol('Parent',strctTrainingControllers.m_hPanel,'Style', 'checkbox', 'String', 'Eye Drift Correction','value',...
	g_strctParadigm.m_strctTrainingVars.m_bCorrectEyeDrift,...
    'Position', [5 strctTrainingControllers.m_iPanelHeight-350 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''EyeDriftCorrection'');']);
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*1, ...
    'Trials in buffer:', 'TrialsInBuffer', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','TrialsInBuffer'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*2, ...
    'Trials to use:', 'TrialsToUseForWeighting', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','TrialsToUseForWeighting'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*3, ...
    'Trials weighting limits:', 'TrialWeightingLimits', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','TrialWeightingLimits'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*4, ...
    'Eye Drift Correction Rate:', 'EyeDriftCorrectionRate', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','EyeDriftCorrectionRate'));	
	

	%g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialsInCircularBuffer
	
%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*5, ...
 %   'Weight Buffer', 'RollingBufferTrialsToUseForTrialWeights', 0, 200, [1, 5], fnTsGetVar(g_strctParadigm,'RollingBufferTrialsToUseForTrialWeights'));
	
	
	
	%{
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*1, ...
    'Cue display (ms):', 'CuePeriodMS', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'CuePeriodMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*2, ...
    'Cue Memory (ms):', 'CueMemoryPeriodMS', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'CueMemoryPeriodMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*3, ...
    'Retain Choice (ms):', 'RetainSelectedChoicePeriodMS', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'RetainSelectedChoicePeriodMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctTrainingControllers.m_hPanel,40+30*4, ...
    'Trial Timeout (ms):', 'TrialTimout', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'TrialTimout'));
	%}
	
	
%% Stimuli Panel
iNumButtonsInSubRow = 5;
iSubButtonWidth = strctStimuliControllers.m_iPanelWidth / iNumButtonsInSubRow - 20;
[strctPreCueControllers.m_hPanel, strctPreCueControllers.m_iPanelHeight,strctPreCueControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(strctStimuliControllers.m_hPanel,60,strctStimuliControllers.m_iPanelHeight-5,'PreCue');
	
[strctCueControllers.m_hPanel, strctCueControllers.m_iPanelHeight,strctCueControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(strctStimuliControllers.m_hPanel,60,strctStimuliControllers.m_iPanelHeight-5,'Cue');

[strctMemoryControllers.m_hPanel, strctMemoryControllers.m_iPanelHeight,strctMemoryControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(strctStimuliControllers.m_hPanel,60,strctStimuliControllers.m_iPanelHeight-5,'Memory');
	
[strctChoicesControllers.m_hPanel, strctChoicesControllers.m_iPanelHeight,strctChoicesControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(strctStimuliControllers.m_hPanel,60,strctStimuliControllers.m_iPanelHeight-5,'Choices');
	
[strctPostTrialControllers.m_hPanel, strctPostTrialControllers.m_iPanelHeight,strctPostTrialControllers.m_iPanelWidth] = ...
    fnCreateParadigmSubPanel(strctStimuliControllers.m_hPanel,60,strctStimuliControllers.m_iPanelHeight-5,'Post Trial');

 strctControllers.m_hSetPreCuePanel = uicontrol('Parent',strctStimuliControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'PreCue',...
      'Position', [5 iPanelHeight-140 iSubButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''PreCuePanel'');'],'enable','on');
	  
 strctControllers.m_hSetCuePanel = uicontrol('Parent',strctStimuliControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Cue',...
      'Position', [iSubButtonWidth+10 iPanelHeight-140 iSubButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''CuePanel'');'],'enable','on');
	 
 strctControllers.m_hSetMemoryPanel = uicontrol('Parent',strctStimuliControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Memory',...
      'Position', [2*iSubButtonWidth+20 iPanelHeight-140 iSubButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''MemoryPanel'');'],'enable','on');
	  
strctControllers.m_hSetChoicePanel = uicontrol('Parent',strctStimuliControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Choices',...
      'Position', [3*iSubButtonWidth+30 iPanelHeight-140 iSubButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ChoicesPanel'');'],'enable','on');
	  
strctControllers.m_hSetPostTrialPanel = uicontrol('Parent',strctStimuliControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Post Trial',...
      'Position', [4*iSubButtonWidth+40 iPanelHeight-140 iSubButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''PostTrialPanel'');'],'enable','on');


strctControllers.m_strctStimuliPanel.m_hSubPanels = [strctPreCueControllers.m_hPanel;strctCueControllers.m_hPanel;strctMemoryControllers.m_hPanel;...
				strctChoicesControllers.m_hPanel;strctPostTrialControllers.m_hPanel];

	  
	  
%% PreCue Sub Panel


	
% How big is the fixation spot in pixels
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPreCueControllers.m_hPanel,40+30*1, ...
    'Fixation Spot Size (pix):', 'PreCueFixationSpotPix', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','PreCueFixationSpotPix'));

%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPreCueControllers.m_hPanel,40+30*2, ...
  %  'Fixation Spot Region (pix):', 'PreCueFixationRegion', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'PreCueFixationRegion'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPreCueControllers.m_hPanel,40+30*2, ...
    'Fixation Period (MS):', 'PreCueFixationPeriodMS', 0, 3000, [1, 5], fnTsGetVar('g_strctParadigm','PreCueFixationPeriodMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPreCueControllers.m_hPanel,40+30*3, ...
    'Juice Time (MS):', 'PreCueJuiceTimeMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','PreCueJuiceTimeMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPreCueControllers.m_hPanel,40+30*4, ...
    'Reward probability (%)', 'PreCueRewardProbability', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','PreCueRewardProbability'));
	
strctControllers.m_hSetPreCueReward = uicontrol('Parent',strctPreCueControllers.m_hPanel,'Style', 'checkbox', 'String', 'Reward This Epoch','value',...
	g_strctParadigm.m_bPreCueReward,...
    'Position', [5 strctPreCueControllers.m_iPanelHeight-280 130 80], 'Callback', [g_strctParadigm.m_strCallbacks,'(''PreCueReward'');']);
	
	
	
%% Cue Sub Panel

% How big is the fixation spot in pixels
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*0, ...
    'Fixation Spot radius (pix):', 'CueFixationSpotPix', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','CueFixationSpotPix'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*1, ...
    'Cue Period (MS):', 'CuePeriodMS', 0, 5000, [1, 5], fnTsGetVar('g_strctParadigm','CuePeriodMS'));
	
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*2, ...
    'Cue Size:', 'CueLength', 0, 300, [1, 1], fnTsGetVar('g_strctParadigm','CueLength'));	
%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*3, ...
%    'Cue Width:', 'CueWidth', 0,300 , [1, 1], fnTsGetVar('g_strctParadigm','CueWidth'));
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*4, ...
    'Orientation:', 'CueOrientation', 0, 360, [1, 5], fnTsGetVar('g_strctParadigm','CueOrientation'));	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*5, ...
    'Null trial %:', 'GrayTrialProbability', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','GrayTrialProbability'));	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctCueControllers.m_hPanel,40+30*6, ...
    'Cue Rho Deviation:', 'CueRhoDeviation', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','CueRhoDeviation'));	
	
strctControllers.m_hSetCueHighlight = uicontrol('Parent',strctCueControllers.m_hPanel,'Style', 'checkbox', 'String', 'Highlight Cue','value',...
	g_strctParadigm.m_strctStimuliVars.m_bCueHighlight,...
    'Position', [5 strctCueControllers.m_iPanelHeight-250 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''HighlightCue'');']);

strctControllers.m_hSetShowCue = uicontrol('Parent',strctCueControllers.m_hPanel,'Style', 'checkbox', 'String', 'Display Cue','value',...
	g_strctParadigm.m_strctStimuliVars.m_bDisplayCue,...
    'Position', [5 strctCueControllers.m_iPanelHeight-275 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ShowCue'');']);
	
strctControllers.m_hForceBalanceCuePossibilities = uicontrol('Parent',strctCueControllers.m_hPanel,'Style', 'checkbox', 'String', 'Balance Cue Counts','value',...
	g_strctParadigm.m_bForceBalanceCueProbabilities,...
    'Position', [5 strctCueControllers.m_iPanelHeight-300 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ForceBalanceCuePossibilities'');']);
	
strctControllers.m_hGenerateCueTextures = uicontrol('Parent', strctCueControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Update Stimulus Location',...
  'Position', [5 strctCueControllers.m_iPanelHeight-330 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''UpdateStimulusPosition'');']);
	  
  strctControllers.m_hGenerateCueTextures = uicontrol('Parent', strctCueControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Generate Cue Textures',...
  'Position', [5 strctCueControllers.m_iPanelHeight-360 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''GenerateCues'');']);

strctControllers.hColorListContextMenu = uicontextmenu;

strctControllers.m_hCueColorConversionType = uicontrol('Style', 'listbox', 'String', g_strctParadigm.m_acAvailableColorSpaceNames,...
    'Position', [10 strctCueControllers.m_iPanelHeight-410 strctCueControllers.m_iPanelWidth-15 40], 'parent', strctCueControllers.m_hPanel, 'Callback', [g_strctParadigm.m_strCallbacks, '(''SelectCueColorConversionType'');'],...
    'value', g_strctParadigm.m_strctInitialValues.m_fInitial_ColorConversionID, 'UIContextMenu', strctControllers.hColorListContextMenu, 'max', 1, 'min', 1);
	g_strctParadigm.m_iCurrentColorConversionID = g_strctParadigm.m_strctInitialValues.m_fInitial_ColorConversionID;

[a2cCharMatrix, g_strctParadigm.m_strctMasterColorTableLookup] = fnStructToCharShort(g_strctParadigm.m_strctMasterColorTable{g_strctParadigm.m_iCurrentColorConversionID});
	
strctControllers.m_hCueSaturationLists = uicontrol('Style', 'listbox', 'String', a2cCharMatrix,...
    'Position', [10 strctCueControllers.m_iPanelHeight-515 strctCueControllers.m_iPanelWidth-15 100], 'parent',strctCueControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''SelectCueSaturations'');'],...
    'value',max(1,g_strctParadigm.m_strctInitialValues.m_iInitial_IndexInSaturationList),'UIContextMenu',strctControllers.hColorListContextMenu, 'max', size(a2cCharMatrix,1),'min',0);
	

%colorStr = {'hue 0'; 'hue 22.5';'hue 45';'hue 67.5';'hue 90';'hue 112.5';'hue 135';'hue 157.5';'hue 180';'hue 202.5';'hue 225';'hue 247.5';'hue 270';'hue 292.5';'hue 315';'hue 337.5'};
%colorStr = num2cell([0:360/64:360-(360/64)]');
%colorCell = char(colorStr);
colorCell = num2str([0:360/64:360-(360/64)]');
strctControllers.m_hCueColorLists = uicontrol('Style', 'listbox', 'String', colorCell,...
    'Position', [10 strctCueControllers.m_iPanelHeight-630 ,strctCueControllers.m_iPanelWidth-15 100], 'parent',strctCueControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''SelectCueColors'');'],...
    'value',g_strctParadigm.m_cAllCueColorsPerSat{:},'UIContextMenu',strctControllers.hColorListContextMenu, 'max', 16, 'min', 0);

stimTypes = {'disc','bar'};
stimCell = char(stimTypes);
strctControllers.m_hStimType = uicontrol('Style', 'listbox', 'String', stimCell,...
    'Position', [10 strctCueControllers.m_iPanelHeight-690 ,strctCueControllers.m_iPanelWidth-15 30], 'parent',strctCueControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''SelectStimType'');'],...
    'value',1,'UIContextMenu',strctControllers.hColorListContextMenu, 'max', 1, 'min', 1);

%% Memory Period Sub Panel

%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*1, ...
%    'Memory Period (MS):', 'MemoryPeriodMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryPeriodMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*1, ...
    'Min Memory Period (MS):', 'MemoryPeriodMinMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryPeriodMinMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*2, ...
    'Max Memory Period (MS):', 'MemoryPeriodMaxMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryPeriodMaxMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*3, ...
    'Min Choices Fix Period (MS):', 'MemoryChoicePeriodMinMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryChoicePeriodMinMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*4, ...
    'Max Choices Fix Period (MS):', 'MemoryChoicePeriodMaxMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryChoicePeriodMaxMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*5, ...
    'Memory Fix Size (pix):', 'MemoryPeriodFixationSpotPix', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryPeriodFixationSpotPix'));

	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*7, ...
    'Juice Time (MS):', 'MemoryChoiceJuiceTimeMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryChoiceJuiceTimeMS'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*8, ...
    'Reward probability (%)', 'MemoryChoiceRewardProbability', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','MemoryChoiceRewardProbability'));
	
strctControllers.m_hSetMemoryChoiceReward = uicontrol('Parent',strctMemoryControllers.m_hPanel,'Style', 'checkbox', 'String', 'Reward This Epoch','value',...
	g_strctParadigm.m_bMemoryChoiceReward,...
    'Position', [5 strctPreCueControllers.m_iPanelHeight-400 130 80], 'Callback', [g_strctParadigm.m_strCallbacks,'(''MemoryChoiceReward'');']);
		
	%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*3, ...
 %   'Memory Fix Region (pix):', 'MemoryPeriodFixationRegionPix', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'MemoryPeriodFixationRegionPix'));
	
%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctMemoryControllers.m_hPanel,40+30*4, ...
%    'Juice Reward (ms):', 'MemoryPeriodJuiceTimeMS', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'MemoryPeriodJuiceTimeMS'));
	
	
%strctControllers.m_hSetFixationCueOverride = uicontrol('Parent',strctMemoryControllers.m_hPanel,'Style', 'checkbox', 'String', 'Reward This Epoch','value',...
%	g_strctParadigm.m_bMemoryPeriodReward,...
%    'Position', [5 strctMemoryControllers.m_iPanelHeight-550 130 80], 'Callback', [g_strctParadigm.m_strCallbacks,'(''MemoryPeriodReward'');']);


%% Choices Sub Panel

%{
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*1, ...
    'Choice location weights (LR):', 'ChoiceLocationWeights', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceLocationWeights'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*2, ...
    'Fixation Spot Persist (MS):', 'FixationSpotPersistPeriodMS', 0, 2000, [1, 5], fnTsGetVar('g_strctParadigm','FixationSpotPersistPeriodMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*3, ...
    'Number of Choices:', 'NumberOfChoices', 0, 6, [1, 1], fnTsGetVar('g_strctParadigm','NumberOfChoices'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*4, ...
    'Choice Eccentricity (pix):', 'ChoiceEccentricity', 0, 400, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceEccentricity'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*5, ...
    'Choice Size (pix):', 'ChoiceSize', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceSize'));
	
%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*6, ...
%    'Fixation Spot radius (pix):', 'ChoiceFixationSpotPix', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'ChoiceFixationSpotPix'));

%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*7, ...
 %   'Fixation Spot Region (pix):', 'ChoiceFixationRegion', 0, 100, [1, 5], fnTsGetVar(g_strctParadigm,'ChoiceFixationRegion'));
 		
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*5, ...
    'Choice Ring Saturation:', 'ChoiceRingSaturation', 0, 1, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceRingSaturation'));
		
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*6, ...
    'Choice Ring Elevation:', 'ChoiceRingElevation', -1, 1, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceRingElevation'));
%}	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*0, ...
   'Choice Width:', 'ChoiceWidth', 0, 300, [1, 1], fnTsGetVar('g_strctParadigm','ChoiceWidth'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*1, ...
    'Choice Length:', 'ChoiceLength', 0, 300, [1, 1], fnTsGetVar('g_strctParadigm','ChoiceLength'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*2, ...
    'Inside Choice Region (%):', 'InsideChoiceRegion', 0, 300, [1, 1], fnTsGetVar('g_strctParadigm','InsideChoiceRegion'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*3, ...
    'Hold To Select (MS):', 'HoldToSelectChoiceMS', 0, 2000, [1, 5], fnTsGetVar('g_strctParadigm','HoldToSelectChoiceMS'));
	%{}
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*4, ...
    'Choice Ring Size:', 'ChoiceRingSize', 0, 500, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceRingSize'));
	%}
%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*2, ...
%    'saturation Boundary Multi:', 'SaturationBoundaryWidthMultiplier', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'SaturationBoundaryWidthMultiplier'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*4, ...
    'Choice Luminance Deviation:', 'ChoiceLuminanceDeviation', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceDeviation'));

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*5, ...
    'annulus rho:', 'AnnulusCenterOffset', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'AnnulusCenterOffset'));
	
%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*5, ...
 %   'annulus separation:', 'AnnulusSaturationSeparation', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'AnnulusSaturationSeparation'));	
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*6, ...
'Number of choices:', 'NTargets', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'NTargets'));	
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*7, ...
'% probe trials:', 'ProbeTrialProbability', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'ProbeTrialProbability'));	

%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*8, ...
%'Choice spread', 'ChoiceDistributionSpread', 0, 32, [1, 5], fnTsGetVar('g_strctParadigm', 'ChoiceDistributionSpread'));	

%strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*9, ...
%'% easy trials', 'EasyTrialProbability', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm', 'EasyTrialProbability'));	

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*10, ...
'min Choice Angle', 'minChoiceAngleDeg', 0, 360, [1, 5], fnTsGetVar('g_strctParadigm', 'minChoiceAngleDeg'));	


strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*11, ...
'max Choice Angle', 'maxChoiceAngleDeg', 0, 360, [1, 5], fnTsGetVar('g_strctParadigm', 'maxChoiceAngleDeg'));	


	
		%g_strctParadigm, 'AnnulusCenterOffset'
	%g_strctParadigm 
		%{
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctChoicesControllers.m_hPanel,40+30*4, ...
    'Choice ring N Choices:', 'ChoiceRingChoices', 0, 128, [1, 5], fnTsGetVar('g_strctParadigm','ChoiceRingChoices'));
%}

strctControllers.m_hDirectMatch = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Force direct match cue to choices','value',...
	g_strctParadigm.m_strctStimuliVars.m_bDirectMatchCueChoices,...
    'Position', [5 iPanelHeight-550 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''DirectMatch'');']);
		
strctControllers.m_hSetInvertChoiceRingOnEachTrial = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Random Ring Inversion','value',...
	g_strctParadigm.m_strctChoiceVars.m_bRandomRingOrderInversion,...
   'Position', [5 iPanelHeight-575 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''RandomInvertChoiceRing'');']);
   
strctControllers.m_hSetRotateRingOnEachTrial = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Random Ring Rotation','value',...
	g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial,...
   'Position', [5 iPanelHeight-600 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''RotateChoiceRingOnEachTrial'');']);
   %{
strctControllers.m_hSetInsertGrayBoundaryInChoiceColorRing = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Gray Boundary In color Ring','value',...
	g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors,...
   'Position', [5 iPanelHeight-370 250 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''InsertGrayBoundaryBetweenChoiceColors'');']);
   
strctControllers.m_hSetInsertGrayBoundaryInChoiceSaturationRing = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Gray Boundary in Saturation Ring','value',...
	g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations,...
    'Position', [5 iPanelHeight-400 250 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''InsertGrayBoundaryBetweenChoiceSaturations'');']);
		%}

strctControllers.m_hForceChoiceColorConversionMatchToCueType = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Match Conversion to Cue','value',...
	g_strctParadigm.m_strctChoiceVars.m_bForceChoiceColorConversionMatchToCueType,...
   'Position', [5 iPanelHeight-625 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ForceChoiceColorConversionMatchToCueType'');']);
strctControllers.m_bSortChoiceHues = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Sort Choices by Hue','value',...
	g_strctParadigm.m_strctChoicePeriod.m_bSortChoiceHues,...
   'Position', [5 iPanelHeight-650 250 25], 'Callback', [g_strctParadigm.m_strCallbacks,'(''SortChoiceHues'');']);  
   %{
strctControllers.m_hSetStimulusOverRide = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'OverRide Stimulus Control','value',...
	g_strctParadigm.m_bDynamicStimuli,...
    'Position', [5 iPanelHeight-460 250 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''OverRideStimulusControl'');']);
	%}
strctControllers.m_hAFCChoiceLocation = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Update Choice Location',...
    'Position', [5 iPanelHeight-675 250 25],'callback', [g_strctParadigm.m_strCallbacks,'(''AFCChoiceLocation'');']);

strctControllers.m_hGenerateChoiceTextures = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Generate Choice Textures',...
    'Position', [5 iPanelHeight-705 250 25],'callback', [g_strctParadigm.m_strCallbacks,'(''GenerateChoices'');']);	
	
	
	%{
% Implement automatic or manual choice location probability selection. For training...
strctControllers.m_hSetChoicesLocationsWeightingOverride = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Choice Location Prob Override','value',...
	g_strctParadigm.m_strctChoicesVars.m_bChoicesLocationsWeightingOverride,...
    'Position', [5 iPanelHeight-510 250 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ChoicesLocationsWeightingOverride'');']);
   %}
   %{
strctControllers.m_hChoiceDisplayType = uicontrol('Style', 'listbox', 'String', g_strctParadigm.m_acAvailableChoiceDisplayTypes,...
    'Position', [10 strctChoicesControllers.m_iPanelHeight-570 strctChoicesControllers.m_iPanelWidth-15 60], 'parent', strctChoicesControllers.m_hPanel, 'Callback', [g_strctParadigm.m_strCallbacks, '(''ChoiceDisplayType'');'],...
    'value', g_strctParadigm.m_strctInitialValues.m_fInitial_ChoiceDisplayID, 'UIContextMenu', strctControllers.hColorListContextMenu, 'max', 1, 'min', 1);
   %}
   %dbstop if warning
   %warning('stop')
   
strctControllers.m_hChoiceColorConversionType = uicontrol('Style', 'listbox', 'String', g_strctParadigm.m_acAvailableColorSpaceNames,...
    'Position', [10 strctChoicesControllers.m_iPanelHeight-930 strctChoicesControllers.m_iPanelWidth-15 50], 'parent', strctChoicesControllers.m_hPanel, 'Callback', [g_strctParadigm.m_strCallbacks, '(''ChoiceSelectConversionType'');'],...
    'value', g_strctParadigm.m_strctInitialValues.m_fInitial_ColorConversionID, 'UIContextMenu', strctControllers.hColorListContextMenu, 'max', 1, 'min', 1);
	%}
	%g_strctParadigm.m_iCurrentColorConversionID = g_strctParadigm.m_strctInitialValues.m_fInitial_ColorConversionID;


	
iCurrentColorConversionID = get(strctControllers.m_hCueColorConversionType,'value');
strCurrentColorConversionName = get(strctControllers.m_hCueColorConversionType,'string');
g_strctParadigm.m_strctChoiceVars.m_strChoiceColorConversionType  = deblank(strCurrentColorConversionName{iCurrentColorConversionID,:});
	
[a2cCharMatrix, g_strctParadigm.m_strctMasterColorTableLookup] = fnStructToCharShort(g_strctParadigm.m_strctMasterColorTable{g_strctParadigm.m_iCurrentColorConversionID});
	
strctControllers.m_hChoiceSaturationLists = uicontrol('Style', 'listbox', 'String', a2cCharMatrix,...
    'Position', [10 strctChoicesControllers.m_iPanelHeight-600 strctChoicesControllers.m_iPanelWidth-15 50], 'parent',strctChoicesControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''ChoiceSelectSaturations'');'],...
    'value',g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations,'UIContextMenu',strctControllers.hColorListContextMenu, 'max', size(a2cCharMatrix,1),'min',0);
	

%colorStr = {'hue 0'; 'hue 22.5';'hue 45';'hue 67.5';'hue 90';'hue 112.5';'hue 135';'hue 157.5';'hue 180';'hue 202.5';'hue 225';'hue 247.5';'hue 270';'hue 292.5';'hue 315';'hue 337.5'};
%colorStr = num2cell([0:360/64:360-(360/64)]');
%colorCell = char(colorStr);
colorCell = num2str([0:360/64:360-(360/64)]');
strctControllers.m_hChoiceColorLists = uicontrol('Style', 'listbox', 'String', colorCell,...
    'Position', [10 strctChoicesControllers.m_iPanelHeight-650 ,strctChoicesControllers.m_iPanelWidth-15 75], 'parent',strctChoicesControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''ChoiceSelectColors'');'],...
    'value',g_strctParadigm.m_cAllChoiceColorsPerSat{:},'UIContextMenu',strctControllers.hColorListContextMenu, 'max', 16, 'min', 0);
	

%Quads = char(g_strctParadigm.m_strctChoiceVars.m_QuadrantsSelected);
	%strctControllers.m_hQuadrantsSelected = uicontrol('Style', 'listbox', 'String', Quads,...
    %'Position', [10 strctChoicesControllers.m_iPanelHeight-635 ,strctChoicesControllers.m_iPanelWidth-15 67], 'parent',strctChoicesControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''QuadrantsSelected'');'],...
    %'value',1,'UIContextMenu',strctControllers.hColorListContextMenu, 'max', 4, 'min', 1);
	
%{
stimTypes = {'disc','bar'};
stimCell = char(stimTypes);
strctControllers.m_hStimType = uicontrol('Style', 'listbox', 'String', stimCell,...
    'Position', [10 strctChoicesControllers.m_iPanelHeight-690 ,strctChoicesControllers.m_iPanelWidth-15 30], 'parent',strctChoicesControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''SelectStimType'');'],...
    'value',1,'UIContextMenu',strctControllers.hColorListContextMenu, 'max', 1, 'min', 1);
   
	
g_strctParadigm.ChoicePositionOptions ={'LeftRight';'TopBottom'};%;'Random'};
ChoicePositionList = char(g_strctParadigm.ChoicePositionOptions);
strctControllers.hChoicePositionOptionsContextMenu = uicontextmenu;
strctControllers.m_hChoicePositionOptions = uicontrol('Style', 'listbox', 'String', ChoicePositionList,...
    'Position', [10 strctChoicesControllers.m_iPanelHeight-600 strctChoicesControllers.m_iPanelWidth-15 50],...
	'parent',strctChoicesControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''ChoiceLocation'');'],...
    'value',1,'UIContextMenu',strctControllers.hChoicePositionOptionsContextMenu, 'max', 1,'min',1);
	%}
%strctControllers.m_hSetFixationsSpotDuringChoices = uicontrol('Parent',strctChoicesControllers.m_hPanel,'Style', 'checkbox', 'String', 'Fixation Spot During Choices','value',...
%	g_strctParadigm.m_strctChoiceVars.m_bShowFixationSpot,...
 %   'Position', [5 iPanelHeight-600 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ChoiceFixationSpot'');']);
	

	


	
%% Post-Trial Sub Panel

strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*1, ...
    'Retain Choice (ms):', 'RetainSelectedChoicePeriodMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','RetainSelectedChoicePeriodMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*2, ...
    'ITI Min (ms):', 'InterTrialIntervalMinMS', 0, 5000, [1, 5], fnTsGetVar('g_strctParadigm','InterTrialIntervalMinMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*3, ...
    'ITI Max (ms):', 'InterTrialIntervalMaxMS', 0, 5000, [1, 5], fnTsGetVar('g_strctParadigm','InterTrialIntervalMaxMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*4, ...
    'Wrong Trial Punish (ms):', 'IncorrectTrialPunishmentDelayMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','IncorrectTrialPunishmentDelayMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*5, ...
    'Abort Trial Punish (ms):', 'AbortedTrialPunishmentDelayMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','AbortedTrialPunishmentDelayMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*6, ...
    'Trial Timeout (ms):', 'TrialTimeoutMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','TrialTimeoutMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*7, ...
    'Fixation Spot radius (pix):', 'PostTrialFixationSpotPix', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','PostTrialFixationSpotPix'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers, strctPostTrialControllers.m_hPanel,40+30*8, ...
    'ITI Juice (ms):', 'PostTrialJuiceTimeMS', 0, 100, [1, 5], fnTsGetVar('g_strctParadigm','PostTrialJuiceTimeMS'));
	
strctControllers.m_hSetExtinguishNonSelectedChoices = uicontrol('Parent',strctPostTrialControllers.m_hPanel,'Style', 'checkbox', 'String', 'Extinguish Non Selected Choice','value',...
	g_strctParadigm.m_strctPostTrialVars.m_bExtinguishNonSelectedChoicesAfterChoice,...
    'Position', [5 iPanelHeight-800 130 80], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ExtinguishNonSelectedChoicesAfterChoice'');']);

	

	
	set(strctControllers.m_strctStimuliPanel.m_hSubPanels(1:end),'visible','off');
%{	
= [strctPreCueControllers.m_hPanel;strctCueControllers.m_hPanel;strctMemoryControllers.m_hPanel;...
				strctChoicesControllers.m_hPanel;strctPostTrialControllers.m_hPanel];
set(strctTrainingControllers.m_hPanel,'visible','off');
set(strctTrainingControllers.m_hPanel,'visible','off');
set(strctTrainingControllers.m_hPanel,'visible','off');
set(strctTrainingControllers.m_hPanel,'visible','off');
set(strctTrainingControllers.m_hPanel,'visible','off');
	%}
%% Microstim

strctControllers.m_hSetMicroStimActive = uicontrol('Parent',strctMicroStimControllers.m_hPanel,'Style', 'checkbox', 'String', 'MicroStim Active','value',...
	g_strctParadigm.MicroStimActive.Buffer(g_strctParadigm.MicroStimActive.BufferIdx),...
    'Position', [5 iPanelHeight-190 130 80], 'Callback', [g_strctParadigm.m_strCallbacks,'(''MicroStimActive'');']);
	
strctControllers.m_hSetBipolarStimulationActive = uicontrol('Parent',strctMicroStimControllers.m_hPanel,'Style', 'checkbox', 'String', 'BiPolar Stimulation Active','value',...
	g_strctParadigm.MicroStimBiPolar.Buffer(g_strctParadigm.MicroStimBiPolar.BufferIdx),...
    'Position', [5 iPanelHeight-240 130 80], 'Callback', [g_strctParadigm.m_strCallbacks,'(''MicroStimBiPolar'');']);
%strctMicroStimControllers.m_hMicroStimActive = uicontrol('Parent',strctMicroStimControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Microstim active',...
%    'Position', [5 iPanelHeight-140 130 30],'callback', [g_strctParadigm.m_strCallbacks,'(''MicroStimActive'');']);

%strctMicroStimControllers.m_hMicroStimBiPolar = uicontrol('Parent',strctMicroStimControllers.m_hPanel,'Style', 'pushbutton', 'String', 'BiPolar stimulation',...
   % 'Position', [5 iPanelHeight-180 130 30],'callback', [g_strctParadigm.m_strCallbacks,'(''MicroStimBiPolar'');']);
	
	%{
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*3, ...
    'Amplitude', 'MicroStimAmplitude', 0, 359, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimAmplitude'));
	%}
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*3, ...
    'Delay (MS)', 'MicroStimDelayMS', 0, 359, [1, 1000], fnTsGetVar('g_strctParadigm' ,'MicroStimDelayMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*4, ...
    'Pulse Width', 'MicroStimPulseWidthMS', 0, 1000, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimPulseWidthMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*5, ...
    'Pulse Width 2', 'MicroStimSecondPulseWidthMS', 0, 1000, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimSecondPulseWidthMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*6, ...
    'IPI Delay', 'MicroStimBipolarDelayMS', 0, 1000, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimBipolarDelayMS'));
	
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*7, ...
    'Pulse Rate', 'MicroStimPulseRateHz', 0, 359, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimPulseRateHz'));
	%{
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*9, ...
    'Train Rate', 'MicroStimTrainRateHz', 0, 359, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimTrainRateHz'));
	%}
strctControllers = fnAddTextSliderEditComboSmallWithCallback2(strctControllers,strctMicroStimControllers.m_hPanel, 40+40*8, ...
    'Train Duration', 'MicroStimTrainDurationMS', 0, 359, [1, 2], fnTsGetVar('g_strctParadigm' ,'MicroStimTrainDurationMS'));

	
	
g_strctParadigm.m_cEpochSelectList=	{'preCue';'Cue';'Memory';'Choice'};
 contextManuList= char(g_strctParadigm.m_cEpochSelectList);
strctControllers.hMicroStimEpochSelectContextMenu = uicontextmenu;
strctControllers.m_hMicroStimEpochOptions = uicontrol('Style', 'listbox', 'String', contextManuList,...
    'Position', [10 strctMicroStimControllers.m_iPanelHeight-600 strctMicroStimControllers.m_iPanelWidth-15 50],...
	'parent',strctMicroStimControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''MicroStimEpochSelect'');'],...
    'value',1,'UIContextMenu',strctControllers.hMicroStimEpochSelectContextMenu, 'max', 1,'min',0);
%% Stat


strctStatControllers.m_hClearStat = uicontrol('Parent',strctStatControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Clear All Stat',...
    'Position', [5 iPanelHeight-140 130 30],'callback', [g_strctParadigm.m_strCallbacks,'(''ResetAllDesignsStat'');']);
	
strctStatControllers.m_hClearCurrentStat = uicontrol('Parent',strctStatControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Clear Current Stat',...
    'Position', [140 iPanelHeight-140 130 30],'callback', [g_strctParadigm.m_strCallbacks,'(''ResetDesignStat'');']);

strctStatControllers.m_hPercentCheckBox = uicontrol('Parent',strctStatControllers.m_hPanel,'Style', 'checkbox', 'String', 'Stat in %',...
    'Position', [5 iPanelHeight-160 130 20],'value',0,'callback', [g_strctParadigm.m_strCallbacks,'(''ReplotStat'');']);

strctStatControllers.m_hStatTable = uitable('ColumnName',{'Trial Name','Correct','Incorrect','Aborted','Timeout'},...
    'parent',strctStatControllers.m_hPanel,'position',[5 iPanelHeight-470 iPanelWidth-20 300]);

afDefaultColor = get(strctStatControllers.m_hClearCurrentStat,'BackgroundColor');
  strctStatControllers.m_hStatText = uicontrol('Parent',strctStatControllers.m_hPanel,'Style', 'text', 'String', '',...
      'Position', [5 iPanelHeight-680 iPanelWidth-20 200],'BackgroundColor',afDefaultColor*0.9,'HorizontalAlignment','left');

%% Design   
  strctDesignControllers.m_hLoadDesign = uicontrol('Parent',strctDesignControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Load Design',...
      'Position', [5 iPanelHeight-140 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''LoadDesign'');']);

  strctDesignControllers.m_hLoadDesign = uicontrol('Parent',strctDesignControllers.m_hPanel,'Style', 'pushbutton', 'String', 'Edit Design',...
      'Position', [150 iPanelHeight-140 130 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''EditDesign'');']);
  

strctDesignControllers.m_hTrialBlocksTable = uitable('parent',strctDesignControllers.m_hPanel,...
            'position',[10 iPanelHeight-440 strctDesignControllers.m_iPanelWidth-15  150],'ColumnName',{'Block Name','Trial Types','#Trials'},'ColumnEditable',[false true true],...
            'CellEditCallback',@fnModifyBlockOrder,'CellSelectionCallback',@fnSelectBlockOrder);

 strctDesignControllers.m_hDeleteBlock = uicontrol('Parent',strctDesignControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Delete Block(s)',...
      'Position', [5 iPanelHeight-285 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''DeleteBlockFromDesign'');'],'enable','off');
  
 strctDesignControllers.m_hAddBlock = uicontrol('Parent',strctDesignControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Add Block',...
      'Position', [iButtonWidth+15 iPanelHeight-285 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''AddBlockToDesign'');'],'enable','off');

   strctDesignControllers.m_hJumpToBlock = uicontrol('Parent',strctDesignControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Jump to Block',...
      'Position', [2*iButtonWidth+25 iPanelHeight-285 iButtonWidth 30], 'Callback', [g_strctParadigm.m_strCallbacks,'(''JumpToBlock'');']);

strctDesignControllers.m_hTrialTypeList = uicontrol('Style', 'listbox', 'String', '','enable','off',...
    'Position', [10 iPanelHeight-550 strctDesignControllers.m_iPanelWidth-15  100], 'parent',strctDesignControllers.m_hPanel);

strctDesignControllers.m_hResetGlobalVars= uicontrol('Style', 'checkbox', 'String', 'Reset global vars after design reload',...
    'Position', [10 iPanelHeight-580 strctDesignControllers.m_iPanelWidth-15  20], 'parent',strctDesignControllers.m_hPanel,'value',false);
%{
strctDesignControllers.m_hfMRI_Mode= uicontrol('Style', 'checkbox', 'String', 'fMRI Mode',...
    'Position', [10 iPanelHeight-600 strctDesignControllers.m_iPanelWidth-15  20], 'parent',strctDesignControllers.m_hPanel,'value',false, 'Callback', [g_strctParadigm.m_strCallbacks,'(''fMRI_Mode_Toggle'');']);

 strctDesignControllers.m_hAbortRun = uicontrol('Parent',strctDesignControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Abort fMRI Run',...
      'Position', [iButtonWidth+105 iPanelHeight-600 iButtonWidth 20], 'Callback', [g_strctParadigm.m_strCallbacks,'(''Abort_fMRI_Run'');']);

   strctDesignControllers.m_hSimTrig = uicontrol('Parent',strctDesignControllers.m_hPanel, 'Style', 'pushbutton', 'String', 'Simulate Trig',...
      'Position', [iButtonWidth+105 iPanelHeight-625 iButtonWidth 20], 'Callback', [g_strctParadigm.m_strCallbacks,'(''SimulateTrig'');']);

   strctDesignControllers.m_hChangeTRValue = uicontrol('Parent',strctDesignControllers.m_hPanel, 'Style', 'edit', 'String', num2str(fnTsGetVar(g_strctParadigm, 'TR')),...
      'Position', [iButtonWidth+10 iPanelHeight-600 iButtonWidth 20], 'Callback', [g_strctParadigm.m_strCallbacks,'(''ChangeTR'');']);

strctDesignControllers.m_hTotalNumberOfTRs= uicontrol('Style', 'text', 'String', '#TRs in design: NaN',...
    'Position', [10 iPanelHeight-625 100  20], 'parent',strctDesignControllers.m_hPanel,'horizontalalignment','left');
  %}
%%

set(strctTrainingControllers.m_hPanel,'visible','off');
set(strctStimuliControllers.m_hPanel,'visible','off');
set(strctRewardControllers.m_hPanel,'visible','off');
set(strctMicroStimControllers.m_hPanel,'visible','off');
set(strctStatControllers.m_hPanel,'visible','off');


g_strctParadigm.m_strctStimuliControllers = strctStimuliControllers;
g_strctParadigm.m_strctTrainingControllers = strctTrainingControllers;
g_strctParadigm.m_strctRewardControllers = strctRewardControllers;
g_strctParadigm.m_strctDesignControllers = strctDesignControllers;
g_strctParadigm.m_strctMicroStimControllers= strctMicroStimControllers;
g_strctParadigm.m_strctStatControllers= strctStatControllers;


fnLoadFavoriteDesigns();
feval(g_strctParadigm.m_strCallbacks,'ResetAllDesignsStat');

g_strctParadigm.m_strctDesignControllers.m_hFavroiteLists = uicontrol('Style', 'listbox', 'String', fnCellToCharShort(g_strctParadigm.m_acFavroiteLists),...
    'Position', [10 iPanelHeight-250 strctDesignControllers.m_iPanelWidth-15  100], 'parent',strctDesignControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''LoadFavoriteList'');'],...
    'value',max(1,g_strctParadigm.m_iInitialIndexInFavroiteList));


if ~isempty(g_strctParadigm.m_strctDesign)
      fnUpdateForceChoiceDesignTable();
end
  
g_strctParadigm.m_strctControllers = strctControllers;
return;

function fnSelectBlockOrder(a, strctWhatChanged)
global g_strctParadigm
if isempty(g_strctParadigm.m_strctDesign) || ~isfield( strctWhatChanged,'Indices') || isempty(strctWhatChanged.Indices)
    return;
end;

iBlockNumber = strctWhatChanged.Indices(1,1);
g_strctParadigm.m_iSelectedBlockInDesignTable = iBlockNumber;
return;

function fnModifyBlockOrder(a,strctWhatChanged)
global g_strctParadigm
if isempty(g_strctParadigm.m_strctDesign)
    return;
end;

iNumTrialTypes = length(g_strctParadigm.m_strctDesign.m_acTrialTypes);
iBlockNumber = strctWhatChanged.Indices(1,1);
g_strctParadigm.m_iSelectedBlockInDesignTable = iBlockNumber;

if strctWhatChanged.Indices(1,2) == 2
    % Trial type changed. Make sure it is still valid, otherwise, discard
    
    

    % change!
    aiNewTrialTypes = strctWhatChanged.NewData;
    if isempty(aiNewTrialTypes) || min(aiNewTrialTypes) <= 0 || max(aiNewTrialTypes) > iNumTrialTypes || sum(isnan(aiNewTrialTypes))> 0
        a2cData = get(g_strctParadigm.m_strctDesignControllers.m_hTrialBlocksTable,'Data');
        a2cData{iBlockNumber,1} = strctWhatChanged.PreviousData;
        set(g_strctParadigm.m_strctDesignControllers.m_hTrialBlocksTable,'Data',a2cData);
        return;
    end

    % Modify the force choice block order according to existing table (!)
    g_strctParadigm.m_strctDesign.m_strctOrder.m_acTrialTypeIndex{iBlockNumber} = aiNewTrialTypes;
end

if strctWhatChanged.Indices(1,2) == 3
    % Num trials changed
    if isnumeric(strctWhatChanged.NewData)
        iNewNumTrials = strctWhatChanged.NewData;
    else
        iNewNumTrials = str2num(strctWhatChanged.NewData);
    end
    
    if isempty(iNewNumTrials) || ~isreal(iNewNumTrials) || length(iNewNumTrials) > 1 || isnan(iNewNumTrials)
        a2cData = get(g_strctParadigm.m_strctDesignControllers.m_hTrialBlocksTable,'Data');
        a2cData{iBlockNumber,2} = strctWhatChanged.PreviousData;
        set(g_strctParadigm.m_strctDesignControllers.m_hTrialBlocksTable,'Data',a2cData);
        return;
    end
    g_strctParadigm.m_strctDesign.m_strctOrder.m_aiNumTrialsPerBlock(iBlockNumber) = iNewNumTrials;
end
return;




function fnLoadFavoriteDesigns()
global g_strctParadigm g_strctPTB
acFieldNames = fieldnames(g_strctParadigm);
acFavroiteLists = cell(1,0);
iListCounter = 1;
for k=1:length(acFieldNames)
    if strncmpi(acFieldNames{k},'m_strInitial_FavroiteList',25)
        strImageListFileName = getfield(g_strctParadigm,acFieldNames{k});
        if exist(strImageListFileName,'file')
            acFavroiteLists{iListCounter} = strImageListFileName;
            iListCounter = iListCounter + 1;
        end
    end
end
g_strctParadigm.m_bStimulusServerLoadedMedia = false;

if ~isempty(g_strctParadigm.m_strctInitialValues.m_strInitial_DesignFile) && exist(g_strctParadigm.m_strctInitialValues.m_strInitial_DesignFile,'file')
    [strPath,strFile,strExt] = fileparts(g_strctParadigm.m_strctInitialValues.m_strInitial_DesignFile);
    
    g_strctParadigm.m_strctDesign = fnLoadForceChoiceNewDesignFile(g_strctParadigm.m_strctInitialValues.m_strInitial_DesignFile);
    
    if ~isempty(g_strctParadigm.m_strctDesign) % successful load
         fnTsSetVarParadigm('ExperimentDesigns',g_strctParadigm.m_strctDesign);
         
         fnAddTimeStampedVariablesFromDesignToParadigmStructure(g_strctParadigm.m_strctDesign,true);
         
         
         % Send this information to statistics server
         if fnParadigmToStatServerComm('IsConnected')
            fnParadigmToStatServerComm('SendDesign', g_strctParadigm.m_strctDesign.m_strctStatServerDesign);
        end
         
        g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = 0;
         % Instruct stimulus server to load media if not on the fly
         % mode....
         if ~g_strctParadigm.m_strctDesign.m_bLoadOnTheFly 
             if fnParadigmToKofikoComm('IsTouchMode')
                 fnParadigmTouchForceChoiceDrawCycle({'LoadMedia', g_strctParadigm.m_strctDesign.m_astrctMedia});
                 g_strctParadigm.m_bStimulusServerLoadedMedia = true;
             else
                fnParadigmToStimulusServer('LoadMedia', g_strctParadigm.m_strctDesign.m_astrctMedia);  % Load media on stim server
                g_strctParadigm.m_acMedia = fnLoadMedia(g_strctPTB.m_hWindow,g_strctParadigm.m_strctDesign.m_astrctMedia,true); % Load media locally
                g_strctParadigm.m_bStimulusServerLoadedMedia = false;
             end
         else
             g_strctParadigm.m_bStimulusServerLoadedMedia = true;
         end
         
        iInitialIndex = -1;
        for k=1:length(acFavroiteLists)
            if strcmpi(acFavroiteLists{k}, g_strctParadigm.m_strctInitialValues.m_strInitial_DesignFile)
                iInitialIndex = k;
                break;
            end
        end
        if iInitialIndex == -1
            acFavroiteLists = [g_strctParadigm.m_strctInitialValues.m_strInitial_DesignFile,acFavroiteLists];
            iInitialIndex = 1;
        end
    else
        g_strctParadigm.m_strctDesign = [];
        g_strctParadigm.m_acImages = [];
        iInitialIndex = 1;
    end
else
    g_strctParadigm.m_strctDesign = [];
    g_strctParadigm.m_acImages = [];
    iInitialIndex = 1;
end


g_strctParadigm.m_acFavroiteLists = acFavroiteLists;
g_strctParadigm.m_iInitialIndexInFavroiteList = iInitialIndex;

return;