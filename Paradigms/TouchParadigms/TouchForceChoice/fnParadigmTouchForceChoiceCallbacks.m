function fnParadigmTouchForceChoiceCallbacks(strCallback,varargin)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global  g_strctParadigm g_strctStimulusServer g_strctAppConfig g_strctPTB


switch strCallback
	case 'PreAllocateStimuli'
		g_strctParadigm.m_bPreAllocateStimuli = ~g_strctParadigm.m_bPreAllocateStimuli;
	case 'StartingHue'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'minChoiceAngleDeg'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'maxChoiceAngleDeg'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'SortChoiceHues'
		g_strctParadigm.m_strctChoicePeriod.m_bSortChoiceHues = ~g_strctParadigm.m_strctChoicePeriod.m_bSortChoiceHues; 
	case 'ProbeTrialRewardProbability'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'ProbeTrialProbability'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'MemoryChoiceJuiceTimeMS'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'MemoryChoiceRewardProbability'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'MemoryChoiceReward'
		g_strctParadigm.m_bMemoryChoiceReward = ~g_strctParadigm.m_bMemoryChoiceReward; 
	case 'MemoryPeriodMinMS'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'MemoryPeriodMaxMS'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'DirectMatch'
		g_strctParadigm.m_strctStimuliVars.m_bDirectMatchCueChoices = ~g_strctParadigm.m_strctStimuliVars.m_bDirectMatchCueChoices; 
	case 'MemoryChoicePeriodMinMS'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'MemoryChoicePeriodMaxMS'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'NTargets'
		varargout{1} = fnDynamicCallback(strCallback);
		g_strctParadigm.m_bChoiceTexturesInitialized = 0;
	%{
	case 'QuadrantsSelected'
		iQuadrantsSelected= get(g_strctParadigm.m_strctControllers.m_hQuadrantsSelected,'value');
		strQuadrantsSelected = get(g_strctParadigm.m_strctControllers.m_hQuadrantsSelected,'string');
        for n=1:numel(iQuadrantsSelected)
            QuadrantsSelected{n} = deblank(strQuadrantsSelected(n,:));
			c_iQuadrantsSelected{n} = iQuadrantsSelected(n);
			%c_strQuadrantsSelected{n} = char(QuadrantsSelected{iQuadrantsSelected(n)}); % get strings for quadrants selected
        end 
		g_strctParadigm.m_ciQuadrantsSelected = c_iQuadrantsSelected;
		%g_strctParadigm.m_strctChoiceVars.m_cQuadrantsSelected = c_strQuadrantsSelected
	%}	
	case 'RandomInvertChoiceRing'
		g_strctParadigm.m_strctChoiceVars.m_bRandomRingOrderInversion = ~g_strctParadigm.m_strctChoiceVars.m_bRandomRingOrderInversion;
	case 'SelectStimType'
	cuetypes = get(g_strctParadigm.m_strctControllers.m_hStimType,'string');
	g_strctParadigm.m_strCueType = strtrim(cuetypes(get(g_strctParadigm.m_strctControllers.m_hStimType,'value'),:));
	%g_strctParadigm.m_strCueType = get(g_strctParadigm.m_strctControllers.m_hStimType,'value');
		%g_strctParadigm.m_strCueType = 
	case 'EyeDriftCorrection'
		g_strctParadigm.m_strctTrainingVars.m_bCorrectEyeDrift = ~g_strctParadigm.m_strctTrainingVars.m_bCorrectEyeDrift;
	case 'StopRecording'
	case 'StartRecording'
	case 'MicroStimEpochSelect'
		g_strctParadigm.m_strctMicroStim.m_cEpochs = vertcat(cellstr(g_strctParadigm.m_cEpochSelectList{get(g_strctParadigm.m_strctControllers.m_hMicroStimEpochOptions,'value')}));
		%g_strctParadigm.m_strctMicroStim.m_cEpochs
	case 'UpdateStimulusPosition'
		g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
	case 'ChoicesLocationsWeightingOverride'
		g_strctParadigm.m_strctChoiceVars.m_bChoicesLocationsWeightingOverride = ~g_strctParadigm.m_strctChoiceVars.m_bChoicesLocationsWeightingOverride;
	case 'ChoiceFixationSpot'
		g_strctParadigm.m_strctChoiceVars.m_bShowFixationSpot = ~g_strctParadigm.m_strctChoiceVars.m_bShowFixationSpot;
	case 'ShowCue'
		g_strctParadigm.m_strctStimuliVars.m_bDisplayCue = ~g_strctParadigm.m_strctStimuliVars.m_bDisplayCue;
	case 'HighlightCue'
		g_strctParadigm.m_strctStimuliVars.m_bCueHighlight = ~g_strctParadigm.m_strctStimuliVars.m_bCueHighlight;
	case 'HoldToSelectChoiceMS'
		varargout{1} = fnDynamicCallback(strCallback);
	case 'ExtinguishNonSelectedChoicesAfterChoice'
		g_strctParadigm.m_strctPostTrialVars.m_bExtinguishNonSelectedChoicesAfterChoice = ...
					~g_strctParadigm.m_strctPostTrialVars.m_bExtinguishNonSelectedChoicesAfterChoice;
	case 'CueReward'
		g_strctParadigm.m_bCueReward = ~g_strctParadigm.m_bCueReward;
	
	case 'PreCueReward'
		g_strctParadigm.m_bPreCueReward = ~g_strctParadigm.m_bPreCueReward;
	
	case 'PreCueRewardProbability'
		varargout{1} = fnDynamicCallback(strCallback);
	
	case 'TrialTimout'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'ChoiceLocationWeights'
		varargout{1} = fnDynamicCallback(strCallback);
	
	case 'RetainSelectedChoicePeriodMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'InterTrialIntervalSec'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'IncorrectTrialPunishmentDelayMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'AbortedTrialPunishmentDelayMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'TrialTimeoutMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'PostTrialFixationSpotPix'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'CuePeriodMS'
		varargout{1} = fnDynamicCallback(strCallback);
	
	case 'CueMemoryPeriodMS'
		varargout{1} = fnDynamicCallback(strCallback);

	case 'JuiceTimeMS'
		varargout{1} = fnDynamicCallback(strCallback);
	
	case 'JuiceTimeHighMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'BlinkTimeMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'PositiveIncrement'
		varargout{1} = fnDynamicCallback(strCallback);
	
	case 'NumberOfJuiceDrops'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'PreCueJuiceTimeMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'SelectCueColorConversionType'
		g_strctParadigm.m_iCurrentColorConversionID = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'value');
        g_strctParadigm.m_strCurrentConversionType = g_strctParadigm.m_acAvailableColorSpaceNames{g_strctParadigm.m_iCurrentColorConversionID};
        
		%g_strctParadigm.m_iCurrentColorConversionID = get(g_strctParadigm.m_strctControllers.m_hColorConversionType,'value')
		[a2cCharMatrix, g_strctParadigm.m_strctMasterColorTableLookup] = fnStructToCharShort(g_strctParadigm.m_strctMasterColorTable{g_strctParadigm.m_iCurrentColorConversionID});
		set(g_strctParadigm.m_strctControllers.m_hCueSaturationLists ,'string',a2cCharMatrix)
	%{
strctControllers.m_hSaturationLists = uicontrol('Style', 'listbox', 'String', a2cCharMatrix,...
    'Position', [10 strctCueControllers.m_iPanelHeight-540 strctCueControllers.m_iPanelWidth-15 100], 'parent',strctCueControllers.m_hPanel, 'Callback',[g_strctParadigm.m_strCallbacks,'(''SelectSaturations'');'],...
    'value',max(1,g_strctParadigm.m_strctInitialValues.m_iInitial_IndexInSaturationList),'UIContextMenu',strctControllers.hColorListContextMenu, 'max', size(a2cCharMatrix,1),'min',0);
	%}
		
	case 'SelectCueSaturations'
		fnParadigmToKofikoComm('JuiceOff');
		fnParadigmToStimulusServer('AbortTrial');
		fnPauseParadigm();
        g_strctParadigm.m_aiSelectedSaturationsLookup = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'value');
		g_strctParadigm.m_strctCurrentSaturations = {};
		g_strctParadigm.m_strctCurrentSaturationsLookup = {};
     
        for iSaturations = 1:numel(g_strctParadigm.m_aiSelectedSaturationsLookup);
            g_strctParadigm.m_strctCurrentSaturations{iSaturations} = g_strctParadigm.m_strctMasterColorTable{g_strctParadigm.m_iCurrentColorConversionID}...
								.(g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_aiSelectedSaturationsLookup(iSaturations)});
        
			g_strctParadigm.m_cCurrentSaturationsLookup{iSaturations} = ...
							g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_aiSelectedSaturationsLookup(iSaturations)};
		
		end
        g_strctParadigm.m_aiColorsDisplayedCount = zeros(numel(g_strctParadigm.m_aiSelectedSaturationsLookup),numel(get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'value')));
		g_strctParadigm.m_bCueTexturesInitialized = false;
	case 'SelectCueColors'
		fnParadigmToKofikoComm('JuiceOff');
		fnParadigmToStimulusServer('AbortTrial');
		fnPauseParadigm();
        g_strctParadigm.m_strctCurrentColors = get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'value');		
        g_strctParadigm.m_aiColorsDisplayedCount = zeros(numel(get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'value')),numel(get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'value')));
		g_strctParadigm.m_bCueTexturesInitialized = false;

    case 'OverRideStimulusControl'
	
		if ~g_strctParadigm.m_bDynamicStimuli
			% dynamic stimulus is not active, we're turning it on
			
			% Backup the old trial order type
			g_strctParadigm.m_strOldTrialOrderType = g_strctParadigm.m_strctDesign.m_strctOrder.m_strTrialOrderType;
			g_strctParadigm.m_strctDesign.m_strctOrder.m_strTrialOrderType = 'Dynamic';
		else
			% dynamic stimulus active, we're turning it off
            % Don't mind using the slow try here since I'm lazy and it
            % is very rare
            try
                g_strctParadigm.m_strctDesign.m_strctOrder.m_strTrialOrderType = g_strctParadigm.m_strOldTrialOrderType;
            catch
                g_strctParadigm.m_strctDesign.m_strctOrder.m_strTrialOrderType = g_strctParadigm.m_strctDesign.m_strctOrderBackup;
            end    
            g_strctParadigm.m_strOldTrialOrderType = [];
		end
		% Swap the boolean
		g_strctParadigm.m_bDynamicStimuli = ~g_strctParadigm.m_bDynamicStimuli;
		
        
        
	
	case 'ChoiceSize'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'ChoiceEccentricity'	
		varargout{1} = fnDynamicCallback(strCallback);
		
    case 'RestartTrial'
        fnParadigmToKofikoComm('JuiceOff');
        g_strctParadigm.m_iMachineState = 1;
        
         if ~fnParadigmToKofikoComm('IsTouchMode')
            fnParadigmToStimulusServer('AbortTrial');
         else
            fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial'});
         end
		 
    case 'EditDesign'
        fnParadigmToKofikoComm('JuiceOff');
        if ~fnParadigmToKofikoComm('IsTouchMode')
            fnParadigmToStimulusServer('AbortTrial');
        else
            fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial'});
        end
        fnHidePTB();
          iSelected = get(g_strctParadigm.m_strctDesignControllers.m_hFavroiteLists,'value');
         eval(['!notepad ',g_strctParadigm.m_acFavroiteLists{iSelected}]);
          fnShowPTB();  
          
         fnLoadDesignAux(g_strctParadigm.m_acFavroiteLists{iSelected});
		 
    case 'Start'
        g_strctParadigm.m_iMachineState = 1;
		
    case 'TrainingPanel'
        set(g_strctParadigm.m_strctControllers.m_hSubPanels([2,3,4,5,6]),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','on');
		
    case 'StimuliPanel'
        set(g_strctParadigm.m_strctControllers.m_hSubPanels([1,3,4,5,6]),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','on');
		
    case 'RewardPanel'
        set(g_strctParadigm.m_strctControllers.m_hSubPanels([1,2,4,5,6]),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','on');
		
    case 'MicrostimPanel'
        set(g_strctParadigm.m_strctControllers.m_hSubPanels([1,2,3,5,6]),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','on');
		
    case 'DesignPanel'
        set(g_strctParadigm.m_strctControllers.m_hSubPanels([1,2,3,4,6]),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','on');
		
    case 'StatPanel'
        set(g_strctParadigm.m_strctControllers.m_hSubPanels([1,2,3,4,5]),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','on');
		
    case 'PreCuePanel'
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels([1:end]), 'visible','off');
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels(1),'visible','on');
		
	case 'CuePanel'
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels([1:end]), 'visible','off');
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels(2),'visible','on');

	case 'MemoryPanel'
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels([1:end]), 'visible','off');
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels(3),'visible','on');		
		
	
	case 'ChoicesPanel'
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels([1:end]), 'visible','off');
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels(4),'visible','on');
		
	case 'PostTrialPanel'
		set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels([1:end]), 'visible','off');
	    set(g_strctParadigm.m_strctControllers.m_strctStimuliPanel.m_hSubPanels(5),'visible','on');
	
	case 'ForceChoiceColorConversionMatchToCueType'
		g_strctParadigm.m_strctChoiceVars.m_bForceChoiceColorConversionMatchToCueType = ~g_strctParadigm.m_strctChoiceVars.m_bForceChoiceColorConversionMatchToCueType;
	
    case 'JumpToBlock'
        fnParadigmToKofikoComm('SafeCallback','JumpToBlockSafe');  
		
    case 'JumpToBlockSafe'
        if g_strctParadigm.m_iSelectedBlockInDesignTable > 0
            
            fnParadigmToStimulusServer('AbortTrial');
            
            aiNumTrials = cumsum(g_strctParadigm.m_strctDesign.m_strctOrder.m_aiNumTrialsPerBlock);
            if g_strctParadigm.m_iSelectedBlockInDesignTable == 1
                g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = 1;
            else
                g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = aiNumTrials(g_strctParadigm.m_iSelectedBlockInDesignTable-1)+1;
            end
            g_strctParadigm.m_bTrialRepetitionOFF = true;
            g_strctParadigm.m_iMachineState = 1;
        end
	case 'EnableEyeSmoothing'
		g_strctParadigm.m_strctEyeSmoothing.m_bEyeSmoothingEnabled = ~g_strctParadigm.m_strctEyeSmoothing.m_bEyeSmoothingEnabled;
	case 'EyeSmoothingKernel'
		varargout{1} = fnDynamicCallback(strCallback);
	    g_strctParadigm.m_strctEyeSmoothing.m_afEyeSmoothingArray = zeros(fnTsGetVar('g_strctParadigm','EyeSmoothingKernel'),2);
		g_strctParadigm.m_strctEyeSmoothing.m_iEyeSmoothingIndex = 1;

  

	
    case 'AddBlockToDesign'
        dbg = 1;
    case 'DeleteBlockFromDesign'
        dbg = 1;
    case 'InterTrialIntervalMinSec'
		varargout{1} = fnDynamicCallback(strCallback);
		
    case 'InterTrialIntervalMaxSec'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MemoryPeriodReward'
		g_strctParadigm.m_bMemoryPeriodReward = ~g_strctParadigm.m_bMemoryPeriodReward;
	
	case 'ChoiceLocation'
		g_strctParadigm.m_strctChoiceVars.m_strChoicePositionType = g_strctParadigm.ChoicePositionOptions{get(g_strctParadigm.m_strctControllers.m_hChoicePositionOptions,'value')};
		g_strctParadigm.m_bChoicePositionTypeUpdated = 1;
		fnParadigmTouchForceChoiceCallbacks('RestartTrial');
	
	case 'AutoBalance'
		g_strctParadigm.m_strctTrainingVars.m_bAutoBalance = ~g_strctParadigm.m_strctTrainingVars.m_bAutoBalance;
		
	case 'RollingBufferTrialsToUseForTrialWeights'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'FixationSpotPix'
	
	
		varargout{1} = fnDynamicCallback(strCallback);
		
    case 'FixationRadiusPix'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'UseFixationAsCue'
		g_strctParadigm.m_bUseFixationSpotAsCue = ~g_strctParadigm.m_bUseFixationSpotAsCue;
	

	
    case 'HitRadius'
		varargout{1} = fnDynamicCallback(strCallback);
		
    case 'ImageHalfSizePix'
        g_strctParadigm.m_iMachineState = 1;
		
    case 'ChoicesHalfSizePix'
        g_strctParadigm.m_iMachineState = 1;
		
    case 'LoadDesign'
        fnParadigmToKofikoComm('SafeCallback','LoadDesignSafe');
		
    case 'LoadFavoriteList'
        fnParadigmToKofikoComm('SafeCallback','SafeLoadFavoriteDesign');
		
    case 'SafeLoadFavoriteDesign'
          iSelected = get(g_strctParadigm.m_strctDesignControllers.m_hFavroiteLists,'value');
          fnLoadDesignAux(g_strctParadigm.m_acFavroiteLists{iSelected});
		  
    case 'LoadDesignSafe'
	
          % This is safe because callback was NOT during a call to
        % draw/cycle/.....
        fnParadigmToKofikoComm('JuiceOff');
	fnParadigmToStimulusServer('AbortTrial');
         % Abort Trial!
         g_strctParadigm.m_iMachineState = 2;
         
         if ~fnParadigmToKofikoComm('IsTouchMode')
            fnParadigmToStatServerComm('AbortTrial');
         else
            fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial'});
         end
        
        fnHidePTB();
        [strFile, strPath] = uigetfile([g_strctParadigm.m_strInitial_DefaultFolder,'*.xml']);
        fnShowPTB()
        if strFile(1) ~= 0
            strNextList = [strPath, strFile];
            fnLoadDesignAux(strNextList);
        end;        
		
	% Microstim Stuff
	
	case 'MicroStimActive'
		bMicroStimActive = ~g_strctParadigm.MicroStimActive.Buffer(g_strctParadigm.MicroStimActive.BufferIdx);
        fnTsSetVarParadigm('MicroStimActive',bMicroStimActive);
		
	case 'MicroStimBiPolar'
		bMicroStimBiPolar = ~g_strctParadigm.MicroStimBiPolar.Buffer(g_strctParadigm.MicroStimBiPolar.BufferIdx);
        fnTsSetVarParadigm('MicroStimBiPolar',bMicroStimBiPolar);


	case 'MicroStimAmplitude'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimDelayMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimPulseWidthMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimSecondPulseWidthMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimBipolarDelayMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimPulseRateHz'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimTrainRateHz'
		varargout{1} = fnDynamicCallback(strCallback);
		
	case 'MicroStimTrainDurationMS'
		varargout{1} = fnDynamicCallback(strCallback);
		
	% end microstim stuff
	
    case 'ToggleExtinguish'
        g_strctParadigm.m_bExtinguishObjectsAfterSaccade = ~g_strctParadigm.m_bExtinguishObjectsAfterSaccade;
    case 'ToggleEmulator'
        g_strctParadigm.m_bEmulatorON = ~g_strctParadigm.m_bEmulatorON;
        fnParadigmToKofikoComm('MouseEmulator',g_strctParadigm.m_bEmulatorON);
        
    case 'NoiseLevel'
        g_strctParadigm.m_strctCurrentTrial.m_fNoiseLevel = fnTsGetVar('g_strctParadigm', 'NoiseLevel');
    case 'StairCaseUp'
    case 'StairCaseDown'
    case 'StairCaseStepPerc'
    case 'LoadNoiseFile'
        fnParadigmToKofikoComm('SafeCallback','SafeLoadNoiseFile');
    case 'SafeLoadNoiseFile'
        fnParadigmToKofikoComm('JuiceOff');
        fnParadigmToStimulusServer('PauseButRecvCommands');
        fnHidePTB();
        [strFile, strPath] = uigetfile([g_strctParadigm.m_strInitial_DefaultFolder,'*.mat']);
        fnShowPTB()
        if strFile(1) ~= 0
            strNoiseFile = [strPath, strFile];
            %fnLoadNoiseFile(strNoiseFile);

            fnTsSetVarParadigm('NoiseFile', strNoiseFile);
            g_strctParadigm.m_strctNoise = load(strNoiseFile);
            g_strctParadigm.m_iNoiseIndex = 1;
        end;
    case 'ResetDesignStat'
        if   isfield(g_strctParadigm,'m_strctDesign') && ~isempty(g_strctParadigm.m_strctDesign) && isfield(g_strctParadigm.m_strctDesign,'m_acTrialTypes')
            iNumTrialTypes = length(g_strctParadigm.m_strctDesign.m_acTrialTypes);
        else
            iNumTrialTypes = 0;    
        end
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect = zeros(1,iNumTrialTypes);
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumIncorrect = zeros(1,iNumTrialTypes);
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTimeout = zeros(1,iNumTrialTypes);
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumAborted = zeros(1,iNumTrialTypes);
        %g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_afResponseTime = zeros(1,iNumTrialTypes);
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTrials = zeros(1,iNumTrialTypes);
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumNullTrials = 0;
        if isfield(g_strctParadigm,'m_strctStatControllers') && isfield(g_strctParadigm.m_strctStatControllers,'m_hStatText')
           set(g_strctParadigm.m_strctStatControllers.m_hStatText,'String',fnPrepareSummaryResults());
        end
    case 'ResetStat'
	
	case 'TrainingMode'
		g_strctParadigm.m_strctTrainingVars.m_bTrainingMode = ~g_strctParadigm.m_strctTrainingVars.m_bTrainingMode;
	
	case 'AutoBalanceJuiceReward'
		g_strctParadigm.m_strctTrainingVars.m_bAutoBalanceJuiceReward = ~g_strctParadigm.m_strctTrainingVars.m_bAutoBalanceJuiceReward;
		
    case 'ResetAllDesignsStat'
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect = 0;
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect = 0;
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTimeout = 0;
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumAborted = 0;
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTrials = 0;
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumNullTrials = 0;
        feval(g_strctParadigm.m_strCallbacks,'ResetDesignStat');
        
        if isfield(g_strctParadigm,'m_strctStatControllers') && isfield(g_strctParadigm.m_strctStatControllers,'m_hStatText')
            set(g_strctParadigm.m_strctStatControllers.m_hStatText,'String',fnPrepareSummaryResults());
        end
		
		% New style
		%{
		g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias = zeros(1,20);
		g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionCorrect = zeros(1,20);
		g_strctParadigm.m_strctStatistics.m_aiAnswerColorBias= zeros(1,16);
		g_strctParadigm.m_strctStatistics.m_iNumCorrect = 0;
		g_strctParadigm.m_strctStatistics.m_iNumIncorrect = 0;
		g_strctParadigm.m_strctStatistics.m_iNumTimeout = 0;
		g_strctParadigm.m_strctStatistics.m_iNumBrokeFixationOrAborted = 0;
		%}
		% Reset the temp stat matrix 
		%g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix = zeros(4,numel(g_strctParadigm.m_cMasterColorTableLookup),16);
	case 'AFCChoiceLocation'
		g_strctParadigm.m_strCurrentlySelectedVariable = strCallback;
			
	case 'ChoiceDisplayType'
		iChoiceDisplayType = get(g_strctParadigm.m_strctControllers.m_hChoiceDisplayType,'value');
		strChoiceDisplayType = get(g_strctParadigm.m_strctControllers.m_hChoiceDisplayType,'string');
		g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType  = deblank(strChoiceDisplayType{iChoiceDisplayType,:});
		
		
	case {'ChoiceRingSize','ChoiceRingChoices' ,'ChoiceRingSaturation','ChoiceRingElevation','InsertGrayBoundaryBetweenChoiceColors','InsertGrayBoundaryBetweenChoiceSaturations','ChoiceSelectConversionType','ChoiceSelectColors','ChoiceSelectSaturations'}
		% if any of these values change the choice ring should be recalculated
		if g_strctParadigm.m_strctChoiceVars.m_bForceChoiceColorConversionMatchToCueType
			g_strctParadigm.m_strctChoiceVars.iChoiceColorConversionType = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'value');
			strChoiceColorConversionType = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'string');
			g_strctParadigm.m_strctChoiceVars.m_strChoiceColorConversionType  = deblank(strChoiceColorConversionType{g_strctParadigm.m_strctChoiceVars.iChoiceColorConversionType,:});
        else
			strChoiceColorConversionType = get(g_strctParadigm.m_strctControllers.m_hChoiceColorConversionType,'string');
            iChoiceColorConversionType = get(g_strctParadigm.m_strctControllers.m_hChoiceColorConversionType,'value');
            g_strctParadigm.m_strctChoiceVars.m_strChoiceColorConversionType = deblank(strChoiceColorConversionType{iChoiceColorConversionType,:});
        end
        
		% check color conversion type
		%g_strctParadigm.m_strctChoiceVars.m_strChoiceColorConversionType = deblank(strChoiceColorConversionType{iChoiceColorConversionType,:});
	
		switch strCallback
            case 'InsertGrayBoundaryBetweenChoiceColors'
			g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors = ~g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors;
            case 'InsertGrayBoundaryBetweenChoiceSaturations'
			g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations = ~g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations;
            case  'ChoiceRingSize'
                g_strctParadigm.m_strCurrentlySelectedVariable = strCallback;
                iNewVal = g_strctParadigm.(strCallback).Buffer(g_strctParadigm.(strCallback).BufferIdx);
                if strcmp(strCallback,'ChoiceRingSize') && (iNewVal > g_strctParadigm.m_iMaxChoiceRingSize || iNewVal < g_strctParadigm.m_iMinChoiceRingSize)
                    if iNewVal > g_strctParadigm.m_iMaxChoiceRingSize
                        iNewVal = g_strctParadigm.m_iMaxChoiceRingSize;
                    elseif iNewVal < g_strctParadigm.m_iMinChoiceRingSize
                        iNewVal = g_strctParadigm.m_iMinChoiceRingSize;
                    end
                end
                fnTsSetVarParadigm(strCallback,iNewVal);
                fnUpdateSlider(g_strctParadigm.m_strctControllers.(['m_h', strCallback, 'Slider']), iNewVal);
                set(g_strctParadigm.m_strctControllers.(['m_h', strCallback,'Edit']), 'String', num2str(iNewVal));
                varargout{1} = iNewVal;
		end
       g_strctParadigm.m_bChoiceTexturesInitialized = false;

	case 'GenerateCues'
        fnPauseParadigm();
		%dbstop if warning
		%warning('stop')
        
		% use the same number of luminance steps for the cue as for the choice
		%numInitialChoices = numel(g_strctParadigm.m_afInitial_SelectedChoiceColors) * numel(g_strctParadigm.m_afInitial_SelectedChoiceSaturations);
				numInitialCues = 19; % hard-coded for 19-stimulus triangular tessalation
		%		numInitialCues = numel(get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'value')) * ...
		%                            numel(get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'value'));
				numLuminanceStepsPerCue = floor(253 / (numInitialCues + 1));

		if rem(numLuminanceStepsPerCue,2) == 0
			numLuminanceStepsPerCue = numLuminanceStepsPerCue - 1;
		end
		stimulusTypeStr = get(g_strctParadigm.m_strctControllers.m_hStimType, 'String');
		stimulusTypeID = get(g_strctParadigm.m_strctControllers.m_hStimType, 'Value');
		%satString = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'String');
		%activeSaturationsID = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'Value');
		colorConversionID = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'Value');
		%colorValuesStr = get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'String');
		%colorValuesID = get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'Value');
		cueTypeValue = get(g_strctParadigm.m_strctControllers.m_hStimType,'Value');
		cueTypeString = get(g_strctParadigm.m_strctControllers.m_hStimType,'String');
		cueDisplayType = cueTypeString(cueTypeValue,:);
		%g_strctParadigm.m_cAllCueColorsPerSat = {colorValuesID};
		stimulusTypeToPrepare = deblank(stimulusTypeStr(stimulusTypeID,:));

		fnParadigmToStimulusServer('ForceMessage', 'PrepareCueTextures', stimulusTypeToPrepare,...
													fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'), 1,...
													[fnTsGetVar('g_strctParadigm', 'CueLength'),fnTsGetVar('g_strctParadigm', 'CueLength')], ...
													numLuminanceStepsPerCue, ...
													g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'CueLuminanceNoiseBlockSize'));% ,g_strctParadigm.m_cAllCueColorsPerSat);  
												


		activeSaturationsID = 1:4;
		satString = g_strctParadigm.m_strChromaLookupLUV;
		for i = 1:numel(activeSaturationsID)
			activeSaturationsStr{i} = deblank(satString{activeSaturationsID(i)});
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
		[~, controlComputerColors] = fnCalculateColorsForChoiceAFCDisplay(activeSaturationsID,...
																							activeSaturationsStr, ...
																							colorConversionID, ...
																							fnTsGetVar('g_strctParadigm', 'CueLuminanceDeviation'), ...
																							numLuminanceStepsPerCue);

		fnInitializeCueTrainingTextures(stimulusTypeToPrepare, fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'), ...
													numInitialCues, [fnTsGetVar('g_strctParadigm', 'CueLength'),fnTsGetVar('g_strctParadigm', 'CueLength')], ...
													numLuminanceStepsPerCue, g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'CueLuminanceNoiseBlockSize'), ...
													controlComputerColors)
													strctCurrentTrial.m_strctCuePeriod.m_bCueTexturesInitialized = true;
				%{
				% use the same number of luminance steps for the cue as for the choice
				numInitialChoices = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'value')) * ...
									numel(get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value'));
				numLuminanceStepsPerChoice = floor(253 / (numInitialChoices + 1));
				if rem(numLuminanceStepsPerChoice,2) == 0
					numLuminanceStepsPerChoice = numLuminanceStepsPerChoice - 1;
				end
				stimulusTypeStr = get(g_strctParadigm.m_strctControllers.m_hStimType, 'String');
				stimulusTypeValue = get(g_strctParadigm.m_strctControllers.m_hStimType, 'Value');
				stimulusTypeToPrepare = deblank(stimulusTypeStr(stimulusTypeValue,:));
				fnParadigmToStimulusServer('ForceMessage', 'PrepareCueTextures', stimulusTypeToPrepare,...
															fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'), 1,...
															[fnTsGetVar('g_strctParadigm', 'CueLength'),fnTsGetVar('g_strctParadigm', 'CueLength')], ...
															numLuminanceStepsPerChoice, ...
															g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'CueLuminanceNoiseBlockSize'));  

				cueSaturationStr = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'String');
				cueSaturationVal = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'Value');
				cueColorVal = get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'Value');
				
			   % stimulusConversionStr = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType, 'String');
				stimulusConversionValue = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType, 'Value');
				
				%stimulusConversionType = stimulusConversionStr{stimulusConversionValue};
				%cueSaturationsToPrepare = cueSaturationStr{cueSaturationVal};									
				%satString = strsplit(g_strctParadigm.m_strInitial_ChromaLookupLUV);
				for i = 1:numel(cueSaturationVal)
					activeSaturationsStr{i} = deblank(cueSaturationStr(cueSaturationVal(i),:));
				end
				
				[~, controlComputerColors] = fnCalculateColorsForChoiceDisplay(cueSaturationVal,...
													cueColorVal, ...
													activeSaturationsStr, ...
													stimulusConversionValue, ...
													fnTsGetVar('g_strctParadigm', 'CueLuminanceDeviation'), ...
													numLuminanceStepsPerChoice);

				fnInitializeCueTextures(stimulusTypeToPrepare, fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'), ...
															numInitialChoices, [fnTsGetVar('g_strctParadigm', 'CueLength'),fnTsGetVar('g_strctParadigm', 'CueLength')], ...
															numLuminanceStepsPerChoice, g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'CueLuminanceNoiseBlockSize'), ...
															controlComputerColors)
				strctCurrentTrial.m_strctCuePeriod.m_bCueTexturesInitialized = true;
				%}
	
	case 'GenerateChoices'
        fnPauseParadigm();
		stimulusTypeStr = get(g_strctParadigm.m_strctControllers.m_hStimType, 'String');
		stimulusTypeID = get(g_strctParadigm.m_strctControllers.m_hStimType, 'Value');
		%satString = get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'String');
		%activeSaturationsID = get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'Value');
		colorConversionID = get(g_strctParadigm.m_strctControllers.m_hChoiceColorConversionType,'Value');
		%colorValuesStr = get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'String');
		%colorValuesID = get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'Value');
		ChoiceTypeValue = get(g_strctParadigm.m_strctControllers.m_hStimType,'Value');
		ChoiceTypeString = get(g_strctParadigm.m_strctControllers.m_hStimType,'String');
		ChoiceDisplayType = ChoiceTypeString(ChoiceTypeValue,:);
		%g_strctParadigm.m_cAllChoiceColorsPerSat = {colorValuesID};
		stimulusTypeToPrepare = deblank(stimulusTypeStr(stimulusTypeID,:));
		%satString = strsplit(g_strctParadigm.m_strctChoiceVars.m_aiChoiceChromaLookupLUV);
		%for i = 1:numel(g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations)
		%	activeSaturationsStr{i} = deblank(satString{g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations(i)});
		%end
		nTargets = fnTsGetVar('g_strctParadigm','NTargets');    
	    numInitialChoices = nTargets;
		numInitialChoices_local = 19; % hard-coded for 19-stimulus triangular tessalation
