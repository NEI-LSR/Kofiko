function [fChoicesOnsetTS] = fnDisplayChoicesTraining(hPTBWindow, m_strctKeepCurrentTrial,bFlip,bClear)
global  g_strctPTB
% Clear screen

if m_strctKeepCurrentTrial.m_strctTrialParams.m_bDynamicTrial
    if g_strctPTB.m_bRunningOnStimulusServer
	fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, m_strctKeepCurrentTrial, bFlip, bClear);
									
    else
        fnDynamicTrial(hPTBWindow, m_strctKeepCurrentTrial, bFlip, bClear);
									
    end
    return;
end	
    
return;

%function fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, aiChoices, m_strctKeepCurrentTrial, acMedia,bFlip,bClear,bHighlightRewardedChoices,fScale, bDrawResponseRegion)
function fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, m_strctKeepCurrentTrial,bFlip,bClear)
global  g_strctPTB 
if bClear && g_strctPTB.m_bRunningOnStimulusServer
	Screen('FillRect',hPTBWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor);
elseif bClear && ~g_strctPTB.m_bRunningOnStimulusServer
    global g_strctParadigm
	Screen('FillRect',hPTBWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor,...
				[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_m_strctKeepCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3),...
				g_strctPTB.m_fScale*g_strctParadigm.m_m_strctKeepCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(4)]);

end
switch lower(m_strctKeepCurrentTrial.m_strChoiceDisplayType)
	case {'disc', 'annuli', 'nestedannuli'}
		[fChoicesOnsetTS] = fnDisplayChoiceDiscs(m_strctKeepCurrentTrial, bFlip);
	case 'ring'
		[fChoicesOnsetTS] = fnDisplayChoiceRing(m_strctKeepCurrentTrial, bFlip);


end
return;

