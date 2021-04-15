function fnAcceptDynamicTrialInformation(strctTrial)
global g_strctNeuralServer g_strctTrial g_strctStatistics unitsInUpdate
global spikes strctColorValues exptDataK

persistent strcTrialBackupInfo

if isempty(strctTrial)
    return;
end

exptDataK = strctTrial';
[n, TS, WF] = PL_GetWFEvs(g_strctNeuralServer.m_hSocket);

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


unitsInUpdate = unique(spikes.timeStamps(spikes.timeStamps(:,3) > 0 & spikes.timeStamps(:,3) < 10 & spikes.timeStamps(:,2) ~= 257,3));
g_strctStatistics.m_aiActiveUnits = unique([unitsInUpdate;g_strctStatistics.m_aiActiveUnits]);
numUnitsInUpdate = numel(unitsInUpdate);


exptDataP = zeros(g_strctNeuralServer.m_strctLastCheck.m_iWFCount,5);
for iUnit=1:numUnitsInUpdate
    if any(spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4))
        exptDataP(1:numel(spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4)),unitsInUpdate(iUnit)) =...
            spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4);
        exptDataP(:,unitsInUpdate(iUnit)) = exptDataP(:,unitsInUpdate(iUnit)) - initTimeP;
        
    end
end


