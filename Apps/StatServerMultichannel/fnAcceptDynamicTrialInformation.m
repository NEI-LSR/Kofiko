function fnAcceptDynamicTrialInformation(strctTrial)
global g_strctNeuralServer g_strctTrial g_strctStatistics unitsInUpdate
global spikes strctColorValues exptDataK

persistent strcTrialBackupInfo
if g_strctStatistics.m_bDebugModeEnabled
    dbstop if warning
    warning('stopped in debugger')
    g_strctStatistics.m_bDebugModeEnabled  = 0;
end
if isempty(strctTrial)
    return;
end

exptDataK = strctTrial';
[n, TS, WF] = PL_GetWFEvs(g_strctNeuralServer.m_hSocket);

% % Felix added
% targunit=1;
% targinds= find(TS(:,2)==targunit);
% n=length(targinds);
% TS=TS(targinds,:);
% WF=WF(targinds,:);

g_strctNeuralServer.m_strctLastCheck.m_iWFCount = n;
g_strctNeuralServer.m_strctLastCheck.m_afTimeStamps = zeros(size(TS));
g_strctNeuralServer.m_strctLastCheck.m_afTimeStamps = TS;
g_strctNeuralServer.m_strctLastCheck.m_afWaveForms = zeros(size(WF));
g_strctNeuralServer.m_strctLastCheck.m_afWaveForms = WF;

if any(TS(:,3) == g_strctNeuralServer.m_iSyncStrobeCode)
    g_strctNeuralServer.m_afCurrentServerTime(1) = TS(find(TS(:,3) ==  g_strctNeuralServer.m_iSyncStrobeCode,1,'last'),4);
    g_strctNeuralServer.m_afCurrentServerTime(2) = g_strctNeuralServer.m_fSyncTimer;
end
initTimeP = g_strctNeuralServer.m_afCurrentServerTime(1);
initTimeK = g_strctNeuralServer.m_afCurrentServerTime(2);
spikes.timeStamps = TS;
spikes.Waves = WF;

exptDataK(cellfun('isempty',exptDataK)) = [];
exptDataK(:,2)=exptDataK(:,1);
for iTrials=1:size(exptDataK,1)
    exptDataK{iTrials,1} = exptDataK{iTrials,2}.m_fImageFlipON_TS_Kofiko;
end

unitsInUpdate = unique(spikes.timeStamps(spikes.timeStamps(:,3) > 0 & spikes.timeStamps(:,3) < 6 & spikes.timeStamps(:,2) ~= 257,3));
g_strctStatistics.m_aiActiveUnits = unique([unitsInUpdate;g_strctStatistics.m_aiActiveUnits]);
numUnitsInUpdate = numel(unitsInUpdate);

%dbstop if warning
%warning('stop')

exptDataP = zeros(g_strctNeuralServer.m_strctLastCheck.m_iWFCount,5);
for iUnit=1:numUnitsInUpdate
    if any(spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4))
        exptDataP(1:numel(spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4)),unitsInUpdate(iUnit)) =...
            spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4);
        exptDataP(:,unitsInUpdate(iUnit)) = exptDataP(:,unitsInUpdate(iUnit)) - initTimeP;
        
    end
end


strobeDataP = horzcat([TS(TS(:,2) == 257,3),TS(TS(:,2) == 257,4)]);

%dbstop if warning
%warning('blah')
exptDataK(:,1)=num2cell(cell2mat(exptDataK(:,1))-initTimeK); % normalize timestamps to first 'Sync' strobe

orientations = 20;
%{
g_strctStatistics.preTrialWindow = -.050;
postTrialWindow = .200;
%}



