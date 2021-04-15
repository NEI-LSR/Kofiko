function [varargout] =  fnParadigmHandMappingCallbacks(strCallback,varargin)
%
% Copyright (c) 2015 Joshua Fuller-Deets, Massachusetts Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

% Add new case for every new GUI control added
% slider controls do not need their own case, as they are handled by the dynamic
% variable function
% booleans and other non-slider variables need their own case, or Kofiko will crash

global g_strctParadigm g_strctStimulusServer  g_strctGUIParams g_strctCycle g_strctPlexon g_strctPTB g_bRecording g_strctRealTimeStatServer
%{
switch strCallback
case {'StaticBarCurrentVariableModifySpeedHz','StaticBarCurrentVariableModifyRange'}


end
%}

%disp(sprintf('callbacks function called %s', strCallback))

switch strCallback

	case 'CycleToNextMovieList'
	
		numMovieLists = numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths);
		CurrentlySelectedMovieLists = get(g_strctParadigm.m_strctControllers.m_hBlockLists, 'value');
		g_strctParadigm.m_iCurrentlyPlayingMovieListID = g_strctParadigm.m_iCurrentlyPlayingMovieListID + 1;
		if g_strctParadigm.m_iCurrentlyPlayingMovieListID > numel(CurrentlySelectedMovieLists)
			%g_strctParadigm.m_iCurrentlyPlayingMovieListID = CurrentlySelectedMovieLists(1);
			g_strctParadigm.m_iCurrentlyPlayingMovieListID = 1;
		else
		g_strctParadigm.m_iCurrentlyPlayingMovieList = CurrentlySelectedMovieLists(g_strctParadigm.m_iCurrentlyPlayingMovieListID);
        end
        aStrMovieListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
        %aStrMovieListNames(g_strctParadigm.m_iCurrentlyPlayingMovieList)
		strSelectedImageList = deblank(aStrMovieListNames(g_strctParadigm.m_iCurrentlyPlayingMovieList,:));
		if ~g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly
                    
			[g_strctParadigm.m_strctMovieStim.m_ahMovieHandles, g_strctParadigm.m_strctMovieStim.m_acMovieData,...
				g_strctParadigm.m_strctMovieStim.m_abIsMovie, g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
				fnLoadImageSet({'LoadMovieSet'},g_strctParadigm.m_strMovieListDirectoryPath,strSelectedImageList);
		else
			[g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
				fnLoadImageSet({'GetMovieFilePaths'}, g_strctParadigm.m_strMovieListDirectoryPath, strSelectedImageList);
		end
		g_strctParadigm.m_strctMovieStim.m_iDisplayCount = zeros(numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths),1);
				g_strctParadigm.m_strctMovieStim.m_iNumMoviesInThisBlock = numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths);
		%set(g_strctParadigm.m_strctControllers.m_hBlockLists, 'value', g_strctParadigm.m_iCurrentBlockIndexInOrderList)
		%feval(g_strctParadigm.m_strCallbacks,'JumpToBlock')
		fnResumeParadigm();
	%{
		                 %g_strctParadigm.m_iCurrentBlockIndexInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
                g_strctParadigm.m_iCurrentlySelectedBlocksInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
               % g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
                g_strctParadigm.m_iCurrentlyPlayingMovieList = g_strctParadigm.m_iCurrentlySelectedBlocksInOrderList(g_strctParadigm.m_iCurrentlyPlayingMovieListID);
                aStrMovieListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
                %iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
               % strSelectedImageList = deblank(aStrMovieListNames(g_strctParadigm.m_iCurrentBlockIndexInOrderList,:));
                strSelectedImageList = deblank(aStrMovieListNames(g_strctParadigm.m_iCurrentlyPlayingMovieList,:));
                fnParadigmToStimulusServer('ForceMessage','LoadMovieSet', g_strctParadigm.m_strMovieListDirectoryPath,...
                    strSelectedImageList,	g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly);
                if ~g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly
                    
                    [g_strctParadigm.m_strctMovieStim.m_ahMovieHandles, g_strctParadigm.m_strctMovieStim.m_acMovieData,...
                        g_strctParadigm.m_strctMovieStim.m_abIsMovie, g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
                        fnLoadImageSet({'LoadMovieSet'},g_strctParadigm.m_strMovieListDirectoryPath,strSelectedImageList);
                else
                    [g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
                        fnLoadImageSet({'GetMovieFilePaths'}, g_strctParadigm.m_strMovieListDirectoryPath, strSelectedImageList);
                end
				g_strctParadigm.m_strctMovieStim.m_iDisplayCount = zeros(numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths),1);
				g_strctParadigm.m_strctMovieStim.m_iNumMoviesInThisBlock = numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths);
				
				
				
%}
	
	case 'ReverseMovieDisplayOrder'
	
		g_strctParadigm.m_strctMovieStim.m_bReverseOrder = ~g_strctParadigm.m_strctMovieStim.m_bReverseOrder;
	
    case 'LockMovieAspectRatio'
        g_strctParadigm.m_strctMovieStim.m_bLockAspectRatio = ~g_strctParadigm.m_strctMovieStim.m_bLockAspectRatio;
        
        
	case 'ForceMatchImageSizes'
		g_strctParadigm.m_strctMRIStim.m_bForceMatchImageSizes = ~g_strctParadigm.m_strctMRIStim.m_bForceMatchImageSizes;
		
	case 'MatchToMaximumImageSize'
		g_strctParadigm.m_strctMRIStim.m_bMatchToMaximumImageSize = ~g_strctParadigm.m_strctMRIStim.m_bMatchToMaximumImageSize;

	case 'MatchToMinimumImageSize'
		g_strctParadigm.m_strctMRIStim.m_bMatchToMinimumImageSize = ~g_strctParadigm.m_strctMRIStim.m_bMatchToMinimumImageSize;
	
	

    case 'RandomMovieDisplayOrder'
         g_strctParadigm.m_strctMovieStim.m_bRandomOrder =  ~g_strctParadigm.m_strctMovieStim.m_bRandomOrder;
	
	case 'FitDisplayAreaToMovieSize'
		g_strctParadigm.m_strctMovieStim.m_bFitDisplayAreaToMovieSize = ~g_strctParadigm.m_strctMovieStim.m_bFitDisplayAreaToMovieSize;
	
    case 'LoadOnTheFly'
        g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly = ~g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly;
        
    case 'UseCustomImageColors'
        g_strctParadigm.m_strctMRIStim.m_bOverrideImageColors = ~g_strctParadigm.m_strctMRIStim.m_bOverrideImageColors;
        
        
    case 'UseLUVCoordinates'
        
        g_strctParadigm.m_bUseLUVCoordinates = ~g_strctParadigm.m_bUseLUVCoordinates;
        
    case 'LockImageAspectRatio'
        g_strctParadigm.m_strctMRIStim.m_bLockAspectRatio = ~g_strctParadigm.m_strctMRIStim.m_bLockAspectRatio;
        
    case 'ReverseImageDisplayOrder'
        
        g_strctParadigm.m_strctMRIStim.m_bReverseOrder = ~g_strctParadigm.m_strctMRIStim.m_bReverseOrder;
        
        
        
    case 'RandomImageDisplayOrder'
        
        g_strctParadigm.m_strctMRIStim.m_bRandomOrder = ~g_strctParadigm.m_strctMRIStim.m_bRandomOrder;
        
        
        
        
    case 'SetDifferentColorsForDifferentStim'
        g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars = ~g_strctParadigm.m_strct2BarStimParams.m_bDifferentColorsForDifferentBars ;
        
        
    case 'SetRandomTestValue'
        g_strctParadigm.m_bRandomTestValue = ~g_strctParadigm.m_bRandomTestValue;
        
        
    case 'ClearCurrentTestObjects'
        g_strctParadigm.m_acCurrentlyVariableFields = {};
        
    case 'SetCurrentSelectedVariableAsTestObject'
        if ~strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, 'StimulusPosition') && ~strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, 'ColorPicker')
            
            if ~any(strcmp(g_strctParadigm.m_strCurrentlySelectedVariable,g_strctParadigm.m_acCurrentlyVariableFields))
                CurrentVariableIDX = size(g_strctParadigm.m_acCurrentlyVariableFields,1) + 1;
            else
                CurrentVariableIDX = find(strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, g_strctParadigm.m_acCurrentlyVariableFields));
                
            end
            
            CurrentVariableModifyRange = [g_strctParadigm.m_strCurrentlySelectedBlock,'CurrentVariableModifyRange'];
            CurrentVariableModifySpeedHz = [g_strctParadigm.m_strCurrentlySelectedBlock,'CurrentVariableModifySpeedHz'];
            
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,1} = g_strctParadigm.m_strCurrentlySelectedVariable;
            
            % Range in % to modify variable from base
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,2} =...
                squeeze(g_strctParadigm.(CurrentVariableModifyRange).Buffer(1, :, g_strctParadigm.(CurrentVariableModifyRange).BufferIdx))/100;
            
            
            % how many seconds it takes to complete a full cycle
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,3} =...
                squeeze(g_strctParadigm.(CurrentVariableModifySpeedHz).Buffer(1, :, g_strctParadigm.(CurrentVariableModifySpeedHz).BufferIdx))/100;
            
            % last value that the variable held (last trial's value). Init as current variable
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,4} =...
                g_strctParadigm.(g_strctParadigm.m_strCurrentlySelectedVariable).Buffer(1, :, g_strctParadigm.(g_strctParadigm.m_strCurrentlySelectedVariable).BufferIdx);
            
            % direction that the variable is moving (positive or negative from last value)
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,5} = 1;
            
            % original value
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,6} =...
                squeeze(g_strctParadigm.(g_strctParadigm.m_strCurrentlySelectedVariable).Buffer(1,:,g_strctParadigm.(g_strctParadigm.m_strCurrentlySelectedVariable).BufferIdx));
            
            % is this variable chosen randomly or in sequence?
            g_strctParadigm.m_acCurrentlyVariableFields{CurrentVariableIDX,7} = g_strctParadigm.m_bRandomTestValue;
            
            
        end
        
        
    case 'UpdateColorPicker'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'ColorPicker';
        
        
        
    case 'PostTrialPlottingWindow'
        varargout{1} = fnDynamicCallback(strCallback);
        g_strctParadigm.m_strctStatServerComm.m_bUpdatePostTrialWindow = 1;
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        
    case 'PreTrialPlottingWindow'
        varargout{1} = fnDynamicCallback(strCallback);
        g_strctParadigm.m_strctStatServerComm.m_bUpdatePreTrialWindow = 1;
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        
    case 'flushorientationspikebuffer'
        %fnParadigmToStatServerComm('send', 'ClearOrientationBuffer')
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearOrientationBuffer = 1;
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'flushorientationspikebuffer'];
        %fnParadigmToStatServerComm('Send','flushorientationspikebuffer');
        
    case 'flushcolorspikebuffer'
        %fnParadigmToStatServerComm('Send','FlushColorBuffer');
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'flushcolorspikebuffer'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearColorBuffer = 1;
    
	case 'debugstatserver'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bDebugStatServer = 1;
	
	case 'toggleluvpsthplot'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleLUVPsthPlot = 1;
		
	case 'clearluvpsthplot'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearLUVPSTHPlot = 1;	
		
	case 'flushimagespikebuffer'
        %fnParadigmToStatServerComm('Send','FlushColorBuffer');
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'flushcolorspikebuffer'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearImageBuffer = 1;	
		
	case 'printstatfigure'
		 g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bPrintStatFigure = 1;	
		

		
		
    case 'togglepsthplot'
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'togglepsthplot'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bTogglePsthPlot = 1;
        
	case 'togglewidthplot'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleWidthPlot = 1;
		
	 case 'flushwidthspikebuffer'
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearWidthBuffer = 1;	
		
	case 'togglelengthplot'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleLengthPlot = 1;
		
	case 'flushlengthspikebuffer'
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearLengthBuffer = 1;		
		
	case 'togglespeedplot'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleSpeedPlot = 1;
		
	 case 'flushspeedspikebuffer'
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearSpeedBuffer = 1;	
		
	 
			
	case 'toggleimageplot'
		g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleImagePlot = 1;		
		
    case 'toggleorientationpolar'
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'toggleorientationpolar'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleOrientationPolar = 1;
        
    case 'toggleisiplot'
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'toggleisiplot'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bToggleISIPlot = 1;
		
	 case 'flushisispikebuffer'
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearISIBuffer = 1;	
        
		
    case 'togglepositionplot'
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'toggleisiplot'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bTogglePositionPlot = 1;
        
    case 'flushpositionspikebuffer'
        %g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServer,'toggleisiplot'];
        g_strctParadigm.m_strctStatServerComm.m_bUpdateRequested = 1;
        g_strctParadigm.m_strctStatServerComm.m_bClearPositionBuffer = 1;
        
        
        
        
    case 'UseSinePulses'
        g_strctParadigm.m_bUseGaussianPulses = ~g_strctParadigm.m_bUseGaussianPulses;
        
    case 'UseDiscPresetColors'
        g_strctParadigm.m_bUseDiscPresetColors = ~g_strctParadigm.m_bUseDiscPresetColors;
        
    case 'UseGaborPresetColors'
        g_strctParadigm.m_bUseGaborPresetColors = ~g_strctParadigm.m_bUseGaborPresetColors;
        
    case 'UseMovingBarPresetColors'
        g_strctParadigm.m_bUseMovingBarPresetColors = ~g_strctParadigm.m_bUseMovingBarPresetColors;
        
    case 'FlipForegroundBackground'
        g_strctParadigm.m_bFlipForegroundBackground = ~g_strctParadigm.m_bFlipForegroundBackground;
        
    case 'FlipForegroundBackgroundMovingBar'
        g_strctParadigm.m_bFlipForegroundBackgroundMovingBar = ~g_strctParadigm.m_bFlipForegroundBackgroundMovingBar;
        
    case 'PhaseShiftOffset'
        g_strctParadigm.m_bPhaseShiftOffset = ~g_strctParadigm.m_bPhaseShiftOffset;
        
    case 'UsePlainBarPresetColors'
        g_strctParadigm.m_bUsePlainBarPresetColors = ~g_strctParadigm.m_bUsePlainBarPresetColors;
        
        
    case 'ReverseCycleStimulusOrientation'
        g_strctParadigm.m_bReverseCycleStimulusOrientation = ~g_strctParadigm.m_bReverseCycleStimulusOrientation;
        
    case 'CycleStimulusOrientation'
        g_strctParadigm.m_bCycleStimulusOrientation = ~g_strctParadigm.m_bCycleStimulusOrientation;
        
    case 'RandDiscStimulusLocation'
        g_strctParadigm.m_bRandomDiscStimulusPosition = ~g_strctParadigm.m_bRandomDiscStimulusPosition;
        
        
    case 'ResetHandMapper'
        
	case 'ContinueInMovieListWhenComplete'
		g_strctParadigm.m_strctMovieStim.m_bContinueInMovieListWhenComplete = ~g_strctParadigm.m_strctMovieStim.m_bContinueInMovieListWhenComplete;
		
        
    case 'UseCartesianCoordinates'
        g_strctParadigm.m_bUseCartesianCoordinates = ~g_strctParadigm.m_bUseCartesianCoordinates;
        
    case 'InvertPresetColors'
        g_strctParadigm.m_bInvertPresetColors = ~g_strctParadigm.m_bInvertPresetColors;
        
    case 'UseCalibratedColors'
        g_strctParadigm.m_bUseCalibratedColors = ~g_strctParadigm.m_bUseCalibratedColors;
        
    case 'UsePresetColors'
        g_strctParadigm.m_bUsePresetColors = ~g_strctParadigm.m_bUsePresetColors;
        
    case 'ResetTuningPlot'
        g_strctParadigm.m_strctTuningFunctionStats.m_afPolarPlottingHolder{1,end+1} = g_strctPlexon.m_afConditionSpikes;
        g_strctParadigm.m_strctTuningFunctionStats.m_afPolarPlottingHolder{2,end} = GetSecs();
        g_strctParadigm.m_strctTuningFunctionStats.m_afPolarPlottingHolder{3,end} = g_strctParadigm.m_strctCurrentSaturation;
        %fnCreateExperimentBackup(g_strctParadigm, g_strctParadigm.m_strPlexonFileName,iSelectedColorList);
        for i = 1:g_strctParadigm.m_iNumberOfCurrentConditions
            
            g_strctPlexon.m_afConditionSpikes.(['condition',num2str(i)]) = zeros(1,2);
        end
        %g_strctPlexon.m_afPolarPlottingArray = zeros(g_strctParadigm.m_iNumberOfCurrentConditions,2);
    case 'CycleColors'
        g_strctParadigm.m_bCycleColors = ~g_strctParadigm.m_bCycleColors;
        %g_strctParadigm.m_strctCurrentSaturation = g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList});
        
    case 'RealTimeCycleColors'
        g_strctParadigm.m_bRealTimeCycleColors = ~g_strctParadigm.m_bRealTimeCycleColors;
        %g_strctParadigm.m_strctCurrentSaturation = g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList});
        
    case 'ReverseColorOrder'
        g_strctParadigm.m_bReverseColorOrder = ~g_strctParadigm.m_bReverseColorOrder;
        
    case 'RandomColorOrder'
        g_strctParadigm.m_bRandomColor = ~g_strctParadigm.m_bRandomColor;
        
    case 'ReverseOrientationOrder'
        g_strctParadigm.m_bReverseOrientationOrder = ~g_strctParadigm.m_bReverseOrientationOrder;
        
    case 'RandomOrientationOrder'
        g_strctParadigm.m_bRandomOrientation = ~g_strctParadigm.m_bRandomOrientation ;
        
    case 'UseChosenBackgroundColor'
        g_strctParadigm.m_bUseChosenBackgroundColor = ~g_strctParadigm.m_bUseChosenBackgroundColor;
        
    case 'LoadBackgroundColor'
        fnParadigmToKofikoComm('JuiceOff');
        iSelectedBackgroundColor = get(g_strctParadigm.m_strctControllers.m_hBackgroundColors,'value');
        if ~isempty(iSelectedBackgroundColor)
            g_strctParadigm.m_strctCurrentBackgroundColors = [];
            for iSize = 1:size(iSelectedBackgroundColor,2)
                %size([g_strctParadigm.m_strctMasterColorTableLookup{iSelectedColorList}],1)
                g_strctParadigm.m_strctCurrentBackgroundColors(iSize,:) = g_strctParadigm.m_strctMasterColorTable.gray.RGB(iSelectedBackgroundColor(iSize),:);
            end
            %g_strctParadigm.m_strctCurrentBackgroundColors
        end
        
        
    case 'LoadColorList'
        
        fnParadigmToKofikoComm('JuiceOff');
        iSelectedColorList = get(g_strctParadigm.m_strctControllers.m_hColorLists,'value');
        if ~isempty(iSelectedColorList)
            g_strctParadigm.m_strctCurrentSaturation = {};
            g_strctParadigm.m_strctCurrentSaturationLookup = {};
            for iSize = 1:size(iSelectedColorList,2)
                %size([g_strctParadigm.m_strctMasterColorTableLookup{iSelectedColorList}],1)
                g_strctParadigm.m_strctCurrentSaturation{iSize} = ...
                    g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_strctMasterColorTableLookup{iSelectedColorList(iSize)});
                
                g_strctParadigm.m_strctCurrentSaturationLookup{iSize} = ...
                    g_strctParadigm.m_acstrSaturationsLookup{iSelectedColorList(iSize)};
                
            end
		else 
			g_strctParadigm.m_iSelectedColorList = 1;
			g_strctParadigm.m_strctCurrentSaturation = g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList});
			g_strctParadigm.m_strctCurrentSaturationLookup = {g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList}};
			set(g_strctParadigm.m_strctControllers.m_hColorLists,'value', g_strctParadigm.m_iSelectedColorList);
        end
    case 'RandStimulusLocation'
        g_strctParadigm.m_bRandomStimulusPosition = ~g_strctParadigm.m_bRandomStimulusPosition;
        
    case 'RandStimulusOrientation'
        g_strctParadigm.m_bRandomStimulusOrientation = ~g_strctParadigm.m_bRandomStimulusOrientation;
        
    case 'DiscRandStimulusOrientation'
        g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation = ~g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation;
        
    case 'GaborPhase'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'GaborPhase';
        iNewGaborPhase = g_strctParadigm.GaborPhase.Buffer(g_strctParadigm.GaborPhase.BufferIdx);
        fnTsSetVarParadigm('GaborPhase',iNewGaborPhase);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hGaborPhaseSlider, iNewGaborPhase);
        set(g_strctParadigm.m_strctControllers.m_hGaborPhaseEdit,'String',num2str(iNewGaborPhase));
        varargout{1} = iNewGaborPhase;
        
    case 'GaborFreq'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'GaborFreq';
        iNewGaborFreq = g_strctParadigm.GaborFreq.Buffer(g_strctParadigm.GaborFreq.BufferIdx);
        fnTsSetVarParadigm('GaborFreq',iNewGaborFreq);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hGaborFreqSlider, iNewGaborFreq);
        set(g_strctParadigm.m_strctControllers.m_hGaborFreqEdit,'String',num2str(iNewGaborFreq));
        varargout{1} = iNewGaborFreq;
        
    case 'GaborContrast'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'GaborContrast';
        iNewGaborContrast = g_strctParadigm.GaborContrast.Buffer(g_strctParadigm.GaborContrast.BufferIdx);
        fnTsSetVarParadigm('GaborContrast',iNewGaborContrast);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hGaborContrastSlider, iNewGaborContrast);
        set(g_strctParadigm.m_strctControllers.m_hGaborContrastEdit,'String',num2str(iNewGaborContrast));
        varargout{1} = iNewGaborContrast;
        
    case 'GaborSigma'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'GaborSigma';
        iNewGaborSigma = g_strctParadigm.GaborSigma.Buffer(g_strctParadigm.GaborSigma.BufferIdx);
        fnTsSetVarParadigm('GaborSigma',iNewGaborSigma);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hGaborSigmaSlider, iNewGaborSigma);
        set(g_strctParadigm.m_strctControllers.m_hGaborSigmaEdit,'String',num2str(iNewGaborSigma));
        varargout{1} = iNewGaborSigma;
        
    case 'ReversePhaseDirection'
        g_strctParadigm.m_strctGaborParams.m_bReversePhaseDirection = ~g_strctParadigm.m_strctGaborParams.m_bReversePhaseDirection;
        
    case 'Blur'
        g_strctParadigm.m_bBlur = ~g_strctParadigm.m_bBlur;
        
    case 'TogglePolarPlot'
        g_strctParadigm.m_bPolarPlot = ~g_strctParadigm.m_bPolarPlot;
        
    case 'ToggleHeatPlot'
        g_strctParadigm.m_bHeatPlot = ~g_strctParadigm.m_bHeatPlot;
        
    case 'ToggleRasterPlot'
        g_strctParadigm.m_bRasterPlot = ~g_strctParadigm.m_bRasterPlot;
        
    case 'BlurSteps'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BlurSteps';
        iNewStimulusBlurSteps = g_strctParadigm.BlurSteps.Buffer(g_strctParadigm.BlurSteps.BufferIdx);
        fnTsSetVarParadigm('BlurSteps',iNewStimulusBlurSteps);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBlurStepsSlider, iNewStimulusBlurSteps);
        set(g_strctParadigm.m_strctControllers.m_hBlurStepsEdit,'String',num2str(iNewStimulusBlurSteps));
        varargout{1} = iNewStimulusBlurSteps;
        
        
    case 'Length'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'Length';
        iNewStimulusLength = g_strctParadigm.Length.Buffer(g_strctParadigm.Length.BufferIdx);
        fnTsSetVarParadigm('Length',iNewStimulusLength);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hLengthSlider, iNewStimulusLength);
        set(g_strctParadigm.m_strctControllers.m_hLengthEdit,'String',num2str(iNewStimulusLength));
        varargout{1} = iNewStimulusLength;
        
    case 'Width'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'Width';
        iNewStimulusWidth = g_strctParadigm.Width.Buffer(g_strctParadigm.Width.BufferIdx);
        fnTsSetVarParadigm('Width',iNewStimulusWidth);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hWidthSlider, iNewStimulusWidth);
        set(g_strctParadigm.m_strctControllers.m_hWidthEdit,'String',num2str(iNewStimulusWidth));
        varargout{1} = iNewStimulusWidth;
        
    case 'MoveDistance'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'MoveDistance';
        iNewStimulusMoveDistance = g_strctParadigm.MoveDistance.Buffer(g_strctParadigm.MoveDistance.BufferIdx);
        fnTsSetVarParadigm('MoveDistance',iNewStimulusMoveDistance);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hMoveDistanceSlider, iNewStimulusMoveDistance);
        set(g_strctParadigm.m_strctControllers.m_hMoveDistanceEdit,'String',num2str(iNewStimulusMoveDistance));
        varargout{1} = iNewStimulusMoveDistance;
        
    case 'NumberOfBars'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'NumberOfBars';
        iNewNumberOfBars = g_strctParadigm.NumberOfBars.Buffer(g_strctParadigm.NumberOfBars.BufferIdx);
        fnTsSetVarParadigm('NumberOfBars',iNewNumberOfBars);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hNumberOfBarsSlider, iNewNumberOfBars);
        set(g_strctParadigm.m_strctControllers.m_hNumberOfBarsEdit,'String',num2str(iNewNumberOfBars));
        varargout{1} = iNewNumberOfBars;
    case 'Orientation'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'Orientation';
        iNewStimulusOrientation = g_strctParadigm.Orientation.Buffer(g_strctParadigm.Orientation.BufferIdx);
        fnTsSetVarParadigm('Orientation',iNewStimulusOrientation);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hOrientationSlider, iNewStimulusOrientation);
        set(g_strctParadigm.m_strctControllers.m_hOrientationEdit,'String',num2str(iNewStimulusOrientation));
        varargout{1} = iNewStimulusOrientation;
        
    case 'BarRed'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BarRed';
        iNewBarRed = g_strctParadigm.BarRed.Buffer(g_strctParadigm.BarRed.BufferIdx);
        fnTsSetVarParadigm('BarRed',iNewBarRed);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBarRedSlider, iNewBarRed);
        set(g_strctParadigm.m_strctControllers.m_hBarRedEdit,'String',num2str(iNewBarRed));
        varargout{1} = iNewBarRed;
        
    case 'BarGreen'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BarGreen';
        iNewBarGreen = g_strctParadigm.BarGreen.Buffer(g_strctParadigm.BarGreen.BufferIdx);
        fnTsSetVarParadigm('BarGreen',iNewBarGreen);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBarGreenSlider, iNewBarGreen);
        set(g_strctParadigm.m_strctControllers.m_hBarGreenEdit,'String',num2str(iNewBarGreen));
        varargout{1} = iNewBarGreen;
        
    case 'BarBlue'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BarBlue';
        iNewBarBlue = g_strctParadigm.BarBlue.Buffer(g_strctParadigm.BarBlue.BufferIdx);
        fnTsSetVarParadigm('BarBlue',iNewBarBlue);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBarBlueSlider, iNewBarBlue);
        set(g_strctParadigm.m_strctControllers.m_hBarBlueEdit,'String',num2str(iNewBarBlue));
        varargout{1} = iNewBarBlue;
        
    case 'BarPresetColor'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BarPresetColor';
        iNewBarPresetColor = g_strctParadigm.BarPresetColor.Buffer(g_strctParadigm.BarPresetColor.BufferIdx);
        fnTsSetVarParadigm('BarPresetColor',iNewBarPresetColor);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBarBlueSlider, iNewBarPresetColor);
        set(g_strctParadigm.m_strctControllers.m_hBarBlueEdit,'String',num2str(iNewBarPresetColor));
        varargout{1} = iNewBarPresetColor;
        
    case 'BackgroundRed'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BackgroundRed';
        iNewBackgroundRed = g_strctParadigm.BackgroundRed.Buffer(g_strctParadigm.BackgroundRed.BufferIdx);
        fnTsSetVarParadigm('BackgroundRed',iNewBackgroundRed);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBackgroundRedSlider, iNewBackgroundRed);
        set(g_strctParadigm.m_strctControllers.m_hBackgroundRedEdit,'String',num2str(iNewBackgroundRed));
        varargout{1} = iNewBackgroundRed;
        
    case 'BackgroundGreen'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BackgroundGreen';
        iNewBackgroundGreen = g_strctParadigm.BackgroundGreen.Buffer(g_strctParadigm.BackgroundGreen.BufferIdx);
        fnTsSetVarParadigm('BackgroundGreen',iNewBackgroundGreen);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBackgroundGreenSlider, iNewBackgroundGreen);
        set(g_strctParadigm.m_strctControllers.m_hBackgroundGreenEdit,'String',num2str(iNewBackgroundGreen));
        varargout{1} = iNewBackgroundGreen;
        
    case 'BackgroundBlue'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BackgroundBlue';
        iNewBackgroundBlue = g_strctParadigm.BackgroundBlue.Buffer(g_strctParadigm.BackgroundBlue.BufferIdx);
        fnTsSetVarParadigm('BackgroundBlue',iNewBackgroundBlue);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBackgroundBlueSlider, iNewBackgroundBlue);
        set(g_strctParadigm.m_strctControllers.m_hBackgroundBlueEdit,'String',num2str(iNewBackgroundBlue));
        varargout{1} = iNewBackgroundBlue;
        
    case 'BackgroundPresetColor'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'BackgroundPresetColor';
        iNewBackgroundPresetColor = g_strctParadigm.BackgroundPresetColor.Buffer(g_strctParadigm.BackgroundPresetColor.BufferIdx);
        fnTsSetVarParadigm('BackgroundPresetColor',iNewBackgroundPresetColor);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hBarBlueSlider, iNewBackgroundPresetColor);
        set(g_strctParadigm.m_strctControllers.m_hBarBlueEdit,'String',num2str(iNewBackgroundPresetColor));
        varargout{1} = iNewBackgroundPresetColor;
        
    case 'StimulusArea'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusArea';
        iNewStimulusArea = g_strctParadigm.StimulusArea.Buffer(g_strctParadigm.StimulusArea.BufferIdx);
        fnTsSetVarParadigm('StimulusArea',iNewStimulusArea);
        fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hStimulusAreaSlider, iNewStimulusArea);
        set(g_strctParadigm.m_strctControllers.m_hStimulusAreaEdit,'String',num2str(iNewStimulusArea));
        
    case 'UpdateStimulusPosition'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'SetDynamicTrialMode'
        g_strctParadigm.m_bSetDynamicTrialMode = ~g_strctParadigm.m_bSetDynamicTrialMode;
        if g_strctRealTimeStatServer.m_bConnected
            mssend(g_strctRealTimeStatServer.m_iSocket,{'setdynamictrialmode',g_strctParadigm.m_bSetDynamicTrialMode});
        end
        
        
    case 'BlockLoopingToggle'
        g_strctParadigm.m_bBlockLooping = get(g_strctParadigm.m_strctControllers.m_hLoopCurrentBlock,'value') > 0;
        
    case 'BlocksDoneAction'
        acOptions =get(g_strctParadigm.m_strctControllers.m_hBlocksDoneActionPopup,'String');
        iValue =get(g_strctParadigm.m_strctControllers.m_hBlocksDoneActionPopup,'value');
        g_strctParadigm.m_strBlockDoneAction = acOptions{iValue};
        %---------------------------------------------------------------------------------------------------------------
    case 'MicroStimFixedRateToggle'
        set(g_strctParadigm.m_strctControllers.m_hMicroStimPoissonRate,'value',0);
        bActive = get(g_strctParadigm.m_strctControllers.m_hMicroStimFixedRate,'value');
        if bActive
            % Turn on
            g_strctParadigm.m_strctMiroSctim.m_strMicroStimType = 'FixedRate';
            g_strctParadigm.m_strctMiroSctim.m_fMicroStimRateHz = 1/5;
            g_strctParadigm.m_strctMiroSctim.m_fNextStimTS = GetSecs();
            g_strctParadigm.m_strctMiroSctim.m_bActive = true;
        else
            % Turn off
            g_strctParadigm.m_strctMiroSctim.m_bActive = false;
        end
    case 'MicroStimPoissonRateToggle'
        set(g_strctParadigm.m_strctControllers.m_hMicroStimFixedRate,'value',0);
        bActive = get(g_strctParadigm.m_strctControllers.m_hMicroStimPoissonRate,'value');
        if bActive
            % Turn on
            g_strctParadigm.m_strctMiroSctim.m_strMicroStimType = 'Poisson';
            g_strctParadigm.m_strctMiroSctim.m_fMicroStimRateHz = 1/5;
            g_strctParadigm.m_strctMiroSctim.m_fNextStimTS = GetSecs();
            g_strctParadigm.m_strctMiroSctim.m_bActive = true;
            
        else
            % Turn off
            g_strctParadigm.m_strctMiroSctim.m_bActive = false;
        end
    case 'LoadImageSet'
        fnPauseParadigm();
		fnParadigmToStimulusServer('LoadDefaultClut');
        fnParadigmToStimulusServer('LoadDefaultBlendFunction');
        Screen('BlendFunction', g_strctPTB.m_hWindow, GL_ONE, GL_ZERO);
        
        g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 0;
        Screen('Flip', g_strctPTB.m_hWindow, 0, 0, 2);
        % wait for the screen to update so it doesnt crash in the main cycle
        WaitSecs(.3);
         try
                	for iTextures = 1:numel(g_strctParadigm.m_strctMRIStim.ahTextures)
                    % free up texture memory just in case
                    	Screen('Close',g_strctParadigm.m_strctMRIStim.ahTextures(iTextures));
                    
                	end
                end
        aStrImageListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
                %iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
        strSelectedImageList = deblank(aStrImageListNames(g_strctParadigm.m_iCurrentBlockIndexInOrderList,:));
		[g_strctParadigm.m_strctMRIStim.ahTextures,g_strctParadigm.m_strctMRIStim.a2iTextureSize,...
			g_strctParadigm.m_strctMRIStim.abIsMovie,g_strctParadigm.m_strctMRIStim.aiApproxNumFrames,...
			g_strctParadigm.m_strctMRIStim.afMovieLengthSec,g_strctParadigm.m_strctMRIStim.acImages] = ...
			fnInitializeHandMappingTextures(g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);
		fnParadigmToStimulusServer('ForceMessage','LoadImageSetHandMapping', g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);
        
        g_strctParadigm.m_strCurrentlySelectedBlock = 'Image';
        g_strctParadigm.m_strctMRIStim.m_strCurrentlySelectedStimset = strSelectedImageList;
		        setStimulusPanelButton('Image',g_strctParadigm.m_strCurrentlySelectedBlock);

        
    case 'LoadFavoriteList'
        % fnParadigmToKofikoComm('SafeCallback','LoadFavoriteListSafe');
        fnPauseParadigm();
        iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'value');
        cImageListNames = get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'string');
        g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;
        set(g_strctParadigm.m_strctControllers.m_hBlockLists, 'value', 1);
		
        
        switch deblank(cImageListNames(iSelectedImageList,:))
            case 'HandMapper'
                %g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;
                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder = g_strctParadigm.m_strctHandMappingDesignBackup;
                acBlockNames = {g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks.m_strBlockName};
                %acBlockNames = acBlockNames(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder(1).m_aiBlockIndexOrder);
                set(g_strctParadigm.m_strctControllers.m_hBlockLists, 'string',acBlockNames);
                
                %g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder = g_strctParadigm.m_strctHandMappingDesignBackup;
                %g_strctParadigm.m_iCurrentBlockIndexInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
                iSelectedBlock = g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder(g_strctParadigm.m_iCurrentOrder).m_aiBlockIndexOrder(g_strctParadigm.m_iCurrentBlockIndexInOrderList);
                setStimulusPanelButton(lower(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_strBlockName),...
                    g_strctParadigm.m_strCurrentlySelectedBlock);
                
                
                
            case 'Images'
                g_strctParadigm.m_strctMRIStim.m_strCurrentlySelectedStimset = [];
                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder.m_strOrderName = 'Default Order';
                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder.m_aiBlockIndexOrder = [1:numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths)];
                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder.m_aiBlockRepitition = ones(numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths));
                for iBlocks = 1:numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths)
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_strBlockName = g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths{iBlocks};
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_aiMedia = iBlocks;
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_bMicroStim = false;
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_acMicroStimAttributes = [];
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_fBlockLengthMS = [];
                    
                end
                g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths = fnLoadImageSet({'FindImageSets'},g_strctParadigm.m_strImageListDirectoryPath);
                g_strctParadigm.m_iCurrentBlockIndexInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
                g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
                set(g_strctParadigm.m_strctControllers.m_hBlockLists, 'string', g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths);
                aStrImageListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
                %iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
				for iLists = 1:numel(g_strctParadigm.m_iCurrentBlockIndexInOrderList)
                    strSelectedImageList{iLists} = deblank(aStrImageListNames{g_strctParadigm.m_iCurrentBlockIndexInOrderList(iLists)});

                end
               % strSelectedImageList = deblank(aStrImageListNames(g_strctParadigm.m_iCurrentBlockIndexInOrderList,:));
                
                %{
                [g_strctParadigm.m_strctMRIStim.ahTextures,g_strctParadigm.m_strctMRIStim.a2iTextureSize,...
                    g_strctParadigm.m_strctMRIStim.abIsMovie,g_strctParadigm.m_strctMRIStim.aiApproxNumFrames,...
                    g_strctParadigm.m_strctMRIStim.afMovieLengthSec,g_strctParadigm.m_strctMRIStim.acImages] = ...
                    fnInitializeHandMappingTextures(g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);
                fnParadigmToStimulusServer('ForceMessage','LoadImageSetHandMapping', g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);
				%}
                %acBlockNames = {g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks.m_strBlockName};
                %acBlockNames = acBlockNames(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder(1).m_aiBlockIndexOrder);
                %setStimulusPanelButton('Image',g_strctParadigm.m_strCurrentlySelectedBlock);
                %g_strctParadigm.m_strCurrentlySelectedBlock = 'Image';
                %feval(g_strctParadigm.m_strCallbacks,'ImagePanel');
                %feval(g_strctParadigm.m_strCallbacks,'DesignPanel')
            case 'Movies'

                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder.m_strOrderName = 'Default Order';
                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder.m_aiBlockIndexOrder = [1:numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths)];
                g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder.m_aiBlockRepitition = ones(numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths));
                for iBlocks = 1:numel(g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths)
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_strBlockName = g_strctParadigm.m_strctMRIStim.m_acMRIStimPaths{iBlocks};
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_aiMedia = iBlocks;
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_bMicroStim = false;
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_acMicroStimAttributes = [];
                    g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iBlocks).m_fBlockLengthMS = [];
                    
                end
                
                %strSelectedImageList = deblank(aStrImageListNames(g_strctParadigm.m_iCurrentBlockIndexInOrderList,:));
                
                
                g_strctParadigm.m_strctMovieStim.m_acMovieStimPaths = fnLoadImageSet({'FindImageSets'},g_strctParadigm.m_strMovieListDirectoryPath);
                set(g_strctParadigm.m_strctControllers.m_hBlockLists, 'string', g_strctParadigm.m_strctMovieStim.m_acMovieStimPaths);
                 
                
                
                setStimulusPanelButton('Movie',g_strctParadigm.m_strCurrentlySelectedBlock);
                g_strctParadigm.m_strCurrentlySelectedBlock = 'Movie';
                aStrMovieListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
				strSelectedImageList = deblank(aStrMovieListNames(g_strctParadigm.m_iCurrentBlockIndexInOrderList,:));
                [g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
                        fnLoadImageSet({'GetMovieFilePaths'}, g_strctParadigm.m_strMovieListDirectoryPath, strSelectedImageList);
                
                
                
                
        end
        %get(g_strctParadigm.m_strctControllers.m_hBlockLists, 'string')
        fnParadigmToStimulusServer('LoadDefaultClut');
        %   case {'StaticBarPanel','MovingBarPanel','TwoBarPanel','GaborPanel','DiscPanel'}
        %       return;
    case 'JumpToBlock'
		%g_strctParadigm.m_iCurrentBlockIndexInOrderList = set(g_strctParadigm.m_strctControllers.m_hBlockLists, 'value', 1);
         fnPauseParadigm();
        g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
        if isempty(g_strctParadigm.m_strctDesign)
            return;
        end;
        iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'value');
        cImageListNames = get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'string');
        switch deblank(cImageListNames(iSelectedImageList,:))
            case 'HandMapper'
               

                fnParadigmToStimulusServer('LoadDefaultClut');
                g_strctParadigm.m_iNumTimesBlockShown = 0;
                g_strctParadigm.m_iCurrentBlockIndexInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
                g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
                iSelectedBlock = g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder(g_strctParadigm.m_iCurrentOrder).m_aiBlockIndexOrder(g_strctParadigm.m_iCurrentBlockIndexInOrderList);
                iNumMediaInBlock = length(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_aiMedia);
                
                switch lower(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_strBlockName)
                    case 'plain bar'
                        feval(g_strctParadigm.m_strCallbacks,'PlainBarPanel');
                        
                    case 'moving bar'
                        feval(g_strctParadigm.m_strCallbacks,'MovingBarPanel');
                        
                    case 'two bar'
                        feval(g_strctParadigm.m_strCallbacks,'TwoBarPanel');
                        
                    case 'gabor'
                        feval(g_strctParadigm.m_strCallbacks,'GaborPanel');
                        
                    case 'moving dots'
                        feval(g_strctParadigm.m_strCallbacks,'DiscPanel');
						
                    case 'many bar'
                        feval(g_strctParadigm.m_strCallbacks,'ManyBarPanel');
                end
                 fnParadigmToStimulusServer('LoadDefaultClut');
        fnParadigmToStimulusServer('LoadDefaultBlendFunction');
        Screen('BlendFunction', g_strctPTB.m_hWindow, GL_ONE, GL_ZERO);
        
        g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 0;
        Screen('Flip', g_strctPTB.m_hWindow, 0, 0, 2);
        % wait for the screen to update so it doesnt crash in the main cycle
        WaitSecs(.3);
            case 'Images'
                g_strctParadigm.m_strctMRIStim.m_strCurrentlySelectedStimset = [];
                %disp('loading beginning')
                %{
                try
                	for iTextures = 1:numel(g_strctParadigm.m_strctMRIStim.ahTextures)
                    % free up texture memory just in case
                    	Screen('Close',g_strctParadigm.m_strctMRIStim.ahTextures(iTextures));
                    
                	end
                end
                %}
                g_strctParadigm.m_iPreviousBlockIndexInOrderList = g_strctParadigm.m_iCurrentBlockIndexInOrderList;
                
                g_strctParadigm.m_iCurrentBlockIndexInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
               % g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
                
                aStrImageListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
                %iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
                for iLists = 1:numel(g_strctParadigm.m_iCurrentBlockIndexInOrderList)
                    strSelectedImageList{iLists} = deblank(aStrImageListNames{g_strctParadigm.m_iCurrentBlockIndexInOrderList(iLists)});

                end
                %{
                fnParadigmToStimulusServer('ForceMessage','LoadImageSetHandMapping', g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);

                
                [g_strctParadigm.m_strctMRIStim.ahTextures,g_strctParadigm.m_strctMRIStim.a2iTextureSize,...
                    g_strctParadigm.m_strctMRIStim.abIsMovie,g_strctParadigm.m_strctMRIStim.aiApproxNumFrames,...
                    g_strctParadigm.m_strctMRIStim.afMovieLengthSec,g_strctParadigm.m_strctMRIStim.acImages] = ...
                    fnInitializeHandMappingTextures(g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);

                if isempty(g_strctParadigm.m_strctMRIStim.ahTextures)
                    
                    strSelectedImageList = deblank(aStrImageListNames(g_strctParadigm.m_iPreviousBlockIndexInOrderList,:));
                    fnParadigmToStimulusServer('ForceMessage','LoadImageSetHandMapping', g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);                   
                    
                    [g_strctParadigm.m_strctMRIStim.ahTextures,g_strctParadigm.m_strctMRIStim.a2iTextureSize,...
                        g_strctParadigm.m_strctMRIStim.abIsMovie,g_strctParadigm.m_strctMRIStim.aiApproxNumFrames,...
                        g_strctParadigm.m_strctMRIStim.afMovieLengthSec,g_strctParadigm.m_strctMRIStim.acImages] = ...
                        fnInitializeHandMappingTextures(g_strctParadigm.m_strImageListDirectoryPath, strSelectedImageList);
                    fnParadigmToKofikoComm('DisplayMessage','Folder empty!! Previous image list retained');
                else
                    
                    %fnParadigmToStimulusServer('ForceMessage','LoadImageList',acFileNames);
                    %g_strctParadigm.m_strctMRIStim.m_ahStimImageHandles = fnLoadImageSet({'LoadImageSet'}, g_strctParadigm.m_strImageListDirectoryPath, {strSelectedImageList});
                    feval(g_strctParadigm.m_strCallbacks,'ImagePanel');
                end
                %}
            case 'Movies'
               % g_strctParadigm.m_iPreviousBlockIndexInOrderList = g_strctParadigm.m_iCurrentBlockIndexInOrderList;
                fnPauseParadigm();

                %g_strctParadigm.m_iCurrentBlockIndexInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
                g_strctParadigm.m_iCurrentlySelectedBlocksInOrderList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
               % g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
                g_strctParadigm.m_iCurrentlyPlayingMovieList = g_strctParadigm.m_iCurrentlySelectedBlocksInOrderList(g_strctParadigm.m_iCurrentlyPlayingMovieListID);
                aStrMovieListNames = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'string');
                %iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hBlockLists,'value');
               % strSelectedImageList = deblank(aStrMovieListNames(g_strctParadigm.m_iCurrentBlockIndexInOrderList,:));
                strSelectedImageList = deblank(aStrMovieListNames(g_strctParadigm.m_iCurrentlyPlayingMovieList,:));
                fnParadigmToStimulusServer('ForceMessage','LoadMovieSet', g_strctParadigm.m_strMovieListDirectoryPath,...
                    strSelectedImageList,	g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly);
                if ~g_strctParadigm.m_strctMovieStim.m_bLoadOnTheFly
                    
                    [g_strctParadigm.m_strctMovieStim.m_ahMovieHandles, g_strctParadigm.m_strctMovieStim.m_acMovieData,...
                        g_strctParadigm.m_strctMovieStim.m_abIsMovie, g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
                        fnLoadImageSet({'LoadMovieSet'},g_strctParadigm.m_strMovieListDirectoryPath,strSelectedImageList);
                else
                    [g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths] = ...
                        fnLoadImageSet({'GetMovieFilePaths'}, g_strctParadigm.m_strMovieListDirectoryPath, strSelectedImageList);
                end
				g_strctParadigm.m_strctMovieStim.m_iDisplayCount = zeros(numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths),1);
				g_strctParadigm.m_strctMovieStim.m_iNumMoviesInThisBlock = numel(g_strctParadigm.m_strctMovieStim.m_acMovieFilePaths);
				 fnParadigmToStimulusServer('LoadDefaultClut');
        fnParadigmToStimulusServer('LoadDefaultBlendFunction');
        Screen('BlendFunction', g_strctPTB.m_hWindow, GL_ONE, GL_ZERO);
        
        g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 0;
        Screen('Flip', g_strctPTB.m_hWindow, 0, 0, 2);
        % wait for the screen to update so it doesnt crash in the main cycle
        WaitSecs(.3);
                %feval(g_strctParadigm.m_strCallbacks,'MoviePanel');
        end
        
        
        % default blend functions, in case we're switching from the gabor mode to something else
        %disp('blend function loaded')
       
        % disp('loading finished')
        %{
		% gray out the controllers for the stimuli we arent using
        if ~any(strfind(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_strBlockName,'Tuning')) && ...
                ~any(strfind(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(g_strctParadigm.m_iCurrentBlockIndexInOrderList).m_strBlockName,'Tuning'))
            % We're switching between non-tuning function paradigms
            % Gray out the previous paradigms controls and re-enable the
            % new paradigm controls
            set(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtons(g_strctParadigm.m_iCurrentBlockIndexInOrderList),'enable','on')
            set(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtons(g_strctParadigm.m_iCurrentBlockIndexInOrderList),'visible','on')
            set(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtons(g_strctParadigm.m_iLastStimuliControllerButtonIndex),'enable','off')
            set(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtons(g_strctParadigm.m_iLastStimuliControllerButtonIndex),'visible','off')
            g_strctParadigm.m_iLastStimuliControllerButtonIndex = g_strctParadigm.m_iCurrentBlockIndexInOrderList;
        elseif any(strfind(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_strBlockName,'Tuning')) && ...
                ~any(strfind(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(g_strctParadigm.m_iCurrentBlockIndexInOrderList).m_strBlockName,'Tuning'))
            % We're switching to a tuning function paradigm from a
            % non-tuning function paradigm
            % Start the plexon file recording and signal the paradigm start
                fnStartRecording(0.2);
                fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iStartRecord);
                fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iStartParadigm);
            
            
        elseif g_bRecording && ~any(strfind(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_strBlockName,'tuning'))
            % We're recording ( presumably we're in a tuning function paradigm) and we're switching to a non-tuning function paradigm.
            % stop the recording and re-enable stimulus controls
           
                fnStopRecording(0.2);
                set(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtons(g_strctParadigm.m_iCurrentBlockIndexInOrderList),'enable','on')
                set(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtons(g_strctParadigm.m_iCurrentBlockIndexInOrderList),'visible','on')
                
        elseif g_bRecording && any(strfind(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_strBlockName,'tuning'))
            % We were already in a tuning function paradigm and now we're
            % switching to a new one. No need to stop the recording, but
            % signal Plexon that we're changing paradigms
            fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iStopParadigm);
            fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iStopRecord);
            fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iStartRecord);
            fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iStartParadigm);
            
           
            
        end
        %}
        
        
        %{
        if g_strctParadigm.m_bRandom
            [fDummy,g_strctParadigm.m_aiCurrentRandIndices] = sort(rand(1,iNumMediaInBlock));
        else
            g_strctParadigm.m_aiCurrentRandIndices = 1:iNumMediaInBlock;
        end
        %}
    case 'LocalStereoMode'
        iNewStereoMode = get(g_strctParadigm.m_strctControllers.m_hLocalStereoModePopup,'value');
        acStereoModes = get(g_strctParadigm.m_strctControllers.m_hLocalStereoModePopup,'String');
        g_strctParadigm.m_strLocalStereoMode = acStereoModes{iNewStereoMode};
    case 'RepatNonFixatedToggle'
        g_strctParadigm.m_bRepeatNonFixatedImages=~g_strctParadigm.m_bRepeatNonFixatedImages;
    case 'NoiseOverlayToggle'
        bNoiseOverlayActive = fnTsGetVar('g_strctParadigm' , 'NoiseOverlayActive');
        bNoiseOverlayActive = ~bNoiseOverlayActive;
        fnTsSetVarParadigm('NoiseOverlayActive',bNoiseOverlayActive);
        
        if bNoiseOverlayActive
            if g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns > 0
                g_strctParadigm.m_strctNoiseOverlay.m_iNoiseIndex = 1;
            end
            fnParadigmToKofikoComm('DisplayMessage', 'Resetting Noise Index');
        end
    case 'NoisePatternSwitch'
        iSelectedNoiseFile = get(g_strctParadigm.m_strctControllers.m_hNoisePatternPopup,'value');
        fnTsSetVarParadigm( 'NoiseFile', g_strctParadigm.m_acNoisePatternsFiles{iSelectedNoiseFile});
        strctTmp = load(['.\NoisePatterns\',g_strctParadigm.m_acNoisePatternsFiles{iSelectedNoiseFile}]);
        g_strctParadigm.m_a3fRandPatterns = strctTmp.a3fRand;
        g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = size(g_strctParadigm.m_a3fRandPatterns,3);
        g_strctParadigm.m_strctNoiseOverlay.m_iNoiseIndex = 0;
        
        
        
    case 'MicroStim'
        strctStimulation.m_iChannel = 1;
        strctStimulation.m_fDelayToTrigMS = 0;
        fnParadigmToKofikoComm('MultiChannelStimulation', strctStimulation);
        
    case 'DesignPanel'
       % setStimulusPanelButton('Design',g_strctParadigm.m_strCurrentlySelectedBlock)
       % g_strctParadigm.m_strCurrentlySelectedBlock = 'Gabor';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'StatisticsPanel'
        %setStimulusPanelButton('Statistics',g_strctParadigm.m_strCurrentlySelectedBlock)
      %  g_strctParadigm.m_strCurrentlySelectedBlock = 'Gabor';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'JuicePanel'
       % setStimulusPanelButton('Juice',g_strctParadigm.m_strCurrentlySelectedBlock)
       % g_strctParadigm.m_strCurrentlySelectedBlock = 'Gabor';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'ColorPanel'
       % setStimulusPanelButton('Color',g_strctParadigm.m_strCurrentlySelectedBlock)
       % g_strctParadigm.m_strCurrentlySelectedBlock = 'Gabor';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'PlainBarPanel'
        setStimulusPanelButton('PlainBar',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'PlainBar';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'MovingBarPanel'
        setStimulusPanelButton('MovingBar',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'MovingBar';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
		     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');
        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
        
    case 'TwoBarPanel'
        setStimulusPanelButton('TwoBar',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'TwoBar';
        
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'GaborPanel'
        setStimulusPanelButton('Gabor',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'Gabor';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'DiscPanel'
        setStimulusPanelButton('Disc',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'Disc';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        
        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'ImagePanel'
        setStimulusPanelButton('Image',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'Image';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','on');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
    case 'MoviePanel'
        setStimulusPanelButton('Movie',g_strctParadigm.m_strCurrentlySelectedBlock)
        g_strctParadigm.m_strCurrentlySelectedBlock = 'Movie';
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','on');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','off');

        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
        
        case 'ManyBarPanel'
             setStimulusPanelButton('ManyBar',g_strctParadigm.m_strCurrentlySelectedBlock)
             g_strctParadigm.m_strCurrentlySelectedBlock = 'ManyBar';
			 
			         set(g_strctParadigm.m_strctControllers.m_hSubPanels(1),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(2),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(3),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(4),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(5),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(6),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(7),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(8),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(9),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(10),'visible','off');
        set(g_strctParadigm.m_strctControllers.m_hSubPanels(11),'visible','off');
				     set(g_strctParadigm.m_strctControllers.m_hSubPanels(12),'visible','on');
			 
             g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
                        
        case 'ManyBarSelectedBar'
			for iBar = 0:fnTsGetVar('g_strctParadigm','ManyBarNumberOfBarsSelected')% 'ManyBarNumberOfBars'
				if iBar == fnTsGetVar('g_strctParadigm','ManyBarSelectedBar')
					set(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'visible','on')
% % % % % 					set(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'enable','on')
% % % % % 					set(g_strctParadigm.m_strctControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'visible','on')
% % % % % 					set(g_strctParadigm.m_strctControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'enable','on')

% handleArray = [handles.editText, handles.pushbutton, handles.listbox];
% % Set them all disabled.
% set(handlesArray, 'Enable', 'off');

set( findall(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, '-property', 'Enable'), 'Enable', 'on')

				else
					set(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'visible','off')
% % % % % 					set(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'enable','off')
% % % % % 					set(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'visible','off')
% % % % % 					set(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, 'enable','off')
set( findall(g_strctParadigm.m_strctControllers.strctManyBarControllers.strctManyBarSubControllers(iBar+1).m_hPanel, '-property', 'Enable'), 'Enable', 'on')

				end
		end
		
    case 'FixationSizePix'
        
        
    case 'StimulusON_MS'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusON_MS';
        ISI=1/g_strctStimulusServer.m_fRefreshRateHz*1e3;
        
        fStimulusON_MS = ISI*ceil(g_strctParadigm.StimulusON_MS.Buffer(1,:,g_strctParadigm.StimulusON_MS.BufferIdx)/ISI);
        fStimulusOFF_MS = ISI*ceil(g_strctParadigm.StimulusOFF_MS.Buffer(1,:,g_strctParadigm.StimulusOFF_MS.BufferIdx)/ISI);
        g_strctParadigm.m_strctStatServerDesign.TrialLengthSec = 1.1 * (fStimulusON_MS+fStimulusOFF_MS)/1e3; % multiple by 10% to account for possible jitter
        fnParadigmToStatServerComm('SendDesign', g_strctParadigm.m_strctStatServerDesign);
        
    case 'StimulusOFF_MS'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusOFF_MS';
        ISI=1/g_strctStimulusServer.m_fRefreshRateHz*1e3;
        
        fStimulusON_MS = ISI*ceil(g_strctParadigm.StimulusON_MS.Buffer(1,:,g_strctParadigm.StimulusON_MS.BufferIdx)/ISI);
        fStimulusOFF_MS = ISI*ceil(g_strctParadigm.StimulusOFF_MS.Buffer(1,:,g_strctParadigm.StimulusOFF_MS.BufferIdx)/ISI);
        g_strctParadigm.m_strctStatServerDesign.TrialLengthSec = 1.1 * (fStimulusON_MS+fStimulusOFF_MS)/1e3; % multiple by 10% to account for possible jitter
        
        fnParadigmToStatServerComm('SendDesign', g_strctParadigm.m_strctStatServerDesign);
        
    case 'RotationAngle'
        if g_strctParadigm.m_bParameterSweep
            fnInitializeParameterSweep();
        end
        
    case 'GazeBoxPix'
    case 'StimulusSizePix'
        if g_strctParadigm.m_bParameterSweep
            fnInitializeParameterSweep();
        end
        
    case 'BlinkTimeMS'
    case 'PositiveIncrement'
    case 'Resuming'
        if g_strctParadigm.m_iMachineState == 6
            g_strctParadigm.m_iMachineState = 1;
        end
        
    case 'PhotoDiodeRectToggle'
        g_strctParadigm.m_bShowPhotodiodeRect = ~g_strctParadigm.m_bShowPhotodiodeRect;
    case 'Pausing'
        
        
        
    case 'LoadList'
        fnParadigmToKofikoComm('SafeCallback','LoadListSafe');
    case 'LoadListSafe'
        fnSafeLoadListAux();
        
        
        
        %     case 'LFPStatToggle'
        %         g_strctGUIParams.m_bShowLFPStat = ~g_strctGUIParams.m_bShowLFPStat;
        
    case 'Start'
        g_strctParadigm.m_iMachineState = 1;
        [fLocalTime, fServerTime, fJitter] = fnSyncClockWithStimulusServer(100);
        fnTsSetVarParadigm('SyncTime', [fLocalTime,fServerTime,fJitter]);
        
        g_strctParadigm.m_fLastFixatedTimer = GetSecs();
        % end any trials in progress, if any
        fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctStatServerDesign.TrialEndCode);
        
    case 'Random'
        g_strctParadigm.m_bRandom =  get(g_strctParadigm.m_strctControllers.m_hRandomImageIndex,'value');
        
        
        iSelectedBlock = g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlockOrder(g_strctParadigm.m_iCurrentOrder).m_aiBlockIndexOrder(g_strctParadigm.m_iCurrentBlockIndexInOrderList);
        iNumMediaInBlock = length(g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(iSelectedBlock).m_aiMedia);
        if g_strctParadigm.m_bRandom
            [fDummy,g_strctParadigm.m_aiCurrentRandIndices] = sort(rand(1,iNumMediaInBlock));
        else
            g_strctParadigm.m_aiCurrentRandIndices = 1:iNumMediaInBlock;
        end
        
        
    case 'GazeTimeMS'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'GazeTimeMS';
        g_strctParadigm.m_strctDynamicJuice.m_iFixationCounter = 0;
        iNewGazeTimeMS = g_strctParadigm.GazeTimeMS.Buffer(g_strctParadigm.GazeTimeMS.BufferIdx);
        iGazeTimeLowMS = g_strctParadigm.GazeTimeLowMS.Buffer(g_strctParadigm.GazeTimeLowMS.BufferIdx);
        if iNewGazeTimeMS < iGazeTimeLowMS
            fnTsSetVarParadigm('GazeTimeLowMS',iNewGazeTimeMS);
            fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hGazeTimeLowMSSlider, iNewGazeTimeMS);
            set(g_strctParadigm.m_strctControllers.m_hGazeTimeLowMSEdit,'String',num2str(iNewGazeTimeMS));
        end
        
    case 'GazeTimeLowMS'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'GazeTimeLowMS';
        iNewGazeTimeLowMS = g_strctParadigm.GazeTimeLowMS.Buffer(g_strctParadigm.GazeTimeLowMS.BufferIdx);
        iGazeTimeMS = g_strctParadigm.GazeTimeMS.Buffer(g_strctParadigm.GazeTimeMS.BufferIdx);
        if iNewGazeTimeLowMS > iGazeTimeMS
            fnTsSetVarParadigm('GazeTimeMS',iNewGazeTimeLowMS);
            fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hGazeTimeMSSlider, iNewGazeTimeLowMS);
            set(g_strctParadigm.m_strctControllers.m_hGazeTimeMSEdit,'String',num2str(iNewGazeTimeLowMS));
        end
        g_strctParadigm.m_strctDynamicJuice.m_iFixationCounter = 0;
        
    case 'JuiceTimeMS'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'JuiceTimeMS';
        iNewJuiceTimeMS =  g_strctParadigm.JuiceTimeMS.Buffer(g_strctParadigm.JuiceTimeMS.BufferIdx);
        iJuiceTimeHighMS = g_strctParadigm.JuiceTimeHighMS.Buffer(g_strctParadigm.JuiceTimeHighMS.BufferIdx);
        if iNewJuiceTimeMS > iJuiceTimeHighMS
            fnTsSetVarParadigm('JuiceTimeHighMS',iNewJuiceTimeMS);
            fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hJuiceTimeHighMSSlider, iNewJuiceTimeMS);
            set(g_strctParadigm.m_strctControllers.m_hJuiceTimeHighMSEdit,'String',num2str(iNewJuiceTimeMS));
        end
        
    case 'JuiceTimeHighMS'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'JuiceTimeHighMS';
        iNewJuiceTimeHighMS = g_strctParadigm.JuiceTimeHighMS.Buffer(g_strctParadigm.JuiceTimeHighMS.BufferIdx);
        iJuiceTimeMS = g_strctParadigm.JuiceTimeMS.Buffer(g_strctParadigm.JuiceTimeMS.BufferIdx);
        if iNewJuiceTimeHighMS < iJuiceTimeMS
            fnTsSetVarParadigm('JuiceTimeMS',iNewJuiceTimeHighMS);
            fnUpdateSlider(g_strctParadigm.m_strctControllers.m_hJuiceTimeMSSlider, iNewJuiceTimeHighMS);
            set(g_strctParadigm.m_strctControllers.m_hJuiceTimeMSEdit,'String',num2str(iNewJuiceTimeHighMS));
        end
        
    case 'FixationSpot'
        g_strctParadigm.m_strCurrentlySelectedVariable = 'JuiceTimeHighMS';
        if g_strctParadigm.m_bUpdateFixationSpot
            g_strctParadigm.m_bUpdateFixationSpot = false;
            set( g_strctParadigm.m_strctControllers.m_hFixationSpotChange,'String','New Fixation Spot','fontweight','normal');
        else
            g_strctParadigm.m_bUpdateFixationSpot = true;
            set( g_strctParadigm.m_strctControllers.m_hFixationSpotChange,'String','Updating Fixation Spot','fontweight','bold');
        end;
        
    case 'StimulusPos'
        if g_strctParadigm.m_bUpdateStimulusPos
            g_strctParadigm.m_bUpdateStimulusPos = false;
            set( g_strctParadigm.m_strctControllers.m_hStimulusPosChange,'String','New Stimulus Pos','fontweight','normal');
        else
            g_strctParadigm.m_bUpdateStimulusPos = true;
            set( g_strctParadigm.m_strctControllers.m_hStimulusPosChange,'String','Updating Stimulus Pos','fontweight','bold');
        end;
        if g_strctParadigm.m_bParameterSweep
            fnInitializeParameterSweep();
        end
        
    case 'ResetStimulusPosition'
        g_strctParadigm.m_aiCenterOfStimulus(1) = g_strctStimulusServer.m_aiScreenSize(3)/2;
        g_strctParadigm.m_aiCenterOfStimulus(2) = g_strctStimulusServer.m_aiScreenSize(4)/2;
        
        fnTsSetVar('g_strctParadigm','StimulusPosition',g_strctParadigm.m_aiCenterOfStimulus);
        
    case 'BackgroundColor'
        fnParadigmToKofikoComm('JuiceOff');
        bParadigmPaused = fnParadigmToKofikoComm('IsPaused');
        
        if ~bParadigmPaused
            bPausing = true;
            fnPauseParadigm()
        else
            bPausing = false;
        end
        
        
        fnShowHideWind('PTB Onscreen window [10]:','hide');
        aiColor  = uisetcolor();
        fnShowHideWind('PTB Onscreen window [10]:','show');
        if length(aiColor) > 1
            fnTsSetVarParadigm('BackgroundColor',round(aiColor*255));
            %            fnDAQWrapper('StrobeWord', fnFindCode('Stimulus Position Changed'));
        end;
        if bPausing
            fnResumeParadigm();
        end
        
        
    case 'ResetUnit'
        g_strctParadigm.m_strWhatToReset = 'Unit';
        set(g_strctParadigm.m_strctControllers.m_hResetUnit,'value',1);
        set(g_strctParadigm.m_strctControllers.m_hResetChannel,'value',0);
        set(g_strctParadigm.m_strctControllers.m_hResetAllChannels,'value',0);
    case 'ResetChannel'
        g_strctParadigm.m_strWhatToReset = 'Channel';
        set(g_strctParadigm.m_strctControllers.m_hResetUnit,'value',0);
        set(g_strctParadigm.m_strctControllers.m_hResetChannel,'value',1);
        set(g_strctParadigm.m_strctControllers.m_hResetAllChannels,'value',0);
    case 'ResetAllChannels'
        g_strctParadigm.m_strWhatToReset = 'AllChannels';
        set(g_strctParadigm.m_strctControllers.m_hResetUnit,'value',0);
        set(g_strctParadigm.m_strctControllers.m_hResetChannel,'value',0);
        set(g_strctParadigm.m_strctControllers.m_hResetAllChannels,'value',1);
    case 'ResetStat'
        fnParadigmToKofikoComm('ResetStat',g_strctParadigm.m_strWhatToReset);
        %{
     case 'StartRecording'
		global  g_bRecording
		if ~g_bRecording
			fnStartRecording(0.2);
		else
			fnStopRecording(0.2);
		end;
        %}
        
    case 'StartRecording'
        %  fnParadigmToKofikoComm('ResetStat');
        
        
        %        set(g_strctParadigm.m_strctControllers.m_hLoadList,'enable','off');
        %        set(g_strctParadigm.m_strctControllers.m_hFavroiteLists,'enable','off');
    case 'StopRecording'
        %        set(g_strctParadigm.m_strctControllers.m_hLoadList,'enable','on');
        %        set(g_strctParadigm.m_strctControllers.m_hFavroiteLists,'enable','on');
        [fLocalTime, fServerTime, fJitter] = fnSyncClockWithStimulusServer(100);
        fnTsSetVarParadigm('SyncTime', [fLocalTime,fServerTime,fJitter]);
        
    case 'LoadFavoriteListSafe'
        fnParadigmToKofikoComm('JuiceOff');
        iSelectedImageList = get(g_strctParadigm.m_strctControllers.m_hFavoriteLists,'value');
        if ~fnLoadPassiveFixationDesign(g_strctParadigm.m_acFavroiteLists{iSelectedImageList});
            return;
        end
        
        [fLocalTime, fServerTime, fJitter] = fnSyncClockWithStimulusServer(100);
        fnTsSetVarParadigm('SyncTime', [fLocalTime,fServerTime,fJitter]);
        fnResetStat();
        
        g_strctParadigm.m_iNumTimesBlockShown = 0;
        g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;
        g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
        g_strctParadigm.m_iCurrentOrder = 1;
        
        g_strctParadigm.m_strctCurrentTrial = [];
        
    case 'RandFixationSpot'
        g_strctParadigm.m_bRandFixPos = ~g_strctParadigm.m_bRandFixPos;
        if g_strctParadigm.m_bRandFixPos
            set(g_strctParadigm.m_strctControllers.m_hRandomPosition,'FontWeight','bold');
        else
            set(g_strctParadigm.m_strctControllers.m_hRandomPosition,'FontWeight','normal');
            % return it to center....
            fnTsSetVarParadigm('FixationSpotPix', g_strctStimulusServer.m_aiScreenSize(3:4)/2);
            fnParadigmToKofikoComm('SetFixationPosition',g_strctStimulusServer.m_aiScreenSize(3:4)/2);
            if g_strctParadigm.m_bRandFixSyncStimulus
                fnTsSetVarParadigm('StimulusPos', g_strctStimulusServer.m_aiScreenSize(3:4)/2);
            end
        end;
    case 'RandFixationSpotMinEdit'
        strTemp = get(g_strctParadigm.m_strctControllers.m_hRandomPositionMinEdit,'string');
        iRandMin = fnMyStr2Num(strTemp);
        if ~isempty(iRandMin)
            g_strctParadigm.m_fRandFixPosMin = iRandMin;
            fnLog('Random fixation changes after at least %d images', iRandMin);
        end;
    case 'RandFixationSpotMaxEdit'
        strTemp = get(g_strctParadigm.m_strctControllers.m_hRandomPositionMaxEdit,'string');
        iRandMax = fnMyStr2Num(strTemp);
        if ~isempty(iRandMax)
            g_strctParadigm.m_fRandFixPosMax = iRandMax;
            fnLog('Random fixation changes after at max %d images', iRandMax);
        end;
    case 'RandFixationSpotRadiusEdit'
        strTemp = get(g_strctParadigm.m_strctControllers.m_hRandomPositionRadiusEdit,'string');
        iRandRadius = fnMyStr2Num(strTemp);
        if ~isempty(iRandRadius)
            g_strctParadigm.m_fRandFixRadius = iRandRadius;
            fnLog('Random fixation radius set to %d pixels', iRandRadius);
        end;
    case 'ParameterSweep'
        g_strctParadigm.m_bParameterSweep = get(g_strctParadigm.m_strctControllers.m_hParameterSweep,'value');
        if (g_strctParadigm.m_bParameterSweep)
            
            g_strctParadigm.m_strctSavedParam.m_pt2fStimulusPosition = fnTsGetVar('g_strctParadigm','StimulusPos');
            g_strctParadigm.m_strctSavedParam.m_fTheta = fnTsGetVar('g_strctParadigm','RotationAngle');
            g_strctParadigm.m_strctSavedParam.m_fSize = fnTsGetVar('g_strctParadigm','StimulusSizePix');
            
            fnInitializeParameterSweep();
            g_strctParadigm.m_iStimuliCounter = 1;
            g_strctParadigm.m_iMachineState = 1;
            
            
        else
            
            fnTsSetVarParadigm('StimulusPos',g_strctParadigm.m_strctSavedParam.m_pt2fStimulusPosition);
            fnTsSetVarParadigm('RotationAngle',g_strctParadigm.m_strctSavedParam.m_fTheta);
            fnTsSetVarParadigm('StimulusSizePix',g_strctParadigm.m_strctSavedParam.m_fSize);
            
        end
        % Changelog 10/21/13 josh - other components of FitToScreen setting
    case 'FitToScreen'
        g_strctParadigm.m_bFitToScreen = get(g_strctParadigm.m_strctControllers.m_hFitToScreen, 'value');
        
    case 'SetStimulusClipping'
        g_strctParadigm.m_bClipStimulusOutsideStimArea = ~g_strctParadigm.m_bClipStimulusOutsideStimArea;
        
        % End Changelog
    case 'RandFixationSync'
        g_strctParadigm.m_bRandFixSyncStimulus = ~g_strctParadigm.m_bRandFixSyncStimulus;
        
    case 'MotionStarted'
        g_strctParadigm.m_iMachineState = 0;
        fnParadigmToStimulusServer('PauseButRecvCommands');
        g_strctParadigm.m_bPausedDueToMotion = true;
    case 'MotionFinished'
        if ~fnParadigmToKofikoComm('IsPaused')
            g_strctParadigm.m_strctCurrentTrial = fnHandMappingPrepareTrial();
            g_strctParadigm.m_iMachineState = 1;
        end
        g_strctParadigm.m_bPausedDueToMotion = false;
    case 'HideNotLookingToggle'
        g_strctParadigm.m_bHideStimulusWhenNotLooking = ~g_strctParadigm.m_bHideStimulusWhenNotLooking;
        if ~g_strctParadigm.m_bHideStimulusWhenNotLooking
            g_strctParadigm.m_iMachineState = 1;
        end
    case 'ParameterSweepMode'
        g_strctParadigm.m_iParameterSweepMode = get(g_strctParadigm.m_strctControllers.m_hParameterSweepPopup,'value');
        fnInitializeParameterSweep();
    case 'UpdateListFiringRate'
        [Dummy, acShortFileNames] = fnCellToCharShort(g_strctParadigm.m_acImageFileNames);
        
        %         for k=1:length(acShortFileNames)
        %             acShortFileNames{k} = sprintf('%.2f %s',...
        %                 g_strctCycle.m_a2fAvgStimulusResponse(g_strctGUIParams.m_iSelectedChannelPSTH,k),acShortFileNames{k});
        %         end
        %
        %         set(g_strctParadigm.m_strctControllers.m_hImageList,'String',acShortFileNames);
        
        
    case 'PlayStimuliLocally'
        g_strctParadigm.m_bDisplayStimuliLocally = ~g_strctParadigm.m_bDisplayStimuliLocally;
    case 'ShowWhileLoading'
        g_strctParadigm.m_bShowWhileLoading = ~g_strctParadigm.m_bShowWhileLoading;
    case 'ForceStereoToggle'
        bForceStereo = fnTsGetVar('g_strctParadigm','ForceStereoOnMonocularLists') > 0;
        bForceStereo = ~bForceStereo;
        fnTsSetVarParadigm('ForceStereoOnMonocularLists',bForceStereo);
        set(g_strctParadigm.m_strctControllers.m_hForceStereoOnMonocularLists,'value',bForceStereo);
    case 'DrawAttentionEvent'
        g_strctParadigm.m_iMachineState = 1;
        
    otherwise
        varargout{1} = fnDynamicCallback(strCallback);
        % fnParadigmToKofikoComm('DisplayMessage', [strCallback,' not handeled']);
        
end;

return;

function fnSafeLoadListAux()
global g_strctParadigm
fnParadigmToKofikoComm('JuiceOff');
fnParadigmToStimulusServer('PauseButRecvCommands');
fnHidePTB();
[strFile, strPath] = uigetfile([g_strctParadigm.m_strInitial_DefaultImageFolder,'*.txt;*.xml']);

fnShowPTB()
if strFile(1) ~= 0
    g_strctParadigm.m_strNextImageList = [strPath,strFile];
    
    if ~fnLoadPassiveFixationDesign(g_strctParadigm.m_strNextImageList);
        return;
    end;
    
    [fLocalTime, fServerTime, fJitter] = fnSyncClockWithStimulusServer(100);
    fnTsSetVarParadigm('SyncTime', [fLocalTime,fServerTime,fJitter]);
    
    % If not available in the favorite list, add it!
    iIndex = -1;
    for k=1:length(g_strctParadigm.m_acFavroiteLists)
        if strcmpi(g_strctParadigm.m_acFavroiteLists{k}, g_strctParadigm.m_strNextImageList)
            iIndex = k;
            break;
        end
    end
    
    
    if iIndex == -1
        % Not found, add!
        g_strctParadigm.m_acFavroiteLists = [g_strctParadigm.m_strNextImageList,g_strctParadigm.m_acFavroiteLists];
        set(g_strctParadigm.m_strctControllers.m_hFavroiteLists,'String',fnCellToCharShort(g_strctParadigm.m_acFavroiteLists),'value',1);
    else
        set(g_strctParadigm.m_strctControllers.m_hFavroiteLists,'value',iIndex);
    end
    
    
    
end;




function setStimulusPanelButton(StimName,previousStimName)
global g_strctParadigm






% find the appropriate entry in the stimulus button controllers list
StimName = StimName(~isspace(StimName));
strIndex = strfind(lower(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtonsStrLookup),lower(StimName));

strIndex = find(~cellfun(@isempty,strIndex));
setPanelStr = ['m_hSet',g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtonsStrLookup{strIndex}];
% enable that stimulus' controller button
set(g_strctParadigm.m_strctControllers.(setPanelStr),'enable','on');
set(g_strctParadigm.m_strctControllers.(setPanelStr),'visible','on');

% find the previous stimulus' button
previousStimName = previousStimName(~isspace(previousStimName));

previousStrIndex = strfind(lower(g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtonsStrLookup),lower(previousStimName));
previousStrIndex = find(~cellfun(@isempty,previousStrIndex));
if ~isempty(previousStrIndex) && previousStrIndex ~= strIndex
    % if the index is empty there's nothing to do here.
    setPanelStr = ['m_hSet',g_strctParadigm.m_strctControllers.m_ahStimuliControllerButtonsStrLookup{previousStrIndex}];
    
    % disable previous stimulus' controller button
    set(g_strctParadigm.m_strctControllers.(setPanelStr),'enable','off');
    set(g_strctParadigm.m_strctControllers.(setPanelStr),'visible','off');
    
    
end

return;



