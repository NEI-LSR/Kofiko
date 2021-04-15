%% Error stack
*** Warning, sound file Digital Audio (S/PDIF) (High De is missing
Load sounds Done.
Warning: Using 'state' to set RAND's internal state causes RAND, RANDI, and RANDN to use legacy random number generators.  This syntax
will be removed in a future release.  See Updating Your Random Number Generator Syntax to use RNG to replace the old syntax. 
> In ClockRandSeed at 69
  In fnNTlabInit at 634
  In fnRunParadigm at 57
  In Kofiko at 181
  In RegisterGUI>hStartKofiko_Callback at 291
  In gui_mainfcn at 96
  In RegisterGUI at 44
  In @(hObject,eventdata)RegisterGUI('hStartKofiko_Callback',hObject,eventdata,guidata(hObject)) 
Parsing XML, please wait...Done!
Error in fnHandMappingPrepareTrial (line 7)
global g_strctParadigm g_strctPTB

Output argument "strctTrial" (and maybe others) not assigned during call to
"C:\Users\Admin\Documents\Kofiko\Paradigms\HandMapping\fnHandMappingPrepareTrial.m>fnHandMappingPrepareTrial".

Error in fnNTlabCycle (line 150)
            g_strctParadigm.m_strctAllPlannedTrials = fnHandMappingPrepareTrial();

Error in fnKofikoCycleClean (line 657)
    feval(g_strctParadigm.m_strCycle, strctInputs, g_strctCycle.m_bParadigmPaused);  % This takes 0.1ms for the Passive fixation

Error in fnRunParadigm (line 241)
        fnKofikoCycleClean();

Error in Kofiko (line 181)
    fnRunParadigm();

Error in RegisterGUI>hStartKofiko_Callback (line 291)
Kofiko(strRigConfigFile,strctRegisterConfig);

Error in gui_mainfcn (line 96)
        feval(varargin{:});

Error in RegisterGUI (line 44)
    gui_mainfcn(gui_State, varargin{:});

Error in @(hObject,eventdata)RegisterGUI('hStartKofiko_Callback',hObject,eventdata,guidata(hObject))

 
150             g_strctParadigm.m_strctAllPlannedTrials = fnHandMappingPrepareTrial();

ans =

     1
%% stack 2
Improper index matrix reference.

Error in Kofiko>SetTSName (line 800)
set( g_handles.hTSNameEdit,'string',g_strctAppConfig.m_astrctUserTS(iSelected).m_strName);
 
800 set( g_handles.hTSNameEdit,'string',g_strctAppConfig.m_astrctUserTS(iSelected).m_strName);
Improper index matrix reference.

Error in Kofiko>SetTSName (line 800)
set( g_handles.hTSNameEdit,'string',g_strctAppConfig.m_astrctUserTS(iSelected).m_strName);
 
800 set( g_handles.hTSNameEdit,'string',g_strctAppConfig.m_astrctUserTS(iSelected).m_strName);