for iTrials = 1:size(exptDataK,1)
    spikesInThisTrial = [];
    if isfield(exptDataK{iTrials,2},'m_bMonkeyFixated') && exptDataK{iTrials,2}.m_bMonkeyFixated
        %g_strctStatistics.curTrialWindow = (exptDataK{iTrials,2}.m_iTrialLength_MS/1000) + postTrialWindow;
        
        for iUnit = 1:numUnitsInUpdate
            
            spikesInThisTrial = exptDataP(exptDataP(:,unitsInUpdate(iUnit)) - exptDataK{iTrials,1} >= g_strctStatistics.preTrialWindow & ...
                exptDataP(:,unitsInUpdate(iUnit)) -  exptDataK{iTrials,1} <=  g_strctStatistics.curTrialWindow,unitsInUpdate(iUnit)) - exptDataK{iTrials,1};
            if strcmpi(exptDataK{iTrials,2}.m_strTrialType, 'image')
                
                fnProcessImageTrial(exptDataK{iTrials,2},iUnit,spikesInThisTrial);
                
                
                
            end
            if isfield(exptDataK{iTrials,2},'m_bRandomStimulusPosition') && exptDataK{iTrials,2}.m_bRandomStimulusPosition    
                %g_strctStatistics.m_strctPositionMapping.m_aiPositionBins = [
            end          
            if isfield(exptDataK{iTrials,2},'m_bRandomStimulusPosition') && exptDataK{iTrials,2}.m_bRandomStimulusPosition
                %fnProcessPositionTrial(iTrials, unitsInUpdate(iUnit),  spikesInThisTrial);
                
            end


            if isfield(exptDataK{iTrials, 2}, 'm_strImageColorSpace') && strcmp(exptDataK{iTrials, 2}.m_strImageColorSpace, 'LUV')
                fnProcessLUVTrial(exptDataK{iTrials,2},iUnit,spikesInThisTrial)
            else
                fnProcessDKLTrial(exptDataK{iTrials,2},iUnit,spikesInThisTrial)
            end
              
            if isfield(exptDataK{iTrials,2},'m_bVariableTestObject') && exptDataK{iTrials,2}.m_bVariableTestObject
                fnProcessVariableTestObjectTrial(iTrials, unitsInUpdate(iUnit),  spikesInThisTrial);
                
            end
            
            if isfield(exptDataK{iTrials,2},'m_aiStimxyY')
                roundedThisTrialDKL = myRoundn(exptDataK{iTrials,2}.m_aiStimxyY,-3);
                if isempty(g_strctStatistics.trackedDKLCoordinates) || ~ismember(roundedThisTrialDKL,g_strctStatistics.trackedDKLCoordinates,'rows')
                    if ismember(roundedThisTrialDKL,myRoundn(strctColorValues.allDKLCoordinates,-3),'rows')
                        colorIDX = find(ismember(myRoundn(strctColorValues.allDKLCoordinates(:,1),-3),roundedThisTrialDKL(:,1)) &...
                            ismember(myRoundn(strctColorValues.allDKLCoordinates(:,2),-3),roundedThisTrialDKL(:,2))&...
                            ismember(myRoundn(strctColorValues.allDKLCoordinates(:,3),-3),roundedThisTrialDKL(:,3)),1);
                        g_strctStatistics.trackedDKLCoordinates(colorIDX,:) = roundedThisTrialDKL;
                    else
                        g_strctStatistics.trackedDKLCoordinates = [g_strctStatistics.trackedDKLCoordinates;roundedThisTrialDKL];
                    end
                    
                end
                allColorIDX = ismember(myRoundn(strctColorValues.allDKLCoordinates(:,1),-3),g_strctStatistics.trackedDKLCoordinates(:,1)) &...
                    ismember(myRoundn(strctColorValues.allDKLCoordinates(:,2),-3),g_strctStatistics.trackedDKLCoordinates(:,2))&...
                    ismember(myRoundn(strctColorValues.allDKLCoordinates(:,3),-3),g_strctStatistics.trackedDKLCoordinates(:,3));
                if any(allColorIDX)
                    thisTrialDKLIDX = find(roundedThisTrialDKL(1) ==  g_strctStatistics.trackedDKLCoordinates(:,1) &...
                        roundedThisTrialDKL(2) == g_strctStatistics.trackedDKLCoordinates(:,2)   &...
                        roundedThisTrialDKL(3) == g_strctStatistics.trackedDKLCoordinates(:,3)  );
                    g_strctStatistics.m_aiDKLCoorindateColorMatchingTable = [strctColorValues.allDKLCoordinates(allColorIDX,:),strctColorValues.allRGBValues(allColorIDX,:)];
                    g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(thisTrialDKLIDX,unitsInUpdate(iUnit)) =...
                        g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(thisTrialDKLIDX,unitsInUpdate(iUnit)) + 1;
                    
                else
                    
                    g_strctStatistics.uniqueDKLCoordinates = [g_strctStatistics.uniqueDKLCoordinates;roundedThisTrialDKL];
                    g_strctStatistics.trackedDKLCoordinates = vertcat(myRoundn(strctColorValues.allDKLCoordinates(colorIDX,:),-3),...
                        g_strctStatistics.uniqueDKLCoordinates);
                    numUniqueDKLPresetColors = size(strctColorValues.allDKLCoordinates,1);
                    g_strctStatistics.m_aiDKLCoorindateColorMatchingTable(numUniqueDKLPresetColors + g_strctStatistics.numTrackedNonPresetColors,1:3) = roundedThisTrialDKL;
                    g_strctStatistics.m_aiDKLCoorindateColorMatchingTable(numUniqueDKLPresetColors + g_strctStatistics.numTrackedNonPresetColors,4:6) = exptDataK{iTrials,2}.m_aiStimColor;
                    g_strctStatistics.numTrackedNonPresetColors = g_strctStatistics.numTrackedNonPresetColors + 1;
                    thisTrialDKLIDX = find(roundedThisTrialDKL(1) ==  g_strctStatistics.trackedDKLCoordinates(:,1) &...
                        roundedThisTrialDKL(2) == g_strctStatistics.trackedDKLCoordinates(:,2)   &...
                        roundedThisTrialDKL(3) == g_strctStatistics.trackedDKLCoordinates(:,3)  );
                    
                end
                
                g_strctStatistics.m_aiDKLCoorindateSpikeHolder(thisTrialDKLIDX,g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialDKLIDX,unitsInUpdate(iUnit)):...
                    g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialDKLIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
                    spikesInThisTrial ;
                
                g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialDKLIDX,unitsInUpdate(iUnit)) = ...
                    g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialDKLIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
 
            end
            if isfield(exptDataK{iTrials,2},'m_iOrientationBin') && ~isempty(exptDataK{iTrials,2}.m_iOrientationBin)
                
                g_strctStatistics.m_aiOrientationSpikeHolder(exptDataK{iTrials,2}.m_iOrientationBin,...
                    g_strctStatistics.m_aiOrientationSpikeHolderIDX(exptDataK{iTrials,2}.m_iOrientationBin,unitsInUpdate(iUnit)):...
                    g_strctStatistics.m_aiOrientationSpikeHolderIDX(exptDataK{iTrials,2}.m_iOrientationBin,unitsInUpdate(iUnit))+...
                    numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) =  spikesInThisTrial ;
                
                
                g_strctStatistics.m_aiOrientationSpikeHolderIDX(exptDataK{iTrials,2}.m_iOrientationBin,unitsInUpdate(iUnit)) = ...
                    g_strctStatistics.m_aiOrientationSpikeHolderIDX(exptDataK{iTrials,2}.m_iOrientationBin,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
            end
            
            exptDataK{iTrials,2}.spikes(unitsInUpdate(iUnit),1:numel(spikesInThisTrial)) = spikesInThisTrial;
        end
        
    end

    g_strctTrial{g_strctStatistics.m_iTrialIter,1} = exptDataK{iTrials,2};
    g_strctTrial{g_strctStatistics.m_iTrialIter,2} = spikesInThisTrial;
    
    g_strctStatistics.m_iTrialIter = g_strctStatistics.m_iTrialIter + 1;
    if g_strctStatistics.m_iTrialIter > g_strctNeuralServer.m_iTrialsToKeepInBuffer
        g_strctStatistics.m_iTrialIter = 1;
    end
end

PSTHOrientationHolder = [];
if isfield(g_strctStatistics, 'trackedDKLCoordinates') && ~isempty(g_strctStatistics.trackedDKLCoordinates)
    activeDKLConditionsIDX = find(~isnan(g_strctStatistics.trackedDKLCoordinates(:,1)));
    activeConditionsDKLIDX =  1:size(g_strctStatistics.trackedDKLCoordinates,1);
else
    activeDKLConditionsIDX = [];
    activeConditionsDKLIDX = [];
end
if isfield(g_strctStatistics, 'trackedLUVCoordinates') && ~isempty(g_strctStatistics.trackedLUVCoordinates)
    
    activeLUVConditionsIDX = find(~isnan(g_strctStatistics.trackedLUVCoordinates(:,1)));
    activeConditionsLUVIDX =  1:size(g_strctStatistics.trackedLUVCoordinates,1);
else
    activeLUVConditionsIDX = [];
    activeConditionsLUVIDX = [];
end

fields = fieldnames(g_strctStatistics.m_strctEnabledPlots);
g_strctStatistics.numEnabledPlots = 0;

for iFields = 1:size(fields,1)
    g_strctStatistics.numEnabledPlots = g_strctStatistics.numEnabledPlots + g_strctStatistics.m_strctEnabledPlots.(fields{iFields});
end
g_strctStatistics.numCurrentlyTrackedUnits = max(max([g_strctStatistics.m_aiActiveUnits;unitsInUpdate]));
[g_strctStatistics.m_aiDKLPSTHColorHolder, g_strctStatistics.m_aiLUVPSTHColorHolder] = deal([]);
subplotIDX = 1;
%dbstop if warning
%warning('stop')
for iUnit = 1:numUnitsInUpdate
    g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numEnabledPlots;
    plotRowInUse = 1;
    if g_strctStatistics.m_strctEnabledPlots.m_bPSTHEnabled && ~isempty(g_strctStatistics.trackedDKLCoordinates)
        
        if ~isempty(activeDKLConditionsIDX)
            for iConditions = 1:size(activeDKLConditionsIDX,1)
                maxVal = max(g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0));
                
                minVal = min(	g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0));
                
                %{
            if  g_strctStatistics.curTrialWindow < maxVal
				g_strctStatistics.curTrialWindow = myRoundn(maxVal,-2);
			end
			
			if  g_strctStatistics.preTrialWindow > minVal
				g_strctStatistics.preTrialWindow = myRoundn(minVal,-2);
			
			end
                    %}
                    
                    
                    % Force the spikes in the condition onto a template with the desired time range, so all the spikes have the same time x-range
                    TrialTimeTemplate = [];
                    %fprintf('maxval = %f, minval = %f\n', maxVal, minVal)
                    %if any(maxVal) & any(minVal)
                    % if g_strctStatistics.curTrialWindow >= maxVal && g_strctStatistics.preTrialWindow <=  minVal
                    
                    
                    TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
                    
                    tempSpikes = [g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),...
                        :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                    
                    % histogram and subtract out our template
                    g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        hist(tempSpikes,50);
                    
                    g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) - 1;
                    % else
                    %{
                    tempSpikes = [g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),...
                        :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                    
                    g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        hist(tempSpikes,50);
                    %}
                    % end
                    %end
                    
                    
                    
                    %{
		 g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
            hist(g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeDKLConditionsIDX(iConditions),:,unitsInUpdate(iUnit)) ~= 0,...
            unitsInUpdate(iUnit)),50);
		
                    %}
                    
                    
                    g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = g_strctStatistics.m_aiDKLPSTHColorHolder(iConditions, :, unitsInUpdate(iUnit)) /...
                        g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(activeDKLConditionsIDX(iConditions),unitsInUpdate(iUnit));
            end
        end
        TrialTimeTemplate = [];
        TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
        
        
        
        tempSpikes = cat(2,repmat(TrialTimeTemplate,[numel(activeConditionsDKLIDX),1]),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeConditionsDKLIDX,:, unitsInUpdate(iUnit)));
        % tempSpikes = cat(2,g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeConditionsDKLIDX,:, unitsInUpdate(iUnit)),repmat(TrialTimeTemplate,[numel(activeConditionsDKLIDX),1]));
        
        for iDKLConditions = 1:numel(activeConditionsDKLIDX)
            % histogram and subtract out our template
            g_strctStatistics.m_aiDKLPSTHColorHolder(iDKLConditions,:,unitsInUpdate(iUnit)) = ...
                histcounts(tempSpikes(iDKLConditions,1:(g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(iDKLConditions, unitsInUpdate(iUnit))-1)+numel(TrialTimeTemplate)),50)-1;
            
            %{
                
                 g_strctStatistics.m_aiDKLPSTHColorHolder(iDKLConditions+numel(activeDKLConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                histcounts(tempSpikes(iDKLConditions,1:(g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(iDKLConditions, unitsInUpdate(iUnit))-1)+numel(TrialTimeTemplate)),50)-1;
           
            g_strctStatistics.m_aiDKLPSTHColorHolder(iDKLConditions+numel(activeDKLConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                g_strctStatistics.m_aiDKLPSTHColorHolder(iDKLConditions+numel(activeDKLConditionsIDX),:,unitsInUpdate(iUnit)) - 1;
                %}
                
                
                
                
                g_strctStatistics.m_aiDKLPSTHColorHolder(iDKLConditions,:,unitsInUpdate(iUnit)) = g_strctStatistics.m_aiDKLPSTHColorHolder(iDKLConditions, :, unitsInUpdate(iUnit)) /...
                    g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(activeConditionsDKLIDX(iDKLConditions),unitsInUpdate(iUnit));
        end
        
        thisSubplotStartingIndex = ((((plotRowInUse-1) * 10) * max(unitsInUpdate)  + (unitsInUpdate(iUnit)-1)*10) + 1);
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,...
            thisSubplotStartingIndex + 1: thisSubplotStartingIndex + 9);
        
        
        
        %{
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(2+((unitsInUpdate(iUnit)-1)*10)+...
            (g_strctStatistics.numCurrentlyTrackedUnits *...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)))...
            :(unitsInUpdate(iUnit)*10 + (g_strctStatistics.numCurrentlyTrackedUnits *...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows))));
            %}
            %{
                                        
                                        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(2+((unitsInUpdate(iUnit)-1)*10)+...
										(g_strctStatistics.numCurrentlyTrackedUnits *...
                                        (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows-1)))...
										:(unitsInUpdate(iUnit)*10 + (g_strctStatistics.numCurrentlyTrackedUnits *...
                                        (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows-1))));
                                        
                                        
            %}
            
            imagesc(g_strctStatistics.m_aiDKLPSTHColorHolder(:,:,unitsInUpdate(iUnit)));
            set(gca,'YTick',[])
            NumTicks = 11;%(numBins/20)+1;
            L = get(gca,'XLim');
            set(gca,'XTick',linspace(L(1),L(2),NumTicks-1))
            set(gca,'XTickLabelMode','manual')
            set(gca,'XTickLabel',myRoundn(linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,NumTicks-1),-2))
            
            %{
            subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(1+((unitsInUpdate(iUnit)-1)*10)) + (g_strctStatistics.numCurrentlyTrackedUnits *...
                (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
            %}
            %thisSubplotStartingIndex = ((((plotRowInUse-1) * 10) * max(unitsInUpdate)  + (unitsInUpdate(iUnit)-1)*10) + 1);
            subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,thisSubplotStartingIndex);
            
            %{
            [colorBar] = fnMakeColorBar(g_strctStatistics.m_aiDKLCoorindateColorMatchingTable(find(...
                g_strctStatistics.m_aiDKLCoorindateColorMatchingTable(:,1)),:));
            %}
            [colorBar] = fnMakeColorBar(g_strctStatistics.m_aiDKLCoorindateColorMatchingTable);
            imagesc(colorBar);
            set(gca,'xTickLabel','')
            set(gca,'yTickLabel','')
            set(gca,'XTick',[])
            set(gca,'YTick',[])
            
            
            g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numAvailableSubplotRows - 1;
            plotRowInUse = plotRowInUse + 1;
            
    end
    if g_strctStatistics.m_strctEnabledPlots.m_bLUVPSTHEnabled && ~isempty(g_strctStatistics.trackedLUVCoordinates)
        
        if ~isempty(activeLUVConditionsIDX)
            for iConditions = 1:size(activeLUVConditionsIDX,1)
                maxVal = max(g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0));
                
                minVal = min(	g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0));
                
                %{
            if  g_strctStatistics.curTrialWindow < maxVal
				g_strctStatistics.curTrialWindow = myRoundn(maxVal,-2);
			end
			
			if  g_strctStatistics.preTrialWindow > minVal
				g_strctStatistics.preTrialWindow = myRoundn(minVal,-2);
			
			end
                    %}
                    
                    
                    % Force the spikes in the condition onto a template with the desired time range, so all the spikes have the same time x-range
                    TrialTimeTemplate = [];
                    %fprintf('maxval = %f, minval = %f\n', maxVal, minVal)
                    %if any(maxVal) & any(minVal)
                    % if g_strctStatistics.curTrialWindow >= maxVal && g_strctStatistics.preTrialWindow <=  minVal
                    
                    
                    TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
                    
                    tempSpikes = [g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),...
                        :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                    
                    % histogram and subtract out our template
                    g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        hist(tempSpikes,50);
                    
                    g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) - 1;
                    % else
                    %{
                    tempSpikes = [g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),...
                        :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                    
                    g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        hist(tempSpikes,50);
                    %}
                    % end
                    %end
                    
                    
                    
                    %{
		 g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
            hist(g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeLUVConditionsIDX(iConditions),:,unitsInUpdate(iUnit)) ~= 0,...
            unitsInUpdate(iUnit)),50);
		
                    %}
                    
                    
                    g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = g_strctStatistics.m_aiLUVPSTHColorHolder(iConditions, :, unitsInUpdate(iUnit)) /...
                        g_strctStatistics.m_aiLUVCoorindateColorTrialCounter(activeLUVConditionsIDX(iConditions),unitsInUpdate(iUnit));
            end
        end
        TrialTimeTemplate = [];
        TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
        
        
        
        tempSpikes = cat(2,repmat(TrialTimeTemplate,[numel(activeConditionsLUVIDX),1]),g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeConditionsLUVIDX,:, unitsInUpdate(iUnit)));
        % tempSpikes = cat(2,g_strctStatistics.m_aiLUVCoorindateSpikeHolder(activeConditionsLUVIDX,:, unitsInUpdate(iUnit)),repmat(TrialTimeTemplate,[numel(activeConditionsLUVIDX),1]));
        
        for iLUVConditions = 1:numel(activeConditionsLUVIDX)
            % histogram and subtract out our template
            g_strctStatistics.m_aiLUVPSTHColorHolder(iLUVConditions,:,unitsInUpdate(iUnit)) = ...
                histcounts(tempSpikes(iLUVConditions,1:(g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(iLUVConditions, unitsInUpdate(iUnit))-1)+numel(TrialTimeTemplate)),50)-1;
            %{
                g_strctStatistics.m_aiLUVPSTHColorHolder(iLUVConditions+numel(activeLUVConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                histcounts(tempSpikes(iLUVConditions,1:(g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(iLUVConditions, unitsInUpdate(iUnit))-1)+numel(TrialTimeTemplate)),50)-1;
           
            g_strctStatistics.m_aiLUVPSTHColorHolder(iLUVConditions+numel(activeLUVConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                g_strctStatistics.m_aiLUVPSTHColorHolder(iLUVConditions+numel(activeLUVConditionsIDX),:,unitsInUpdate(iUnit)) - 1;
                %}
                
                
                
                
                g_strctStatistics.m_aiLUVPSTHColorHolder(iLUVConditions,:,unitsInUpdate(iUnit)) = g_strctStatistics.m_aiLUVPSTHColorHolder(iLUVConditions, :, unitsInUpdate(iUnit)) /...
                    g_strctStatistics.m_aiLUVCoorindateColorTrialCounter(activeConditionsLUVIDX(iLUVConditions),unitsInUpdate(iUnit));
        end
        
        
        thisSubplotStartingIndex = ((((plotRowInUse-1) * 10) * max(unitsInUpdate)  + (unitsInUpdate(iUnit)-1)*10) + 1);
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,...
            thisSubplotStartingIndex + 1: thisSubplotStartingIndex + 9);
        
        
        %{
                                        
                                        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(2+((unitsInUpdate(iUnit)-1)*10)+...
										(g_strctStatistics.numCurrentlyTrackedUnits *...
                                        (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows-1)))...
										:(unitsInUpdate(iUnit)*10 + (g_strctStatistics.numCurrentlyTrackedUnits *...
                                        (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows-1))));
                                        
                                        
            %}
            
            imagesc(g_strctStatistics.m_aiLUVPSTHColorHolder(:,:,unitsInUpdate(iUnit)));
            set(gca,'YTick',[])
            NumTicks = 11;%(numBins/20)+1;
            L = get(gca,'XLim');
            set(gca,'XTick',linspace(L(1),L(2),NumTicks-1))
            set(gca,'XTickLabelMode','manual')
            set(gca,'XTickLabel',myRoundn(linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,NumTicks-1),-2))
            
            subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,thisSubplotStartingIndex);
            
            
            
            
            [colorBar] = fnMakeColorBar(g_strctStatistics.m_aiLUVCoorindateColorMatchingTable);
            imagesc(colorBar);
            set(gca,'xTickLabel','')
            set(gca,'yTickLabel','')
            set(gca,'XTick',[])
            set(gca,'YTick',[])
            
            
            g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numAvailableSubplotRows - 1;
            plotRowInUse = plotRowInUse + 1;
            
    end
    %Trials,2}.m_iTrialLength_MS,numXTickLabels)));
    tic
    %{
        PositionPSTHHolder = zeros(prod(g_strctStatistics.m_aiSpikePositionBinGrid),1);
        for indices = 1:prod(g_strctStatistics.m_aiSpikePositionBinGrid)
            
            %[thisIndexSubscriptX,thisIndexSubscriptY] = ind2sub([20,12],indices);
            % tempSpikes = numel(g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),:) ~= 0));
            tempSpikes = numel(g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),:) ~= 0));
            if isempty(tempSpikes)
                tempSpikes = 0;
            end
            PositionPSTHHolder(indices) = tempSpikes;
            %  PositionPSTHHolder(thisIndexSubscriptX,thisIndexSubscriptY) = tempSpikes;%...
            % g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),:) ~= 0);
            %if any(tempSpikes)
        end
    %}
    if g_strctStatistics.m_strctEnabledPlots.m_bPositionHeatmapEnabled
        PositionPSTHHolder = zeros(prod(g_strctStatistics.m_aiSpikePositionBinGrid),1);
        for indices = 1:prod(g_strctStatistics.m_aiSpikePositionBinGrid)
            
            %indices = [1:prod(g_strctStatistics.m_aiSpikePositionBinGrid)];
            % tempSpikes = cat(2,repmat(TrialTimeTemplate,[numel(activeConditionsDKLIDX),1]),g_strctStatistics.m_aiDKLCoorindateSpikeHolder(activeConditionsDKLIDX,:, unitsInUpdate(iUnit)));
            
            %[thisIndexSubscriptX,thisIndexSubscriptY] = ind2sub([20,12],indices);
            % tempSpikes = numel(g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),:) ~= 0));
            PositionPSTHHolder(indices) = numel(g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),...
                1:g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX(indices,unitsInUpdate(iUnit))-1));
            
            % PositionPSTHHolder(indices) = tempSpikes;
            %  PositionPSTHHolder(thisIndexSubscriptX,thisIndexSubscriptY) = tempSpikes;%...
            % g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(indices,unitsInUpdate(iUnit),:) ~= 0);
            %if any(tempSpikes)
        end
        positionSpikesInThisUnit = PositionPSTHHolder./...
            g_strctStatistics.m_aiSpikePositionBinsTrialCounter(:,unitsInUpdate(iUnit));
        positionSpikesInThisUnit(isinf(positionSpikesInThisUnit)) = 0;
        %reshape(g_strctStatistics.m_aiSpikePositionBinsTrialCounter(:,unitsInUpdate(iUnit)),20,12),50);
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits, unitsInUpdate(iUnit) + (g_strctStatistics.numCurrentlyTrackedUnits *...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
        imagesc(reshape(positionSpikesInThisUnit, [g_strctStatistics.m_aiSpikePositionBinGrid(1), g_strctStatistics.m_aiSpikePositionBinGrid(2)]));
        %set(gca,'YTick',[])
        %NumTicks = 11;%(numBins/20)+1;
        %L = get(gca,'XLim');
        %set(gca,'XTick',linspace(L(1),L(2),NumTicks-1))
        %set(gca,'XTickLabelMode','manual')
        %set(gca,'XTickLabel',myRoundn(linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,NumTicks-1),-2))
        
        % end
        g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numAvailableSubplotRows - 1;
    end
    toc
    for iConditions = 1:20
        PSTHOrientationHolder(iConditions,1,unitsInUpdate(iUnit)) = deg2rad(round(iConditions * (360/20)));
        PSTHOrientationHolder(iConditions,2,unitsInUpdate(iUnit)) = sum(g_strctStatistics.m_aiOrientationSpikeHolder(iConditions,...
            g_strctStatistics.m_aiOrientationSpikeHolder(iConditions,:,unitsInUpdate(iUnit)) ~= 0,unitsInUpdate(iUnit)));
    end
    
    if max(max(max(any(PSTHOrientationHolder)))) && g_strctStatistics.m_strctEnabledPlots.m_bOrientationPolarEnabled
        PSTHOrientationHolder(:,2,unitsInUpdate(iUnit)) = circshift(PSTHOrientationHolder(:,2,unitsInUpdate(iUnit)), [6,0,0]);
        PSTHOrientationHolder(:,1,unitsInUpdate(iUnit)) = flipud(PSTHOrientationHolder(:,1,unitsInUpdate(iUnit)));
        % P.RTickValue = deg2rad(1:90:360);
        % P.RTickValue = deg2rad(1:90:360);
        P.RTickLabel = {''};
        P.TTickValue = (0:90:360);
        P.TTickLabel = {'270','180','90','0'};
        P.Style = 'Cartesian';
        % subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + g_strctStatistics.numCurrentlyTrackedUnits*(g_strctStatistics.numEnabledPlots-1));
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + (g_strctStatistics.numCurrentlyTrackedUnits * ...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
        
        mmpolar(vertcat(PSTHOrientationHolder(:,1,unitsInUpdate(iUnit)), PSTHOrientationHolder(1,1,unitsInUpdate(iUnit))),...
            vertcat(PSTHOrientationHolder(:,2,unitsInUpdate(iUnit)),PSTHOrientationHolder(1,2,unitsInUpdate(iUnit))),P);
        %deg2rad(1:90:360)
        
        %{
        mmpolar(vertcat(flipud(PSTHOrientationHolder(:,1,unitsInUpdate(iUnit))),PSTHOrientationHolder(end,1,unitsInUpdate(iUnit))),...
            vertcat(PSTHOrientationHolder(:,2,unitsInUpdate(iUnit)),PSTHOrientationHolder(end,2,unitsInUpdate(iUnit)))-1);
        %}
        g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numAvailableSubplotRows - 1;
    end
    
    if g_strctStatistics.m_strctEnabledPlots.m_bVariableWidthPlotEnabled && (g_strctStatistics.numAvailableSubplotRows >= 1)
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + (g_strctStatistics.numCurrentlyTrackedUnits * ...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
        
        
        %occupiedArrayPositionsForward = ~isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep(:,1))
        % occupiedArrayPositionsBackward = ~isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(:,1))
        %warning('bluh');
        [~,fowardSortIDX] = sort(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(unitsInUpdate(iUnit)).m_afForwardStepConditionID);
        [~,backwardSortIDX] = sort(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(unitsInUpdate(iUnit)).m_afBackwardStepConditionID);
        
        forwardSpikeCounts = cellfun(@numel,g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(unitsInUpdate(iUnit)).m_afForwardStep);
        backwardSpikeCounts = cellfun(@numel,g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(unitsInUpdate(iUnit)).m_afBackwardStep);
        
        plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(unitsInUpdate(iUnit)).m_afForwardStepConditionID(fowardSortIDX), ...
            forwardSpikeCounts(fowardSortIDX), 'color', 'red');
        hold on
        plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(unitsInUpdate(iUnit)).m_afBackwardStepConditionID(backwardSortIDX), ...
            backwardSpikeCounts(backwardSortIDX), 'color', 'blue');
        hold off
        
        
        %plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(occupiedArrayPositionsBackward,1), ...
        %   g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(occupiedArrayPositionsBackward,2),'color','blue');
        
    end
    
    if g_strctStatistics.m_strctEnabledPlots.m_bVariableLengthPlotEnabled && (g_strctStatistics.numAvailableSubplotRows >= 1)
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + (g_strctStatistics.numCurrentlyTrackedUnits * ...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
        
        
        %occupiedArrayPositionsForward = ~isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep(:,1))
        % occupiedArrayPositionsBackward = ~isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(:,1))
        %warning('bluh');
        [~,fowardSortIDX] = sort(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(unitsInUpdate(iUnit)).m_afForwardStepConditionID);
        [~,backwardSortIDX] = sort(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(unitsInUpdate(iUnit)).m_afBackwardStepConditionID);
        
        forwardSpikeCounts = cellfun(@numel,g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(unitsInUpdate(iUnit)).m_afForwardStep);
        backwardSpikeCounts = cellfun(@numel,g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(unitsInUpdate(iUnit)).m_afBackwardStep);
        
        plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(unitsInUpdate(iUnit)).m_afForwardStepConditionID(fowardSortIDX), ...
            forwardSpikeCounts(fowardSortIDX), 'color', 'red');
        hold on
        plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(unitsInUpdate(iUnit)).m_afBackwardStepConditionID(backwardSortIDX), ...
            backwardSpikeCounts(backwardSortIDX), 'color', 'blue');
        hold off
        
        
        %plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(occupiedArrayPositionsBackward,1), ...
        %   g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(occupiedArrayPositionsBackward,2),'color','blue');
        
    end
    if g_strctStatistics.m_strctEnabledPlots.m_bVariableSpeedPlotEnabled && (g_strctStatistics.numAvailableSubplotRows >= 1)
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + (g_strctStatistics.numCurrentlyTrackedUnits * ...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
        
        
        %occupiedArrayPositionsForward = ~isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep(:,1))
        % occupiedArrayPositionsBackward = ~isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(:,1))
        %warning('bluh');
        [~,fowardSortIDX] = sort(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(unitsInUpdate(iUnit)).m_afForwardStepConditionID);
        [~,backwardSortIDX] = sort(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(unitsInUpdate(iUnit)).m_afBackwardStepConditionID);
        
        forwardSpikeCounts = cellfun(@numel,g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(unitsInUpdate(iUnit)).m_afForwardStep);
        backwardSpikeCounts = cellfun(@numel,g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(unitsInUpdate(iUnit)).m_afBackwardStep);
        
        plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(unitsInUpdate(iUnit)).m_afForwardStepConditionID(fowardSortIDX), ...
            forwardSpikeCounts(fowardSortIDX), 'color', 'red');
        hold on
        plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(unitsInUpdate(iUnit)).m_afBackwardStepConditionID(backwardSortIDX), ...
            backwardSpikeCounts(backwardSortIDX), 'color', 'blue');
        hold off
        
        
        %plot(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(occupiedArrayPositionsBackward,1), ...
        %   g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep(occupiedArrayPositionsBackward,2),'color','blue');
        
    end
    
    % dbstop if warning
    
    if g_strctStatistics.m_strctEnabledPlots.m_bImagePlotEnabled && isfield(g_strctStatistics,'m_strctImageAnalysis') && ~isempty(g_strctStatistics.m_strctImageAnalysis)
        
        disp('plot images')
        iNumCurrentlyTrackedImageCategories = numel(g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames);
        
        %warning('stop');
        TrialTimeTemplate = [];
        TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
        
        tic
        g_strctStatistics.PSTHImageHolder = zeros(iNumCurrentlyTrackedImageCategories,50,g_strctStatistics.numCurrentlyTrackedUnits);
        
        
        toc
        tic
        for iImageCategories = 1:iNumCurrentlyTrackedImageCategories
            tempSpikes = [g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolder(iImageCategories,g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolder(iImageCategories,...
                :, unitsInUpdate(iUnit)) ~= 0,unitsInUpdate(iUnit)) ,TrialTimeTemplate];
            
            
            %tempSpikeHolder = histcounts([g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolder(iImageCategories,:,unitsInUpdate(iUnit))],50);
            g_strctStatistics.PSTHImageHolder(iImageCategories,:,unitsInUpdate(iUnit)) = ...
                (histcounts(tempSpikes,50)-1)/g_strctStatistics.m_strctImageAnalysis.m_aiImageNameTrialCounter(iImageCategories);
            % histcounts(tempSpikes(iImageCategories,1:(g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolderIDX(iImageCategories, unitsInUpdate(iUnit))-1)+numel(TrialTimeTemplate)),50)-1;
            
            
            %g_strctStatistics.PSTHImageHolder(iImageCategories, :, unitsInUpdate(iUnit)) = tempSpikes;
        end
        g_strctStatistics.PSTHImageHolder(iImageCategories,:,unitsInUpdate(iUnit))
        
        toc
        tic
        
        
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + (g_strctStatistics.numCurrentlyTrackedUnits * ...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
        
        imagesc(g_strctStatistics.PSTHImageHolder(:,:,unitsInUpdate(iUnit)));
        set(gca,'YTick',[])
        NumTicks = 11;%(numBins/20)+1;
        L = get(gca,'XLim');
        set(gca,'XTick',linspace(L(1),L(2),NumTicks-1))
        set(gca,'XTickLabelMode','manual')
        set(gca,'XTickLabel',myRoundn(linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,NumTicks-1),-2))
        
        pos = get(gca, 'Position'); %// gives x left, y bottom, width, height
        bottom = pos(2);
        %width = pos(3);
        height = pos(4);
        
        for iImageCategories = 1:iNumCurrentlyTrackedImageCategories
            text(0 ,iImageCategories , ...
                g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames{iImageCategories},'interpreter','none', 'color', [1,0,0], 'FontSize',15);
            
        end
        
        
        g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numAvailableSubplotRows - 1;
        toc
    end
    drawnow;
    
