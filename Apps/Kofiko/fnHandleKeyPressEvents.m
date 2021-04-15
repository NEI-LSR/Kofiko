function fnHandleKeyPressEvents(keyCode, keyIsDown)
global g_strctGUIParams g_strctParadigm g_strctCycle

keyID = find(keyCode,1,'first');
switch keyID
    case g_strctGUIParams.m_fJuiceKey
        fnParadigmToKofikoComm('Juice', g_strctGUIParams.m_fJuiceTimeMS, true);
        
    case g_strctGUIParams.m_fRecenterKey
        fnRecenterGaze();
        
    case g_strctGUIParams.m_fDrawAttentionKey
        fnDrawAttention();
        
    case g_strctGUIParams.m_fEyeTracesKey
        g_strctCycle.m_strctEyeTraces.m_bShowEyeTraces = ~g_strctCycle.m_strctEyeTraces.m_bShowEyeTraces;
        if g_strctCycle.m_strctEyeTraces.m_bShowEyeTraces == 0
            g_strctCycle.m_strctEyeTraces.m_apt2fPreviousFixations(:) = 0;
        end
        
    case g_strctGUIParams.m_fResetStatKey
        feval(g_strctParadigm.m_strCallbacks,'ResetStat');
        
        
    case g_strctGUIParams.m_fToggleStat
        fnToggleShowStatistics([],[]);
        
        
    case g_strctGUIParams.m_fTogglePTB
        fnTogglePTB();
        
    otherwise
        if isfield(g_strctParadigm,'m_cParadigmSpecificKeyCodes')
            [~, idx] = ismember(keyID,[g_strctParadigm.m_cParadigmSpecificKeyCodes{:,1}]);
            if any(idx)
                eval(g_strctParadigm.m_cParadigmSpecificKeyCodes{idx,2});
            end
        end
       
end
 








return;