function fnNTlab_mTurkPlusDraw(bParadigmPaused)
%
% Copyright (c) 2018 Joshua Fuller-Deets, National Institutes of Health.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
%
global g_strctPTB g_strctParadigm g_strctDraw 

% Do not call Flip, just draw everything to the screen.

acMedia = [];
if fnParadigmToKofikoComm('IsTouchMode')
    if isfield(g_strctDraw,'m_acMedia')
        acMedia = g_strctDraw.m_acMedia;
    end
else
    if isfield(g_strctParadigm,'m_acMedia')
        acMedia = g_strctParadigm.m_acMedia;
    end
end
if any(g_strctParadigm.m_iMachineState) && ~isempty(g_strctParadigm.m_strctCurrentTrial)
% draw background
	Screen('FillRect', g_strctPTB.m_hWindow,g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_afLocalBackgroundColor,...
		[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3),...
		g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(4)]);
    
    strctFixationSpot= g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod;
    Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgcircle,[],g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
	Screen('FillArc',g_strctPTB.m_hWindow,[0,0,0], g_strctPTB.m_fScale * [strctFixationSpot.m_pt2fFixationPosition(1)-2,strctFixationSpot.m_pt2fFixationPosition(2)-2,strctFixationSpot.m_pt2fFixationPosition(1)+2,strctFixationSpot.m_pt2fFixationPosition(2)+2] ,0,360); % convex
	
%     if g_strctParadigm.m_iMachineState == 4
%         Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgcircle,[],g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
%     end
	if g_strctParadigm.m_iMachineState == 20
		%fnDisplayDynamicStimLocally();
        
		fnDrawDynamicMkTurkPlusCue(g_strctPTB.m_hWindow);
        	aiFixationRect = [g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) -...
														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) -...
														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) +...
														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) +...
														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix];
 %           Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgAChTexPtr(g_strctParadigm.m_strctCurrentTrial.m_iMkTurkTargetID),[],g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueWin);
            %Screen('Flip',window);
        if g_strctParadigm.MemoryChoiceBool 
        fnDisplayMkTurkPlusMemoryChoices(g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial,false,true);
        end
        
	elseif any(ismember(g_strctParadigm.m_iMachineState, [21,22,23])) 
		switch lower(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType)
			case 'ring'
		%if strcmp(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'Ring')
			%fnDisplayChoiceRing(g_strctPTB.m_hWindow,g_strctParadigm.m_strctCurrentTrial);
            dbstop if warning
            warning('Stop, Hammertime')
%            fnDisplayChoicesTraining(g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial,false,true)
			case {'disc','annuli','nestedannuli'}
		%elseif strcmp(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'Disc')
			%fnDisplayChoiceDiscs(g_strctPTB.m_hWindow,g_strctParadigm.m_strctCurrentTrial);

            fnDisplayMkTurkPlusChoices(g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial,false,true);
%                     	aiFixationRect = [g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) -...
% 														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
% 						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) -...
% 														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
% 						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) +...
% 														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
% 						g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) +...
% 														g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix];
%             Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgChTexPtr(1),[],g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_aiChoiceScreenCoordinates');

		end
	end
%    fnDrawFixationSpot(g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod, false, g_strctPTB.m_fScale);


end

 if ~g_strctParadigm.m_iMachineState || bParadigmPaused
	fnDrawStimulusAndChoiceLocations();

 end
 
if 0
% Stat...
iNumTrials = g_strctParadigm.acTrials.BufferIdx-1;
iNumTimeOuts = 0;
iNumCorrect = 0;
iNumIncorrect = 0;
for iTrialIter=1:iNumTrials
    if ~isempty(g_strctParadigm.acTrials.Buffer{iTrialIter}) && isfield(g_strctParadigm.acTrials.Buffer{iTrialIter},'m_g_strctParadigm.m_strctParadigmPTBUpdateParams.utcome')
        switch g_strctParadigm.acTrials.Buffer{iTrialIter}.m_g_strctParadigm.m_strctParadigmPTBUpdateParams.utcome.m_strResult
            case 'Timeout'
                iNumTimeOuts = iNumTimeOuts+1;
            case 'Correct'
                iNumCorrect = iNumCorrect + 1;
            case 'Incorrect'
                iNumIncorrect = iNumIncorrect + 1;
        end
    end