end


return;




function [rgb] = ldrgyv2rgb(ld,rg,yv)
global g_strctStatistics
ldrgyv = [ld rg yv]';

matrix = g_strctStatistics.m_strctConversionMatrices.ldgyb;


rgb = matrix*ldrgyv/2.0 + 0.5;
return;

% ------------------------------------------------------------------------------------------

function [colorBar] = fnMakeColorBar(CoorindateColorMatchingTable)

%colorTableIDX = find(CoorindateColorMatchingTable(:,1));

%CoorindateColorMatchingTable = CoorindateColorMatchingTable(colorTableIDX,:);
colorBar = [];
for i = 1:size(CoorindateColorMatchingTable,1)
    
    colorBar(i,1,1) = CoorindateColorMatchingTable(i,4)/65535;
    colorBar(i,1,2) = CoorindateColorMatchingTable(i,5)/65535;
    colorBar(i,1,3) = CoorindateColorMatchingTable(i,6)/65535;
end


return;

% ------------------------------------------------------------------------------------------


function fnProcessPositionTrial(iTrials, iUnit, spikesInThisTrial)
global g_strctStatistics exptDataK unitsInUpdate


% flipped for clarity in Kofiko trial planning
% or something
locationY = exptDataK{iTrials,2}.location_x;
locationX = exptDataK{iTrials,2}.location_y;
xRange = range([exptDataK{iTrials,2}.m_aiStimulusRect(2),exptDataK{iTrials,2}.m_aiStimulusRect(4)]);
yRange = range([exptDataK{iTrials,2}.m_aiStimulusRect(1),exptDataK{iTrials,2}.m_aiStimulusRect(3)]);

