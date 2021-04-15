function varargout=fnParadigmTouchForceChoiceTrainingDrawCycle(acInputsFromKofiko)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global  g_strctDraw g_strctStimulusServer g_strctPTB g_bPhotoDiodeToggle


if g_strctPTB.m_bRunningOnStimulusServer
    hPTBWindow = g_strctPTB.m_hWindow;
else
    hPTBWindow = g_strctStimulusServer.m_hWindow;
end
varargout{1} = [];
varargout{2} = [];
if ~isempty(acInputsFromKofiko)
    
    strCommand = acInputsFromKofiko{1};
    
    switch strCommand
        case 'LoadMedia'
            g_strctDraw.m_acMedia = fnLoadMedia(hPTBWindow,acInputsFromKofiko{2});
            fnStimulusServerToKofikoParadigm('MediaLoaded');
        case 'PrepareTrial'
            g_strctDraw.m_strctCurrentTrial = acInputsFromKofiko{2};
            
			
			if ~g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
            % Load Images, unless they are already in memory...
			
				if g_strctDraw.m_strctCurrentTrial.m_bLoadOnTheFly
					g_strctDraw.m_acMedia = fnLoadMedia(hPTBWindow,g_strctDraw.m_strctCurrentTrial.m_astrctMedia);
					% Need to prep the media array in prepare trial function...
				end
			end
            PsychPortAudio('Stop',g_strctPTB.m_hAudioDevice);
            
            fnStimulusServerToKofikoParadigm('TrialPreparationDone');
        case 'ClearScreen'
			Screen('FillRect',hPTBWindow,1);
            g_bPhotoDiodeToggle = 1; % black
			fFlipTime = fnFlipWrapper(hPTBWindow); % Blocking !
			
            PsychPortAudio('Stop',g_strctPTB.m_hAudioDevice);
            
        case 'ShowFixationSpot'
            fnDrawFixationSpotTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod, true, 1);	
			
			g_bPhotoDiodeToggle = 0; % white
			fFlipTime = fnFlipWrapper(hPTBWindow); % Blocking !
			
            if ~g_strctPTB.m_bRunningOnStimulusServer
                fFlipTime =  GetSecs(); % Don't trust TS obtained from flip on touch mode
            end
            fnStimulusServerToKofikoParadigm('FixationSpotFlip',fFlipTime); % For remote kofiko
            varargout{1} = fFlipTime; % for local touch screen
        case 'AbortTrial'
            if length(acInputsFromKofiko) > 1 & g_strctDraw.m_strctCurrentTrial.m_strctPostTrial.m_bExtinguishNonSelectedChoicesAfterChoice
                % We need to present only the choice media and wait for a while
                % before moving on...
                iSelectedChoice = acInputsFromKofiko{2};
                fTimeOnScreenMS =  acInputsFromKofiko{3};
				