end
%aiScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');

fStartX = 0;    
fStartY = 200;
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Num Trials   : %d',iNumTrials), fStartX,fStartY+30,[255 255 255]);
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Num Correct  : %d (%.1f%%)',iNumCorrect,iNumCorrect/iNumTrials*100), fStartX,fStartY+60,[0 255 0]);
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Num Incorrect: %d (%.1f%%)',iNumIncorrect,iNumIncorrect/iNumTrials*100), fStartX,fStartY+90,[255 0 0]);
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Num Timeout  : %d (%.1f%%)',iNumTimeOuts,iNumTimeOuts/iNumTrials*100), fStartX,fStartY+120,[255 0 255]);

end
return;
        
aiScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');

% Prepare the trial structure that is sent to the stimulus server
pt2fFixationSpotPosition = aiScreenSize(3:4)/2;
fChoicesHalfSizePix = fnTsGetVar('g_strctParadigm','ChoicesHalfSizePix');
if ~isempty(g_strctParadigm.m_ahPTBHandles)
    for k=1:length(g_strctParadigm.m_ahPTBHandles)
        Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.m_ahPTBHandles(k),[],  g_strctPTB.m_fScale * g_strctParadigm.m_a2iStimulusRect(k,:));
        
       if k > 1
           pt2fChoiceCenter = pt2fFixationSpotPosition + g_strctParadigm.m_g_strctParadigm.m_strctParadigmPTBUpdateParams.oStimulusServer.m_astrctRelevantChoices(k-1).m_pt2fRelativePos;
           fHitRadius = fnTsGetVar('g_strctParadigm','HitRadius'); 
           aiHitRect = [pt2fChoiceCenter-fHitRadius,pt2fChoiceCenter+fHitRadius];
           if k == 2
               % Correct answer
               Screen('FrameArc', g_strctPTB.m_hWindow, [0 255 0],g_strctPTB.m_fScale * aiHitRect,0,360);
           else
               Screen('FrameArc', g_strctPTB.m_hWindow, [255 255 255],g_strctPTB.m_fScale * aiHitRect,0,360);
           end
           
        else
           % Target Image. Draw noise.
              Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.m_hNoiseHandle,[],  g_strctPTB.m_fScale * g_strctParadigm.m_a2iStimulusRect(k,:));
       end
       
       aiTargetRect = g_strctPTB.m_fScale * g_strctParadigm.m_a2iStimulusRect(k,:);
       if g_strctParadigm.m_iMachineState < 8
           for j=1:20:2*fChoicesHalfSizePix+1
               Screen('DrawLine', g_strctPTB.m_hWindow, [200 200 200],aiTargetRect(1),aiTargetRect(2)+j, aiTargetRect(3), aiTargetRect(2)+j);
           end
       end
       if g_strctParadigm.m_iMachineState < 10
           for j=1:20:2*fChoicesHalfSizePix+1
               Screen('DrawLine', g_strctPTB.m_hWindow, [200 200 200],aiTargetRect(1)+j,aiTargetRect(2), aiTargetRect(1)+j, aiTargetRect(4));
           end
       end       
       
    end
end

fFixationRadiusPix = fnTsGetVar('g_strctParadigm','FixationRadiusPix');
aiFixationArea = [g_strctParadigm.m_pt2fFixationSpot - fFixationRadiusPix,g_strctParadigm.m_pt2fFixationSpot + fFixationRadiusPix];
Screen('FrameArc', g_strctPTB.m_hWindow, [255 255 255],g_strctPTB.m_fScale * aiFixationArea,0,360);


iNumTrials = g_strctParadigm.m_strctStatistics.m_iNumCorrect+g_strctParadigm.m_strctStatistics.m_iNumIncorrect+...
    g_strctParadigm.m_strctStatistics.m_iNumTimeout + g_strctParadigm.m_strctStatistics.m_iNumShortHold;
