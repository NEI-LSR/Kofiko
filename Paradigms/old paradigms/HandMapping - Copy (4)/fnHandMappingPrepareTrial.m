function strctTrial = fnHandMappingPrepareTrial()
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
global g_strctParadigm g_strctPTB 
%fCurrTime = GetSecs;
ClockRandSeed();
% Give Kofiko something to chew on later
iNewStimulusIndex = 1;
strctTrial.m_strTrialType = g_strctParadigm.m_strctDesign.m_strctBlocksAndOrder.m_astrctBlocks(g_strctParadigm.m_iCurrentBlockIndexInOrderList).m_strBlockName;
strctTrial.m_iStimulusIndex = iNewStimulusIndex;
strctTrial.m_strctMedia = g_strctParadigm.m_strctDesign.m_astrctMedia(iNewStimulusIndex);
strctTrial.m_pt2iFixationSpot = g_strctParadigm.FixationSpotPix.Buffer(1,:,g_strctParadigm.FixationSpotPix.BufferIdx);
strctTrial.m_pt2fStimulusPos = g_strctParadigm.StimulusPos.Buffer(1,:,g_strctParadigm.StimulusPos.BufferIdx);
strctTrial.m_fFixationSizePix = g_strctParadigm.FixationSizePix.Buffer(1,:,g_strctParadigm.FixationSizePix.BufferIdx);
strctTrial.m_fGazeBoxPix = g_strctParadigm.GazeBoxPix.Buffer(1,:,g_strctParadigm.GazeBoxPix.BufferIdx);
strctTrial.m_fStimulusSizePix = g_strctParadigm.StimulusSizePix.Buffer(1,:,g_strctParadigm.StimulusSizePix.BufferIdx);
strctTrial.m_bShowPhotodiodeRect = g_strctParadigm.m_bShowPhotodiodeRect;
strctTrial.m_iLocalFrameCounter = 1;
strctTrial.m_bColorUpdated = 0;
strctTrial.m_bBlur = 0;
strctTrial.m_bClipStimulusOutsideStimArea = g_strctParadigm.m_bClipStimulusOutsideStimArea;
strctTrial.m_bUseBitsPlusPlus = 1;
g_strctParadigm.m_strctCurrentTrial.m_bDrawScreenCoords = 1;

strctTrial.m_fImageFlipON_TS_StimulusServer = [];
strctTrial.m_fImageFlipON_TS_Kofiko = [];


aiStimulusScreenSize = fnParadigmToKofikoComm('GetStimulusServerScreenSize');
strctTrial.m_aiNonStimulusAreas = [0,0, aiStimulusScreenSize(3), min(g_strctParadigm.m_aiStimulusRect(2),aiStimulusScreenSize(4));...
    0,0,min(aiStimulusScreenSize(3),g_strctParadigm.m_aiStimulusRect(1)),aiStimulusScreenSize(4);...
    0, min(aiStimulusScreenSize(4),g_strctParadigm.m_aiStimulusRect(4)), aiStimulusScreenSize(3), aiStimulusScreenSize(4);...
    min(aiStimulusScreenSize(3),g_strctParadigm.m_aiStimulusRect(3)), 0,aiStimulusScreenSize(3), aiStimulusScreenSize(4)]';


switch strctTrial.m_strTrialType
    case 'Plain Bar'
        [strctTrial] = fnPreparePlainBarTrial(g_strctPTB, strctTrial);
    case 'Moving Bar'
        [strctTrial] = fnPrepareMovingBarTrial(g_strctPTB, strctTrial);
    case 'Moving Dots'
        [g_strctParadigm, strctTrial] = fnPrepareMovingDiscTrial(g_strctParadigm, g_strctPTB, strctTrial);
    case 'Gabor'
        [g_strctParadigm, strctTrial] = fnPrepareRealTimeGaborTrial(g_strctParadigm, g_strctPTB, strctTrial);

end

return;


% ------------------------------------------------------------------------------------------------------------------------

function [strctTrial] = fnPreparePlainBarTrial(g_strctPTB, strctTrial)
global g_strctStimulusServer g_strctParadigm

strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.StaticBarLength.Buffer(1,:,g_strctParadigm.StaticBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.StaticBarWidth.Buffer(1,:,g_strctParadigm.StaticBarWidth.BufferIdx));
strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.StaticBarOrientation.Buffer(1,:,g_strctParadigm.StaticBarOrientation.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.StaticBarBlurSteps.Buffer(1,:,g_strctParadigm.StaticBarBlurSteps.BufferIdx)));
strctTrial.m_bBlur  = squeeze(g_strctParadigm.StaticBarBlur.Buffer(1,:,g_strctParadigm.StaticBarBlur.BufferIdx));
%strctTrial.m_bBlur = g_strctParadigm.m_bBlur;

strctTrial.m_fStimulusON_MS = 0;
strctTrial.m_fStimulusOFF_MS = 0;
strctTrial.numFrames = 1; % Tells Kofiko to update every frame




%Override the number of bars if this paradigm is selected. Might change this later.
strctTrial.m_iNumberOfBars = 1;
g_strctParadigm.m_strctHandMappingParameters.m_bRandomStimulusPosition = 0;

strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.StaticBarMoveDistance.Buffer(1,:,g_strctParadigm.StaticBarMoveDistance.BufferIdx));

strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);


if strctTrial.m_iMoveDistance
    strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.StaticBarMoveSpeed.Buffer(1,:,g_strctParadigm.StaticBarMoveSpeed.BufferIdx));
    strctTrial.m_iNewBarPositionOffset = g_strctParadigm.m_fLastBarPositionOffset + (g_strctParadigm.m_fLastBarMovementDirection *...
        (strctTrial.m_iMoveSpeed/g_strctStimulusServer.m_fRefreshRateMS));
    
    if abs(strctTrial.m_iNewBarPositionOffset) >= strctTrial.m_iMoveDistance
        
        strctTrial.m_iNewBarPositionOffset = sign(strctTrial.m_iNewBarPositionOffset) * strctTrial.m_iMoveDistance;
        g_strctParadigm.bReverse = 1;
    end
    [strctTrial.m_iLineBegin(1),strctTrial.m_iLineBegin(2)] = fnRotateAroundPoint(strctTrial.location_x(1),round(strctTrial.location_y(1) - strctTrial.m_iMoveDistance),strctTrial.location_x(1),...
        strctTrial.location_y(1) ,strctTrial.m_fRotationAngle);
    
    [strctTrial.m_iLineEnd(1), strctTrial.m_iLineEnd(2)] = fnRotateAroundPoint(strctTrial.location_x(1),round(strctTrial.location_y(1)+ strctTrial.m_iMoveDistance),strctTrial.location_x(1),...
        strctTrial.location_y(1) ,strctTrial.m_fRotationAngle);
    [offSetX, offSetY] = fnRotateAroundPoint(strctTrial.location_x(1),round(strctTrial.location_y(1)+ strctTrial.m_iNewBarPositionOffset),strctTrial.location_x(1),...
        strctTrial.location_y(1) ,strctTrial.m_fRotationAngle);
    strctTrial.location_x(1) = offSetX;
    strctTrial.location_y(1) = offSetY;
    
    g_strctParadigm.m_fLastBarPositionOffset = strctTrial.m_iNewBarPositionOffset;
    if g_strctParadigm.bReverse
        g_strctParadigm.bReverse = 0;
        g_strctParadigm.m_fLastBarMovementDirection = -g_strctParadigm.m_fLastBarMovementDirection;
    end
    
    strctTrial.bar_rect(1,1:4) = [(offSetX - strctTrial.m_iLength/2),...
        (offSetY - strctTrial.m_iWidth/2),...
        (offSetX + strctTrial.m_iLength/2),...
        (offSetY + strctTrial.m_iWidth/2)];
    