%		numInitialChoices_local = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'value')) * ...
%                            numel(get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value'));
        numLuminanceStepsPerChoice = floor(253 / (numInitialChoices + 1));
        % get an odd number of steps so the middle value is always the
        % target
        if rem(numLuminanceStepsPerChoice,2) == 0
            numLuminanceStepsPerChoice = numLuminanceStepsPerChoice - 1;
        end
		
		% numLuminanceStepsPerChoice = floor(253 / (numInitialChoices + 1))
		
		activeSaturationsID = 1:4;
		satString = g_strctParadigm.m_strChromaLookupLUV;
		for i = 1:numel(activeSaturationsID)
			activeSaturationsStr{i} = deblank(satString{activeSaturationsID(i)});
		end
	
		fnParadigmToStimulusServer('ForceMessage', 'PrepareChoiceTextures', g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType,...
										fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'), numInitialChoices,...
										[fnTsGetVar('g_strctParadigm', 'ChoiceLength'),fnTsGetVar('g_strctParadigm', 'ChoiceWidth')], ...
										numLuminanceStepsPerChoice, ...
										g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceNoiseBlockSize'));
		

	
		[~, controlComputerColors] = fnCalculateColorsForChoiceAFCDisplay(g_strctParadigm.m_strctChoiceVars.m_aiSelectedChoiceSaturations, ...
										activeSaturationsStr, ...
										g_strctParadigm.m_strctChoiceVars.m_iInitialChoiceColorConversionType, ...
										fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceDeviation'),...
										numLuminanceStepsPerChoice);
		%{
        [~, controlComputerColors] = fnCalculateColorsForChoiceDisplay(aiAllSaturations,...
                                                                                    activeSaturationsStr, ...
                                                                                    g_strctParadigm.m_fInitial_SelectedCueConversionID, ...
																					fnTsGetVar('g_strctParadigm', 'CueLuminanceDeviation'), ...
                                                                                    numLuminanceStepsPerChoice,...
                                                                                    g_strctParadigm.m_cAllColorsPerSat);
                                    %}
                                    
		fnInitializeChoiceTrainingTextures(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'), ...
                                            numInitialChoices_local, [fnTsGetVar('g_strctParadigm', 'ChoiceLength'),fnTsGetVar('g_strctParadigm', 'ChoiceWidth')], ...
                                            numLuminanceStepsPerChoice, g_strctParadigm.CLUTOffset, fnTsGetVar('g_strctParadigm', 'ChoiceLuminanceNoiseBlockSize'), ...
											controlComputerColors)
		
																					
	if isfield(g_strctParadigm, 'ahChoiceTexture') %&& exist('g_strctParadigm.ahChoiceTexture')
		Screen('Close',g_strctParadigm.ahChoiceTexture)
        clear g_strctParadigm.ahChoiceTexture
	end
		[g_strctParadigm.m_strctChoiceVars.m_aiChoiceRGB, g_strctParadigm.m_strctChoiceVars.m_aiRGBInd, ...
             g_strctParadigm.m_strctChoiceVars.m_iClutIndices] = fnCreateNestedChoiceCircleAFC();
			 %dbstop if warning
			%warning('stop')
		fnParadigmToStimulusServer('ForceMessage', 'PrepareChoiceTexture', g_strctParadigm.m_strctChoiceVars.m_aiRGBInd);
		g_strctParadigm.ahChoiceTexture = Screen('MakeTexture', g_strctPTB.m_hWindow,  g_strctParadigm.m_strctChoiceVars.m_aiChoiceRGB);

		Screen('PreloadTextures', g_strctPTB.m_hWindow);
	%case {}
	%dbstop if warning
	%warning('stop')
    
	%get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value')
	%get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists ,'value')
	
	g_strctParadigm.m_bChoiceTexturesInitialized = true;
	
	case 'RotateChoiceRingOnEachTrial'
		g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial = ~g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial;
		
	
		
    case 'TrialOutcome'
        strctCurrentTrial = varargin{1};
        acOutcomes = lower(fnSplitString( strctCurrentTrial.m_strctTrialOutcome.m_strResult));
        
		if strctCurrentTrial.m_strctTrialParams.m_iTrialType == 0
            g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumNullTrials =  g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumNullTrials + 1;
        else
            g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTrials(strctCurrentTrial.m_strctTrialParams.m_iTrialType) = g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTrials(strctCurrentTrial.m_strctTrialParams.m_iTrialType) + 1;
        end
        g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTrials = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTrials + 1;
        bCorrect = ismember('correct',acOutcomes);
        bIncorrect = ismember('incorrect',acOutcomes);
        bAborted = ismember('aborted',acOutcomes);
        bTimeout = ismember('timeout',acOutcomes); 
		
		% shortcut implementation of positive juice increment which bypasses stats server
		
		if bCorrect
			g_strctParadigm.m_iPositiveJuiceIncrement = g_strctParadigm.m_iPositiveJuiceIncrement + 1;
		else
			g_strctParadigm.m_iPositiveJuiceIncrement = 0;
		end
		
		% Counter for number of trials
		if g_strctParadigm.m_bPreAllocateStimuli
			g_strctParadigm.m_iTrialNumber = g_strctParadigm.m_iTrialNumber + 1;
			if g_strctParadigm.m_iTrialNumber > g_strctParadigm.m_iSessionLength
				fnPauseParadigm(); 
			end
		end
		
		%{
		if bCorrect
				
				% increase the juice increment% Juice increment
				g_strctParadigm.m_iPositiveJuiceIncrement = g_strctParadigm.m_iPositiveJuiceIncrement + 1;
		
                g_strctParadigm.m_strctStatistics.m_iNumCorrect = g_strctParadigm.m_strctStatistics.m_iNumCorrect + 1;
				g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(1,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(1,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;								
				
				%g_strctParadigm.m_strctStatistics.m_aiRollingTrialBuffer = circshift(g_strctParadigm.m_strctStatistics.m_aiRollingTrialBuffer,
				%g_strctParadigm.m_strctStatistics.m_aiRollingTrialBuffer(1,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
				%								g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ,1) = 1;
				
				g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(1,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(1,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;	

				[choiceDirection] = fnCalculateAnswerDirection();
				g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionCorrect(choiceDirection) = g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionCorrect(choiceDirection) + 1;
						
						
				fnUpdateTrialCircularBuffer(1, choiceDirection, g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex );		
						
        elseif bIncorrect
		
				% Reset the positive juice increment
				g_strctParadigm.m_iPositiveJuiceIncrement = 0;
		
                g_strctParadigm.m_strctStatistics.m_iNumIncorrect = g_strctParadigm.m_strctStatistics.m_iNumIncorrect + 1;
				g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(2,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(2,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;	
												
												
				g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(2,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(2,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;
												
				% Add this trial to the bias indicators
				% Calculate the direction from the fixation point to the selected choice
				% Fixation point to screen North
				[choiceDirection] = fnCalculateAnswerDirection();
				fnUpdateTrialCircularBuffer(2, choiceDirection, g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex );		
				TrialsToUseForWeighting = squeeze(g_strctParadigm.TrialsToUseForWeighting.Buffer(1,:,g_strctParadigm.TrialsToUseForWeighting.BufferIdx));
				
				tempDirectionArray = fnGetDataFromTrialCircularBuffer(g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularDirectionBuffer,...
																	g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularDirectionBufferIDs,...
																	TrialsToUseForWeighting);	
				
				g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias = ...
				sum(sum(tempDirectionArray(2,:,:),2),2);
						
				tempColorArray = fnGetDataFromTrialCircularBuffer(g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularColorBuffer,...
																	g_strctParadigm.m_strctTrainingVars.m_strctTrialBuffer.m_aiTrialCircularColorBufferIDs,...
																	TrialsToUseForWeighting);		
																	
				g_strctParadigm.m_strctStatistics.m_aiAnswerColorBias = ...
					sum(sum(tempColorArray(2,:,strctCurrentTrial.m_strctTrialParams.m_aiColors,:),2),2);
					
                % Probably more complicated than necessary but I'm too
                % tired to fix it now
				%{
				normalizedAnsByDirection(1,:) = squeeze(sum(tempDirectionArray(2,:,:,:),3)./...
							sum(sum(sum(squeeze(sum(tempDirectionArray([1,2],:,:,:),2)),1))));
				normalizedAnsByColor = squeeze(sum(tempColorArray(2,:,:),3)./...
							sum(sum(sum(squeeze(sum(tempColorArray([1,2],:,:),2)),1))));
				%}
				
				normalizedAnsByDirection(1,:) = squeeze(sum(tempDirectionArray(2,:,:,:),3))./...
						max(squeeze(sum(tempDirectionArray(2,:,:,:),3)));
					
				normalizedAnsByColor = squeeze(sum(tempColorArray(2,:,:,:),3))./...
						max(squeeze(sum(tempColorArray(2,:,:,:),3)));
				

				
				%{
				g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias(choiceDirection) = g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias(choiceDirection) + 1;
				
				g_strctParadigm.m_strctStatistics.m_aiAnswerColorBias(g_strctParadigm.m_strctCurrentTrial.m_iIncorrectChoicem_strctTrialParams.m_iColorIndex ) =... 
					g_strctParadigm.m_strctStatistics.m_aiAnswerColorBias(g_strctParadigm.m_strctCurrentTrial.m_iIncorrectChoicem_strctTrialParams.m_iColorIndex ) + 1;
				
				
				
				normalizedAnsByDirection = g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias./ ...
							g_strctParadigm.m_strctStatistics.m_iNumIncorrect;
				normalizedAnsByColor = g_strctParadigm.m_strctStatistics.m_aiAnswerColorBias./...
							g_strctParadigm.m_strctStatistics.m_iNumIncorrect;
				%}
				
				[g_strctParadigm.m_strctStatistics.m_afDirectionPolarPlottingArray(:,1), g_strctParadigm.m_strctStatistics.m_afDirectionPolarPlottingArray(:,2)] = ...
													fnRotateAroundPoint(g_strctParadigm.m_strctStatistics.m_aiDirectionBiasPolarLocation(1),...
													g_strctParadigm.m_strctStatistics.m_aiDirectionBiasPolarLocation(2) - ... % start from the top
													(normalizedAnsByDirection * g_strctParadigm.m_strctStatistics.m_afDirectionPolarRadius) ,...
                                                    g_strctParadigm.m_strctStatistics.m_aiDirectionBiasPolarLocation(1),...
													g_strctParadigm.m_strctStatistics.m_aiDirectionBiasPolarLocation(2),...
													rad2deg(g_strctParadigm.m_strctStatistics.m_afDirectionRotAngle));
													
				[g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray(:,1),...
													g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray(:,2)] = ...
													fnRotateAroundPoint(g_strctParadigm.m_strctStatistics.m_aiColorBiasPolarLocation(1) + ... % Start from the right
													(circshift(normalizedAnsByColor,[0,size(normalizedAnsByColor,2)/2]) * g_strctParadigm.m_strctStatistics.m_afColorPolarRadius),...
													g_strctParadigm.m_strctStatistics.m_aiColorBiasPolarLocation(2),  ...
                                                    g_strctParadigm.m_strctStatistics.m_aiColorBiasPolarLocation(1),...
													g_strctParadigm.m_strctStatistics.m_aiColorBiasPolarLocation(2),...
													rad2deg(g_strctParadigm.m_strctStatistics.m_afColorRotAngle));
													
													
				% Correct for rotation in the wrong direction
				
				%g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray = circshift(g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray,size(g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray,1)/2);
				g_strctParadigm.m_strctStatistics.m_afDirectionPolarPlottingArray = flipud(g_strctParadigm.m_strctStatistics.m_afDirectionPolarPlottingArray);								
													
													
												
        elseif bTimeout
				[choiceDirection] = fnCalculateAnswerDirection(g_strctParadigm.m_strctCurrentTrial,...
								g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_iCorrectAnswerLocation).m_pt2fPosition);
				% Reset the positive juice increment
				g_strctParadigm.m_iPositiveJuiceIncrement = 0;
				
               g_strctParadigm.m_strctStatistics.m_iNumTimeout = g_strctParadigm.m_strctStatistics.m_iNumTimeout + 1;
			   g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(3,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(3,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;
				

				% Temporary Matrix, erased on stat reset
				 g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(3,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(3,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;
				fnUpdateTrialCircularBuffer(3, choiceDirection, g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex );		  
        elseif bAborted
			%[choiceDirection] = fnCalculateAnswerDirection(g_strctParadigm.m_strctCurrentTrial,...
			%					g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_iCorrectAnswerLocation).m_pt2fPosition);
			% Reset the positive juice increment
			g_strctParadigm.m_iPositiveJuiceIncrement = 0;
		
			g_strctParadigm.m_strctStatistics.m_iNumBrokeFixationOrAborted = g_strctParadigm.m_strctStatistics.m_iNumBrokeFixationOrAborted + 1;
			g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(4,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(4,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;
												
												
			
			g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(4,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) = ...
				g_strctParadigm.m_strctStatistics.m_aiTempStatMatrix(4,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex),...
												g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex ) +1 ;									
												
												
			fnUpdateTrialCircularBuffer(4, choiceDirection, g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iColorIndex );	
		end	
			%}
			
		
		



        %Touch Fixation
		%{
        if bCorrect
                g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect(strctCurrentTrial.m_strctTrialParams.m_iTrialType) = g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect(strctCurrentTrial.m_strctTrialParams.m_iTrialType)+1;
                g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect+1;
        elseif bIncorrect
                g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumIncorrect(strctCurrentTrial.m_strctTrialParams.m_iTrialType) = g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumIncorrect(strctCurrentTrial.m_strctTrialParams.m_iTrialType)+1;
                g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect+1;
        elseif bTimeout
                g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTimeout(strctCurrentTrial.m_strctTrialParams.m_iTrialType) = g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTimeout(strctCurrentTrial.m_strctTrialParams.m_iTrialType)+1;
                g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTimeout = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTimeout + 1;
        elseif bAborted
                g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumAborted(strctCurrentTrial.m_strctTrialParams.m_iTrialType) = g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumAborted(strctCurrentTrial.m_strctTrialParams.m_iTrialType)+1;
                g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumAborted = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumAborted + 1;
        end
		%}
			if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
				%fnUpdateDynamicStatsAux();
			else
				%fnUpdateStatAux();
			end
        
	case 'Pausing'
		g_strctParadigm.m_bParadigmActive = 0;
		
	case 'Resuming'
		g_strctParadigm.m_bParadigmActive = 1;
		
    case 'DrawAttentionEvent'
        fnParadigmToStatServerComm('AbortTrial');
         if ~g_strctParadigm.m_bMRI_Mode
            g_strctParadigm.m_iMachineState = 2;
         else
             % Did we start running?
             if g_strctParadigm.m_iTriggerCounter == 0
                g_strctParadigm.m_iMachineState = 200;
             else
                 g_strctParadigm.m_iMachineState = 2;
             end
         end
    case 'fMRI_Mode_Toggle'
        g_strctParadigm.m_bMRI_Mode = get( g_strctParadigm.m_strctDesignControllers.m_hfMRI_Mode,'value');
        if g_strctParadigm.m_bMRI_Mode
            
            % Verify that the design has specified block length in number
            % of TRs....
            
            if ~isfield(g_strctParadigm.m_strctDesign.m_strctOrder,'m_acNumTRsPerBlock')
                fnParadigmToKofikoComm('DisplayMessage', 'Design do not support fMRI');
                set( g_strctParadigm.m_strctDesignControllers.m_hfMRI_Mode,'value',0);
                return;
            end;
            
    
            
            
            fnParadigmToStimulusServer('AbortTrial');
            g_strctParadigm.m_iMachineState = 200;
        else
            fnParadigmToStimulusServer('AbortTrial');
            g_strctParadigm.m_iMachineState = 2;
        end
    case 'ChangeTR'
        fNewTRValue = str2num(get(g_strctParadigm.m_strctDesignControllers.m_hChangeTRValue,'string'));
        if isreal(fNewTRValue) && ~isnan(fNewTRValue)
            fnTsSetVarParadigm( 'TR',fNewTRValue);
            [strctCurrentTrial,strWhatHappened] =  fnParadigmTouchForceChoiceTrainingPrepareTrial();
            if ~isempty(strctCurrentTrial)
                g_strctParadigm.m_strctCurrentTrial = strctCurrentTrial;
            end
            
        else
            fOldTRValue = fnTsGetVar('g_strctParadigm','TR');
            set(g_strctParadigm.mn_strctDesignControllers.m_hChangeTRValue,'string',num2str(fOldTRValue));
        end
    case 'SimulateTrig'
            g_strctParadigm.m_iTriggerCounter = 1;
            g_strctParadigm.m_fFirstTriggerTS = GetSecs();
            fnParadigmToKofikoComm('StartRecording',0);
            % Force abort trial because we start a new fMRI run
            g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = 1;
            g_strctParadigm.m_bTrialRepetitionOFF = true;
            g_strctParadigm.m_iMachineState = 2;
    case 'BinaryReward'
		g_strctParadigm.m_bBinaryReward = ~g_strctParadigm.m_bBinaryReward;
	case 'ForceBalanceCuePossibilities'
		g_strctParadigm.m_bForceBalanceCueProbabilities = ~g_strctParadigm.m_bForceBalanceCueProbabilities;
    case 'Abort_fMRI_Run'
         g_strctParadigm.m_iMachineState = 201;
    case 'ReplotStat'
            fnUpdateStatAux();
    case {'MotionStarted','MotionFinished'}
        fnParadigmToKofikoComm('DisplayMessage', [strCallback,' not handeled']);
    otherwise
		varargout{1} = fnDynamicCallback(strCallback);
        %fnParadigmToKofikoComm('DisplayMessage', [strCallback,' not handeled']);
end;


return;


function fnLoadDesignAux(strNextList)
global g_strctParadigm g_strctPTB
% If not available in the favorite list, add it!

iIndex = -1;
for k=1:length(g_strctParadigm.m_acFavroiteLists)
    if strcmpi(g_strctParadigm.m_acFavroiteLists{k}, strNextList)
        iIndex = k;
        break;
    end
end
if iIndex == -1
    % Not found, add!
    g_strctParadigm.m_acFavroiteLists = [strNextList,g_strctParadigm.m_acFavroiteLists];
    set(g_strctParadigm.m_strctDesignControllers.m_hFavroiteLists,'String',fnCellToCharShort(g_strctParadigm.m_acFavroiteLists),'value',1);
else
    set(g_strctParadigm.m_strctDesignControllers.m_hFavroiteLists,'value',iIndex);
end

if isfield(g_strctParadigm,'m_strctDesign') && ~isempty(g_strctParadigm.m_strctDesign)
    bSameDesignName = strcmp(strNextList,g_strctParadigm.m_strctDesign.m_strDesignFileName);
else
    bSameDesignName = false;
end;
fnParadigmToStimulusServer('AbortTrial');
fnParadigmToKofikoComm('JuiceOff');
fnParadigmToKofikoComm('DisplayMessageNow','Loading XML file');
strctDesign = fnLoadForceChoiceNewDesignFile(strNextList);
if isempty(strctDesign)
    fnParadigmToKofikoComm('DisplayMessage','Failed to parse XML design file');
    % Restore the previous selected design in the list box
    if ~isempty(g_strctParadigm.m_strctDesign)
        iFallbackIndex = find(ismember(g_strctParadigm.m_acFavroiteLists,g_strctParadigm.m_strctDesign.m_strDesignFileName));
        set(g_strctParadigm.m_strctDesignControllers.m_hFavroiteLists,'value',iFallbackIndex);
    end
    return;
end



% Send this information to statistics server
if fnParadigmToStatServerComm('IsConnected')
    fnParadigmToStatServerComm('SendDesign', strctDesign.m_strctStatServerDesign);
end

g_strctParadigm.m_strctDesign = strctDesign;
g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = 0;


feval(g_strctParadigm.m_strCallbacks,'ResetDesignStat');

bResetGlobalVars = get(g_strctParadigm.m_strctDesignControllers.m_hResetGlobalVars,'value');
if ~bSameDesignName
    bResetGlobalVars = true; % Always reset global variables when loading a design with a different name!
end;

fnAddTimeStampedVariablesFromDesignToParadigmStructure(strctDesign,bResetGlobalVars);

fnTsSetVarParadigm('ExperimentDesigns',g_strctParadigm.m_strctDesign);

% Instruct stimulus server to load media if not on the fly
% mode....
if ~g_strctParadigm.m_strctDesign.m_bLoadOnTheFly
    if fnParadigmToKofikoComm('IsTouchMode')
        fnParadigmTouchForceChoiceTrainingDrawCycle({'LoadMedia', g_strctParadigm.m_strctDesign.m_astrctMedia});
        g_strctParadigm.m_bStimulusServerLoadedMedia = true;
    else
        fnParadigmToStimulusServer('LoadMedia', g_strctParadigm.m_strctDesign.m_astrctMedia);
        if ~isempty(g_strctParadigm.m_acMedia)
            fnReleaseMedia(g_strctParadigm.m_acMedia);
        end
        g_strctParadigm.m_acMedia = fnLoadMedia(g_strctPTB.m_hWindow,g_strctParadigm.m_strctDesign.m_astrctMedia,true);
        g_strctParadigm.m_bStimulusServerLoadedMedia = false;
    end
else
    g_strctParadigm.m_bStimulusServerLoadedMedia = true;
end
	fnUpdateForceChoiceDesignTable();
 
 
 %%
    if isfield(g_strctParadigm.m_strctDesign.m_strctOrder,'m_acNumTRsPerBlock')
        % Special operation using Number of TRs per block....
        
        iNumBlocks = length(g_strctParadigm.m_strctDesign.m_strctOrder.m_acNumTRsPerBlock);
        % Parse the number of TRs....
        aiNumTRs = zeros(1,iNumBlocks);
        for k=1:iNumBlocks
            aiNumTRs(k) = fnParseVariable(g_strctParadigm.m_strctDesign.m_strctOrder,'m_acNumTRsPerBlock',0,k);
        end
        fTS_Sec = fnTsGetVar('g_strctParadigm', 'TR') / 1e3;
        g_strctParadigm.m_aiCumulativeTRs = cumsum(aiNumTRs);
        set(g_strctParadigm.m_strctDesignControllers.m_hTotalNumberOfTRs,'String', sprintf('#TRs in design: %d', g_strctParadigm.m_aiCumulativeTRs(end)));
    else
        set(g_strctParadigm.m_strctDesignControllers.m_hTotalNumberOfTRs,'String', sprintf('#TRs in design: NaN'));
    end 
 %%
 
 
if fnParadigmToKofikoComm('IsPaused')
    % Important, otherwise we won't get the message saying data was loaded!
    fnResumeParadigm();
    g_strctParadigm.m_iMachineState = 0;
end    

if g_strctParadigm.m_iMachineState > 0
    g_strctParadigm.m_iMachineState = 1;
end

g_strctParadigm.m_iTrialCounter = 1;
g_strctParadigm.m_iTrialRep = 0;

g_strctParadigm.m_strctCurrentTrial = [];


if isfield(strctDesign.m_strctOrder,'m_acNumTRsPerBlock')
    % Automatically activate fMRI block mode.
    set( g_strctParadigm.m_strctDesignControllers.m_hfMRI_Mode,'value',1);
    fnParadigmTouchForceChoiceCallbacks('fMRI_Mode_Toggle');
end
    
return;


function acResult = fnPrepareSummaryResults()
global g_strctParadigm
iNumTrialsAllDesigns = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTrials;
acResult{1} = 'Global Statistics:';
acResult{2} = sprintf('Num Trials : %d', iNumTrialsAllDesigns);
acResult{3} = sprintf('Num Correct    : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect, g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect/iNumTrialsAllDesigns*100);
acResult{4} = sprintf('Num Incorrect  : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect, g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect/iNumTrialsAllDesigns*100);
acResult{5} = sprintf('Num Timeout    : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTimeout, g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTimeout/iNumTrialsAllDesigns*100);
acResult{6} = sprintf('Num Aborted    : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumAborted, g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumAborted/iNumTrialsAllDesigns*100);
iNumTrials=g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect+g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect;
acResult{7} = sprintf('* No Aborted/Timeout Stats:');
acResult{8} = sprintf('  Correct (%.2f%%)', g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumCorrect/iNumTrials*100);
acResult{9} = sprintf('  Incorrect (%.2f%%)', g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumIncorrect/iNumTrials*100);


return;


function fnUpdateStatAux()
global g_strctParadigm
iNumTrialTypes = length(g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect);
a2cStatTable = cell(iNumTrialTypes,6);
acTrialName = cell(1,iNumTrialTypes);
bPercent = get(g_strctParadigm.m_strctStatControllers.m_hPercentCheckBox,'value')>0;
for k=1:iNumTrialTypes
    acTrialName{k} = g_strctParadigm.m_strctDesign.m_acTrialTypes{k}.TrialParams.Name;
    a2cStatTable{k,1} = acTrialName{k};
    iTotal = g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect(k) + ...
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumIncorrect(k) + ...
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTimeout(k) + ...
        g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumAborted(k);
    
    if bPercent
        a2cStatTable{k,2} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect(k)/iTotal*1e2));
        a2cStatTable{k,3} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumIncorrect(k)/iTotal*1e2));
        a2cStatTable{k,4} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTimeout(k)/iTotal*1e2));
        a2cStatTable{k,5} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumAborted(k)/iTotal*1e2));
        a2cStatTable{k,6} = '100';
    else
        a2cStatTable{k,2} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumCorrect(k));
        a2cStatTable{k,3} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumIncorrect(k));
        a2cStatTable{k,4} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumTimeout(k));
        a2cStatTable{k,5} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_strctCurrentDesign.m_aiNumAborted(k));
        a2cStatTable{k,6} = sprintf('%d',iTotal);
    end
    
    
end
set(g_strctParadigm.m_strctStatControllers.m_hStatTable,'RowName',[],'ColumnName',{'Name','Correct','Incorrect','Timeout','Aborted','Total'},'Data',a2cStatTable,'ColumnWidth',{150 30 30 30 30});
set(g_strctParadigm.m_strctStatControllers.m_hStatText,'String',fnPrepareSummaryResults());
return;



function [varargout] = fnDynamicCallback(strCallback,varargin)
global  g_strctParadigm g_strctStimulusServer  g_strctAppConfig

g_strctParadigm.m_strCurrentlySelectedVariable = strCallback;

iNewVal = g_strctParadigm.(strCallback).Buffer(g_strctParadigm.(strCallback).BufferIdx);
fnTsSetVarParadigm(strCallback,iNewVal);
fnUpdateSlider(g_strctParadigm.m_strctControllers.(['m_h',strCallback,'Slider']), iNewVal);
set(g_strctParadigm.m_strctControllers.(['m_h',strCallback,'Edit']),'String',num2str(iNewVal));
varargout{1} = iNewVal;
return;






function fnUpdateDynamicStatsAux()
global  g_strctParadigm
iNumTrialTypes = numel(g_strctParadigm.m_strctCurrentSaturations);
a2cStatTable = cell(iNumTrialTypes,6);
acTrialName = cell(1,iNumTrialTypes);
bPercent = get(g_strctParadigm.m_strctStatControllers.m_hPercentCheckBox,'value')>0;
for k=1:iNumTrialTypes
    acTrialName{k} = g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_aiSelectedSaturationsLookup(k)};
    a2cStatTable{k,1} = acTrialName{k};
    iTotal = g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(1,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:) + ...
        g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(2,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:) + ...
        g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(3,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:) + ...
        g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(4,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:);
    
    if bPercent
        a2cStatTable{k,2} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(1,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:)/iTotal*1e2));
        a2cStatTable{k,3} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(2,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:)/iTotal*1e2));
        a2cStatTable{k,4} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(3,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:)/iTotal*1e2));
        a2cStatTable{k,5} = sprintf('%d', round(g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(4,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:)/iTotal*1e2));
        a2cStatTable{k,6} = '100';
    else
        a2cStatTable{k,2} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(1,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:));
        a2cStatTable{k,3} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(2,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:));
        a2cStatTable{k,4} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(3,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:));
        a2cStatTable{k,5} = sprintf('%d',g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix(4,g_strctParadigm.m_aiSelectedSaturationsLookup(k),:));
        a2cStatTable{k,6} = sprintf('%d',iTotal);
    end
    
    
