function bBlinkTimerElapsed = fnCheckBlinkTimer(command)
global g_strctParadigm
switch command
	case 'reset'
		g_strctParadigm.m_fBlinkTimer = 0;
		g_strctParadigm.m_bBlinkTimerActive = false;
		bBlinkTimerElapsed = false;
	case 'check'
		if g_strctParadigm.m_fBlinkTimer == 0
			g_strctParadigm.m_fBlinkTimer = GetSecs();
			bBlinkTimerElapsed = false;
			g_strctParadigm.m_bBlinkTimerActive = true;
		elseif GetSecs() - g_strctParadigm.m_fBlinkTimer> ...
			fnTsGetVar('g_strctParadigm','BlinkTimeMS')/1e3
			bBlinkTimerElapsed = true;
			g_strctParadigm.m_bBlinkTimerActive = false;
		else
			bBlinkTimerElapsed = false;
			g_strctParadigm.m_bBlinkTimerActive = true;
		end
	end

return;