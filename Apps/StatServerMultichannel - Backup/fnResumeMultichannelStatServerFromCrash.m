function fnResumeMultichannelStatServerFromCrash()
global g_bAppIsRunning
drawnow
g_bAppIsRunning = true;
while (g_bAppIsRunning)
    fnStatServerMultichannelCycle();
end;

fnCloseMultichannelStatServer();

return;