strobeDataP = horzcat([TS(TS(:,2) == 257,3),TS(TS(:,2) == 257,4)]);


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
               % fnProcessImageTrial();
                
                
                
            end
            if isfield(exptDataK{iTrials,2},'m_bRandomStimulusPosition') && exptDataK{iTrials,2}.m_bRandomStimulusPosition
                
                %g_strctStatistics.m_strctPositionMapping.m_aiPositionBins = [
                
                
                
                
                
                
                
            end
            
            if ~isfield(exptDataK{iTrials,2},'m_aiStimxyY') && isfield(exptDataK{iTrials,2},'m_iXCoordinate') || isfield(exptDataK{iTrials,2},'m_aiStimXYZ')
                % Attempt to figure out this stimuli's DKL coordinates and color
                %if size(exptDataK{iTrials,2}.m_aiStimColor,1) > 1
                
                %	RGB = exptDataK{iTrials,2}.m_aiStimColor(round(size(exptDataK{iTrials,2}.m_aiStimColor,1)/2),:);
                %
                %else
                % RGB = exptDataK{iTrials,2}.m_aiStimColor;
                %end
                %[XYZ] = RGB2XYZShort(RGB');
                %{
                    strctTrial.dklRadius = squeeze(g_strctParadigm.DKLRadius.Buffer(1,:,g_strctParadigm.DKLRadius.BufferIdx));
                    strctTrial.dklElevation = squeeze(g_strctParadigm.DKLElevation.Buffer(1,:,g_strctParadigm.DKLElevation.BufferIdx));
                    strctTrial.dklAzimuthSteps = squeeze(g_strctParadigm.DKLAzimuthSteps.Buffer(1,:,g_strctParadigm.DKLAzimuthSteps.BufferIdx));
                %}
                if isfield(exptDataK{iTrials,2},'m_bUseGaussianPulses') && exptDataK{iTrials,2}.m_bUseGaussianPulses
                    X = exptDataK{iTrials,2}.m_iXCoordinate(ceil(numel(exptDataK{iTrials,2}.m_iXCoordinate)/2));
                    Y = exptDataK{iTrials,2}.m_iYCoordinate(ceil(numel(exptDataK{iTrials,2}.m_iYCoordinate)/2));
                    Z = exptDataK{iTrials,2}.m_iZCoordinate(ceil(numel(exptDataK{iTrials,2}.m_iZCoordinate)/2));
                    
                    %elseif exptDataK{iTrials,2}.m_iXCoordinate
                    
                    
                    
                    
                elseif isfield(exptDataK{iTrials,2},'m_aiStimXYZ')
                    X = exptDataK{iTrials,2}.m_aiStimXYZ(1);
                    Y = exptDataK{iTrials,2}.m_aiStimXYZ(2);
                    Z = exptDataK{iTrials,2}.m_aiStimXYZ(3);
                    
                else
                    X = exptDataK{iTrials,2}.m_iXCoordinate(exptDataK{iTrials,2}.m_iCurrentlySelectedDKLCoordinateID);
                    Y =	exptDataK{iTrials,2}.m_iYCoordinate(exptDataK{iTrials,2}.m_iCurrentlySelectedDKLCoordinateID);
                    Z =	exptDataK{iTrials,2}.m_iZCoordinate;
                    
                    
                end
                [az, el, rad] = cart2sph(X,Y,Z);
                
                
                %rad = exptDataK{iTrials,2}.dklRadius;
                %el = exptDataK{iTrials,2}.dklElevation
                %az =
                if isempty(g_strctStatistics.trackedXYZCoordinates) || ~any(ismember(g_strctStatistics.trackedXYZCoordinates,roundn([az,el,rad],-2),'rows'))
                    uniqueTrackedXYZCoordinates = [];
                    if ~exptDataK{iTrials,2}.m_bFlipForegroundBackground
                        if size(exptDataK{iTrials,2}.m_aiStimColor,1) > 1
                            g_strctStatistics.m_aiXYZCoorindateColorMatchingTable = vertcat(g_strctStatistics.m_aiXYZCoorindateColorMatchingTable,[roundn([az,el,rad],-2),...
                                exptDataK{iTrials,2}.m_aiStimColor(round(size(exptDataK{iTrials,2}.m_aiStimColor,1)/2),:)]);
                            
                        else
                            g_strctStatistics.m_aiXYZCoorindateColorMatchingTable = vertcat(g_strctStatistics.m_aiXYZCoorindateColorMatchingTable,[roundn([az,el,rad],-2),exptDataK{iTrials,2}.m_aiStimColor]);
                        end
                    else
                        if size(exptDataK{iTrials,2}.m_afBackgroundColor,1) > 1
                            g_strctStatistics.m_aiXYZCoorindateColorMatchingTable = ...
                                vertcat(g_strctStatistics.m_aiXYZCoorindateColorMatchingTable,[roundn([az,el,rad],-2),...
                                exptDataK{iTrials,2}.m_afBackgroundColor(round(size(exptDataK{iTrials,2}.m_afBackgroundColor,1)/2),:)]);
                            
                        else
                            g_strctStatistics.m_aiXYZCoorindateColorMatchingTable = ...
                                vertcat(g_strctStatistics.m_aiXYZCoorindateColorMatchingTable,[roundn([az,el,rad],-2),exptDataK{iTrials,2}.m_afBackgroundColor]);
                        end
                    end
                    g_strctStatistics.trackedXYZCoordinates = vertcat(g_strctStatistics.trackedXYZCoordinates,roundn([az,el,rad],-2));
                    uniqueTrackedXYZCoordinates = roundn(unique(g_strctStatistics.trackedXYZCoordinates,'rows'),-2);
                    
                    
                    % sort by radius, elevation, azimuth
                    [~, radIndex] = sort(uniqueTrackedXYZCoordinates(:,3));
                    uniqueTrackedXYZCoordinates = uniqueTrackedXYZCoordinates(radIndex,:);
                    [uniqueRadii] = unique(uniqueTrackedXYZCoordinates(:,3));
                    for iRadii = 1 : numel(uniqueRadii)
                        
                        thisRadiusIDX = uniqueTrackedXYZCoordinates(:,3) == uniqueRadii(iRadii);
                        tempELXYZ = uniqueTrackedXYZCoordinates(thisRadiusIDX,:);
                        [~, elIndex] = sort(tempELXYZ(:,2));
                        
                        uniqueEl = unique(uniqueTrackedXYZCoordinates(thisRadiusIDX,2));
                        for iEl = 1:numel(uniqueEl)
                            
                            thisElIDX = uniqueTrackedXYZCoordinates(thisRadiusIDX,2) == uniqueEl(iEl);
                            [~, azIndex] = sort(uniqueTrackedXYZCoordinates(thisRadiusIDX,1));
                            
                            tempAZXYZ = uniqueTrackedXYZCoordinates(thisRadiusIDX,:);
                            uniqueTrackedXYZCoordinates(thisRadiusIDX,:) = tempAZXYZ(azIndex,:);
                        end
                        
                        uniqueTrackedXYZCoordinates(thisRadiusIDX,:) = tempELXYZ(elIndex,:);
                        
                    end
                    
                    g_strctStatistics.trackedXYZCoordinates = [];
                    g_strctStatistics.trackedXYZCoordinates = uniqueTrackedXYZCoordinates;
                    
                    [~,matchingTableIDX] = ismember(g_strctStatistics.trackedXYZCoordinates,g_strctStatistics.m_aiXYZCoorindateColorMatchingTable(:,1:3),'rows');
                    
                    
                    g_strctStatistics.m_aiXYZCoorindateColorMatchingTable =  g_strctStatistics.m_aiXYZCoorindateColorMatchingTable(matchingTableIDX,:);
                    
                    
                    % Got alotta conditions. allocate more space
                    if size(matchingTableIDX,1) > size(g_strctStatistics.m_aiXYZCoorindateSpikeHolder,1)
                        g_strctStatistics.m_aiXYZCoorindateSpikeHolder = vertcat(g_strctStatistics.m_aiXYZCoorindateSpikeHolder,zeros(200,5000,5));
                        g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX = vertcat(g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX,ones(200, 5));
                        g_strctStatistics.m_aiXYZCoorindateColorTrialCounter = vertcat(g_strctStatistics.m_aiXYZCoorindateColorTrialCounter,zeros(200,5));
                    end
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolder(1:numel(matchingTableIDX),:,:) = g_strctStatistics.m_aiXYZCoorindateSpikeHolder(matchingTableIDX,:,:);
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(1:numel(matchingTableIDX),:) = g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(matchingTableIDX,:);
                    g_strctStatistics.m_aiXYZCoorindateColorTrialCounter(1:numel(matchingTableIDX),:) = g_strctStatistics.m_aiXYZCoorindateColorTrialCounter(matchingTableIDX,:);
                end
                
                thisTrialIDX = find(g_strctStatistics.trackedXYZCoordinates(:,1) == roundn(az,-2) & ...
                    g_strctStatistics.trackedXYZCoordinates(:,2) == roundn(el,-2) & ...
                    g_strctStatistics.trackedXYZCoordinates(:,3) == roundn(rad,-2));
                
                
                
                
                
                g_strctStatistics.m_aiXYZCoorindateColorTrialCounter(thisTrialIDX,unitsInUpdate(iUnit)) =...
                    g_strctStatistics.m_aiXYZCoorindateColorTrialCounter(thisTrialIDX,unitsInUpdate(iUnit)) + 1;
                if any(spikesInThisTrial)
                    
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolder(thisTrialIDX,g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)):...
                        g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
                        spikesInThisTrial ;
                    
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(thisTrialIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
                    
                    
                    %{
					XYZ = [exptDataK{iTrials,2}.m_iXCoordinate,...
							exptDataK{iTrials,2}.m_iYCoordinate,...
							exptDataK{iTrials,2}.m_iZCoordinate];
                        %}
                        %[xyY]= thXYZToxyY(XYZ);
                        %x = xyY(1);
                        % y = xyY(2);
                        % Y = xyY(3);
                        %exptDataK{iTrials,2}.m_aiStimxyY = [x, y, Y];
                        %[x, y, Y]
                        
                end
            end
            if isfield(exptDataK{iTrials,2},'m_bRandomStimulusPosition') && exptDataK{iTrials,2}.m_bRandomStimulusPosition
                fnProcessPositionTrial(iTrials, unitsInUpdate(iUnit),  spikesInThisTrial);
                
            end
            
            if isfield(exptDataK{iTrials,2},'m_bVariableTestObject') && exptDataK{iTrials,2}.m_bVariableTestObject
                fnProcessVariableTestObjectTrial(iTrials, unitsInUpdate(iUnit),  spikesInThisTrial);
                
            end
            
            if isfield(exptDataK{iTrials,2},'m_aiStimxyY')
                
                
                roundedThisTrialxyY = roundn(exptDataK{iTrials,2}.m_aiStimxyY,-3);
                %roundedTrackedxyYCoordinates = roundn(g_strctStatistics.trackedxyYCoordinates,-3);
                
                
                if isempty(g_strctStatistics.trackedxyYCoordinates) || ~ismember(roundedThisTrialxyY,g_strctStatistics.trackedxyYCoordinates,'rows')
                    if ismember(roundedThisTrialxyY,roundn(strctColorValues.allxyYCoordinates,-3),'rows')
                        colorIDX = find(ismember(roundn(strctColorValues.allxyYCoordinates(:,1),-3),roundedThisTrialxyY(:,1)) &...
                            ismember(roundn(strctColorValues.allxyYCoordinates(:,2),-3),roundedThisTrialxyY(:,2))&...
                            ismember(roundn(strctColorValues.allxyYCoordinates(:,3),-3),roundedThisTrialxyY(:,3)),1);
                        g_strctStatistics.trackedxyYCoordinates(colorIDX,:) = roundedThisTrialxyY;
                    else
                        g_strctStatistics.trackedxyYCoordinates = [g_strctStatistics.trackedxyYCoordinates;roundedThisTrialxyY];
                    end
                    
                end
                %{
					colorIDX = ismember(roundn(strctColorValues.allxyYCoordinates(:,1),-3),roundedThisTrialxyY(:,1)) &...
                        ismember(roundn(strctColorValues.allxyYCoordinates(:,2),-3),roundedThisTrialxyY(:,2))&...
                        ismember(roundn(strctColorValues.allxyYCoordinates(:,3),-3),roundedThisTrialxyY(:,3));
                %}
                allColorIDX = ismember(roundn(strctColorValues.allxyYCoordinates(:,1),-3),g_strctStatistics.trackedxyYCoordinates(:,1)) &...
                    ismember(roundn(strctColorValues.allxyYCoordinates(:,2),-3),g_strctStatistics.trackedxyYCoordinates(:,2))&...
                    ismember(roundn(strctColorValues.allxyYCoordinates(:,3),-3),g_strctStatistics.trackedxyYCoordinates(:,3));
                if any(allColorIDX)
                    % g_strctStatistics.trackedxyYCoordinates = [g_strctStatistics.trackedxyYCoordinates; roundedThisTrialxyY];
                    
                    
                    
                    %{
						  	allColorIDX = ismember(roundn(strctColorValues.allxyYCoordinates(:,1),-3),roundedThisTrialxyY(:,1)) &...
						   ismember(roundn(strctColorValues.allxyYCoordinates(:,2),-3),roundedThisTrialxyY(:,2))&...
						   ismember(roundn(strctColorValues.allxyYCoordinates(:,3),-3),roundedThisTrialxyY(:,3));
                    %}
                    
                    
                    % g_strctStatistics.trackedxyYCoordinates = roundn(strctColorValues.allxyYCoordinates(allColorIDX,:),-3);
                    
                    thisTrialxyYIDX = find(roundedThisTrialxyY(1) ==  g_strctStatistics.trackedxyYCoordinates(:,1) &...
                        roundedThisTrialxyY(2) == g_strctStatistics.trackedxyYCoordinates(:,2)   &...
                        roundedThisTrialxyY(3) == g_strctStatistics.trackedxyYCoordinates(:,3)  );
                    %thisTrialxyYIDX
                    g_strctStatistics.m_aixyYCoorindateColorMatchingTable = [strctColorValues.allxyYCoordinates(allColorIDX,:),strctColorValues.allRGBValues(allColorIDX,:)];
                    g_strctStatistics.m_aixyYCoorindateColorTrialCounter(thisTrialxyYIDX,unitsInUpdate(iUnit)) =...
                        g_strctStatistics.m_aixyYCoorindateColorTrialCounter(thisTrialxyYIDX,unitsInUpdate(iUnit)) + 1;
                    
                else
                    
                    
                    g_strctStatistics.uniquexyYCoordinates = [g_strctStatistics.uniquexyYCoordinates;roundedThisTrialxyY];
                    g_strctStatistics.trackedxyYCoordinates = vertcat(roundn(strctColorValues.allxyYCoordinates(colorIDX,:),-3),...
                        g_strctStatistics.uniquexyYCoordinates);
                    numUniquexyYPresetColors = size(strctColorValues.allxyYCoordinates,1);
                    g_strctStatistics.m_aixyYCoorindateColorMatchingTable(numUniquexyYPresetColors + g_strctStatistics.numTrackedNonPresetColors,1:3) = roundedThisTrialxyY;
                    g_strctStatistics.m_aixyYCoorindateColorMatchingTable(numUniquexyYPresetColors + g_strctStatistics.numTrackedNonPresetColors,4:6) = exptDataK{iTrials,2}.m_aiStimColor;
                    g_strctStatistics.numTrackedNonPresetColors = g_strctStatistics.numTrackedNonPresetColors + 1;
                    thisTrialxyYIDX = find(roundedThisTrialxyY(1) ==  g_strctStatistics.trackedxyYCoordinates(:,1) &...
                        roundedThisTrialxyY(2) == g_strctStatistics.trackedxyYCoordinates(:,2)   &...
                        roundedThisTrialxyY(3) == g_strctStatistics.trackedxyYCoordinates(:,3)  );
                    
                end
                
                
                
                
                
                
                
                
                
                
                
                g_strctStatistics.m_aixyYCoorindateSpikeHolder(thisTrialxyYIDX,g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)):...
                    g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
                    spikesInThisTrial ;
                
                g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)) = ...
                    g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
                
                %{
                    g_strctStatistics.m_aiColorSpikeHolder(exptDataK{iTrials,2}.m_iSelectedColorIndex,...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)):...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit))+numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
                        spikesInThisTrial ;
                    
                    g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
                    %}
                    
                    
                    
                    
                    
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