% 				dbstop if warning
% 			    warning('stop')
				
				% note (AC): maybe try adding new "Post-Trial" struct to strctCurrentTrial instead of creating this temporary one (or do all of it inside RetainChoiceTraining)
				m_strctKeepCurrentTrial.m_aiActiveChoiceColorID = g_strctDraw.m_strctCurrentTrial.m_aiActiveChoiceColorID(iSelectedChoice(2));		
				m_strctKeepCurrentTrial.m_strctTrialParams.m_bDynamicTrial = g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial;
                m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor = g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor;
                m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT = g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT;
                m_strctKeepCurrentTrial.m_iChoiceFrameCounter = g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounter;
                m_strctKeepCurrentTrial.m_iMaxFramesInChoiceEpoch = g_strctDraw.m_strctCurrentTrial.m_iMaxFramesInChoiceEpoch;
                m_strctKeepCurrentTrial.m_aiChoiceScreenCoordinates = g_strctDraw.m_strctCurrentTrial.m_aiChoiceScreenCoordinates(iSelectedChoice(2),:);
                m_strctKeepCurrentTrial.m_strctChoicePeriod.Clut = g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.Clut;	
				m_strctKeepCurrentTrial.m_strChoiceDisplayType = g_strctDraw.m_strctCurrentTrial.m_strChoiceDisplayType; 
				m_strctKeepCurrentTrial.m_bLuminanceNoiseBackground = g_strctDraw.m_strctCurrentTrial.m_bLuminanceNoiseBackground; 
				m_strctKeepCurrentTrial.m_strctChoiceVars = g_strctDraw.m_strctCurrentTrial.m_strctChoiceVars;
				m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs = iSelectedChoice(2);
				m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder = g_strctDraw.m_strctCurrentTrial.thisTrialChoiceTextureOrder;
				
				
                fnRetainChoiceTraining(hPTBWindow,m_strctKeepCurrentTrial, true, true); % Blocking (!)
                WaitSecs(fTimeOnScreenMS/1e3);
            end
            g_strctDraw.m_iMachineState  = 0;
            
			g_bPhotoDiodeToggle = 0; % white
			fFlipTime = fnFlipWrapper(hPTBWindow); % Blocking !
			
            PsychPortAudio('Stop',g_strctPTB.m_hAudioDevice);
            
            if isfield(g_strctDraw,'m_strctCurrentTrial') && isfield(g_strctDraw.m_strctCurrentTrial,'m_bLoadOnTheFly') && g_strctDraw.m_strctCurrentTrial.m_bLoadOnTheFly
                % Clean up!
                fnReleaseMedia( g_strctDraw.m_acMedia);
                g_strctDraw.m_acMedia = [];
            end
            return;
        case 'StartTrial'
            g_strctDraw.m_iMachineState = 1;
			
			g_bPhotoDiodeToggle = 1; % black
			fFlipTime = fnFlipWrapper(hPTBWindow); % Blocking !
			
            if ~isempty(g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod)
                WaitSecs(g_strctDraw.m_strctCurrentTrial.m_strctPreCuePeriod.m_fPostTouchDelayMS/1e3);
            end
        case 'ClearMemory'
        
		case 'PrepareNoiseTextures'
			fnGenerateNoiseTextures(acInputsFromKofiko{2},acInputsFromKofiko{3},acInputsFromKofiko{4});
			
		case 'PrepareChoiceTextures'
			fnInitializeChoiceTrainingTextures(acInputsFromKofiko{2}, acInputsFromKofiko{3}, acInputsFromKofiko{4}, acInputsFromKofiko{5}, acInputsFromKofiko{6}, acInputsFromKofiko{7}, acInputsFromKofiko{8});
		
		case 'PrepareCueTextures'
			fnInitializeCueTrainingTextures(acInputsFromKofiko{2}, acInputsFromKofiko{3}, acInputsFromKofiko{4}, acInputsFromKofiko{5}, acInputsFromKofiko{6}, acInputsFromKofiko{7}, acInputsFromKofiko{8});
			
		case 'PrepareChoiceTexture'
		if isfield(g_strctDraw, 'ahChoiceTexture') 
			Screen('Close',g_strctDraw.ahChoiceTexture);
            clear g_strctDraw.ahChoiceTexture;
		end
			rgbInd = acInputsFromKofiko{2};
			%[~, rgbInd] = fnCreateChoiceColorCircle(acInputsFromKofiko{2},acInputsFromKofiko{3},acInputsFromKofiko{4},acInputsFromKofiko{5},acInputsFromKofiko{6},acInputsFromKofiko{7});
			%use the index here. The CLUT will convert to proper colors
			%dbstop if warning
			%warning('stop')
			g_strctDraw.ahChoiceTexture = Screen('MakeTexture', g_strctPTB.m_hWindow,  rgbInd);
    end
end

