function [strctOutput] = fnParadigmTouchForceChoiceClose()
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global g_strctParadigm g_strctDynamicStimLog

if isfield(g_strctParadigm,'m_strctNoise')
    g_strctParadigm = rmfield(g_strctParadigm,'m_strctNoise');
end
strctOutput = [];
%{
try
if ~isempty(g_strctDynamicStimLog)
	save([g_strctParadigm.m_strLogPath,'\',g_strctParadigm.m_strExperimentName,...
						'\',g_strctParadigm.m_strExperimentName,'-Final'],'g_strctDynamicStimLog');

	fnCombineExperimentBackups();
	m_aiMasterStatMatrix = g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix;
	save([g_strctParadigm.m_strLogPath,'\',g_strctParadigm.m_strExperimentName,...
							'\',g_strctParadigm.m_strExperimentName,'-statLog'],'m_aiMasterStatMatrix');


end
catch 
newSavePath = uigetdir('default save path unavailable or failed for unknown reason. Select new save path')
newSaveName = inputdlg('default save name unavailable or failed for unknown reason. Type experiment name')
newSaveName = newSaveName{1,:};
save([newSavePath, newSaveName, '-Final'],'g_strctDynamicStimLog');

	%fnCombineExperimentBackups();
	%m_aiMasterStatMatrix = g_strctParadigm.m_strctStatistics.m_aiMasterStatMatrix;
	%save([newSavePath,filesep, newSaveName,'-statLog'],'m_aiMasterStatMatrix');
end
%}


return;