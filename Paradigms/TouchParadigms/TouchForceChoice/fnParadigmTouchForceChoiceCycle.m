function [strctOutput] = fnParadigmTouchForceChoiceCycle(strctInputs, varargin)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global g_strctParadigm g_strctDynamicStimLog g_strctPTB g_strctDAQParams

if g_strctParadigm.m_strctEyeSmoothing.m_bEyeSmoothingEnabled
g_strctParadigm.m_strctEyeSmoothing.m_afEyeSmoothingArray(g_strctParadigm.m_strctEyeSmoothing.m_iEyeSmoothingIndex,:) = ...
																							strctInputs.m_pt2iEyePosScreen;
g_strctParadigm.m_strctEyeSmoothing.m_iEyeSmoothingIndex = mod(g_strctParadigm.m_strctEyeSmoothing.m_iEyeSmoothingIndex,fnTsGetVar('g_strctParadigm','EyeSmoothingKernel')) + 1;
strctInputs.m_pt2iEyePosScreen = mean(g_strctParadigm.m_strctEyeSmoothing.m_afEyeSmoothingArray,1);
end

% Make sure stimulus server media files are in memory
if ~isempty(strctInputs.m_acInputFromStimulusServer)
    if strcmpi(strctInputs.m_acInputFromStimulusServer{1},'MediaLoaded')
        g_strctParadigm.m_bStimulusServerLoadedMedia = true;
    end
end
if g_strctParadigm.m_iMachineState == 0 || varargin{1}
    % Variable update crap. Only happens while paradigm is paused
    fnVariableUpdateCheck();
    if g_strctParadigm.m_iMachineState == 0
        % We're short circuiting the switch's case 0 here so we need to duplicate it.
        fnParadigmToKofikoComm('SetParadigmState','Waiting for user to press Start');
    end
    return;
end
TRIAL_DYNAMIC_CODE = 32690;
TRIAL_START_CODE = 32700;
TRIAL_END_CODE = 32699;
TRIAL_ALIGN_CODE = 32698;
TRIAL_OUTCOME_INCORRECT = 32696;
TRIAL_OUTCOME_CORRECT = 32697;
TRIAL_OUTCOME_ABORTED = 32695;
TRIAL_OUTCOME_TIMEOUT = 32694;

%{
if isfield(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim,'m_aSpikeTrain') && ...
                            length(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_aSpikeTrain) > 1
                        % Start with the first spike in the train
                        g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_iSpikeIterator = 1;
                        g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_fSpikeTrainStartTS = GetSecs();
                        % Set as active. We'll check at the beginning of each cycle to see if we need to trigger another spike
                        g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_bActive = 1;

                        % Important! Stop the GUI from updating while we are stimulating. Updating takes until the start of the next screen refresh which can block the microstimulator!
                        %g_strctParadigm.m_bDoNotDrawDueToCriticalSection = 1;
                        fnParadigmToKofikoComm('criticalsectionon', true);
                    elseif ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim)

                        fnParadigmToKofikoComm('MultiChannelStimulation',g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim);
                    end
%}
% Handle microstim events

% make sure the paradigm is running, there is supposed to be stimulation during this trial, there is supposed to be stimulation during this epoch
%{
if g_strctParadigm.m_bParadigmActive && g_strctParadigm.m_bMicroStimThisTrial && g_strctParadigm.m_bMicroStimThisEpoch
	%tic

    fCurrentTime = GetSecs();

	% is the current time greater than the time for the next spike in the chain?
	if fCurrentTime - g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_fSpikeTrainStartTS >=...
		g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_afSpikeTrain(...
		g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_iSpikeIterator)*1e-3

		% Send a spike request

		fnParadigmToKofikoComm('MultiChannelStimulation',g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim);

		% Record the TS for this spike. It will be recorded in Plexon as well, but this is easier to extract for
		% general purposes
		g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_afStimTimes(...
		g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_iSpikeIterator) = GetSecs();

		% iterate the iterator
		g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_iSpikeIterator = ...
		g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_iSpikeIterator + 1;



    end
    % see if we're at the last planned spike or if we've gone more than 10% over the max time planned for the spike train
	if g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_iSpikeIterator > ...
        size(g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_afSpikeTrain,2) ||...
        fCurrentTime - g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_fSpikeTrainStartTS >=...
        g_strctParadigm.m_strctCurrentTrial.(g_strctParadigm.m_strCurrentEpoch).m_astrctMicroStim.m_afSpikeTrain(end)*1.1

        % we're done with this spike train, but there might be others in
        % the trial
        g_strctParadigm.m_bMicroStimThisEpoch = 0;
		g_strctParadigm.m_bMicroStimThisTrial = 0;
		fnParadigmToKofikoComm('criticalsectionoff');
    end
%{
    if g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_bActive && ...
            g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_iSpikeIterator <= length(...
            g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_aSpikeTrain)
        if fCurrentTime - g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_fSpikeTrainStartTS >=...
                g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_aSpikeTrain(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod(...
                g_strctParadigm.m_iLastKnownCueToBeDisplayedOnScreen).m_astrctMicroStim.m_iSpikeIterator)*1e-3
            % Send a spike request

            % Update the spike iterator
            g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_iSpikeIterator =...
                g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_iSpikeIterator + 1;

        end
    elseif g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_bActive
        g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_bActive = 0;
        fnParadigmToKofikoComm('criticalsectionoff');
        %g_strctParadigm.m_bDoNotDrawDueToCriticalSection = 0;
    end
%}
	%disp(sprintf('stim check time is %f',toc))

end
%}
% Support for running the paradigm in the scanner....
fCurrTime = GetSecs();
if g_strctParadigm.m_bMRI_Mode

    if strctInputs.m_abExternalTriggers(1)
        g_strctParadigm.m_iTriggerCounter = g_strctParadigm.m_iTriggerCounter+1;
    end
    if g_strctParadigm.m_iTriggerCounter == 1
        g_strctParadigm.m_iActiveBlock = 1;
    end

    % Did we just start a new block? If so, abort current trial and
    % generate a new trial relevant for the new block!
    if g_strctParadigm.m_iTriggerCounter > 0 && ~isnan(g_strctParadigm.m_fRunLengthSec_fMRI)
        % We are running....
        fTS_Sec = fnTsGetVar('g_strctParadigm', 'TR') / 1e3;

        fTimeElapsedSec = GetSecs()-g_strctParadigm.m_fFirstTriggerTS;
        fNumTRsPassed = fTimeElapsedSec / fTS_Sec;
        iActiveBlock = find(g_strctParadigm.m_aiCumulativeTRs >= fNumTRsPassed ,1,'first');
        g_strctParadigm.m_iActiveBlock = iActiveBlock;

        if isempty(iActiveBlock) && ~isnan(fTimeElapsedSec) && ~isnan(g_strctParadigm.m_aiCumulativeTRs(1))
            g_strctParadigm.m_iMachineState = 201;
            fnParadigmToKofikoComm('DisplayMessageNow','Finished fMRI Run');

        elseif ~isempty(iActiveBlock) && ~isempty(g_strctParadigm.m_strctCurrentTrial) && iActiveBlock ~= g_strctParadigm.m_strctCurrentTrial.m_iBlockIndex
            fnParadigmToKofikoComm('DisplayMessageNow', sprintf('Entering block %d',iActiveBlock) );
            % We just entered a new block!
            % Abort trial and generate a new one.
            fnParadigmToStimulusServer('AbortTrial');
            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Cancelled;BlockOutOfTime';
            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fTrialAbortedTS_Kofiko = GetSecs();
            fnParadigmToStatServerComm('Send','TrialEnd');
            fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialEndCode);
            fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
            g_strctParadigm.m_iMachineState = 2;
        end


    end

    % Handle micro stim events
    if g_strctParadigm.m_iTriggerCounter > 0 && ~isempty(g_strctParadigm.m_iActiveBlock) && g_strctParadigm.m_iActiveBlock > 0
        % During a run (block is in progress)
        if  g_strctParadigm.m_strctDesign.m_strctOrder.m_aiMicroStimEntireBlockPresetIndex(g_strctParadigm.m_iActiveBlock) > 0

            strctPreset = g_strctParadigm.m_strctDesign.m_acMicrostimPresets{g_strctParadigm.m_strctDesign.m_strctOrder.m_aiMicroStimEntireBlockPresetIndex(g_strctParadigm.m_iActiveBlock)};
            fTrainRateHz = fnParseVariable(strctPreset,'TrainRate',0);
            aiChannels = str2num(strctPreset.Channels);
            if fCurrTime-g_strctParadigm.m_fMicroStimTimer > 1/fTrainRateHz
                iNumChannels = length(aiChannels);
                if iNumChannels > 0
                    clear astrctStimulation
                    for iChannelIter=1:iNumChannels
                        astrctStimulation(iChannelIter).m_iChannel = aiChannels(iChannelIter);
                        astrctStimulation(iChannelIter).m_fDelayToTrigMS = 0;
                    end
                    fnParadigmToKofikoComm('MultiChannelStimulation', astrctStimulation);
                    g_strctParadigm.m_fMicroStimTimer = GetSecs();
                end
            end
        end
    end


