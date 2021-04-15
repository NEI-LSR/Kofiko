function fnStandardCheckBoxCallback(hController, VarName)
global g_strctParadigm

iValue = get(hController,'value');
fnTsSetVar('g_strctParadigm',VarName,iValue);

feval(g_strctParadigm.m_strCallbacks,VarName);

return;
