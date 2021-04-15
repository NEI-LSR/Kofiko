function fnHandMappingEraseOpenTextures()
global g_strctPTB
if g_strctPTB.m_bRunningOnStimulusServer 
	global g_strctDraw
	if isfield(g_strctDraw,'m_ahHandles') &&  ~isempty(g_strctDraw.m_ahHandles)
		%isfield(g_strctParadigm,'m_strctMRIStim') && isfield(g_strctParadigm.m_strctMRIStim,'acFileNames') && ~isempty(g_strctParadigm.m_strctMRIStim.ahTextures)
		%g_strctDraw.m_ahHandles
		Screen('Close',g_strctDraw.m_ahHandles);
	end
else
	global g_strctParadigm
	if isfield(g_strctParadigm,'m_strctMRIStim') && isfield(g_strctParadigm.m_strctMRIStim,'acFileNames') && ~isempty(g_strctParadigm.m_strctMRIStim.ahTextures)
		
		disp(sprintf('closing textures 1 - %i',numel(g_strctParadigm.m_strctMRIStim.ahTextures)))
			Screen('Close',g_strctParadigm.m_strctMRIStim.ahTextures);
			
		end
end
return;