else
    
    
    strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2),...
        (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2),...
        (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2),...
        (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
end

[strctTrial] = fnCycleColor(strctTrial);





[strctTrial.point1(1,1), strctTrial.point1(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point2(1,1), strctTrial.point2(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point3(1,1), strctTrial.point3(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point4(1,1), strctTrial.point4(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);

if ~strctTrial.m_bBlur
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
    
    strctTrial.coordinatesX(1:4,:) = [strctTrial.point1(1), strctTrial.point2(1), strctTrial.point3(1),strctTrial.point4(1)];
    strctTrial.coordinatesY(1:4,:) = [strctTrial.point1(2), strctTrial.point2(2), strctTrial.point3(2),strctTrial.point4(2)];
    
else
    
    min_distance = min((strctTrial.m_iLength/2)-1,(strctTrial.m_iWidth/2)-1);
    % Make sure our number of blur steps is sane
   
    %{
    strctTrial.m_aiBlurStepHolder(1,:) = linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(1),strctTrial.numberBlurSteps);
    strctTrial.m_aiBlurStepHolder(2,:) = linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(2),strctTrial.numberBlurSteps);
    strctTrial.m_aiBlurStepHolder(3,:) = linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(3),strctTrial.numberBlurSteps);
    %}
    
    strctTrial.blurRawScreenCoordinates = [strctTrial.bar_rect(1,1) + strctTrial.numberBlurSteps,...
        strctTrial.bar_rect(1,2) + strctTrial.numberBlurSteps,...
        strctTrial.bar_rect(1,3) - strctTrial.numberBlurSteps,...
        strctTrial.bar_rect(1,4) - strctTrial.numberBlurSteps];
    
    % We have to do the same math we did for the rectangle to rotate the
    % blur points into position
    
    
    [strctTrial.blurCorrectedScreenCoordinates(1,1), strctTrial.blurCorrectedScreenCoordinates(1,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,1),...
        strctTrial.blurRawScreenCoordinates(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blurCorrectedScreenCoordinates(2,1), strctTrial.blurCorrectedScreenCoordinates(2,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,1),...
        strctTrial.blurRawScreenCoordinates(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blurCorrectedScreenCoordinates(3,1), strctTrial.blurCorrectedScreenCoordinates(3,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,3),...
        strctTrial.blurRawScreenCoordinates(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blurCorrectedScreenCoordinates(4,1), strctTrial.blurCorrectedScreenCoordinates(4,2)] = fnRotateAroundPoint(strctTrial.blurRawScreenCoordinates(1,3),...
        strctTrial.blurRawScreenCoordinates(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blur_starting_point(1,1),strctTrial.blur_starting_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),...
        strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.blur_ending_point(1,1),strctTrial.blur_ending_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),...
        strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps+1));
    
    % Only 1 frame and 1 bar here, so we can ignore the middle two dimensions
    % We also add one to the linspace because we can't fillpoly a single pixel in the center of the stimulus
    % This means we'll have an extra entry on the end because I'm too lazy to do anything about it
    % But the fillpoly call in the draw function won't index to it anyway
    strctTrial.coordinatesX(1:4,:,:,1:strctTrial.numberBlurSteps+1) = vertcat(round(linspace(strctTrial.point1(1),strctTrial.blurCorrectedScreenCoordinates(1,1),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point2(1),strctTrial.blurCorrectedScreenCoordinates(2,1),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point3(1),strctTrial.blurCorrectedScreenCoordinates(3,1),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point4(1),strctTrial.blurCorrectedScreenCoordinates(4,1),strctTrial.numberBlurSteps+1)));
    
    
    
    strctTrial.coordinatesY(1:4,:,:,1:strctTrial.numberBlurSteps+1) = vertcat(round(linspace(strctTrial.point1(2),strctTrial.blurCorrectedScreenCoordinates(1,2),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point2(2),strctTrial.blurCorrectedScreenCoordinates(2,2),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point3(2),strctTrial.blurCorrectedScreenCoordinates(3,2),strctTrial.numberBlurSteps+1)),...
        round(linspace(strctTrial.point4(2),strctTrial.blurCorrectedScreenCoordinates(4,2),strctTrial.numberBlurSteps+1)));
    
end
return;


% ------------------------------------------------------------------------------------------------------------------------
function [strctTrial] = fnPrepareMovingBarTrial(g_strctPTB, strctTrial)

global g_strctParadigm
strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iLength = squeeze(g_strctParadigm.MovingBarLength.Buffer(1,:,g_strctParadigm.MovingBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.MovingBarWidth.Buffer(1,:,g_strctParadigm.MovingBarWidth.BufferIdx));
strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.MovingBarNumberOfBars.Buffer(1,:,g_strctParadigm.MovingBarNumberOfBars.BufferIdx));
strctTrial.m_fStimulusON_MS = g_strctParadigm.MovingBarStimulusOnTime.Buffer(1,:,g_strctParadigm.MovingBarStimulusOnTime.BufferIdx);
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.MovingBarStimulusOffTime.Buffer(1,:,g_strctParadigm.MovingBarStimulusOffTime.BufferIdx);

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.MovingBarMoveDistance.Buffer(1,:,g_strctParadigm.MovingBarMoveDistance.BufferIdx));


strctTrial.m_bBlur  = squeeze(g_strctParadigm.MovingBarBlur.Buffer(1,:,g_strctParadigm.MovingBarBlur.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.MovingBarBlurSteps.Buffer(1,:,g_strctParadigm.MovingBarBlurSteps.BufferIdx)));



[strctTrial] = fnCycleColor(strctTrial);


if g_strctParadigm.m_bRandomStimulusOrientation
    ClockRandSeed();
    strctTrial.m_iOrientationBin = round(((g_strctParadigm.m_iNumOrientationBins-1) * rand(1,1))) + 1;
    strctTrial.m_fRotationAngle = strctTrial.m_iOrientationBin * (360/g_strctParadigm.m_iNumOrientationBins) ;
elseif g_strctParadigm.m_bCycleStimulusOrientation
    if isempty(g_strctParadigm.m_iOrientationBin)
        g_strctParadigm.m_iOrientationBin = 1;
    end
    if ~g_strctParadigm.m_bReverseCycleStimulusOrientation
        strctTrial.m_iOrientationBin = g_strctParadigm.m_iOrientationBin + 1;
        if strctTrial.m_iOrientationBin >= 21
            strctTrial.m_iOrientationBin = 1;
        end
    else
        strctTrial.m_iOrientationBin = g_strctParadigm.m_iOrientationBin - 1;
        if strctTrial.m_iOrientationBin <= 0
            strctTrial.m_iOrientationBin = 20;
        end
    end
    strctTrial.m_fRotationAngle = strctTrial.m_iOrientationBin * (360/g_strctParadigm.m_iNumOrientationBins) ;
else
    strctTrial.m_iOrientationBin = [];
    strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.MovingBarOrientation.Buffer(1,:,g_strctParadigm.MovingBarOrientation.BufferIdx));
end
g_strctParadigm.m_iOrientationBin = strctTrial.m_iOrientationBin;

if g_strctParadigm.m_bRandomStimulusPosition
    minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iWidth)/2;
    for iNumBars = 1 : strctTrial.m_iNumberOfBars
        % Random center points
        
        
        
        strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
        strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
        % Try not to draw bars on top of each other
        if iNumBars > 2
            for tries=1:5
                if abs(min(strctTrial.location_x(1:iNumBars-1)) - strctTrial.location_x(iNumBars)) < minimum_seperation ||...
                        abs(min(strctTrial.location_y(1:iNumBars-1)) - strctTrial.location_y(iNumBars)) < minimum_seperation
                    % I'm too lazy to do the maths to figure out if it is possible to find an empty location
                    % So we'll just try 5 times and hope for the best
                    strctTrial.location_x(iNumBars) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
                    strctTrial.location_y(iNumBars) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
                else
                    break;
                end
            end
        end
        strctTrial.bar_rect(iNumBars,1:4) = [(strctTrial.location_x(iNumBars) - strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars)  - strctTrial.m_iWidth/2), ...
            (strctTrial.location_x(iNumBars) + strctTrial.m_iLength/2), (strctTrial.location_y(iNumBars) + strctTrial.m_iWidth/2)];
        
    end
