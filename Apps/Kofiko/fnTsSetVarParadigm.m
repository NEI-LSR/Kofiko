function fnTsSetVarParadigm(strVarName, NewValue)
global g_strctParadigm


%iLastEntry = g_strctParadigm.(strVarName).BufferIdx;




%Buf = g_strctParadigm.(strVarName).Buffer;


sz = size(g_strctParadigm.(strVarName).Buffer);
%iBufferSize = sz(end);
if g_strctParadigm.(strVarName).BufferIdx+1 > sz(end)
	
	g_strctParadigm.(strVarName) = fnIncreaseBufferSize(g_strctParadigm.(strVarName));
	
end;
if iscell(g_strctParadigm.(strVarName).Buffer) %iscell(NewValue)
    g_strctParadigm.(strVarName).Buffer{g_strctParadigm.(strVarName).BufferIdx+1} = NewValue;

else
    g_strctParadigm.(strVarName).Buffer(:,:,g_strctParadigm.(strVarName).BufferIdx+1) = NewValue;

end

g_strctParadigm.(strVarName).TimeStamp(g_strctParadigm.(strVarName).BufferIdx+1) = GetSecs();
g_strctParadigm.(strVarName).BufferIdx = g_strctParadigm.(strVarName).BufferIdx+1;
return;

