function fnGetSpikesFromPlexon()
global g_strctPlexon g_strctParadigm g_strctSystemCodes g_strctCycle 

%raw_spikeCounts = PL_GetSpikeCounts(g_strctPlexon.m_iServerID);
%[raw_tsCount, raw_timeStamps] = PL_GetTS(g_strctPlexon.m_iServerID);


% Output:
%   n - 1 by 1 matrix, number of waveforms retrieved
%
%   t - n by 4 matrix, timestamp info:
%       t(:, 1) - timestamp type (1 - neuron, 4 - external event)
%       t(:, 2) - channel numbers
%       t(:, 3) - unit numbers
%       t(:, 4) - timestamps in seconds
%
%   w - n by wf_len matrix of waveforms, where wf_len is the waveform length
%       (in data points)
%       w(1,:) - first waveform, w(2,:) - second waveform, etc.
%       waveforms for external events (when t(:,1) == 4) are all zeros
[n, TS, WF] = PL_GetWFEvs(g_strctPlexon.m_iServerID);

g_strctPlexon.m_strctLastCheck.m_iWFCount = n;
g_strctPlexon.m_strctLastCheck.m_afTimeStamps = zeros(size(TS));
g_strctPlexon.m_strctLastCheck.m_afTimeStamps = TS;
g_strctPlexon.m_strctLastCheck.m_afWaveForms = zeros(size(WF));
g_strctPlexon.m_strctLastCheck.m_afWaveForms = WF;

if any(TS(:,3) == g_strctSystemCodes.m_iSync)
	g_strctPlexon.m_afCurrentServerTime(1) = TS(find(TS(:,3) ==  g_strctSystemCodes.m_iSync,1,'last'),4);
	g_strctPlexon.m_afCurrentServerTime(2) = g_strctCycle.m_fSyncTimer;
	
	
	
	
end
if any(TS)
	% convert spikes to local time
	TS(:,4) = (TS(:,4) - g_strctPlexon.m_afCurrentServerTime(1)) + g_strctPlexon.m_afCurrentServerTime(2);
	numSortedSpikes = numel(find(TS(:,3) ~= 0 ));
	g_strctPlexon.m_afRollingSpikeBuffer.Buf(g_strctPlexon.m_afRollingSpikeBuffer.BufID+1:...
								g_strctPlexon.m_afRollingSpikeBuffer.BufID+numSortedSpikes,:) =...
											TS(TS(:,3) ~= 0,:);
	g_strctPlexon.m_afRollingSpikeBuffer.BufID = g_strctPlexon.m_afRollingSpikeBuffer.BufID + numSortedSpikes;

end

if any(TS(:,3) == g_strctParadigm.m_strctStatServerDesign.TrialStartCode)
	


end
% Separate strobe events
%strobeIndices = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,2) == 257,:);

g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents = zeros(size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,2) == 257),1),4);

g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,2) == 257,:);

% separate noise 
g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents = zeros(size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,2) == 0),1),4);

g_strctPlexon.m_strctLastCheck.m_afUnsortedSpikes = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == 0,:);

% Separate spikes, events, etc by channel, not including external events
for iUnits = 1:max(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,1) ~= 4))
	%find this channel's indices
	unitIndex = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == iUnits,:);
	
	unitIndex = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == iUnits;
	
	g_strctPlexon.m_strctLastCheck.m_strctChannels(iUnits).m_afWaveForms = zeros(size(g_strctPlexon.m_strctLastCheck.m_afWaveForms(...
														unitIndex,:)));
														
	g_strctPlexon.m_strctLastCheck.m_strctChannels(iUnits).m_afWaveForms =  g_strctPlexon.m_strctLastCheck.m_afWaveForms(unitIndex,:);
	
	g_strctPlexon.m_strctLastCheck.m_strctChannels(iUnits).m_afTimeStamps = zeros(size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(...
														unitIndex,:)));
														
	g_strctPlexon.m_strctLastCheck.m_strctChannels(iUnits).m_afTimeStamps = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(unitIndex,:);
	
	g_strctPlexon.m_strctLastCheck.m_strctChannels(iUnits).m_aiCounts = size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(unitIndex),1);
end
%{
[g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices,g_strctPlexon.m_strctLastCheck.m_iStrobeTrialStartIndices] = deal([]);
g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices = find(...
                g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == ...
                g_strctParadigm.m_strctStatServerDesign.TrialStartCode);
g_strctPlexon.m_strctLastCheck.m_iStrobeTrialStartIndices = find(g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents(:,3) ==...
    g_strctParadigm.m_strctStatServerDesign.TrialStartCode);
%}
return;