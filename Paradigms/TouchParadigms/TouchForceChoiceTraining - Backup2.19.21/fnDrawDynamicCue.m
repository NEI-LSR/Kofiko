function [fLastFlipTime] = fnDrawDynamicCue(h_PTBWindow)
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
						

	if strcmp(g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strStimulusType,'bar')
		%Screen('FillArc', h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afFixationColor, aiFixationRect, 0, 360);
		if ~g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_bBlur
			
			for iNumOfBars = 1:g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumberOfBars
				Screen('FillPoly',h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_aiCueColors,...
					 horzcat(g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesX(1:4,1,iNumOfBars),...
						g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesY(1:4,1,iNumOfBars)),0);
			end
			
		else
		% Blur not implemented
		%{
			for iNumOfBars = 1:g_strctDraw.m_strctCurrentTrial.NumberOfBars
				for iBlurStep = 1:g_strctDraw.m_strctCurrentTrial.numberBlurSteps
				
					Screen('FillPoly',h_PTBWindow, g_strctDraw.m_strctCurrentTrial.blurStepHolder(:,iBlurStep),...
								horzcat(g_strctDraw.m_strctCurrentTrial.coordinatesX(1:4,g_strctDraw.m_strctCurrentTrial.m_iLocalFrameCounter,iNumOfBars,iBlurStep),...
								g_strctDraw.m_strctCurrentTrial.coordinatesY(1:4,g_strctDraw.m_strctCurrentTrial.m_iLocalFrameCounter,iNumOfBars,iBlurStep)),0);
				end
			end
			%}
		end
	elseif strcmp(g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strStimulusType,'disc')
	%dbstop if warning
	%warning('stop')
		%Screen('FillArc', h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_aiCueColors, g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect', 0, 360);
		if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bLuminanceMaskedCueStimuli
			thisFrame = rem(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter,...
                g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_iMaxFramesInCueEpoch);
			thisFrame(thisFrame == 0) = 1;
			Screen('DrawTexture', h_PTBWindow, ...
				g_strctDraw.m_ahCueDiscTextures(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.thisTrialCueTextureOrder(thisFrame))', ...
				[] ,g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect');
			g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter = ...
                g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter + 1;
		else
			Screen('FillArc', h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_aiCueColors, g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect', 0, 360);
		end


	end

	ClutEncoded = BitsPlusEncodeClutRow(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_aiClut);
	ClutTextureIndex = Screen( 'MakeTexture', h_PTBWindow, ClutEncoded );
	Screen('DrawTexture', h_PTBWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	Screen('Close',ClutTextureIndex);

	fnDrawFixationSpot(h_PTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod, 0, 1)
	fLastFlipTime = fnFlipWrapper(h_PTBWindow);
	return;
else
	global g_strctParadigm
			

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
			%dbstop if warning
			%warning('stop')
			Screen('DrawTexture', h_PTBWindow, ...
				g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCueHandleIndexingColorID, ...
												g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.thisTrialCueTextureOrder(thisFrame))', ...
												[] , g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect');
			g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter = g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter + 1;
		else
			Screen('FillArc', h_PTBWindow, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiCueColors, g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect', 0, 360);
		end

	end

	%ClutEncoded = BitsPlusEncodeClutRow(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiClut);
	%ClutTextureIndex = Screen( 'MakeTexture', h_PTBWindow, ClutEncoded );
	%Screen('DrawTexture', h_PTBWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	%Screen('Close',ClutTextureIndex);

	%fnDrawFixationSpot(h_PTBWindow, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod, 0, 1)
	%fLastFlipTime = fnFlipWrapper(h_PTBWindow);


end