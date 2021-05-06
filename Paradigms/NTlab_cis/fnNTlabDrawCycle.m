function fnNTlabDrawCycle(acInputFromKofiko)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

%save('kofikoinput','acInputFromKofiko')
global g_strctPTB g_strctDraw g_strctServerCycle

fCurrTime = GetSecs();
%disp(acInputFromKofiko)
if ~isempty(acInputFromKofiko)
    strCommand = acInputFromKofiko{1};
    switch strCommand
        case 'PreloadMovie'
            movieFilePaths = acInputFromKofiko{2};
            
            Screen('OpenMovie', g_strctPTB.m_hWindow, movieFilePaths, 1);
            
        case 'ClearMemory'
            fnStimulusServerClearTextureMemory();
        case 'PauseButRecvCommands'
            if g_strctPTB.m_bInStereoMode
                Screen('SelectStereoDrawBuffer', g_strctPTB.m_hWindow,0); % Left Eye
                Screen(g_strctPTB.m_hWindow,'FillRect',0);
                Screen('SelectStereoDrawBuffer', g_strctPTB.m_hWindow,1); % Right Eye
                Screen(g_strctPTB.m_hWindow,'FillRect',0);
            else
                Screen(g_strctPTB.m_hWindow,'FillRect',0);
            end
            fnFlipWrapper(g_strctPTB.m_hWindow);
            g_strctServerCycle.m_iMachineState = 0;
            
        case 'LoadImageSetHandMapping'
            %feval(acInputFromKofiko{1}, acInputFromKofiko{2});
            %g_strctDraw.m_ahHandles = fnLoadImageSet({'LoadImageSet'}, acInputFromKofiko{2}, acInputFromKofiko{3});
            fnStimulusServerClearTextureMemory();
            
            Clut = zeros(256,3);
            normalColors = round(linspace(1,65535,256));
            [Clut(:,1), Clut(:,2), Clut(:,3)] = deal(normalColors);
            gammaTable = zeros(256,3);
            gammaVals = linspace(0,1,256);
            [gammaTable(:,1),gammaTable(:,2),gammaTable(:,3)]  = deal(gammaVals);
            Screen('LoadNormalizedGammaTable', g_strctPTB.m_hWindow, gammaTable);
            BitsPlusSetClut(g_strctPTB.m_hWindow, Clut);
            fnFlipWrapper(g_strctPTB.m_hWindow);
            [g_strctDraw.m_ahHandles, g_strctDraw.m_a2iTextureSize,...
                g_strctDraw.m_abIsMovie, g_strctDraw.m_aiApproxNumFrames, ~, g_strctDraw.m_acImages] = ...
                fnInitializeHandMappingTextures(acInputFromKofiko{2}, acInputFromKofiko{3});
            
            
        case 'InitializeHartleyTextures'
			%fnInitializeChoiceTextures(acInputsFromKofiko{2}, acInputsFromKofiko{3}, acInputsFromKofiko{4}, acInputsFromKofiko{5}, acInputsFromKofiko{6}, acInputsFromKofiko{7}, acInputsFromKofiko{8});
		    fnInitializeHartleyTextures(acInputFromKofiko{2}, acInputFromKofiko{3});
        
        case 'InitializeAchromCloudTextures'
			%fnInitializeChoiceTextures(acInputsFromKofiko{2}, acInputsFromKofiko{3}, acInputsFromKofiko{4}, acInputsFromKofiko{5}, acInputsFromKofiko{6}, acInputsFromKofiko{7}, acInputsFromKofiko{8});
		    fnInitializeAchromCloudTextures(acInputFromKofiko{2}, acInputFromKofiko{3}, acInputFromKofiko{4}, acInputFromKofiko{5});
        
        case 'InitializeChromCloudTextures'
			%fnInitializeChoiceTextures(acInputsFromKofiko{2}, acInputsFromKofiko{3}, acInputsFromKofiko{4}, acInputsFromKofiko{5}, acInputsFromKofiko{6}, acInputsFromKofiko{7}, acInputsFromKofiko{8});
		    fnInitializeChromCloudTextures(acInputFromKofiko{2}, acInputFromKofiko{3}, acInputFromKofiko{4}, acInputFromKofiko{5});
        
        case 'InitializeChromBarTextures'
			%fnInitializeChoiceTextures(acInputsFromKofiko{2}, acInputsFromKofiko{3}, acInputsFromKofiko{4}, acInputsFromKofiko{5}, acInputsFromKofiko{6}, acInputsFromKofiko{7}, acInputsFromKofiko{8});
		    fnInitializeChromBarTextures(acInputFromKofiko{2}, acInputFromKofiko{3}, acInputFromKofiko{4}, acInputFromKofiko{5});
        
        case 'LoadImageList'
            acFileNames = acInputFromKofiko{2};
            
            
            Screen(g_strctPTB.m_hWindow,'FillRect',1);
            
            
            
            fnFlipWrapper(g_strctPTB.m_hWindow);
            
            fnStimulusServerClearTextureMemory();
            
            [g_strctDraw.m_ahHandles, g_strctDraw.m_a2iTextureSize,...
                g_strctDraw.m_abIsMovie, g_strctDraw.m_aiApproxNumFrames, ~, g_strctDraw.m_acImages] = fnInitializeTexturesAux(acFileNames,false,true);
            
            fnStimulusServerToKofikoParadigm('AllImagesLoaded');
            g_strctServerCycle.m_iMachineState = 0;
            
        case 'LoadMovieSet'
            DirectoryPath = acInputFromKofiko{2};
            selectedMovieList = acInputFromKofiko{3};
            g_strctDraw.m_bLoadOnTheFly = acInputFromKofiko{4};
            
            Screen(g_strctPTB.m_hWindow,'FillRect',1);
            fnFlipWrapper(g_strctPTB.m_hWindow);
            
            fnStimulusServerClearTextureMemory();
            %  [g_strctDraw.m_ahHandles, g_strctDraw.m_a2iTextureSize,...
            %    g_strctDraw.m_abIsMovie, g_strctDraw.m_aiApproxNumFrames, Dummy, g_strctDraw.m_acImages] = fnInitializeTexturesAux(acFileNames,false,true);
            if ~g_strctDraw.m_bLoadOnTheFly
                [g_strctDraw.m_ahMovieHandles, g_strctDraw.m_acVideoData,...
                    g_strctDraw.m_abIsMovie] = fnLoadImageSet('LoadMovieSet', DirectoryPath, selectedMovieList);
            end
            
            fnStimulusServerToKofikoParadigm('AllImagesLoaded');
            g_strctServerCycle.m_iMachineState = 0;
            
            
            %case 'RequestLastShownTrialInformation'
            % send this trial, since it will have been shown by the time the next one is received
            %	g_strctServerCycle.m_iLastShownTrialID
            %	fnStimulusServerToKofikoParadigm('LastShownTrialRequestReply',g_strctServerCycle.m_iLastShownTrialID);
            
        case 'ShowTrial'
            %g_strctDraw.m_strctTrial = acInputFromKofiko{2};
            g_strctServerCycle.m_iLastShownTrialID = 1;
            if size(acInputFromKofiko{2},2) > 1
                
                g_strctDraw.m_strctPlannedTrials = acInputFromKofiko{2};
                g_strctDraw.m_strctTrial = g_strctDraw.m_strctPlannedTrials(g_strctServerCycle.m_iLastShownTrialID).trial;
                g_strctServerCycle.m_bUseSavedTrialsIfNecessary = true;
                
                %save('stim_server_inputs','g_strctDraw')
                switch g_strctDraw.m_strctTrial(1).m_strTrialType
                    
                    % Parse command type
                    case 'Moving Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Dual Stim'
                        g_strctServerCycle.m_iMachineState = 22;
                    case 'CI Handmapper'
                        g_strctServerCycle.m_iMachineState = 24;  
                    case 'Ground Truth'
                        g_strctServerCycle.m_iMachineState = 26;  
                    case 'Dense Noise'
                        g_strctServerCycle.m_iMachineState = 28; 
                    case 'Fivedot'
                        g_strctServerCycle.m_iMachineState = 30;
                    case 'OneD Noise'
                        g_strctServerCycle.m_iMachineState = 32; 
                    case 'Disc Probe'
                        g_strctServerCycle.m_iMachineState = 34;
                        
                    case 'Plain Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Color Tuning Function'
                        g_strctServerCycle.m_iMachineState = 13;
                    case 'Orientation Tuning Function'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Position Tuning Function'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Gabor'
                        g_strctServerCycle.m_iMachineState = 14;
                    case 'Moving Disc'
                        g_strctServerCycle.m_iMachineState = 16;
                    case 'Two Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Image'
                        g_strctServerCycle.m_iMachineState = 18;
                    case 'Movie'
                        g_strctServerCycle.m_iMachineState = 20;
                        
                    otherwise
                        assert(false);
                end
            else
                g_strctServerCycle.m_bUseSavedTrialsIfNecessary = false;
                % This will always be one, but having it set will let us use
                % the same code for saved or not saved trials
                g_strctDraw.m_strctTrial = acInputFromKofiko{2}.trial;
                % g_strctDraw.m_strctTrial = g_strctDraw.m_strctTrial.trial;
                g_strctServerCycle.m_iLastShownTrialID = 1;
                switch g_strctDraw.m_strctTrial.m_strTrialType
                    
                    % Parse command type
                    case 'Moving Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Dual Stim'
                        g_strctServerCycle.m_iMachineState = 22;
                    case 'CI Handmapper'
                        g_strctServerCycle.m_iMachineState = 24;
                    case 'Ground Truth'
                        g_strctServerCycle.m_iMachineState = 26;  
                    case 'Dense Noise'
                        g_strctServerCycle.m_iMachineState = 28;
                    case 'Fivedot'
                        g_strctServerCycle.m_iMachineState = 30;
                    case 'OneD Noise'
                        g_strctServerCycle.m_iMachineState = 32;
                    case 'Disc Probe'
                        g_strctServerCycle.m_iMachineState = 34;
                        
                    case 'Plain Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Color Tuning Function'
                        g_strctServerCycle.m_iMachineState = 13;
                    case 'Orientation Tuning Function'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Position Tuning Function'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Gabor'
                        g_strctServerCycle.m_iMachineState = 14;
                    case 'Moving Disc'
                        g_strctServerCycle.m_iMachineState = 16;
                    case 'Two Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                    case 'Image'
                        g_strctServerCycle.m_iMachineState = 18;
                    case 'Movie'
                        g_strctServerCycle.m_iMachineState = 20;
                    case 'Many Bar'
                        g_strctServerCycle.m_iMachineState = 11;
                        
                    otherwise
                         assert(false);
                end
            end
            
    end