%{
numCurrentlyTrackedColorUnits = max([max(find(max(max(g_strctStatistics.m_aixyYCoorindateSpikeHolder)))),numUnitsInUpdate]);
numCurrentlyTrackedOrientationUnits = max([max(find(max(max(g_strctStatistics.m_aiOrientationSpikeHolder)))),numUnitsInUpdate]);
numCurrentlyTrackedXYZUnits = max([max(find(max(max(g_strctStatistics.m_aiXYZCoorindateSpikeHolder)))),numUnitsInUpdate]);
g_strctStatistics.numCurrentlyTrackedUnits = max([numCurrentlyTrackedColorUnits, numCurrentlyTrackedOrientationUnits, numCurrentlyTrackedXYZUnits]);
%}
%{
if g_strctStatistics.numCurrentlyTrackedUnits == 0 || isempty(g_strctStatistics.numCurrentlyTrackedUnits)
    g_strctStatistics.numCurrentlyTrackedUnits = 1;
end
%}

%g_strctStatistics.numCurrentlyTrackedUnits = max([g_strctStatistics.numCurrentlyTrackedUnits,max(unitsInUpdate)]);

%{
if ~any(any(g_strctStatistics.trackedxyYCoordinates)) && ~any(numCurrentlyTrackedOrientationUnits) && ~any(any(g_strctStatistics.trackedXYZCoordinates))
    return;
    
end
%}
PSTHOrientationHolder = [];
activeConditionsIDX = find(~isnan(g_strctStatistics.trackedxyYCoordinates(:,1)));
activeConditionsXYZIDX =  1:size(g_strctStatistics.trackedXYZCoordinates,1);
%{
if isempty(activeConditionsIDX)
    activeConditionsIDX = 0
end
if isempty(activeConditionsXYZIDX)
activeConditionsXYZIDX = 0;
end
%}
%{
g_strctStatistics.m_strctEnabledPlots.m_bPSTHEnabled = 1;
g_strctStatistics.m_strctEnabledPlots.m_bOrientationPolarEnabled = 1;
g_strctStatistics.m_strctEnabledPlots.m_bISIPlotEnabled = 0;
g_strctStatistics.m_strctEnabledPlots.m_bPositionHeatmapEnabled = 0;
%}
fields = fieldnames(g_strctStatistics.m_strctEnabledPlots);
g_strctStatistics.numEnabledPlots = 0;