fStartX = g_strctPTB.m_aiRect(3)-370;
fStartY = 20;
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Num Trials : %d',iNumTrials), fStartX,fStartY,[255 255 255]);
if iNumTrials > 0
if g_strctParadigm.m_strctStatistics.m_iNumCorrect+g_strctParadigm.m_strctStatistics.m_iNumIncorrect > 0
    
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Correct    : %d (%.1f%%, %.1f%%)',...
    g_strctParadigm.m_strctStatistics.m_iNumCorrect,100*g_strctParadigm.m_strctStatistics.m_iNumCorrect/iNumTrials, ...
    100*g_strctParadigm.m_strctStatistics.m_iNumCorrect / (g_strctParadigm.m_strctStatistics.m_iNumCorrect+g_strctParadigm.m_strctStatistics.m_iNumIncorrect)), fStartX,fStartY+30,[0 255 0]);
else
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Correct    : %d (%.1f%%)',...
    g_strctParadigm.m_strctStatistics.m_iNumCorrect,100*g_strctParadigm.m_strctStatistics.m_iNumCorrect/iNumTrials), fStartX,fStartY+30,[0 255 0]);
    
end

Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Incorrect  : %d (%.1f%%)',...
    g_strctParadigm.m_strctStatistics.m_iNumIncorrect,100*g_strctParadigm.m_strctStatistics.m_iNumIncorrect/iNumTrials), fStartX,fStartY+60,[255 0 0]);
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Timeout    : %d (%.1f%%)',...
    g_strctParadigm.m_strctStatistics.m_iNumTimeout,100*g_strctParadigm.m_strctStatistics.m_iNumTimeout/iNumTrials), fStartX,fStartY+90,[255 0 255]);
Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Short Hold : %d (%.1f%%)',...
    g_strctParadigm.m_strctStatistics.m_iNumShortHold,100*g_strctParadigm.m_strctStatistics.m_iNumShortHold/iNumTrials), fStartX,fStartY+120,[255 255 0]);

Screen(g_strctPTB.m_hWindow,'DrawText', sprintf('Trial %d/%d Rep %d',...
    g_strctParadigm.m_iTrialCounter,length(g_strctParadigm.m_astrctTrials) ,g_strctParadigm.m_iTrialRep), fStartX,fStartY+150,[0 255 255]);


end
return;



function fnDisplayDynamicStimLocally()
global g_strctParadigm g_strctPTB

% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
%ahTexturePointers = g_strctParadigm.m_strctCurrentTrial.m_strctMedia.m_aiMediaToHandleIndexInBuffer;
%fCurrTime  = GetSecs();
%{
Screen('FillRect',g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_afLocalBackgroundColor,...
				[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3),...
				g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(4)]);
				%}
%{
if g_strctParadigm.m_iMachineState == 5 | g_strctParadigm.m_strctCurrentTrial.m_iLocalFrameCounter > g_strctParadigm.m_strctCurrentTrial.numFrames  %#ok<OR2>
	% Trial's over, or we've somehow gone over the number of frames in the trial. Bail out.
	return;
end
%}
if strcmpi(g_strctParadigm.m_strCueType,'disc')
	Screen(g_strctPTB.m_hWindow,'FillArc',g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiLocalStimulusColors,g_strctPTB.m_fScale * g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect,0,360);
elseif strcmpi(g_strctParadigm.m_strCueType,'bar')

	if ~g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_bBlur
		for iNumOfBars = 1:g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumberOfBars
			Screen('FillPoly',g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_aiLocalStimulusColors,...
				g_strctPTB.m_fScale * horzcat(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesX(1:4,1,iNumOfBars),...
					g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesY(1:4,1,iNumOfBars)),0);
		end
	
	end
	
end

return;

function fnDrawStimulusAndChoiceLocations()
global g_strctPTB g_strctParadigm 


% See if we're updating a variable. If not we don't need to do all this crap, just draw the last iteration
if g_strctPTB.m_variableUpdating || ~g_strctParadigm.m_bLocalDrawParamsInitialized 
	fnCalculateStimAndChoiceParams();
	if g_strctParadigm.m_bChoicePositionTypeUpdated
		g_strctParadigm.m_bChoicePositionTypeUpdated = 0;
	end