end


switch g_strctParadigm.m_iMachineState
    case 0
        fnParadigmToKofikoComm('SetParadigmState','Waiting for user to press Start');



    case 1
        g_strctParadigm.m_iMachineState = 2;
        %{
        % Make sure a design is available...
        if ~isempty(g_strctParadigm.m_strctDesign) && g_strctParadigm.m_bStimulusServerLoadedMedia
            if g_strctParadigm.m_bMRI_Mode &&  g_strctParadigm.m_iTriggerCounter == 0
                % Are we running already ? If so, skip this step
                g_strctParadigm.m_iMachineState = 200;
            else
                g_strctParadigm.m_iMachineState = 2;
            end
        else
            fnParadigmToKofikoComm('SetParadigmState','Please load an experiment design file!');
        end
        %}
    case 2
        % Prepare next trial!
        % if isempty(g_strctParadigm.m_strctDesign)
        %     fnParadigmToKofikoComm('SetParadigmState','Problem loading design!');
        %     g_strctParadigm.m_iMachineState = 0;
        % else

        %             % Which block are we at ?
        %             aiNumTrials = cumsum(g_strctParadigm.m_strctDesign.m_strctOrder.m_aiNumTrialsPerBlock);
        %             iBlockIndex= find(aiNumTrials >= g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter,1,'first');
        %             if isempty(iBlockIndex) % someone modified aiNumTrials in real time...
        %                 iBlockIndex = length(aiNumTrials);
        %             end
        %
        %             g_strctParadigm.m_strCurrentBlock = g_strctParadigm.m_strctDesign.m_strctOrder.m_acBlockNames{iBlockIndex};
        %
        if (~isempty(g_strctParadigm.m_strctCurrentTrial) && isfield(g_strctParadigm.m_strctCurrentTrial,'m_strctTrialOutcome') && ~g_strctParadigm.m_bDynamicStimuli && ...
                isfield(g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome,'m_strResult') && ~strcmpi(g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult,'Correct') && ...
                g_strctParadigm.m_strctDesign.m_strctOrder.m_abRepeatIncorrect(g_strctParadigm.m_strctCurrentTrial.m_iBlockIndex)) && ~g_strctParadigm.m_bTrialRepetitionOFF
            g_strctParadigm.m_strctCurrentTrial =  g_strctParadigm.m_strctPrevTrial;
        else
            % First trial or previously correct trial...
            %tic
            [strctTemp,strWhatHappened] =  fnParadigmTouchForceChoicePrepareTrial();
            %disp(sprintf('trial prep took %s', num2str(toc)));
            if isempty(strctTemp)
                if strcmpi(strWhatHappened, 'TR_Mode_FinishedAllBlocks')
                    fnParadigmToKofikoComm('DisplayMessageNow','Finished fMRI Run');
                    g_strctParadigm.m_iMachineState = 201; % Skip stimulus server prepare trial
                    return;
                else
                    fnParadigmToKofikoComm('DisplayMessageNow','Error generating trial. check design!');
                end
            else
                g_strctParadigm.m_strctCurrentTrial = strctTemp;
            end
        end

        g_strctParadigm.m_strctPrevTrial = g_strctParadigm.m_strctCurrentTrial;

        if ~fnParadigmToKofikoComm('IsTouchMode')
            fnParadigmToStimulusServer('PrepareTrial',g_strctParadigm.m_strctCurrentTrial);
        else
            fnParadigmTouchForceChoiceTrainingDrawCycle({'PrepareTrial',g_strctParadigm.m_strctCurrentTrial});
        end

        if ~fnParadigmToKofikoComm('IsTouchMode')
            fnParadigmToKofikoComm('SetParadigmState', 'Waiting for  stimulus server...');
            g_strctParadigm.m_iMachineState = 3;
            g_strctParadigm.m_bTrialRepetitionOFF = false;
        else
            g_strctParadigm.m_iMachineState = 4; % Skip stimulus server prepare trial
            g_strctParadigm.m_bTrialRepetitionOFF = false;
        end
        %  end

    case 3
        % Wait until trial preparation is done (stimulus server loaded everything?)
        if ~isempty(strctInputs.m_acInputFromStimulusServer)
            if strcmpi(strctInputs.m_acInputFromStimulusServer{1},'TrialPreparationDone')
                g_strctParadigm.m_iMachineState = 4;
            end
        end
    case 4
        % Show fixation spot
        if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod)
            % Display fixation and wait until enough time has elapsed
            if ~fnParadigmToKofikoComm('IsTouchMode')
                fnParadigmToStimulusServer('ShowFixationSpot');
                fnParadigmToKofikoComm('SetFixationPosition', g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition);

                fnParadigmToKofikoComm('SetParadigmState', 'Waiting for  stimulus server...');
                g_strctParadigm.m_iMachineState = 5;
            else
                fFlipTimeLocal = fnParadigmTouchForceChoiceTrainingDrawCycle({'ShowFixationSpot'});
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fFixationSpotFlipTS_Kofiko = fFlipTimeLocal;
                g_strctParadigm.m_iMachineState = 6;
            end
        else
            % Skip fixation spot stage and go directly to cue
            g_strctParadigm.m_iMachineState = 10;
        end
    case 5
        % Wait to hear from stimulus server that fixation spot appeared on
        % screen
        if ~isempty(strctInputs.m_acInputFromStimulusServer)
            if strcmpi(strctInputs.m_acInputFromStimulusServer{1},'FixationSpotFlip')
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fFixationSpotFlipTS_Kofiko = GetSecs();
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fFixationSpotFlipTS_StimulusServer = strctInputs.m_acInputFromStimulusServer{2};
                g_strctParadigm.m_iMachineState = 6;
            end
        end
    case 6

        % Fixation spot is on screen. Wait until monkey look at it
        fDistX=strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition(1);
        fDistY=strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition(2);
        fDistToFixationSpot = sqrt(fDistX*fDistX+fDistY*fDistY);
        if ~g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
            fnParadigmToKofikoComm('SetParadigmState', sprintf('Block %d : Waiting for fixation... (%.2f)',g_strctParadigm.m_strctCurrentTrial.m_iBlockIndex,fDistToFixationSpot));
        else
            fnParadigmToKofikoComm('SetParadigmState', sprintf('Waiting for fixation... (%.2f)',fDistToFixationSpot));
        end
        if fnParadigmToKofikoComm('IsTouchMode')
            % Monkey can only touch the fixation spot....
            if  strctInputs.m_abMouseButtons(1)
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_pt2fTouchFixation = strctInputs.m_pt2iEyePosScreen;
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fDistToFixationSpot = fDistToFixationSpot;
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fTouchTS = GetSecs();
                if fDistToFixationSpot < g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix
                    g_strctParadigm.m_fStartFixationTS = GetSecs();

                    fnParadigmToKofikoComm('SetParadigmState', 'Monkey touched spot...');
                    if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod) && ...
                            g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueFixationPeriodMS == 0
                        g_strctParadigm.m_iMachineState = 9;
                    else
                        g_strctParadigm.m_iMachineState = 7;
                    end
                else
                    % Monkey touched outside fixation spot. what to do
                    % next?
                    if g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_bAbortTrialUponTouchOutsideFixation
                        % Clear the screen
                        g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Aborted;TouchOutsideFixation';
                        feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
                        fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);

                        fnParadigmTouchForceTrainingChoiceDrawCycle({'ClearScreen'});
                        fnParadigmToKofikoComm('SetParadigmState', 'Trial Aborted (touch outside fixation)...');

                        g_strctParadigm.m_fWaitTimer = GetSecs();

                        g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec+...
                            g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fAbortedTrialPunishmentDelayMS/1e3;
                        g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial


                    end

                end

            end

        else
            % Is monkey looking at the fixation spot?
            if fDistToFixationSpot <= g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix
                fnParadigmToKofikoComm('SetParadigmState', 'Inside Fixation region');
                g_strctParadigm.m_fStartFixationTS = GetSecs();

                g_strctParadigm.m_iMachineState = 7;


            end
        end

    case 7

        % Eye drift correction, for my stupid monkeys that shift the chair around

        if ~(g_strctDAQParams.m_fUseMouseClickAsEyePosition || g_strctDAQParams.m_bMouseGazeEmulator) && g_strctParadigm.m_strctTrainingVars.m_bCorrectEyeDrift && ...
                (GetSecs()- g_strctParadigm.m_fStartFixationTS) >= (fnTsGetVar('g_strctParadigm','EyeDriftCorrectionRate')/1e2)*g_strctParadigm.m_iDriftCorrectIteration
            fnAdjustEyeGainForDrift(strctInputs.m_pt2iEyePosScreen);
            g_strctParadigm.m_iDriftCorrectIteration = g_strctParadigm.m_iDriftCorrectIteration + 1;
        end


        % Monkey is looking/ touching the fixation spot
        % If enough time has elapsed, go on with the trial (display cue,
        % etc)
        fDistX=strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition(1);
        fDistY=strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition(2);
        fDistToFixationSpot = sqrt(fDistX*fDistX+fDistY*fDistY);



        if fnParadigmToKofikoComm('IsTouchMode')

            if fDistToFixationSpot >  g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix || ~strctInputs.m_abMouseButtons(1)
                % Monkey moved his finger outside fixationi spot, or stopped
                % pressing....
                g_strctParadigm.m_iMachineState = 6;
            else
                if (GetSecs()- g_strctParadigm.m_fStartFixationTS) >= g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueFixationPeriodMS/1e3
                    fnParadigmToKofikoComm('SetParadigmState', 'Trial Will start when touch released...');
                    g_strctParadigm.m_iMachineState = 9; % Monkey fixated for enough time. Wait until he releases touch
                end
            end
        else

            % Is still looking?
            if fDistToFixationSpot > g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix
                %  Monkey broke fixation.
                g_strctParadigm.m_iMachineState = 6;

            end

            fnParadigmToKofikoComm('SetParadigmState', sprintf('Inside Fixation region for %.2f',GetSecs()- g_strctParadigm.m_fStartFixationTS ));

            % Eye tracking mode
            if GetSecs()- g_strctParadigm.m_fStartFixationTS  >= g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fPreCueFixationPeriodMS/1e3

                g_strctParadigm.m_iMachineState = 10; % Monkey fixated for enough time. Start the trial....

                if g_strctParadigm.m_bPreCueReward
                    if rand() <  squeeze(g_strctParadigm.PreCueRewardProbability.Buffer(1,:,g_strctParadigm.PreCueRewardProbability.BufferIdx))/100
                        fnParadigmToKofikoComm('Juice', squeeze(g_strctParadigm.PreCueJuiceTimeMS.Buffer...
                            (1,:,g_strctParadigm.PreCueJuiceTimeMS.BufferIdx)), 0, ...
                            squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx)),...
                            squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));
                    end
                end
            end

        end

    case 9
        % Wait until monkey releases touch from fixation spot, then start
        % trial
        if ~strctInputs.m_abMouseButtons(1)
            g_strctParadigm.m_iMachineState = 10;
        end
    case 10



        % Send request to stimulus server to initiate the trial....
        if isempty(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod) && isempty(g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia)
            if g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_bRewardTouchFixation
                if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_strRewardSound)
                    fnParadigmToKofikoComm('PlaySound',g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_strRewardSound);
                end

                if fnParadigmToKofikoComm('IsTouchMode')
                    fnParadigmToKofikoComm('JuiceBlock', g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS);
                else
                    fnParadigmToKofikoComm('Juice', g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS, 0, ...
                        squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx)),...
                        squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));
                end

            end
            if fnParadigmToKofikoComm('IsTouchMode')
                fnParadigmTouchForceChoiceTrainingDrawCycle({'ClearScreen'});
            else
                fnParadigmToStimulusServer('ClearScreen');
            end

            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Touch Fixation';
            feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
            fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);

            g_strctParadigm.m_fWaitTimer = GetSecs();
            g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec;
            g_strctParadigm.m_iMachineState = 11; % Weird degenerate case, like in simple touch screen training....
        else
            if fnParadigmToKofikoComm('IsTouchMode')
                fnParadigmTouchForceChoiceTrainingDrawCycle({'StartTrial'});
                g_strctParadigm.m_iMachineState = 12; % TOUCH MODE
            else

                fnParadigmToStimulusServer('StartTrial');

                % Declare a new trial is starting. This is for the statistics
                % server side
                fnParadigmToStatServerComm('Send','TrialStart');
                fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialStartCode);

                % Send trial information to Plexon
                % Which Trial type is this?


                if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
                    % Tell Plexon this is dynamic, so we can look up what happened later
                    fnDAQWrapper('StrobeWord',TRIAL_DYNAMIC_CODE);

                    % Send a unique vector to plexon so we can look this trial up in the recording event history
                    % this method ensures that we can lose track of when a trial was presented relative to other trials
                    % and still find it post hoc. Since every trial here is generated on the fly it is imperative that
                    % we be able to find it in the backups

                    % Supports n numbers of entries in the vector, but 3 is more than enough. This whole thing takes about
                    % 1 ms, so we do it before the trial
                    for i = 1:size(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiTrialVec,2)
                        fnDAQWrapper('StrobeWord',g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiTrialVec(i));
                    end


                else
                    % which cue was presented?
                    fnDAQWrapper('StrobeWord',g_strctParadigm.m_strctCurrentTrial.m_iTrialType);
                    fnDAQWrapper('StrobeWord',g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iMediaIndex);
                end
                % Declare the trial start
                fnParadigmToKofikoComm('TrialStart', g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_iTrialType);
                if strcmp(g_strctParadigm.m_strAlignTo, 'CueOnset')
                    fnParadigmToStatServerComm('Send','TrialAlign');
                    fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialAlignCode);  %Align spikes in real time to this time point.
                end

                g_strctParadigm.m_iLastKnownCueToBeDisplayedOnScreen = 0;
                g_strctParadigm.m_iMachineState = 20; % NON-TOUCH MODE
            end
        end


    case 11



        % Wait ITI after touch fixation (no cue, no choices) and start
        % again...
        fElapsedTimeSec = GetSecs()-g_strctParadigm.m_fWaitTimer;
        fWaitTimeSec = g_strctParadigm.m_fWaitPeriodSec;
        if (fElapsedTimeSec > fWaitTimeSec) && ~strctInputs.m_abMouseButtons(1)
            g_strctParadigm.m_iMachineState = 2;
        else
            if fWaitTimeSec-fElapsedTimeSec > 0
                fnParadigmToKofikoComm('SetParadigmState', sprintf('Trial Finished (Resuming in %.1f sec)...',fWaitTimeSec-fElapsedTimeSec));
            else
                fnParadigmToKofikoComm('SetParadigmState', sprintf('Trial Finished (Resuming when touch is released'));
            end
        end

    case 12
        % Easy case. Touch screen mode. no need to fixate ....

        % Cue -> Memory -> Choices will be appeared on the stimulus screen
        % in the correct timing.

        % We call to draw cycle at high rate to simulate what will happen
        % in the non touch mode....

        [strWhatHappened, fWhenItHappened] = fnParadigmTouchForceChoiceTrainingDrawCycle({''});
        if ~isempty(strWhatHappened)
            switch strWhatHappened
                case 'MemoryOnsetTS'
                    % Good to know, but don't do anything...
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fMemoryOnsetTS_Kofiko = fWhenItHappened;
                case 'ChoicesOnsetTS'
                    % if choices appear on the screen, move to the next stage....
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko = fWhenItHappened;
                    g_strctParadigm.m_iMachineState = 13;
            end
        end
    case 13
        % Choices are on the screen. Wait until monkey touches one of the
        % choices, or timeout!
        fElapsedTime = GetSecs()-g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko ;
        if fElapsedTime > g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3
            % Trial Timeout!
            g_strctParadigm.m_iMachineState = 14;
        else
            fnParadigmToKofikoComm('SetParadigmState', sprintf('Waiting for answer (%.2f Sec)',g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3-fElapsedTime));
        end

        if strctInputs.m_abMouseButtons(1)
            % Monkey touched the screen. Is he also inside one of the
            % targets rectangles ?
            iNumChoices = length(g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia);

            for iChoiceIter=1:iNumChoices

                fDistX=strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition(1);
                fDistY=strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition(2);

                if strcmpi(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType,'Rect')
                    bInsideChoice = abs(fDistX) <= g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize && ...
                        abs(fDistY) <= g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize;
                elseif strcmpi(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType,'Circular')
                    fDistToFixationSpot = sqrt(fDistX*fDistX+fDistY*fDistY);
                    bInsideChoice = fDistToFixationSpot <=g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize;
                end

                if bInsideChoice


                    g_strctParadigm.m_fTouchChoiceTS = GetSecs();
                    g_strctParadigm.m_iSelectedChoice = iChoiceIter;

                    if g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fHoldToSelectChoiceMS == 0
                        % This is considered a commitment!
                        fnParadigmToKofikoComm('SetParadigmState', sprintf('Selected %d', g_strctParadigm.m_iSelectedChoice ));
                        g_strctParadigm.m_iMachineState = 15;
                    else
                        % Still have time to change his mind....
                        g_strctParadigm.m_iMachineState = 16;
                    end

                end

            end

        end

    case 14
        % Trial timeout!

        g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Timeout';
        fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial'}); % Clear screen & handles
        feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
        fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);

        g_strctParadigm.m_fWaitTimer = GetSecs();
        g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec;
        g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial
        if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
            fnSaveBackup();
        end
    case 15

        % Monkey committed to a decision. Does he get a reward?
        g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectCounter = g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectCounter + 1;
        g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_afTouchChoiceTS(g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectCounter) = g_strctParadigm.m_fTouchChoiceTS;
        g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_aiSelectedChoice(g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectCounter) = g_strctParadigm.m_iSelectedChoice;

        bGiveJuice = g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_bJuiceReward;
		

        if bGiveJuice
            if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_strRewardSound)
                fnParadigmToKofikoComm('PlaySound',g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_strRewardSound);
            end
            if fnParadigmToKofikoComm('IsTouchMode')
                fnParadigmToKofikoComm('JuiceBlock', g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS);
            else
                juiceRewardMS = g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS;
                if g_strctParadigm.m_iPositiveJuiceIncrement
									PositiveIncrementPct = 1 + fnTsGetVar('g_strctParadigm', 'PositiveIncrement')/100;
									RewardStreak = g_strctParadigm.m_iPositiveJuiceIncrement;
                    juiceRewardMS =  min(juiceRewardMS * (PositiveIncrementPct^RewardStreak), g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fJuiceTimeMSHigh);
										g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fJuiceRewardMS = juiceRewardMS;
                end
                if g_strctParadigm.m_strctTrainingVars.m_bTrainingMode && g_strctParadigm.m_strctTrainingVars.m_bAutoBalanceJuiceReward

                    [biasAdjustedJuiceReward] = fnAdjustJuiceReward();
                    biasAdjustedJuiceDrops = max(round(biasAdjustedJuiceReward * squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx))),1);
                    %biasAdjustedJuiceDrops
                    fnParadigmToKofikoComm('Juice', round(biasAdjustedJuiceReward * juiceRewardMS), 0, ...
                        biasAdjustedJuiceDrops,...
                        squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));

                    %% bias adjusted end
                else
                    % normal juice reward
                    fnParadigmToKofikoComm('Juice', juiceRewardMS, 0, ...
                        squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx)),...
                        squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));
                end
            end

            % Jackpot?
            if rand() < g_strctParadigm.m_strctTrainingVars.m_fJackpotChance
                fnParadigmToKofikoComm('Juice', juiceRewardMS, 0, ...
                    squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx))*5,...
                    squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx))/2);
            end

            % Correct trial!
            fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial',...
                g_strctParadigm.m_iSelectedChoice, g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fRetainSelectedChoicePeriodMS});

            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Correct';
            %g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectedChoice = g_strctParadigm.m_iSelectedChoice;
            fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
            feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
            g_strctParadigm.m_fWaitTimer = GetSecs();
            g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec;
            g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial
        else
            % Monkey selected a target with no reward. What do we do next?
            if g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_bMultipleAttemptsUntilJuice
                % Record that an attempt was made at this target, Wait
                % until release, and try again...
                g_strctParadigm.m_iMachineState = 17;
            else
                % Incorrect trial
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Incorrect';
                %g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectedChoice = g_strctParadigm.m_iSelectedChoice;
                if g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_bExtinguishNonSelectedChoicesAfterChoice
                    fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial',g_strctParadigm.m_iSelectedChoice, g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fRetainSelectedChoicePeriodMS});
                else
                    fnParadigmTouchForceChoiceTrainingDrawCycle({'AbortTrial'});
                end
                fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
                feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);

                g_strctParadigm.m_fWaitTimer = GetSecs();
                g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec+...
                    g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fIncorrectTrialPunishmentDelayMS/1e3;
                g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial

            end

        end
        if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
            fnSaveBackup();
        end
    case 16

        fElapsedTime = GetSecs()-g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko ;
        if fElapsedTime > g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3
            % Trial Timeout!
            g_strctParadigm.m_iMachineState = 14;
        end

        % Monkey touched the screen. But he needs to hold the touch to
        % commit
        fDistX=strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_pt2fPosition(1);
        fDistY=strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_pt2fPosition(2);
        if strcmpi(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType,'Rect')
            bInsideChoice = abs(fDistX) <= g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize && ...
                abs(fDistY) <= g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize;
        elseif strcmpi(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType,'Circular')
            fDistToFixationSpot = sqrt(fDistX*fDistX+fDistY*fDistY);
            bInsideChoice = fDistToFixationSpot <=g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize;
        end
        if ~bInsideChoice || ~strctInputs.m_abMouseButtons(1)
            % Monkey switched his mind and moved his hand from this choice
            % before the time to commit elapsed...
            g_strctParadigm.m_iMachineState = 13;
        else
            if GetSecs()-g_strctParadigm.m_fTouchChoiceTS >  g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fHoldToSelectChoiceMS/1e3
                g_strctParadigm.m_iMachineState = 15; % Monkey committed to a decision
            end
        end
    case 17
        % Incorrect selection of target, but second chance was given. Wait
        % until moneky releases touch...
        fElapsedTime = GetSecs()-g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko ;
        if fElapsedTime > g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3
            % Trial Timeout!
            g_strctParadigm.m_iMachineState = 14;
        end

        if ~strctInputs.m_abMouseButtons(1)
            g_strctParadigm.m_iMachineState = 13;
        end
    case 20
        % NON-TOUCH MODE
        % Trial was initiated on the stimulus server.
        % Need to keep track of eye position while cues are on screen
        % And, at some point, choices will appear on screen.
        % At that time, switch to the next state of the machine....

        bAbortTrial = false;

        % Cue will be displayed, followed by a set of choices.
        if g_strctParadigm.m_iLastKnownCueToBeDisplayedOnScreen == 0
            bMaintainFixationOnCue = false; % we cannot maintain fixation on screen until we are informed where the cues are...
            bMaintainFixationOnFixationSpot = false;
            if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod)
                bMaintainFixationOnFixationSpot = true;
                pt2fFixationCenter = g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition;
                fThreshold = g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix;
            end
        else
            bMaintainFixationOnCue = g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_bAbortTrialIfBreakFixationOnCue;
            bMaintainFixationOnFixationSpot = g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_bAbortTrialIfBreakFixationDuringCue;
            if bMaintainFixationOnFixationSpot
                pt2fFixationCenter = g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_pt2fFixationPosition;
                fThreshold = g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_fFixationRegionPix;
            end
        end

        % We need to monitor eye position during cues presentation.
        if bMaintainFixationOnCue
            fDistX=strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_pt2fCuePosition(1);
            fDistY=strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_pt2fCuePosition(2);
            switch lower(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_strCueFixationRegion)
                case 'entirecue'
                    if (abs(fDistX) > g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_fCueSizePix || ...
                            abs(fDistY) > g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_fCueSizePix)
                        bAbortTrial = true;
                    end
            end
        end

        if bMaintainFixationOnFixationSpot
            fDistX=strctInputs.m_pt2iEyePosScreen(1)-pt2fFixationCenter(1);
            fDistY=strctInputs.m_pt2iEyePosScreen(2)-pt2fFixationCenter(2);
            if sqrt(fDistX.^2+fDistY.^2) > fThreshold
                bBlinkTimerElapsed = fnCheckBlinkTimer('check');
                %if g_strctParadigm.m_fBlinkTimer == 0
                %	g_strctParadigm.m_fBlinkTimer = GetSecs();
                if bBlinkTimerElapsed
                    %elseif GetSecs() - g_strctParadigm.m_fBlinkTimer>...
                    %			(squeeze(g_strctParadigm.BlinkTimeMS.Buffer(:,1,g_strctParadigm.BlinkTimeMS.BufferIdx)) /1e3)
                    bAbortTrial = true;
                end
            else
                g_strctParadigm.m_fBlinkTimer = 0;
                fnCheckBlinkTimer('reset');
            end
        end

        if bAbortTrial
            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Aborted';
            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fTrialAbortedTS_Kofiko = GetSecs();

            fnParadigmToStatServerComm('Send',['TrialOutcome ',num2str(g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(1))]);
            fnParadigmToStatServerComm('Send','TrialEnd');

            fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(1)); % 1 = ABORTED
            fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialEndCode);

            fnParadigmToStimulusServer('AbortTrial');

            fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
            feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
            g_strctParadigm.m_fWaitTimer = GetSecs();
            g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec+...
                g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fAbortedTrialPunishmentDelayMS/1e3;
            g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial
            if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
                fnSaveBackup();
            end
        else
            % Information flowing from stimulus server...
            if ~isempty(strctInputs.m_acInputFromStimulusServer)
				strctInputs.m_acInputFromStimulusServer{1};
                if strcmpi(strctInputs.m_acInputFromStimulusServer{1},'ChoicesOnsetTS')

                    if strcmp(g_strctParadigm.m_strAlignTo, 'ChoicesOnset')
                        fnParadigmToStatServerComm('Send','TrialAlign');
                        fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialAlignCode);  %Align spikes in real time to this time point.
                    end
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko = GetSecs();
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_StatServer = strctInputs.m_acInputFromStimulusServer{2};
                    g_strctParadigm.m_bWasOutsideChoice = true;
                    g_strctParadigm.m_iMachineState = 21;

					if g_strctParadigm.m_bMemoryChoiceReward
						if rand() <  squeeze(g_strctParadigm.MemoryChoiceRewardProbability.Buffer(1,:,g_strctParadigm.MemoryChoiceRewardProbability.BufferIdx))/100
							fnParadigmToKofikoComm('Juice', squeeze(g_strctParadigm.MemoryChoiceJuiceTimeMS.Buffer...
								(1,:,g_strctParadigm.MemoryChoiceJuiceTimeMS.BufferIdx)), 0, ...
								squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx)),...
								squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));
						end
					end


                elseif strcmpi(strctInputs.m_acInputFromStimulusServer{1},'CueOnset')
                    g_strctParadigm.m_iLastKnownCueToBeDisplayedOnScreen = strctInputs.m_acInputFromStimulusServer{3};
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_afCueOnset_TS_StimulusServer(g_strctParadigm.m_iLastKnownCueToBeDisplayedOnScreen) = strctInputs.m_acInputFromStimulusServer{2};
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_afCueOnset_TS_Kofiko = GetSecs();

                    if strncmpi(g_strctParadigm.m_strAlignTo, 'CueOnset',8) && g_strctParadigm.m_iLastKnownCueToBeDisplayedOnScreen == 1
                        fnParadigmToStatServerComm('Send','TrialAlign');

                        fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialAlignCode);  %Align spikes in real time to this time point.
                    end

                    %length(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim.m_aSpikeTrain)
                    %isfield(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod,'m_aSpikeTrain')

                    % Micro stim




                    if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim)

                        fnParadigmToKofikoComm('MultiChannelStimulation',g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_astrctMicroStim);
                        % Important! Stop the GUI from updating while we are stimulating. Updating takes until the start of the next screen refresh which can block the microstimulator!
                        %fnParadigmToKofikoComm('criticalsectionon', true);
                    end
                 elseif strcmpi(strctInputs.m_acInputFromStimulusServer{1},'MemoryOnsetTS')
					g_strctParadigm.bMemory = 1;
                 elseif strcmpi(strctInputs.m_acInputFromStimulusServer{1},'MemoryChoicesOnsetTS')
                    g_strctParadigm.bMemoryChoice = 1;
					%{
					Screen('FillRect',g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor,...
						[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3),...
						g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(4)]);
					%fnDrawFixationSpot(g_strctPTB.m_hWindow, g_strctParadigm.m_strctCurrentTrial.m_strctMemoryPeriod, false, 1);
					%} 
                end
            end
        end

    case 21
        % NON-Touch Mode
        % Choices are on the screen. Wait until timeout or monkey makes a
        % saccade. or time out


        fElapsedTime = GetSecs()-g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko;
        if fElapsedTime > g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3
            g_strctParadigm.m_iMachineState = 24;
        else
            fnParadigmToKofikoComm('SetParadigmState', sprintf('Waiting for answer (%.2f Sec)',g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3-fElapsedTime));
        end


        if  isfield(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod,'m_astrctMicroStim') && ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_astrctMicroStim) && ...
                strcmpi(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_astrctMicroStim(1).m_strWhenToStimulate,'LeaveFixation') && ...
                ~isempty(g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod)

            pt2fFixationCenter = g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_pt2fFixationPosition;
            fThreshold = g_strctParadigm.m_strctCurrentTrial.m_strctPreCuePeriod.m_fFixationRegionPix;
            fDistX=strctInputs.m_pt2iEyePosScreen(1)-pt2fFixationCenter(1);
            fDistY=strctInputs.m_pt2iEyePosScreen(2)-pt2fFixationCenter(2);
            if sqrt(fDistX.^2+fDistY.^2) > fThreshold && g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fStimulated == false
                fnParadigmToKofikoComm('MultiChannelStimulation',g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_astrctMicroStim);
                g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fStimulated = true;
            end
        end

        % Check for eye position.
        %iNumChoices = length(g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia);

        if g_strctParadigm.m_bDebugModeEnabled
            %dbstop if warning
            %warning('stop')
        end
        fDistX = strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(1);
        fDistY = strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(2);
        euclidianDistance = sqrt(fDistX^2 + fDistY^2);
		%disp(sprintf('mouse distance = %f, choice ring size = %f',euclidianDistance, g_strctParadigm.m_strctCurrentTrial.m_iChoiceRingSize))
		%dbstop if warning
           % warning('stop')
        if euclidianDistance < g_strctParadigm.m_strctCurrentTrial.m_iChoiceRingSize
            if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'ring')
                % eye trace is inside the choice ring
                [choiceDirectionTheta, choiceDirectionRho] = cart2pol(strctInputs.m_pt2iEyePosScreen(1) - g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(1), ...
                    g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(2) - strctInputs.m_pt2iEyePosScreen(2));
                choiceDirectionTheta = wrapTo2Pi(choiceDirectionTheta);

                choiceDirectionTheta = wrapTo2Pi(choiceDirectionTheta + deg2rad(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle));
                %choiceDirectionTheta - wrapTo2Pi(-deg2rad(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle));
                g_strctParadigm.m_fInsideChoiceTS = GetSecs();
                [insideRhoSat,~] = find(choiceDirectionRho >= g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(:,:,1) & choiceDirectionRho < g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(:,:,2));
                if isempty(insideRhoSat)

                    bInsideChoice = false;

                else
                    bInsideChoice = true;
                    iSelectedChoiceRhoID = unique(insideRhoSat);

                    [~, iSelectedChoiceThetaID] = min(abs(choiceDirectionTheta - g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(iSelectedChoiceRhoID,:)));

                    g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice = [iSelectedChoiceRhoID,iSelectedChoiceThetaID];
                    g_strctParadigm.m_strctCurrentTrial.m_aiAllChoiceSelections(end+1,:) = g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice;
                    g_strctParadigm.m_fInsideChoiceTS = GetSecs();
                    g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice = g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice;
					fnParadigmToKofikoComm('SetParadigmState',sprintf('Choice Theta = %f', choiceDirectionTheta) );

                    g_strctParadigm.m_iMachineState = 22;
                end
            elseif strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'disc') ||...
                    strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli') ||...
                    strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')
                %dbstop if warning
                %warning('stop');
                %{
                insideChoices = strctInputs.m_pt2iEyePosScreen(1) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,1) & ...
                    strctInputs.m_pt2iEyePosScreen(2) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,2) & ...
                    strctInputs.m_pt2iEyePosScreen(1) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,3) & ...
                    strctInputs.m_pt2iEyePosScreen(2) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,4);
                %}
				insideChoices = strctInputs.m_pt2iEyePosScreen(1) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,1) & ...
                    strctInputs.m_pt2iEyePosScreen(2) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,2) & ...
                    strctInputs.m_pt2iEyePosScreen(1) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,3) & ...
                    strctInputs.m_pt2iEyePosScreen(2) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,4);
				%g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_aiChoiceFramingRects
                if any(any(insideChoices))
                    [g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(1),...
                    g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2)] = ...
                    find(strctInputs.m_pt2iEyePosScreen(1) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,1) & ...
                    strctInputs.m_pt2iEyePosScreen(2) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,2) & ...
                    strctInputs.m_pt2iEyePosScreen(1) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,3) & ...
                    strctInputs.m_pt2iEyePosScreen(2) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,4));
                %g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects( g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceSat, ...
                % g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceColor,:)
                %
                %g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice = [g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceSat,...
                %    g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceColor];
                    bInsideChoice = true;
                    g_strctParadigm.m_fInsideChoiceTS = GetSecs();
					g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice = g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice;
					g_strctParadigm.m_iMachineState = 22;

                end
            end
        end

    case 22
        % Monkey saccaded to a choice, however, the "hold to choice" is
        % larger than zero, so the monkey needs to commit by staying on a
        % choice for enough time....
        bInsideChoice = true;
		%dbstop if warning
		%warning('stop');
        fElapsedTime = GetSecs()-g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_fChoicesOnsetTS_Kofiko ;
        if fElapsedTime > g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3
            % Trial Timeout!
            g_strctParadigm.m_iMachineState = 24;
        end
        if g_strctParadigm.m_bDebugModeEnabled
            %dbstop if warning
            %ShowCursor()
            %warning('stop')
        end
        fDistX=strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(1);
        fDistY=strctInputs.m_pt2iEyePosScreen(2)-g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(2);
        euclidianDistance = sqrt(fDistX^2 + fDistY^2);
				%disp(sprintf('mouse distance = %f, choice ring size = %f',euclidianDistance, g_strctParadigm.m_strctCurrentTrial.m_iChoiceRingSize))

        if euclidianDistance <  g_strctParadigm.m_strctCurrentTrial.m_iChoiceRingSize
            if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'ring')
                [choiceDirectionTheta, choiceDirectionRho] = cart2pol(strctInputs.m_pt2iEyePosScreen(1)-g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(1), ...
                    g_strctParadigm.m_strctCurrentTrial.m_afChoiceRingLocation(2) - strctInputs.m_pt2iEyePosScreen(2));
                choiceDirectionTheta = wrapTo2Pi(choiceDirectionTheta);

                choiceDirectionTheta = wrapTo2Pi(choiceDirectionTheta + deg2rad(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle));
                fnParadigmToKofikoComm('SetParadigmState',sprintf('Choice Theta = %f', choiceDirectionTheta) );

                %g_strctParadigm.m_fInsideChoiceTS = GetSecs();
                [insideRhoSat,~] = find(choiceDirectionRho >= g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(:,:,1) & choiceDirectionRho < g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(:,:,2));
                if isempty(insideRhoSat)
                    bBlinkTimerElapsed = fnCheckBlinkTimer('check');
                    if bBlinkTimerElapsed
                        bInsideChoice = false;
                        g_strctParadigm.m_iMachineState = 21;
                    end
                else
                    iSelectedChoiceRhoID = unique(insideRhoSat);
                    [~, iSelectedChoiceThetaID] = min(abs(choiceDirectionTheta - g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(iSelectedChoiceRhoID,:)));
                    iCurrentlySelectedChoice = [iSelectedChoiceRhoID,iSelectedChoiceThetaID];
                    %fnParadigmToKofikoComm('SetParadigmState',sprintf('Currently selected choice = %i %i', iCurrentlySelectedChoice(1), iCurrentlySelectedChoice(2)));
                    if ~(iCurrentlySelectedChoice(1) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(1)) || ...
                            ~(iCurrentlySelectedChoice(2) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2))
                        % animal is still inside the choice region, but has a different choice selected than previous
                        bBlinkTimerElapsed = fnCheckBlinkTimer('check');
                        if bBlinkTimerElapsed
                            % fnParadigmToKofikoComm('SetParadigmState','Choice Changed');

                            g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice = iCurrentlySelectedChoice;
                            g_strctParadigm.m_strctCurrentTrial.m_aiAllChoiceSelections(end+1,:) = g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice;
                            % restart the inside choice region timer
                            g_strctParadigm.m_fInsideChoiceTS = GetSecs();
                        end

                    elseif (iCurrentlySelectedChoice(1) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(1)) || ...
                            (iCurrentlySelectedChoice(2) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2))
                        if g_strctParadigm.m_bBlinkTimerActive
                            fnCheckBlinkTimer('reset');
                        end

                    end


                end
            elseif strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'disc') || ...
					strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli') || ...
					strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')
                 insideChoices = strctInputs.m_pt2iEyePosScreen(1) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,1) & ...
                    strctInputs.m_pt2iEyePosScreen(2) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,2) & ...
                    strctInputs.m_pt2iEyePosScreen(1) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,3) & ...
                    strctInputs.m_pt2iEyePosScreen(2) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,4);
                if any(any(insideChoices))
 					%dbstop if warning
 					%warning('stop')
                    [iCurrentlySelectedChoice(1),iCurrentlySelectedChoice(2)] = ...
                    find(strctInputs.m_pt2iEyePosScreen(1) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,1) & ...
                    strctInputs.m_pt2iEyePosScreen(2) > g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,2) & ...
                    strctInputs.m_pt2iEyePosScreen(1) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,3) & ...
                    strctInputs.m_pt2iEyePosScreen(2) < g_strctParadigm.m_strctCurrentTrial.m_aiInsideChoiceRects(:,:,4));

					%iCurrentlySelectedChoice = [g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceSat, ...
					%	g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceColor];
						
					g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingSaturationID = ... 
						g_strctParadigm.m_strctCurrentTrial.m_aiActiveChoiceSaturationID(iCurrentlySelectedChoice(2));
					g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingColorID = ... 
						g_strctParadigm.m_strctCurrentTrial.m_aiActiveChoiceColorID(iCurrentlySelectedChoice(2));

					g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceID = ... 
						g_strctParadigm.m_strctCurrentTrial.m_aiColorOrder(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingSaturationID, ...
						g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingColorID);
						
                if ~any(iCurrentlySelectedChoice)
                    bBlinkTimerElapsed = fnCheckBlinkTimer('check');
                    if bBlinkTimerElapsed
                        bInsideChoice = false;
                        g_strctParadigm.m_iMachineState = 21;
                    end

                elseif ~(iCurrentlySelectedChoice(1) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(1)) || ...
                        ~(iCurrentlySelectedChoice(2) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2))
                    % animal is still inside the choice region, but has a different choice selected than previous
                    bBlinkTimerElapsed = fnCheckBlinkTimer('check');
                    if bBlinkTimerElapsed
                        % fnParadigmToKofikoComm('SetParadigmState','Choice Changed');

                        g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice = iCurrentlySelectedChoice;
                        g_strctParadigm.m_strctCurrentTrial.m_aiAllChoiceSelections(end+1,:) = g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice;
                        % restart the inside choice region timer
                        g_strctParadigm.m_fInsideChoiceTS = GetSecs();
                    end

                elseif (iCurrentlySelectedChoice(1) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(1)) || ...
                        (iCurrentlySelectedChoice(2) == g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2))
                    if g_strctParadigm.m_bBlinkTimerActive
                        fnCheckBlinkTimer('reset');
                    end

                end
                else
                    bBlinkTimerElapsed = fnCheckBlinkTimer('check');
                    if bBlinkTimerElapsed
                        bInsideChoice = false;
                        g_strctParadigm.m_iMachineState = 21;
                    end
                end
                %bInsideChoice = true;
                %g_strctParadigm.m_iMachineState = 22;

            end
        else

            bBlinkTimerElapsed = fnCheckBlinkTimer('check');
            if bBlinkTimerElapsed
                bInsideChoice = false;
                g_strctParadigm.m_iMachineState = 21;
            end


        end
		if bInsideChoice && GetSecs()-g_strctParadigm.m_fInsideChoiceTS >  g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_fHoldToSelectChoiceMS/1e3
            % g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice = g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice;
			g_strctParadigm.m_iMachineState = 23; % Monkey committed to a decision
            if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'ring')
                g_strctParadigm.m_strctCurrentTrial.m_fChoiceDirectionTheta = choiceDirectionTheta;
                g_strctParadigm.m_strctCurrentTrial.m_fchoiceDirectionRho = choiceDirectionRho;
            end
        else
            %fnParadigmToKofikoComm('SetParadigmState', sprintf('Waiting for correct answer (%.2f Sec)',g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fTrialTimeoutMS/1e3-fElapsedTime));
        end


    case 23
        % Monkey has committed to a choice
        % First thing - has he made decision which entitles juice?
		
        bGiveJuice = 0;
        