end;

if g_strctServerCycle.m_bUseSavedTrialsIfNecessary && g_strctServerCycle.m_iMachineState == 0
    fCurrTime  = GetSecs();
    %fCurrTime - g_strctServerCycle.m_fLastFlipTime
    %(.9 * (1/g_strctPTB.m_iRefreshRate) )
    fCurrTime - g_strctServerCycle.m_fLastFlipTime;
    if (fCurrTime - g_strctServerCycle.m_fLastFlipTime) > ...
            (.8 * (1/g_strctPTB.m_iRefreshRate) )
        %disp('next saved trial triggered')
        % 80% of the time to the next trial flip has occurred, time to fall back on the saved trial
        g_strctServerCycle.m_iLastShownTrialID = g_strctServerCycle.m_iLastShownTrialID + 1;
        
        if g_strctServerCycle.m_iLastShownTrialID > size(g_strctDraw.m_strctPlannedTrials,2)
            % disaster. We ran out of saved trials even planning ahead, something must be wrong but
            % we might as well keep the stim server alive
            g_strctServerCycle.m_bUseSavedTrialsIfNecessary = 0;
            
            
        else
            
            if ~isempty(acInputFromKofiko) && strcmp(acInputFromKofiko{1},'RequestLastShownTrialInformation')
                % send this trial, since it will have been shown by the time the next one is received
                g_strctServerCycle.m_iLastShownTrialID
                fnStimulusServerToKofikoParadigm('LastShownTrialRequestReply',g_strctServerCycle.m_iLastShownTrialID);
            end
            
            g_strctDraw.m_strctTrial = g_strctDraw.m_strctPlannedTrials(g_strctServerCycle.m_iLastShownTrialID).trial;
            
            
            %fnStimulusServerToKofikoParadigm('LastShownTrialInfo',g_strctServerCycle.m_iLastShownTrialID);
            % I can't imagine a case where the next saved trial will be a different type,
            % but that Josh guy is one crazy mofo and who knows what he'll do next
            switch g_strctDraw.m_strctTrial.m_strTrialType
                case 'Moving Bar'
                    g_strctServerCycle.m_iMachineState = 11;
                case 'Dual Stim'
                    g_strctServerCycle.m_iMachineState = 22;
                case 'CI Handmapper'
                    g_strctServerCycle.m_iMachineState = 24;
                case 'Ground Truth'
                    g_strctServerCycle.m_iMachineState = 26;  
                case 'Dense Noise'
                    g_strctServerCycle.m_iMachineState = 28;
                case 'Fivedot'
                    g_strctServerCycle.m_iMachineState = 30;
                case 'OneD Noise'
                    g_strctServerCycle.m_iMachineState = 32;
                case 'Disc Probe'
                    g_strctServerCycle.m_iMachineState = 34;

                case 'Plain Bar'
                    g_strctServerCycle.m_iMachineState = 11;
                case 'Color Tuning Function'
                    g_strctServerCycle.m_iMachineState = 13;
                case 'Orientation Tuning Function'
                    g_strctServerCycle.m_iMachineState = 11;
                case 'Position Tuning Function'
                    g_strctServerCycle.m_iMachineState = 11;
                case 'Gabor'
                    g_strctServerCycle.m_iMachineState = 14;
                case 'Moving Dots'
                    g_strctServerCycle.m_iMachineState = 16;
                case 'Two Bar'
                    g_strctServerCycle.m_iMachineState = 11;
                case 'Image'
                    g_strctServerCycle.m_iMachineState = 20;
                case 'Movie'
                    
                    
                otherwise
                    assert(false);
            end
        end
    end
    
    
    
end


switch g_strctServerCycle.m_iMachineState
    % Kept these other command states in in case we want them for mapping at some point
    case 0
        % Do nothing
    case 3
        fnWaitOffPeriod();
    case 11
        %g_strctServerCycle.m_iMachineState = 0;
        fnDisplayMovingBar(); % Can also display static bar, if move_distance is set to zero
    case 12
        fnKeepDisplayingMovingBar();
    case 13
        fnColorTuningFunction();
    case 14
        fnDisplayGabor();
    case 15
        %[g_strctDraw, g_strctPTB, g_strctServerCycle] = fnKeepDisplayingGabor(g_strctDraw, g_strctPTB, g_strctServerCycle); % Not implemented, all gabors are updated every frame atm
    case 16
        fnDisplayMovingDots();
    case 17
        fnKeepDisplayingMovingDots();
    case 18
        fnDisplayImage();
    case 19
        fnKeepDisplayingImage();
    case 20
        fnDisplayMovie();
    case 21
        fnKeepDisplayingMovie();
    case 22
        fnDisplayDualstim();
    case 23
        fnKeepDisplayingDualstim();
    case 24
        fnDisplayCIHandmapper();
    case 25
        fnKeepDisplayingCIHandmapper();
    case 26
        fnDisplayGroundtruth();
    case 27
        fnKeepDisplayingGroundtruth();
    case 28
        fnDisplayDensenoise();
    case 29
        fnKeepDisplayingDensenoise();
    case 30
        fnDisplayFivedot();
    case 31
        fnKeepDisplayingFivedot();
    case 32
        fnDisplayOneDnoise();
    case 33
        fnKeepDisplayingOneDnoise();    
    case 34
        fnDisplayDiscProbe();
    case 35
        fnKeepDisplayingDiscProbe();
end;

return;


function fnWaitOffPeriod()
global g_strctDraw g_strctPTB g_strctServerCycle
fCurrTime  = GetSecs();
if (fCurrTime - g_strctServerCycle.m_fLastFlipTime) > ...
        (g_strctDraw.m_strctTrial.m_fStimulusOFF_MS)/1e3 - (0.2 * (1/g_strctPTB.m_iRefreshRate) )
    fnStimulusServerToKofikoParadigm('TrialFinished');
    g_strctServerCycle.m_iMachineState = 0;
end
return;







% Excerpted code from passive fixation paradigm
%
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------



function fnDisplayMovingBar()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')
%sprintf('dkl ID = %i',g_strctDraw.m_strctTrial.m_iCurrentlySelectedDKLCoordinateID)

fCurrTime  = GetSecs();

% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
g_strctDraw.m_iFrameCounter = 1;

%if strcmp(g_strctDraw.m_strctTrial.m_strTrialType, 'Moving Bar') && g_strctDraw.m_strctTrial.m_bFlipForegroundBackground
%Screen('FillRect',g_strctPTB.m_hWindow, [2 2 2]);
%else
Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%end
%{
if ~g_strctDraw.m_strctTrial.m_bBlur
	for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
		if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
		Screen('FillPoly',g_strctPTB.m_hWindow, [2 2 2],...
			horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,1,iNumOfBars),g_strctDraw.m_strctTrial.coordinatesY(1:4,1,iNumOfBars)),0)
			
		else
		Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiStimColor,...
			horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,1,iNumOfBars),g_strctDraw.m_strctTrial.coordinatesY(1:4,1,iNumOfBars)),0)
			end
	end
else
%}
if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
    for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
        for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
            
            
            if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                
                
                
                Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep,g_strctDraw.m_iFrameCounter),...
                    horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                    g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                
            end
        end
    end
    
else
    for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
        for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
            
            
            if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep),...
                    horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                    g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
            end
        end
    end
end

if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar')
    
    %if strcmp(g_strctDraw.m_strctTrial.m_strTrialType, 'Moving Bar') && g_strctDraw.m_strctTrial.m_bFlipForegroundBackground
    %	Screen('FillRect', g_strctPTB.m_hWindow, [2 2 2], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
    if  g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
        Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
    end
end


% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end



if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);


g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking


if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end
% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 12;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    %fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end

return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


function fnKeepDisplayingMovingBar()
global g_strctPTB g_strctDraw g_strctServerCycle