function [fChoicesOnsetTS] = fnDisplayChoiceDiscs(m_strctKeepCurrentTrial, bFlip)
global g_strctPTB                                                                                                                                                                                                                  
if g_strctPTB.m_bRunningOnStimulusServer
global g_strctDraw
	Screen('FillRect',g_strctPTB.m_hWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT);
	thisFrame = rem(m_strctKeepCurrentTrial.m_iChoiceFrameCounter, m_strctKeepCurrentTrial.m_iMaxFramesInChoiceEpoch);
            thisFrame(thisFrame == 0) = 1;

    if m_strctKeepCurrentTrial.m_bLuminanceNoiseBackground        
        thisFrame(thisFrame == 0) = 1;
		Screen('DrawTexture', g_strctPTB.m_hWindow, ...
            g_strctDraw.m_ahNoiseTextures(m_strctKeepCurrentTrial.m_aiLuminanceNoisePatternID(thisFrame)), ...
            [], m_strctKeepCurrentTrial.m_afChoiceRingDestinationRect );
    end
     %dbstop if warning
	 %ShowCursor
     %warning('stop')
	 
    iChoices = m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs
       thisChoicesFrameID = ...
           g_strctDraw.m_ahChoiceDiscTextures(...
           iChoices,... % m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),...
		   		   m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder(iChoices,thisFrame)); %m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder(m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),thisFrame));  
   	Screen('DrawTextures', g_strctPTB.m_hWindow, ...
       thisChoicesFrameID', ...
        [] ,m_strctKeepCurrentTrial.m_aiChoiceScreenCoordinates');
	%{
        Screen('DrawTextures', g_strctPTB.m_hWindow, ...
        g_strctDraw.m_ahChoiceDiscTextures(...
m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs,...
        m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder(:,thisFrame))', ...
        [] ,m_strctKeepCurrentTrial.m_aiChoiceScreenCoordinates');
        %}
	%fnDrawFixationSpot(g_strctPTB.m_hWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod, false, 1);

    ClutEncoded = BitsPlusEncodeClutRow( m_strctKeepCurrentTrial.m_strctChoicePeriod.Clut );
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
	Screen('DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	Screen('Close',ClutTextureIndex);
	
    g_strctDraw.m_m_strctKeepCurrentTrial.m_iChoiceFrameCounter = m_strctKeepCurrentTrial.m_iChoiceFrameCounter + 1;
	%g_strctDraw.m_m_strctKeepCurrentTrial.m_iChoiceFrameCounter
    if bFlip
		fChoicesOnsetTS = fnFlipWrapper(g_strctPTB.m_hWindow); % This would block the server until the next flip.
    end
	


	 
else
	global g_strctParadigm 
	thisFrame = rem(m_strctKeepCurrentTrial.m_iChoiceFrameCounter, m_strctKeepCurrentTrial.m_iMaxFramesInChoiceEpoch);
		thisFrame(thisFrame == 0) = 1;
	
	iChoices = m_strctKeepCurrentTrial.m_strctChoiceVars.m_iSelectedChoiceID;
       thisChoicesFrameID = ...
           g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(...
           g_strctParadigm.m_m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),... 
           g_strctParadigm.m_m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder(iChoices,thisFrame)); %g_strctParadigm.m_m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder(g_strctParadigm.m_m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),thisFrame));  
   

	Screen('DrawTextures', g_strctPTB.m_hWindow, ...
		thisChoicesFrameID', ...
		[] ,g_strctPTB.m_fScale * m_strctKeepCurrentTrial.m_aiChoiceScreenCoordinates');
		%{
		Screen('DrawTextures', g_strctPTB.m_hWindow, ...
	g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(m_strctKeepCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs, m_strctKeepCurrentTrial.thisTrialChoiceTextureOrder(thisFrame))', ...
		[] ,m_strctKeepCurrentTrial.m_aiChoiceScreenCoordinates');
		%}
	if g_strctParadigm.m_strctChoiceVars.m_bFrameChoiceAreas
		Screen('FrameRect', g_strctPTB.m_hWindow, [255 255 255],g_strctPTB.m_fScale * m_strctKeepCurrentTrial.m_strctReward.m_aiChoiceFramingRects);
	end
	%fnDrawFixationSpot(g_strctPTB.m_hWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod, false, 1);
    fChoicesOnsetTS = nan;
    g_strctParadigm.m_m_strctKeepCurrentTrial.m_iChoiceFrameCounter = thisFrame + 1;
	
    
end
return;

function [fChoicesOnsetTS] = fnDisplayChoiceRing(m_strctKeepCurrentTrial, bFlip)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw 

	% fill background color
	Screen('FillRect',g_strctPTB.m_hPTBWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT);
	%Screen('DrawTexture',g_strctPTB.m_hPTBWindow,g_strctDraw.ahChoiceTexture)

	Screen('DrawTexture', g_strctPTB.m_hPTBWindow, g_strctDraw.ahChoiceTexture, [],...
							m_strctKeepCurrentTrial.m_afChoiceRingDestinationRect, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_fRotationAngle);

	fnDrawFixationSpot(g_strctPTB.m_hPTBWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod, false, 1);

    ClutEncoded = BitsPlusEncodeClutRow( m_strctKeepCurrentTrial.m_strctChoicePeriod.Clut );
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hPTBWindow, ClutEncoded );
	Screen('DrawTexture', g_strctPTB.m_hPTBWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	Screen('Close',ClutTextureIndex);
	
    if bFlip
		fChoicesOnsetTS = fnFlipWrapper(g_strctPTB.m_hPTBWindow); % This would block the server until the next flip.
    end
else 
	global g_strctParadigm g_strctPTB
	Screen('FillRect',g_strctPTB.m_hPTBWindow, g_strctParadigm.m_aiLocalBackgroundColor);

	% fill background color
	% Screen('FillRect',g_strctPTB.m_hPTBWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor);
	% dbstop if warning
	% warning('stop')
	% Screen('DrawTexture',hPTBWindow,g_strctParadigm.ahChoiceTexture)


	Screen('DrawTexture', g_strctPTB.m_hPTBWindow, g_strctParadigm.ahChoiceTexture, [],...
							g_strctPTB.m_fScale * m_strctKeepCurrentTrial.m_afChoiceRingDestinationRect, m_strctKeepCurrentTrial.m_strctChoicePeriod.m_fRotationAngle);

	fnDrawFixationSpot(g_strctPTB.m_hPTBWindow, m_strctKeepCurrentTrial.m_strctChoicePeriod, false, 1);
    fChoicesOnsetTS = nan;
end
return;