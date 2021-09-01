function fnInitializeCueTextures(textureType, numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUToffset, blockSize, varargin)


if strcmpi(textureType,'disc')
    if nargin == 7
        fnGenerateDiscTextures(numTextures, numDiscs, textureSize, numEntriesPerTexture,  CLUToffset, blockSize);
    else
        fnGenerateDiscTextures(numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUToffset, blockSize, varargin{1});
    end
end

return;



function fnGenerateDiscTextures(numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB


% calculate inside coordinates of disc
% for external testing only
%{
g_strctPTB.m_bRunningOnStimulusServer = true;
[g_strctPTB.m_hWindow, winRect] = Screen(2,'OpenWindow',zeros(1,3)*127,[0,0,1024,768]);
numTextures = 200;
numDiscs = 16;
textureSize = [60,60];
numEntriesPerTexture = 9;
CLUTOffset = 2;
%}

%texture size is equal in both dimensions. Take half of first dimensions as radius
discRadius = textureSize(1)/2;
textureLength = textureSize(1)*textureSize(2);

[coordGridX, coordGridY] = meshgrid([1:textureSize(1)] ,...
    [1:textureSize(2)]);
dist = sqrt((coordGridX - discRadius).^2   +   (coordGridY - discRadius).^2); % distance calc.




if blockSize == 1
    % modify each pixel inside the generation area
    in = find(dist<discRadius);
    linearIndices = sub2ind([discRadius*2, discRadius*2],coordGridX(in),coordGridY(in));
    seed = repmat([1:numEntriesPerTexture],[1,ceil((textureSize(1)*textureSize(2))/numEntriesPerTexture)]);
    seed = seed(1:textureLength);
    if g_strctPTB.m_bRunningOnStimulusServer
        global g_strctDraw
        % init the stimulus side textures as ones
        % one is the RGB index of the background
        textureTemplate = ones(textureLength,3);
        
        if isfield(g_strctDraw,'m_ahCueDiscTextures') && ~isempty(g_strctDraw.m_ahCueDiscTextures)
            for iTextures = 1:numel(g_strctDraw.m_ahCueDiscTextures)
                Screen('Close', g_strctDraw.m_ahCueDiscTextures(iTextures));
            end
            g_strctDraw.m_ahCueDiscTextures = zeros(numDiscs ,numTextures);
        end
        
        % dbstop if warning
        %warning('stop')
        LastUsedClutEntry = CLUTOffset;
        for iDiscs = 1:numDiscs
            thisDiscCLUTEntries = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            for iTextures = 1:numTextures
                textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
                g_strctDraw.m_ahCueDiscTextures(iDiscs, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
            end
            LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        end
        % special case, generate 1 extra disc for the null condition (gray trial)
        %{
        thisDiscCLUTEntries = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
        for iTextures = 1:numTextures
            textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
            g_strctDraw.m_ahCueDiscTextures(iDiscs+1, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
        end
        LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        %}
        
    else
        global g_strctParadigm
        choiceColors = varargin{1};
        % initialize the control side texture as the local background color
        textureTemplate = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[textureLength,1]);
        if isfield(g_strctParadigm.m_strctStimuliVars,'m_ahCueDiscTextures') && ~isempty(g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures)
            for iTextures = 1:numel(g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures)
                Screen('Close', g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(iTextures));
            end
            g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures = zeros(numDiscs ,numTextures);
        end
        % add one to the CLUT to get the RGB entry of the CLUT
        % RGB is zero indexed and CLUT is not
        LastUsedClutEntry = CLUTOffset+ 1;
        for iDiscs = 1:numDiscs
            g_strctParadigm.m_strctStimuliVars.ChoiceLUTs(iDiscs,:) = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            for iTextures = 1:numTextures
                
                % draw from this discs colors and randomly permutate it into
                % the discs
                textureTemplate(linearIndices, :) = choiceColors(iDiscs,seed(randperm(numel(linearIndices))),:);
                g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(iDiscs, iTextures) =  ...
                    Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
            end
            LastUsedClutEntry = max(g_strctParadigm.m_strctStimuliVars.ChoiceLUTs(iDiscs,:))+1;
        end
        %{
        % special case, generate 1 extra disc for the null condition (gray trial)
        g_strctParadigm.m_strctStimuliVars.ChoiceLUTs(iDiscs,:) = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
        for iTextures = 1:numTextures
            
            % draw from this discs colors and randomly permutate it into
            % the discs
            textureTemplate(linearIndices, :) = choiceColors(iDiscs,seed(randperm(numel(linearIndices))),:);
            g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(iDiscs+1, iTextures) =  ...
                Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
        end
        %}
        
        
    end
elseif blockSize > 1
    %dbstop if warning
    %warning('stop')
    % generate a noise pattern and then mask all pixels outside the
    % generation area
    out = find(dist>discRadius);
    linearOutIndices = sub2ind([discRadius*2, discRadius*2], coordGridX(out), coordGridY(out));
    
    if g_strctPTB.m_bRunningOnStimulusServer
        global g_strctDraw
        if isfield(g_strctDraw,'m_ahCueDiscTextures') && ~isempty(g_strctDraw.m_ahCueDiscTextures)
            for iTextures = 1:numel(g_strctDraw.m_ahCueDiscTextures)
                Screen('Close', g_strctDraw.m_ahCueDiscTextures(iTextures));
            end
            g_strctDraw.m_ahCueDiscTextures = zeros(numDiscs ,numTextures);
        end
        % init the stimulus side textures as ones
        % one is the RGB index of the background
        % textureTemplate = ones(textureLength,3);
        [textureTemplate] = fnGenerateNoisePattern(textureSize, blockSize, numTextures, numEntriesPerTexture);

         %dbstop if warning
        %warning('stop')
        LastUsedClutEntry = CLUTOffset;
        for iDiscs = 1:numDiscs
            thisDiscCLUTEntries = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            
            for iTextures = 1:numTextures
                % add the CLUT offset to the template for this disc
                thisDiscTemplate = textureTemplate(:,:,iTextures);
                thisDiscTemplate = reshape(thisDiscTemplate, [discRadius*2 * discRadius*2,1]) + LastUsedClutEntry-1;
                %textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
                % mask all areas outside the target radius
                thisDiscTemplate(linearOutIndices) = 1;
                thisDiscTemplate = repmat(thisDiscTemplate, [1,3]);
                g_strctDraw.m_ahCueDiscTextures(iDiscs, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisDiscTemplate,[(discRadius*2),(discRadius*2),3]));
            end
            LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        end
        %{
        % generate one extra for the gray condition
        for iTextures = 1:numTextures
            % add the CLUT offset to the template for this disc
            thisDiscTemplate = textureTemplate(:,:,iTextures);
            thisDiscTemplate = reshape(thisDiscTemplate, [discRadius*2 * discRadius*2,1]) + LastUsedClutEntry;
            %textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
            % mask all areas outside the target radius
            thisDiscTemplate(linearOutIndices) = 1;
            thisDiscTemplate = repmat(thisDiscTemplate, [1,3]);
            g_strctDraw.m_ahCueDiscTextures(iDiscs+1, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisDiscTemplate,[(discRadius*2),(discRadius*2),3]));
        end
        LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        %}
    else
        global g_strctParadigm
        choiceColors = varargin{1};
        
        % close previous textures
        if isfield(g_strctParadigm.m_strctStimuliVars,'m_ahCueDiscTextures') && ~isempty(g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures)
            for iTextures = 1:numel(g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures)
                Screen('Close', g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(iTextures));
            end
            g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures = zeros(numDiscs ,numTextures);
        end
        
        
        % the internal indices are needed on the control computer regardless of
        % block size, so compute those now.
        in = find(dist<=discRadius);
        linearOutIndices = sub2ind([discRadius*2, discRadius*2], coordGridX(out), coordGridY(out));
        linearIndices = sub2ind([discRadius*2, discRadius*2],coordGridX(in),coordGridY(in));
        seed = repmat([1:numEntriesPerTexture],[1,ceil((textureSize(1)*textureSize(2))/numEntriesPerTexture)]);
        seed = seed(1:textureLength);
        % these will not be the same as the patterns on the stimulus
        % computer. They are for representative purposes only.
        [textureTemplate] = fnGenerateNoisePattern(textureSize, blockSize, numTextures, numEntriesPerTexture);
        % numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin
        %textureTemplate = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[textureLength,1]);
        
        % add one to the CLUT to get the RGB entry of the CLUT
        % RGB is zero indexed and CLUT is not
        LastUsedClutEntry = CLUTOffset+ 1;
        for iDiscs = 1:numDiscs
            g_strctParadigm.m_strctStimuliVars.ChoiceLUTs(iDiscs,:) = ...
                LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            for iTextures = 1:numTextures
                thisTemplate = reshape(squeeze(textureTemplate(:,:,iTextures)), [discRadius*2 * discRadius*2,1]);
                thisTemplate = cat(2,thisTemplate,thisTemplate,thisTemplate);
                % draw from this discs colors and randomly permutate it into
                % the discs
                thisTemplate(linearOutIndices, :) = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[numel(linearOutIndices),1]);
                thisTemplate(linearIndices, :) = choiceColors(seed(randperm(numel(linearIndices)))+((iDiscs-1)*numEntriesPerTexture),:);
                g_strctParadigm.m_strctStimuliVars.m_ahCueDiscTextures(iDiscs, iTextures) =  ...
                    Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisTemplate, [(discRadius*2),(discRadius*2),3]));
                
            end
            LastUsedClutEntry = max(g_strctParadigm.m_strctStimuliVars.ChoiceLUTs(iDiscs,:))+1;
        end
       %{
        % generate one extra for the gray condition
        g_strctParadigm.m_strctChoiceVars.GrayChoiceLUTs = ...
            LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
        for iTextures = 1:numTextures
            thisTemplate = reshape(squeeze(textureTemplate(:,:,iTextures)), [discRadius*2 * discRadius*2,1]);
            thisTemplate = cat(2,thisTemplate,thisTemplate,thisTemplate);
            % draw from this discs colors and randomly permutate it into
            % the discs
            thisTemplate(linearOutIndices, :) = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[numel(linearOutIndices),1]);
            thisTemplate(linearIndices, :) = choiceColors(seed(randperm(numel(linearIndices)))+((iDiscs)*numEntriesPerTexture),:);
            g_strctParadigm.m_strctChoiceVars.m_ahCueDiscTextures(iDiscs+1, iTextures) =  ...
                Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisTemplate, [(discRadius*2),(discRadius*2),3]));
            
        end
        %LastUsedClutEntry = max(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs+1,:))+1;
        %}
    end
    
    
end
return;