SHOW_CHOICES = 101;
MEMORY_PERIOD_WAIT = 100;
MEMORY_PERIOD = 105;
MEMORY_SHOW_CHOICES = 102;
MEMORY_SHOW_CHOICES_Cont = 103;
SHOWING_CUES = 50;
CUE_WAIT_WHILE_ON_SCREEN = 51;
CUE_CONTINUE_DISPLAYING_LUMINANCE_NOISE_STIM = 52;

CUE_MEMORY_PERIOD = 505;
CUE_MEMORY_PERIOD_WAIT = 506;
NEXT_CUE = 200;


            %dbstop if warning
			%warning('test')
			
if isfield(g_strctDraw,'m_iMachineState') && ~isempty(g_strctDraw.m_iMachineState)
    switch  g_strctDraw.m_iMachineState
        case 1
            % Trial started. Show cue(s) if needed...
            
            if isempty(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod)
                % NO CUE condition
                if ~isempty(g_strctDraw.m_strctCurrentTrial.m_astrctChoicesMedia)
                    
                    if ~isempty(g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod)
                        g_strctDraw.m_fMemoryOnsetTS = GetSecs();
                        g_strctDraw.m_iMachineState  = MEMORY_PERIOD_WAIT;
                    else
                        g_strctDraw.m_iMachineState  = SHOW_CHOICES;
                    end
                else
                    g_strctDraw.m_iMachineState  = 0; % Degenerate case (touch screen training)
                end
                
            else
                % CUE CONDITION (!)
                g_strctDraw.m_iCurrentCue = 1;
                g_strctDraw.m_iMachineState = SHOWING_CUES;
                
            end
            
            
        case SHOWING_CUES
			if g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
				fFlipTime =  fnFlipWrapper(hPTBWindow); % Blocking !