for iFields = 1:size(fields,1)
    g_strctStatistics.numEnabledPlots = g_strctStatistics.numEnabledPlots + g_strctStatistics.m_strctEnabledPlots.(fields{iFields});
end
g_strctStatistics.numCurrentlyTrackedUnits = max(max([g_strctStatistics.m_aiActiveUnits;unitsInUpdate]));
g_strctStatistics.PSTHColorHolder = zeros(sum([numel(activeConditionsIDX),numel(activeConditionsXYZIDX)]),50,max(unitsInUpdate));
subplotIDX = 1;
for iUnit = 1:numUnitsInUpdate
    g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numEnabledPlots;
    if g_strctStatistics.m_strctEnabledPlots.m_bPSTHEnabled
        
        if ~isempty(activeConditionsIDX)
            for iConditions = 1:size(activeConditionsIDX,1)
                maxVal = max(g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0));
                
                minVal = min(	g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0));
                
                %{
            if  g_strctStatistics.curTrialWindow < maxVal
				g_strctStatistics.curTrialWindow = roundn(maxVal,-2);
			end
			
			if  g_strctStatistics.preTrialWindow > minVal
				g_strctStatistics.preTrialWindow = roundn(minVal,-2);
			
			end
                    %}
                    
                    
                    % Force the spikes in the condition onto a template with the desired time range, so all the spikes have the same time x-range
                    TrialTimeTemplate = [];
                    %fprintf('maxval = %f, minval = %f\n', maxVal, minVal)
                    %if any(maxVal) & any(minVal)
                    % if g_strctStatistics.curTrialWindow >= maxVal && g_strctStatistics.preTrialWindow <=  minVal
                    
                    
                    TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
                    
                    tempSpikes = [g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),...
                        :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                    
                    % histogram and subtract out our template
                    g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        hist(tempSpikes,50);
                    
                    g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) - 1;
                    % else
                    %{
                    tempSpikes = [g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),...
                        :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                    
                    g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
                        hist(tempSpikes,50);
                    %}
                    % end
                    %end
                    
                    
                    
                    %{
		 g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
            hist(g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),:,unitsInUpdate(iUnit)) ~= 0,...
            unitsInUpdate(iUnit)),50);
		
                    %}
                    
                    
                    g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = g_strctStatistics.PSTHColorHolder(iConditions, :, unitsInUpdate(iUnit)) /...
                        g_strctStatistics.m_aixyYCoorindateColorTrialCounter(activeConditionsIDX(iConditions),unitsInUpdate(iUnit));
            end
        end
        TrialTimeTemplate = [];
        TrialTimeTemplate = linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,50);
        
        
        
        tempSpikes = cat(2,repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1]),g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,:, unitsInUpdate(iUnit)));
        % tempSpikes = cat(2,g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,:, unitsInUpdate(iUnit)),repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1]));
        
        for iXYZConditions = 1:numel(activeConditionsXYZIDX)
            % histogram and subtract out our template
            g_strctStatistics.PSTHColorHolder(iXYZConditions+numel(activeConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                histcounts(tempSpikes(iXYZConditions,1:(g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX(iXYZConditions, unitsInUpdate(iUnit))-1)+numel(TrialTimeTemplate)),50)-1;
            %{
            g_strctStatistics.PSTHColorHolder(iXYZConditions+numel(activeConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                g_strctStatistics.PSTHColorHolder(iXYZConditions+numel(activeConditionsIDX),:,unitsInUpdate(iUnit)) - 1;
                %}
                
                
                
                
                g_strctStatistics.PSTHColorHolder(iXYZConditions + numel(activeConditionsIDX),:,unitsInUpdate(iUnit)) = g_strctStatistics.PSTHColorHolder(iXYZConditions+numel(activeConditionsIDX), :, unitsInUpdate(iUnit)) /...
                    g_strctStatistics.m_aiXYZCoorindateColorTrialCounter(activeConditionsXYZIDX(iXYZConditions),unitsInUpdate(iUnit));
        end
        
        
        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(2+((unitsInUpdate(iUnit)-1)*10)+...
            (g_strctStatistics.numCurrentlyTrackedUnits *...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)))...
            :(unitsInUpdate(iUnit)*10 + (g_strctStatistics.numCurrentlyTrackedUnits *...
            (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows))));
        
        %{
                                        
                                        subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(2+((unitsInUpdate(iUnit)-1)*10)+...
										(g_strctStatistics.numCurrentlyTrackedUnits *...
                                        (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows-1)))...
										:(unitsInUpdate(iUnit)*10 + (g_strctStatistics.numCurrentlyTrackedUnits *...
                                        (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows-1))));
                                        
                                        
            %}
            
            imagesc(g_strctStatistics.PSTHColorHolder(:,:,unitsInUpdate(iUnit)));
            set(gca,'YTick',[])
            NumTicks = 11;%(numBins/20)+1;
            L = get(gca,'XLim');
            set(gca,'XTick',linspace(L(1),L(2),NumTicks-1))
            set(gca,'XTickLabelMode','manual')
            set(gca,'XTickLabel',roundn(linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,NumTicks-1),-2))
            
            subplot(g_strctStatistics.numEnabledPlots,g_strctStatistics.numCurrentlyTrackedUnits*10,(1+((unitsInUpdate(iUnit)-1)*10)) + (g_strctStatistics.numCurrentlyTrackedUnits *...
                (g_strctStatistics.numEnabledPlots-g_strctStatistics.numAvailableSubplotRows)));
            
            
            
            
            [colorBar] = fnMakeColorBar(vertcat(g_strctStatistics.m_aixyYCoorindateColorMatchingTable(find(g_strctStatistics.m_aixyYCoorindateColorMatchingTable(:,1)),:),...
                g_strctStatistics.m_aiXYZCoorindateColorMatchingTable));
            imagesc(colorBar);
            set(gca,'xTickLabel','')
            set(gca,'yTickLabel','')
            set(gca,'XTick',[])
            set(gca,'YTick',[])
            
            
            g_strctStatistics.numAvailableSubplotRows = g_strctStatistics.numAvailableSubplotRows - 1;
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
            % tempSpikes = cat(2,repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1]),g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,:, unitsInUpdate(iUnit)));
            
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
        %set(gca,'XTickLabel',roundn(linspace(g_strctStatistics.preTrialWindow,g_strctStatistics.curTrialWindow,NumTicks-1),-2))
        
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
    
    
    
    if g_strctStatistics.m_strctEnabledPlots.m_bImagePlotEnabled && isfield(g_strctStatistics,'m_strctImageAnalysis') && ~isempty(g_strctStatistics.m_strctImageAnalysis)
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

