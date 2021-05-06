function [fLastFlipTime] = fnDrawDynamicMkTurkPlusCue(h_PTBWindow)
global g_strctPTB
if g_strctPTB.m_bRunningOnStimulusServer

	global g_strctDraw
	aiFixationRect = [g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) -...
														g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
						g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) -...
														g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
						g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) +...
														g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
						g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) +...
														g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix];
			
    sample=g_strctDraw.m_strctCurrentTrial.m_iMkTurkTargetID;
    
    switch g_strctDraw.m_strctCurrentTrial.m_iMkTurkTaskType
        case {1,2}
            Screen('FillRect',h_PTBWindow,g_strctDraw.rectColor(sample,:),g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
            Screen('DrawTexture',h_PTBWindow,g_strctDraw.imgChTexPtr(sample),g_strctDraw.imageRect, g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
        case {3,7}
            Screen('DrawTexture',h_PTBWindow,g_strctDraw.imgAChTexPtr(sample),g_strctDraw.imageRect, g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
        case {4,6}
            Screen('FillRect',h_PTBWindow,g_strctDraw.rectColor(sample,:),g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
            Screen('DrawTexture',h_PTBWindow,g_strctDraw.imgcircle,g_strctDraw.imageRect,g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
        case 5
            Screen('DrawTexture',h_PTBWindow,g_strctDraw.imgChTexPtr(sample),g_strctDraw.imageRect, g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
    end                                                
%    Screen('DrawTexture',h_PTBWindow,g_strctDraw.imgAChTexPtr(g_strctDraw.m_strctCurrentTrial.m_iMkTurkTargetID), [], g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
    Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.achromcloud_disp(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.stimseq(g_strctDraw.m_strctCurrentTrial.m_iCueFrameCounter)), [] , g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin',0,0);

	ClutEncoded = BitsPlusEncodeClutRow(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_aiClut);
	ClutTextureIndex = Screen( 'MakeTexture', h_PTBWindow, ClutEncoded );
	Screen('DrawTexture', h_PTBWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	Screen('Close',ClutTextureIndex);

    g_strctDraw.m_strctCurrentTrial.m_iCueFrameCounter = g_strctDraw.m_strctCurrentTrial.m_iCueFrameCounter + 1;
	fnDrawFixationSpot(h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod, 0, 1)
	fLastFlipTime = fnFlipWrapper(h_PTBWindow);
	return;
    
    
else
	global g_strctParadigm
	thisFrame = rem(g_strctParadigm.m_strctCurrentTrial.m_iLocalCueFrameCounter, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.numFrames);
		thisFrame(thisFrame == 0) = 1;			
%{
	if strcmp(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strStimulusType,'bar')
		%Screen('FillArc', h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afFixationColor, aiFixationRect, 0, 360);
		if ~g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_bBlur
			
			for iNumOfBars = 1:g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumberOfBars
				Screen('FillPoly',h_PTBWindow, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiCueColors,...
					 g_strctPTB.m_fScale *  horzcat(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesX(1:4,1,iNumOfBars),...
						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesY(1:4,1,iNumOfBars)),0);
			end
			
		else
		
		end
	elseif strcmp(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strStimulusType,'disc')
		if g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_bLuminanceMaskedCueStimuli
			thisFrame = rem(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iMaxFramesInCueEpoch);
			thisFrame(thisFrame == 0) = 1;
			Screen('DrawTexture', h_PTBWindow, ...
				g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCueHandleIndexingColorID, ...
												g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.thisTrialCueTextureOrder(thisFrame))', ...
												[] , g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect');
			g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter = g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter + 1;
		else
			Screen('FillArc', h_PTBWindow, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiCueColors, g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect', 0, 360);
		end

    end
%}
    
    sample=g_strctParadigm.m_strctCurrentTrial.m_iMkTurkTargetID;
    switch g_strctParadigm.m_strctCurrentTrial.m_iMkTurkTaskType
        case {1,2}
            Screen('FillRect',h_PTBWindow,g_strctParadigm.rectColor(sample,:),g_strctPTB.m_fScale * g_strctParadigm.m_aiMkTurkCueRect);
            Screen('DrawTexture',h_PTBWindow,g_strctParadigm.imgChTexPtr(sample),g_strctParadigm.imageRect, g_strctPTB.m_fScale * g_strctParadigm.m_aiMkTurkCueRect);
        case {3,7}
            Screen('DrawTexture',h_PTBWindow,g_strctParadigm.imgAChTexPtr(sample),g_strctParadigm.imageRect, g_strctPTB.m_fScale * g_strctParadigm.m_aiMkTurkCueRect);
        case {4,6}
            Screen('FillRect',h_PTBWindow,g_strctParadigm.rectColor(sample,:), g_strctPTB.m_fScale * g_strctParadigm.m_aiMkTurkCueRect);
            Screen('DrawTexture',h_PTBWindow,g_strctParadigm.imgcircle,g_strctParadigm.imageRect,g_strctPTB.m_fScale * g_strctParadigm.m_aiMkTurkCueRect);
        case 5
            Screen('DrawTexture',h_PTBWindow,g_strctParadigm.imgChTexPtr(sample),g_strctParadigm.imageRect, g_strctPTB.m_fScale * g_strctParadigm.m_aiMkTurkCueRect);
    end
    
%        Screen('DrawTexture',hPTBWindow,g_strctParadigm.imgAChTexPtr(g_strctParadigm.m_strctCurrentTrial.m_iMkTurkTargetID), [], g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);

	%ClutEncoded = BitsPlusEncodeClutRow(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiClut);
	%ClutTextureIndex = Screen( 'MakeTexture', h_PTBWindow, ClutEncoded );
	%Screen('DrawTexture', h_PTBWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	%Screen('Close',ClutTextureIndex);

	%fnDrawFixationSpot(h_PTBWindow, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod, 0, 1)
	%fLastFlipTime = fnFlipWrapper(h_PTBWindow);
    
    Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.achromcloud_local(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.stimseq(g_strctParadigm.m_strctCurrentTrial.m_iLocalCueFrameCounter)), [] , g_strctPTB.m_fScale * g_strctParadigm.m_aiETStimulusRect',0,0);
    g_strctParadigm.m_strctCurrentTrial.m_iLocalCueFrameCounter = thisFrame + 1;


end