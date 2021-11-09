function fnInitializeHartleyTextures(filename, CurCLUTOffset) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)

% switch lower(hartleytype)
% case {'annuli','disc','nestedannuli'}
%     if nargin == 7
        fnGenerateHartleyTextures(filename, CurCLUTOffset);%numDiscs, textureSize, numEntriesPerTexture);
%     else
%         fnGenerateHartleyTextures(filename, cur_clut);%numDiscs, textureSize, numEntriesPerTexture, varargin{1});
%     end
% end
return;

function fnGenerateHartleyTextures(filename, CurCLUTOffset) % (numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw
    if ~isfield(g_strctDraw,'hartleyset')
        g_strctDraw.hartleyset=load(filename);
        g_strctDraw.hartleyset.hartleys=shiftdim(127.5*(1+(g_strctDraw.hartleyset.hartleys50./max(max(max(g_strctDraw.hartleyset.hartleys50))))),1);
        g_strctDraw.hartleyset.hartleys_binned=shiftdim(g_strctDraw.hartleyset.hartleys50_binned,1);
    end
    if isfield(g_strctDraw,'hartleys_disp')
    Screen('Close',g_strctDraw.hartleys_disp)
    end
%     if isfield(g_strctDraw,'m_ahChoiceDiscTextures') && ~isempty(g_strctDraw.m_ahChoiceDiscTextures)
%         for iTextures = 1:numel(g_strctDraw.m_ahChoiceDiscTextures)
%             Screen('Close', g_strctDraw.m_ahChoiceDiscTextures(iTextures));
%         end
%         g_strctDraw.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
%     end
%    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );

    for iTextures = 1:length(g_strctDraw.hartleyset.hartleys_binned)
        g_strctDraw.hartleys_disp(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.hartleyset.hartleys_binned(:,:,iTextures,:)+ CurCLUTOffset));
    end
    for iTextures = 1:length(g_strctDraw.hartleyset.hartleys_binned)
        g_strctDraw.hartleys_disp(iTextures+length(g_strctDraw.hartleyset.hartleys_binned)) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.hartleyset.hartleys_binned(:,:,iTextures,:)+ CurCLUTOffset+7));
    end
    for iTextures = 1:length(g_strctDraw.hartleyset.hartleys_binned)
        g_strctDraw.hartleys_disp(iTextures+length(g_strctDraw.hartleyset.hartleys_binned)*2) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.hartleyset.hartleys_binned(:,:,iTextures,:)+ CurCLUTOffset+7+7));
    end
    fprintf('finished preparing hartley set \n')
%      dbstop if warning
%      warning('stop')
else
    global g_strctParadigm
    if ~isfield(g_strctParadigm,'hartleyset')
        g_strctParadigm.hartleyset=load(filename);
        g_strctParadigm.hartleyset.hartleys=shiftdim(127.5*(1+(g_strctParadigm.hartleyset.hartleys50./max(max(max(g_strctParadigm.hartleyset.hartleys50))))),1);
        g_strctParadigm.hartleyset.hartleys_binned=shiftdim(g_strctParadigm.hartleyset.hartleys50_binned,1);
    end
    if isfield(g_strctParadigm,'hartleys_local')
    Screen('Close',g_strctParadigm.hartleys_local)
    end
%     if isfield(g_strctDraw,'m_ahChoiceDiscTextures') && ~isempty(g_strctDraw.m_ahChoiceDiscTextures)
%         for iTextures = 1:numel(g_strctDraw.m_ahChoiceDiscTextures)
%             Screen('Close', g_strctDraw.m_ahChoiceDiscTextures(iTextures));
%         end
%         g_strctDraw.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
%     end

%    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );

    for iTextures = 1:length(g_strctParadigm.hartleyset.hartleys_binned)
        g_strctParadigm.hartleys_local(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctParadigm.hartleyset.hartleys(:,:,iTextures,:)));
    end
    for iTextures = 1:length(g_strctParadigm.hartleyset.hartleys_binned)
        g_strctParadigm.hartleys_local(iTextures+length(g_strctParadigm.hartleyset.hartleys_binned)) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  cat(3,squeeze(g_strctParadigm.hartleyset.hartleys(:,:,iTextures,:)),ones(50)*127,ones(50)*127));
    end
    for iTextures = 1:length(g_strctParadigm.hartleyset.hartleys_binned)
        g_strctParadigm.hartleys_local(iTextures+length(g_strctParadigm.hartleyset.hartleys_binned)*2) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  cat(3,ones(50)*127,squeeze(g_strctParadigm.hartleyset.hartleys(:,:,iTextures,:)),ones(50)*127));
    end
    fprintf('finished preparing hartley set \n')

end

return;