%         dbstop if warning
%  		warning('stop')
        [bGiveJuice, bJuiceDropMultiplier, fJuiceTimeMultiplier] = fnDetermineJuiceReward();

		
        
        %g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_bJuiceReward;
        if bGiveJuice > 0
            % Correct trial!
            fnParadigmToKofikoComm('SetParadigmState','Correct Answer!');
            %{
            if ~isempty(g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_strRewardSound)
                fnParadigmToStimulusServer('PlaySound',g_strctParadigm.m_strctCurrentTrial.m_astrctChoicesMedia(g_strctParadigm.m_iSelectedChoice).m_strRewardSound);
            end
            %}
            fnParadigmToStatServerComm('Send',['TrialOutcome ',num2str(g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(3))]);
            fnParadigmToStatServerComm('Send','TrialEnd');

            fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(3)); % 4 = CORRECT TRIAL
            fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialEndCode);

            g_strctParadigm.m_strctTrialCounter.m_iTrialCounter = g_strctParadigm.m_strctTrialCounter.m_iTrialCounter + 1;

				if g_strctParadigm.m_bDebugModeEnabled
					dbstop if warning
					ShowCursor();
					warning('stop')
				end
            if (bGiveJuice <= 1)
                % Flip a coin.
                if rand() <= bGiveJuice % not sure why this is here? - Audrey
					juiceRewardMS = g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fDefaultJuiceRewardMS;
					if g_strctParadigm.m_iPositiveJuiceIncrement
						PositiveIncrementPct = 1 + fnTsGetVar('g_strctParadigm', 'PositiveIncrement')/100;
						RewardStreak = g_strctParadigm.m_iPositiveJuiceIncrement;
						juiceRewardMS =  min(juiceRewardMS * (PositiveIncrementPct^RewardStreak), g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fJuiceTimeMSHigh);
						g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fJuiceRewardMS = juiceRewardMS;
					end
                    fnParadigmToKofikoComm('Juice', juiceRewardMS, 0, ...
                        fnTsGetVar('g_strctParadigm','NumberOfJuiceDrops'),... % squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx)),...
                        fnTsGetVar('g_strctParadigm','JuiceDropInterval'));% squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_bRewardGiven = true;
                else
                    g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_bRewardGiven = false;
                end
            else
                if g_strctParadigm.m_strctTrainingVars.m_bTrainingMode && g_strctParadigm.m_strctTrainingVars.m_bAutoBalanceJuiceReward
                    [biasAdjustedJuiceReward] = fnAdjustJuiceReward();
                    biasAdjustedJuiceDrops = max(round(biasAdjustedJuiceReward * squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx))),1);
                    %biasAdjustedJuiceDrops


                    fnParadigmToKofikoComm('Juice', round(biasAdjustedJuiceReward * juiceRewardMS), 0, ...
                        biasAdjustedJuiceDrops,...
                        squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));

                else
					dbstop if warning
					ShowCursor();
					warning('stop')
                    fnParadigmToKofikoComm('Juice', juiceRewardMS, 0, ...
                        squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx)),...
                        squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx)));




                end

                % Jackpot?
                if rand() < g_strctParadigm.m_strctTrainingVars.m_fJackpotChance
                    fnParadigmToKofikoComm('Juice', juiceRewardMS, 0, ...
                        squeeze(g_strctParadigm.NumberOfJuiceDrops.Buffer(1,:,g_strctParadigm.NumberOfJuiceDrops.BufferIdx))*5,...
                        squeeze(g_strctParadigm.JuiceDropInterval.Buffer(1,:,g_strctParadigm.JuiceDropInterval.BufferIdx))/2);
                end
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_bRewardGiven = true;
            end

            if g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_bExtinguishNonSelectedChoicesAfterChoice
                fnParadigmToStimulusServer('AbortTrial',...
                    g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice, g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fRetainSelectedChoicePeriodMS);
            else
                % Just clear the screen?
                fnParadigmToStimulusServer('AbortTrial');
            end
            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectedChoice = g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice;
            g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Correct';

            fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
            feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
            g_strctParadigm.m_fWaitTimer = GetSecs();
            g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec;
            g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial
        else
            % Monkey selected a target with no reward. What do we do next?
            if g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_bMultipleAttemptsUntilJuice
                % Record that an attempt was made at this target, Wait
                % until release, and try again...
                g_strctParadigm.m_iMachineState = 21;
            else
                % Incorrect trial
                 g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_iSelectedChoice = g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice;
                g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Incorrect';

                fnParadigmToStatServerComm('Send',['TrialOutcome ',num2str(g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(2))]);
                fnParadigmToStatServerComm('Send','TrialEnd');
                g_strctParadigm.m_strctTrialCounter.m_iTrialCounter = g_strctParadigm.m_strctTrialCounter.m_iTrialCounter + 1;
                fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(2)); % 4 = INCORRECT TRIAL
                fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialEndCode);


                if g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_bExtinguishNonSelectedChoicesAfterChoice
                    fnParadigmToStimulusServer('AbortTrial',...
                        g_strctParadigm.m_strctCurrentTrial.m_iSelectedChoice, g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fRetainSelectedChoicePeriodMS);
                else
                    fnParadigmToStimulusServer('AbortTrial');
                end

                fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
                feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
                g_strctParadigm.m_fWaitTimer = GetSecs();
                g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec+...
                    g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fIncorrectTrialPunishmentDelayMS/1e3;
                g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial

            end

        end
        if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
            fnSaveBackup();
        end

    case 24
        % Trial Timeout!
        g_strctParadigm.m_strctCurrentTrial.m_strctTrialOutcome.m_strResult = 'Timeout';
        fnParadigmToStimulusServer('AbortTrial');

        fnParadigmToStatServerComm('Send',['TrialOutcome ',num2str(g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(4))]);
        fnParadigmToStatServerComm('Send','TrialEnd');



        fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialOutcomesCodes(4)); % 4 = TIMEOUT
        fnDAQWrapper('StrobeWord', g_strctParadigm.m_strctDesign.m_strctStatServerDesign.TrialEndCode);

        fnTsSetVarParadigm('acTrials',g_strctParadigm.m_strctCurrentTrial);
        feval(g_strctParadigm.m_strCallbacks,'TrialOutcome',g_strctParadigm.m_strctCurrentTrial);
        g_strctParadigm.m_fWaitTimer = GetSecs();
        g_strctParadigm.m_fWaitPeriodSec =  g_strctParadigm.m_strctCurrentTrial.m_strctPostTrial.m_fInterTrialIntervalSec;

        g_strctParadigm.m_iMachineState = 11; % Wait ITI and start new trial
        if g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
            fnSaveBackup();
        end
    case 200
        % Waiting for first MRI trigger
        fnParadigmToKofikoComm('SetParadigmState','Waiting for first MRI trigger');

        if strctInputs.m_abExternalTriggers(1)
            g_strctParadigm.m_iTriggerCounter = 1;
            g_strctParadigm.m_fFirstTriggerTS = GetSecs();
            fnParadigmToKofikoComm('StartRecording',0);
            % Force abort trial because we start a new fMRI run
            g_strctParadigm.m_strctTrialTypeCounter.m_iTrialCounter = 1;
            g_strctParadigm.m_bTrialRepetitionOFF = true;
            g_strctParadigm.m_iMachineState = 2;
        end
    case 201
        % Finished MRI Run
        fnParadigmToKofikoComm('StopRecording');
        fnParadigmToStimulusServer('AbortTrial');
        g_strctParadigm.m_iTriggerCounter = 0;
        g_strctParadigm.m_fFirstTriggerTS = NaN;
        g_strctParadigm.m_iMachineState = 200;
        g_strctParadigm.m_iActiveBlock = 0;

