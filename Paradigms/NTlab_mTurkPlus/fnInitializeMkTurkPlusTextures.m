function fnInitializeMkTurkPlusTextures(BlockType, imgpath, numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUToffset, blockSize, varargin)

switch lower(BlockType)
case {'all','color','shape'}
%if strcmp(lower(textureType),'disc')
    if nargin == 8
        fnGenerateMkTurkTextures(imgpath, numTextures, numDiscs, textureSize, numEntriesPerTexture,  CLUToffset, blockSize);
    else
        fnGenerateMkTurkTextures(imgpath, numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUToffset, blockSize, varargin{1});
    end
end
return;

function fnGenerateMkTurkTextures(imgpath, numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin)
global g_strctPTB
% calculate inside coordinates of disc
% for external testing only


    backgroundRGB = [152, 132, 151];
    %must calibrate these
    cRED = [246, 142, 209, 121, 142, 81, 83, 48, 162, 93, 236, 136, 191, 110];
    cGREEN = [134, 77, 165, 96, 187, 108, 190, 109, 163, 94, 125, 73, 165, 94];
    cBLUE = [175, 97, 95, 52, 129, 71, 218, 120, 255, 153, 255, 142, 198, 109];
    
if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw
    
    ImageDirCh = fullfile(imgpath,'chromatic');
    ImageDiraCh = fullfile(imgpath,'achromatic');
    ImageDirCircle = fullfile(imgpath);
    numShapes = 14;
    
    for i = 1:numShapes
        shapeFiles{i} = [num2str(i) '.png'];
    end

    for i = 1:numShapes
        [imgCh{i},~, alpha] = imread(fullfile(ImageDirCh, shapeFiles{i}));
        imgCh{i}(:,:,4) = alpha;
        [imgaCh{i},~, alpha] = imread(fullfile(ImageDiraCh, shapeFiles{i}));
        imgaCh{i}(:,:,4) = alpha;
    end 

    [circle,~,alpha] = imread(fullfile(ImageDirCircle,'colorCircle.png'));
    circle(:,:,4) = alpha;
    
    [imgX,imgY,~] = size(imgCh{1});
    g_strctDraw.imageRect = [0 0 imgX imgY];
    
    shapes = 1:numShapes; %zeros(numShapes,1);
    
    g_strctDraw.imgChTexPtr = zeros(numShapes,1);
    g_strctDraw.imgAChTexPtr = zeros(numShapes,1);
    g_strctDraw.rectColor = zeros(numShapes,3);
    for i = 1:numShapes
        g_strctDraw.imgChTexPtr(i) = Screen('MakeTexture',g_strctPTB.m_hWindow, imgCh{i});
        g_strctDraw.imgAChTexPtr(i) = Screen('MakeTexture',g_strctPTB.m_hWindow, imgaCh{i});
        g_strctDraw.rectColor(i,:) = [cRED(i) cGREEN(i) cBLUE(i)];
    end
    g_strctDraw.imgcircle = Screen('MakeTexture',g_strctPTB.m_hWindow, circle);
    
    g_strctDraw.Blank0 = Screen('MakeTexture',g_strctPTB.m_hWindow, zeros(25));
    g_strctDraw.Blank1 = Screen('MakeTexture',g_strctPTB.m_hWindow, ones(25)*255);
else
    global g_strctParadigm
    
    ImageDirCh = fullfile(imgpath,'chromatic');
    ImageDiraCh = fullfile(imgpath,'achromatic');
    ImageDirCircle = fullfile(imgpath);
    numShapes = 14;
    
    for i = 1:numShapes
        shapeFiles{i} = [num2str(i) '.png'];
    end

    for i = 1:numShapes
        [imgCh{i},~, alpha] = imread(fullfile(ImageDirCh, shapeFiles{i}));
        imgCh{i}(:,:,4) = alpha;
        [imgaCh{i},~, alpha] = imread(fullfile(ImageDiraCh, shapeFiles{i}));
        imgaCh{i}(:,:,4) = alpha;
    end 

    [circle,~,alpha] = imread(fullfile(ImageDirCircle,'colorCircle.png'));
    circle(:,:,4) = alpha;
    
    g_strctParadigm.MkTurkTextBG=imgCh{1}(1,1,1:3);
    
    [imgX,imgY,~] = size(imgCh{1});
    g_strctParadigm.imageRect = [0 0 imgX imgY];
    
    shapes = 1:numShapes; %zeros(numShapes,1);

    g_strctParadigm.imgChTexPtr = zeros(numShapes,1);
    g_strctParadigm.imgAChTexPtr = zeros(numShapes,1);
    g_strctParadigm.rectColor = zeros(numShapes,3);
    for i = 1:numShapes
        g_strctParadigm.imgChTexPtr(i) = Screen('MakeTexture',g_strctPTB.m_hWindow, imgCh{i});
        g_strctParadigm.imgAChTexPtr(i) = Screen('MakeTexture',g_strctPTB.m_hWindow, imgaCh{i});
        g_strctParadigm.rectColor(i,:) = [cRED(i) cGREEN(i) cBLUE(i)];
    end
    g_strctParadigm.imgcircle = Screen('MakeTexture',g_strctPTB.m_hWindow, circle);
    
    g_strctParadigm.Blank0 = Screen('MakeTexture',g_strctPTB.m_hWindow, zeros(25));
    g_strctParadigm.Blank1 = Screen('MakeTexture',g_strctPTB.m_hWindow, ones(25)*255);
    
