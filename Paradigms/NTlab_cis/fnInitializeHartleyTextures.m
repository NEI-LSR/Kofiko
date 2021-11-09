function fnInitializeHartleyTextures(hartleys_in) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)

% switch lower(hartleytype)
% case {'annuli','disc','nestedannuli'}
%     if nargin == 7
        fnGenerateHartleyTextures(hartleys_in);%numDiscs, textureSize, numEntriesPerTexture);
%     else
%         fnGenerateHartleyTextures(filename, cur_clut);%numDiscs, textureSize, numEntriesPerTexture, varargin{1});
%     end
% end
return;

function fnGenerateHartleyTextures(hartleys_in) % (numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw
%     if ~isfield(g_strctDraw,'hartleyset')
%         g_strctDraw.hartleyset=load(filename);
%         hartleys_tmp = reshape(g_strctDraw.hartleyset.hartleys60_DKL, [1152*60*60,3]);
%         hartleys_tmp = round(255*ldrgyv2rgb(hartleys_tmp(:,1)',hartleys_tmp(:,2)',hartleys_tmp(:,3)'));
%         g_strctDraw.hartleyset.hartleys=permute(reshape(hartleys_tmp', [1152,60,60,3]), [2,3,1,4]);
%         g_strctDraw.hartleyset.hartleys_binned=g_strctDraw.hartleyset.hartleys;
%     end
    g_strctDraw.hartleyset.hartleys_binned = hartleys_in;
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

    g_strctDraw.hartleyset.hartleys_binned = hartleys_in;
    for iTextures = 1:length(g_strctDraw.hartleyset.hartleys_binned)
        g_strctDraw.hartleys_disp(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(g_strctDraw.hartleyset.hartleys_binned(:,:,iTextures,:)));
    end

    fprintf('finished preparing hartley set \n')
%      dbstop if warning
%      warning('stop')
else
    global g_strctParadigm
%     if ~isfield(g_strctParadigm,'hartleyset')
%         g_strctParadigm.hartleyset=load(filename);
%         hartleys_tmp = reshape(g_strctParadigm.hartleyset.hartleys60_DKL, [1152*60*60,3]);
%         hartleys_tmp = round(255*ldrgyv2rgb(hartleys_tmp(:,1)',hartleys_tmp(:,2)',hartleys_tmp(:,3)'));
%         g_strctParadigm.hartleyset.hartleys=permute(reshape(hartleys_tmp', [1152,60,60,3]), [2,3,1,4]);
%         g_strctParadigm.hartleyset.hartleys_binned=g_strctParadigm.hartleyset.hartleys;
%     end
    g_strctParadigm.hartleyset.hartleys_binned = hartleys_in;
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

    fprintf('finished preparing hartley set \n')

end

return;