end




strctOutput = strctInputs;
return;

function fnReleaseMemoryAndAllocatePTBTextures(strctCurrentTrial)
global g_strctParadigm g_strctPTB

% Release existing handles if they exist
if ~isempty(g_strctParadigm.m_ahPTBHandles)
    Screen('Close',g_strctParadigm.m_ahPTBHandles);
    g_strctParadigm.m_ahPTBHandles = [];
end
if ~isempty(g_strctParadigm.m_hNoiseHandle)
    Screen('Close',g_strctParadigm.m_hNoiseHandle);
    g_strctParadigm.m_hNoiseHandle = [];
end

% Allocate new ones for next trial
iNumChoices = length(strctCurrentTrial.m_astrctRelevantChoices);
g_strctParadigm.m_ahPTBHandles = zeros(1, 1+iNumChoices);
g_strctParadigm.m_a2iStimulusRect = zeros(iNumChoices+1,4);

g_strctParadigm.m_a2iStimulusRect(1,:) = fnComputeStimulusRect(strctCurrentTrial.m_fImageHalfSizePix, ...
    [size(strctCurrentTrial.m_Image,2), size(strctCurrentTrial.m_Image,1)], strctCurrentTrial.m_strctFixation.m_pt2fPosition);

if strcmp(class(strctCurrentTrial.m_Image),'uint8')
    g_strctParadigm.m_ahPTBHandles(1) = Screen('MakeTexture', g_strctPTB.m_hWindow,  strctCurrentTrial.m_Image);