if xRange < g_strctStatistics.m_aiSpikePositionBinGrid(1)
    xRange = g_strctStatistics.m_aiSpikePositionBinGrid(1);
end

if yRange < g_strctStatistics.m_aiSpikePositionBinGrid(2)
    yRange = g_strctStatistics.m_aiSpikePositionBinGrid(2);
end

numBarsInThisTrial = exptDataK{iTrials,2}.m_iNumberOfBars;
for iBars = 1:numBarsInThisTrial
    xBin = round((abs(exptDataK{iTrials,2}.m_aiStimulusRect(2) - locationX(iBars)) / xRange) * g_strctStatistics.m_aiSpikePositionBinGrid(1)) + 1;
    
    if xBin < 1
        xBin = 1;
    end
    if xBin > g_strctStatistics.m_aiSpikePositionBinGrid(1)
        xBin = g_strctStatistics.m_aiSpikePositionBinGrid(1);
    end
    
    yBin = round((abs(exptDataK{iTrials,2}.m_aiStimulusRect(1) - locationY(iBars)) / yRange) * g_strctStatistics.m_aiSpikePositionBinGrid(2)) + 1;
    
    if yBin < 1
        yBin = 1;
    end
    if yBin >  g_strctStatistics.m_aiSpikePositionBinGrid(2)
        yBin = g_strctStatistics.m_aiSpikePositionBinGrid(2);
    end
    linearBinID = sub2ind(g_strctStatistics.m_aiSpikePositionBinGrid,xBin,yBin);
    spikesInThisTrialsIntegrationPeriod = spikesInThisTrial(spikesInThisTrial >= g_strctStatistics.m_afPositionMappingSpikeIntegrationTimeMS(1) & ...
        spikesInThisTrial <= g_strctStatistics.m_afPositionMappingSpikeIntegrationTimeMS(2));
    numSpikes = numel(spikesInThisTrialsIntegrationPeriod);
    if any(spikesInThisTrialsIntegrationPeriod)
        g_strctStatistics.m_aiSpikePositionBinsSpikeHolder(linearBinID,iUnit,...
            g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX(linearBinID,iUnit):...
            g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX(linearBinID,iUnit) + ...
            numSpikes-1) = spikesInThisTrialsIntegrationPeriod;
        g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX(linearBinID,iUnit) = ...
            g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX(linearBinID,iUnit) + ...
            numSpikes;
    end
    g_strctStatistics.m_aiSpikePositionBinsTrialCounter(linearBinID,iUnit) =...
        g_strctStatistics.m_aiSpikePositionBinsTrialCounter(linearBinID,iUnit) + 1;