else
    strctTrial.m_iNumberOfBars = 1;
    strctTrial.location_x(1) = g_strctParadigm.m_aiCenterOfStimulus(1);
    strctTrial.location_y(1) = g_strctParadigm.m_aiCenterOfStimulus(2);
    strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_aiCenterOfStimulus(1) - strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) - strctTrial.m_iWidth/2), ...
        (g_strctParadigm.m_aiCenterOfStimulus(1) + strctTrial.m_iLength/2), (g_strctParadigm.m_aiCenterOfStimulus(2) + strctTrial.m_iWidth/2)];
end


if ~strctTrial.m_bBlur
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));
    if strctTrial.m_iNumberOfBars == 1
        [strctTrial.point1(1,1), strctTrial.point1(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.point2(1,1), strctTrial.point2(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.point3(1,1), strctTrial.point3(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.point4(1,1), strctTrial.point4(1,2)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
        [strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(1,2)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
    else
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            [strctTrial.point1(iNumOfBars,1), strctTrial.point1(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point2(iNumOfBars,1), strctTrial.point2(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,4),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point3(iNumOfBars,1), strctTrial.point3(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,4),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.point4(iNumOfBars,1), strctTrial.point4(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.bar_starting_point(iNumOfBars,1),strctTrial.bar_starting_point(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(iNumOfBars),(strctTrial.location_y(iNumOfBars) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            [strctTrial.bar_ending_point(iNumOfBars,1),strctTrial.bar_ending_point(iNumOfBars,2)] = fnRotateAroundPoint(strctTrial.location_x(iNumOfBars),(strctTrial.location_y(iNumOfBars) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
            
            
            % Calculate center points for all the bars based on random generation of coordinates inside the stimulus area, and generate the appropriate point list
        end
    end
    % Check if the trial has more than 1 frame in it, so we can plan the trial
    if strctTrial.numFrames > 1
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            % Calculate coordinates for every frame
            
            strctTrial.coordinatesX(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,1) -...
                (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point1(iNumOfBars,1)-...
                (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                ...
                round(linspace(strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point2(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point3(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,1)),strctTrial.point4(iNumOfBars,1) - (strctTrial.location_x(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,1)),strctTrial.numFrames)));
            strctTrial.coordinatesY(1:4,:,iNumOfBars) = vertcat(round(linspace(strctTrial.point1(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point1(iNumOfBars,2)-(strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point2(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point2(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point3(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point3(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)),...
                round(linspace(strctTrial.point4(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_starting_point(iNumOfBars,2)),strctTrial.point4(iNumOfBars,2) - (strctTrial.location_y(iNumOfBars) - strctTrial.bar_ending_point(iNumOfBars,2)),strctTrial.numFrames)));
        end
    else
        for iNumOfBars = 1:strctTrial.m_iNumberOfBars
            % Only one frame, so the coordinates are static
            
            strctTrial.coordinatesX(1:4,:,iNumOfBars) = [strctTrial.point1(iNumOfBars,1), strctTrial.point2(iNumOfBars,1), strctTrial.point3(iNumOfBars,1),strctTrial.point4(iNumOfBars,1)];
            strctTrial.coordinatesY(1:4,:,iNumOfBars) = [strctTrial.point1(iNumOfBars,2), strctTrial.point2(iNumOfBars,2), strctTrial.point3(iNumOfBars,2),strctTrial.point4(iNumOfBars,2)];
        end
    end
else
    
    
    
    
    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars, strctTrial.numberBlurSteps));

    [strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars,strctTrial.numberBlurSteps+1));
    [strctTrial.blur_starting_point, strctTrial.blur_ending_point] = deal(zeros(strctTrial.m_iNumberOfBars, 2 ,1));
    for iNumOfBars = 1:strctTrial.m_iNumberOfBars
        blurXCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,1),strctTrial.bar_rect(iNumOfBars,1) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
            round(linspace(strctTrial.bar_rect(iNumOfBars,3),strctTrial.bar_rect(iNumOfBars,3) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
        
        blurYCoords = vertcat(round(linspace(strctTrial.bar_rect(iNumOfBars,2),strctTrial.bar_rect(iNumOfBars,2) + strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)),...
            round(linspace(strctTrial.bar_rect(iNumOfBars,4),strctTrial.bar_rect(iNumOfBars,4) - strctTrial.numberBlurSteps+1,strctTrial.numberBlurSteps+1)));
        
        [firstBlurCoordsPoint1(1, :), firstBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [firstBlurCoordsPoint2(1,:), firstBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [firstBlurCoordsPoint3(1,:), firstBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [firstBlurCoordsPoint4(1,:), firstBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) - strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        
        [lastBlurCoordsPoint1(1,:), lastBlurCoordsPoint1(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(1,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [lastBlurCoordsPoint2(1,:), lastBlurCoordsPoint2(2,:)] = fnRotateAroundPoint(blurXCoords(1,:),blurYCoords(2,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [lastBlurCoordsPoint3(1,:), lastBlurCoordsPoint3(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(2,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        [lastBlurCoordsPoint4(1,:), lastBlurCoordsPoint4(2,:)] = fnRotateAroundPoint(blurXCoords(2,:),blurYCoords(1,:) + strctTrial.m_iMoveDistance/2,strctTrial.location_x(iNumOfBars),strctTrial.location_y(iNumOfBars),strctTrial.m_fRotationAngle);
        
        
        for iBlurSteps = 1: strctTrial.numberBlurSteps+1
            strctTrial.coordinatesX(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(1,iBlurSteps),lastBlurCoordsPoint1(1,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint2(1,iBlurSteps),lastBlurCoordsPoint2(1,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint3(1,iBlurSteps),lastBlurCoordsPoint3(1,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint4(1,iBlurSteps),lastBlurCoordsPoint4(1,iBlurSteps),strctTrial.numFrames)));
            strctTrial.coordinatesY(1:4,:,iNumOfBars,iBlurSteps) = vertcat(round(linspace(firstBlurCoordsPoint1(2,iBlurSteps),lastBlurCoordsPoint1(2,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint2(2,iBlurSteps),lastBlurCoordsPoint2(2,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint3(2,iBlurSteps),lastBlurCoordsPoint3(2,iBlurSteps),strctTrial.numFrames)),...
                round(linspace(firstBlurCoordsPoint4(2,iBlurSteps),lastBlurCoordsPoint4(2,iBlurSteps),strctTrial.numFrames)));
        end
        
    end
    
end



return;


% ------------------------------------------------------------------------------------------------------------------------



function [g_strctParadigm, strctTrial] = fnPrepareColorTuningFunctionTrial(g_strctParadigm, g_strctPTB, strctTrial)

strctTrial.m_iFixationColor = [255 255 255];


strctTrial.m_bUseStrobes = 1;

strctTrial.m_iNumberOfBars = 1;
strctTrial.m_iMoveDistance = g_strctParadigm.m_strctTuningFunctionParams.m_fMoveDistance;

strctTrial.numFrames = g_strctParadigm.m_strctTuningFunctionParams.m_fNumFrames;
strctTrial.m_fStimulusON_MS = g_strctParadigm.m_strctTuningFunctionParams.m_fStimulusOnTime;
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.m_strctTuningFunctionParams.m_fStimulusOffTime;
strctTrial.location_x(1) = g_strctParadigm.m_strctTuningFunctionParams.m_afCenterOfStimulus(1);
strctTrial.location_y(1) = g_strctParadigm.m_strctTuningFunctionParams.m_afCenterOfStimulus(2);
strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_strctTuningFunctionParams.m_afCenterOfStimulus(1) - g_strctParadigm.m_strctTuningFunctionParams.m_fLength/2),...
    (g_strctParadigm.m_strctTuningFunctionParams.m_afCenterOfStimulus(2) - g_strctParadigm.m_strctTuningFunctionParams.m_fWidth/2), ...
    (g_strctParadigm.m_strctTuningFunctionParams.m_afCenterOfStimulus(1) + g_strctParadigm.m_strctTuningFunctionParams.m_fLength/2),...
    (g_strctParadigm.m_strctTuningFunctionParams.m_afCenterOfStimulus(2) + g_strctParadigm.m_strctTuningFunctionParams.m_fWidth/2)];




strctTrial.m_fRotationAngle = g_strctParadigm.m_strctTuningFunctionParams.m_fTheta;




% Always set to this so the Clut is accurate
strctTrial.m_aiStimColor = [2 2 2];
% Background color
strctTrial.m_afBackgroundColor = [1 1 1]; % ditto

[g_strctParadigm, strctTrial] = fnChooseColor(g_strctParadigm, strctTrial);






[strctTrial.point1(1,1), strctTrial.point1(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point2(1,1), strctTrial.point2(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point3(1,1), strctTrial.point3(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point4(1,1), strctTrial.point4(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);


% clear this or if the stimulus on time is changed it will break the array and crash kofiko
[strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));

% Check if the trial has more than 1 frame in it, so we can plan the trial
if strctTrial.numFrames > 1
    % Calculate coordinates for every frame
    
    strctTrial.coordinatesX(1:4,:,strctTrial.m_iNumberOfBars) = vertcat(round(linspace(strctTrial.point1(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point1(1,strctTrial.m_iNumberOfBars)-(strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point2(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point2(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point3(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point3(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point4(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point4(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)));
    strctTrial.coordinatesY(1:4,:,strctTrial.m_iNumberOfBars) = vertcat(round(linspace(strctTrial.point1(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point1(2,strctTrial.m_iNumberOfBars)-(strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point2(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point2(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point3(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point3(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point4(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point4(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)));
else
    strctTrial.coordinatesX(1:4,:) = [strctTrial.point1(1), strctTrial.point2(1), strctTrial.point3(1),strctTrial.point4(1)];
    strctTrial.coordinatesY(1:4,:) = [strctTrial.point1(2), strctTrial.point2(2), strctTrial.point3(2),strctTrial.point4(2)];
end


return;
% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------

function [g_strctParadigm, strctTrial] = fnPrepareOrientationFunctionTrial(g_strctParadigm, g_strctPTB, strctTrial)

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_bUseStrobes = 1;

strctTrial.m_iNumberOfBars = 1;
strctTrial.m_iMoveDistance = g_strctParadigm.m_strctOrientationFunctionParams.m_fMoveDistance;

strctTrial.numFrames = g_strctParadigm.m_strctOrientationFunctionParams.m_fNumFrames;
strctTrial.m_fStimulusON_MS = g_strctParadigm.m_strctOrientationFunctionParams.m_fStimulusOnTime;
strctTrial.m_fStimulusOFF_MS = g_strctParadigm.m_strctOrientationFunctionParams.m_fStimulusOffTime;
strctTrial.location_x(1) = g_strctParadigm.m_strctOrientationFunctionParams.m_afCenterOfStimulus(1);
strctTrial.location_y(1) = g_strctParadigm.m_strctOrientationFunctionParams.m_afCenterOfStimulus(2);
strctTrial.m_afBackgroundColor = g_strctParadigm.m_afBackgroundColor;
strctTrial.m_aiStimColor = g_strctParadigm.m_afBarColor;



strctTrial.bar_rect(1,1:4) = [(g_strctParadigm.m_strctOrientationFunctionParams.m_afCenterOfStimulus(1) - g_strctParadigm.m_strctOrientationFunctionParams.m_fLength/2),...
    (g_strctParadigm.m_strctOrientationFunctionParams.m_afCenterOfStimulus(2) - g_strctParadigm.m_strctOrientationFunctionParams.m_fWidth/2), ...
    (g_strctParadigm.m_strctOrientationFunctionParams.m_afCenterOfStimulus(1) + g_strctParadigm.m_strctOrientationFunctionParams.m_fLength/2),...
    (g_strctParadigm.m_strctOrientationFunctionParams.m_afCenterOfStimulus(2) + g_strctParadigm.m_strctOrientationFunctionParams.m_fWidth/2)];


[g_strctParadigm, strctTrial] = fnChooseOrientation(g_strctParadigm, strctTrial);



[strctTrial.point1(1,1), strctTrial.point1(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point2(1,1), strctTrial.point2(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,1),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point3(1,1), strctTrial.point3(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,4),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.point4(1,1), strctTrial.point4(2,1)] = fnRotateAroundPoint(strctTrial.bar_rect(1,3),strctTrial.bar_rect(1,2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_starting_point(1,1),strctTrial.bar_starting_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) - strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
[strctTrial.bar_ending_point(1,1),strctTrial.bar_ending_point(2,1)] = fnRotateAroundPoint(strctTrial.location_x(1),(strctTrial.location_y(1) + strctTrial.m_iMoveDistance/2),strctTrial.location_x(1),strctTrial.location_y(1),strctTrial.m_fRotationAngle);
% clear this or if the stimulus on time is changed it will break the array and crash kofiko
[strctTrial.coordinatesX, strctTrial.coordinatesY]  = deal(zeros(4, strctTrial.numFrames, strctTrial.m_iNumberOfBars));

% Check if the trial has more than 1 frame in it, so we can plan the trial
if strctTrial.numFrames > 1
    % Calculate coordinates for every frame
    
    strctTrial.coordinatesX(1:4,:,strctTrial.m_iNumberOfBars) = vertcat(round(linspace(strctTrial.point1(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point1(1,strctTrial.m_iNumberOfBars)-(strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point2(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point2(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point3(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point3(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point4(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(1,strctTrial.m_iNumberOfBars)),strctTrial.point4(1,strctTrial.m_iNumberOfBars) - (strctTrial.location_x(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(1,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)));
    
    strctTrial.coordinatesY(1:4,:,strctTrial.m_iNumberOfBars) = vertcat(round(linspace(strctTrial.point1(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point1(2,strctTrial.m_iNumberOfBars)-(strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point2(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point2(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point3(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point3(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)),...
        round(linspace(strctTrial.point4(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_starting_point(2,strctTrial.m_iNumberOfBars)),strctTrial.point4(2,strctTrial.m_iNumberOfBars) - (strctTrial.location_y(strctTrial.m_iNumberOfBars) - strctTrial.bar_ending_point(2,strctTrial.m_iNumberOfBars)),strctTrial.numFrames)));
else
    strctTrial.coordinatesX(1:4,:) = [strctTrial.point1(1), strctTrial.point2(1), strctTrial.point3(1),strctTrial.point4(1)];
    strctTrial.coordinatesY(1:4,:) = [strctTrial.point1(2), strctTrial.point2(2), strctTrial.point3(2),strctTrial.point4(2)];
end
return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------


function [g_strctParadigm, strctTrial] = fnPrepareRealTimeGaborTrial(g_strctParadigm, g_strctPTB, strctTrial)

strctTrial.m_iFixationColor = [255 255 255];
strctTrial.numberBlurSteps = 0;
strctTrial.m_fStimulusON_MS = 0;
strctTrial.m_fStimulusOFF_MS = 0;
strctTrial.numFrames = 1; % Tells the stimulus server to update every frame
strctTrial.m_bUseStrobes = 0;
strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.GaborOrientation.Buffer(1,:,g_strctParadigm.GaborOrientation.BufferIdx));
strctTrial.m_iLength = squeeze(g_strctParadigm.GaborBarLength.Buffer(1,:,g_strctParadigm.GaborBarLength.BufferIdx));
strctTrial.m_iWidth = squeeze(g_strctParadigm.GaborBarWidth.Buffer(1,:,g_strctParadigm.GaborBarWidth.BufferIdx));
%strctTrial.m_iNumberOfBars = squeeze(g_strctParadigm.NumberOfBars.Buffer(1,:,g_strctParadigm.GaborNumberOfBars.BufferIdx));


strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.GaborMoveDistance.Buffer(1,:,g_strctParadigm.GaborMoveDistance.BufferIdx));

[strctTrial] = fnCycleColor(strctTrial);

strctTrial.Clut(:,1) = round(linspace(0,65535,256));
strctTrial.Clut(:,2) = round(linspace(0,65535,256));
strctTrial.Clut(:,3) = round(linspace(0,65535,256));
strctTrial.m_afCenterScreen = [1024/2,768/2];

strctTrial.m_iSigma = squeeze(g_strctParadigm.GaborSigma.Buffer(1,:,g_strctParadigm.GaborSigma.BufferIdx));
strctTrial.m_iGaborFreq = squeeze(g_strctParadigm.GaborFreq.Buffer(1,:,g_strctParadigm.GaborFreq.BufferIdx))*1e-3;

strctTrial.m_iContrast = squeeze(g_strctParadigm.GaborContrast.Buffer(1,:,g_strctParadigm.GaborContrast.BufferIdx));
strctTrial.m_bNonsymmetric = g_strctParadigm.m_strctGaborParams.m_bNonsymmetric ;

if g_strctPTB.m_variableUpdating && strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, 'GaborPhase')
    strctTrial.m_fGaborPhase = (squeeze(g_strctParadigm.GaborPhase.Buffer(1,:,g_strctParadigm.GaborPhase.BufferIdx))); % The fnUpdateParadigmWithPTBSlider function will take care of wraparound in this case
elseif strctTrial.m_iMoveDistance > 0
    if g_strctParadigm.m_strctGaborParams.m_bReversePhaseDirection
        strctTrial.m_fGaborPhase = g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase - strctTrial.m_iMoveDistance/100;
    else
        strctTrial.m_fGaborPhase = g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase + strctTrial.m_iMoveDistance/100;
    end
    if strctTrial.m_fGaborPhase > 360 || strctTrial.m_fGaborPhase < 0
        strctTrial.m_fGaborPhase = strctTrial.m_fGaborPhase - floor(strctTrial.m_fGaborPhase/359)*359; % wrap around to other side
    end
    
    g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase = strctTrial.m_fGaborPhase;
    % This takes 8/10 of a ms, computationally expensive. Don't use during a real trial
	
    fnTsSetVarParadigm('GaborPhase', strctTrial.m_fGaborPhase);
    set(eval(['g_strctParadigm.m_strctControllers.m_hGaborPhaseSlider']),'value',strctTrial.m_fGaborPhase,'max', max(360,strctTrial.m_fGaborPhase), 'min',min(0,strctTrial.m_fGaborPhase));
    set(eval('g_strctParadigm.m_strctControllers.m_hGaborPhaseEdit'),'String', num2str(strctTrial.m_fGaborPhase));
    
else
    strctTrial.m_fGaborPhase = g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase;
end

% Size of support in pixels, derived from si:

strctTrial.AspectRatio = strctTrial.m_iLength/strctTrial.m_iWidth; % Not really sure what this does, but we can play with it
strctTrial.m_afDestRectangle = g_strctParadigm.m_aiStimulusRect;


% Alternative Matlab code. Creates a nice pure color block... useless atm
%{
[gab_x gab_y] = meshgrid(0:(strctTrial.tw-1), 0:(strctTrial.th-1));
a=cos(deg2rad(strctTrial.m_fRotationAngle))*strctTrial.GaborHorzFreq*360;
b=sin(deg2rad(strctTrial.m_fRotationAngle))*strctTrial.GaborHorzFreq*360;
multConst=1/(sqrt(2*pi)*strctTrial.m_iSigma);
%multConst=1/(sqrt(2*pi)*sc);
x_factor=-1*(gab_x-g_strctParadigm.m_aiCenterOfStimulus(1)).^2;
y_factor=-1*(gab_y-g_strctParadigm.m_aiCenterOfStimulus(2)).^2;
sinWave=sin(deg2rad(a*(gab_x - g_strctParadigm.m_aiCenterOfStimulus(1)) + b*(gab_y - g_strctParadigm.m_aiCenterOfStimulus(2))+strctTrial.phase));
varScale=2*strctTrial.m_iSigma^2;
strctTrial.gaborArray = 0.5 + strctTrial.m_fContrast*(multConst*exp(x_factor/varScale+y_factor/varScale).*sinWave)';
%}
%strctTrial.m_hGaborArray = Screen('MakeTexture', g_strctPTB.m_hWindow, gaborArray);

if ~g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized
    strctTrial.tw = 1024;
    strctTrial.th = 768;
    fnParadigmToStimulusServer('InitializeGaborTexture', strctTrial.tw, strctTrial.th, strctTrial.m_bNonsymmetric);% [0.5, 0.5, 0.5, 0])
    %PsychImaging('PrepareConfiguration');
    %PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    g_strctParadigm.m_hGabortex = CreateProceduralGabor(g_strctPTB.m_hWindow, strctTrial.tw, strctTrial.th, strctTrial.m_bNonsymmetric);%, [0.5, 0.5, 0.5, 1]);
    
   % Screen('BlendFunction', g_strctPTB.m_hWindow, GL_SRC_ALPHA, GL_ONE);
    Screen('BlendFunction', g_strctPTB.m_hWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %[sfOLD, dfOLD, cmOLD] = Screen('BlendFunction', g_strctPTB.m_hWindow, GL_ONE, GL_ONE);
    %sfOLD
    %dfOLD
    %cmOLD
    g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 1;
end

% we're going to futz with the colors using bits++ on the stimulus server, but we need to calibrate them for local display at some point
return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------

function [g_strctParadigm, strctTrial] = fnPrepareMovingDiscTrial(g_strctParadigm, g_strctPTB, strctTrial)

strctTrial.m_bUseStrobes = 0;

strctTrial.m_iFixationColor = [255 255 255];

strctTrial.m_iDiscDiameter = squeeze(g_strctParadigm.DiscDiameter.Buffer(1,:,g_strctParadigm.DiscDiameter.BufferIdx));

if g_strctParadigm.m_strctHandMappingParams.m_bPerfectCircles == 1
    %always on for now
    strctTrial.m_iLength = strctTrial.m_iDiscDiameter;
else
    strctTrial.m_iLength = squeeze(g_strctParadigm.BarLength.Buffer(1,:,g_strctParadigm.BarLength.BufferIdx));
end
strctTrial.m_iWidth = 0;


strctTrial.NumberOfDots = squeeze(g_strctParadigm.DiscNumberOfDiscs.Buffer(1,:,g_strctParadigm.DiscNumberOfDiscs.BufferIdx));


%strctTrial.m_fStimulusON_MS = g_strctParadigm.StimulusON_MS.Buffer(1,:,g_strctParadigm.StimulusON_MS.BufferIdx);



%g_strctParadigm.StimulusON_MS.Buffer(1,:,g_strctParadigm.StimulusON_MS.BufferIdx);


strctTrial.m_fStimulusOFF_MS = g_strctParadigm.DiscStimulusOffTime.Buffer(1,:,g_strctParadigm.DiscStimulusOffTime.BufferIdx);


strctTrial.m_iMoveDistance = squeeze(g_strctParadigm.DiscMoveDistance.Buffer(1,:,g_strctParadigm.DiscMoveDistance.BufferIdx));
strctTrial.m_iMoveSpeed = squeeze(g_strctParadigm.DiscMoveSpeed.Buffer(1,:,g_strctParadigm.DiscMoveSpeed.BufferIdx));
if any(strctTrial.m_iMoveDistance) && any(strctTrial.m_iMoveSpeed)
    strctTrial.m_fStimulusON_MS = (strctTrial.m_iMoveDistance/strctTrial.m_iMoveSpeed)*1e3;
    % strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
else
    
    strctTrial.m_fStimulusON_MS = g_strctParadigm.DiscStimulusOnTime.Buffer(1,:,g_strctParadigm.DiscStimulusOnTime.BufferIdx);
    %strctTrial.m_fStimulusON_MS = g_strctPTB.g_strctStimulusServer.m_RefreshRateMS;
    %strctTrial.m_fStimulusOFF_MS = 0;
    %strctTrial.numFrames = 1;
    
end

strctTrial.numFrames = round(strctTrial.m_fStimulusON_MS / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
if ~strctTrial.numFrames
    % Sanity check, in case speed and distance are too low
    strctTrial.numFrames = 1;
end

strctTrial.m_bBlur  = squeeze(g_strctParadigm.DiscBlur.Buffer(1,:,g_strctParadigm.DiscBlur.BufferIdx));
strctTrial.numberBlurSteps = round(squeeze(g_strctParadigm.DiscBlurSteps.Buffer(1,:,g_strctParadigm.DiscBlurSteps.BufferIdx)));

[strctTrial] = fnCycleColor(strctTrial);

if g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation
    strctTrial.m_fRotationAngle = round(19.*rand(1,1) + 1) * 18;
    
else
    strctTrial.m_fRotationAngle = squeeze(g_strctParadigm.DiscOrientation.Buffer(1,:,g_strctParadigm.DiscOrientation.BufferIdx));
end


if g_strctParadigm.m_bRandomDiscStimulusPosition
    minimum_seperation = max(strctTrial.m_iLength, strctTrial.m_iDiscDiameter)/2;
    for iNumOfDots = 1 : strctTrial.NumberOfDots
        % Random center points
        
        
        
        strctTrial.m_aiStimCenter(iNumOfDots,1) = g_strctParadigm.m_aiStimulusRect(1)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]));
        strctTrial.m_aiStimCenter(iNumOfDots,2) = g_strctParadigm.m_aiStimulusRect(2)+ round(rand*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)]));
     
    end
else
    for iNumOfDots = 1:strctTrial.NumberOfDots
        [strctTrial.m_aiStimCenter(iNumOfDots,[1:2])] = [(g_strctParadigm.m_aiStimulusRect(1) +...
            (.5*range([g_strctParadigm.m_aiStimulusRect(1),g_strctParadigm.m_aiStimulusRect(3)]))),...
            (g_strctParadigm.m_aiStimulusRect(2) +...
            (.5*range([g_strctParadigm.m_aiStimulusRect(2),g_strctParadigm.m_aiStimulusRect(4)])))];
    end
end
for iNumOfDots = 1:strctTrial.NumberOfDots
    
    
   
    [strctTrial.dot_starting_point(iNumOfDots,1),strctTrial.dot_starting_point(iNumOfDots,2)] = fnRotateAroundPoint(strctTrial.m_aiStimCenter(iNumOfDots,1),(strctTrial.m_aiStimCenter(iNumOfDots,2) -...
        strctTrial.m_iMoveDistance/2),strctTrial.m_aiStimCenter(iNumOfDots,1),strctTrial.m_aiStimCenter(iNumOfDots,2),strctTrial.m_fRotationAngle);
    
    [strctTrial.dot_ending_point(iNumOfDots,1),strctTrial.dot_ending_point(iNumOfDots,2)] = fnRotateAroundPoint(strctTrial.m_aiStimCenter(iNumOfDots,1),(strctTrial.m_aiStimCenter(iNumOfDots,2) +...
        strctTrial.m_iMoveDistance/2),strctTrial.m_aiStimCenter(iNumOfDots,1),strctTrial.m_aiStimCenter(iNumOfDots,2),strctTrial.m_fRotationAngle);
    
    strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,:) = [(strctTrial.dot_starting_point(iNumOfDots,1) - strctTrial.m_iLength/2), (strctTrial.dot_starting_point(iNumOfDots,2) - strctTrial.m_iDiscDiameter/2), ...
        (strctTrial.dot_starting_point(iNumOfDots,1) + strctTrial.m_iLength/2), (strctTrial.dot_starting_point(iNumOfDots,2) + strctTrial.m_iDiscDiameter/2)];
    
    strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,:) = [(strctTrial.dot_ending_point(iNumOfDots,1) - strctTrial.m_iLength/2), (strctTrial.dot_ending_point(iNumOfDots,2) - strctTrial.m_iDiscDiameter/2), ...
        (strctTrial.dot_ending_point(iNumOfDots,1) + strctTrial.m_iLength/2), (strctTrial.dot_ending_point(iNumOfDots,2) + strctTrial.m_iDiscDiameter/2)];
    
    strctTrial.m_aiCoordinates(1:4,:,iNumOfDots) = vertcat(round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,1),strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,1),strctTrial.numFrames)),...
        round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,2),strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,2),strctTrial.numFrames)),...
        round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,3), strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,3),strctTrial.numFrames)),...
        round(linspace(strctTrial.m_aiStimRectangleStartingCoordinates(iNumOfDots,4), strctTrial.m_aiStimRectangleEndingCoordinates(iNumOfDots,4),strctTrial.numFrames)));
    
end


return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------




function [g_strctParadigm, strctTrial] = fnChooseOrientation(g_strctParadigm, strctTrial)

strctTrial.OrientationID = g_strctParadigm.m_strctOrientationFunctionParams.fOrientationID;

% Random order?
if g_strctParadigm.m_strctOrientationFunctionParams.m_bRandomOrientation
    strctTrial.OrientationID = ceil(rand*g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest);
    %(360/g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest).*ceil(rand*g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest);
    
elseif g_strctParadigm.m_strctOrientationFunctionParams.m_bReverseOrientationOrder
    if strctTrial.OrientationID == 1
        strctTrial.OrientationID = g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest;
    else
        strctTrial.OrientationID = strctTrial.OrientationID-1;
    end
    
else
    if strctTrial.OrientationID == g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest
        strctTrial.OrientationID = 1;
    else
        strctTrial.OrientationID = strctTrial.OrientationID + 1;
    end
end
strctTrial.m_fRotationAngle = round(strctTrial.OrientationID * 360/g_strctParadigm.m_strctOrientationFunctionParams.m_iNumberOfOrientationsToTest);
g_strctParadigm.m_strctOrientationFunctionParams.fOrientationID = strctTrial.OrientationID;
g_strctParadigm.m_iTrialStrobeID = g_strctParadigm.m_strctOrientationFunctionParams.fOrientationID;
return;

% ------------------------------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------------------------------


function [strctTrial] = fnCycleColor(strctTrial)
global g_strctParadigm
min_distance = min((strctTrial.m_iLength/2)-1,(strctTrial.m_iWidth/2)-1);
strctTrial.m_bUseBitsPlusPlus = 1;
if strctTrial.numberBlurSteps > min_distance
	strctTrial.numberBlurSteps = floor(min_distance);
elseif strctTrial.numberBlurSteps == 0
	strctTrial.numberBlurSteps = 1;
elseif strctTrial.numberBlurSteps >= 250
% don't exceed the number of CLUT slots
	strctTrial.numberBlurSteps = 250;
end
	currentBlockStimBGColorsR = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundRed'];
    currentBlockStimBGColorsG = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundGreen'];
    currentBlockStimBGColorsB = [g_strctParadigm.m_strCurrentlySelectedBlock,'BackgroundBlue'];
	
	currentBlockStimulusColorsR = [g_strctParadigm.m_strCurrentlySelectedBlock,'StimulusRed'];
    currentBlockStimulusColorsG = [g_strctParadigm.m_strCurrentlySelectedBlock,'StimulusGreen'];
    currentBlockStimulusColorsB = [g_strctParadigm.m_strCurrentlySelectedBlock,'StimulusBlue'];
	
	

	
strctTrial.m_afLocalBackgroundColor = [squeeze(g_strctParadigm.(currentBlockStimBGColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimBGColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimBGColorsB).BufferIdx))];

strctTrial.m_afBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/255) * 65535);

%x(1,1) = [1,2]
numSaturations = numel(g_strctParadigm.m_strctCurrentSaturation);

% Prevent crash if user changed saturations between trials
if g_strctParadigm.m_iSelectedSaturationIndex > numSaturations
	g_strctParadigm.m_iSelectedSaturationIndex = numSaturations;
end
if ~iscell(g_strctParadigm.m_strctCurrentSaturation)
	g_strctParadigm.m_strctCurrentSaturation = {g_strctParadigm.m_strctCurrentSaturation};
end

if strcmp(strctTrial.m_strTrialType,'Plain Bar') && g_strctParadigm.m_bUsePlainBarPresetColors ||...
	strcmp(strctTrial.m_strTrialType,'Moving Bar') && g_strctParadigm.m_bUseMovingBarPresetColors ||...
	strcmp(strctTrial.m_strTrialType,'Moving Dots') && g_strctParadigm.m_bUseDiscPresetColors ||...
	strcmp(strctTrial.m_strTrialType,'Gabor') && g_strctParadigm.m_bUseGaborPresetColors 
	
		switch strctTrial.m_strTrialType
			case 'Plain Bar'
				PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'StaticBarStimulusPresetColor');
				
			case 'Moving Bar'
				PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'MovingBarStimulusPresetColor');
				
			case 'Moving Dots'
				PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'DiscStimulusPresetColor');
				
			case 'Gabor'
			   PresetColorIndex = fnTsGetVar('g_strctParadigm' ,'GaborStimulusPresetColor');

		end
	
	if PresetColorIndex > size(g_strctParadigm.m_cPresetColors,1)
		PresetColorIndex = size(g_strctParadigm.m_cPresetColors,1);
	elseif PresetColorIndex <= 0
		PresetColorIndex = 1;
	end
	
   
	
	strctTrial.m_aiLocalStimColor = g_strctParadigm.m_cPresetColors{PresetColorIndex,1};
	strctTrial.m_afLocalBackgroundColor = g_strctParadigm.m_cPresetColors{PresetColorIndex,2};
	

    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor/255) * 65535);
    strctTrial.m_afBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/255) * 65535);
elseif g_strctParadigm.m_bCycleColors || g_strctParadigm.m_bRandomColor
	if g_strctParadigm.m_iSelectedSaturationIndex > size(g_strctParadigm.m_strctCurrentSaturation,1)
		g_strctParadigm.m_iSelectedSaturationIndex = 1;
	end
	strctTrial.m_afBackgroundColor = g_strctParadigm.m_aiCalibratedBackgroundColor;
	strctTrial.m_afLocalBackgroundColor = round((strctTrial.m_afBackgroundColor/65535)*255);
    strctTrial.m_bUseBitsPlusPlus = 1;
    if g_strctParadigm.m_bRandomColor
        %ClockRandSeed();
        g_strctParadigm.m_iSelectedSaturationIndex = ceil(rand(1) * numSaturations);
		
       % ClockRandSeed();
        g_strctParadigm.m_iSelectedColorIndex = ceil(rand(1)* size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1));
		
        strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_aiStimxyY = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.xyY(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex;
        strctTrial.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex;
		
		
    elseif ~g_strctParadigm.m_bReverseColorOrder
        g_strctParadigm.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex + 1;
        if g_strctParadigm.m_iSelectedColorIndex > size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1)
            
            g_strctParadigm.m_iSelectedColorIndex = 1;
            g_strctParadigm.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex + 1;
            if g_strctParadigm.m_iSelectedSaturationIndex > numSaturations
                
                g_strctParadigm.m_iSelectedSaturationIndex = 1;
            end
        end
        strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_aiStimxyY = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.xyY(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex;
		strctTrial.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex;
		
		
    elseif g_strctParadigm.m_bReverseColorOrder
        g_strctParadigm.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex - 1;
        
        if g_strctParadigm.m_iSelectedColorIndex < 1
            g_strctParadigm.m_iSelectedColorIndex = size(g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB,1);
            g_strctParadigm.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex - 1;
            if g_strctParadigm.m_iSelectedSaturationIndex < 1
                
                g_strctParadigm.m_iSelectedSaturationIndex = numSaturations;
            end
        end
        
        strctTrial.m_aiStimColor = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.RGB(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_aiStimxyY = g_strctParadigm.m_strctCurrentSaturation{g_strctParadigm.m_iSelectedSaturationIndex}.xyY(g_strctParadigm.m_iSelectedColorIndex,:);
        strctTrial.m_iSelectedColorIndex = g_strctParadigm.m_iSelectedColorIndex;
		strctTrial.m_iSelectedSaturationIndex = g_strctParadigm.m_iSelectedSaturationIndex;
    end
    strctTrial.m_aiLocalStimColor = round((strctTrial.m_aiStimColor/65535)*255);

elseif g_strctParadigm.m_bUseCartesianCoordinates

	strctTrial.m_bUseBitsPlusPlus = 1;
    strctTrial.m_aiCLUT = zeros(256,3);
    
    YCoord = squeeze(g_strctParadigm.CartesianYCoord.Buffer(1,:,g_strctParadigm.CartesianYCoord.BufferIdx));
    XCoord = squeeze(g_strctParadigm.CartesianXCoord.Buffer(1,:,g_strctParadigm.CartesianXCoord.BufferIdx));
    ZCoord = squeeze(g_strctParadigm.CartesianZCoord.Buffer(1,:,g_strctParadigm.CartesianZCoord.BufferIdx));
    %[rgb] = ldrgyv2rgb(ld,rg,yv)
    [rgb] = ldrgyv2rgb((ZCoord/1000)-1, (XCoord/1000)-1, (YCoord/1000)-1);
	
	rgb(rgb >= 1) = 1;
	rgb(rgb <= 0) = 0;
    strctTrial.m_aiLocalStimColor = round(rgb * 255);
    strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(round(rgb(1) * 65535)),...
	g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(round(rgb(2) * 65535)),...
	g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(round(rgb(3) * 65535))];
	
	
	strctTrial.m_afBackgroundColor = round((strctTrial.m_afLocalBackgroundColor/255) * 65535);
    % g_strctParadigm.m_strctConversionMatrices
    
    
    strctTrial.m_aiCLUT(2,:) = round((strctTrial.m_afBackgroundColor/255) * 65535);
    strctTrial.m_aiCLUT(3,:) = strctTrial.m_aiStimColor;
    strctTrial.m_aiCLUT(256,:) = ones(1,3) * 65535;
	

elseif strctTrial.m_bUseBitsPlusPlus

	strctTrial.m_aiLocalStimColor= [squeeze(g_strctParadigm.(currentBlockStimulusColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsR).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimulusColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsG).BufferIdx))...
        squeeze(g_strctParadigm.(currentBlockStimulusColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsB).BufferIdx))];

    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor /255)*65535);
    
else
    
    strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.MovingBarStimulusRed.Buffer(1,:,g_strctParadigm.MovingBarStimulusRed.BufferIdx)), ...
        squeeze(g_strctParadigm.MovingBarStimulusGreen.Buffer(1,:,g_strctParadigm.MovingBarStimulusGreen.BufferIdx)),...
        squeeze(g_strctParadigm.MovingBarStimulusBlue.Buffer(1,:,g_strctParadigm.MovingBarStimulusBlue.BufferIdx))];
    strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor/255)*65535);
end
%if strctTrial.m_bUseBitsPlusPlus
if strctTrial.numberBlurSteps > 0
    strctTrial.m_aiCLUT = zeros(256,3);
    strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,1) = round(linspace(strctTrial.m_afBackgroundColor(1),strctTrial.m_aiStimColor(1),strctTrial.numberBlurSteps)) ;
    strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,2) = round(linspace(strctTrial.m_afBackgroundColor(2),strctTrial.m_aiStimColor(2),strctTrial.numberBlurSteps)) ;
    strctTrial.m_aiCLUT(3:3+strctTrial.numberBlurSteps-1,3) = round(linspace(strctTrial.m_afBackgroundColor(3),strctTrial.m_aiStimColor(3),strctTrial.numberBlurSteps)) ;
    strctTrial.m_aiCLUT(256,:) = deal(65535);
else
    strctTrial.m_aiCLUT = zeros(256,3);
    strctTrial.m_aiCLUT(2,:) = strctTrial.m_afBackgroundColor;
    strctTrial.m_aiCLUT(3,:) = strctTrial.m_aiStimColor;
    strctTrial.m_aiCLUT(256,:) = deal(65535);
    
end

strctTrial.m_aiLocalBlurStepHolder(1,:) = round(linspace(strctTrial.m_afLocalBackgroundColor(1),strctTrial.m_aiLocalStimColor(1),strctTrial.numberBlurSteps));
strctTrial.m_aiLocalBlurStepHolder(2,:) = round(linspace(strctTrial.m_afLocalBackgroundColor(2),strctTrial.m_aiLocalStimColor(2),strctTrial.numberBlurSteps));
strctTrial.m_aiLocalBlurStepHolder(3,:) = round(linspace(strctTrial.m_afLocalBackgroundColor(3),strctTrial.m_aiLocalStimColor(3),strctTrial.numberBlurSteps));
strctTrial.m_aiBlurStepHolder(1,:) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
strctTrial.m_aiBlurStepHolder(2,:) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
strctTrial.m_aiBlurStepHolder(3,:) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));

return;


function [rgb] = ldrgyv2rgb(ld,rg,yv)
global g_strctParadigm
ldrgyv = [ld rg yv]';

%matrix=[	1 1 dRyv;
%1 dGrg dGyv;
%1 dBrg 1];


% Values for MIT, july 2015
matrix = g_strctParadigm.m_strctConversionMatrices.ldgyb;

%{
matrix=  [1	1	0.304455308556149
			1	-0.253409957412193	-0.257060304918859
			1	0.00799723127465672	1];
%}
% These are the correct values given out
% by the calib_correct function.


rgb = matrix*ldrgyv/2.0 + 0.5;
return;




