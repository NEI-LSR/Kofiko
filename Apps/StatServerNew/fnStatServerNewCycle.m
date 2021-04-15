if ~g_strctCycle.m_bClientConnected
    fnStatLog('Listening on port %d...',g_strctConfig.m_strctServer.m_fPort);
    drawnow
    [g_strctNet.m_iCommSocket,g_strctNet.m_strIP] = msaccept(g_strctNet.m_iServerSocket, g_strctConfig.m_strctServer.m_fListenTimeOutSec);
    if g_strctNet.m_iCommSocket > 0
        g_strctCycle.m_bClientConnected = true;
        fnStatLog('Client connected! [%s] \n',g_strctNet.m_strIP);
        drawnow          
    end;
    
end