end




return;

function fnProcessVariableTestObjectTrial(iTrials, iUnit,  spikesInThisTrial)
global g_strctStatistics exptDataK
%determine test object type
%dbstop if warning
if ~isfield(g_strctStatistics,'m_strctTestObjectSpikeHolder')
    g_strctStatistics.m_strctTestObjectSpikeHolder = [];
end
for iTestObjects = 1:size(exptDataK{iTrials,2}.m_acCurrentlyVariableFields,1)
    switch exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,1}
        case {'PlainBarLength', 'MovingBarLength'}
            
            if ~isfield(g_strctStatistics.m_strctTestObjectSpikeHolder,'BarLengthSpikes') || size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes,2) < iUnit
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStep = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStep = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepConditionID = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepConditionID = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardSteptrialCounter = 0;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardSteptrialCounter = 0;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX = 1;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX = 1;
                
                
            end
            if exptDataK{iTrials,2}.m_iLength == 0
                continue
            end
            if any(spikesInThisTrial)
                if sign(double(exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,5} == 1)) || exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,7}
                    if size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX,1) < exptDataK{iTrials,2}.m_iLength || ...
                            isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength))
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = 1;
                    end
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStep(exptDataK{iTrials,2}.m_iLength, ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) : ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial) -1) = ...
                        spikesInThisTrial;
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial);
                    
                elseif 	sign(double(exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,5} == -1))
                    if size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX,1) < exptDataK{iTrials,2}.m_iLength || ...
                            isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength))
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = 1;
                    end
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStep(exptDataK{iTrials,2}.m_iLength, ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) : ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial) -1) = ...
                        spikesInThisTrial;
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarLengthSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial);
                end
            end
            
        case {'PlainBarWidth', 'MovingBarWidth'}
            % warning('bluh');
            %  if ~isfield(g_strctStatistics,'m_strctTestObjectSpikeHolder')
            %     g_strctStatistics.m_strctTestObjectSpikeHolder = [];
            %  end
            
            if ~isfield(g_strctStatistics.m_strctTestObjectSpikeHolder,'BarWidthSpikes') || size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes,2) < iUnit
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep = {};
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep = {};
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStepConditionID = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStepConditionID = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardSteptrialCounter = {};
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardSteptrialCounter = {};
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStepSpikeIDX = 1;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStepSpikeIDX = 1;
                
            end
            
            if exptDataK{iTrials,2}.m_iWidth == 0
                continue
            end
            if any(spikesInThisTrial)
                if sign(double(exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,5} == 1)) || exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,7}
                    % forward or random
                    
                    if ~any(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStepConditionID == exptDataK{iTrials,2}.m_iWidth)
                        % is this a new condition?
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStepConditionID(end + 1) = exptDataK{iTrials,2}.m_iWidth;
                        thisConditionID = numel(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStepConditionID);
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep{end + 1} = [];
                    else
                        thisConditionID = find(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStepConditionID == exptDataK{iTrials,2}.m_iWidth);
                        
                    end
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardSteptrialCounter{thisConditionID} = ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardSteptrialCounter{thisConditionID} + 1;
                    if any(spikesInThisTrial)
                        
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep{thisConditionID} = ...
                            vertcat(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afForwardStep{thisConditionID}, ...
                            spikesInThisTrial);
                        
                    end
                elseif sign(double(exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,5} == -1))
                    % backward
                    if ~any(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStepConditionID == exptDataK{iTrials,2}.m_iWidth)
                        % is this a new condition?
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStepConditionID(end + 1) = exptDataK{iTrials,2}.m_iWidth;
                        thisConditionID = numel(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStepConditionID);
                        
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep{end + 1} = [];
                    else
                        thisConditionID = find(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStepConditionID == exptDataK{iTrials,2}.m_iWidth);
                        
                    end
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardSteptrialCounter{thisConditionID} = ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardSteptrialCounter{thisConditionID} + 1;
                    
                    if any(spikesInThisTrial)
                        
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep{thisConditionID} = ...
                            vertcat(g_strctStatistics.m_strctTestObjectSpikeHolder.BarWidthSpikes(iUnit).m_afBackwardStep{thisConditionID}, ...
                            spikesInThisTrial);
                        
                    end
                end
            end
        case {'PlainBarMoveSpeed', 'MovingBarMoveSpeed'}
            %   if ~isfield(g_strctStatistics,'m_strctTestObjectSpikeHolder')
            %       g_strctStatistics.m_strctTestObjectSpikeHolder = [];
            %   end
            if ~isfield(g_strctStatistics.m_strctTestObjectSpikeHolder,'BarSpeedSpikes') || size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes,2) < iUnit
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStep = {};
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStep = {};
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepConditionID = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepConditionID = [];
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardSteptrialCounter = 0;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardSteptrialCounter = 0;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX = 1;
                g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX = 1;
                
            end
            % if ~isfield(g_strctStatistics,'m_strctTestObjectSpikeHolder')
            %     g_strctStatistics.m_strctTestObjectSpikeHolder = [];
            %  end
            
            if exptDataK{iTrials,2}.m_iLength == 0
                continue
            end
            if any(spikesInThisTrial)
                if sign(double(exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,5} == 1)) || exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,7}
                    if size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX,1) < exptDataK{iTrials,2}.m_iLength || ...
                            isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength))
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = 1;
                    end
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStep(exptDataK{iTrials,2}.m_iLength, ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) : ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial) -1) = ...
                        spikesInThisTrial;
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afForwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial);
                    
                elseif 	sign(double(exptDataK{iTrials,2}.m_acCurrentlyVariableFields{iTestObjects,5} == -1))
                    if size(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX,1) < exptDataK{iTrials,2}.m_iLength || ...
                            isempty(g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength))
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = 1;
                    end
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStep(exptDataK{iTrials,2}.m_iLength, ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) : ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial) -1) = ...
                        spikesInThisTrial;
                    
                    g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) = ...
                        g_strctStatistics.m_strctTestObjectSpikeHolder.BarSpeedSpikes(iUnit).m_afBackwardStepSpikeIDX(exptDataK{iTrials,2}.m_iLength) + numel(spikesInThisTrial);
                end
                
                
            end
    end
    