end
%{
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
        
        if isfield(g_strctDraw,'m_ahChoiceDiscTextures') && ~isempty(g_strctDraw.m_ahChoiceDiscTextures)
            for iTextures = 1:numel(g_strctDraw.m_ahChoiceDiscTextures)
                Screen('Close', g_strctDraw.m_ahChoiceDiscTextures(iTextures));
            end
            g_strctDraw.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
        end
        
        % dbstop if warning
        %warning('stop')
        LastUsedClutEntry = CLUTOffset;
        for iDiscs = 1:numDiscs
            thisDiscCLUTEntries = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            for iTextures = 1:numTextures
                textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
                g_strctDraw.m_ahChoiceDiscTextures(iDiscs, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
            end
            LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        end
        % special case, generate 1 extra disc for the null condition (gray trial)
        
        thisDiscCLUTEntries = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
        for iTextures = 1:numTextures
            textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
            g_strctDraw.m_ahChoiceDiscTextures(iDiscs+1, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
        end
        LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        
    else
        global g_strctParadigm
        choiceColors = varargin{1};
        % initialize the control side texture as the local background color
        textureTemplate = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[textureLength,1]);
        if isfield(g_strctParadigm.m_strctChoiceVars,'m_ahChoiceDiscTextures') && ~isempty(g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures)
            for iTextures = 1:numel(g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures)
                Screen('Close', g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(iTextures));
            end
            g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
        end
        % add one to the CLUT to get the RGB entry of the CLUT
        % RGB is zero indexed and CLUT is not
        LastUsedClutEntry = CLUTOffset+ 1;
        for iDiscs = 1:numDiscs
            g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs,:) = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            for iTextures = 1:numTextures
                
                % draw from this discs colors and randomly permutate it into
                % the discs
                textureTemplate(linearIndices, :) = choiceColors(iDiscs,seed(randperm(numel(linearIndices))),:);
                g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(iDiscs, iTextures) =  ...
                    Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
            end
            LastUsedClutEntry = max(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs,:))+1;
        end
        % special case, generate 1 extra disc for the null condition (gray trial)
        g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs,:) = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
        for iTextures = 1:numTextures
            
            % draw from this discs colors and randomly permutate it into
            % the discs
            textureTemplate(linearIndices, :) = choiceColors(iDiscs,seed(randperm(numel(linearIndices))),:);
            g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(iDiscs+1, iTextures) =  ...
                Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(textureTemplate,[(discRadius*2),(discRadius*2),3]));
        end

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
        if isfield(g_strctDraw,'m_ahChoiceDiscTextures') && ~isempty(g_strctDraw.m_ahChoiceDiscTextures)
            for iTextures = 1:numel(g_strctDraw.m_ahChoiceDiscTextures)
                Screen('Close', g_strctDraw.m_ahChoiceDiscTextures(iTextures));
            end
            g_strctDraw.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
        end
        % init the stimulus side textures as ones
        % one is the RGB index of the background
        % textureTemplate = ones(textureLength,3);
        [textureTemplate] = fnGenerateNoisePattern(textureSize, blockSize, numTextures, numEntriesPerTexture);
        
        % dbstop if warning
        %warning('stop')
        LastUsedClutEntry = CLUTOffset;
        for iDiscs = 1:numDiscs
            thisDiscCLUTEntries = LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            
            for iTextures = 1:numTextures
                % add the CLUT offset to the template for this disc
                thisDiscTemplate = textureTemplate(:,:,iTextures);
                thisDiscTemplate = reshape(thisDiscTemplate, [discRadius*2 * discRadius*2,1]) + LastUsedClutEntry;
                %textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
                % mask all areas outside the target radius
                thisDiscTemplate(linearOutIndices) = 1;
                thisDiscTemplate = repmat(thisDiscTemplate, [1,3]);
                g_strctDraw.m_ahChoiceDiscTextures(iDiscs, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisDiscTemplate,[(discRadius*2),(discRadius*2),3]));
            end
            LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
        end
        % generate one extra for the gray condition
        for iTextures = 1:numTextures
            % add the CLUT offset to the template for this disc
            thisDiscTemplate = textureTemplate(:,:,iTextures);
            thisDiscTemplate = reshape(thisDiscTemplate, [discRadius*2 * discRadius*2,1]) + LastUsedClutEntry;
            %textureTemplate(linearIndices, :) = repmat(thisDiscCLUTEntries(seed(randperm(numel(linearIndices))))',[1,3]);
            % mask all areas outside the target radius
            thisDiscTemplate(linearOutIndices) = 1;
            thisDiscTemplate = repmat(thisDiscTemplate, [1,3]);
            g_strctDraw.m_ahChoiceDiscTextures(iDiscs+1, iTextures) =  Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisDiscTemplate,[(discRadius*2),(discRadius*2),3]));
        end
        LastUsedClutEntry = max(thisDiscCLUTEntries)+1;
    else
        global g_strctParadigm
        choiceColors = varargin{1};
        
        % close previous textures
        if isfield(g_strctParadigm.m_strctChoiceVars,'m_ahChoiceDiscTextures') && ~isempty(g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures)
            for iTextures = 1:numel(g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures)
                Screen('Close', g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(iTextures));
            end
            g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures = zeros(numDiscs ,numTextures);
        end
        
        % the internal indices are needed on the control computer regardless of
        % block size, so compute those now.
        in = find(dist<=discRadius);
        linearOutIndices = sub2ind([discRadius*2, discRadius*2], coordGridX(out), coordGridY(out));
        linearIndices = sub2ind([discRadius*2, discRadius*2],coordGridX(in),coordGridY(in));
        seed = repmat([1:numEntriesPerTexture],[1,ceil((textureSize(1)*textureSize(2))/numEntriesPerTexture)]);
        seed = seed(1:textureLength);
        % these will not be the same as the patterns on the stimulus
        % computer
        [textureTemplate] = fnGenerateNoisePattern(textureSize, blockSize, numTextures, numEntriesPerTexture);
        % numTextures, numDiscs, textureSize, numEntriesPerTexture, CLUTOffset, blockSize, varargin
        %textureTemplate = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[textureLength,1]);

        % add one to the CLUT to get the RGB entry of the CLUT
        % RGB is zero indexed and CLUT is not
        LastUsedClutEntry = CLUTOffset+ 1;
        for iDiscs = 1:numDiscs
            g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs,:) = ...
                LastUsedClutEntry:(LastUsedClutEntry + numEntriesPerTexture)-1;
            for iTextures = 1:numTextures
                thisTemplate = reshape(squeeze(textureTemplate(:,:,iTextures)), [discRadius*2 * discRadius*2,1]);
                thisTemplate = cat(2,thisTemplate,thisTemplate,thisTemplate);
                % draw from this discs colors and randomly permutate it into
                % the discs
                thisTemplate(linearOutIndices, :) = repmat(g_strctParadigm.m_aiLocalBackgroundColor,[numel(linearOutIndices),1]);
                thisTemplate(linearIndices, :) = choiceColors(seed(randperm(numel(linearIndices)))+((iDiscs-1)*numEntriesPerTexture),:);
                g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(iDiscs, iTextures) =  ...
                    Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisTemplate, [(discRadius*2),(discRadius*2),3]));
                
            end
            LastUsedClutEntry = max(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs,:))+1;
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
            g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(iDiscs+1, iTextures) =  ...
                Screen('MakeTexture', g_strctPTB.m_hWindow, reshape(thisTemplate, [(discRadius*2),(discRadius*2),3]));
            
        end
        %LastUsedClutEntry = max(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs(iDiscs+1,:))+1;
        %}
    end
end
%}
return;
