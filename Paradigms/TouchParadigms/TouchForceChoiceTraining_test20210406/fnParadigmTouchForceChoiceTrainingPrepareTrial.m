function [strctCurrentTrial,strWhatHappened] =  fnParadigmTouchForceChoiceTrainingPrepareTrial()
global g_strctParadigm g_strctPTB
%[g_strctParadigm.m_strctDesign,g_strctParadigm.m_acImages] = fnLoadForceChoiceNewDesignFile('NewForceChoiceDesign.xml');
g_strctParadigm.m_bParadigmActive = 1;
g_strctParadigm.m_bGuiOverrideParamters = false;

strWhatHappened = [];
if g_strctParadigm.m_bDynamicStimuli || strcmpi(g_strctParadigm.m_strctDesign.m_strctOrder.m_strTrialOrderType,'Dynamic')
    strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial = 1;
    g_strctParadigm.m_bUpdatePolar = 1;
    strctCurrentTrial = fnPrepareDynamicTrial(strctCurrentTrial);
    %fnBackupDynamicTrial(strctCurrentTrial);
    g_strctParadigm.m_strctTrainingVars.m_bFirstTrial = 0;
    return;
else
    strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial = 0;
end

return;

function astrctMicroStim = fnExtractMicroStimParams(strctRoot)
global g_strctParadigm g_strctDAQParams
% Check if user has microstim active
if ~g_strctParadigm.MicroStimActive.Buffer(g_strctParadigm.MicroStimActive.BufferIdx)
    astrctMicroStim = [];
    return;
end

% how many channels are we stimulating?
if isfield(strctRoot,'StimulationPreset')
    % Find the corresponding entry....
    iNumPresets = length(g_strctParadigm.m_strctDesign.m_acMicrostimPresets);
    iPresetIndex = -1;
    for k=1:iNumPresets
        if isfield(g_strctParadigm.m_strctDesign.m_acMicrostimPresets{k},'Name') && ...
                strcmpi(g_strctParadigm.m_strctDesign.m_acMicrostimPresets{k}.Name, strctRoot.StimulationPreset)
            iPresetIndex = k;
            break;
        end
    end
    if iPresetIndex == -1
        fnParadigmToKofikoComm('DisplayMessageNow','ERROR: Missing microstim preset');
        astrctMicroStim = [];
        return;
    end
    strctStimPreset = g_strctParadigm.m_strctDesign.m_acMicrostimPresets{iPresetIndex};

    acChannels = fnSplitString(strctStimPreset.Channels,' ');
    iNumChannels = length(acChannels);
    afAmplitudes = fnTsGetVar('g_strctDAQParams','MicroStimAmplitude');
    acMicroStimSource = fnTsGetVar('g_strctDAQParams','MicroStimSource');
    for iStimIter=1:iNumChannels
        astrctMicroStim(iStimIter).m_iChannel = str2num(acChannels{iStimIter});

        astrctMicroStim(iStimIter).m_fAmplitude = afAmplitudes(astrctMicroStim(iStimIter).m_iChannel);
        astrctMicroStim(iStimIter).m_strSource = acMicroStimSource{astrctMicroStim(iStimIter).m_iChannel};

        astrctMicroStim(iStimIter).m_fDelayToTrigMS =  fnParseVariable(strctStimPreset,'Delay', 0,iStimIter);
        astrctMicroStim(iStimIter).m_fPulseWidthMS =  fnParseVariable(strctStimPreset,'PulseWidth', 0,iStimIter);
        astrctMicroStim(iStimIter).m_bBiPolar =  fnParseVariable(strctStimPreset,'Bipolar', 0,iStimIter);
        astrctMicroStim(iStimIter).m_fSecondPulseWidthMS =  fnParseVariable(strctStimPreset,'SecondPulseWidth', 0,iStimIter);
        astrctMicroStim(iStimIter).m_fBiPolarDelayMS =  fnParseVariable(strctStimPreset,'BipolarDelay', 0,iStimIter);
        astrctMicroStim(iStimIter).m_fPulseRateHz =  fnParseVariable(strctStimPreset,'PulseRate', 0,iStimIter);
        astrctMicroStim(iStimIter).m_fTrainRateHz =  fnParseVariable(strctStimPreset,'TrainRate', 0,iStimIter);
        astrctMicroStim(iStimIter).m_fTrainDurationMS =  fnParseVariable(strctStimPreset,'TrainDuration', 0,iStimIter);
        astrctMicroStim(iStimIter).m_strWhenToStimulate =  fnParseVariable(strctStimPreset,'WhenToStimulate', 'OnChoice',iStimIter);

    end


else
    % No preset, information is in the trial
    acChannels = fnSplitString(strctRoot.StimChannels,' ');
    iNumChannels = length(acChannels);
    for iStimIter=1:iNumChannels
        astrctMicroStim(iStimIter).m_iChannel = str2num(acChannels{iStimIter});
        % Amplitude
        astrctMicroStim(iStimIter).m_fAmplitude =  fnParseVariable(...
            strctRoot,'MicroStimAmplitude', fnTsGetVar('g_strctParadigm','MicroStimAmplitude'),iStimIter);
        % Delay to trigger
        astrctMicroStim(iStimIter).m_fDelayToTrigMS =  fnParseVariable(...
            strctRoot,'MicroStimDelayMS', fnTsGetVar('g_strctParadigm','MicroStimDelayMS'),iStimIter);
        % Delay to trigger
        astrctMicroStim(iStimIter).m_fPulseWidthMS =  fnParseVariable(...
            strctRoot,'MicroStimPulseWidthMS', fnTsGetVar('g_strctParadigm','MicroStimPulseWidthMS'),iStimIter)*1e-6;
        astrctMicroStim(iStimIter).m_bBiPolar =  fnParseVariable(...
            strctRoot,'MicroStimBiPolar', fnTsGetVar('g_strctParadigm','MicroStimBiPolar'),iStimIter);
        astrctMicroStim(iStimIter).m_fSecondPulseWidthMS =  fnParseVariable(...
            strctRoot,'MicroStimSecondPulseWidthMS', fnTsGetVar('g_strctParadigm','MicroStimSecondPulseWidthMS'),iStimIter)*1e-6;
        astrctMicroStim(iStimIter).m_fBiPolarDelayMS =  fnParseVariable(...
            strctRoot,'MicroStimBipolarDelayMS', fnTsGetVar('g_strctParadigm','MicroStimBipolarDelayMS'),iStimIter)*1e-6;
        astrctMicroStim(iStimIter).m_fPulseRateHz =  fnParseVariable(...
            strctRoot,'MicroStimPulseRateHz', fnTsGetVar('g_strctParadigm','MicroStimPulseRateHz'),iStimIter);
        astrctMicroStim(iStimIter).m_fTrainRateHz =  fnParseVariable(...
            strctRoot,'MicroStimTrainRateHz', fnTsGetVar('g_strctParadigm','MicroStimTrainRateHz'),iStimIter);
        astrctMicroStim(iStimIter).m_fTrainDurationMS =  fnParseVariable(...
            strctRoot,'MicroStimTrainDurationMS', fnTsGetVar('g_strctParadigm','MicroStimTrainDurationMS'),iStimIter);
        astrctMicroStim(iStimIter).m_bActive = 0;
        % Plan the spike train; in progress
        switch g_strctParadigm.m_strMicroStimType
            % Store the stimulation times from time zero, and check against them from the start of the stimulation request
            case 'FixedRate'

                astrctMicroStim(iStimIter).m_afSpikeTrain = linspace(astrctMicroStim(iStimIter).m_fDelayToTrigMS,...
                    astrctMicroStim(iStimIter).m_fDelayToTrigMS + astrctMicroStim(iStimIter).m_fTrainDurationMS,...
                    round(astrctMicroStim(iStimIter).m_fTrainDurationMS/(1000/astrctMicroStim(iStimIter).m_fPulseRateHz)));

                % for storing the stimulation times in the trial structure
                astrctMicroStim(iStimIter).m_afStimTimes = zeros(1,round(astrctMicroStim(iStimIter).m_fTrainDurationMS/...
                    (1000/astrctMicroStim(iStimIter).m_fPulseRateHz)));
            case 'Poisson'
                % Get the parameters for generating the spike train
                times = [0:.001:astrctMicroStim(iStimIter).m_fTrainDurationMS]; %Plot for every ms
                astrctMicroStim(iStimIter).m_afSpikeTrain = zeros(numTrains, length(times));
                ClockRandSeed;
                vt = rand(size(times));
                astrctMicroStim(iStimIter).m_afSpikeTrain = (astrctMicroStim(iStimIter).m_fPulseRateHz*.001) > vt;
            case 'Pearson'
                % In progress
                %{
				mu = 80;
				sigma = 5;
				skew = 2.5;
				kurt = 10;
				samplesM = 4000;
				samplesN = 1;
				astrctMicroStim(iStimIter).m_aSpikeTrain =
                %}
            otherwise
                % assume fixed rate
                astrctMicroStim(iStimIter).m_afSpikeTrain = linspace(0,astrctMicroStim(iStimIter).m_fTrainDurationMS,1/astrctMicroStim(iStimIter).m_fPulseRateHz);
        end
        %astrctMicroStim(iStimIter).m_aSpikeTrain =

        % Not functional as far as I can tell
        %{
		%switch g_strctParadigm.m_strctMicroStim.m_strMicroStimType
         %   case 'FixedRate'
          %      g_strctParadigm.m_strctMicroStim.m_fNextStimTS = g_strctParadigm.m_strctMicroStim.m_fNextStimTS + 1/g_strctParadigm.m_strctMicroStim.m_fMicroStimRateHz;
           % case 'Poisson'
                % I hope I got this right. This should generate a poisson
                % train (actually, an exponential latency between events)






                FiringRate = g_strctParadigm.m_strctMicroStim.m_fMicroStimRateHz;
                NumSeconds = 1;
                N=ceil(FiringRate* NumSeconds);
                a2fUniformDist=rand(1, N);
                a2fExpDist = -log(a2fUniformDist); % exponentially distributed random values.
                fNextEventLatencySec =  a2fExpDist/FiringRate;
                g_strctParadigm.m_strctMicroStim.m_fNextStimTS = g_strctParadigm.m_strctMicroStim.m_fNextStimTS  + fNextEventLatencySec;

        end
        %}
    end
end
return;



% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------



function strctCurrentTrial = fnPrepareDynamicTrial(strctCurrentTrial)
global g_strctStimulusServer g_strctParadigm
g_strctParadigm.m_iDriftCorrectIteration = 1;
g_strctParadigm.m_bParadigmActive = 1;
% Pack any variables without direct relevance to one of the trial epochs into m_strctTrialParams
% we do this so we can concatenate the trial record later, even if the number of variables is not the same

% Trial ID for matching to Plexon file later
strctCurrentTrial.m_strctTrialParams.m_aiTrialVec = round(rand(1,3)*1000);

% Tell Kofiko to not stimulate during the first Epoch. If the previous trial doesn't finish for whatever reason this might
% not get reset after the previous spike train.
g_strctParadigm.m_bMicroStimThisEpoch = 0;

% Override the normal operation and generate random stimulus from the selected saturations and colors
% Some stuff since we're reusing code we might want to use all of later
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_bBlur = 0;
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumberOfBars = 1;
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_inumberBlurSteps = 0;

strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames = round(squeeze(g_strctParadigm.CuePeriodMS.Buffer(1,:,g_strctParadigm.CuePeriodMS.BufferIdx))...
    / g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate);
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iMoveDistance = 0;
strctCurrentTrial.m_strctTrialParams.m_bAutoBalanceActive = 0;

% holds a full copy of all the saturations considered for this trial, the bottom level index will refer to this cell
strctCurrentTrial.m_strctTrialParams.m_acSaturations = 	g_strctParadigm.m_strctCurrentSaturations;

% holds the top level index to the colors
%strctCurrentTrial.m_strctTrialParams.m_aiColors = g_strctParadigm.m_strctCurrentColors;

%strctCurrentTrial.m_strctTrialParams.m_afTrialWeighting = .5*ones(1,numel(strctCurrentTrial.m_strctTrialParams.m_aiColors));

% keep track of all choices that are saccaded to over the course of the trial, even if they are not the final choice
strctCurrentTrial.m_aiAllChoiceSelections = [];

strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen = g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenSize; % fnParadigmToKofikoComm('GetStimulusServerScreenSize');
strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter = g_strctParadigm.m_strctStimServerVars.m_aiStimulusServerScreenCenter;
strctCurrentTrial.m_strctTrialParams.m_acSaturationsLookup = g_strctParadigm.m_cCurrentSaturationsLookup; % saturation names
strctCurrentTrial.m_strctTrialParams.m_aiSelectedSaturationsLookup =  g_strctParadigm.m_aiSelectedSaturationsLookup; % indices from the paradigm level struct holding the current saturations.
% mostly so fnCallbacks doesnt crash if we change the number of saturations mid trial
%{
if ~g_strctParadigm.m_strctTrainingVars.m_bFirstTrial && g_strctParadigm.m_strctTrainingVars.m_bTrainingMode
    if strctCurrentTrial.m_strctTrialParams.m_iColorIndex == g_strctParadigm.m_strctPrevTrial.m_strctTrialParams.m_iColorIndex
        g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(1) = g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(1) + 1;
    else
        g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(1) = 0;
    end
    if strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex == g_strctParadigm.m_strctPrevTrial.m_strctTrialParams.m_iSaturationIndex
        g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(2) = g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(2) + 1;
    else
        g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(2) = 0;
    end
    if numel(strctCurrentTrial.m_strctTrialParams.m_aiColors) > 1 && g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(1) > g_strctParadigm.m_strctTrainingVars.m_iMaxConsecutiveTrials
        g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(1) = 0;
        strctCurrentTrial.m_strctTrialParams.m_iColorIndex = ...
            datasample(strctCurrentTrial.m_strctTrialParams.m_aiColors(strctCurrentTrial.m_strctTrialParams.m_aiColors ~= g_strctParadigm.m_strctPrevTrial.m_strctTrialParams.m_iColorIndex),1);


    end
    if numel(strctCurrentTrial.m_strctTrialParams.m_acSaturations) > 1 && g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(2) >...
            g_strctParadigm.m_strctTrainingVars.m_iMaxConsecutiveTrials
        g_strctParadigm.m_strctTrainingVars.m_aiConsecutiveTrialCounter(2) = 0;

        posSats = 1:numel(strctCurrentTrial.m_strctTrialParams.m_acSaturations);
        strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex = datasample(posSats(posSats ~= g_strctParadigm.m_strctPrevTrial.m_strctTrialParams.m_iSaturationIndex),1);

    end
end
%}
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates = fnTsGetVar('g_strctParadigm','StimulusPosition');
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iCueRhoDeviation = fnTsGetVar('g_strctParadigm','CueRhoDeviation');

if strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iCueRhoDeviation > 0
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCueXYDeviation = ...
        round((rand(1,2) * (2*strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iCueRhoDeviation)) -...
        strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iCueRhoDeviation);
else
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCueXYDeviation = [0,0];
end
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates = ...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates + ...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCueXYDeviation;
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta = squeeze(g_strctParadigm.CueOrientation.Buffer(:,1,g_strctParadigm.CueOrientation.BufferIdx));

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(2)] = fnTsGetVar('g_strctParadigm','CueLength','CueWidth');


% Clut Stuff
% Stimulus Colors

strctCurrentTrial.m_strctTrialParams.m_aiClut = g_strctParadigm.m_afMasterClut;
strctCurrentTrial.m_strctTrialParams.m_afRGBToXYZConversionMatrix = g_strctParadigm.m_strctConversionMatrices.RGBToXYZ;
strctCurrentTrial.m_strctTrialParams.m_afXYZToRGBConversionMatrix = g_strctParadigm.m_strctConversionMatrices.XYZToRGB;
%{
if size(strctCurrentTrial.m_strctTrialParams.m_acSaturations{1,strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex},1) == 1
    strctCurrentTrial.m_strctTrialParams.m_bGrayTrial = 1;
    strctCurrentTrial.m_strctTrialParams.m_aiClut(3,:) =...
        strctCurrentTrial.m_strctTrialParams.m_acSaturations{strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex}(1,:);% Gray saturation, only 1 color

else
    strctCurrentTrial.m_strctTrialParams.m_aiClut(3,:) = strctCurrentTrial.m_strctTrialParams.m_acSaturations...
        {strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex}(strctCurrentTrial.m_strctTrialParams.m_iColorIndex,:);% stimulus server color
    strctCurrentTrial.m_strctTrialParams.m_bGrayTrial = 0;
end

% Saturation name for this trial, to save some effort in analysis
strctCurrentTrial.m_strctTrialParams.m_strThisTrialsSaturationName = strctCurrentTrial.m_strctTrialParams.m_acSaturationsLookup{strctCurrentTrial.m_strctTrialParams.m_iSaturationIndex};
%}
%strctCurrentTrial.m_strctTrialParams.m_aiLocalStimulusColors = round(strctCurrentTrial.m_strctTrialParams.m_aiClut(3,:)/255);% Local colors
strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition = strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3:4)/2;

%strctCurrentTrial.m_strctPreCuePeriod.m_afLocalBackgroundColor = round(g_strctParadigm.m_strctMasterColorTable.neutralGray.RGB/255); % Setup for local machine
strctCurrentTrial.m_strctTrialParams.m_afLocalBackgroundColor = round(g_strctParadigm.m_aiBackgroundColor/255); % Setup for local machine

if strcmp(g_strctParadigm.m_strCueType, 'bar')
    strctCurrentTrial.m_strctTrialParams.m_strStimulusType = 'bar';
    [strctCurrentTrial] = fnCalcBarCoordinates(strctCurrentTrial);
elseif strcmp(g_strctParadigm.m_strCueType, 'disc')
    strctCurrentTrial.m_strctTrialParams.m_strStimulusType = 'disc';
    [strctCurrentTrial] = fnCalcDiscCoordinates(strctCurrentTrial);

end


[strctCurrentTrial] = fnDynamicTrialPreCueSetup(strctCurrentTrial);

[strctCurrentTrial] = fnDynamicTrialMemoryPeriodSetup(strctCurrentTrial);

[strctCurrentTrial] = fnDynamicTrialCuePeriodSetup(strctCurrentTrial);

[strctCurrentTrial] = fnDynamicTrialChoicesSetup(strctCurrentTrial);

[strctCurrentTrial] = fnDynamicPostTrialSetup(strctCurrentTrial);

% Is this a stim trial? This setting is off by default and must be set by the user.
if g_strctParadigm.MicroStimActive.Buffer(g_strctParadigm.MicroStimActive.BufferIdx) && rand() <= g_strctParadigm.m_strctMicroStim.m_fMicroStimChance
    g_strctParadigm.m_bMicroStimThisTrial  = 1;
    switch lower(g_strctParadigm.m_strctMicroStim.m_cEpochs{1})
        case 'precue'
            strctCurrentTrial.m_strctPreCuePeriod.m_astrctMicroStim = fnExtractMicroStimParams(g_strctParadigm.m_strctMicroStim);
        case 'cue'
            strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim = fnExtractMicroStimParams(g_strctParadigm.m_strctMicroStim);
        case 'memory'
            strctCurrentTrial.m_strctMemoryPeriod.m_astrctMicroStim = fnExtractMicroStimParams(g_strctParadigm.m_strctMicroStim);
        case 'choice'
            strctCurrentTrial.m_strctChoicePeriod.m_astrctMicroStim = fnExtractMicroStimParams(g_strctParadigm.m_strctMicroStim);
    end
else
    g_strctParadigm.m_bMicroStimThisTrial = 0;
end

strctCurrentTrial.m_strctTrialParams.m_iTrialType = strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID;
return;
% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------

function [strctCurrentTrial] = fnDynamicTrialPreCueSetup(strctCurrentTrial)
global g_strctParadigm

strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueFixationPeriodMS = squeeze(g_strctParadigm.PreCueFixationPeriodMS.Buffer(1,:,g_strctParadigm.PreCueFixationPeriodMS.BufferIdx));
if strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueFixationPeriodMS > 0
    % Background Colors
    strctCurrentTrial.m_strctPreCuePeriod.m_afBackgroundColor= [1, 1, 1]; % Setup for bits ++

    strctCurrentTrial.m_strctPreCuePeriod.m_aiStimulusColors = [2, 2, 2]; % Setup for bits ++
    strctCurrentTrial.m_strctPreCuePeriod.m_aiLocalStimulusColors = round(strctCurrentTrial.m_strctTrialParams.m_aiClut(3,:)/255); % Setup for bits ++

    strctCurrentTrial.m_strctPreCuePeriod.m_afFixationColor = [255, 255, 255]; % Setup for bits ++
    strctCurrentTrial.m_strctPreCuePeriod.m_afLocalFixationColor = [255, 255, 255]; %round(strctCurrentTrial.m_strctPreCuePeriod.m_aiClut(3,:)/255);
    % Default position is center of screen

    strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition = strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition;
    strctCurrentTrial.m_strctPreCuePeriod.m_fPostTouchDelayMS = 0;
    %{
	tic
	[strctCurrentTrial.m_strctPreCuePeriod.m_fFixationSpotSize,...
	strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix,...
	strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueJuiceTimeMS] = fnTsGetVar('g_strctParadigm','PreCueFixationSpotPix','FixationRadiusPix','PreCueJuiceTimeMS');
	toc
    %}

    strctCurrentTrial.m_strctPreCuePeriod.m_fFixationSpotSize = squeeze(g_strctParadigm.PreCueFixationSpotPix.Buffer(1,:,g_strctParadigm.PreCueFixationSpotPix.BufferIdx)); % Size of the fixation spot
    strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix = squeeze(g_strctParadigm.FixationRadiusPix.Buffer(1,:,g_strctParadigm.FixationRadiusPix.BufferIdx)); % Area of the fixation region
    strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueJuiceTimeMS = squeeze(g_strctParadigm.PreCueJuiceTimeMS.Buffer(1,:,g_strctParadigm.PreCueJuiceTimeMS.BufferIdx));

    % strctCurrentTrial.m_strctPreCuePeriod.m_strFixationSpotType = 'disc';
    strctCurrentTrial.m_strctPreCuePeriod.m_strFixationSpotType = 'x.';
    strctCurrentTrial.m_strctPreCuePeriod.m_bAbortTrialUponTouchOutsideFixation = false;
    %strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix = squeeze(g_strctParadigm.PreCueFixationRegion.Buffer(1,:,g_strctParadigm.PreCueFixationRegion.BufferIdx)); % Area of the fixation region
    strctCurrentTrial.m_strctPreCuePeriod.m_bRewardTouchFixation = g_strctParadigm.m_bPreCueReward;



    strctCurrentTrial.m_strctPreCuePeriod.m_strRewardSound = [];



else
    strctCurrentTrial.m_strctPreCuePeriod = []; % no pre cue fixation period
end


return;
% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------
function [strctCurrentTrial] = fnDynamicTrialCuePeriodSetup(strctCurrentTrial)
global g_strctParadigm
if ~g_strctParadigm.m_bChoiceTexturesInitialized
    fnPauseParadigm();
    fnParadigmToKofikoComm('DisplayMessageNow','Cue Textures Not Initialized! Create Textures Before Running Task');

end


strctCurrentTrial.m_strctTrialParams.FixationSpotSize = squeeze(g_strctParadigm.CueFixationSpotPix.Buffer(1,:,g_strctParadigm.CueFixationSpotPix.BufferIdx));
strctCurrentTrial.m_strctCuePeriod.m_strctStimulusVariables.m_iTheta = squeeze(g_strctParadigm.CueOrientation.Buffer(:,1,g_strctParadigm.CueOrientation.BufferIdx));
if g_strctParadigm.m_bDebugModeEnabled
    dbstop if warning
    ShowCursor();
    warning('stop')
end
% Vars that Kofiko will process later and crash if they don't exist
strctCurrentTrial.m_strctCuePeriod.m_strName = 'Dynamic';
strctCurrentTrial.m_strctCuePeriod.m_strFileName = 'null';
strctCurrentTrial.m_strctCuePeriod.m_iMediaIndex = 1;
strctCurrentTrial.m_strctCuePeriod.m_bMovie = false;
%strctCurrentTrial.m_strctCuePeriod.m_strFixationSpotType = 'disc';
strctCurrentTrial.m_strctCuePeriod.m_strFixationSpotType = 'x.';
strctCurrentTrial.m_strctCuePeriod.m_fFixationSpotSize = squeeze(g_strctParadigm.CueFixationSpotPix.Buffer(1,:,g_strctParadigm.CueFixationSpotPix.BufferIdx));
%%
% Are null trials possible (no cue displayed)
%{
% superceded by gray as its own saturation
strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials = fnTsGetVar('g_strctParadigm','IncludeGrayTrials');
%}


