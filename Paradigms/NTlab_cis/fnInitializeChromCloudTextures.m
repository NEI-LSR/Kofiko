function fnInitializeChromCloudTextures(stim_length, CurCLUTOffset, cloudstims, cloudstims_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)

% switch lower(hartleytype)
% case {'annuli','disc','nestedannuli'}
%     if nargin == 7
        fnGenerateChromCloudTextures(stim_length, CurCLUTOffset, cloudstims, cloudstims_binned);%numDiscs, textureSize, numEntriesPerTexture);
%     else
%         fnGenerateHartleyTextures(filename, cur_clut);%numDiscs, textureSize, numEntriesPerTexture, varargin{1});
%     end
% end
return;

function fnGenerateChromCloudTextures(stim_length, CurCLUTOffset, cloudstims, cloudstims_binned) % (numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw
  
%     if isfield(g_strctDraw,'m_ahChoiceDiscTextures') && ~isempty(g_strctDraw.m_ahChoiceDiscTextures)
%         for iTextures = 1:numel(g_strctDraw.m_ahChoiceDiscTextures)
%             Screen('Close', g_strctDraw.m_ahChoiceDiscTextures(iTextures));
%         end
%         g_strctDraw.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
%     end
%    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
    if isfield(g_strctDraw,'chromcloud_disp') && ~isempty(g_strctDraw.chromcloud_disp)
        Screen('Close',g_strctDraw.chromcloud_disp);
    end
    for iTextures = 1:stim_length
        g_strctDraw.chromcloud_disp(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(cloudstims_binned(:,:,iTextures,:))+CurCLUTOffset);
    end
    fprintf('finished preparing Ccloud set \n')

%      dbstop if warning
%      warning('stop')
else
    global g_strctParadigm
    
%     if isfield(g_strctDraw,'m_ahChoiceDiscTextures') && ~isempty(g_strctDraw.m_ahChoiceDiscTextures)
%         for iTextures = 1:numel(g_strctDraw.m_ahChoiceDiscTextures)
%             Screen('Close', g_strctDraw.m_ahChoiceDiscTextures(iTextures));
%         end
%         g_strctDraw.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
%     end

%    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
    if isfield(g_strctParadigm,'chromcloud_local') && ~isempty(g_strctParadigm.chromcloud_local)
        Screen('Close',g_strctParadigm.chromcloud_local);
    end
    for iTextures = 1:stim_length
        g_strctParadigm.chromcloud_local(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(cloudstims(:,:,iTextures,:)));
    end
    fprintf('finished preparing CCloud set \n')

end

return;