end
return;

function fnProcessImageTrial(trialToProcess, iUnit, spikesInThisTrial)
global g_strctStatistics unitsInUpdate

if ~isfield(g_strctStatistics,'m_strctImageAnalysis') || isempty(g_strctStatistics.m_strctImageAnalysis)
    g_strctStatistics.m_strctImageAnalysis = [];
    g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolder = zeros(200,3000,5);
    g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolderIDX = ones(200,5);
    g_strctStatistics.m_strctImageAnalysis.m_cstrImageCategories = {};
    g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames = {};
    g_strctStatistics.m_strctImageAnalysis.m_aiImageNameTrialCounter = [];
    g_strctStatistics.m_strctImageAnalysis.m_aiImageCategoryTrialCounter = [];
    %g_strctStatistics.m_strctImageAnalysis.m_aiSaturations = [];
    
    %g_strctStatistics.m_strctImageAnalysis.m_aiSaturations = [];
    
    
    
end

if isfield(trialToProcess,'m_strImageFileCategory') && isfield(trialToProcess,'m_strImageName') && isfield(trialToProcess,'m_iImageNameID')
    
    if any(ismember(g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames,trialToProcess.m_strImageName))
        nameID = find(ismember(g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames,trialToProcess.m_strImageName));
        
        g_strctStatistics.m_strctImageAnalysis.m_aiImageNameTrialCounter(nameID) = ...
            g_strctStatistics.m_strctImageAnalysis.m_aiImageNameTrialCounter(nameID) + 1;
    else
        g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames{end + 1} = trialToProcess.m_strImageName;
        nameID = numel(g_strctStatistics.m_strctImageAnalysis.m_cstrImageNames,1);
        g_strctStatistics.m_strctImageAnalysis.m_aiImageNameTrialCounter(end+1) = 1;
    end

    disp('processing spikes in trial')
    g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolder(nameID,g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolderIDX(nameID,unitsInUpdate(iUnit)) : ...
        g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolderIDX(nameID,unitsInUpdate(iUnit)) + numel(spikesInThisTrial) -1, unitsInUpdate(iUnit)) = spikesInThisTrial;
    
    g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolderIDX(nameID,unitsInUpdate(iUnit)) = ...
        g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolderIDX(nameID,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
end

return



function fnProcessDKLTrial(trialToProcess, iUnit, spikesInThisTrial)
global g_strctStatistics unitsInUpdate
%if ~isfield(trialToProcess,'m_aiStimxyY') && isfield(trialToProcess,'m_iXCoordinate') || isfield(trialToProcess,'m_aiStimXYZ') && ~any(isnan(trialToProcess.m_aiStimXYZ))

if isfield(trialToProcess,'m_afDKLSphereCoordinates') || ...
           (isfield(trialToProcess,'m_fDKLSaturation') &&  ...
           isfield(trialToProcess,'m_fDKLElevation') &&  ...
           isfield(trialToProcess,'m_fDKLAzimuth'))
    
    if isfield(trialToProcess,'m_afDKLSphereCoordinates')
        az = trialToProcess.m_afDKLSphereCoordinates(1);
        el = trialToProcess.m_afDKLSphereCoordinates(2);
        rad = trialToProcess.m_afDKLSphereCoordinates(3);
        
    else
		rad = trialToProcess.m_fDKLSaturation;
		el = trialToProcess.m_fDKLElevation;
		az =trialToProcess.m_fDKLAzimuth;

    end
  
    if isempty(g_strctStatistics.trackedDKLCoordinates) || ~any(ismember(g_strctStatistics.trackedDKLCoordinates,myRoundn([az,el,rad],-2),'rows'))
        uniquetrackedDKLCoordinates = [];
        if ~trialToProcess.m_bFlipForegroundBackground
            if size(trialToProcess.m_aiStimColor,1) > 1
                g_strctStatistics.m_aiDKLCoorindateColorMatchingTable = vertcat(g_strctStatistics.m_aiDKLCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2),...
                    
                trialToProcess.m_aiStimColor(round(size(trialToProcess.m_aiStimColor,1)/2),:)]);
            else
                g_strctStatistics.m_aiDKLCoorindateColorMatchingTable = vertcat(g_strctStatistics.m_aiDKLCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2), ...
                    trialToProcess.m_aiStimColor]);
            end
        else
            if size(trialToProcess.m_afBackgroundColor,1) > 1
                g_strctStatistics.m_aiDKLCoorindateColorMatchingTable = ...
                    vertcat(g_strctStatistics.m_aiDKLCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2),...
                    trialToProcess.m_afBackgroundColor(round(size(trialToProcess.m_afBackgroundColor,1)/2),:)]);
                
            else
                g_strctStatistics.m_aiDKLCoorindateColorMatchingTable = ...
                    vertcat(g_strctStatistics.m_aiDKLCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2),trialToProcess.m_afBackgroundColor]);
            end
        end
        g_strctStatistics.trackedDKLCoordinates = vertcat(g_strctStatistics.trackedDKLCoordinates,myRoundn([az,el,rad],-2));
        uniquetrackedDKLCoordinates = myRoundn(myUnique(g_strctStatistics.trackedDKLCoordinates,'rows','legacy'),-2);

        % sort by radius, elevation, azimuth
        [~, radIndex] = sort(uniquetrackedDKLCoordinates(:,3));
        uniquetrackedDKLCoordinates = uniquetrackedDKLCoordinates(radIndex,:);
        [uniqueRadii] = myUnique(uniquetrackedDKLCoordinates(:,3),'legacy');
        for iRadii = 1 : numel(uniqueRadii)
            
            thisRadiusIDX = uniquetrackedDKLCoordinates(:,3) == uniqueRadii(iRadii);
            tempELXYZ = uniquetrackedDKLCoordinates(thisRadiusIDX,:);
            [~, elIndex] = sort(tempELXYZ(:,2));
            
            uniqueEl = myUnique(uniquetrackedDKLCoordinates(thisRadiusIDX,2),'legacy');
            for iEl = 1:numel(uniqueEl)
                
                thisElIDX = uniquetrackedDKLCoordinates(thisRadiusIDX,2) == uniqueEl(iEl);
                [~, azIndex] = sort(uniquetrackedDKLCoordinates(thisRadiusIDX,1));
                
                tempAZXYZ = uniquetrackedDKLCoordinates(thisRadiusIDX,:);
                uniquetrackedDKLCoordinates(thisRadiusIDX,:) = tempAZXYZ(azIndex,:);
            end
            
            uniquetrackedDKLCoordinates(thisRadiusIDX,:) = tempELXYZ(elIndex,:);
            
        end
        
        g_strctStatistics.trackedDKLCoordinates = [];
        g_strctStatistics.trackedDKLCoordinates = uniquetrackedDKLCoordinates;
        
        [~,matchingTableIDX] = ismember(g_strctStatistics.trackedDKLCoordinates,g_strctStatistics.m_aiDKLCoorindateColorMatchingTable(:,1:3),'rows');

        g_strctStatistics.m_aiDKLCoorindateColorMatchingTable =  g_strctStatistics.m_aiDKLCoorindateColorMatchingTable(matchingTableIDX,:);

        % Got alotta conditions. allocate more space
        if size(matchingTableIDX,1) > size(g_strctStatistics.m_aiDKLCoorindateSpikeHolder,1)
            g_strctStatistics.m_aiDKLCoorindateSpikeHolder = vertcat(g_strctStatistics.m_aiDKLCoorindateSpikeHolder,zeros(200,5000,5));
            g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX = vertcat(g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX,ones(200, 5));
            g_strctStatistics.m_aiDKLCoorindateColorTrialCounter = vertcat(g_strctStatistics.m_aiDKLCoorindateColorTrialCounter,zeros(200,5));
        end
        g_strctStatistics.m_aiDKLCoorindateSpikeHolder(1:numel(matchingTableIDX),:,:) = g_strctStatistics.m_aiDKLCoorindateSpikeHolder(matchingTableIDX,:,:);
        g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(1:numel(matchingTableIDX),:) = g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(matchingTableIDX,:);
        g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(1:numel(matchingTableIDX),:) = g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(matchingTableIDX,:);
    end
    
    thisTrialIDX = find(g_strctStatistics.trackedDKLCoordinates(:,1) == myRoundn(az,-2) & ...
        g_strctStatistics.trackedDKLCoordinates(:,2) == myRoundn(el,-2) & ...
        g_strctStatistics.trackedDKLCoordinates(:,3) == myRoundn(rad,-2));
    
    g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(thisTrialIDX,unitsInUpdate(iUnit)) =...
        g_strctStatistics.m_aiDKLCoorindateColorTrialCounter(thisTrialIDX,unitsInUpdate(iUnit)) + 1;
    if any(spikesInThisTrial)
        
        g_strctStatistics.m_aiDKLCoorindateSpikeHolder(thisTrialIDX,g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)):...
            g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
            spikesInThisTrial ;
        
        g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) = ...
            g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
    end