% Choose what color this trial will be
strctCurrentTrial.m_strctCuePeriod.m_acCurrentlyActiveColorStructures = g_strctParadigm.m_strctCurrentSaturations;

iCurrentColorConversionID = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'value');
strCurrentColorConversionName = get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'string');
strctCurrentTrial.m_strctCuePeriod.m_strSelectedConversionType = strCurrentColorConversionName{iCurrentColorConversionID,:};
currentlySelectedSaturationvalue = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'value');
currentlySelectedSaturationStrings = get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'string');

currentlySelectedColors = get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'value');

thisColorConversionStructs = g_strctParadigm.m_strctMasterColorTable{get(g_strctParadigm.m_strctControllers.m_hCueColorConversionType,'value')};
for iActiveSaturations = 1:numel(currentlySelectedSaturationvalue)
    strctCurrentTrial.m_cCurrentlySelectedSaturations.(deblank(currentlySelectedSaturationStrings(currentlySelectedSaturationvalue(iActiveSaturations),:))) = ...
        thisColorConversionStructs.(deblank(currentlySelectedSaturationStrings(currentlySelectedSaturationvalue(iActiveSaturations),:)));

end

numSelectedSaturations = numel(currentlySelectedSaturationvalue);
numSelectedColors = numel(currentlySelectedColors);
strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID = ...
    find(ismember( fieldnames(strctCurrentTrial.m_cCurrentlySelectedSaturations),g_strctParadigm.m_strctChoiceVars.m_strNullConditionName));

if g_strctParadigm.m_strctStimuliVars.m_bOverrideGrayProbability && any(strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID)
    strctCurrentTrial.m_strctCuePeriod.m_bGrayTrialProbability = fnTsGetVar('g_strctParadigm','GrayTrialProbability')/100;
    if strctCurrentTrial.m_strctCuePeriod.m_bGrayTrialProbability > 0
        strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials = true;
    end
else
    % is the null condition in the list of selected saturations
    if any(strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID)
        strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials = true;
    else
        strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials =  false;
    end
end
strctCurrentTrial.m_strctCuePeriod.m_bLuminanceMaskedCueStimuli = g_strctParadigm.m_strctStimuliVars.m_bLuminanceMaskedCueStimuli;

if strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials && rand(1) < strctCurrentTrial.m_strctCuePeriod.m_bGrayTrialProbability
    strctCurrentTrial.m_strctTrialParams.m_bGrayTrial = true;
else
    strctCurrentTrial.m_strctTrialParams.m_bGrayTrial = false;
end

strctCurrentTrial.m_strctCuePeriod.m_bDisplayCue = g_strctParadigm.m_strctStimuliVars.m_bDisplayCue;
strctCurrentTrial.m_strctCuePeriod.m_fCuePeriodMS = squeeze(g_strctParadigm.CuePeriodMS.Buffer(1,:,g_strctParadigm.CuePeriodMS.BufferIdx));

strctCurrentTrial.m_strctCuePeriod.m_pt2fFixationPosition = [strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter(1), strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter(2)]; %[1024/2,768/2];

strctCurrentTrial.m_strctCuePeriod.m_fFixationRegionPix = squeeze(g_strctParadigm.FixationRadiusPix.Buffer(1,:,g_strctParadigm.FixationRadiusPix.BufferIdx));
strctCurrentTrial.m_strctCuePeriod.m_bCueHighlight = g_strctParadigm.m_strctStimuliVars.m_bCueHighlight;

strctCurrentTrial.m_strctCuePeriod.m_aiClut = g_strctParadigm.m_afMasterClut;

if ~strctCurrentTrial.m_strctTrialParams.m_bGrayTrial
    % generate a random number based on the least displayed colors and use
    % it to pick this trial's cue
    % determine which conditions are not the null condition for use in
    % balancing
    eligibleConditions = 1:size(g_strctParadigm.m_aiColorsDisplayedCount,1);
    if any(strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID)
        eligibleConditions = eligibleConditions(eligibleConditions ~= strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID);
        % else

    end
    if g_strctParadigm.m_bForceBalanceCueProbabilities
        [leastDisplayedSaturationPossibilities, leastDisplayedColorPossibilities] = ...
            find(g_strctParadigm.m_aiColorsDisplayedCount(eligibleConditions,:) <= ...
            min(min(g_strctParadigm.m_aiColorsDisplayedCount(eligibleConditions,:))));
        thisTrialSaturationRandomNumber = ceil(rand(1,1)*numel(leastDisplayedSaturationPossibilities));
        thisTrialColorRandomNumber = ceil(rand(1,1)*numel(leastDisplayedColorPossibilities));

    else
        %tempCuePossibilityMatrix = zeros(numSelectedSaturations,numSelectedColors);
        tempCuePossibilityMatrix = zeros(numel(eligibleConditions),numSelectedColors);
        [leastDisplayedSaturationPossibilities, leastDisplayedColorPossibilities] = find(tempCuePossibilityMatrix <= min(min(tempCuePossibilityMatrix)));

        %find(g_strctParadigm.m_aiColorsDisplayedCount(eligibleConditions,:) <= min(min(tempCuePossibilityMatrix)));
        thisTrialSaturationRandomNumber = ceil(rand(1,1)*size(tempCuePossibilityMatrix,1));
        thisTrialColorRandomNumber = ceil(rand(1,1)*size(tempCuePossibilityMatrix,2));
    end
    currentlySelectedSaturationvalue = currentlySelectedSaturationvalue(eligibleConditions);
    thisTrialTempColorID = leastDisplayedColorPossibilities(thisTrialColorRandomNumber);
    thisTrialTempSaturationID = leastDisplayedSaturationPossibilities(thisTrialSaturationRandomNumber);
    % thisTrialTempSaturationID = eligibleConditions(leastDisplayedSaturationPossibilities(thisTrialSaturationRandomNumber));

    strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID = thisTrialTempSaturationID;%...
    % currentlySelectedSaturationvalue(eligibleConditions(leastDisplayedSaturationPossibilities(thisTrialSaturationRandomNumber)));
    strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID = currentlySelectedColors(leastDisplayedColorPossibilities(thisTrialColorRandomNumber));
    strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation = ...
        strctCurrentTrial.m_cCurrentlySelectedSaturations.(deblank(currentlySelectedSaturationStrings(currentlySelectedSaturationvalue(thisTrialTempSaturationID),:)));
    % store the absolute ID of the cue
    % I.E., which iteration of generation it was during creation of the texture, for local display
    strctCurrentTrial.m_strctCuePeriod.m_iCueHandleIndexingColorID = ((strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID - 1) * numSelectedColors) + thisTrialTempColorID;
    thisTrialSatNames =  fieldnames(strctCurrentTrial.m_cCurrentlySelectedSaturations);
    strctCurrentTrial.m_strctCuePeriod.m_strCurrentSaturationName = thisTrialSatNames{strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID};

    strctCurrentTrial.m_strctCuePeriod.m_aiRGB = strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.RGB(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID,:);
    strctCurrentTrial.m_strctCuePeriod.m_aiLocalStimulusColors = round((strctCurrentTrial.m_strctCuePeriod.m_aiRGB/65535)*255);
    strctCurrentTrial.m_strctCuePeriod.m_iSaturation = strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.Radius;
    strctCurrentTrial.m_strctCuePeriod.m_afLUV_CartCoordinates = ...
        strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.m_afCartCoordinates(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID,:);
    strctCurrentTrial.m_strctCuePeriod.m_afSphereCoordinates = strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.m_afSphereCoordinates(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID,:);
    strctCurrentTrial.m_strctCuePeriod.m_iAzimuth = strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID);

    % update the trial counter for trial count balancing
    %currentlySelectedSaturationvalue(strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID)
    % trialSatID = currentlySelectedSaturationvalue(strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID);
    %trialColorID = leastDisplayedColorPossibilities(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID);
    g_strctParadigm.m_aiColorsDisplayedCount(thisTrialTempSaturationID,thisTrialTempColorID) = ...
        g_strctParadigm.m_aiColorsDisplayedCount(thisTrialTempSaturationID,thisTrialTempColorID) + 1;

    %{
        g_strctParadigm.m_aiColorsDisplayedCount(strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID,leastDisplayedColorPossibilities(thisTrialRandomNumber)) = ...
        g_strctParadigm.m_aiColorsDisplayedCount(strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID,leastDisplayedColorPossibilities(thisTrialRandomNumber)) + 1;

        %}
else
    strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID = strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID;
    strctCurrentTrial.m_strctCuePeriod.m_aiRGB = g_strctParadigm.m_aiBackgroundColor;
    strctCurrentTrial.m_strctCuePeriod.m_aiLocalStimulusColors = g_strctParadigm.m_aiLocalBackgroundColor;
    strctCurrentTrial.m_strctCuePeriod.m_iSaturation = 0;
    strctCurrentTrial.m_strctCuePeriod.m_iAzimuth = 0;
    strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation = ...
        strctCurrentTrial.m_cCurrentlySelectedSaturations.(g_strctParadigm.m_strctChoiceVars.m_strNullConditionName);
    strctCurrentTrial.m_strctCuePeriod.m_afLUV_CartCoordinates = ...
        strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.m_afCartCoordinates(1,:);
    strctCurrentTrial.m_strctCuePeriod.m_afSphereCoordinates = ...
        strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.m_afSphereCoordinates(1,:);
    % use all of the null condition colors, they're all "correct"
    strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID = currentlySelectedColors;

    % all the null condition cue handles are the same.
    strctCurrentTrial.m_strctCuePeriod.m_iCueHandleIndexingColorID = ...
        ((strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID - 1) * numSelectedColors) + 1;


end