%{
function [ld,rg,yv] = rgb2ldrgyv(rgb)
global g_strctStatistics

matrix = g_strctStatistics.m_strctConversionMatrices.ldgyb;


[s1 s2 thirdD] = size(r);
dkl = reshape((M_rgb2dkl*(2*(reshape(r,s1*s2,thirdD)-0.5))')',s1,s2,thirdD);

rgb = (matrix*ldrgyv/2.0 )/2
rgb = ((matrix*ldrgyv/2.0 )/2)
return;
%}
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
dbstop if warning
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

function fnProcessImageTrial()
global g_strctStatistics exptDataK

if ~isfield(g_strctStatistics,'m_strctImageAnalysis')
    g_strctStatistics.m_strctImageAnalysis = [];
    g_strctStatistics.m_strctImageAnalysis.m_aiSpikeHolder = zeros(200,3000);
    g_strctStatistics.m_strctImageAnalysis.m_cstrImageCategories = {};
	g_strctStatistics.m_strctImageAnalysis.m_aiSaturations = [];
	
	g_strctStatistics.m_strctImageAnalysis.m_aiSaturations = [];
	
    
    
end
%{
if ~ismember(g_strctStatistics.m_strctImageAnalysis.m_cstrImageCategories, exptDataK{iTrials,2}.m_strImageName)
	[stringSegments] = strsplit(exptDataK{iTrials,2}.m_strImageName, '-')
	if ismember(
	placeHolderONE = 
	placeHolderTWO = 
	placeHolderTHREE = 
	placeHolderFOUR = 
	

end
%}
return


function defunctcode
%{
        maxVal = max(g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),...
            :,unitsInUpdate(iUnit)) ~= 0));
        
        minVal = min(	g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),...
            :,unitsInUpdate(iUnit)) ~= 0));
