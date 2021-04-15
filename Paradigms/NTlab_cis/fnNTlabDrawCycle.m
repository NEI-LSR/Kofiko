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
    fCurrTime - g_strctServerCycle.m_fLastFlipTime
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

function fnDisplayDualstim()
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

% redraw here?
[cur_peristim, ~]=GenerateTernaryStim(.25, 1, 0); 
hImageID = Screen('MakeTexture', g_strctPTB.m_hWindow,  cur_peristim);
if mod(g_strctDraw.m_iFrameCounter,2); fRotationAngle=0; else; fRotationAngle=90; end
Screen('DrawTexture', g_strctPTB.m_hWindow, hImageID,[],g_strctParadigm.m_aiSecondaryStimulusRect, fRotationAngle);

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
    g_strctServerCycle.m_iMachineState = 23;
    
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


    function fnKeepDisplayingDualstim()
    global g_strctPTB g_strctDraw g_strctServerCycle

    g_strctDraw.m_iFrameCounter = g_strctDraw.m_iFrameCounter + 1;
    
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
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        