if strctCurrentTrial.m_strctCuePeriod.m_bLuminanceMaskedCueStimuli
    numCues = numel(get(g_strctParadigm.m_strctControllers.m_hCueColorLists,'value')) * ...
        numel(get(g_strctParadigm.m_strctControllers.m_hCueSaturationLists,'value'));
    %numCues = sum(cellfun(@numel,g_strctParadigm.m_cAllCueColorsPerSat));
    %g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps = ...
    %linspace(-luminanceDeviation,luminanceDeviation,numLuminanceStepsPerChoice);
    numLuminanceStepsPerCue = floor(253 / (numCues + 1));
    if rem(numLuminanceStepsPerCue,2) == 0
        numLuminanceStepsPerCue = numLuminanceStepsPerCue - 1;
    end
    strctCurrentTrial.m_strctCuePeriod.m_fCueLuminanceDeviation = fnTsGetVar('g_strctParadigm','CueLuminanceDeviation');
    strctCurrentTrial.m_strctCuePeriod.m_afCueLuminanceSteps = ...
        linspace(-strctCurrentTrial.m_strctCuePeriod.m_fCueLuminanceDeviation,strctCurrentTrial.m_strctCuePeriod.m_fCueLuminanceDeviation,numLuminanceStepsPerCue);
    % strctCurrentTrial.m_iMaxFramesInCueEpoch = round((1e3/g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate) * (squeeze(g_strctParadigm.TrialTimeoutMS.Buffer(1,:,g_strctParadigm.TrialTimeoutMS.BufferIdx)/1e3)));
    %strctCurrentTrial.thisTrialChoiceTextureOrder = floor(rand(1, strctCurrentTrial.m_iMaxFramesInChoiceEpoch ) * fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'))+1;
    strctCurrentTrial.m_strctCuePeriod.m_iCuePeriodFrameCounter = 1;
    strctCurrentTrial.m_strctCuePeriod.m_iMaxFramesInCueEpoch = round((1e3/g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate) * strctCurrentTrial.m_strctCuePeriod.m_fCuePeriodMS/1e3);
    strctCurrentTrial.m_strctCuePeriod.thisTrialCueTextureOrder = floor(rand(1, strctCurrentTrial.m_strctCuePeriod.m_iMaxFramesInCueEpoch ) * fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerCue'))+1;
    %if ~strctCurrentTrial.m_strctTrialParams.m_bGrayTrial
    %for iSaturations = 1:numel(strctCurrentTrial.m_aiActiveChoiceSaturationID)
    %for iColors = strctCurrentTrial.m_aiActiveChoiceColorID
    thisColorCoordinate = strctCurrentTrial.m_strctCuePeriod.m_afLUV_CartCoordinates;
    rawValues = luv2rgb([ones(numel(strctCurrentTrial.m_strctCuePeriod.m_afCueLuminanceSteps),1) .* ...
        ((thisColorCoordinate(1)*100) + strctCurrentTrial.m_strctCuePeriod.m_afCueLuminanceSteps*100)', ...
        ones(numel(strctCurrentTrial.m_strctCuePeriod.m_afCueLuminanceSteps),1) .*thisColorCoordinate(2)'.*100, ...
        ones(numel(strctCurrentTrial.m_strctCuePeriod.m_afCueLuminanceSteps),1) .*thisColorCoordinate(3)'.*100]);
    if any(any(rawValues > 1)) ||  any(any(rawValues < 0))
        rawValues( rawValues > 1) = 1;
        rawValues( rawValues < 0) = 0;
        fnParadigmToKofikoComm('DisplayMessageNow','Cue Color Values Out Of Range');
    end
    %end
    %end
    %{
    else
        % append the gray choice information
        thisColorCoordinate = fnTsGetVar('g_strctParadigm', 'BackgroundLUVCoordinates');
        rawValues = luv2rgb([ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .* ...
            ((thisColorCoordinate(1)) + g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps*100)', ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(2)'.*100, ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(3)'.*100]);
        if any(any(rawValues > 1)) ||  any(any(rawValues < 0))
            rawValues( rawValues > 1) = 1;
            rawValues( rawValues < 0) = 0;
            fnParadigmToKofikoComm('DisplayMessageNow','Cue Color Values Out Of Range');
        end
    end
    %}
    strctCurrentTrial.m_strctCuePeriod.ClutEntries = fnGammaCorrectRGBValues(rawValues);
    strctCurrentTrial.m_strctCuePeriod.CueLUTs = g_strctParadigm.CLUTOffset + 1:g_strctParadigm.CLUTOffset + size(strctCurrentTrial.m_strctCuePeriod.ClutEntries,1);
    strctCurrentTrial.m_strctCuePeriod.m_aiClut(strctCurrentTrial.m_strctCuePeriod.CueLUTs ,:) = strctCurrentTrial.m_strctCuePeriod.ClutEntries;



    %g_strctParadigm.m_aiColorsDisplayedCount

else
    if strctCurrentTrial.m_strctTrialParams.m_bGrayTrial

        strctCurrentTrial.m_strctCuePeriod.m_aiClut(3,:) = g_strctParadigm.m_aiBackgroundColor;

    else
        strctCurrentTrial.m_strctCuePeriod.m_aiClut(3,:) = strctCurrentTrial.m_strctCuePeriod.m_aiRGB;% stimulus server color
    end
end
strctCurrentTrial.m_strctCuePeriod.m_aiCueColors = [2, 2, 2];
strctCurrentTrial.m_strctCuePeriod.m_afCueHighlightColor = [255 0 0];
if g_strctParadigm.m_bUseFixationSpotAsCue
    % Use the fixation point as the cue color, only use for training right now
    % Not used atm but might be nice to have at some point.
    strctCurrentTrial.m_strctTrialParams.m_bUseFixationSpotAsCue = 1;
    strctCurrentTrial.m_strctCuePeriod.m_afFixationColor = [2, 2, 2];
    strctCurrentTrial.m_strctCuePeriod.m_afLocalFixationColor = [255, 255, 255];
    strctCurrentTrial.m_strctTrialParams.m_bDoNotShowCue = 1;

else
    strctCurrentTrial.m_strctTrialParams.m_bUseFixationSpotAsCue = 0;
    % this is the CLUT index of the fixation color, not the actual stimulus server fixation color
    strctCurrentTrial.m_strctCuePeriod.m_afFixationColor = [255 255 255];

    strctCurrentTrial.m_strctCuePeriod.m_afLocalFixationColor = [255, 255, 255];
    strctCurrentTrial.m_strctTrialParams.m_bDoNotShowCue = 0;

end
strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim = [];
strctCurrentTrial.m_strctCuePeriod.m_fCueMemoryPeriodMS = 0;

% Support for determining Cue Size, hopefully this works
strctCurrentTrial.m_strctCuePeriod.m_fCueSizePix =  max(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions);

strctCurrentTrial.m_strctCuePeriod.m_pt2fCuePosition = strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3:4)/2;

strctCurrentTrial.m_strctCuePeriod.m_bAbortTrialIfBreakFixationDuringCue = true;

strctCurrentTrial.m_strctCuePeriod.m_bAbortTrialIfBreakFixationOnCue = false;


return;
% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------


function [strctCurrentTrial] = fnDynamicTrialMemoryPeriodSetup(strctCurrentTrial)
global g_strctParadigm

%strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMS = squeeze(g_strctParadigm.MemoryPeriodMS.Buffer(1,:,g_strctParadigm.MemoryPeriodMS.BufferIdx));
strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMinMS = squeeze(g_strctParadigm.MemoryPeriodMinMS.Buffer(1,:,g_strctParadigm.MemoryPeriodMinMS.BufferIdx));
strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMaxMS = squeeze(g_strctParadigm.MemoryPeriodMaxMS.Buffer(1,:,g_strctParadigm.MemoryPeriodMaxMS.BufferIdx));

% currently if memory period = 0, the entire memory/memory choice period is skipped over. Shortcut way to prevent that is to throw an error if max memory period = 0.
if strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMaxMS ==0
    fnParadigmToKofikoComm('DisplayMessageNow','Please please please do not set max memory period to 0 :)');
    dbstop
end

strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMS = strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMinMS + (strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMaxMS - strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMinMS) * rand(1,1);

% strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMS = squeeze(g_strctParadigm.MemoryChoicePeriodMS.Buffer(1,:,g_strctParadigm.MemoryChoicePeriodMS.BufferIdx));
strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMinMS = squeeze(g_strctParadigm.MemoryChoicePeriodMinMS.Buffer(1,:,g_strctParadigm.MemoryChoicePeriodMinMS.BufferIdx));
strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMaxMS = squeeze(g_strctParadigm.MemoryChoicePeriodMaxMS.Buffer(1,:,g_strctParadigm.MemoryChoicePeriodMaxMS.BufferIdx));
strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMS = strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMinMS + (strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMaxMS - strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMinMS) * rand(1,1);

strctCurrentTrial.m_strctMemoryPeriod.numFrames = ceil( (strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMS + strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryChoicePeriodMS) / g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate)+1;
strctCurrentTrial.m_iMemoryFrameCounter = 1; strctCurrentTrial.m_iMemoryFrameCounterResets = 0;
strctCurrentTrial.m_iLocalMemoryFrameCounter = 1;
g_strctParadigm.bMemory = 0;
g_strctParadigm.bMemoryChoice = 0;


if strctCurrentTrial.m_strctMemoryPeriod.m_fMemoryPeriodMS > 0
    strctCurrentTrial.m_strctMemoryPeriod.m_afBackgroundColor = [1, 1, 1];
    strctCurrentTrial.m_strctMemoryPeriod.m_bShowFixationSpot= 1;
    strctCurrentTrial.m_strctMemoryPeriod.m_pt2fFixationPosition = [strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter(1), strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter(2)]; %[1024/2,768/2];
    strctCurrentTrial.m_strctMemoryPeriod.m_afFixationColor = [255, 255, 255];
    strctCurrentTrial.m_strctMemoryPeriod.m_afLocalFixationColor = [255, 255, 255];
    %strctCurrentTrial.m_strctMemoryPeriod.m_strFixationSpotType = 'disc';
    strctCurrentTrial.m_strctMemoryPeriod.m_strFixationSpotType = 'x.';
    strctCurrentTrial.m_strctMemoryPeriod.m_fFixationSpotSize  = squeeze(g_strctParadigm.MemoryPeriodFixationSpotPix.Buffer(1,:,g_strctParadigm.MemoryPeriodFixationSpotPix.BufferIdx));
    %strctCurrentTrial.m_strctMemoryPeriod.m_fFixationRegionSize = squeeze(g_strctParadigm.MemoryPeriodFixationRegionPix.Buffer(1,:,g_strctParadigm.MemoryPeriodFixationRegionPix.BufferIdx));
    strctCurrentTrial.m_strctMemoryPeriod.m_fFixationRegionSize = squeeze(g_strctParadigm.FixationRadiusPix.Buffer(1,:,g_strctParadigm.FixationRadiusPix.BufferIdx));
    strctCurrentTrial.m_strctMemoryPeriod.m_fJuiceTimeMS = squeeze(g_strctParadigm.MemoryPeriodJuiceTimeMS.Buffer(1,:,g_strctParadigm.MemoryPeriodJuiceTimeMS.BufferIdx));
    strctCurrentTrial.m_strctMemoryPeriod.m_bRewardMemoryPeriod = g_strctParadigm.m_bMemoryPeriodReward;


else
    strctCurrentTrial.m_strctMemoryPeriod = [];
end


return;
% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------

function [strctCurrentTrial] = fnDynamicTrialChoicesSetup(strctCurrentTrial)

global g_strctParadigm g_strctPTB
if ~g_strctParadigm.m_bChoiceTexturesInitialized
    fnPauseParadigm();
    fnParadigmToKofikoComm('DisplayMessageNow','Choice Textures Not Initialized! Create Textures Before Running Task');

end

strctCurrentTrial.m_iChoiceFrameCounter = 1;
strctCurrentTrial.m_bLuminanceNoiseBackground = 0;
% init Color Lookup Table
strctCurrentTrial.m_strctChoicePeriod.Clut(:,1) = round(g_strctParadigm.m_aiBackgroundColor(ceil(end/2),1)) .* ones(256,1)  ;
strctCurrentTrial.m_strctChoicePeriod.Clut(:,2) = round(g_strctParadigm.m_aiBackgroundColor(ceil(end/2),2)) .* ones(256,1)  ;
strctCurrentTrial.m_strctChoicePeriod.Clut(:,3) = round(g_strctParadigm.m_aiBackgroundColor(ceil(end/2),3)) .* ones(256,1)  ;

if g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial
    if g_strctParadigm.m_strctChoiceVars.m_bProgressiveChoiceRingRotation
        strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle = -(g_strctParadigm.m_strctChoiceVars.m_fLastChoiceRingRotation + g_strctParadigm.m_strctChoiceVars.m_iChoiceRingRotationIncrement);
        g_strctParadigm.m_strctChoiceVars.m_fLastChoiceRingRotation = strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle;
    else

        % take the negative of the rotation angle. Psychophysics toolbox handles rotation in the opposite manner of the matlab functions that determine the angle of the choice direction
        strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle = -rad2deg(rand(1) * (2 * pi));
        strctCurrentTrial.m_strctChoicePeriod.m_bRandomChoiceRotationAngle = true;
    end
else
    strctCurrentTrial.m_strctChoicePeriod.m_bRandomChoiceRotationAngle = false;
    strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle = 0;
end
strctCurrentTrial.m_iChoiceRingSize = fnTsGetVar('g_strctParadigm','ChoiceRingSize');
strctCurrentTrial.m_afChoiceRingLocation = fnTsGetVar('g_strctParadigm','AFCChoiceLocation');
strctCurrentTrial.m_strChoiceDisplayType = g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType;


strctCurrentTrial.m_afChoiceRingDestinationRect = [strctCurrentTrial.m_afChoiceRingLocation(1) - strctCurrentTrial.m_iChoiceRingSize(1)/2,...
    strctCurrentTrial.m_afChoiceRingLocation(2) - strctCurrentTrial.m_iChoiceRingSize(1)/2,...
    strctCurrentTrial.m_afChoiceRingLocation(1) + strctCurrentTrial.m_iChoiceRingSize(1)/2,...
    strctCurrentTrial.m_afChoiceRingLocation(2) + strctCurrentTrial.m_iChoiceRingSize(1)/2];
strctCurrentTrial.m_iChoiceWidth = fnTsGetVar('g_strctParadigm','ChoiceWidth');
strctCurrentTrial.m_iChoiceLength = fnTsGetVar('g_strctParadigm','ChoiceLength');


strctCurrentTrial.m_astrctChoicesMedia.m_strChoiceType = g_strctParadigm.m_strctChoiceVars.m_strChoiceType;

% strctCurrentTrial.m_iChoiceRingChoices = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value'));
% strctCurrentTrial.m_iChoiceRingNumChoices = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'value'));
strctCurrentTrial.m_strctChoiceVars.m_NTargets = fnTsGetVar('g_strctParadigm','NTargets');
strctCurrentTrial.m_strctChoiceVars.numSaturations = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value'));
strctCurrentTrial.m_strctChoiceVars.numColors = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'value'));


strctCurrentTrial.m_aiAllChoiceSaturationIDs = get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value');  % get target saturations ("chroma")
m_strAllChoiceSaturations = get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'string');
for iSaturations = 1:numel(strctCurrentTrial.m_aiAllChoiceSaturationIDs)
    strctCurrentTrial.m_strAllChoiceSaturations{iSaturations} = deblank(m_strAllChoiceSaturations(strctCurrentTrial.m_aiAllChoiceSaturationIDs(iSaturations),:));