% 				dbstop if warning
% 				warning('true') 
				[g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue)] = fnDrawDynamicCueTraining(hPTBWindow);
				g_strctDraw.m_iMachineState = CUE_CONTINUE_DISPLAYING_LUMINANCE_NOISE_STIM;
				fnStimulusServerToKofikoParadigm('CueOnset',g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue),g_strctDraw.m_iCurrentCue);
			else
				if  ~g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bDisplayCue
					g_strctDraw.m_iMachineState = NEXT_CUE;
				else
					
					if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bMovie
						g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue) = fnInitializeMovie(hPTBWindow ); % And display first frame...
					else
						g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue) = fnDrawCue(hPTBWindow,true);
					end
					
					fnStimulusServerToKofikoParadigm('CueOnset',g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue),g_strctDraw.m_iCurrentCue);
					g_strctDraw.m_iMachineState = CUE_WAIT_WHILE_ON_SCREEN;
				end
			end
		case CUE_CONTINUE_DISPLAYING_LUMINANCE_NOISE_STIM	
			if GetSecs()-g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue) <= ...
                    g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_fCuePeriodMS/1e3  - (0.2 * (1/g_strctPTB.m_iRefreshRate) )
                
				[~] = fnDrawDynamicCueTraining(hPTBWindow);
                
            else
                g_strctDraw.m_iMachineState = CUE_MEMORY_PERIOD;
            end

        case CUE_WAIT_WHILE_ON_SCREEN
            % Keep playing movie until cue period has elapsed.
            if GetSecs()-g_strctDraw.m_afCueOnsetTS(g_strctDraw.m_iCurrentCue) <= ...
                    g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_fCuePeriodMS/1e3  - (0.2 * (1/g_strctPTB.m_iRefreshRate) )
                
                if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bMovie
                    fnKeepPlayingMovie(hPTBWindow);
                end
            else
                g_strctDraw.m_iMachineState = CUE_MEMORY_PERIOD;
            end
        case CUE_MEMORY_PERIOD
		        if  g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_fCueMemoryPeriodMS > 0
                
                Screen('FillRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afBackgroundColor);
                if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bCueMemoryPeriodShowFixation
                    fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod, false, 1);
                end
				g_strctDraw.m_afCueMemoryOnsetTS(g_strctDraw.m_iCurrentCue) = fnFlipWrapper(hPTBWindow);
                
                if ~g_strctPTB.m_bRunningOnStimulusServer
                    g_strctDraw.m_afCueMemoryOnsetTS(g_strctDraw.m_iCurrentCue) =  GetSecs(); % Don't trust TS obtained from flip on touch mode
                end
                fnStimulusServerToKofikoParadigm('CueMemoryOnsetTS',g_strctDraw.m_afCueMemoryOnsetTS(g_strctDraw.m_iCurrentCue), g_strctDraw.m_iCurrentCue);
                varargout{1} = 'CueMemoryOnsetTS';
                varargout{2} = g_strctDraw.m_afCueMemoryOnsetTS(g_strctDraw.m_iCurrentCue);
                
                g_strctDraw.m_iMachineState = CUE_MEMORY_PERIOD_WAIT;
                
                
                % Do we have a cue memoy period?
                % If yes, perform the wait
                % If not, go to next cue, or to the memory period before
                % choices...
            else
                % No Cue Memory Period. Next Cue?
                g_strctDraw.m_iMachineState =NEXT_CUE;
            end
            
        case CUE_MEMORY_PERIOD_WAIT
            if GetSecs()- g_strctDraw.m_afCueMemoryOnsetTS(g_strctDraw.m_iCurrentCue) > ...
                    (g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_fCueMemoryPeriodMS/1e3 -(0.2 * (1/g_strctPTB.m_iRefreshRate) ))
                
                g_strctDraw.m_iMachineState =NEXT_CUE;
            end
            
        case NEXT_CUE
            
            iNumCues = length(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod);
            if g_strctDraw.m_iCurrentCue+1 > iNumCues
                % Finished showing cues!
                % Goto memory period!
                g_strctDraw.m_iMachineState = MEMORY_PERIOD;
            else
                g_strctDraw.m_iCurrentCue = g_strctDraw.m_iCurrentCue + 1;
                g_strctDraw.m_iMachineState = SHOWING_CUES;
            end
            
        case MEMORY_PERIOD
            % Cue period is over! Do we have a cue memory period?
            if ~isempty(g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod) && (g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMS ~= 0)
                Screen('FillRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_afBackgroundColor);
                if g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_bShowFixationSpot			
                    fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod, false, 1);
                end
                
				g_bPhotoDiodeToggle = 0;
				g_strctDraw.m_fMemoryOnsetTS = fnFlipWrapper(hPTBWindow);
				
                if ~g_strctPTB.m_bRunningOnStimulusServer
                    g_strctDraw.m_fMemoryOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
                end
                fnStimulusServerToKofikoParadigm('MemoryOnsetTS',g_strctDraw.m_fMemoryOnsetTS);
                varargout{1} = 'MemoryOnsetTS';
                varargout{2} = g_strctDraw.m_fMemoryOnsetTS;
				
                
                g_strctDraw.m_iMachineState = MEMORY_PERIOD_WAIT;
            else
                g_strctDraw.m_iMachineState = SHOW_CHOICES;
            end
            
            
        case MEMORY_PERIOD_WAIT
            % Memory period
			
			if g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_bShowFixationSpot	
                fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod, false, 1);
            end
             
			 g_bPhotoDiodeToggle = 1;
			 fFipTime = fnFlipWrapper(hPTBWindow);
			 
			 
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.Clut );
            ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
            Screen('DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1],0,0 );
            Screen('Close',ClutTextureIndex);
			

            g_strctDraw.m_strctCurrentTrial.m_iMemoryFrameCounter = g_strctDraw.m_strctCurrentTrial.m_iMemoryFrameCounter + 1;
            if g_strctDraw.m_strctCurrentTrial.m_iMemoryFrameCounter > round(g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.numFrames/2)
                g_strctDraw.m_strctCurrentTrial.m_iMemoryFrameCounter = 1;
                g_strctDraw.m_strctCurrentTrial.m_iMemoryFrameCounterResets =  g_strctDraw.m_strctCurrentTrial.m_iMemoryFrameCounterResets + 1;
            end
				
			
            if GetSecs()-g_strctDraw.m_fMemoryOnsetTS > (g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMS/1e3 - (0.2 * (1/g_strctPTB.m_iRefreshRate) ))
                g_strctDraw.m_iMachineState = MEMORY_SHOW_CHOICES;
            end
            
          case MEMORY_SHOW_CHOICES

		  
            if ~isempty(g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod) && (g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMS ~= 0)
                %Screen('FillRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_afBackgroundColor);
                
               if g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_bShowFixationSpot
                    fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod, false, 0);
                end
				

				g_strctDraw.m_fMemoryChoicesOnsetTS = fnFlipWrapper(hPTBWindow);
                
                if ~g_strctPTB.m_bRunningOnStimulusServer
                    g_strctDraw.m_fMemoryChoicesOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
                end

            fnStimulusServerToKofikoParadigm('MemoryChoicesOnsetTS',g_strctDraw.m_fMemoryChoicesOnsetTS);
            varargout{1} = 'MemoryChoicesOnsetTS';
            varargout{2} = g_strctDraw.m_fMemoryChoicesOnsetTS;
            
                g_strctDraw.m_iMachineState = MEMORY_SHOW_CHOICES_Cont;
            else
                g_strctDraw.m_iMachineState = SHOW_CHOICES;
            end
           % dbstop if warning
		%	warning('test')
        case MEMORY_SHOW_CHOICES_Cont
            fnDisplayMemoryChoicesTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial, 0, false);
