function fnDrawLuminanceCheckerboard(hWindow, strctCurrentTrial)
global g_strctPTB                                                                                                                                                                                                                  
if g_strctPTB.m_bRunningOnStimulusServer
	Screen('FillRect',hWindow, strctCurrentTrial.m_aiPixelGridLUTIndices, strctCurrentTrial.m_strctChoiceVars.checkerboardCoord);
else
    Screen('FillRect',hWindow, strctCurrentTrial.m_strctChoicePeriod.m_aiLocalLuminanceCheckerboard, strctCurrentTrial.m_strctChoiceVars.checkerboardCoord);
end
return;