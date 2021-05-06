function fnDisplayChoiceDiscs(hWindow,strctCurrentTrial);
                                                                                                                                                                                                                     
if g_strctPTB.m_bRunningOnStimulusServer
global g_strctDraw

	% fill background color
	Screen('FillRect',g_strctPTB.m_hWindow, strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT);
	%Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctDraw.ahChoiceTexture)

	Screen('FillOval', g_strctPTB.m_hWindow, strctCurrentTrial.m_iClutIndices, strctCurrentTrial.m_aiChoiceScreenCoordinates);

	fnDrawFixationSpot(g_strctPTB.m_hWindow, strctCurrentTrial.m_strctChoicePeriod, false, 1);

    ClutEncoded = BitsPlusEncodeClutRow( strctCurrentTrial.m_strctChoicePeriod.Clut );
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
    
	Screen('DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
    fChoicesOnsetTS = fnFlipWrapper(g_strctPTB.m_hWindow); % This would block the server until the next flip.

else
	global g_strctParadigm
	
	Screen('FillOval', g_strctPTB.m_hWindow, strctCurrentTrial.m_aiLocalStimulusColors, strctCurrentTrial.m_aiChoiceScreenCoordinates, [],...
							strctCurrentTrial.m_afChoiceRingDestinationRect, strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle);

	fnDrawFixationSpot(g_strctPTB.m_hWindow, strctCurrentTrial.m_strctChoicePeriod, false, 1);
end




return;