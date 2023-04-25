%%
clear all

%% Extract And Align kofiko and Plexon data

filenameP = '230331_144125_Jacomo'; % this is the label

useofflinesorting = 0; % 0 for Plexon sorting, 1 for Kilosort
skipLFP=1; % do we want to load the LFPs as well, or skip and jsut use spikes
    LFPchans=[1:24];
    % for Jocamo, this was LFPchans=[1:24, 33,40,46,47,52,53,54,59,65,67,71,81,83,89,90,95,98,102,103,109,112,131,138,139,145,146,152,158, 161:256];
nChans=24; % number of channels in your recording - likely 24 if using Laminar probes

target_trialtype='Fivedot'; % is there a specifictype of trial you want to extract? if not, leave empty

TrialWindow = [-.050, 4.5]; %this is the window (in seconds) around each trial that we'll align eyetracker and plexon data to

ExperimentFolder = 'X:\users\bartschf2\'; %this is your base data directory
plxFilePath = ['D:\PlexonData\' filenameP '.pl2']; %this is the path to your plexon recording file
matFilePath = [ExperimentFolder filenameP '\'];  % this is the folder containing all the Kofiko savepoints (should be a bunch of .mat files with the experiment name and numbers, e.g. 220201_123456_Jocamo_1.mat
configFilePath = [ExperimentFolder filenameP '.mat']; % this is the path to the .mat file containing Kofiko's data
strExperimentPath = [matFilePath 'Analysis\']; % this is where your analysis data goes


% KSstitched=0; ksFilePath = ['/media/felix/Internal_1/Data/BevilColor/' filenameP '/kilosorting_laminar/']; arraylabel ='laminar';
KSstitched=1; ksFilePath = [ExperimentFolder filenameP '/kilosorting_stitch/']; arraylabel ='full';

strExperimentPath = [matFilePath '/Analysis/'];
if ~exist(strExperimentPath,'dir');
    mkdir(strExperimentPath);
end

%% load basic variables
global unitsInFile g_strctStatistics ExperimentRecording topLevelIndex 

experimentIndex = {};
g_strctStatistics.preTrialWindow = TrialWindow(1);
g_strctStatistics.postTrialWindow = TrialWindow(2);

filenameK = matFilePath;
load(configFilePath)

currentDirectory = pwd;
cd(ExperimentFolder);

allMatFiles = dir('*.mat');
[~, indices] = sort(vertcat(allMatFiles(:).datenum));
allMatFiles = allMatFiles(indices);
allPLXfiles = dir([pwd,filesep, '*.plx']);

syncStrobeID = 32757;
eventChannelNumber = 257;
startRecordID = 32767;
stopRecordID = 32766;

%%
if useofflinesorting==1

    if KSstitched==1
        load([ksFilePath 'KS_stitched.mat'])
    else
        spk_times = readNPY([ksFilePath 'spike_times_seconds.npy']);
        spk_clusters = readNPY([ksFilePath 'spike_clusters.npy']);
        spk_info = tdfread([ksFilePath 'cluster_info.tsv']);
    end
   spk_clustIDs = unique(spk_clusters); nclusts=length(spk_clustIDs);
%        spk_clustIDs = spk_info.cluster_id; nclusts=length(spk_clustIDs);
    
    spk_labels_SU=[]; spk_labels_MU=[];
    for cc=1:nclusts
        if strcmp(deblank(spk_info.group(cc,:)), 'good')
            spk_labels_SU = [spk_labels_SU,cc];
        elseif strcmp(spk_info.group(cc,:), 'noise')
            % % do nothing about noise
        else
             spk_labels_MU = [spk_labels_MU,cc];
        end
    end
    bad_chans_SU = find(spk_info.n_spikes(spk_labels_SU)<2000); spk_labels_SU(bad_chans_SU)=[];
    bad_chans_MU = find(spk_info.n_spikes(spk_labels_MU)<2000); spk_labels_MU(bad_chans_MU)=[];
    spk_ID_SU = (spk_clustIDs(spk_labels_SU));
    try
        spk_rating_SU = (spk_info.Rating(spk_labels_SU));
        spk_rating_MU = (spk_info.Rating(spk_labels_MU));
    catch
        spk_rating_SU = (spk_info.rating(spk_labels_SU));
        spk_rating_MU = (spk_info.rating(spk_labels_MU));
    end
    spk_channels_SU = spk_info.ch(spk_labels_SU);
    spk_ID_MU = (spk_clustIDs(spk_labels_MU));
    spk_channels_MU = spk_info.ch(spk_labels_MU);
    nSU=length(spk_ID_SU);
    nMU=length(spk_ID_MU);
end
%% collect and align all the Kofiko parameter files that are saved periodically
allMatFiles = dir([filenameK, '*.mat']);
[~, indices] = sort(vertcat(allMatFiles(:).datenum));
allMatFiles = allMatFiles(indices);
g_strctStatistics.ExperimentRecording = {};
for iFiles = 1:size(allMatFiles,1)
    if allMatFiles(iFiles).isdir
        continue
    end
    load([matFilePath,filesep,allMatFiles(iFiles).name])
    disp(sprintf('loading experiment file %s', allMatFiles(iFiles).name));
    if exist('g_strctLocalExperimentRecording') && size(g_strctLocalExperimentRecording{1},1) > 1
       warning('incorrect format detected in save structure in file  %s, skipping', allMatFiles(iFiles).name)
        %tmp = g_strctLocalExperimentRecording{1};
        continue
    end

    g_strctStatistics.ExperimentRecording(cellfun('isempty',g_strctStatistics.ExperimentRecording)) = [];
    if (exist('g_strctLocalExperimentRecording') == 1)
        disp('case 1')
        g_strctStatistics.ExperimentRecording = vertcat(g_strctStatistics.ExperimentRecording,vertcat({g_strctLocalExperimentRecording{find(~cellfun(@isempty,g_strctLocalExperimentRecording))}})');
       clear g_strctLocalExperimentRecording
    elseif (exist('strctLocalExperimentRecording') == 1)
        disp('case 2')
        g_strctStatistics.ExperimentRecording = vertcat(g_strctStatistics.ExperimentRecording,vertcat({strctLocalExperimentRecording{find(~cellfun(@isempty,strctLocalExperimentRecording))}})');
        clear('strctLocalExperimentRecording')
    else
        disp('case 3')
        try
        g_strctStatistics.ExperimentRecording = vertcat(g_strctStatistics.ExperimentRecording,vertcat({dataToSave{find(~cellfun(@isempty,dataToSave))}})');
        catch
           warning(sprintf('file %s did not contain appropriately formatted trials', allMatFiles(iFiles).name)); 
        end
    end
end
ExperimentRecording = g_strctStatistics.ExperimentRecording;
clear g_strctStatistics.ExperimentRecording;


%% now loading and aligning Plexon and kofiko Sync Strobes

try
    [events.count, events.timeStamps, events.strobeNumber] = plx_event_ts(plxFilePath, eventChannelNumber);
%    [events] = PL2EventTs(plxFilePath, eventChannelNumber);
catch
    [~,sessionName] = fileparts(plxFilePath);
    sprintf('corrupt or missing information from Plexon file, experiment %s', sessionName)
    return;
end
cd(ExperimentFolder);

try
load(filenameK, 'g_strctDAQParams');
catch
    try
        load([ExperimentFolder, filenameP, '.mat'], 'g_strctDAQParams');
    catch
       [~, filename] = fileparts(filenameK); 
       load([filename, '.mat'], 'g_strctDAQParams');
    end
end

firstStrobePlexonTS = events.timeStamps(find(events.strobeNumber(events.strobeNumber == syncStrobeID),1));
plexonStrobeIDX = find(events.strobeNumber == syncStrobeID);
lastStrobePlexonTS = events.timeStamps(find(events.strobeNumber(events.strobeNumber == syncStrobeID),1,'last'));
plexonStrobeAllTS = events.timeStamps(plexonStrobeIDX);

firstStrobeKofikoTS = g_strctDAQParams.LastStrobe.TimeStamp(find(g_strctDAQParams.LastStrobe.Buffer == syncStrobeID, 1,'first'));
lastStrobeKofikoTS = g_strctDAQParams.LastStrobe.TimeStamp(find(g_strctDAQParams.LastStrobe.Buffer == syncStrobeID, 1,'last'));
kofikoStrobeIDX = find(g_strctDAQParams.LastStrobe.Buffer == syncStrobeID);
kofikoStrobeAllTS = g_strctDAQParams.LastStrobe.TimeStamp(kofikoStrobeIDX);

if numel(kofikoStrobeIDX) ~= numel(plexonStrobeIDX)
    error('strobe ID mismatch, different number of sync timestamps detected')
end

%% now align and test sync strobes
plexonSyncStrobesInThisSessionTS = events.timeStamps;
plexonSyncStrobesInThisSessionStrobeID =   events.strobeNumber;
plexonSyncStrobesInThisSessionTS =  plexonSyncStrobesInThisSessionTS(plexonSyncStrobesInThisSessionStrobeID == syncStrobeID);

kofikoSyncStrobesInThisSessionTS = g_strctDAQParams.LastStrobe.TimeStamp;
kofikoSyncStrobesInThisSessionStrobeID = g_strctDAQParams.LastStrobe.Buffer;
kofikoSyncStrobesInThisSessionTS = kofikoSyncStrobesInThisSessionTS(kofikoSyncStrobesInThisSessionStrobeID == syncStrobeID);
if isempty(kofikoSyncStrobesInThisSessionTS) || isempty(plexonSyncStrobesInThisSessionTS)
    sprintf('could not process recording %s, session %i, timestamp missing.', filenameP, iSessions)
end

%% get data indices for specific recording sessions 
% this is what it means when you hit 'record' in Kofiko

sessionsStartIDX = find(g_strctDAQParams.LastStrobe.Buffer == startRecordID);
sessionStartTS = g_strctDAQParams.LastStrobe.TimeStamp(sessionsStartIDX);% - firstStrobeKofikoTS;

sessionsEndIDX = find(g_strctDAQParams.LastStrobe.Buffer == stopRecordID);
sessionEndTS = g_strctDAQParams.LastStrobe.TimeStamp(sessionsEndIDX);% - firstStrobeKofikoTS;
numSessions = numel(sessionsStartIDX);

sessionStartPlexonIDX = find(events.strobeNumber == startRecordID);
sessionEndPlexonIDX = find(events.strobeNumber == stopRecordID);
sessionsStartPlexonTS = events.timeStamps(sessionStartPlexonIDX);
sessionEndPlexonTS = events.timeStamps(sessionEndPlexonIDX);

%% Extract trial onset times into their own field
for iTrials = 1:size(ExperimentRecording,1)
    ExperimentRecording{iTrials, 2} = ExperimentRecording{iTrials, 1}.m_fImageFlipON_TS_Kofiko;
    trialIter(iTrials) = ExperimentRecording{iTrials, 1}.m_iTrialNumber;
    ExperimentRecording{iTrials, 1}.SessionID = find(ExperimentRecording{iTrials, 2}>sessionStartTS,1,'last');
end
%% if picking a particular subset of trials
if ~isempty(target_trialtype)
    targ_trials=[];
    for tt=1:length(ExperimentRecording)
        if strcmp(ExperimentRecording{tt, 1}.m_strTrialType, target_trialtype);
        targ_trials=[targ_trials,tt];
        end
    end
    ExperimentRecording=ExperimentRecording(targ_trials,:);
end
%% ensure trials are in correct order
ntrials=length(ExperimentRecording);

for tt=1:ntrials; 
    trialstart_raw(tt)=ExperimentRecording{tt, 2}; 
end
[~,order]=sort(trialstart_raw);
ExperimentRecording=ExperimentRecording(order, :);  

%% align spiking data from Plexon file

topLevelIndex = [];
sessionIndex  = [];
sessionTags   = {};

cd ..
allPLXfiles = vertcat(dir([pwd,filesep, '*.plx']),dir([pwd,filesep, '*.pl2']));

thisSessionFile = plxFilePath;
if ~exist(plxFilePath) && isempty(allPLXfiles) && ~any(~arrayfun(@isempty,strfind({allPLXfiles(:).name}, [filenameP,'.plx']))) && ~any(~arrayfun(@isempty,strfind({allPLXfiles(:).name}, [filenameP,'.pl2'])))
    warning('could not find PLX file for this experiment')
end

cd(ExperimentFolder)
[~,~,experimentFileExtension] = fileparts(thisSessionFile);
if ~strcmp(experimentFileExtension,'.plx') && ~strcmp(experimentFileExtension,'.pl2')
    thisSessionFile = [thisSessionFile, '.plx'];
end

numUnitsInSession = 0; unitsInFile = [];
[tscounts, wfcounts, evcounts, contcounts] = plx_info([thisSessionFile], false);
    numUnits = find(sum(wfcounts,2));
    allNumUnits=[];
    topLevelIndex.m_iNumNeuronUnits = numUnits;
    
for channel=1:nChans
    numUnitsInSession = 0;
    for iUnit = 1:numel(numUnits)
        nameOfUnit = ['unit',num2str(numUnits(iUnit))];
        tempTS = 0;
        try
        [~, ~, tempTS, ~] = plx_waves_v([thisSessionFile], channel, iUnit);
%       [~, ~, tempTS, ~] = PL2Waves([thisSessionFile], channel, iUnit); % alternative way
        catch
            fprintf('big oof - couldnt read plexon waves \n')
        end
        if tempTS > 0
            numUnitsInSession = numUnitsInSession + 1
            unitsInFile = [unitsInFile, iUnit];
        [spikes(channel).(nameOfUnit).count, spikes(channel).(nameOfUnit).numWaves, spikes(channel).(nameOfUnit).timeStamps, spikes(channel).(nameOfUnit).Waves] = ...
                                                                        plx_waves_v([thisSessionFile], channel, iUnit);
%                 [spikes.(nameOfUnit).count, spikes.(nameOfUnit).numWaves, spikes.(nameOfUnit).timeStamps, spikes.(nameOfUnit).Waves] = ...
%                                                                                 PL2Waves([thisSessionFile], channel, iUnit); % alternative way
        end
    end
    allNumUnits=[allNumUnits,numUnitsInSession];
end
numUnitsInSession=max(allNumUnits);


%% get ET data from Kofiko
% Note that this does not align dDPI data here, nor does it use the
% higher-time resolution information from Plexon ET traces. Those are
% separate alignment processes.

load([ExperimentFolder, filenameP, '.mat'], 'g_strctEyeCalib');
load([ExperimentFolder, filenameP, '.mat'], 'g_strctStimulusServer');

ET_ad = g_strctEyeCalib.EyeRaw.Buffer(:,1:2)';
ET_times = g_strctEyeCalib.EyeRaw.TimeStamp;
%%
Recalibs=unique(round([g_strctEyeCalib.CenterX.TimeStamp, g_strctEyeCalib.CenterY.TimeStamp, g_strctEyeCalib.GainX.TimeStamp, g_strctEyeCalib.GainY.TimeStamp]));
Recalibs=[Recalibs, ET_times(end)];
for rr=1:length(Recalibs)-1
    eyeCenterXID = find(Recalibs(rr) > g_strctEyeCalib.CenterX.TimeStamp,1,'last'); if isempty(eyeCenterXID); eyeCenterXID=1;end
    eyeCenterYID = find(Recalibs(rr) > g_strctEyeCalib.CenterY.TimeStamp,1,'last'); if isempty(eyeCenterYID);eyeCenterYID=1;end
    eyeGainXID = find(Recalibs(rr) > g_strctEyeCalib.GainX.TimeStamp,1,'last'); if isempty(eyeGainXID);eyeGainXID=1;end
    eyeGainYID = find(Recalibs(rr) > g_strctEyeCalib.GainY.TimeStamp,1,'last'); if isempty(eyeGainYID);eyeGainYID=1;end

    CalibEyeBufferIDX = find(g_strctEyeCalib.EyeRaw.TimeStamp > Recalibs(rr) & ...
        g_strctEyeCalib.EyeRaw.TimeStamp < Recalibs(rr+1));

    ET_ad(1,CalibEyeBufferIDX) = (ET_ad(1,CalibEyeBufferIDX) - g_strctEyeCalib.CenterX.Buffer(eyeCenterXID)) * g_strctEyeCalib.GainX.Buffer(eyeGainXID);% + (g_strctStimulusServer.m_aiScreenSize(3)/2)-ExperimentRecording{1, 1}.m_pt2iFixationSpot(1);
    ET_ad(2,CalibEyeBufferIDX) = (ET_ad(2,CalibEyeBufferIDX) - g_strctEyeCalib.CenterY.Buffer(eyeCenterYID)) * g_strctEyeCalib.GainY.Buffer(eyeGainYID);% + (g_strctStimulusServer.m_aiScreenSize(4)/2)-ExperimentRecording{1, 1}.m_pt2iFixationSpot(2);
end

%%
LFPcc=1;
if ~skipLFP
    for chan=LFPchans
        [LFP_adfreq, LFP_n, LFP_ts, LFP_fn, LFP_ad(:,LFPcc)] = plx_ad_v(thisSessionFile, ['FP' num2str(chan,'%03.f')]);
        LFPcc=LFPcc+1;
    end
    LFP_ad=LFP_ad';
    LFP_times=[1:LFP_n]/LFP_adfreq;
end
%% previous location of reading in kilosort outputs
%%
exptDataP = []; exptDataP2=[]; exptDataMUA=[];

if useofflinesorting==1
    for iUnit=1:length(spk_labels_SU)
        exptDataP(iUnit).spkID = double(spk_ID_SU(iUnit));
        exptDataP(iUnit).spkCh = spk_channels_SU(iUnit);
        exptDataP(iUnit).rating = spk_rating_SU(iUnit);
        exptDataP(iUnit).unit1 = spk_times(find(spk_clusters==spk_ID_SU(iUnit)));
    end

    for iUnit=1:length(spk_labels_MU)
        exptDataMUA(iUnit).spkID = double(spk_ID_MU(iUnit));
        exptDataMUA(iUnit).spkCh = spk_channels_MU(iUnit);
        exptDataMUA(iUnit).rating = spk_rating_MU(iUnit);
        exptDataMUA(iUnit).unit1 = spk_times(find(spk_clusters==spk_ID_MU(iUnit)));
    end

else
    for channel=1:nChans    
        for iUnit = 1:allNumUnits(channel)
            nameOfUnit = ['unit',num2str(iUnit)];
            if useofflinesorting==1
                %{
                exptDataP(channel).(nameOfUnit) = Clusters{channel}.times(find(Clusters{channel}.spike_clusts==iUnit+1));
                %exptDataP(channel).(nameOfUnit) = allchan_spktimes{1,channel};
                %exptDataMUA(channel).(nameOfUnit) = allchan_spktimes{2,channel};
                %}
            else
                try
                exptDataP(channel).(nameOfUnit) = spikes(channel).(nameOfUnit).timeStamps;
                catch
                exptDataP(channel).(nameOfUnit) = 0;   
                end
            end
        end

    end

end
iSessions = 1;%
allStartTS = [ExperimentRecording{:,2}];

%%
thisExptEyeRaw=g_strctEyeCalib.EyeRaw.Buffer;
thisExptEyeTimes=g_strctEyeCalib.EyeRaw.TimeStamp;
N_recalibs=g_strctEyeCalib.CenterX.TimeStamp;

trialIter = 1;
for iFixationCheck = 1:ntrials;
    if isfield(ExperimentRecording{iFixationCheck, 1},'m_bMonkeyFixated') && ExperimentRecording{iFixationCheck, 1}.m_bMonkeyFixated
        ExperimentRecording{iFixationCheck,7} = 1;
        sessionIndex(trialIter).m_bFixated = 1;
        sessionIndex(trialIter).m_afEyeXPositionScreenCoordinates = [];
        % append eye trace information to this trial
        thisTrialFlipon = ExperimentRecording{iFixationCheck,2} ;
            eyeCenterXID = find(thisTrialFlipon > g_strctEyeCalib.CenterX.TimeStamp,1,'last'); if isempty(eyeCenterXID); eyeCenterXID=1;end
            eyeCenterYID = find(thisTrialFlipon > g_strctEyeCalib.CenterY.TimeStamp,1,'last'); if isempty(eyeCenterYID);eyeCenterYID=1;end
            eyeGainXID = find(thisTrialFlipon > g_strctEyeCalib.GainX.TimeStamp,1,'last'); if isempty(eyeGainXID);eyeGainXID=1;end
            eyeGainYID = find(thisTrialFlipon > g_strctEyeCalib.GainY.TimeStamp,1,'last'); if isempty(eyeGainYID);eyeGainYID=1;end
            
            thisTrialEyeBufferIDX = find(g_strctEyeCalib.EyeRaw.TimeStamp > thisTrialFlipon + g_strctStatistics.m_strctEyeData.m_fEyeIntegrationPeriod(1) & ...
                g_strctEyeCalib.EyeRaw.TimeStamp < thisTrialFlipon + g_strctStatistics.m_strctEyeData.m_fEyeIntegrationPeriod(2) );
            
            thisTrialRawEyeData = g_strctEyeCalib.EyeRaw.Buffer(thisTrialEyeBufferIDX,:);
            thisTrialRawEyeDatatimes = g_strctEyeCalib.EyeRaw.TimeStamp(1,thisTrialEyeBufferIDX);
           
            fEyeXPix = (thisTrialRawEyeData(:, 1) - g_strctEyeCalib.CenterX.Buffer(eyeCenterXID)) * g_strctEyeCalib.GainX.Buffer(eyeGainXID) + (g_strctStimulusServer.m_aiScreenSize(3)/2);
            fEyeYPix = (thisTrialRawEyeData(:, 2) - g_strctEyeCalib.CenterY.Buffer(eyeCenterYID)) * g_strctEyeCalib.GainY.Buffer(eyeGainYID) + (g_strctStimulusServer.m_aiScreenSize(4)/2);
            ExperimentRecording{(iFixationCheck),1}.m_afEyeXPositionScreenCoordinates = fEyeXPix;
            ExperimentRecording{(iFixationCheck),1}.m_afEyeYPositionScreenCoordinates = fEyeYPix;
            ExperimentRecording{iFixationCheck,1}.m_afEyePositiontimes = thisTrialRawEyeDatatimes;
        ExperimentRecording{iFixationCheck,1}.ETthisTrialRawEyeData = thisTrialRawEyeData;
        ExperimentRecording{iFixationCheck,1}.ETCenter = [g_strctEyeCalib.CenterX.Buffer(eyeCenterXID),g_strctEyeCalib.CenterY.Buffer(eyeCenterYID)];
        ExperimentRecording{iFixationCheck,1}.ScreenCenter = [(g_strctStimulusServer.m_aiScreenSize(3)/2),(g_strctStimulusServer.m_aiScreenSize(4)/2)];
            sessionIndex(trialIter).m_afEyeXPositionScreenCoordinates = fEyeXPix;
            sessionIndex(trialIter).m_afEyeYPositionScreenCoordinates = fEyeYPix;
    elseif ~isfield(ExperimentRecording{(iFixationCheck), 1},'m_bMonkeyFixated') || ~ExperimentRecording{(iFixationCheck), 1}.m_bMonkeyFixated
        ExperimentRecording{(iFixationCheck),7} = 0;
        sessionIndex(trialIter).m_bFixated = 0;
        sessionIndex(trialIter).m_afEyeXPositionScreenCoordinates = [];        % append eye trace information to this trial
        thisTrialFlipon = ExperimentRecording{(iFixationCheck),2} ;
        eyeCenterXID = find(thisTrialFlipon > g_strctEyeCalib.CenterX.TimeStamp,1,'last'); if isempty(eyeCenterXID); eyeCenterXID=1;end
        eyeCenterYID = find(thisTrialFlipon > g_strctEyeCalib.CenterY.TimeStamp,1,'last'); if isempty(eyeCenterYID);eyeCenterYID=1;end
        eyeGainXID = find(thisTrialFlipon > g_strctEyeCalib.GainX.TimeStamp,1,'last'); if isempty(eyeGainXID);eyeGainXID=1;end
        eyeGainYID = find(thisTrialFlipon > g_strctEyeCalib.GainY.TimeStamp,1,'last'); if isempty(eyeGainYID);eyeGainYID=1;end

        thisTrialEyeBufferIDX = g_strctEyeCalib.EyeRaw.TimeStamp > thisTrialFlipon + g_strctStatistics.m_strctEyeData.m_fEyeIntegrationPeriod(1) & ...
            g_strctEyeCalib.EyeRaw.TimeStamp < thisTrialFlipon + g_strctStatistics.m_strctEyeData.m_fEyeIntegrationPeriod(2) ;

        thisTrialRawEyeData = g_strctEyeCalib.EyeRaw.Buffer(thisTrialEyeBufferIDX,:);
        thisTrialRawEyeDatatimes = g_strctEyeCalib.EyeRaw.TimeStamp(1,thisTrialEyeBufferIDX);

        fEyeXPix = (thisTrialRawEyeData(:, 1) - g_strctEyeCalib.CenterX.Buffer(eyeCenterXID)) * g_strctEyeCalib.GainX.Buffer(eyeGainXID) + (g_strctStimulusServer.m_aiScreenSize(3)/2);
        fEyeYPix = (thisTrialRawEyeData(:, 2) - g_strctEyeCalib.CenterY.Buffer(eyeCenterYID)) * g_strctEyeCalib.GainY.Buffer(eyeGainYID) + (g_strctStimulusServer.m_aiScreenSize(4)/2);
        ExperimentRecording{iFixationCheck,1}.m_afEyeXPositionScreenCoordinates = fEyeXPix;
        ExperimentRecording{iFixationCheck,1}.m_afEyeYPositionScreenCoordinates = fEyeYPix;
        ExperimentRecording{iFixationCheck,1}.m_afEyePositiontimes = thisTrialRawEyeDatatimes;
        ExperimentRecording{iFixationCheck,1}.ETthisTrialRawEyeData = thisTrialRawEyeData;
        ExperimentRecording{iFixationCheck,1}.ETCenter = [g_strctEyeCalib.CenterX.Buffer(eyeCenterXID),g_strctEyeCalib.CenterY.Buffer(eyeCenterYID)];
        ExperimentRecording{iFixationCheck,1}.ScreenCenter = [(g_strctStimulusServer.m_aiScreenSize(3)/2),(g_strctStimulusServer.m_aiScreenSize(4)/2)];
        sessionIndex(trialIter).m_afEyeXPositionScreenCoordinates = fEyeXPix;
        sessionIndex(trialIter).m_afEyeYPositionScreenCoordinates = fEyeYPix;

    else
        spintf('big oof: no ET data')
    end
    trialIter = trialIter + 1;

end

%% Now we go through the main data alignment loop for each trial

trialIter = 1;
disp(['found ' num2str(ntrials) ' trials'])
for iTrials = 1:ntrials;

    spikesInThisTrial = [];
    sessionIndex(trialIter).m_iGlobalTrialIndex = iTrials;
    [~,trialSyncStrobeID] = min(abs(ExperimentRecording{iTrials, 2} - kofikoSyncStrobesInThisSessionTS));

    if trialSyncStrobeID>length(kofikoSyncStrobesInThisSessionTS)
        error(['Error with sync strobes? off by ' num2str(trialSyncStrobeID-length(kofikoSyncStrobesInThisSessionTS))]);
    end
    if trialSyncStrobeID>length(plexonSyncStrobesInThisSessionTS)
        error(['Error with sync strobes? off by ' num2str(trialSyncStrobeID-length(plexonSyncStrobesInThisSessionTS))]);
    end
    
    kofikoSyncTime = kofikoSyncStrobesInThisSessionTS(trialSyncStrobeID);
    plexonSyncTime = plexonSyncStrobesInThisSessionTS(trialSyncStrobeID);
    
    % these are just saved for debugging purpsoes if something seems off later
    ExperimentRecording{iTrials,1}.kofikoSyncTime = kofikoSyncTime; 
    ExperimentRecording{iTrials,1}.PlexonSyncTime = plexonSyncTime;
    ExperimentRecording{iTrials,1}.PlexonOnsetTime = plexonSyncTime + (ExperimentRecording{iTrials, 2} - kofikoSyncTime);
    
    % Plexon onset times gives the Plexon timestamps for each trial onset -
    % important for NWB processing
    ExperimentRecording{iTrials, 3} = ExperimentRecording{iTrials,1}.PlexonOnsetTime;
    ExperimentRecording{iTrials, 4} = ExperimentRecording{iTrials, 1}.m_strTrialType;

    sessionIndex(trialIter).m_aiStimulusColor = ExperimentRecording{iTrials, 1}.m_aiStimColor;
    sessionIndex(trialIter).m_strTrialType = ExperimentRecording{iTrials, 1}.m_strTrialType;

    if useofflinesorting==1
        for iUnit=1:nSU
            plexonDataAlignedToThisTrial = [];         
            plexonDataAlignedToThisTrial =  exptDataP(iUnit).unit1 - plexonSyncTime;
            spikesInThisTrial.unit1 = plexonDataAlignedToThisTrial(plexonDataAlignedToThisTrial - ...
                (ExperimentRecording{iTrials, 2} - kofikoSyncTime) >= g_strctStatistics.preTrialWindow & ...
                plexonDataAlignedToThisTrial - (ExperimentRecording{iTrials, 2} - kofikoSyncTime) <=  g_strctStatistics.postTrialWindow) ...
                - (ExperimentRecording{iTrials, 2} - kofikoSyncTime);
            spikesInThisTrial.spkID = exptDataP(iUnit).spkID;
            spikesInThisTrial.rating = exptDataP(iUnit).rating;
            ExperimentRecording{iTrials,10+2*(iUnit-1)} = spikesInThisTrial;
            ExperimentRecording{iTrials,11+2*(iUnit-1)} = length(spikesInThisTrial.unit1);
        end

        for iUnit=1:nMU
            plexonMUADataAlignedToThisTrial=[];
            plexonMUADataAlignedToThisTrial =  exptDataMUA(iUnit).unit1 - plexonSyncTime ;
            MUAspikesInThisTrial.unit1 = plexonMUADataAlignedToThisTrial(plexonMUADataAlignedToThisTrial - ...
                (ExperimentRecording{iTrials, 2} - kofikoSyncTime) >= g_strctStatistics.preTrialWindow & ...
                plexonMUADataAlignedToThisTrial - (ExperimentRecording{iTrials, 2} - kofikoSyncTime) <=  g_strctStatistics.postTrialWindow)...
                - (ExperimentRecording{iTrials, 2} - kofikoSyncTime);

            MUAspikesInThisTrial.spkID = exptDataMUA(iUnit).spkID;
            ExperimentRecording{iTrials,10+2*(iUnit-1+nSU)} = MUAspikesInThisTrial.unit1;
            ExperimentRecording{iTrials,11+2*(iUnit-1+nSU)} = length(MUAspikesInThisTrial.unit1);
        end

    else
        for channel=find(allNumUnits);
            for iUnit = 1:allNumUnits(channel)
                plexonDataAlignedToThisTrial = [];
                nameOfUnit = ['unit',num2str(iUnit)];
                plexonDataAlignedToThisTrial =  exptDataP(channel).(nameOfUnit) - plexonSyncTime ;
                spikesInThisTrial.(nameOfUnit) = plexonDataAlignedToThisTrial(plexonDataAlignedToThisTrial - ...
                    (ExperimentRecording{iTrials, 2} - kofikoSyncTime) >= g_strctStatistics.preTrialWindow & ...
                    plexonDataAlignedToThisTrial - (ExperimentRecording{iTrials, 2} - kofikoSyncTime) <=  g_strctStatistics.postTrialWindow)...
                    - (ExperimentRecording{iTrials, 2} - kofikoSyncTime);;
            end
      
            ExperimentRecording{iTrials,10+2*(channel-1)} = spikesInThisTrial;
            ExperimentRecording{iTrials,11+2*(channel-1)} = length(spikesInThisTrial.unit1);
            sessionIndex(trialIter).m_afSpikesInThisTrial = spikesInThisTrial;
        end
    end
        
    if ~skipLFP
    plexonLFPDataAlignedToThisTrial = LFP_ad(LFPchans, LFP_times - plexonSyncTime - (ExperimentRecording{iTrials, 2} - kofikoSyncTime) >= g_strctStatistics.preTrialWindow & ...
            LFP_times - plexonSyncTime - (ExperimentRecording{iTrials, 2} - kofikoSyncTime) <=  g_strctStatistics.postTrialWindow);
    ExperimentRecording{iTrials,9} = plexonLFPDataAlignedToThisTrial;
    end

% for aligning EMs to Kofiko timestamps
    EMsInThisTrial.saccades =  saccade_times(saccade_times >= ExperimentRecording{iTrials, 2}+g_strctStatistics.preTrialWindow & ...
        saccade_times <= ExperimentRecording{iTrials, 2}+g_strctStatistics.postTrialWindow);
    EMsInThisTrial.saccade_start =  sac_start_times(saccade_times >= ExperimentRecording{iTrials, 2}+g_strctStatistics.preTrialWindow & ...
        sac_start_times <= ExperimentRecording{iTrials, 2}+g_strctStatistics.postTrialWindow);
    EMsInThisTrial.saccade_stop =  sac_stop_times(saccade_times >= ExperimentRecording{iTrials, 2}+g_strctStatistics.preTrialWindow & ...
        sac_stop_times <= ExperimentRecording{iTrials, 2}+g_strctStatistics.postTrialWindow);
    EMsInThisTrial.ET_times =  ET_times(ET_times >= ExperimentRecording{iTrials, 2}+g_strctStatistics.preTrialWindow & ...
        ET_times <= ExperimentRecording{iTrials, 2}+g_strctStatistics.postTrialWindow);
    ExperimentRecording{iTrials,8} = EMsInThisTrial;
 
    trialIter = trialIter + 1;
    
    if mod(iTrials,50)==0
        fprintf('finished trial %d of %d \n',iTrials, ntrials)
    end
    
end 

cd(currentDirectory);
disp('done. saving...')

save([strExperimentPath,filesep,'AlignedExperimentRecording.mat'],'ExperimentRecording','-v7.3')
disp('saved!')