fCurrTime  = GetSecs();
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
% check if there are more frames to display
g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
if g_strctDraw.m_iFrameCounter >= g_strctDraw.m_strctTrial.numFrames; % we shouldn't be able to get larger than this number, but just in case
    
    % Clear the screen
    %Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
    
    if strcmp(g_strctDraw.m_strctTrial.m_strTrialType, 'Moving Bar') && g_strctDraw.m_strctTrial.m_bFlipForegroundBackground
        %disp('triggered')
        %
        if g_strctDraw.m_strctTrial.numberBlurSteps > 1
            %	x(1,1) = [1,2,3,];
            
            Screen('FillRect',g_strctPTB.m_hWindow, [ones(1,3) * 3+g_strctDraw.m_strctTrial.numberBlurSteps-2]);
            
        else
            Screen('FillRect',g_strctPTB.m_hWindow, [2 2 2]);
        end
        
    else
        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    end
    %Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    
    
    %Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
    
    if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
        Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
            [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
            g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
            g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
    end
    
    if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
    else
        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
    end
    
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
    Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
    Screen('Close',ClutTextureIndex);
    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
    % Set the machine to the wait off period and send the flip off command
    
    g_strctServerCycle.m_iMachineState = 3;
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
    
else
    % Display the next frame of the bar
    
    fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter)
    %Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
    
    %if strcmp(g_strctDraw.m_strctTrial.m_strTrialType, 'Moving Bar') && g_strctDraw.m_strctTrial.m_bFlipForegroundBackground
    %	Screen('FillRect',g_strctPTB.m_hWindow, [2 2 2]);
    %else
    
    %if  g_strctDraw.m_strctTrial.m_bFlipForegroundBackground
    
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    %end
    
    
    %{
	if ~g_strctDraw.m_strctTrial.m_bBlur
		for iNumBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
			Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiStimColor,...
				 horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumBars),g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumBars)),0)
		end
	else
    %}
    
    if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
        
        for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
            
            for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                    Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                        horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                        g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
                end
            end
        end
    else
        for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
            for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                    Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                        horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                        g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
                end
            end
        end
        
        
    end
    
    
    %end
    if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
        %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
    end
    %{
	if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
		Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
	end
    %}
    % Fixation point last so it's on top
    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
    %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
    if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
        Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
            [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
            g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
            g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
    end
    if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
        if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
        end
    else
        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,1));
    end
    
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
    Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
    Screen('Close',ClutTextureIndex);
    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
    
    % Update information
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
        g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary
    
end
return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


function fnDisplayFivedot()
global g_strctPTB g_strctDraw g_strctServerCycle

fCurrTime  = GetSecs();

g_strctDraw.m_iFrameCounter=1;

aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

% if sum(g_strctDraw.m_strctTrial.m_aiCLUT(2,:))==0
%     g_strctDraw.m_strctTrial.m_aiCLUT(2,:)=[round(127*(65535/255)),round(127*(65535/255)),round(127*(65535/255))];
% end
% Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);

Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
%sprintf(num2str(g_strctDraw.m_strctTrial.m_afBackgroundColor));

%define and draw current fixation spot
pt2fFixationSpotPix = g_strctDraw.m_strctTrial.apt2iFixationSpots(g_strctDraw.m_strctTrial.targspot,:);
    fFixationSizePix = round(g_strctDraw.m_strctTrial.fFixationSizePix/2);
aiFixationSpot =  [pt2fFixationSpotPix(1) - fFixationSizePix,...
    pt2fFixationSpotPix(2) - fFixationSizePix,...
    pt2fFixationSpotPix(1) + fFixationSizePix,...
    pt2fFixationSpotPix(2) + fFixationSizePix];

%Screen(g_strctPTB.m_hWindow,'FillArc',[255 255 255], aiFixationSpot,0,360);
%Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationSpot,0,360);
Screen(g_strctPTB.m_hWindow,'FillArc',g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationSpot,0,360);

% deal with internal updating stuff
if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT); 
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow, 0, 0, 2); % Time onset of trial, blocking

if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 31;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end

% Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_afBackgroundColor, g_strctPTB.m_aiRect);
% aiFixationSpot = [...
%     g_strctDraw.m_pt2fPos(1) - g_strctDraw.m_fSize,...
%     g_strctDraw.m_pt2fPos(2) - g_strctDraw.m_fSize,...
%     g_strctDraw.m_pt2fPos(1) + g_strctDraw.m_fSize,...
%     g_strctDraw.m_pt2fPos(2) + g_strctDraw.m_fSize];
% 
% Screen(g_strctPTB.m_hWindow,'FillArc',[255 255 255], aiFixationSpot,0,360);
% g_strctServerCycle.m_iMachineState = 0;
% 
% g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow, 0, 0, 2);
%         
return

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

    function fnKeepDisplayingFivedot()
    global g_strctPTB g_strctDraw g_strctServerCycle

    fCurrTime  = GetSecs();
    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];

    Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);

    pt2fFixationSpotPix = g_strctDraw.m_strctTrial.apt2iFixationSpots(g_strctDraw.m_strctTrial.targspot,:);
    fFixationSizePix = round(g_strctDraw.m_strctTrial.fFixationSizePix/2);
    aiFixationSpot =  [pt2fFixationSpotPix(1) - fFixationSizePix,...
        pt2fFixationSpotPix(2) - fFixationSizePix,...
        pt2fFixationSpotPix(1) + fFixationSizePix,...
        pt2fFixationSpotPix(2) + fFixationSizePix];
    %Screen(g_strctPTB.m_hWindow,'FillArc',[255 255 255], aiFixationSpot,0,360);
    %Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationSpot,0,360);
    Screen(g_strctPTB.m_hWindow,'FillArc',g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationSpot,0,360);

%    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
%        if g_strctDraw.m_iFrameCounter < g_strctDraw.m_strctTrial.numFrames % Felix test for keeping stims on screen
%         dbstop if warning
%         warning('stop')
%         end

    if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
        Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
            [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
            g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
            g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
    end
    
    % Update information
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
%    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,1)); 
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
    Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
    Screen('Close',ClutTextureIndex);

    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
        g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

    % Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_afBackgroundColor, g_strctPTB.m_aiRect);
    % aiFixationSpot = [...
    %     g_strctDraw.m_pt2fPos(1) - g_strctDraw.m_fSize,...
    %     g_strctDraw.m_pt2fPos(2) - g_strctDraw.m_fSize,...
    %     g_strctDraw.m_pt2fPos(1) + g_strctDraw.m_fSize,...
    %     g_strctDraw.m_pt2fPos(2) + g_strctDraw.m_fSize];
    % 
    % Screen(g_strctPTB.m_hWindow,'FillArc',[255 255 255], aiFixationSpot,0,360);
    % g_strctServerCycle.m_iMachineState = 0;
    % 
    % g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow, 0, 0, 2);
    %       
%     dbstop if warning
%     warning('stop')
    
    return

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

%{
function fnDisplayDualstim()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')

fCurrTime  = GetSecs();
% if  g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
%     Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
% end
    
% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation

% Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
% Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);

if g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==1 % achromatic cloud
    hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==2 %color cloud
    hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud<=2 % use bar stimuli    
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
% %    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
%     hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
% elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud>=3 & g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud<=6 %achromatic hartleys
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%     hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
end
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0,0);
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0,0);

% draw primary stim
if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==0
    for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
        for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
            if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iNumOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                    horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                    g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
            end
        end
    end
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==1 % achromatic cloud
    hImageID2 = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==2 %color cloud
    hImageID2 = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
% elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=2 % use bar stimuli    
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
% %    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
%     hImageID2 = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
% Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
% elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=3 & g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=6 %achromatic hartleys
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%     hImageID2 = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
end

% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

if g_strctDraw.m_strctTrial.m_bUseGaussianPulses & g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>2
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
% elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=2
%     ClutEncoded = BitsPlusEncodeClutRow( squeeze(g_strctDraw.m_strctTrial.m_aiCLUT(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter),:,:)) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 23;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end

%{
fCurrTime  = GetSecs();
Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);

% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation

Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);

% redraw here?
%[cur_peristim, ~]=GenerateTernaryStim(.25, 1, 0); 
% Draw peripheral stimulus
if g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==1
    hImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  g_strctDraw.m_strctTrial.DualStimSecondary_disp(:,:,g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0);
    Screen('Close',hImageID);
    
else
    hImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  g_strctDraw.m_strctTrial.DualStimSecondary_disp(:,:,g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
    Screen('Close',hImageID);
end
% felix added 4 dualstim
if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==1
    mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.DualStimPrimaryCloud(:,:,g_strctDraw.m_iFrameCounter,:)));
%    mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  rgb2ldrgyv(squeeze(g_strctDraw.m_strctTrial.DualStimPrimaryCloud(:,:,g_strctDraw.m_iFrameCounter,:))));
    Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
    Screen('Close',mImageID);

else
 % if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
	   %{
	   strctTrial.NSmClutIndex
	   strctTrial.NSpClutIndex
	   strctTrial.NMmClutIndex
	   strctTrial.NMpClutIndex
	   strctTrial.NLmClutIndex
	   strctTrial.NLpClutIndex
	   %}
%             for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iActiveStimulusBars
% 				iBlurStep = 1;
%                 %for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
%                     if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
%                         Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iNumOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
%                             horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
%                             g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
%                     end
%                % end
%     
%             end
            iNumOfBars=1;
            for iColOfBars = g_strctDraw.m_strctTrial.m_iBarPresentationOrder; % 1:g_strctDraw.m_strctTrial.m_iActiveStimulusBars
                if g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars)>0
                    for inumCisBars=1:g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars) %Felix note: not yet finished!!!
                        for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                            if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                                Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iColOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                                    horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                                    g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                            end
                        end
                    iNumOfBars=iNumOfBars+1;
                    end
                end
            end
    %{
else
    for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
        for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
            
            % fELIX NOTE - ADD LOOP FOR COLOR ADJUSTMENT HERE
            if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep),...
                    horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                    g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
            end
        end
    end
end
%}
end %end Rgb cloud if statement

% if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') %Felix
% commented out
%     
%     if  g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
%         Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
%     end
% end


% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end



if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);


g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking


if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 23;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end
%crashvar = lololol(15);
%}
return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


    function fnKeepDisplayingDualstim()
    global g_strctPTB g_strctDraw g_strctServerCycle

        g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
    

    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && g_strctDraw.m_strctTrial.ContinuousDisplay; % we shouldn't be able to get larger than this number, but just in case
       g_strctServerCycle.m_iMachineState = 3;
       fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
       return
       
    elseif g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && ~g_strctDraw.m_strctTrial.ContinuousDisplay; % we shouldn't be able to get larger than this number, but just in case
            