else
    g_strctParadigm.m_ahPTBHandles(1) = Screen('MakeTexture', g_strctPTB.m_hWindow,  strctCurrentTrial.m_Image*255);
end


for k=1:iNumChoices
    strctChoice = strctCurrentTrial.m_astrctRelevantChoices(k);
    g_strctParadigm.m_a2iStimulusRect(k+1,:) = fnComputeStimulusRect(strctCurrentTrial.m_fChoicesHalfSizePix, ...
        [size(strctChoice.m_Image,2), size(strctChoice.m_Image,1)], strctCurrentTrial.m_strctFixation.m_pt2fPosition + strctChoice.m_pt2fRelativePos);

    if strcmp(class(strctChoice.m_Image),'uint8')
        g_strctParadigm.m_ahPTBHandles(k+1)  = Screen('MakeTexture', g_strctPTB.m_hWindow,  strctChoice.m_Image);
    else
        g_strctParadigm.m_ahPTBHandles(k+1)  = Screen('MakeTexture', g_strctPTB.m_hWindow,  strctChoice.m_Image*255);
    end
end

fAlpha = strctCurrentTrial.m_fNoiseLevel/100;
warning off
a3iNoiseMask = uint8(min(255,max(0,strctCurrentTrial.m_a2fNoise * 128/3.9 + 128)));
a3iNoiseMask(:,:,2) = round(fAlpha * 255);
warning on
g_strctParadigm.m_hNoiseHandle = Screen('MakeTexture', g_strctPTB.m_hWindow,  a3iNoiseMask);