end
return;



function fnProcessLUVTrial(trialToProcess, iUnit, spikesInThisTrial)
global g_strctStatistics unitsInUpdate
% Attempt to figure out this stimuli's LUV coordinates and color
%if size(trialToProcess.m_aiStimColor,1) > 1

%	RGB = trialToProcess.m_aiStimColor(round(size(trialToProcess.m_aiStimColor,1)/2),:);
%
%else
% RGB = trialToProcess.m_aiStimColor;
%end
%[XYZ] = RGB2XYZShort(RGB');
%{
                    strctTrial.LUVRadius = squeeze(g_strctParadigm.LUVRadius.Buffer(1,:,g_strctParadigm.LUVRadius.BufferIdx));
                    strctTrial.LUVElevation = squeeze(g_strctParadigm.LUVElevation.Buffer(1,:,g_strctParadigm.LUVElevation.BufferIdx));
                    strctTrial.LUVAzimuthSteps = squeeze(g_strctParadigm.LUVAzimuthSteps.Buffer(1,:,g_strctParadigm.LUVAzimuthSteps.BufferIdx));
%}
if isfield(trialToProcess,'m_bUseGaussianPulses') && trialToProcess.m_bUseGaussianPulses
    X = trialToProcess.m_iXCoordinate(ceil(numel(trialToProcess.m_iXCoordinate)/2));
    Y = trialToProcess.m_iYCoordinate(ceil(numel(trialToProcess.m_iYCoordinate)/2));
    Z = trialToProcess.m_iZCoordinate(ceil(numel(trialToProcess.m_iZCoordinate)/2));
    
    %elseif trialToProcess.m_iXCoordinate
    
end 
    

az = trialToProcess.m_fLUVAzimuth;
el = trialToProcess.m_fLUVElevation;
rad = trialToProcess.m_fLUVSaturation;

if isempty(g_strctStatistics.trackedLUVCoordinates) || ~any(ismember(g_strctStatistics.trackedLUVCoordinates,myRoundn([az,el,rad],-2),'rows'))
    uniquetrackedLUVCoordinates = [];
    if ~trialToProcess.m_bFlipForegroundBackground
        if size(trialToProcess.m_aiStimColor,1) > 1
            g_strctStatistics.m_aiLUVCoorindateColorMatchingTable = vertcat(g_strctStatistics.m_aiLUVCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2),...
                
            trialToProcess.m_aiStimColor(round(size(trialToProcess.m_aiStimColor,1)/2),:)]);
        else
            g_strctStatistics.m_aiLUVCoorindateColorMatchingTable = vertcat(g_strctStatistics.m_aiLUVCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2), ...
                trialToProcess.m_aiStimColor]);
        end
    else
        if size(trialToProcess.m_afBackgroundColor,1) > 1
            g_strctStatistics.m_aiLUVCoorindateColorMatchingTable = ...
                vertcat(g_strctStatistics.m_aiLUVCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2),...
                trialToProcess.m_afBackgroundColor(round(size(trialToProcess.m_afBackgroundColor,1)/2),:)]);
            
        else
            g_strctStatistics.m_aiLUVCoorindateColorMatchingTable = ...
                vertcat(g_strctStatistics.m_aiLUVCoorindateColorMatchingTable,[myRoundn([az,el,rad],-2),trialToProcess.m_afBackgroundColor]);
        end
    end
    g_strctStatistics.trackedLUVCoordinates = vertcat(g_strctStatistics.trackedLUVCoordinates,myRoundn([az,el,rad],-2));
    uniquetrackedLUVCoordinates = myRoundn(myUnique(g_strctStatistics.trackedLUVCoordinates,'rows','legacy'),-2);
    
    
    % sort by radius, elevation, azimuth
    [~, radIndex] = sort(uniquetrackedLUVCoordinates(:,3));
    uniquetrackedLUVCoordinates = uniquetrackedLUVCoordinates(radIndex,:);
    [uniqueRadii] = myUnique(uniquetrackedLUVCoordinates(:,3),'legacy');
    for iRadii = 1 : numel(uniqueRadii)
        
        thisRadiusIDX = uniquetrackedLUVCoordinates(:,3) == uniqueRadii(iRadii);
        tempELXYZ = uniquetrackedLUVCoordinates(thisRadiusIDX,:);
        [~, elIndex] = sort(tempELXYZ(:,2));
        
        uniqueEl = myUnique(uniquetrackedLUVCoordinates(thisRadiusIDX,2),'legacy');
        for iEl = 1:numel(uniqueEl)
            
            thisElIDX = uniquetrackedLUVCoordinates(thisRadiusIDX,2) == uniqueEl(iEl);
            [~, azIndex] = sort(uniquetrackedLUVCoordinates(thisRadiusIDX,1));
            
            tempAZXYZ = uniquetrackedLUVCoordinates(thisRadiusIDX,:);
            uniquetrackedLUVCoordinates(thisRadiusIDX,:) = tempAZXYZ(azIndex,:);
        end
        
        uniquetrackedLUVCoordinates(thisRadiusIDX,:) = tempELXYZ(elIndex,:);
        
    end
    
    g_strctStatistics.trackedLUVCoordinates = [];
    g_strctStatistics.trackedLUVCoordinates = uniquetrackedLUVCoordinates;
    
    [~,matchingTableIDX] = ismember(g_strctStatistics.trackedLUVCoordinates,g_strctStatistics.m_aiLUVCoorindateColorMatchingTable(:,1:3),'rows');
    
    
    g_strctStatistics.m_aiLUVCoorindateColorMatchingTable =  g_strctStatistics.m_aiLUVCoorindateColorMatchingTable(matchingTableIDX,:);
    
    
    % Got alotta conditions. allocate more space
    if size(matchingTableIDX,1) > size(g_strctStatistics.m_aiLUVCoorindateSpikeHolder,1)
        g_strctStatistics.m_aiLUVCoorindateSpikeHolder = vertcat(g_strctStatistics.m_aiLUVCoorindateSpikeHolder,zeros(200,5000,5));
        g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX = vertcat(g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX,ones(200, 5));
        g_strctStatistics.m_aiLUVCoorindateColorTrialCounter = vertcat(g_strctStatistics.m_aiLUVCoorindateColorTrialCounter,zeros(200,5));
    end
    g_strctStatistics.m_aiLUVCoorindateSpikeHolder(1:numel(matchingTableIDX),:,:) = g_strctStatistics.m_aiLUVCoorindateSpikeHolder(matchingTableIDX,:,:);
    g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(1:numel(matchingTableIDX),:) = g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(matchingTableIDX,:);
    g_strctStatistics.m_aiLUVCoorindateColorTrialCounter(1:numel(matchingTableIDX),:) = g_strctStatistics.m_aiLUVCoorindateColorTrialCounter(matchingTableIDX,:);
end

thisTrialIDX = find(g_strctStatistics.trackedLUVCoordinates(:,1) == myRoundn(az,-2) & ...
    g_strctStatistics.trackedLUVCoordinates(:,2) == myRoundn(el,-2) & ...
    g_strctStatistics.trackedLUVCoordinates(:,3) == myRoundn(rad,-2));

g_strctStatistics.m_aiLUVCoorindateColorTrialCounter(thisTrialIDX,unitsInUpdate(iUnit)) =...
    g_strctStatistics.m_aiLUVCoorindateColorTrialCounter(thisTrialIDX,unitsInUpdate(iUnit)) + 1;
if any(spikesInThisTrial)
    
    g_strctStatistics.m_aiLUVCoorindateSpikeHolder(thisTrialIDX,g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)):...
        g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
        spikesInThisTrial ;
    
    g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) = ...
        g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
    
    
    
end



return;