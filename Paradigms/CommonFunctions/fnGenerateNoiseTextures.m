function fnGenerateNoiseTextures(noisePatterns, ColorOffset, ColorMultiplier)
global g_strctPTB
if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw 
    if isfield(g_strctDraw,'m_ahNoiseTextures') && ~isempty(g_strctDraw.m_ahNoiseTextures)
       for iTextures = 1:numel(g_strctDraw.m_ahNoiseTextures)
          Screen('Close', g_strctDraw.m_ahNoiseTextures(iTextures));
       end
       g_strctDraw.m_ahNoiseTextures = [];
    end
	for iTextures = 1:size(noisePatterns,3)
       g_strctDraw.m_ahNoiseTextures(iTextures) = Screen('MakeTexture', g_strctPTB.m_hWindow,  (noisePatterns(:,:,iTextures)*ColorMultiplier) + ColorOffset); 
    end
else 
	global g_strctParadigm 
    if isfield(g_strctParadigm,'m_ahNoiseTextures') && ~isempty(g_strctParadigm.m_ahNoiseTextures)
       for iTextures = 1:numel( g_strctParadigm.m_ahNoiseTextures)
          Screen('Close', g_strctParadigm.m_ahNoiseTextures(iTextures));
       end
       g_strctParadigm.m_ahNoiseTextures = [];
    end
    for iTextures = 1:size(noisePatterns,3)
        g_strctParadigm.m_ahNoiseTextures(iTextures) = Screen('MakeTexture', g_strctPTB.m_hWindow,  (noisePatterns(:,:,iTextures)*ColorMultiplier) + ColorOffset) ; 
    end
end

return;