return;

function [bGiveJuice, bJuiceDropMultiplier, fJuiceTimeMultiplier] = fnDetermineJuiceReward()
global g_strctParadigm
if g_strctParadigm.m_bDebugModeEnabled
    dbstop if warning
    ShowCursor();
    warning('stop')
end
%dbstop if warning
%warning('stop')
if ~isfield(g_strctParadigm.m_strctCurrentTrial,'m_iCurrentlySelectedChoiceID') || isempty(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceID)
bGiveJuice = 0;
bJuiceDropMultiplier= 0;
fJuiceTimeMultiplier = 0;
return;
end
g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_strChosenSaturation = ...
				g_strctParadigm.m_strctCurrentTrial.m_strActiveChoiceSaturations{g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2)};

g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_strctChosenSaturation = ...
	g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_acActiveChoiceSaturations{g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2)};

g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_afChosenCartColorCoordinates = ...
	g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_acActiveChoiceSaturations{g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2)}.m_afCartCoordinates(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingColorID,:);

g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_afChosenSphColorCoordinates = ...
	g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_acActiveChoiceSaturations{g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoice(2)}.m_afSphereCoordinates(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingColorID,:);

%strctCurrentTrial = g_strctParadigm.m_strctCurrentTrial;


if g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_bBinaryReward
    if strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'disc') ...
            || strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'annuli') ...
            || strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'nestedannuli')
		if g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.m_bIsDirectMatchTrial % if trial is a direct match, keep old reward structure

			if any(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingSaturationID == ...
					g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCueHandleIndexingSaturationID) && ...
					any(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceHandleIndexingColorID == ...
					g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iCueHandleIndexingColorID)
				bGiveJuice = true;
				bJuiceDropMultiplier = 1;
				fJuiceTimeMultiplier = 1;
			else
				bGiveJuice = false;
				bJuiceDropMultiplier = 0;
				fJuiceTimeMultiplier =0;
			end
			%strctCurrentTrial.m_aiInsideChoiceRects
			% Null trial case. Do we reward null trials? If so, check the rho to
			% make sure its in the null trial zone, and set reward
		else % if direct match is not guaranteed, reward randomly based on probe trial reward probability