end

strctCurrentTrial.m_aiAllChoiceColorIDs = get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'value'); % get all target colors ("hue")

strctCurrentTrial.m_strctStimuliVars.m_fProbeTrialProbability = squeeze(g_strctParadigm.ProbeTrialProbability.Buffer(1,:,g_strctParadigm.ProbeTrialProbability.BufferIdx));


if g_strctParadigm.m_strctStimuliVars.m_bDirectMatchCueChoices
    strctCurrentTrial.m_strctStimuliVars.m_bDirectMatchCueChoices = true;
else
    strctCurrentTrial.m_strctStimuliVars.m_bDirectMatchCueChoices = false;
end

if strctCurrentTrial.m_strctStimuliVars.m_bDirectMatchCueChoices || rand() > (strctCurrentTrial.m_strctStimuliVars.m_fProbeTrialProbability/100)
    strctCurrentTrial.m_strctChoicePeriod.m_bIsDirectMatchTrial = true;
    ColorDistractors = strctCurrentTrial.m_aiAllChoiceColorIDs(strctCurrentTrial.m_aiAllChoiceColorIDs~=strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID);
    strctCurrentTrial.m_aiActiveChoiceColorID = [strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID, ...
        ColorDistractors(randperm(strctCurrentTrial.m_strctChoiceVars.numColors-1,strctCurrentTrial.m_strctChoiceVars.m_NTargets-1))]; % subset random hues (including match) for each trial
	
	SaturationDistractors = strctCurrentTrial.m_aiAllChoiceSaturationIDs(strctCurrentTrial.m_aiAllChoiceSaturationIDs~=strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID);
	strctCurrentTrial.m_aiActiveSaturationColorID = [strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID, ...
        SaturationDistractors(randi(strctCurrentTrial.m_strctChoiceVars.numSaturations,[1 strctCurrentTrial.m_strctChoiceVars.m_NTargets-1]))]; % subset random saturations (including match) for each trial
else
    strctCurrentTrial.m_strctChoicePeriod.m_bIsDirectMatchTrial = false;
    ColorDistractors = strctCurrentTrial.m_aiAllChoiceColorIDs(strctCurrentTrial.m_aiAllChoiceColorIDs~=strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID);
    strctCurrentTrial.m_aiActiveChoiceColorID = ColorDistractors(randperm(strctCurrentTrial.m_strctChoiceVars.numColors-1,strctCurrentTrial.m_strctChoiceVars.m_NTargets)); % subset random non-match hues for each trial
	
	SaturationDistractors = strctCurrentTrial.m_aiAllChoiceSaturationIDs(strctCurrentTrial.m_aiAllChoiceSaturationIDs~=strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID);
    strctCurrentTrial.m_aiActiveChoiceSaturationID = SaturationDistractors(randi(strctCurrentTrial.m_strctChoiceVars.numSaturations,[1 strctCurrentTrial.m_strctChoiceVars.m_NTargets])); % subset random non-match hues for each trial	
end

if g_strctParadigm.m_strctChoicePeriod.m_bSortChoiceHues 
	strctCurrentTrial.m_strctChoicePeriod.m_bSortChoiceHues = true;
	[strctCurrentTrial.m_aiActiveChoiceColorID, SatOrder]= sort(strctCurrentTrial.m_aiActiveChoiceColorID);
	strctCurrentTrial.m_aiActiveChoiceSaturationID = strctCurrentTrial.m_aiActiveChoiceSaturationID(SatOrder);
else
	strctCurrentTrial.m_strctChoicePeriod.m_bSortChoiceHues = false;
	[strctCurrentTrial.m_aiActiveChoiceColorID, SatOrder] = strctCurrentTrial.m_aiActiveChoiceColorID(randperm(strctCurrentTrial.m_strctChoiceVars.m_NTargets, strctCurrentTrial.m_strctChoiceVars.m_NTargets)); % stil need to scramble choices, since the distractors are appended to the direct match choice above
	strctCurrentTrial.m_aiActiveChoiceSaturationID = strctCurrentTrial.m_aiActiveChoiceSaturationID(SatOrder);
end 

strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion = fnTsGetVar('g_strctParadigm','InsideChoiceRegion');

if  ~isfield(g_strctParadigm.m_strctChoiceVars,'m_aiChoiceRingRGBCorrected') || isempty(g_strctParadigm.m_strctChoiceVars.m_aiChoiceRingRGBCorrected)
    % init choice ring texture via callbacks
    feval(g_strctParadigm.m_strCallbacks,'GenerateChoices');
