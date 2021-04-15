%Loads Kofiko and Plexon data from an experiment and merges them based on
% the strobe words '32757' for 'Sync'

%%debug code
filenameK = '150629_165118_Debug'; % change to be gui prompt or function call
filenameP = '140403_123150_Pollux'; % change to be gui prompt or function call
%%end debug code

syncStrobe=32757;
eventChannelNumber = 257;
channel = 1;
unit = 1;%input('unit to analyze? '); % use default 1

%% Load all variables
% Kofiko data
load([filenameK '.mat'],'g_strctLocalExperimentRecording','g_strctDAQParams');
exptDataK = g_strctLocalExperimentRecording;
exptDataK(cellfun('isempty',exptDataK)) = []; exptDataK(:,2)=exptDataK(:,1);
for i=1:size(exptDataK,1)
    exptDataK{i,1} = exptDataK{i,2}.m_fImageFlipON_TS_Kofiko;
end
strobeDataK = horzcat(g_strctDAQParams.LastStrobe.TimeStamp',g_strctDAQParams.LastStrobe.Buffer);
syncStrobeIdxK = strobeDataK(:,2)==syncStrobe;
initTimeK=strobeDataK(find(syncStrobeIdxK==1,1),1);

% Plexon data
[spikes.count, spikes.numWaves, spikes.timeStamps, spikes.Waves] = plx_waves_v([filenameP '.plx'], channel, unit);
[events.count, events.timeStamps, events.strobeNumber] = plx_event_ts([filenameP '.plx'], eventChannelNumber);
for i=1:size(spikes.timeStamps,1)
    exptDataP(i,1) = {spikes.timeStamps(i)};
    exptDataP(i,2) = {spikes.Waves(i,:)};
end
strobeDataP=horzcat(events.timeStamps,events.strobeNumber);
syncStrobeIdxP = strobeDataP(:,2)==syncStrobe;
initTimeP=strobeDataP(find(syncStrobeIdxP==1,1),1);


%% Collate events and strobe words into time series
exptDataK=vertcat(exptDataK,num2cell(strobeDataK));
[~,ix]=sort(cell2mat(exptDataK(:,1)));
exptDataK=exptDataK(ix,:);
exptDataK(:,1)=num2cell(cell2mat(exptDataK(:,1))-initTimeK); % normalize timestamps to first 'Sync' strobe

exptDataP = vertcat(exptDataP,num2cell(strobeDataP));
[~,ix] = sort(cell2mat(exptDataP(:,1)));
exptDataP = exptDataP(ix,:);
exptDataP(:,1) = num2cell(cell2mat(exptDataP(:,1))-initTimeP); % normalize timestamps to first 'Sync' strobe

%% Merge Kofiko and Plexon data based on Kofiko 'Sync' strobes
syncStrobeIdxK=[];
for i = 1:length(exptDataK)
    if isnumeric(exptDataK{i,2}) && exptDataK{i,2}==syncStrobe
        syncStrobeIdxK(end+1,1)=i;
    end
end
syncStrobeIdxP=[];
for i = 1:length(exptDataP)
    if isnumeric(exptDataP{i,2}) && size(exptDataP{i,2},2)==1 && exptDataP{i,2}==syncStrobe
        syncStrobeIdxP(end+1,1)=i;
    end
end

exptData=vertcat(exptDataK(1:syncStrobeIdxK(1)-1,:),exptDataP(1:syncStrobeIdxP(1)-1,:));
[~,ix]=sort(cell2mat(exptData(:,1)));
exptData=exptData(ix,:);
for i = 1:min(length(syncStrobeIdxK),length(syncStrobeIdxP))-1
    tmpK=exptDataK(syncStrobeIdxK(i):syncStrobeIdxK(i+1)-1,:);
    tmpP=exptDataP(syncStrobeIdxP(i):syncStrobeIdxP(i+1)-1,:);
    offset=tmpP{1,1}-tmpK{1,1};
    tmpP(:,1) = num2cell(cell2mat(tmpP(:,1))-offset);
    tmp=vertcat(tmpK,tmpP(2:end,:));
    [~,ix]=sort(cell2mat(tmp(:,1)));
    tmp=tmp(ix,:);
    exptData=vertcat(exptData,tmp);
end

%% Create PSTHs
% Set window size for stim-response pairing
eventWindowPre =  50/1000;
eventWindowDur = 200/1000;
eventWindowPost = 200/1000;
spikeWindowSize = 32;
orientations = 18;
spikes = zeros(orientations,2); spikes(:,1) = [0:orientations-1]';

% Counts spikes
%  Run through all data, can be modded to take in piecemeal data for online
%  version (process windows of data instead of looping through it)
%  Replace startIdx and endIdx with the start and end of each window vector
%  Window timestamps should be a double vector so no need for converting to
%  one from the offline cell array of timestamps.
for i=1:size(exptData,1)
    if isstruct(exptData{i,2})
        if i>10, startIdx=i-10; else startIdx=1; end
        if i+60<=size(exptData,1), endIdx=i+60; else endIdx=size(exptData,1); end
        tsAlign=exptData{i,1};
        rotAngle=exptData{i,2}.m_fRotationAngle+1;
        eventWindowTS=cell2mat(exptData(startIdx:endIdx,1));
        eventWindow=exptData(startIdx:endIdx,2);
        eventWindowStart=tsAlign-eventWindowPre;
        eventWindowEnd=tsAlign+eventWindowDur+eventWindowPost;
        eventWindowIdx=logical((eventWindowTS>eventWindowStart).*(eventWindowTS<eventWindowEnd));
        spikes(rotAngle,2)=spikes(rotAngle,2)+sum(cell2mat(cellfun(@(x) length(x)==spikeWindowSize,eventWindow(eventWindowIdx),'UniformOutput',false)));
    end
end

