function fnParseSpikesAndTrialsMultichannel(NumSpikeAndStrobeEvents, a2fSpikeAndEvents, a2fWaveForms)
global g_strctCycle g_strctConfig g_strctNet g_strctNeuralServer g_strctWindows g_DebugDataLog g_counter g_strctTrial


for i=1:size(spikes.timeStamps,1)
    exptDataP(i,1) = {spikes.timeStamps(i)};
    exptDataP(i,2) = {spikes.Waves(i,:)};
end


return;







function [data] = fnGetDataFromPlexonCircularBuffer(buffer, bufferIDs, numElementsToExtract)


for i = 1:size(buffer,2)
	if bufferIDs(i) - numElementsToExtract <= 0
		dataIDs = [1:bufferIDs(i), (bufferIDs(i) - numElementsToExtract+1)+size(buffer,3):size(buffer,3)];
		data(:,i,1:numElementsToExtract) = buffer(:,i,dataIDs);
	else
		data(:,i,1:numElementsToExtract) = buffer(:,i,[bufferIDs(i)-numElementsToExtract+1:bufferIDs(i)]);
	end

end

return;