%        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
%         if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=6 % use bar stimuli or hartleys   
%             Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%         elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=7 % cloud
            Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%        end
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
        % Set the machine to the wait off period and send the flip off command

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);
        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
        if g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==1 % achromatic cloud
            hImageID2 = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
        elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==2 %color cloud
            hImageID2 = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
        % elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud<=2 % use bar stimuli    
        %     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        % %    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
        %     hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
        % elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud>=3 & g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud<=6 %achromatic hartleys
        %     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        %     hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
        end
        Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0,0);
        Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0,0);
       
        % draw primary stim
        if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==0
            for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
                for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                    if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                        Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iNumOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                            horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                            g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                    end
                end
            end
        elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==1 % achromatic cloud
            hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
            Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
        elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==2 %color cloud
            hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
            Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
        % elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=2 % use bar stimuli    
        %     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        % %    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
        %     hImageID2 = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
        % Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
        % elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=3 & g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=6 %achromatic hartleys
        %     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        %     hImageID2 = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
        % Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
        end
        

        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end

        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
            
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses & g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>2
                    if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
                        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
                    end
%         elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=2
%             ClutEncoded = BitsPlusEncodeClutRow( squeeze(g_strctDraw.m_strctTrial.m_aiCLUT(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter),:,:)) );
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
%        fliptracker=[fliptracker g_strctServerCycle.m_fLastFlipTime];
        
        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

    end
    
    %{
    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter >= g_strctDraw.m_strctTrial.numFrames; % we shouldn't be able to get larger than this number, but just in case

        % Clear the screen
        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
%{
%         if strcmp(g_strctDraw.m_strctTrial.m_strTrialType, 'Moving Bar') && g_strctDraw.m_strctTrial.m_bFlipForegroundBackground
%             %disp('triggered')
%             %
%             if g_strctDraw.m_strctTrial.numberBlurSteps > 1
%                 %	x(1,1) = [1,2,3,];
% 
%                 Screen('FillRect',g_strctPTB.m_hWindow, [ones(1,3) * 3+g_strctDraw.m_strctTrial.numberBlurSteps-2]);
% 
%             else
%                 Screen('FillRect',g_strctPTB.m_hWindow, [2 2 2]);
%             end
% 
%         else
%             Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%         end 
%}
        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);


        %Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
        % Set the machine to the wait off period and send the flip off command

        g_strctServerCycle.m_iMachineState = 3;
        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);
        %Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);

        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        
        
        if g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==1
            hImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  round((65535/255)*(g_strctDraw.m_strctTrial.DualStimSecondary(:,:,g_strctDraw.m_iFrameCounter))));
            Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0);
            Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0);
            Screen('Close',hImageID);
        else
            hImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  (g_strctDraw.m_strctTrial.DualStimSecondary_disp(:,:,g_strctDraw.m_iFrameCounter)));
            Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
            Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
            Screen('Close',hImageID);
        end    
        

    % If switching between Cloud and bars
    if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==1
        mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  round((65535/255)*(squeeze(g_strctDraw.m_strctTrial.DualStimPrimaryCloud(:,:,g_strctDraw.m_iFrameCounter,:)))));
        Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
        Screen('Close',mImageID);

    else
       % if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
	   %{
	   strctTrial.NSmClutIndex
	   strctTrial.NSpClutIndex
	   strctTrial.NMmClutIndex
	   strctTrial.NMpClutIndex
	   strctTrial.NLmClutIndex
	   strctTrial.NLpClutIndex
	   %}
            iNumOfBars=1;
            for iColOfBars = g_strctDraw.m_strctTrial.m_iBarPresentationOrder; % 1:g_strctDraw.m_strctTrial.m_iActiveStimulusBars
                if g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars)>0
                    for inumCisBars=1:g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars) %Felix note: not yet finished!!!
                        for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                            if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                                Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iColOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                                    horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                                    g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                            end
                        end
                    iNumOfBars=iNumOfBars+1;
                    end
                end
            end
            
       % else
	   %{
            for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
                for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                    if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                        Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                            horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                            g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
                    end
                end
            end
%}

       % end
    end %end Cloud stim switch

        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end
        
        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end
        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
                ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
            end
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,1));
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
%        if g_strctDraw.m_iFrameCounter < g_strctDraw.m_strctTrial.numFrames % Felix test for keeping stims on screen
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
%         dbstop if warning
%         warning('stop')
%         end
        
        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

        
    end
    %}
return;
%}
function fnDisplayDualstim()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')

fCurrTime  = GetSecs();
% if  g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
%     Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
% end
    
% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation

Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
% 
if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==0 % use ground truth
    iBlurStep=1;
    for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
        if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
            Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
        end
    end
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=1 && g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=2 % use bar stimuli    
%    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=3 && g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=6 %achromatic hartleys
%    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==7 % achromatic cloud
%    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==8 %color cloud
%    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
end
%hImageID = g_strctDraw.hartleys_disp(randi(1188));
%Screen('Close',hImageID);

% TODO: code up the sequence for secondary stims too
% Draw peripheral stimulus
if g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==0

    %Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
    %Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==1
    hImageID2 = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq_ET(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0);
%    Screen('Close',hImageID);
elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==2
    hImageID2 = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0);
%    Screen('Close',hImageID);
end

if g_strctDraw.m_strctTrial.CSDtrigframe && g_strctDraw.m_iFrameCounter<=3
    Screen('FillRect',g_strctPTB.m_hWindow, [256 256 256], g_strctDraw.m_strctTrial.m_aiStimulusRect);
end

% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

% if g_strctDraw.m_strctTrial.m_bUseGaussianPulses & g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>2
%     ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
% elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=2
%     ClutEncoded = BitsPlusEncodeClutRow( squeeze(g_strctDraw.m_strctTrial.m_aiCLUT(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter),:,:)) );
% else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
% end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 23;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end


% dbstop if warning
% warning('big oof')
return
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

   function fnKeepDisplayingDualstim()
    global g_strctPTB g_strctDraw g_strctServerCycle
%     persistent fliptracker
%     if isempty(fliptracker)
%         fliptracker=zeros(1,10000);
%     end
    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
    

    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && g_strctDraw.m_strctTrial.ContinuousDisplay; % we shouldn't be able to get larger than this number, but just in case
       g_strctServerCycle.m_iMachineState = 3;
       fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
       return
       
    elseif g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && ~g_strctDraw.m_strctTrial.ContinuousDisplay; % we shouldn't be able to get larger than this number, but just in case
            
%        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
%         if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=6 % use bar stimuli    
%             Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%         elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=7 % achromatic cloud
            Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%        end
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
        % Set the machine to the wait off period and send the flip off command

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);
        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);

%        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);

% felix added 4 dense noise - working code
% mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.Densenoisestim_disp(:,:,g_strctDraw.m_iFrameCounter,:)));
% Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',mImageID);

% Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.mImageID(g_strctDraw.m_iFrameCounter),[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',g_strctDraw.mImageID(g_strctDraw.m_iFrameCounter));
%     dbstop if warning
%     warning('stop')

if g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==0 % use ground truth
    iBlurStep=1;
    for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
        if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
            Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iBlurStep),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0)
        end
    end
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=1 && g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=2 % use bar stimuli    
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>=3 && g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=6 %achromatic hartleys
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==7 % achromatic cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud==8 %color cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
end

%hImageID = g_strctDraw.hartleys_disp(randi(1188));
%Screen('Close',hImageID);

if g_strctDraw.m_strctTrial.CSDtrigframe && g_strctDraw.m_iFrameCounter<=3
    Screen('FillRect',g_strctPTB.m_hWindow, [256 256 256], g_strctDraw.m_strctTrial.m_aiStimulusRect);
end

if g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==0

    %Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
    %Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect, g_strctDraw.m_strctTrial.DualStimSecondaryori(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==1
    hImageID2 = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq_ET(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0);
%    Screen('Close',hImageID);
elseif g_strctDraw.m_strctTrial.DualstimSecondaryUseCloud==2
    hImageID2 = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.secondarystim_bar_rect,0);
    Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID2,[],g_strctDraw.m_strctTrial.tertiarystim_bar_rect,0);
%    Screen('Close',hImageID);
end
        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end

        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
            
        end

%         if g_strctDraw.m_strctTrial.m_bUseGaussianPulses & g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud>2
%                     if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
%                         ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
%                     end
%         elseif g_strctDraw.m_strctTrial.DualstimPrimaryuseRGBCloud<=2
%             ClutEncoded = BitsPlusEncodeClutRow( squeeze(g_strctDraw.m_strctTrial.m_aiCLUT(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter),:,:)) );
%         else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
%         end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
%        fliptracker=[fliptracker g_strctServerCycle.m_fLastFlipTime];
        
        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

        
    end
% if  g_strctDraw.m_iFrameCounter>=100    
%     dbstop if warning
%     warning('stop')
% end
return;
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


function fnDisplayCIHandmapper()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')

fCurrTime  = GetSecs();

% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation
%Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
Screen('FillRect',g_strctPTB.m_hWindow, [g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor]);

%{
iNumOfBars=1;
for iColOfBars = g_strctDraw.m_strctTrial.m_iBarPresentationOrder; % 1:g_strctDraw.m_strctTrial.m_iActiveStimulusBars
    if g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars)>0
        for inumCisBars=1:g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars) %Felix note: not yet finished!!!
            for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                    Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iColOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                        horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                        g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                end
            end
        iNumOfBars=iNumOfBars+1;
        end
    end
end
%}


for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
    for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
        if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
            Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,1,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
        end
    end
end

% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);


g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking


if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 25;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end
%crashvar = lololol(15);
return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


    function fnKeepDisplayingCIHandmapper()
    global g_strctPTB g_strctDraw g_strctServerCycle

    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter >= g_strctDraw.m_strctTrial.numFrames; % we shouldn't be able to get larger than this number, but just in case

%Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
Screen('FillRect',g_strctPTB.m_hWindow, [g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor]);


        %Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
        % Set the machine to the wait off period and send the flip off command

        g_strctServerCycle.m_iMachineState = 3;
        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);
        %Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
        %Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        Screen('FillRect',g_strctPTB.m_hWindow, [g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor]);

    % If switching between Cloud and bars

        %{
        iNumOfBars=1;
        for iColOfBars = g_strctDraw.m_strctTrial.m_iBarPresentationOrder; % 1:g_strctDraw.m_strctTrial.m_iActiveStimulusBars
            if g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars)>0
                for inumCisBars=1:g_strctDraw.m_strctTrial.numofeachCIS(iColOfBars) %Felix note: not yet finished!!!
                    for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                        if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                            Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iColOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                                horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                                g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                        end
                    end
                iNumOfBars=iNumOfBars+1;
                end
            end
        end
        %}


        for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
            for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                    Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,1,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                        horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                        g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                end
            end
        end

        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            %Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect',g_strctPTB.m_hWindow, [g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor g_strctDraw.m_strctTrial.BGtargcolor],g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end

        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
            
        end
        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
                ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
            end
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,1));
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

        
    end
    return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------



function fnDisplayGroundtruth()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')

fCurrTime  = GetSecs();

% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

if sum(g_strctDraw.m_strctTrial.m_aiCLUT(2,:))==0
    g_strctDraw.m_strctTrial.m_aiCLUT(2,:)=[round(127*(65535/255)),round(127*(65535/255)),round(127*(65535/255))];
end
g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation
Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);


for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
    for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
        if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
            Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iNumOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
        end
    end
end

% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);


g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking


if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 27;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end
%crashvar = lololol(15);
return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


    function fnKeepDisplayingGroundtruth()
    global g_strctPTB g_strctDraw g_strctServerCycle

    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];

    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter >= g_strctDraw.m_strctTrial.numFrames; % we shouldn't be able to get larger than this number, but just in case

        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        
%        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
        %Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
        % Set the machine to the wait off period and send the flip off command

        g_strctServerCycle.m_iMachineState = 3;
        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);

        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%       Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
%     
%  dbstop if warning 
%  warning('stop')

        for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
            for iBlurStep = 1:g_strctDraw.m_strctTrial.numberBlurSteps
                if any(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep))
                    Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiBlurStepHolder(:,iNumOfBars,g_strctDraw.m_iFrameCounter),...%,g_strctDraw.m_strctTrial.m_aiBlurStepHolder(2,iBlurStep),g_strctDraw.m_strctTrial.m_aiBlurStepHolder(3,iBlurStep)] ,...
                        horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep),...
                        g_strctDraw.m_strctTrial.coordinatesY(1:4,g_strctDraw.m_iFrameCounter,iNumOfBars,iBlurStep)),0);
                end
            end
        end

        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end

        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
            
        end
        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
                ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
            end
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,1));
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

        
    end
return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

function fnDisplayDensenoise()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')

fCurrTime  = GetSecs();
% if  g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
%     Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
% end
    
% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation

Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
% 
%     if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
%         %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
%         Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
%     end
    
% felix added 4 dense noise - working code
% mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.Densenoisestim_disp(:,:,g_strctDraw.m_iFrameCounter,:)));
% Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',mImageID);


% for mImage=1:size(g_strctDraw.m_strctTrial.Densenoisestim_disp,3);
% g_strctDraw.mImageID(mImage) = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.Densenoisestim_disp(:,:,mImage,:)));
% end
% Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.mImageID(1),[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',g_strctDraw.mImageID(1));

if g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=2 % use bar stimuli    
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>=3 & g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=6 %achromatic hartleys
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==7 % achromatic cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==8 %color cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
end
%hImageID = g_strctDraw.hartleys_disp(randi(1188));
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
%Screen('Close',hImageID);

if g_strctDraw.m_strctTrial.CSDtrigframe && g_strctDraw.m_iFrameCounter<=3
    Screen('FillRect',g_strctPTB.m_hWindow, [256 256 256], g_strctDraw.m_strctTrial.m_aiStimulusRect);
end

% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

if g_strctDraw.m_strctTrial.m_bUseGaussianPulses & g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>2
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=2
    ClutEncoded = BitsPlusEncodeClutRow( squeeze(g_strctDraw.m_strctTrial.m_aiCLUT(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter),:,:)) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 29;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end


% dbstop if warning
% warning('big oof')
return
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

   function fnKeepDisplayingDensenoise()
    global g_strctPTB g_strctDraw g_strctServerCycle
%     persistent fliptracker
%     if isempty(fliptracker)
%         fliptracker=zeros(1,10000);
%     end
    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
    

    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && g_strctDraw.m_strctTrial.ContinuousDisplay; % we shouldn't be able to get larger than this number, but just in case
       g_strctServerCycle.m_iMachineState = 3;
       fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
       return
       
    elseif g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && ~g_strctDraw.m_strctTrial.ContinuousDisplay; % we shouldn't be able to get larger than this number, but just in case
            
%        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
        if g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=6 % use bar stimuli    
            Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
        elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>=7 % achromatic cloud
            Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
        end
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[0 0 0], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,end ));
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT);
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
        % Set the machine to the wait off period and send the flip off command

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);
        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);

        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);

% felix added 4 dense noise - working code
% mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.Densenoisestim_disp(:,:,g_strctDraw.m_iFrameCounter,:)));
% Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',mImageID);

% Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.mImageID(g_strctDraw.m_iFrameCounter),[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',g_strctDraw.mImageID(g_strctDraw.m_iFrameCounter));
%     dbstop if warning
%     warning('stop')

if g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=2 % use bar stimuli    
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
    hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.cur_oribin);
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>=3 & g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=6 %achromatic hartleys
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==7 % achromatic cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==8 %color cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
end
%{
if g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==4 % achromatic cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==1 %achromatic hartleys
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
    hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==2 %color hartleys
    Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);    
    hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==3 %color cloud
    Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
    hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
end
%}

%hImageID = g_strctDraw.hartleys_disp(randi(1188));
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,0,0);
%Screen('Close',hImageID);

if g_strctDraw.m_strctTrial.CSDtrigframe && g_strctDraw.m_iFrameCounter<=3
    Screen('FillRect',g_strctPTB.m_hWindow, [256 256 256], g_strctDraw.m_strctTrial.m_aiStimulusRect);
end
        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end

        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
            
        end

        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses & g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud>2
                    if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
                        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
                    end
        elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud<=2
            ClutEncoded = BitsPlusEncodeClutRow( squeeze(g_strctDraw.m_strctTrial.m_aiCLUT(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter),:,:)) );
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
%        fliptracker=[fliptracker g_strctServerCycle.m_fLastFlipTime];
        
        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

        
    end
% if  g_strctDraw.m_iFrameCounter>=100    
%     dbstop if warning
%     warning('stop')
% end
return;
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

function fnDisplayOneDnoise()
global g_strctPTB g_strctDraw g_strctServerCycle
% 	dbstop if warning
% 	warning('stop')

fCurrTime  = GetSecs();
    
% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

g_strctDraw.m_iFrameCounter = 1; %to keep changing stimulus orientation

Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);

% felix added 4 dense noise - working code
% mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.Densenoisestim_disp(:,:,g_strctDraw.m_iFrameCounter,:)));
% Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',mImageID);

% previosu code: induces crashes after about 10 mins of data
%{
tic
for mImage=1:size(g_strctDraw.m_strctTrial.stimuli,1);
g_strctDraw.mImageID(mImage) = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.stimuli(mImage,:,:)));
end
Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.mImageID(1),[],g_strctDraw.m_strctTrial.m_aiStimulusRect,g_strctDraw.m_strctTrial.orientation,0);
%Screen('Close',g_strctDraw.mImageID(1));
toc
%}
hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,g_strctDraw.m_strctTrial.orientation,0);

% if g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==4 % achromatic cloud
%     Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%     hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==1 %achromatic hartleys
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%     hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==2 %color hartleys
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);    
%     hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==3 %color cloud
%     Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%     hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% end
% %hImageID = g_strctDraw.hartleys_disp(randi(1188));
% Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% %Screen('Close',hImageID);

% Fixation point last so it's on top
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end

if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter) );
else
    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
end
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Close',ClutTextureIndex);

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

if g_strctServerCycle.m_iLastShownTrialID < 2
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
else
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex,g_strctServerCycle.m_iLastShownTrialID);
end

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 33;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end

% dbstop if warning
% warning('big oof')
return
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

   function fnKeepDisplayingOneDnoise()
    global g_strctPTB g_strctDraw g_strctServerCycle
%     persistent fliptracker
%     if isempty(fliptracker)
%         fliptracker=zeros(1,10000);
%     end
    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
    
    fCurrTime  = GetSecs();
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot + g_strctDraw.m_strctTrial.m_fFixationSizePix];
    

    % check if there are more frames to display
    if g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames; % we shouldn't be able to get larger than this number, but just in case
       g_strctServerCycle.m_iMachineState = 3;
       fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
       return 

    else
        % Display the next frame of the bar

        fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter);
        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
        Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);

% felix added 4 dense noise - working code
% mImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.m_strctTrial.Densenoisestim_disp(:,:,g_strctDraw.m_iFrameCounter,:)));
% Screen('DrawTexture', g_strctPTB.m_hWindow, mImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% Screen('Close',mImageID);

% previosu code: cause crashes about 10 mins in
%{
Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.mImageID(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter)),[],g_strctDraw.m_strctTrial.m_aiStimulusRect,g_strctDraw.m_strctTrial.orientation,0);
if mod(g_strctDraw.m_iFrameCounter,2)==0;
Screen('Close',g_strctDraw.mImageID(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter)));
end
%}
hImageID = g_strctDraw.chrombar_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect,g_strctDraw.m_strctTrial.orientation,0);

%     dbstop if warning
%     warning('stop')