%             fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod, false, 1);
%             fChoicesOnsetTS = fnFlipWrapper(hPTBWindow); % This would block the server until the next flip.
            
			
            if GetSecs()-g_strctDraw.m_fMemoryChoicesOnsetTS > (g_strctDraw.m_strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMS/1e3 - (0.2 * (1/g_strctPTB.m_iRefreshRate) ))
                g_strctDraw.m_iMachineState = SHOW_CHOICES;
            end   
            
        case SHOW_CHOICES

            % Choices
            iNumChoices =  length(g_strctDraw.m_strctCurrentTrial.m_astrctChoicesMedia);	
			
			
            if ~g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.m_bKeepCueOnScreen
                if g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.m_bShowChoicesOnScreen && ...
                        ~strcmp(g_strctDraw.m_strctCurrentTrial.m_astrctChoicesMedia.m_strChoiceType,'ring')
					fChoicesOnsetTS = fnDisplayChoicesTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial, false,true); % THIS IS THE ONE THAT GETS USED
                    %fChoicesOnsetTS = fnDisplayChoicesTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial, true,true);
                elseif g_strctDraw.m_strctCurrentTrial.m_strctChoicePeriod.m_bShowChoicesOnScreen && ...
                        strcmp(g_strctDraw.m_strctCurrentTrial.m_astrctChoicesMedia.m_strChoiceType,'ring')
					fChoicesOnsetTS = fnDisplayChoicesTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial, false,true);
                    %fChoicesOnsetTS = fnDisplayChoiceRing(g_strctPTB.m_hWindow,g_strctDraw.m_strctCurrentTrial, true,true);

                else
					fChoicesOnsetTS = fnDisplayChoicesTraining(hPTBWindow, [], g_strctDraw.m_strctCurrentTrial, g_strctDraw.m_acMedia,true,true,false,1,false);
                end
            else
			
			 if ~strcmp(g_strctDraw.m_strctCurrentTrial.m_astrctChoicesMedia.m_strChoiceType == 'ring') 
        
					fnDrawCue(hPTBWindow,false);
					%fnDisplayChoicesTraining(g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial,false,true);
					fnDisplayChoicesTraining(hPTBWindow, 1:iNumChoices, g_strctDraw.m_strctCurrentTrial, g_strctDraw.m_acMedia,false,false,false,1,false);
				elseif strcmp(g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia.m_strChoiceType == 'ring') 
					fnDrawCue(hPTBWindow,false);

					fChoicesOnsetTS = fnDisplayChoiceRing(g_strctPTB.m_hWindow,g_strctDraw.m_strctCurrentTrial);
        
				end
                %fChoicesOnsetTS =fnFlipWrapper(hPTBWindow); % This would block the server until the next flip.
                if ~g_strctPTB.m_bRunningOnStimulusServer
                    fChoicesOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
                end
            end
            
			g_bPhotoDiodeToggle = 0;
			g_strctDraw.m_fChoicesOnsetTS = fnFlipWrapper(hPTBWindow);
			
            fnStimulusServerToKofikoParadigm('ChoicesOnsetTS',fChoicesOnsetTS);
            varargout{1} = 'ChoicesOnsetTS';
            varargout{2} = fChoicesOnsetTS;
            g_strctDraw.m_iMachineState = 7;
            PsychPortAudio('Stop',g_strctPTB.m_hAudioDevice);
        case 7		
			% Trial is almost over ? unless we need to extinguish
            % non-saccaded targets....
			fChoicesOnsetTS = fnDisplayChoicesTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial, false,true)
            if g_strctDraw.m_strctCurrentTrial.m_bLuminanceNoiseBackground
				% update the luminance noise background
				fChoicesOnsetTS = fnDisplayChoicesTraining(hPTBWindow, g_strctDraw.m_strctCurrentTrial, false,true);
			end
    end
