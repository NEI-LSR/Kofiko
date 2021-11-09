function fnInitializeAChromBarTextures(stim_length, CurCLUTOffset, barstims, barstims_binned) %, numTextures, numDiscs, textureSize, numEntriesPerTexture, varargin)

% case {'annuli','disc','nestedannuli'}
%     if nargin == 7
        fnGenerateAChromBarTextures(stim_length, CurCLUTOffset, barstims, barstims_binned);%numDiscs, textureSize, numEntriesPerTexture);
%     else
%         fnGenerateHartleyTextures(filename, cur_clut);%numDiscs, textureSize, numEntriesPerTexture, varargin{1});
%     end
% end
return;

function fnGenerateAChromBarTextures(stim_length, CurCLUTOffset, barstims, barstims_binned) % (numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw
    try
    if  isfield(g_strctDraw,'chrombar_disp') %exist('g_strctDraw.chrombar_disp', 'var') %&&
        Screen('Close',g_strctDraw.chrombar_disp);
    end
    
    end
    for iTextures = 1:size(barstims_binned,3)%stim_length
        g_strctDraw.achrombar_disp(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(barstims_binned(:,:,iTextures,:))+CurCLUTOffset);
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
    for iTextures = 1:size(barstims,3)%stim_length
        g_strctParadigm.achrombar_local(iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow,  squeeze(barstims(:,:,iTextures,:)));
    end
    fprintf('finished preparing bar set \n')

end

return;