% 
% if g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==4 % achromatic cloud
%     Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%     hImageID = g_strctDraw.achromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==1 %achromatic hartleys
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
%     hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==2 %color hartleys
%     Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);    
%     hImageID = g_strctDraw.hartleys_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% elseif g_strctDraw.m_strctTrial.DensenoisePrimaryuseRGBCloud==3 %color cloud
%     Screen('FillRect',g_strctPTB.m_hWindow, [127 127 127]);
%     hImageID = g_strctDraw.chromcloud_disp(g_strctDraw.m_strctTrial.stimseq(g_strctDraw.m_iFrameCounter));
% end
% 
% %hImageID = g_strctDraw.hartleys_disp(randi(1188));
% Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctDraw.m_strctTrial.m_aiStimulusRect);
% %Screen('Close',hImageID);

        %end
        if ~strcmp(g_strctDraw.m_strctTrial.m_strTrialType,'Plain Bar') && g_strctDraw.m_strctTrial.m_bClipStimulusOutsideStimArea
            %Screen('FillRect', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor, g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
            Screen('FillRect', g_strctPTB.m_hWindow, [1 1 1], g_strctDraw.m_strctTrial.m_aiNonStimulusAreas);
        end

        % Fixation point last so it's on top
        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
        %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
        if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
            Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
                [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
                g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
            
        end
        if g_strctDraw.m_strctTrial.m_bUseGaussianPulses
            if size( g_strctDraw.m_strctTrial.m_aiCLUT,3) >= g_strctDraw.m_iFrameCounter
                ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,g_strctDraw.m_iFrameCounter ));
            end
        else
            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT(:,:,1));
        end

        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking
%        fliptracker=[fliptracker g_strctServerCycle.m_fLastFlipTime];
        
        % Update information
        g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = ...
            g_strctDraw.m_a2fFrameFlipTS(1,1) + (g_strctDraw.m_iFrameCounter*(1000/g_strctPTB.m_iRefreshRate));   % How long has it been since we started this presentation, estimated
        g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % What is the actual time, so we can compare with the estimated if necessary

        
    end
% if  g_strctDraw.m_iFrameCounter>=100    
%     dbstop if warning
%     warning('stop')
% end
return;
% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------


function fnDisplayDiscProbe()
global g_strctPTB g_strctDraw g_strctServerCycle

fCurrTime  = GetSecs();
g_strctDraw.m_iFrameCounter = 1;
%fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter); % Update the control computer's frame counter

aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

%Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor ); % This will blank the screen if the trial is over
Screen('FillRect',g_strctPTB.m_hWindow, [128 128 128] ); % This will blank the screen if the trial is over

% Screen('FillOval', g_strctPTB.m_hWindow, [2 2 2],  squeeze([g_strctDraw.m_strctTrial.m_aiCoordinates(1, g_strctDraw.m_iFrameCounter, :),... left
%     g_strctDraw.m_strctTrial.m_aiCoordinates(2, g_strctDraw.m_iFrameCounter, :),... top
%     g_strctDraw.m_strctTrial.m_aiCoordinates(3, g_strctDraw.m_iFrameCounter, :),... right
%     g_strctDraw.m_strctTrial.m_aiCoordinates(4, g_strctDraw.m_iFrameCounter, :)])); % bottom

DiscProbeRect=[g_strctDraw.m_strctTrial.m_aiStimCenter(1)-g_strctDraw.m_strctTrial.m_iDiscDiameter/2,...
    g_strctDraw.m_strctTrial.m_aiStimCenter(2)-g_strctDraw.m_strctTrial.m_iDiscDiameter/2,...
    g_strctDraw.m_strctTrial.m_aiStimCenter(1)+g_strctDraw.m_strctTrial.m_iDiscDiameter/2,...
    g_strctDraw.m_strctTrial.m_aiStimCenter(2)+g_strctDraw.m_strctTrial.m_iDiscDiameter/2];   
Screen('FillArc', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.DiscprobeColor, DiscProbeRect,0,360);

    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
    if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
    end
    
    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex);
    
    if g_strctDraw.m_strctTrial.numFrames > 1
        g_strctServerCycle.m_iMachineState = 35;
    else
        g_strctServerCycle.m_iMachineState = 0;
        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
        fnStimulusServerToKofikoParadigm('TrialFinished');
    end
    
    return;
    
    
    % --------------------------------------------------------------------------------------------------------------------------------------------------------
    
    function fnKeepDisplayingDiscProbe()
        global g_strctPTB g_strctDraw g_strctServerCycle
        fCurrTime  = GetSecs();
        
        Screen('FillRect',g_strctPTB.m_hWindow, [128 128 128] );
        
        aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
            g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
        
        g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter  + 1;
        if g_strctDraw.m_iFrameCounter <= g_strctDraw.m_strctTrial.numFrames
            % at least 1 more frame in this trial, continue displaying
            
            fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter); % Update the control computer's frame counter
            % Rectangle coordinates are filled in the following order: top left, bottom left, bottom right, top right
            DiscProbeRect=[g_strctDraw.m_strctTrial.m_aiStimCenter(1)-g_strctDraw.m_strctTrial.m_iDiscDiameter/2,...
                g_strctDraw.m_strctTrial.m_aiStimCenter(2)-g_strctDraw.m_strctTrial.m_iDiscDiameter/2,...
                g_strctDraw.m_strctTrial.m_aiStimCenter(1)+g_strctDraw.m_strctTrial.m_iDiscDiameter/2,...
                g_strctDraw.m_strctTrial.m_aiStimCenter(2)+g_strctDraw.m_strctTrial.m_iDiscDiameter/2];
            Screen('FillArc', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.DiscprobeColor, DiscProbeRect,0,360);
            
                % Time onset of trial, blocking
                aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
                    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
                Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                
                if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
                    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
                    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
                    Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
                    Screen('Close',ClutTextureIndex);
                end
                
                g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                
        else
            Screen('FillRect',g_strctPTB.m_hWindow, [128 128 128]);
            Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
            % We just showed the last frame, end the trial
            g_strctServerCycle.m_iMachineState = 3;
            g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
            fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
            return;
        end
        
        return;

    % --------------------------------------------------------------------------------------------------------------------------------------------------------
    % --------------------------------------------------------------------------------------------------------------------------------------------------------
   
    % --------------------------------------------------------------------------------------------------------------------------------------------------------
    % --------------------------------------------------------------------------------------------------------------------------------------------------------
       
function fnColorTuningFunction()
% DEFUNCT
global g_strctDraw g_strctPTB g_strctServerCycle
fCurrTime  = GetSecs();

% Show a moving bar using the PTB draw functions
% Get the trial parameters from the imported struct
%ahTexturePointers = g_strctDraw.m_strctTrial.m_strctMedia.m_aiMediaToHandleIndexInBuffer;
aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
g_strctDraw.m_iFrameCounter = 1;

% Do the actual drawing

Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);


for iNumOfBars = 1:g_strctDraw.m_strctTrial.m_iNumberOfBars
    Screen('FillPoly',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiStimColor,...
        horzcat(g_strctDraw.m_strctTrial.coordinatesX(1:4,1,iNumOfBars),g_strctDraw.m_strctTrial.coordinatesY(1:4,1,iNumOfBars)),0)
end




%Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctPTB.m_hOffscreenWindow, g_strctPTB.m_hoffRect, ...
%	[], g_strctDraw.m_acImages{1,g_strctDraw.m_strctTrial.m_strctMedia.m_aiMediaToHandleIndexInBuffer}.commandParameters.rotationAngle)

% Fixation point last so it's on top

Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end
% Update the color lookup table for bits ++
% takes 3-10 ms. Ouch.


BitsPlusSetClut(g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.Clut)

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking



fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex);

% Update the machine
if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 12;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 0;
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
end

return;

% ---------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------------------------------

function fnDisplayGabor()
global g_strctPTB g_strctDraw g_strctServerCycle
fCurrTime  = GetSecs();

g_strctDraw.m_iFrameCounter = 1;


Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor );


% g_strctServerCycle.m_hGabortex = Screen('MakeTexture', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.gaborArray);

Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctServerCycle.m_hGabortex, [], g_strctDraw.m_strctTrial.m_afDestRectangle,...
    g_strctDraw.m_strctTrial.m_fRotationAngle, [], [], g_strctDraw.m_strctTrial.m_aiStimColor, [],...
    kPsychDontDoRotation, [g_strctDraw.m_strctTrial.m_fGaborPhase+180, g_strctDraw.m_strctTrial.m_iGaborFreq,...
    g_strctDraw.m_strctTrial.m_iSigma, g_strctDraw.m_strctTrial.m_iContrast,...
    g_strctDraw.m_strctTrial.AspectRatio, 0, 0, 0]);

aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
if g_strctDraw.m_strctTrial.m_bShowPhotodiodeRect
    Screen('FillRect',g_strctPTB.m_hWindow,[255 255 255], ...
        [g_strctPTB.m_aiRect(3)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(4)-g_strctDraw.m_strctTrial.m_iPhotoDiodeWindowPix ...
        g_strctPTB.m_aiRect(3) g_strctPTB.m_aiRect(4)]);
end



ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1]);
Screen('Close',ClutTextureIndex);

g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow); % Time onset of trial, blocking

fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex);


if g_strctDraw.m_strctTrial.numFrames > 1
    % Go and display the rest of the frames in this trial
    g_strctServerCycle.m_iMachineState = 15;
    
    g_strctDraw.m_a2fFrameFlipTS = NaN*ones(2,g_strctDraw.m_strctTrial.numFrames); % allocate the trial timing array
    g_strctDraw.m_a2fFrameFlipTS(1,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime;   % First frame
    g_strctDraw.m_a2fFrameFlipTS(2,g_strctDraw.m_iFrameCounter) = g_strctServerCycle.m_fLastFlipTime; % Actual Flip Time
    
else
    % Do nothing? Kofiko will supply the next frame when it updates
    g_strctServerCycle.m_iMachineState = 3;
    
    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime );
    
end

return;

% --------------------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------------------

function fnDisplayMovingDots()
global g_strctPTB g_strctDraw g_strctServerCycle