%}
%{
            if  g_strctStatistics.curTrialWindow < maxVal
				g_strctStatistics.curTrialWindow = roundn(maxVal,-2);
			end
			
			if  g_strctStatistics.preTrialWindow > minVal
				g_strctStatistics.preTrialWindow = roundn(minVal,-2);
			
			end
%}
% Force the spikes in the condition onto a template with the desired time range, so all the spikes have the same time x-range

%fprintf('maxval = %f, minval = %f\n', maxVal, minVal)

%if any(maxVal) & any(minVal)
%   if g_strctStatistics.curTrialWindow >= maxVal && g_strctStatistics.preTrialWindow <=  minVal
%{
            bleh = zeros(
            for izTest = 1:numel(activeConditionsXYZIDX)
                bleh
                
            end
            
            funFunc = @(x) x
            tempSpikes1 = arrayfun(@cat, (g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,:, unitsInUpdate(iUnit))),repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1]),2)
            tempSpikes1 = arrayfun(@(x) cat(2,g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,:, unitsInUpdate(iUnit)),repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1])))
           tempSpikes2 = bsxfun(@(x) histcounts(cat(2,g_strctStatistics.m_aiXYZCoorindateSpikeHolder(x,:, unitsInUpdate(iUnit)),repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1]))))
                       tempSpikes2 = bsxfun(@(x) histcounts(cat(2,g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,:, unitsInUpdate(iUnit)),repmat(TrialTimeTemplate,[numel(activeConditionsXYZIDX),1]))))

            
            
            tempSpikes1 = arrayfun(@horzcat, g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,...
                :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate)
            
            tempSpikes = [g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),...
                :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
            
             tempSpikes = [g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX,...
                :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
%}

%  else

%{
                tempSpikes = [g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),g_strctStatistics.m_aiXYZCoorindateSpikeHolder(activeConditionsXYZIDX(iXYZConditions),...
                    :,unitsInUpdate(iUnit)) ~= 0, unitsInUpdate(iUnit)),TrialTimeTemplate];
                
                g_strctStatistics.PSTHColorHolder(iXYZConditions+numel(activeConditionsIDX),:,unitsInUpdate(iUnit)) = ...
                    hist(tempSpikes,50);
            end
        end
%}


%{
		 g_strctStatistics.PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = ...
            hist(g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),g_strctStatistics.m_aixyYCoorindateSpikeHolder(activeConditionsIDX(iConditions),:,unitsInUpdate(iUnit)) ~= 0,...
            unitsInUpdate(iUnit)),50);
		
%}
return

