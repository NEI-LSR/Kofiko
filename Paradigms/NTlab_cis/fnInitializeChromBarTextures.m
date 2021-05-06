function fnInitializeChromBarTextures(stim_length, CurCLUTOffset, cloudstims, cloudstims_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)

% case {'annuli','disc','nestedannuli'}
%     if nargin == 7
        fnGenerateChromBarTextures(stim_length, CurCLUTOffset, cloudstims, cloudstims_binned);%numDiscs, textureSize, numEntriesPerTexture);
%     else
%         fnGenerateHartleyTextures(filename, cur_clut);%numDiscs, textureSize, numEntriesPerTexture, varargin{1});
%     end
% end
return;

function fnGenerateChromBarTextures(stim_length, CurCLUTOffset, cloudstims, cloudstims_binned) % (numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw
    try
    if  isfield(g_strctDraw,'chrombar_disp') %exist('g_strctDraw.chrombar_disp', 'var') %&&
        Screen('Close',g_strctDraw.chrombar_disp);
    end
    
    end
    for iTextures = 1:size(cloudstims_binned,3)%stim_length
        g_strctDraw.chrombar_disp(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(cloudstims_binned(:,:,iTextures,:))+CurCLUTOffset);
    end
    fprintf('finished preparing bar set \n')

%       dbstop if warning
%       warning('stop')
else
    global g_strctParadigm
    
%    ClutEncoded = BitsPlusEncodeClutRow( g_strctDraw.m_strctTrial.m_aiCLUT );
    try
    if isfield(g_strctParadigm,'chrombar_local') %exist('g_strctParadigm.chrombar_local','var') %&& 
        Screen('Close',g_strctParadigm.chrombar_local);
%        Screen('Close');
    end
    end
    for iTextures = 1:stim_length
        g_strctParadigm.chrombar_local(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(cloudstims(:,:,iTextures,:)));
    end
    fprintf('finished preparing bar set \n')

end

return;