end

% Cue Params

Screen('FrameRect', g_strctPTB.m_hWindow, [255 0 0],  g_strctPTB.m_fScale * g_strctParadigm.m_aiStimulusRect', 3); % outline the stimulus box
Screen('FillPoly',g_strctPTB.m_hWindow, g_strctParadigm.m_strctParadigmPTBUpdateParams.BarColor,...
			 g_strctPTB.m_fScale * horzcat(g_strctParadigm.m_strctParadigmPTBUpdateParams.coordinatesX(1:4,1,1),...
				g_strctParadigm.m_strctParadigmPTBUpdateParams.coordinatesY(1:4,1,1)),0);
				

Screen('FrameOval',g_strctPTB.m_hWindow, [0, 0, 255], g_strctPTB.m_fScale *g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiChoiceDestinationRect,3);
	
%{			
for iChoices = 1:squeeze(g_strctParadigm.NumberOfChoices.Buffer(:,1,g_strctParadigm.NumberOfChoices.BufferIdx));
	Screen('FrameRect', g_strctPTB.m_hWindow, [0 255 0], [g_strctParadigm.m_strctParadigmPTBUpdateParams.apt2fPositions(iChoices,1) - g_strctParadigm.m_strctParadigmPTBUpdateParams.ChoiceSize,...
														  g_strctParadigm.m_strctParadigmPTBUpdateParams.apt2fPositions(iChoices,2) - g_strctParadigm.m_strctParadigmPTBUpdateParams.ChoiceSize,...
														  g_strctParadigm.m_strctParadigmPTBUpdateParams.apt2fPositions(iChoices,1) + g_strctParadigm.m_strctParadigmPTBUpdateParams.ChoiceSize,...
														  g_strctParadigm.m_strctParadigmPTBUpdateParams.apt2fPositions(iChoices,2) + g_strctParadigm.m_strctParadigmPTBUpdateParams.ChoiceSize],...
														  3);
end
%}
return;

function fnCalculateStimAndChoiceParams()
global g_strctParadigm 


% Statics
g_strctParadigm.m_strctParadigmPTBUpdateParams.numFrames = 1;
g_strctParadigm.m_strctParadigmPTBUpdateParams.NumberOfBars = 1;

% Bounds on Dragging boxes
 locations = fnTsGetVar('g_strctParadigm','StimulusPosition'); 

g_strctParadigm.m_aiStimulusRect(1) = round(locations(1)- 200);
g_strctParadigm.m_aiStimulusRect(2) = round(locations(2)- .75 * 200);
g_strctParadigm.m_aiStimulusRect(3) = round(locations(1)+200);
g_strctParadigm.m_aiStimulusRect(4) = round(locations(2)+ .75 * 200);

% Do the Stimulus bar stuff
 g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x = locations(1);
 g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y = locations(2);
g_strctParadigm.m_strctParadigmPTBUpdateParams.moveDistance = 0;
g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle = fnTsGetVar('g_strctParadigm','CueOrientation');
[cueLength, cueWidth] = fnTsGetVar('g_strctParadigm','CueLength','CueWidth');
g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,1:4) = [(locations(1) - cueLength),...
							(locations(2) - cueWidth),...
							(locations(1) + cueLength),...
							(locations(2) + cueWidth)];

g_strctParadigm.m_strctParadigmPTBUpdateParams.BarColor = [255, 255, 255]; % Bar color is variable during trials so we don't care here

