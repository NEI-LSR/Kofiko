function fnStatServerNewCycle()
global g_bAppIsRunning g_strctConfig  g_strctCycle g_DebugDataLog g_counter g_strctNeuralServer g_strctWindows
dbstop if error
addpath('.\MEX\win32;.\PublicLib\Plexon\Realtime;.\PublicLib\Msocket;');
g_strctConfig.m_strctDirectories.m_strDataFolder = 'C:\Data\Kofiko Statserver logs';
if ~exist(g_strctConfig.m_strctDirectories.m_strDataFolder,'dir')
    mkdir(g_strctConfig.m_strctDirectories.m_strDataFolder);
end;


fNow = now;
strTmp = datestr(fNow,25);
strDate = strTmp([1,2,4,5,7,8]);
strTmp = datestr(fNow,13);
strTime =  strTmp([1,2,4,5,7,8]);
g_strctCycle.m_strTmpSessionName = [strDate,'_',strTime,'_Unknown'];

%%
g_strctConfig.m_strctServer.m_fListenTimeOutSec = 1;
g_strctConfig.m_strctServer.m_fPort = 4003;
g_strctConfig.m_strctGUIParams.m_iSystemMouse = 3;
g_strctConfig.m_strctAdvancers.m_fMouseWheelToMM = 115;
  
g_strctConfig.m_strctServer.m_fAdvancerSampleHz= 5;
g_strctConfig.m_strctServer.m_fPingPongSec = 1;

g_strctConfig.m_strctConsistencyChecks.m_bLostUnits = true;
g_strctConfig.m_strctConsistencyChecks.m_fLostUnitCheckSec = 10; % Check every one minute
g_strctConfig.m_strctConsistencyChecks.m_fDeclareUnitThresSec = 20;

g_strctConfig.m_strctGUIParams.m_fBarGraphFrom = 50;
g_strctConfig.m_strctGUIParams.m_fBarGraphTo = 200;


g_strctConfig.m_strctGUIParams.m_iChannelDisplayStart = 1;
g_strctConfig.m_strctGUIParams.m_fRefreshHz = 1;
g_strctConfig.m_strctGUIParams.m_fSmoothingWindowMS = 15;
g_strctConfig.m_strctGUIParams.m_strViewMode = 'PSTH';
g_strctConfig.m_strctGUIParams.m_bAutoRescale = false;
g_strctConfig.m_strctGUIParams.m_bSmoothPSTH = true;
g_strctConfig.m_strctGUIParams.m_iMaxChannelsOnScreen = 4;
g_strctConfig.m_strctNeuralServer.m_strType = 'PLEXON';


g_strctCycle.m_strSafeCallback = [];
g_strctCycle.m_acSafeCallbackParams = {};
g_strctCycle.m_strctPlexonFrame.m_fMAPClockAtFrameStart = NaN;
g_strctCycle.m_strctPlexonFrame.m_fStatServerTS = NaN;
g_strctCycle.m_strctPlexonFrame.m_iCurrentPlexonFrame = NaN;
g_strctCycle.m_strctPlexonFrame.m_fKofiko_TS = NaN;

% Local time, Kofiko Time
g_strctCycle.m_strctSync = fnTsAddVar([], 'PlexonSync', [0 0 0 0], 500);
g_strctCycle.m_strctSync = fnTsAddVar(g_strctCycle.m_strctSync, 'KofikoSync', [GetSecs(), NaN], 8 * 60 * 60); % 8 hours... more than enough...
g_strctCycle.m_strctSync = fnTsAddVar(g_strctCycle.m_strctSync, 'KofikoSyncPingPong', [GetSecs(), NaN, 0], 8 * 60 * 60); % 8 hours... more than enough...
g_strctCycle.m_fSyncTimer = 0;


g_strctCycle.m_strSessionName = [];
g_strctCycle.m_strctWarnings.m_bUnidentifiedChannel = false;
g_strctCycle.m_bShutDownDone = false;
g_strctCycle.m_afAdvancerPrevReadOut = zeros(1,g_strctCycle.m_iNumAdvancers);
g_strctCycle.m_fAdvancerTimer  = 0;
g_strctCycle.m_fConsistencyTimerUnits = 0;
g_strctCycle.m_bClientConnected = false;
g_strctCycle.m_fRefreshTimer = 0;
g_strctCycle.m_bConditionInfoAvail = false;
g_strctCycle.m_bPlexonIsRecording = false;
g_strctCycle.m_iTrialCounter = 0;
g_strctCycle.m_iGlobalUnitCounter = 0;

hWarning = msgbox('Please make sure PlexNet is running and connected to the server!','Important Message');
waitfor(hWarning);
drawnow

if (~fnSetWindowAndButtons())
    return;
end;

bSuccess = fnConnectToNeuralServer();

if  ~bSuccess
       fprintf('***Critical Error connecting to Plexnet!\n');
       fnCloseStatServerFig([],[]);
        return;
end;