end

return;




function fCueOnsetTS=fnInitializeMovie(hPTBWindow, iCueIndex)
global g_strctDraw g_strctPTB


if g_strctDraw.m_strctCurrentTrial.m_bLoadOnTheFly
    g_strctDraw.m_iLocalMediaIndex = g_strctDraw.m_iCurrentCue;
else
    g_strctDraw.m_iLocalMediaIndex = g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_iMediaIndex;
end


Screen('PlayMovie', g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_hHandle, 1,0,1);
Screen('SetMovieTimeIndex',g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_hHandle,0);
g_strctDraw.m_fMovieOnset = GetSecs();

% Show first frame

% Clear screen
Screen('FillRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afBackgroundColor);

aiTextureSize = [ g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_iWidth,g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_iHeight];

g_strctDraw.m_aiStimulusRect = fnComputeStimulusRect(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_fCueSizePix,aiTextureSize, ...
    g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_pt2fCuePosition);

[hFrameTexture, g_strctDraw.m_fMovieTimeToFlip] = Screen('GetMovieImage', hPTBWindow, ...
    g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_hHandle,1);

% Assume there is at least one frame in this movie... otherwise this
% will crash...
if hFrameTexture > 0
    Screen('DrawTexture', hPTBWindow, hFrameTexture,[],g_strctDraw.m_aiStimulusRect, 0);
    
    % Overlay fixation?
    if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bOverlayPreCueFixation
        fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod, false, 1);
    end
    
    if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bCueHighlight
        Screen('FrameRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afCueHighlightColor, g_strctDraw.m_aiStimulusRect,2);
    end
    
    fCueOnsetTS = fnFlipWrapper(hPTBWindow); % This would block the server until the next flip.
    Screen('Close', hFrameTexture);
else
    fCueOnsetTS = fnFlipWrapper(hPTBWindow);
end

if ~g_strctPTB.m_bRunningOnStimulusServer
    fCueOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
end


%         iApproxNumFrames = g_strctDraw.m_aiApproxNumFrames(g_strctDraw.m_strctTrial.m_iStimulusIndex);
%         g_strctDraw.m_iFrameCounter = 1;
return;


function fnKeepPlayingMovie(hPTBWindow)
global g_strctDraw
% Movie is playing... Fetch frame and display it

[hFrameTexture, fTimeToFlip] = Screen('GetMovieImage', hPTBWindow, ...
    g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_hHandle,1);

if hFrameTexture == -1
    % End of movie. Circular display....
    Screen('SetMovieTimeIndex',g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_hHandle,0);
    g_strctDraw.m_fMovieOnset = GetSecs();
else
    % Still have frames
    if fTimeToFlip == g_strctDraw.m_fMovieTimeToFlip
        % This frame HAS been displayed yet.
        % Don't do anything. (it should still be on the screen...)
        Screen('Close', hFrameTexture);
    else
        Screen('DrawTexture', hPTBWindow, hFrameTexture,[],g_strctDraw.m_aiStimulusRect, 0);
        % Overlay fixation?
        if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bOverlayPreCueFixation
            fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod, false, 1);
        end
        if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bCueHighlight
            Screen('FrameRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afCueHighlightColor, g_strctDraw.m_aiStimulusRect,2);
        end
        fnFlipWrapper(hPTBWindow, g_strctDraw.m_fMovieOnset+fTimeToFlip); % This would block the server until the next flip.
        Screen('Close', hFrameTexture);
    end
end

return;


function fCueOnsetTS=fnDrawCue(hPTBWindow,bFlip)
global g_strctDraw g_strctPTB
% Clear screen

if g_strctDraw.m_strctCurrentTrial.m_bLoadOnTheFly
    g_strctDraw.m_iLocalMediaIndex = g_strctDraw.m_iCurrentCue;
else
    g_strctDraw.m_iLocalMediaIndex = g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_iMediaIndex;
end

if  ~isempty(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_strctAudio)
    % Start playing sound, only then display things on screen.
    % This will introduce some delay/latency, but since we don't know when
    % was the last flip.... we can't sync to that event.
    
    strctAudioSample = g_strctDraw.m_acMedia{g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_strctAudio.m_iMediaIndex    };
    strctAudioSample.m_afAudioData(:,2) = strctAudioSample.m_afAudioData(:,1);
    
    % fill up the buffer
    PsychPortAudio('FillBuffer', g_strctPTB.m_hAudioDevice, strctAudioSample.m_afAudioData');
    PsychPortAudio('Start',g_strctPTB.m_hAudioDevice,1,0,1); % Blocking (!!!)
end


if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bClearBefore
    Screen('FillRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afBackgroundColor);
end

aiTextureSize = [ g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_iWidth,g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_iHeight];
g_strctDraw.m_aiStimulusRect = fnComputeStimulusRectFTS(g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_fCueSizePix,aiTextureSize, ...
    g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_pt2fCuePosition);

	
if g_strctPTB.m_bRunningOnStimulusServer
	BitsPlusSetClut(hPTBWindow, g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.Clut);
else 
	Screen('FillRect',hPTBWindow, [128 128 128]);
end
Screen('DrawTexture', hPTBWindow, g_strctDraw.m_acMedia{g_strctDraw.m_iLocalMediaIndex}.m_hHandle,[],g_strctDraw.m_aiStimulusRect, 0);
% Overlay fixation?
if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bOverlayPreCueFixation
    fnDrawFixationSpot(hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod, false, 1);
end

if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bCueHighlight
    Screen('FrameRect',hPTBWindow, g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_afCueHighlightColor, g_strctDraw.m_aiStimulusRect,2);
end
if bFlip
    
    if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bDontFlip
        fCueOnsetTS =  GetSecs(); 
    else
        if g_strctDraw.m_strctCurrentTrial.m_strctCuePeriod.m_bClearAfter
            fCueOnsetTS = fnFlipWrapper(hPTBWindow); % This would block the server until the next flip.
        else
            % Don't clear the buffer. Next cue can potentially be drawn on the
            % same screen as well...
            fCueOnsetTS = fnFlipWrapper(hPTBWindow,0,1); % This would block the server until the next flip.
        end
    end
    
    if ~g_strctPTB.m_bRunningOnStimulusServer
        fCueOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
    end
else
    fCueOnsetTS  = NaN;
end


return;