% 			dbstop if warning
% 				warning('stop')
%				ShowCursor
			if rand() < (g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_fProbeTrialRewardProbability/100)
				bGiveJuice = true;
				bJuiceDropMultiplier = 1;
				fJuiceTimeMultiplier = 1;
			else
				bGiveJuice = false;
				bJuiceDropMultiplier = 0;
				fJuiceTimeMultiplier =0;
			end

			% old code - reward for closest colorimetric option
			%{
			if any(g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_aiAcceptableChoiceID == g_strctParadigm.m_strctCurrentTrial.m_aiActiveChoiceColorID(g_strctParadigm.m_strctCurrentTrial.m_iCurrentlySelectedChoiceColor))
				bGiveJuice = true;
				bJuiceDropMultiplier = 1;
				fJuiceTimeMultiplier = 1;
			else
				bGiveJuice = false;
				bJuiceDropMultiplier = 0;
				fJuiceTimeMultiplier =0;
			end
			%}
		end
    elseif  strcmpi(g_strctParadigm.m_strctChoiceVars.m_strChoiceDisplayType, 'ring')
        if strcmp(g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_strRewardSaturationName, 'null') && g_strctParadigm.m_bRewardCorrectNullTrials && ...
                (g_strctParadigm.m_strctCurrentTrial.m_fchoiceDirectionRho > g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_aiRhoRange(1)) && ...
                (g_strctParadigm.m_strctCurrentTrial.m_fchoiceDirectionRho < g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_aiRhoRange(2))
            bGiveJuice = true;
            bJuiceDropMultiplier = 1;
            fJuiceTimeMultiplier = 1;
        else
            % only cue color and saturation are rewarded




            if (g_strctParadigm.m_strctCurrentTrial.m_fChoiceDirectionTheta < (g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_afRingTheta + g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_fChoiceThetaTolerance)) && ...
                    (g_strctParadigm.m_strctCurrentTrial.m_fChoiceDirectionTheta > (g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_afRingTheta - g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_fChoiceThetaTolerance)) && ...
                    (g_strctParadigm.m_strctCurrentTrial.m_fchoiceDirectionRho > g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_aiRhoRange(1)) && ...
                    (g_strctParadigm.m_strctCurrentTrial.m_fchoiceDirectionRho < g_strctParadigm.m_strctCurrentTrial.m_strctReward.m_aiRhoRange(2))
                bGiveJuice = true;
                bJuiceDropMultiplier = 1;
                fJuiceTimeMultiplier = 1;

                %g_strctParadigm.m_strctCurrentTrial.m_strctCuePeriod.m_iSelectedColorID
                %g_strctParadigm.m_strctCurrentTrial.m_strctReward
            else
                bGiveJuice = false;
                bJuiceDropMultiplier = 0;
                fJuiceTimeMultiplier = 0;
            end
        end
    end

else
    % animal can be rewarded for wrong answers within a certain range of
    % the correct answer

end
return;

function [rewardAdjust] = fnAdjustJuiceReward()
global g_strctParadigm





%% bias adjusted juice reward calculations

% positively adjusts non-biased direction and negatively adjusts positively biased directions
% adjusts based on direction from fixation point





[choiceDirection, choiceDirectionOpposite] = fnCalculateAnswerDirection();

if g_strctParadigm.m_strctStatistics.m_strctAllDesigns.m_iNumTrials >= g_strctParadigm.m_strctTrainingVars.m_iMinimumTrialsBeforeBalance

    if 5 > abs((g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias(choiceDirection) - (g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias(choiceDirectionOpposite))))
        rewardAdjust = 1 / (g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias(choiceDirection) / ...
            (g_strctParadigm.m_strctStatistics.m_aiAnswerDirectionBias(choiceDirectionOpposite)));
    else
        rewardAdjust = 1;

    end


    if rewardAdjust == 0 || isnan(rewardAdjust) || rewardAdjust <= .8
        rewardAdjust = .7;
    elseif isinf(rewardAdjust) || rewardAdjust >= 1.2
        rewardAdjust = 1.3;
    end
else
    rewardAdjust = 1;

end

return;