end
if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'disc') || ...
        strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'bar') || ...
        strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli') || ...
        strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')

    if g_strctParadigm.m_bDebugModeEnabled
        dbstop if warning
        warning('stop')
    end



    %strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = [0:(2*pi)/strctCurrentTrial.m_strctChoiceVars.numColors:(2*pi) - .00001];
    if strcmp(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'Disc')
        minimumSeparation = strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion * sqrt(2);
    else
        minimumSeparation = max([strctCurrentTrial.m_iChoiceWidth, strctCurrentTrial.m_iChoiceLength]);
    end

    % set the size of the circle based on the size of each disc, the number of choices, and the number of saturations
    % leave one spot for the null choice in the center
    if strcmp(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'Disc')
        %dbstop if warning
        %warning('stop')

        minCircumference = minimumSeparation * strctCurrentTrial.m_strctChoiceVars.m_NTargets * g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier;
        minRadius = round(minCircumference/(2*pi));
        minRho = minimumSeparation * g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier;
        strctCurrentTrial.m_strctChoiceVars.choiceRhos(1) =  minRadius; % + minRadius;
        strctCurrentTrial.m_strctChoiceVars.choiceRhos(2:strctCurrentTrial.m_strctChoiceVars.numSaturations) =...
            ((1:strctCurrentTrial.m_strctChoiceVars.numSaturations-1) .* minRho) + strctCurrentTrial.m_strctChoiceVars.choiceRhos(1);
        % reverse rho direction to match saturation list
        % first in saturation list is highest saturation and it should be
        % on the outside
        strctCurrentTrial.m_strctChoiceVars.choiceRhos = fliplr(strctCurrentTrial.m_strctChoiceVars.choiceRhos);
        strctCurrentTrial.m_aiChoiceScreenCoordinates = [];

        strctCurrentTrial.m_iMaxFramesInChoiceEpoch = round((1e3/g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate) * (squeeze(g_strctParadigm.TrialTimeoutMS.Buffer(1,:,g_strctParadigm.TrialTimeoutMS.BufferIdx)/1e3)));
        strctCurrentTrial.thisTrialChoiceTextureOrder = floor(rand(1, strctCurrentTrial.m_iMaxFramesInChoiceEpoch ) * fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'))+1;

        % index in reverse to go from high saturation in the outermost ring to low
        % saturation in the innermost ring
        % alternatively change the order of the saturations in the config file
        for iSaturations = strctCurrentTrial.m_strctChoiceVars.numSaturations:-1:1
            %for iSaturations = 1:strctCurrentTrial.m_strctChoiceVars.numSaturations
            [targetPointsX, targetPointsY] = pol2cart(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas + strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle, strctCurrentTrial.m_strctChoiceVars.choiceRhos(iSaturations));

            targetPointsX = targetPointsX + strctCurrentTrial.m_afChoiceRingLocation(1);
            targetPointsY = targetPointsY + strctCurrentTrial.m_afChoiceRingLocation(2);
            for iTargetPoints = 1:numel(targetPointsX)
                targetRect(iTargetPoints,:) = round([targetPointsX(iTargetPoints) - strctCurrentTrial.m_iChoiceWidth/2; ...
                    targetPointsY(iTargetPoints) - strctCurrentTrial.m_iChoiceWidth/2; ...
                    targetPointsX(iTargetPoints) + strctCurrentTrial.m_iChoiceWidth/2; ...
                    targetPointsY(iTargetPoints) + strctCurrentTrial.m_iChoiceWidth/2]);

                strctCurrentTrial.m_strctReward.m_aiChoiceCenters(iSaturations,iTargetPoints,:) = round([targetPointsX(iTargetPoints); targetPointsY(iTargetPoints)]);
            end
            %strctCurrentTrial.m_aiChoiceTargetRects = strctCurrentTrial.targetRect;
            strctCurrentTrial.m_aiChoiceScreenCoordinates = vertcat(strctCurrentTrial.m_aiChoiceScreenCoordinates,targetRect);

        end
        if strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials
            % append the gray choice information
            grayTargetRect(1,:) = round([strctCurrentTrial.m_afChoiceRingLocation(1) - strctCurrentTrial.m_iChoiceWidth/2; ...
                strctCurrentTrial.m_afChoiceRingLocation(2) - strctCurrentTrial.m_iChoiceWidth/2; ...
                strctCurrentTrial.m_afChoiceRingLocation(1)  + strctCurrentTrial.m_iChoiceWidth/2; ...
                strctCurrentTrial.m_afChoiceRingLocation(2) + strctCurrentTrial.m_iChoiceWidth/2]);
            strctCurrentTrial.m_aiChoiceScreenCoordinates = vertcat(strctCurrentTrial.m_aiChoiceScreenCoordinates,grayTargetRect);
            strctCurrentTrial.m_strctReward.m_aiChoiceCenters(end+1,1,1:2) = deal(strctCurrentTrial.m_afChoiceRingLocation');
        end

    elseif strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli')
        %dbstop if warning
        %warning('stop')
        nTotalChoices = ((strctCurrentTrial.m_strctChoiceVars.numSaturations) * strctCurrentTrial.m_strctChoiceVars.m_NTargets);
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters = [];
        % draw matches in a 180 degree annuli ring in the contralateral field to the samples

        %dbstop if warning
        %warning('stop')
        if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli')
            if strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) <...
                    (strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter(1))
                strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = linspace(-90,90,nTotalChoices);%    0:180/nTotalChoices:180;
            else
                strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = linspace(90,270,nTotalChoices);%    180:180/nTotalChoices:360;
            end
            strctCurrentTrial.m_strctChoiceVars.choiceRhos = strctCurrentTrial.m_iChoiceRingSize/2;
            [targetPointsX, targetPointsY] = pol2cart(deg2rad(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas), strctCurrentTrial.m_strctChoiceVars.choiceRhos);
            targetPointsX = targetPointsX + strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition(1);
            targetPointsY = targetPointsY + strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition(2);
        elseif strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')
            if strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) <...
                    (strctCurrentTrial.m_strctTrialParams.m_aiStimulusServerScreenCenter(1))
                strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = ...
                    linspace(-90,90, strctCurrentTrial.m_strctChoiceVars.numColors  );
            else
                strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = ...
                    linspace(90,270,strctCurrentTrial.m_strctChoiceVars.numColors );
            end
            minimumSeparation = strctCurrentTrial.m_iChoiceWidth;

            minHalfCircumference = (minimumSeparation * strctCurrentTrial.m_strctChoiceVars.numColors * ...
                g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier)/2;
            minRadius = round(minHalfCircumference/(2*pi));
            minRho = minimumSeparation * g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier;
            iRhoSteps = minRho : minRho : minRho * strctCurrentTrial.m_strctChoiceVars.numSaturations;

            targetPointsX = [];
            targetPointsY = [];
            for iActiveSaturations = 1:strctCurrentTrial.m_strctChoiceVars.numSaturations
                strctCurrentTrial.m_strctChoiceVars.choiceRhos(iActiveSaturations) = iRhoSteps(iActiveSaturations);
                [targetPointsX(end+1:end+strctCurrentTrial.m_strctChoiceVars.numColors), ...
                    targetPointsY(end+1:end+strctCurrentTrial.m_strctChoiceVars.numColors)] = ...
                    pol2cart(deg2rad(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas), ...
                    strctCurrentTrial.m_strctChoiceVars.choiceRhos(iActiveSaturations));

            end
            targetPointsX = targetPointsX + strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition(1);
            targetPointsY = targetPointsY + strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition(2);
        end

        for iTargetPoints = 1:numel(targetPointsX)
            targetRect(iTargetPoints,:) = round([targetPointsX(iTargetPoints) - strctCurrentTrial.m_iChoiceWidth/2; ...
                targetPointsY(iTargetPoints) - strctCurrentTrial.m_iChoiceWidth/2; ...
                targetPointsX(iTargetPoints) + strctCurrentTrial.m_iChoiceWidth/2; ...
                targetPointsY(iTargetPoints) + strctCurrentTrial.m_iChoiceWidth/2]);
        end
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,1) = reshape(targetPointsX(1:end),[strctCurrentTrial.m_strctChoiceVars.numSaturations, strctCurrentTrial.m_strctChoiceVars.numColors]);
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,2) = reshape(targetPointsY(1:end),[strctCurrentTrial.m_strctChoiceVars.numSaturations, strctCurrentTrial.m_strctChoiceVars.numColors]);

        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(end+1,1,1) = targetPointsX(end);
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(end,1,2) = targetPointsY(end);

        strctCurrentTrial.m_aiChoiceScreenCoordinates = targetRect;

        strctCurrentTrial.m_iMaxFramesInChoiceEpoch = ...
            round((1e3/g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate) * ...
            (squeeze(g_strctParadigm.TrialTimeoutMS.Buffer(1,:,g_strctParadigm.TrialTimeoutMS.BufferIdx)/1e3)));

        strctCurrentTrial.thisTrialChoiceTextureOrder = floor(rand(1, strctCurrentTrial.m_iMaxFramesInChoiceEpoch ) * ...
            fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'))+1;
    elseif strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')
        %dbstop if warning
        %        warning('stop')
        nTotalChoices = ((strctCurrentTrial.m_strctChoiceVars.numSaturations) * strctCurrentTrial.m_strctChoiceVars.m_NTargets);
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters = [];

		% calculate choice thetas based on inputted range
		strctCurrentTrial.m_strctChoiceVars.m_minChoiceAngleDeg = fnTsGetVar('g_strctParadigm', 'minChoiceAngleDeg');
		strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg = fnTsGetVar('g_strctParadigm', 'maxChoiceAngleDeg');
	
		if strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg <= strctCurrentTrial.m_strctChoiceVars.m_minChoiceAngleDeg
			strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg = strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg + 360;
		end
		TotalSpan = strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg - strctCurrentTrial.m_strctChoiceVars.m_minChoiceAngleDeg;
		if g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial 
			rotAngle = floor(rand()*TotalSpan/nTotalChoices);
			strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = rotAngle + sort(mod([strctCurrentTrial.m_strctChoiceVars.m_minChoiceAngleDeg:TotalSpan/nTotalChoices:strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg-0.001], 360));
			strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = circshift(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas, floor(rand()*nTotalChoices));
		elseif ~g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial
			strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = sort(mod([strctCurrentTrial.m_strctChoiceVars.m_minChoiceAngleDeg:TotalSpan/nTotalChoices:strctCurrentTrial.m_strctChoiceVars.m_maxChoiceAngleDeg-0.001], 360));
		end


        if g_strctParadigm.m_strctChoiceVars.m_bRandomRingOrderInversion
            strctCurrentTrial.m_strctChoiceVars.m_bChoiceRingOrderInversion = true;
            if rand() > 0.5
                strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = flip(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas);
            end
        else
            strctCurrentTrial.m_strctChoiceVars.m_bChoiceRingOrderInversion = false;
        end


        % OLD VERSION (does not work)
        %{
		
		%if isempty(g_strctParadigm.m_ciQuadrantsSelected)
        %    fnPauseParadigm();
        %    fnParadigmToKofikoComm('DisplayMessageNow','No quadrants selected! Select quadrants Before Running Task');
        %end
		
        if g_strctParadigm.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial
            % if g_strctParadigm.m_bDebugModeEnabled
            %    dbstop if warning
            %   ShowCursor();
            %  warning('stop')
            % end
            strctCurrentTrial.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial = true;

            strctCurrentTrial.m_strctChoiceVars.m_fChoiceRotationDegrees = floor(rand(1,1) * (360/strctCurrentTrial.m_strctChoiceVars.m_NTargets));
            strctCurrentTrial.m_strctChoiceVars.m_iNumChoiceRotationSteps = ...
                floor((strctCurrentTrial.m_strctChoiceVars.m_fChoiceRotationDegrees / 360) * ...
                strctCurrentTrial.m_strctChoiceVars.m_NTargets);

        else
            strctCurrentTrial.m_strctChoiceVars.m_bRotateChoiceRingOnEachTrial = false;
            strctCurrentTrial.m_strctChoiceVars.m_fTrialRotationDegrees = 0;
            strctCurrentTrial.m_strctChoiceVars.m_iNumChoiceRotationSteps = 0;
            strctCurrentTrial.m_strctChoiceVars.m_fChoiceRotationDegrees = 0;

        end

        QuadBounds = [0:90:360];
        totQuadDeg = numel(g_strctParadigm.m_ciQuadrantsSelected) * 90;

        if g_strctParadigm.m_strctChoiceVars.m_bChoiceRandomSpacing
            r = rand(1, strctCurrentTrial.m_strctChoiceVars.m_NTargets);
            strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = cumsum(22.5 + ((numel(g_strctParadigm.m_ciQuadrantsSelected) * 90)-(22.5*strctCurrentTrial.m_strctChoiceVars.m_NTargets)).*(r/sum(r)));
        else
            strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = ...
                [0:(numel(g_strctParadigm.m_ciQuadrantsSelected) * 90)/strctCurrentTrial.m_strctChoiceVars.m_NTargets:(numel(g_strctParadigm.m_ciQuadrantsSelected) * 90)-0.001];
        end

        strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas + strctCurrentTrial.m_strctChoiceVars.m_fChoiceRotationDegrees;

        for q = 1:4 % 4 quadrants
            qmin = QuadBounds(q);
            qmax = QuadBounds(q+1);

            if all(q~=(cell2mat(g_strctParadigm.m_ciQuadrantsSelected)))
                iAdjustedThetas = strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas >= QuadBounds(q);
                strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas(iAdjustedThetas) = mod(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas(iAdjustedThetas) + 90, 360);
            end
        end

        if g_strctParadigm.m_strctChoiceVars.m_bRandomRingOrderInversion
			strctCurrentTrial.m_strctChoiceVars.m_bChoiceRingOrderInversion = true;
            if rand() > 0.5
				strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas = flip(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas)
			end
		else
			strctCurrentTrial.m_strctChoiceVars.m_bChoiceRingOrderInversion = false;
        end
        %}


        minimumSeparation = fnTsGetVar('g_strctParadigm', 'AnnulusSaturationSeparation');%strctCurrentTrial.m_iChoiceWidth;

        minHalfCircumference = (minimumSeparation * strctCurrentTrial.m_strctChoiceVars.m_NTargets * ...
            g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier)/2;
        minRadius = round(minHalfCircumference/(2*pi));
        minRho = fnTsGetVar('g_strctParadigm', 'AnnulusCenterOffset');%minRadius * g_strctParadigm.m_strctChoicesVars.m_fMinimumSeparationMultiplier;
        iRhoSteps = minRho : minimumSeparation : minRho + (minimumSeparation * (strctCurrentTrial.m_strctChoiceVars.numSaturations)) - minimumSeparation;

        targetPointsX = [];
        targetPointsY = [];
        tempX = [];
        tempY = [];
        for iActiveSaturations = strctCurrentTrial.m_strctChoiceVars.numSaturations : -1 : 1
            strctCurrentTrial.m_strctChoiceVars.choiceRhos(iActiveSaturations) = iRhoSteps(iActiveSaturations);
            [tempX, tempY] = ...
                pol2cart(deg2rad(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas), ...
                strctCurrentTrial.m_strctChoiceVars.choiceRhos(iActiveSaturations));
            targetPointsX = [targetPointsX, tempX];
            targetPointsY = [targetPointsY, tempY];
            %{
            [tempX, tempY] = ...
                pol2cart(deg2rad(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas), ...
                strctCurrentTrial.m_strctChoiceVars.choiceRhos(iActiveSaturations));
                targetPointsX = [targetPointsX, circshift(tempX, [1,g_strctParadigm.m_strctChoiceVars.m_iNumChoiceRotationSteps])];
			targetPointsY = [targetPointsY, circshift(tempY, [1,g_strctParadigm.m_strctChoiceVars.m_iNumChoiceRotationSteps])];
            %}


            %{
            [targetPointsX(end+1:end+strctCurrentTrial.m_strctChoiceVars.numColors), ...
                targetPointsY(end+1:end+strctCurrentTrial.m_strctChoiceVars.numColors)] = ...
                pol2cart(deg2rad(strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas), ...
                strctCurrentTrial.m_strctChoiceVars.choiceRhos(iActiveSaturations));
			targetPointsX = circshift(targetPointsX, [1,g_strctParadigm.m_strctChoiceVars.m_iNumChoiceRotationSteps]);
			targetPointsY = circshift(targetPointsY, [1,g_strctParadigm.m_strctChoiceVars.m_iNumChoiceRotationSteps] );
            %}

        end
        targetPointsX = targetPointsX + strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition(1);
        targetPointsY = targetPointsY + strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition(2);
    end

    for iTargetPoints = 1 : numel(targetPointsX)
        targetRect(iTargetPoints,:) = round([targetPointsX(iTargetPoints) - strctCurrentTrial.m_iChoiceWidth/2; ...
            targetPointsY(iTargetPoints) - strctCurrentTrial.m_iChoiceWidth/2; ...
            targetPointsX(iTargetPoints) + strctCurrentTrial.m_iChoiceWidth/2; ...
            targetPointsY(iTargetPoints) + strctCurrentTrial.m_iChoiceWidth/2]);
    end


    strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,1) = ...
        reshape(targetPointsX(1:end),[strctCurrentTrial.m_strctChoiceVars.m_NTargets,...
        strctCurrentTrial.m_strctChoiceVars.numSaturations])';
    strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,2) = ...
        reshape(targetPointsY(1:end),[strctCurrentTrial.m_strctChoiceVars.m_NTargets,...
        strctCurrentTrial.m_strctChoiceVars.numSaturations])';

    %strctCurrentTrial.m_strctReward.m_aiChoiceCenters(end+1,1,1) = targetPointsX(end);
    %strctCurrentTrial.m_strctReward.m_aiChoiceCenters(end,1,2) = targetPointsY(end);

    strctCurrentTrial.m_aiChoiceScreenCoordinates = targetRect;
    strctCurrentTrial.m_iMaxFramesInChoiceEpoch = ...
        round((1e3/g_strctParadigm.m_strctStimServerVars.m_fStimulusMonitorRefreshRate) * ...
        (squeeze(g_strctParadigm.TrialTimeoutMS.Buffer(1,:,g_strctParadigm.TrialTimeoutMS.BufferIdx)/1e3)));
    strctCurrentTrial.thisTrialChoiceTextureOrder = floor(rand(nTotalChoices, strctCurrentTrial.m_iMaxFramesInChoiceEpoch ) * ...
        fnTsGetVar('g_strctParadigm', 'NumTexturesToPreparePerChoice'))+1;

    strctCurrentTrial.m_iStimulusLUTEntries = repmat(g_strctParadigm.m_strctChoiceVars.m_iClutIndices, [3,1])-1;
    strctCurrentTrial.m_aiLocalStimulusColors = floor((g_strctParadigm.m_strctChoiceVars.m_aiChoiceRingRGBCorrected/((2^16)-1))*255);