fCurrTime  = GetSecs();
g_strctDraw.m_iFrameCounter = 1;
%fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter); % Update the control computer's frame counter

aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];

%Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor ); % This will blank the screen if the trial is over
Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1] ); % This will blank the screen if the trial is over


g_strctDraw.m_strctTrial.m_aiRect = zeros(4,g_strctDraw.m_strctTrial.NumberOfDots);
% reallign the rect so it is in the left, top, right, bottom order required by the filloval command
%{
for iNumOfDots = 1:g_strctDraw.m_strctTrial.NumberOfDots
	% Reshape the coordinates. Draw oval requires that they be in left, top, right, bottom order
	% This is sloppy since we're still piggybacking on the rectangle code
	g_strctDraw.m_strctTrial.m_aiRect(1,iNumOfDots) =  min(g_strctDraw.m_strctTrial.coordinatesX(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesX(3,g_strctDraw.m_iFrameCounter,iNumOfDots));
	g_strctDraw.m_strctTrial.m_aiRect(2,iNumOfDots) =  min(g_strctDraw.m_strctTrial.coordinatesY(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesY(2,g_strctDraw.m_iFrameCounter,iNumOfDots));
	g_strctDraw.m_strctTrial.m_aiRect(3,iNumOfDots) =  max(g_strctDraw.m_strctTrial.coordinatesX(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesX(3,g_strctDraw.m_iFrameCounter,iNumOfDots));
	g_strctDraw.m_strctTrial.m_aiRect(4,iNumOfDots) =  max(g_strctDraw.m_strctTrial.coordinatesY(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesY(2,g_strctDraw.m_iFrameCounter,iNumOfDots));

end
%}

Screen('FillOval', g_strctPTB.m_hWindow, [2 2 2],  squeeze([g_strctDraw.m_strctTrial.m_aiCoordinates(1, g_strctDraw.m_iFrameCounter, :),... left
    g_strctDraw.m_strctTrial.m_aiCoordinates(2, g_strctDraw.m_iFrameCounter, :),... top
    g_strctDraw.m_strctTrial.m_aiCoordinates(3, g_strctDraw.m_iFrameCounter, :),... right
    g_strctDraw.m_strctTrial.m_aiCoordinates(4, g_strctDraw.m_iFrameCounter, :)])); % bottom

%{
	Screen('FillOval', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiStimColor,  squeeze([g_strctDraw.m_strctTrial.m_aiCoordinates(1, g_strctDraw.m_iFrameCounter, :),... left
																				 g_strctDraw.m_strctTrial.m_aiCoordinates(2, g_strctDraw.m_iFrameCounter, :),... top
																				 g_strctDraw.m_strctTrial.m_aiCoordinates(3, g_strctDraw.m_iFrameCounter, :),... right
																				 g_strctDraw.m_strctTrial.m_aiCoordinates(4, g_strctDraw.m_iFrameCounter, :)])); % bottom

    %}
    %{
Backup
Screen('FillOval', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiStimColor, squeeze([g_strctDraw.m_strctTrial.coordinatesX(1, g_strctDraw.m_iFrameCounter, :),... left
																				 g_strctDraw.m_strctTrial.coordinatesY(1, g_strctDraw.m_iFrameCounter, :),... top
																				 g_strctDraw.m_strctTrial.coordinatesX(3, g_strctDraw.m_iFrameCounter, :),... right
																				 g_strctDraw.m_strctTrial.coordinatesY(2, g_strctDraw.m_iFrameCounter, :)])); % bottom
    %}
    
    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
        g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
    if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
        
        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
        Screen('Close',ClutTextureIndex);
        
    end
    
    
    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex);
    
    if g_strctDraw.m_strctTrial.numFrames > 1
        g_strctServerCycle.m_iMachineState = 17;
    else
        g_strctServerCycle.m_iMachineState = 0;
        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
        fnStimulusServerToKofikoParadigm('TrialFinished');
    end
    
    
    return;
    
    
    % --------------------------------------------------------------------------------------------------------------------------------------------------------
    % --------------------------------------------------------------------------------------------------------------------------------------------------------
    
    function fnKeepDisplayingMovingDots()
        global g_strctPTB g_strctDraw g_strctServerCycle
        
        
        fCurrTime  = GetSecs();
        
        
        
        
        aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
            g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
        
        g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter  + 1;
        if g_strctDraw.m_iFrameCounter <= g_strctDraw.m_strctTrial.numFrames
            % at least 1 more frame in this trial, continue displaying
            
            fnStimulusServerToKofikoParadigm('UpdateFrameCounter',g_strctDraw.m_iFrameCounter); % Update the control computer's frame counter
            
            
            % This next part is a bit funky, as we're using the rectangle creation math, which creates 4 xy coordinates, to populate
            % the filloval array, which only needs 2 x and 2 y coordinates (the bounds of the oval)
            
            % Per the filloval help: Instead of filling one oval, you can also specify a list of multiple ovals to be
            % filled - this is much faster when you need to draw many ovals per frame. To fill
            % n ovals, provide "rect" as a 4 rows by n columns matrix, each column specifying
            % one oval, e.g., rect(1,5)=left border of 5th oval, rect(2,5)=top border of 5th
            % oval, rect(3,5)=right border of 5th oval, rect(4,5)=bottom border of 5th oval.
            % If the ovals should have different colors, then provide "color" as a 3 or 4 row
            % by n column matrix, the i'th column specifiying the color of the i'th oval.
            Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1] );
            g_strctDraw.m_strctTrial.m_aiRect = zeros(4,g_strctDraw.m_strctTrial.NumberOfDots);
            %{
for iNumOfDots = 1:g_strctDraw.m_strctTrial.NumberOfDots
	% Reshape the coordinates. Draw oval requires that they be in left, top, right, bottom order
	% This is sloppy since we're still piggybacking on the rectangle code
	g_strctDraw.m_strctTrial.m_aiRect(1,iNumOfDots) =  min(g_strctDraw.m_strctTrial.coordinatesX(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesX(3,g_strctDraw.m_iFrameCounter,iNumOfDots));
	g_strctDraw.m_strctTrial.m_aiRect(2,iNumOfDots) =  min(g_strctDraw.m_strctTrial.coordinatesY(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesY(2,g_strctDraw.m_iFrameCounter,iNumOfDots));
	g_strctDraw.m_strctTrial.m_aiRect(3,iNumOfDots) =  max(g_strctDraw.m_strctTrial.coordinatesX(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesX(3,g_strctDraw.m_iFrameCounter,iNumOfDots));
	g_strctDraw.m_strctTrial.m_aiRect(4,iNumOfDots) =  max(g_strctDraw.m_strctTrial.coordinatesY(1,g_strctDraw.m_iFrameCounter,iNumOfDots),g_strctDraw.m_strctTrial.coordinatesY(2,g_strctDraw.m_iFrameCounter,iNumOfDots));

end
            %}
            % Rectangle coordinates are filled in the following order: top left, bottom left, bottom right, top right
            
            
            Screen('FillOval', g_strctPTB.m_hWindow, [2 2 2],  squeeze([g_strctDraw.m_strctTrial.m_aiCoordinates(1, g_strctDraw.m_iFrameCounter, :),... left
                g_strctDraw.m_strctTrial.m_aiCoordinates(2, g_strctDraw.m_iFrameCounter, :),... top
                g_strctDraw.m_strctTrial.m_aiCoordinates(3, g_strctDraw.m_iFrameCounter, :),... right
                g_strctDraw.m_strctTrial.m_aiCoordinates(4, g_strctDraw.m_iFrameCounter, :)])); % bottom
            
            
            
            
            %{
	Screen('FillOval', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_aiStimColor,  squeeze([g_strctDraw.m_strctTrial.coordinatesX(1, g_strctDraw.m_iFrameCounter, :),... left
																				 g_strctDraw.m_strctTrial.coordinatesY(1, g_strctDraw.m_iFrameCounter, :),... top
																				 g_strctDraw.m_strctTrial.coordinatesX(3 ,g_strctDraw.m_iFrameCounter, :),... right
																				 g_strctDraw.m_strctTrial.coordinatesY(2 ,g_strctDraw.m_iFrameCounter, :)])); % bottom
	
                %}
                % Time onset of trial, blocking
                aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
                    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
                Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
                    
                    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
                    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
                    Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
                    Screen('Close',ClutTextureIndex);
                    
                end
                
                g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                
                
                
                
                
        else
            Screen('FillRect',g_strctPTB.m_hWindow, [1 1 1]);
            %Screen('FillArc',g_strctPTB.m_hWindow,[255 255 255], aiFixationRect,0,360);
            Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
            % We just showed the last frame, end the trial
            g_strctServerCycle.m_iMachineState = 3;
            g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
            fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
            return;
        end
        
        
        return;
        
        
        
        function fnDisplayImage()
            global g_strctPTB g_strctDraw g_strctServerCycle
            
            
            
            
            fCurrTime  = GetSecs();
            
            aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
                g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
            g_strctDraw.m_iFrameCounter = 1;
            
            Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
            if g_strctDraw.m_strctTrial.m_iImageIndex > numel(g_strctDraw.m_ahHandles)
                Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                fnStimulusServerToKofikoParadigm('TrialFinished');
                g_strctServerCycle.m_iMachineState = 3;
                
                return;
            end
            
            Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.m_ahHandles(g_strctDraw.m_strctTrial.m_iImageIndex),...
                [], g_strctDraw.m_strctTrial.m_aiStimulusArea, g_strctDraw.m_strctTrial.m_fRotationAngle);
            
            
            
            Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
            if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
                
                ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
                ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
                Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
                Screen('Close',ClutTextureIndex);
                
            end
            g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
            
            fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iStimulusIndex);
            if g_strctDraw.m_strctTrial.numFrames > 1
                g_strctServerCycle.m_iMachineState = 19;
            elseif strctTrial.m_fStimulusOFF_MS > 0
                
                g_strctServerCycle.m_iMachineState = 3;
                fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
            else
                fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                fnStimulusServerToKofikoParadigm('TrialFinished');
                
            end
            
            
            return;
            
            % -------------------------------------------------------------------------------------------------------
            
            function fnKeepDisplayingImage()
                global g_strctPTB g_strctDraw g_strctServerCycle
                
                g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
                
                fCurrTime  = GetSecs();
                
                aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
                    g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
                Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
                
                if g_strctDraw.m_strctTrial.m_iImageIndex > numel(g_strctDraw.m_ahHandles)
                    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                    fnStimulusServerToKofikoParadigm('TrialFinished');
                    g_strctServerCycle.m_iMachineState = 3;
                    
                    return;
                    
                end
                
                
                
                if g_strctDraw.m_iFrameCounter <= g_strctDraw.m_strctTrial.numFrames
                    Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.m_ahHandles(g_strctDraw.m_strctTrial.m_iImageIndex), [],...
                        g_strctDraw.m_strctTrial.m_aiStimulusArea, g_strctDraw.m_strctTrial.m_fRotationAngle);
                    
                    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                    
                    
                    if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
                        
                        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
                        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
                        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
                        Screen('Close',ClutTextureIndex);
                        
                    end

                    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                    
                    
                elseif g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames && g_strctDraw.m_strctTrial.m_fStimulusOFF_MS > 0
                    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);

                    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                    g_strctServerCycle.m_iMachineState = 3;
                    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                elseif g_strctDraw.m_iFrameCounter > g_strctDraw.m_strctTrial.numFrames
                      Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                    fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                    fnStimulusServerToKofikoParadigm('TrialFinished');
                    
                end
                return;
                
                
                % -------------------------------------------------------------------------------------------------------
                
                
                function fnDisplayMovie()
                    global g_strctPTB g_strctDraw g_strctServerCycle
                    g_strctServerCycle.m_fMovieStartTime = [];
                    fCurrTime  = GetSecs();
                    
                    aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
                        g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
                    g_strctDraw.m_iFrameCounter = 1;
                    if ~g_strctDraw.m_strctTrial.m_bLoadOnTheFly
                        
                        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
                        Screen('PlayMovie', g_strctDraw.m_ahMovieHandles{g_strctDraw.m_strctTrial.m_iMovieIndex}, 1, 1);
                        g_strctDraw.m_strctTrial.hMovieHandle = g_strctDraw.m_ahMovieHandles{g_strctDraw.m_strctTrial.m_iMovieIndex};
                        hMovieTex = Screen('GetMovieImage', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.hMovieHandle, 0);
                        g_strctDraw.m_strctTrial.fDuration = g_strctDraw.m_acVideoData{g_strctDraw.m_strctTrial.m_iMovieIndex}.fDuration;
                    else
                        %[g_strctDraw.m_strctTrial.hMovieHandle, g_strctDraw.m_strctTrial.cVideoData,...
                        %      g_strctDraw.m_strctTrial.bIsMovie] = fnLoadImageSet('LoadMovieSet', DirectoryPath, selectedMovieList);
                        [g_strctDraw.m_strctTrial.hMovieHandle, g_strctDraw.m_strctTrial.fDuration,...
                            g_strctDraw.m_strctTrial.fFPS, g_strctDraw.m_strctTrial.iWidth, g_strctDraw.m_strctTrial.iHeight,...
                            g_strctDraw.m_strctTrial.iCount, g_strctDraw.m_strctTrial.fAspectRatio] = Screen('OpenMovie', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_strStimServerMovieFilePath,0);
                        % [g_strctDraw.m_strctTrial.hMovieHandle, ~] = Screen('OpenMovie', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_strMovieFilePath,0);
                        %strctTrial.m_strStimServerMovieFilePath
                        
                        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
                        Screen('PlayMovie', g_strctDraw.m_strctTrial.hMovieHandle, 1, 1);
                        hMovieTex = Screen('GetMovieImage', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.hMovieHandle, 0);
                        g_strctDraw.m_strctTrial.fDuration =  g_strctDraw.m_strctTrial.fDuration;
                        % Valid texture returned?
                    end
                    if hMovieTex < 0
                        
                        disp('invalid text')
                        fnStimulusServerToKofikoParadigm('TrialFinished');
                        return;
                    end
                    
                    if hMovieTex == 0
                        disp('not ready')
                        WaitSecs('YieldSecs', 0.001);
                        return;
                    end
                    
                    Screen('DrawTexture', g_strctPTB.m_hWindow, hMovieTex,...
                        [], g_strctDraw.m_strctTrial.m_aiStimulusArea, g_strctDraw.m_strctTrial.m_fRotationAngle);
                    
                    
                    
                    Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                    
                    if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
                        ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
                        ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
                        Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
                        Screen('Close',ClutTextureIndex);
                    end
                    
                    g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                    g_strctServerCycle.m_fMovieStartTime = g_strctServerCycle.m_fLastFlipTime;
                    fnStimulusServerToKofikoParadigm('FlipON',fCurrTime,g_strctDraw.m_strctTrial.m_iMovieIndex);
                    Screen('Close',hMovieTex);
                    if GetSecs() - g_strctServerCycle.m_fMovieStartTime < g_strctDraw.m_strctTrial.fDuration
                        disp('block 11')
                        g_strctServerCycle.m_iMachineState = 21;
                    elseif strctTrial.m_fStimulusOFF_MS > 0
                        disp('block 12')
                        
                        if g_strctDraw.m_bLoadOnTheFly
                            Screen('CloseMovie',g_strctDraw.m_strctTrial.hMovieHandle);
                        end
                        g_strctServerCycle.m_iMachineState = 3;
                        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                    else
                        disp('block 13')
                        
                        if g_strctDraw.m_bLoadOnTheFly
                            Screen('CloseMovie',g_strctDraw.m_strctTrial.hMovieHandle);
                        end
                        fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                        fnStimulusServerToKofikoParadigm('TrialFinished');
                        
                    end
                    
                    return;
                    
                    % -------------------------------------------------------------------------------------------------------
                    
                    
                    function fnKeepDisplayingMovie()
                        global g_strctPTB g_strctDraw g_strctServerCycle
                        fCurrTime = GetSecs();
                        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
                        disp('keep displaying movie')
                        
                        %fCurrTime - g_strctServerCycle.m_fMovieStartTime;
                        if fCurrTime - g_strctServerCycle.m_fMovieStartTime > (g_strctDraw.m_strctTrial.afMovieLengthSec)
                            g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                            disp('block 1')
                            if g_strctDraw.m_bLoadOnTheFly
                                Screen('CloseMovie',g_strctDraw.m_strctTrial.hMovieHandle);
                            end
                            fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                            % fnStimulusServerToKofikoParadigm('TrialFinished');
                            g_strctServerCycle.m_iMachineState = 3;
                            
                            return;
                            
                        else
                            
                            
                            %g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
                            
                            
                        end
                        
                        
                        
                        
                        
                        aiFixationRect = [g_strctDraw.m_strctTrial.m_pt2iFixationSpot-g_strctDraw.m_strctTrial.m_fFixationSizePix,...
                            g_strctDraw.m_strctTrial.m_pt2iFixationSpot+g_strctDraw.m_strctTrial.m_fFixationSizePix];
                        Screen('FillRect',g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.m_afBackgroundColor);
                        hMovieTex = Screen('GetMovieImage', g_strctPTB.m_hWindow, g_strctDraw.m_strctTrial.hMovieHandle, 1);
                        
                        % Valid texture returned?
                        if hMovieTex < 0
                            disp(' Valid texture returned?')
                            g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                            if g_strctDraw.m_bLoadOnTheFly
                                
                                Screen('CloseMovie',g_strctDraw.m_strctTrial.hMovieHandle);
                            end
                            fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                            g_strctServerCycle.m_iMachineState = 3;
                            % fnStimulusServerToKofikoParadigm('TrialFinished');
                            return;
                        end
                        
                        if hMovieTex == 0
                            disp('wait')
                            WaitSecs('YieldSecs', 0.001);
                            return;
                        end
                        
                        %%if g_strctDraw.m_iFrameCounter <= g_strctDraw.m_strctTrial.numFrames
                        Screen('DrawTexture', g_strctPTB.m_hWindow, hMovieTex, [],...
                            g_strctDraw.m_strctTrial.m_aiStimulusArea, g_strctDraw.m_strctTrial.m_fRotationAngle);
                        
                        Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                        %end
                        if g_strctDraw.m_strctTrial.m_bUseBitsPlusPlus
                            
                            ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
                            ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
                            Screen( 'DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
                            Screen('Close',ClutTextureIndex);
                            
                        end
                        g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                        Screen('Close',hMovieTex);
                        
                        
                        
                        %if fCurrTime - g_strctServerCycle.m_fMovieStartTime > g_strctDraw.m_acVideoData{g_strctDraw.m_strctTrial.m_iMovieIndex}.fDuration
                        if fCurrTime - g_strctServerCycle.m_fMovieStartTime > g_strctDraw.m_strctTrial.afMovieLengthSec
                            %Screen('FillArc',g_strctPTB.m_hWindow,g_strctDraw.m_strctTrial.m_iFixationColor, aiFixationRect,0,360);
                            %g_strctServerCycle.m_fLastFlipTime = fnFlipWrapper(g_strctPTB.m_hWindow);
                            g_strctServerCycle.m_iMachineState = 3;
                            
                            disp('block 2 ')
                            
                            if g_strctDraw.m_bLoadOnTheFly
                                
                                Screen('CloseMovie',g_strctDraw.m_strctTrial.hMovieHandle);
                            end
                            fnStimulusServerToKofikoParadigm('FlipOFF',g_strctServerCycle.m_fLastFlipTime);
                            
                        end
                        
                        
                        return;
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        