end

set(g_strctParadigm.m_strctStatControllers.m_hStatTable,'RowName',[],'ColumnName',{'Name','Correct','Incorrect','Timeout','Aborted','Total'},'Data',a2cStatTable,'ColumnWidth','auto');%,'ColumnWidth',{45 80 80 80 80});
set(g_strctParadigm.m_strctStatControllers.m_hStatText,'String',fnPrepareDynamicTrialSummaryResults());





return;

function acResult = fnPrepareDynamicTrialSummaryResults()
global g_strctParadigm
iNumTrialsAllDesigns = g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTrials;
acResult{1} = 'Global Statistics:';
acResult{2} = sprintf('Num Trials : %d', iNumTrialsAllDesigns);
acResult{3} = sprintf('Num Correct    : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_iNumCorrect, g_strctParadigm.m_strctStatistics.m_iNumCorrect/iNumTrialsAllDesigns*100);
acResult{4} = sprintf('Num Incorrect  : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_iNumIncorrect, g_strctParadigm.m_strctStatistics.m_iNumIncorrect/iNumTrialsAllDesigns*100);
acResult{5} = sprintf('Num Timeout    : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_iNumTimeout, g_strctParadigm.m_strctStatistics.m_iNumTimeout/iNumTrialsAllDesigns*100);
acResult{6} = sprintf('Num Aborted    : %d (%.2f%%)', g_strctParadigm.m_strctStatistics.m_iNumBrokeFixationOrAborted, g_strctParadigm.m_strctStatistics.m_iNumBrokeFixationOrAborted/iNumTrialsAllDesigns*100);
iNumTrials=g_strctParadigm.m_strctStatistics.m_iNumCorrect+g_strctParadigm.m_strctStatistics.m_iNumIncorrect;
acResult{7} = sprintf('* No Aborted/Timeout Stats: (%.2f%%)', (g_strctParadigm.m_strctStatistics.m_iNumBrokeFixationOrAborted + g_strctParadigm.m_strctStatistics.m_iNumTimeout)/iNumTrials*100);
acResult{8} = sprintf('  Correct (%.2f%%)', g_strctParadigm.m_strctStatistics.m_iNumCorrect/iNumTrials*100);
acResult{9} = sprintf('  Incorrect (%.2f%%)', g_strctParadigm.m_strctStatistics.m_iNumIncorrect/iNumTrials*100);


return;