end

strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT= [1 1 1];
if g_strctParadigm.m_bDebugModeEnabled
    dbstop if warning
    ShowCursor();
    warning('stop')
end

luminanceDeviation = fnTsGetVar('g_strctParadigm','ChoiceLuminanceDeviation');
numLuminanceStepsPerChoice = floor(253 / (strctCurrentTrial.m_strctChoiceVars.m_NTargets + 1));
if rem(numLuminanceStepsPerChoice,2) == 0
    numLuminanceStepsPerChoice = numLuminanceStepsPerChoice - 1;
end

%ChoiceLUTsLuminanceSteps = floor(253 / (strctCurrentTrial.m_strctChoiceVars.m_NTargets + 1));
%if rem(ChoiceLUTsLuminanceSteps,2) == 0
%    ChoiceLUTsLuminanceSteps = ChoiceLUTsLuminanceSteps - 1;
%end

g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps = ...
    linspace(-luminanceDeviation,luminanceDeviation,numLuminanceStepsPerChoice);
LUTsize = size(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs);
strctCurrentTrial.m_strctChoiceVars.ChoiceLUTs = ...
    sort(reshape(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs,[LUTsize(1) * LUTsize(2),1]));
%sort(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs);
strctCurrentTrial.m_strctChoicePeriod.ClutEntries = [];



for iSaturations = 1:numel(strctCurrentTrial.m_aiActiveChoiceSaturationID)
    strctCurrentTrial.m_strctChoicePeriod.m_acActiveChoiceSaturations{iSaturations} = g_strctParadigm.m_strctMasterColorTable{1}.(strctCurrentTrial.m_strActiveChoiceSaturations{iSaturations});

    for iColors = strctCurrentTrial.m_aiActiveChoiceColorID
        thisColorCoordinate = strctCurrentTrial.m_strctChoicePeriod.m_acActiveChoiceSaturations{iSaturations}.m_afCartCoordinates(iColors,:);
        rawValues = luv2rgb([ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .* ...
            ((thisColorCoordinate(1)*100) + g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps*100)', ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(2)'.*100, ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(3)'.*100]);
        if any(any(rawValues > 1)) ||  any(any(rawValues < 0))
            rawValues( rawValues > 1) = 1;
            rawValues( rawValues < 0) = 0;
            fnParadigmToKofikoComm('DisplayMessageNow','Choice Color Values Out Of Range');
        end
        strctCurrentTrial.m_strctChoicePeriod.ClutEntries = ...
            vertcat(strctCurrentTrial.m_strctChoicePeriod.ClutEntries,fnGammaCorrectRGBValues(rawValues));
    end
end
%{
if strctCurrentTrial.m_strctCuePeriod.m_bIncludeGrayTrials
    % append the gray choice information
    thisColorCoordinate = fnTsGetVar('g_strctParadigm', 'BackgroundLUVCoordinates');
    rawValues = luv2rgb([ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .* ...
        ((thisColorCoordinate(1)) + g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps*100)', ...
        ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(2)'.*100, ...
        ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(3)'.*100]);
    if any(any(rawValues > 1)) ||  any(any(rawValues < 0))
        rawValues( rawValues > 1) = 1;
        rawValues( rawValues < 0) = 0;
        fnParadigmToKofikoComm('DisplayMessageNow','Choice Color Values Out Of Range');

    end
    %dbstop if warning
	%warning('stop')
    strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs =...
        [ones(1,strctCurrentTrial.m_strctChoiceVars.numColors)* ...
        nTotalChoices-(strctCurrentTrial.m_strctChoiceVars.numColors-1),...
        (nTotalChoices-(strctCurrentTrial.m_strctChoiceVars.numColors)):-1:1];
    strctCurrentTrial.m_strctChoiceVars.ChoiceLUTs = vertcat(strctCurrentTrial.m_strctChoiceVars.ChoiceLUTs,g_strctParadigm.m_strctChoiceVars.GrayChoiceLUTs');
    strctCurrentTrial.m_strctChoicePeriod.ClutEntries = vertcat(strctCurrentTrial.m_strctChoicePeriod.ClutEntries,fnGammaCorrectRGBValues(rawValues));
else
     strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs = 1:nTotalChoices;

end
%}

%dbstop if warning
%ShowCursor;
%warning('stop')
%strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs = 1:strctCurrentTrial.m_strctChoiceVars.m_NTargets;
strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs = strctCurrentTrial.m_aiActiveChoiceColorID;
strctCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor= floor(g_strctParadigm.m_aiBackgroundColor/255);
strctCurrentTrial.m_strctChoicePeriod.Clut(1,:) = [0,0,0];
strctCurrentTrial.m_strctChoicePeriod.Clut(256,:) = [65535,65535,65535];
% strctCurrentTrial.m_strctChoicePeriod.Clut(g_strctParadigm.m_strctChoiceVars.m_iClutIndices,:) = g_strctParadigm.m_strctChoiceVars.m_aiChoiceRingRGBCorrected;
%g_strctParadigm.m_strctChoiceVars.ChoiceLUTs


strctCurrentTrial.m_strctChoicePeriod.Clut(g_strctParadigm.CLUTOffset+1:g_strctParadigm.CLUTOffset+size(strctCurrentTrial.m_strctChoicePeriod.ClutEntries,1),:) = strctCurrentTrial.m_strctChoicePeriod.ClutEntries;



%{
    x(:,1,:) = strctCurrentTrial.m_strctChoicePeriod.Clut
    figure
    imagesc(x/65535)


%}
%% fixation spot stuff

strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType = 'rect';
strctCurrentTrial.m_strctChoicePeriod.m_strFixationSpotType = 'x.';
%strctCurrentTrial.m_strctChoicePeriod.m_strFixationSpotType = 'disc';
strctCurrentTrial.m_strctChoicePeriod.m_pt2fFixationPosition = strctCurrentTrial.m_strctTrialParams.m_pt2fFixationPosition;
strctCurrentTrial.m_strctChoicePeriod.m_afFixationColor = [255, 255, 255];
strctCurrentTrial.m_strctChoicePeriod.m_afLocalFixationColor = [255, 255, 255];
strctCurrentTrial.m_strctChoicePeriod.m_fHoldToSelectChoiceMS = fnTsGetVar('g_strctParadigm','HoldToSelectChoiceMS');
strctCurrentTrial.m_strctChoicePeriod.m_bShowFixationSpot = g_strctParadigm.m_strctChoiceVars.m_bShowFixationSpot;
strctCurrentTrial.m_strctChoicePeriod.m_fFixationSpotSize = fnTsGetVar('g_strctParadigm','ChoiceFixationSpotPix');
strctCurrentTrial.m_strctChoicePeriod.m_bKeepCueOnScreen = false;

strctCurrentTrial.m_strctChoicePeriod.m_bShowChoicesOnScreen = true;
strctCurrentTrial.m_strctChoicePeriod.m_bMultipleAttemptsUntilJuice  = false;
strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize  = 40; %strctCurrentTrial.m_astrctChoicesMedia(1).m_fSizePix;
strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor = [1 1 1];
strctCurrentTrial.m_strctChoicePeriod.m_astrctMicroStim = [];
strctCurrentTrial.m_astrctChoicesMedia.m_fSizePix = 100;

% determine reward structure
strctCurrentTrial = fnDetermineRewardStructure(strctCurrentTrial);




return;

% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------

function [strctCurrentTrial] = fnDynamicPostTrialSetup(strctCurrentTrial)
global g_strctParadigm
%{
dbstop if warning
warning('stop')
[fMin, fMax, ...
strctCurrentTrial.m_strctPostTrial.m_fRetainSelectedChoicePeriodMS ,...
strctCurrentTrial.m_strctPostTrial.m_fIncorrectTrialPunishmentDelayMS ,...
strctCurrentTrial.m_strctPostTrial.m_fAbortedTrialPunishmentDelayMS,...
strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS,...
strctCurrentTrial.m_strctPostTrial.m_fJuiceTimeMSHigh,...
strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS,...
strctCurrentTrial.m_strctPostTrial.m_bReward]  = fnTsGetVar('g_strctParadigm', 'InterTrialIntervalMinMS', 'InterTrialIntervalMaxMS',...
													'RetainSelectedChoicePeriodMS', 'IncorrectTrialPunishmentDelayMS', 'AbortedTrialPunishmentDelayMS',...
													'JuiceTimeMS', 'JuiceTimeHighMS', 'TrialTimeoutMS', 'PostTrialReward');
%}
strctCurrentTrial.m_strctPostTrial.m_bExtinguishNonSelectedChoicesAfterChoice = g_strctParadigm.m_strctPostTrialVars.m_bExtinguishNonSelectedChoicesAfterChoice;
fMin = squeeze(g_strctParadigm.InterTrialIntervalMinMS.Buffer(1,:,g_strctParadigm.InterTrialIntervalMinMS.BufferIdx));
fMax = squeeze(g_strctParadigm.InterTrialIntervalMaxMS.Buffer(1,:,g_strctParadigm.InterTrialIntervalMaxMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_fRetainSelectedChoicePeriodMS = squeeze(g_strctParadigm.RetainSelectedChoicePeriodMS.Buffer(1,:,g_strctParadigm.RetainSelectedChoicePeriodMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec = (rand() * (fMax-fMin) + fMin)/1e3;
strctCurrentTrial.m_strctPostTrial.m_fIncorrectTrialPunishmentDelayMS = squeeze(g_strctParadigm.IncorrectTrialPunishmentDelayMS.Buffer(1,:,g_strctParadigm.IncorrectTrialPunishmentDelayMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_fAbortedTrialPunishmentDelayMS = squeeze(g_strctParadigm.AbortedTrialPunishmentDelayMS.Buffer(1,:,g_strctParadigm.AbortedTrialPunishmentDelayMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS = squeeze(g_strctParadigm.JuiceTimeMS.Buffer(1,:,g_strctParadigm.JuiceTimeMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_fJuiceTimeMSHigh = squeeze(g_strctParadigm.JuiceTimeHighMS.Buffer(1,:,g_strctParadigm.JuiceTimeHighMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS = squeeze(g_strctParadigm.TrialTimeoutMS.Buffer(1,:,g_strctParadigm.TrialTimeoutMS.BufferIdx));
strctCurrentTrial.m_strctPostTrial.m_bReward = squeeze(g_strctParadigm.PostTrialReward.Buffer(1,:,g_strctParadigm.PostTrialReward.BufferIdx));

return;

% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------
function [strctCurrentTrial] = fnCalcDiscCoordinates(strctCurrentTrial)


strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,1:4) = [(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1)/2),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1)/2),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) +...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1)/2),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) +...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1)/2)];
[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesX, strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesY]  =...
    deal(zeros(4, strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames, 1));


return;


% ----------------------------------------------------------------------------------------------------------------------
%% ----------------------------------------------------------------------------------------------------------------------
function [strctCurrentTrial] = fnCalcBarCoordinates(strctCurrentTrial)
iNumOfBars = 1;

strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,1:4) =...
    [(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1)/2),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(2)/2),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1) + strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(1)/2),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) + strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimDimensions(2)/2)];

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint1(iNumOfBars,1), strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint1(iNumOfBars,2)] =...
    fnRotateAroundPoint(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta);

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint2(iNumOfBars,1), strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint2(iNumOfBars,2)] =...
    fnRotateAroundPoint(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,4),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta);

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint3(iNumOfBars,1), strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint3(iNumOfBars,2)] =...
    fnRotateAroundPoint(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,3),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,4),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta);

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint4(iNumOfBars,1), strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint4(iNumOfBars,2)] =...
    fnRotateAroundPoint(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,3),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_rect(1,2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta);

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,1),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,2)] =...
    fnRotateAroundPoint(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2) - ...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iMoveDistance/2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta);

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,1),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,2)] = ...
    fnRotateAroundPoint(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2)...
    + strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iMoveDistance/2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(1),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(2),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iTheta);

[strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesX, strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesY]  =...
    deal(zeros(4, strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames, 1));