[g_strctParadigm.m_strctParadigmPTBUpdateParams.point1(1,1), g_strctParadigm.m_strctParadigmPTBUpdateParams.point1(2,1)] = fnRotateAroundPoint(g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,1),g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,2),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle);
[g_strctParadigm.m_strctParadigmPTBUpdateParams.point2(1,1), g_strctParadigm.m_strctParadigmPTBUpdateParams.point2(2,1)] = fnRotateAroundPoint(g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,1),g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,4),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle);
[g_strctParadigm.m_strctParadigmPTBUpdateParams.point3(1,1), g_strctParadigm.m_strctParadigmPTBUpdateParams.point3(2,1)] = fnRotateAroundPoint(g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,3),g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,4),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle);
[g_strctParadigm.m_strctParadigmPTBUpdateParams.point4(1,1), g_strctParadigm.m_strctParadigmPTBUpdateParams.point4(2,1)] = fnRotateAroundPoint(g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,3),g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_rect(1,2),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle);
[g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_starting_point(1,1),g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_starting_point(2,1)] = fnRotateAroundPoint(g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),(g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1) - g_strctParadigm.m_strctParadigmPTBUpdateParams.moveDistance/2),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle);
[g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_ending_point(1,1),g_strctParadigm.m_strctParadigmPTBUpdateParams.bar_ending_point(2,1)] = fnRotateAroundPoint(g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),(g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1) + g_strctParadigm.m_strctParadigmPTBUpdateParams.moveDistance/2),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_x(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.location_y(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.fRotationAngle);

[g_strctParadigm.m_strctParadigmPTBUpdateParams.coordinatesX, g_strctParadigm.m_strctParadigmPTBUpdateParams.coordinatesY]  = deal(zeros(4, g_strctParadigm.m_strctParadigmPTBUpdateParams.numFrames, g_strctParadigm.m_strctParadigmPTBUpdateParams.NumberOfBars));
    
g_strctParadigm.m_strctParadigmPTBUpdateParams.coordinatesX(1:4,:) = [g_strctParadigm.m_strctParadigmPTBUpdateParams.point1(1), g_strctParadigm.m_strctParadigmPTBUpdateParams.point2(1), g_strctParadigm.m_strctParadigmPTBUpdateParams.point3(1),g_strctParadigm.m_strctParadigmPTBUpdateParams.point4(1)];
g_strctParadigm.m_strctParadigmPTBUpdateParams.coordinatesY(1:4,:) = [g_strctParadigm.m_strctParadigmPTBUpdateParams.point1(2), g_strctParadigm.m_strctParadigmPTBUpdateParams.point2(2), g_strctParadigm.m_strctParadigmPTBUpdateParams.point3(2),g_strctParadigm.m_strctParadigmPTBUpdateParams.point4(2)];

% Do the choice boxes stuff
% Pretty easy really

g_strctParadigm.m_strctParadigmPTBUpdateParams.m_iChoiceRingSize = fnTsGetVar('g_strctParadigm','ChoiceRingSize');
g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiAFCChoiceLocation = fnTsGetVar('g_strctParadigm','AFCChoiceLocation');
g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiChoiceDestinationRect = [g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiAFCChoiceLocation(1) - (g_strctParadigm.m_strctParadigmPTBUpdateParams.m_iChoiceRingSize/2), ...
																			g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiAFCChoiceLocation(2) - (g_strctParadigm.m_strctParadigmPTBUpdateParams.m_iChoiceRingSize/2), ...
																			g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiAFCChoiceLocation(1) + (g_strctParadigm.m_strctParadigmPTBUpdateParams.m_iChoiceRingSize/2), ...
																			g_strctParadigm.m_strctParadigmPTBUpdateParams.m_aiAFCChoiceLocation(2) + (g_strctParadigm.m_strctParadigmPTBUpdateParams.m_iChoiceRingSize/2)];
%{
if ~strcmp(g_strctParadigm.m_strctChoiceVars.m_strChoicePositionType,'Random')
	g_strctParadigm.m_strctParadigmPTBUpdateParams.apt2fPositions = fnSelectChoicePosition(g_strctParadigm.m_strctChoiceVars.m_strChoicePositionType,...
								squeeze(g_strctParadigm.NumberOfChoices.Buffer(1,:,g_strctParadigm.NumberOfChoices.BufferIdx)),...
								0, squeeze(g_strctParadigm.ChoiceEccentricity.Buffer(:,1,g_strctParadigm.ChoiceEccentricity.BufferIdx)));
								
								
else
	% The choice positions will be randomized, so no point showing them
end
%}
g_strctParadigm.m_bLocalDrawParamsInitialized = 1;

return;