% yes, this next part is all one line of code
% all this does is packs all the coordinate information for the stimulus into a single array
strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesX(1:4,:,iNumOfBars) = vertcat(round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint1(iNumOfBars,1)...
    - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,1)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint1(iNumOfBars,1)-(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,1)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)),...
    round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint2(iNumOfBars,1) - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,1)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint2(iNumOfBars,1) -...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,1)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)),...
    round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint3(iNumOfBars,1) - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,1)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint3(iNumOfBars,1) -...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,1)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)),...
    round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint4(iNumOfBars,1) - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,1)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint4(iNumOfBars,1) -...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,1) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,1)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)));

strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiCoordinatesY(1:4,:,iNumOfBars) = vertcat(round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint1(iNumOfBars,2)...
    - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,2)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint1(iNumOfBars,2)-(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,2)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)),...
    round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint2(iNumOfBars,2) - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2)...
    - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,2)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint2(iNumOfBars,2) -...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,2)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)),...
    round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint3(iNumOfBars,2) - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,2)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint3(iNumOfBars,2) -...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,2)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)),...
    round(linspace(strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint4(iNumOfBars,2) - (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) -...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_starting_point(iNumOfBars,2)),strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiPoint4(iNumOfBars,2) -...
    (strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiStimCoordinates(iNumOfBars,2) - strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_aiBar_ending_point(iNumOfBars,2)),...
    strctCurrentTrial.m_strctTrialParams.m_strctStimulusVariables.m_iNumFrames)));

return;

% ----------------------------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

function [strctCurrentTrial] = fnDetermineRewardStructure(strctCurrentTrial)
global g_strctParadigm
% check for reward eligibility
%dbstop if warning
%warning('stop')
if g_strctParadigm.m_bDebugModeEnabled
    dbstop if warning
    ShowCursor();
    warning('stop')
end
% fraction of maximum color space radius to reward;
strctCurrentTrial.m_strctReward.m_bBinaryReward = g_strctParadigm.m_bBinaryReward;
strctCurrentTrial.m_strctReward.m_fRewardRange = .2;
% Reward falloff rate
strctCurrentTrial.m_strctReward.m_fRewardFalloffRate = .01;
if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'ring')

    strctCurrentTrial.m_strctReward.m_fChoiceThetaTolerance = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngleTolerance;
    if strctCurrentTrial.m_strctTrialParams.m_bGrayTrial
        nullCategoryID = find(strcmp(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname,g_strctParadigm.m_strNullCategoryName));
        strctCurrentTrial.m_strctReward.m_aiRhoRange = unique(squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(nullCategoryID,:,:)));
        strctCurrentTrial.m_strctReward.m_afColorSpaceTheta = 0;
        strctCurrentTrial.m_strctReward.m_afRingTheta = 0;
        strctCurrentTrial.m_strctReward.m_strRewardSaturationName = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{nullCategoryID};
        strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex = [0,0];
    else
        strCurrentSaturationNames = fieldnames(strctCurrentTrial.m_cCurrentlySelectedSaturations);
        thisSatName = deblank(strCurrentSaturationNames(strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID,:));
        thisSatName = thisSatName{1};
        [~,choiceSaturationID] = ismember(thisSatName,g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname);

        %{
		%if ~isempty(choiceSaturationID) && any(choiceSaturationID)
		if g_strctParadigm.m_strctStimuliVars.m_bDirectMatchCueChoices
            if ismember(myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec),...
                    myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec))

                % an exact match between cue and choice colors exists. Use this
                % for binary choices, or as the starting point for variable reward

                choiceColorMatchID = find(ismember(myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec),...
                    myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec)));

                strctCurrentTrial.m_strctReward.m_aiRhoRange = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(choiceSaturationID,choiceColorMatchID,:));
                strctCurrentTrial.m_strctReward.m_afColorSpaceTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,choiceColorMatchID,:));
                strctCurrentTrial.m_strctReward.m_afRingTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(choiceSaturationID,choiceColorMatchID,:));
                strctCurrentTrial.m_strctReward.m_strRewardSaturationName = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{choiceSaturationID};
                strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex = [choiceSaturationID, choiceColorMatchID];

            else
                % no exact match; different colors are selected for the cue and
                % choice. Use the nearest choice value as the starting point.
                % multiple correct choices will exist, even if binary reward is
                % set
                minAngle = min(abs(myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec) - ...
                    myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec)));

                allMatchingAngles = find(abs(myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec) - ...
                    myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec)) == minAngle);

                strctCurrentTrial.m_strctReward.m_aiTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,allMatchingAngles,:));
                strctCurrentTrial.m_strctReward.m_aiRhoRange = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(choiceSaturationID,allMatchingAngles,:));
                strctCurrentTrial.m_strctReward.m_afRingTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(choiceSaturationID,allMatchingAngles,:));
                strctCurrentTrial.m_strctReward.m_strRewardSaturationName = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{choiceSaturationID};
                strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex = [choiceSaturationID, allMatchingAngles];

            end


            %strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID
            %strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation

            %strctCurrentTrial.m_strctReward.m_aiRhoRange = g_strctParadigm.m_strctChoiceVars.choiceParameters.NullArea.m_aiChoiceRho;
            %strctCurrentTrial.m_strctReward.m_afTheta = 0;
            % fraction of maximum color space radius to reward;

            % this cue saturation is not one of the choice saturations
        end
        %}
    end

elseif strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'disc') || ...
        strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli') || ...
        strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')

    % strctCurrentTrial.m_iChoiceRingSize = max(strctCurrentTrial.m_strctChoiceVars.choiceRhos) + (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion) *5;
    strctCurrentTrial.m_aiInsideChoiceRects = cat(3,strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,1) - (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2),...
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,2) - (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2),...
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,1) + (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2),...
        strctCurrentTrial.m_strctReward.m_aiChoiceCenters(:,:,2) + (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2));

    iEntries = 1;
    for iChoiceSaturations= 1:size(strctCurrentTrial.m_aiInsideChoiceRects,1) %		strctCurrentTrial.m_strctChoiceVars.numSaturations

        for iChoiceColors = 1:strctCurrentTrial.m_strctChoiceVars.m_NTargets

            strctCurrentTrial.m_strctReward.m_aiChoiceFramingRects(:,iEntries) = ...
                [strctCurrentTrial.m_strctReward.m_aiChoiceCenters(iChoiceSaturations,iChoiceColors,1) - (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2);...
                strctCurrentTrial.m_strctReward.m_aiChoiceCenters(iChoiceSaturations,iChoiceColors,2) - (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2);...
                strctCurrentTrial.m_strctReward.m_aiChoiceCenters(iChoiceSaturations,iChoiceColors,1) + (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2);...
                strctCurrentTrial.m_strctReward.m_aiChoiceCenters(iChoiceSaturations,iChoiceColors,2) + (strctCurrentTrial.m_strctChoiceVars.m_iInsideChoiceRegion/2)];
            iEntries = iEntries + 1;

        end
    end
    %{
    if strctCurrentTrial.m_strctTrialParams.m_bGrayTrial
        nullCategoryID = find(strcmp(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname,g_strctParadigm.m_strNullCategoryName));

        % strctCurrentTrial.m_strctReward.m_aiRhoRange = unique(squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(nullCategoryID,:,:)));
        strctCurrentTrial.m_strctReward.m_afColorSpaceTheta = 0;
        strctCurrentTrial.m_strctReward.m_afRingTheta = 0;
        strctCurrentTrial.m_strctReward.m_strRewardSaturationName = ...
            g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{strctCurrentTrial.m_strctCuePeriod.m_iNullConditionSaturationID}
        %strctCurrentTrial.m_strctReward.m_strRewardSaturationName = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{nullCategoryID};
        strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex = [strctCurrentTrial.m_strctChoiceVars.numSaturations + 1,1];
    else
    %}
    strCurrentSaturationNames = fieldnames(strctCurrentTrial.m_cCurrentlySelectedSaturations);
    thisSatName = deblank(strCurrentSaturationNames(strctCurrentTrial.m_strctCuePeriod.m_iSelectedSaturationID,:));
    thisSatName = thisSatName{1};
    [~,choiceSaturationID] = ismember(thisSatName,g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname);


    if ~isempty(choiceSaturationID) && any(choiceSaturationID)
        %if ismember(myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec),...
        %        myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec))
        if strctCurrentTrial.m_strctChoicePeriod.m_bIsDirectMatchTrial
            % an exact match between cue and choice colors exists. Use this
            % for binary choices, or as the starting point for variable reward
            choiceColorMatchID = find(ismember(myRoundn...
                (g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec),...
                myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),...
                g_strctParadigm.m_iAzimuthRoundToDec)));

            strctCurrentTrial.m_strctReward.m_aiRhoRange = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(choiceSaturationID,choiceColorMatchID,:));
            strctCurrentTrial.m_strctReward.m_afColorSpaceTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,choiceColorMatchID,:));
            strctCurrentTrial.m_strctReward.m_afRingTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(choiceSaturationID,choiceColorMatchID,:));
            strctCurrentTrial.m_strctReward.m_strRewardSaturationName = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{choiceSaturationID};
            strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex{1} = choiceSaturationID;
            strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex{2} =  choiceColorMatchID;

        else
            % random reward for non direct match - do i have to put anything here?
            strctCurrentTrial.m_strctReward.m_fProbeTrialRewardProbability = squeeze(g_strctParadigm.ProbeTrialRewardProbability.Buffer(1,:,g_strctParadigm.ProbeTrialRewardProbability.BufferIdx));

            % no exact match; different colors are selected for the cue and
            % choice. Use the nearest choice value as the starting point.
            % multiple correct choices will exist, even if binary reward is
            % set

            % old code for rewarding closest colorimetric choice (12.8.2020)
            %{
			allSat = ones(size(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles)); % replace with actual variable storing saturation rho

			[cartX, cartY] = pol2cart(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles, allSat);

			choicesX = cartX(strctCurrentTrial.m_aiActiveChoiceColorID);
			choicesY = cartY(strctCurrentTrial.m_aiActiveChoiceColorID);

			cueX = cartX(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID);
			cueY = cartY(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID);

			dists = sqrt(((choicesX - repmat(cueX, size(choicesX))).^2)+((choicesY - repmat(cueY, size(choicesY))).^2));
			[~, diff_order] = sort(dists);
			diffs = diff(sort(dists));

			acceptable = zeros(size(choicesX));
			acceptable(1) = 1;
			count = 1;
			while diffs(count) < 0.01 % arbitrary threshold - we want to accomodate machine precision
				acceptable(count + 1) = 1;
				count = count + 1;
			end

			strctCurrentTrial.m_strctReward.m_aiAcceptableChoiceID = strctCurrentTrial.m_aiActiveChoiceColorID(diff_order(acceptable==1));
            %}

            % old code (8.25.2020)
            %minAngle = min(abs(myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec) - ...
            %    myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec)));

            %allMatchingAngles = find(abs(myRoundn(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,:),g_strctParadigm.m_iAzimuthRoundToDec) - ...
            %    myRoundn(strctCurrentTrial.m_strctCuePeriod.m_strctSelectedSaturation.azimuthSteps(strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID),g_strctParadigm.m_iAzimuthRoundToDec)) == minAngle);

            %strctCurrentTrial.m_strctReward.m_aiTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(choiceSaturationID,allMatchingAngles,:));
            %strctCurrentTrial.m_strctReward.m_aiRhoRange = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(choiceSaturationID,allMatchingAngles,:));
            %strctCurrentTrial.m_strctReward.m_afRingTheta = squeeze(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(choiceSaturationID,allMatchingAngles,:));
            %strctCurrentTrial.m_strctReward.m_strRewardSaturationName = g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{choiceSaturationID};
            %strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex = [choiceSaturationID, allMatchingAngles];
            %strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex{1} = choiceSaturationID;
            %strctCurrentTrial.m_strctReward.m_aiCueToChoiceMatchIndex{2} =  allMatchingAngles;

        end
    end
    %strctCurrentTrial.m_aiInsideChoiceCoordinates = strctCurrentTrial.m_strctReward.m_aiChoiceCenters
    %strctCurrentTrial.m_aiChoiceScreenCoordinates
    %strctCurrentTrial.m_strctChoiceVars.choiceRhos
    %strctCurrentTrial.m_aiChoiceScreenCoordinates
    %strctCurrentTrial.m_strctChoiceVars.m_afChoiceThetas
    %strctCurrentTrial.m_strctChoiceVars.numSaturations
    %strctCurrentTrial.m_strctChoiceVars.numColors

    % end
end

return;
