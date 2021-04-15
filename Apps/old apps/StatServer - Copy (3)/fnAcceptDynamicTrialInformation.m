function fnAcceptDynamicTrialInformation(strctTrial)
global g_strctNeuralServer g_strctTrial g_strctStatistics
global spikes

persistent strcTrialBackupInfo
%{
eventWindowPre =  50/1000;
eventWindowDur = 200/1000;
eventWindowPost = 200/1000;
spikeWindowSize = 32;
orientations = 18;
%}
colors = [64193	44835	50298
    61632	47052	42918
    57188	49461	34694
    51103	51700	26748
    43610	53576	22521
    35078	54690	26239
    25877	54952	33964
    18583	54675	42194
    21422	53430	49536
    30281	51556	55732
    39294	49337	60547
    47529	47010	63700
    54366	44869	64810
    59570	43223	63894
    63119	42678	60983
    64698	43257	56446];


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

exptDataK(cellfun('isempty',exptDataK)) = []; exptDataK(:,2)=exptDataK(:,1);
for iTrials=1:size(exptDataK,1)
    exptDataK{iTrials,1} = exptDataK{iTrials,2}.m_fImageFlipON_TS_Kofiko;
end
%{
		if ~isempty(g_strctNeuralServer.m_afCurrentServerTime)
			fnGetSpikesFromPlexon();
			%[NumSpikeAndStrobeEvents, a2fSpikeAndEvents, a2fWaveForms] =PL_GetWFEvs(g_strctNeuralServer.m_hSocket);
			%fnParseSpikesAndTrials();
		end
%}

% = max(spikes.timeStamps(spikes.timeStamps(:,1) == 1,3));

unitsInUpdate = unique(spikes.timeStamps(spikes.timeStamps(:,3) > 0 & spikes.timeStamps(:,3) < 10,3));
%disp(sprintf('units in this update = %i \n', unitsInUpdate))
numUnitsInUpdate = numel(unitsInUpdate);
%disp(sprintf('number units in this update = %i \n', numUnitsInUpdate))

exptDataP = zeros(g_strctNeuralServer.m_strctLastCheck.m_iWFCount,5);
for iUnit=1:numUnitsInUpdate
    if any(spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4))
        exptDataP(1:numel(spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4)),unitsInUpdate(iUnit)) =...
            spikes.timeStamps(spikes.timeStamps(:,3) == unitsInUpdate(iUnit),4);
        exptDataP(:,unitsInUpdate(iUnit)) = exptDataP(:,unitsInUpdate(iUnit)) - initTimeP;
        % exptDataPUnit2(:,1) = spikes.timeStamps(spikes.timeStamps(:,3) == 2,4);
        %  exptDataP(i,1) = {spikes(spikes.timeStamps(:,3) == 1).timeStamps(i,4)};
        %exptDataP(:,2) = spikes.Waves(spikes.timeStamps(:,3) == 1,:);
    end
end


strobeDataP = horzcat([TS(TS(:,2) == 257,3),TS(TS(:,2) == 257,4)]);
%strobeDataP=horzcat(events.timeStamps,events.strobeNumber);
%syncStrobeIdxP = strobeDataP(:,1) == g_strctNeuralServer.m_iSyncStrobeCode;
%initTimeP = strobeDataP(find(syncStrobeIdxP == 1,1),2);
%initTimeP = strobeDataP(find(syncStrobeIdxP == 1,1),2);

%{
exptDataK=vertcat(exptDataK,num2cell(strobeDataK));
[~,ix]=sort(cell2mat(exptDataK(:,1)));
exptDataK=exptDataK(ix,:);
%}

exptDataK(:,1)=num2cell(cell2mat(exptDataK(:,1))-initTimeK); % normalize timestamps to first 'Sync' strobe
%{
exptDataP=vertcat(exptDataP,num2cell(strobeDataP));
[~,ix]=sort(cell2mat(exptDataP(:,1)));
exptDataP=exptDataP(ix,:);
%}
%exptDataP(:,1)=num2cell(cell2mat(exptDataP(:,1))-initTimeP); % normalize timestamps to first 'Sync' strobe
%exptDataP(:,1) = num2cell((cell2mat(exptDataP(:,1))- initTimeP) + g_strctNeuralServer.m_afCurrentServerTime(2));

%exptDataPUnit2(:,1) = exptDataPUnit2(:,1) - initTimeP;
orientations = 20;
%oldfighandle = gcf;
%figure(g_strctStatistics.m_hColorPSTHFigureHandle);
preTrialWindow = .050;
postTrialWindow = .200;

for iTrials = 1:size(exptDataK,1)
    spikesInThisTrial = [];
    if isfield(exptDataK{iTrials,2},'m_bMonkeyFixated') && exptDataK{iTrials,2}.m_bMonkeyFixated
        
        
        for iUnit = 1:numUnitsInUpdate
            
            spikesInThisTrial = exptDataP(exptDataP(:,unitsInUpdate(iUnit)) - exptDataK{iTrials,1} >= -preTrialWindow & ...
                exptDataP(:,unitsInUpdate(iUnit)) -  exptDataK{iTrials,1} <=  exptDataK{iTrials,2}.m_iTrialLength_MS/1000,unitsInUpdate(iUnit)) - exptDataK{iTrials,1};
            
         %    spikesInThisTrial{iUnit,1} = exptDataP(exptDataP(:,unitsInUpdate(iUnit)) - exptDataK{iTrials,1} >= -preTrialWindow & ...
          %      exptDataP(:,unitsInUpdate(iUnit)) -  exptDataK{iTrials,1} <=  exptDataK{iTrials,2}.m_iTrialLength_MS/1000,unitsInUpdate(iUnit)) - exptDataK{iTrials,1};
            %spikesInThisTrial{iUnit,2} = unitsInUpdate(iUnit);
            %disp(sprintf('spikes in unit %i = %i',  iUnit  ,spikesInThisTrial))
            
            if any(spikesInThisTrial)
                
                if isfield(exptDataK{iTrials,2},'m_aiStimxyY')
				
				%{
				thisTrialxyYIDX = find(trackedxyYCoordinates(:,1) == exptDataK{iTrials,2}.m_aiStimxyY(1) &...
									trackedxyYCoordinates(:,2) == exptDataK{iTrials,2}.m_aiStimxyY(2) &...
									trackedxyYCoordinates(:,3) == exptDataK{iTrials,2}.m_aiStimxyY(3));				
				%}
                
               
				roundedThisTrialxyY = round(exptDataK{iTrials,2}.m_aiStimxyY * 1000);
				%roundedTrackedxyYCoordinates = round(g_strctStatistics.trackedxyYCoordinates * 1000);
                roundedTrackedxyYCoordinates = round(g_strctStatistics.trackedxyYCoordinates * 1000);
                
				
                if isempty(g_strctStatistics.trackedxyYCoordinates) || ~ismember(roundedThisTrialxyY,g_strctStatistics.trackedxyYCoordinates,'rows')
					g_strctStatistics.trackedxyYCoordinates = [g_strctStatistics.trackedxyYCoordinates;roundedThisTrialxyY];
					
				%uniquexyYCoordinates = unique(g_strctStatistics.trackedxyYCoordinates,'rows');
				end
				
				%g_strctStatistics.trackedxyYCoordinates = uniquexyYCoordinates;
                
                %{
				thisTrialxyYIDX = find(roundedThisTrialxyY(1) ==  roundedTrackedxyYCoordinates(:,1) &...
									roundedThisTrialxyY(2) == roundedTrackedxyYCoordinates(:,2)   &...
									roundedThisTrialxyY(3) == roundedTrackedxyYCoordinates(:,3)  );
				%}
                
				
                thisTrialxyYIDX = find(roundedThisTrialxyY(1) ==  g_strctStatistics.trackedxyYCoordinates(:,1) &...
									roundedThisTrialxyY(2) == g_strctStatistics.trackedxyYCoordinates(:,2)   &...
									roundedThisTrialxyY(3) == g_strctStatistics.trackedxyYCoordinates(:,3)  );
                
                g_strctStatistics.m_aixyYCoorindateColorMatchingTable(thisTrialxyYIDX,1:3) = roundedThisTrialxyY;
				g_strctStatistics.m_aixyYCoorindateColorMatchingTable(thisTrialxyYIDX,4:6) = exptDataK{iTrials,2}.m_aiStimColor;
                
				%fprintf('thisTrialxyYIDX = %i\n',thisTrialxyYIDX)
				%fprintf('m_iSelectedColorIndex = %i\n',exptDataK{iTrials,2}.m_iSelectedColorIndex)
				%fprintf('m_iSelectedSaturationIndex = %i\n',exptDataK{iTrials,2}.m_iSelectedSaturationIndex)
				
				
				g_strctStatistics.m_aixyYCoorindateSpikeHolder(thisTrialxyYIDX,g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)):...
						g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
											spikesInThisTrial ;
				
				g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)) = ...
									g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX(thisTrialxyYIDX,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
				
				
                    g_strctStatistics.m_aiColorSpikeHolder(exptDataK{iTrials,2}.m_iSelectedColorIndex,...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)):...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit))+numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
                        spikesInThisTrial ;
                    
                    g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
                    
                    
                    
                end
                
                
                %{
                if isfield(exptDataK{iTrials,2},'m_iSelectedColorIndex')
                    g_strctStatistics.m_aiColorSpikeHolder(exptDataK{iTrials,2}.m_iSelectedColorIndex,...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)):...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit))+numel(spikesInThisTrial)-1,unitsInUpdate(iUnit)) = ...
                        spikesInThisTrial ;
                    
                    g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)) = ...
                        g_strctStatistics.m_aiColorSpikeHolderIDX(exptDataK{iTrials,2}.m_iSelectedColorIndex,unitsInUpdate(iUnit)) + numel(spikesInThisTrial);
                    
                    
                    
                end
                %}
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
        
        %strcTrialBackupInfo = ;
		%{
        strcTrialBackupInfo = [];
        strcTrialBackupInfo.m_fImageFlipON_TS_Kofiko = exptDataK{iTrials,2}.m_fImageFlipON_TS_Kofiko
        strcTrialBackupInfo.m_fRotationAngle = exptDataK{iTrials,2}.m_fRotationAngle;
        strcTrialBackupInfo.m_fTrialKofikoStrobeAlignTime = initTimeK;
        strcTrialBackupInfo.m_fTrialPlexonStrobeAlignTime = initTimeP;
        strcTrialBackupInfo.m_aiSpikesInThisTrial = exptDataK{iTrials,2}.m_fRotationAngle;
        strcTrialBackupInfo.m_aiStimColor = exptDataK{iTrials,2}.m_aiStimColor;
        strcTrialBackupInfo.m_afBackgroundColor = exptDataK{iTrials,2}.m_afBackgroundColor;
        strcTrialBackupInfo.m_fStimulusON_MS = exptDataK{iTrials,2}.m_fStimulusON_MS;
        strcTrialBackupInfo.m_fStimulusOFF_MS = exptDataK{iTrials,2}.m_fStimulusOFF_MS;
        strcTrialBackupInfo.m_aiStimCenter = exptDataK{iTrials,2}.m_aiStimCenter;
        strcTrialBackupInfo.m_bRandomStimulusPosition = exptDataK{iTrials,2}.m_bRandomStimulusPosition;
        strcTrialBackupInfo.m_iMoveSpeed = exptDataK{iTrials,2}.m_iMoveSpeed;
        strcTrialBackupInfo.m_iMoveDistance = exptDataK{iTrials,2}.m_iMoveDistance;
        strcTrialBackupInfo.numFrames = exptDataK{iTrials,2}.numFrames;
        strcTrialBackupInfo.numberBlurSteps = exptDataK{iTrials,2}.numberBlurSteps;
        strcTrialBackupInfo.m_aixyYCoordinates = exptDataK{iTrials,2}.m_aiStimxyY;
        %  g_strctTrial{g_strctStatistics.m_iTrialIter,1} = exptDataK{iTrials,1};
        %  g_strctTrial{g_strctStatistics.m_iTrialIter,2} = exptDataK{iTrials,2};
		 %}
        g_strctTrial{g_strctStatistics.m_iTrialIter,1} = exptDataK{iTrials,2};
        g_strctTrial{g_strctStatistics.m_iTrialIter,2} = spikesInThisTrial;
       
        g_strctStatistics.m_iTrialIter = g_strctStatistics.m_iTrialIter + 1;
        if g_strctStatistics.m_iTrialIter > g_strctNeuralServer.m_iTrialsToKeepInBuffer
            g_strctStatistics.m_iTrialIter = 1;
        end
        
    else
        
    end
end

numCurrentlyTrackedColorUnits = max([max(find(max(max(g_strctStatistics.m_aiColorSpikeHolder)))),numUnitsInUpdate]);
numCurrentlyTrackedOrientationUnits = max([max(find(max(max(g_strctStatistics.m_aiOrientationSpikeHolder)))),numUnitsInUpdate]);
numCurrentlyTrackedUnits = max(numCurrentlyTrackedColorUnits, numCurrentlyTrackedOrientationUnits);


if numCurrentlyTrackedUnits == 0 || isempty(numCurrentlyTrackedUnits)
    numCurrentlyTrackedUnits = 1;
end


numCurrentlyTrackedUnits = max([numCurrentlyTrackedUnits,max(unitsInUpdate)]);

%{
for i = 1:size(g_strctStatistics.trackedxyYCoordinates,1)
	
    [SpherexyYCoordinatesIndex(i,1),...
	 SpherexyYCoordinatesIndex(i,2),...
	 SpherexyYCoordinatesIndex(i,3)] = cart2sph(g_strctStatistics.trackedxyYCoordinates(i,1),...
												g_strctStatistics.trackedxyYCoordinates(i,2),...
												g_strctStatistics.trackedxyYCoordinates(i,3));
	
end
SpherexyYCoordinatesIndex = sort(SpherexyYCoordinatesIndex(:,1));
%}
if ~any(g_strctStatistics.trackedxyYCoordinates)
    return;
    
end
for iUnit = 1:numUnitsInUpdate

    for iConditions = 1:size(g_strctStatistics.trackedxyYCoordinates,1)
        %PSTHColorHolderColorIDs(iConditions,:,unitsInUpdate(iUnit)) = colors(iConditions,:);
        PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = hist(g_strctStatistics.m_aixyYCoorindateSpikeHolder(iConditions,g_strctStatistics.m_aixyYCoorindateSpikeHolder(iConditions,:,unitsInUpdate(iUnit)) ~= 0,unitsInUpdate(iUnit)),50);
    end
	%{
    for iConditions = 1:size(g_strctStatistics.m_aixyYCoorindateSpikeHolder
        PSTHColorHolderColorIDs(iConditions,:,unitsInUpdate(iUnit)) = colors(iConditions,:);
        PSTHColorHolder(iConditions,:,unitsInUpdate(iUnit)) = hist(g_strctStatistics.m_aiColorSpikeHolder(iConditions,g_strctStatistics.m_aiColorSpikeHolder(iConditions,:,unitsInUpdate(iUnit)) ~= 0,iUnit),50);
    end
    %}
    subplot(2,numCurrentlyTrackedUnits*10,(2+((unitsInUpdate(iUnit)-1)*10):unitsInUpdate(iUnit)*10));
 %   imagesc(PSTHColorHolder(:,:,unitsInUpdate(iUnit)));
    imagesc(PSTHColorHolder(:,:,unitsInUpdate(iUnit)));
     set(gca,'YTick',[])
	subplot(2,numCurrentlyTrackedUnits*10,(1+((unitsInUpdate(iUnit)-1)*10)));
	%imagesc(g_strctStatistics.m_aixyYCoorindateColorMatchingTable(any(g_strctStatistics.m_aixyYCoorindateColorMatchingTable),4:6));
	%imagesc(g_strctStatistics.m_aixyYCoorindateColorMatchingTable(any(g_strctStatistics.m_aixyYCoorindateColorMatchingTable),4:6));
    [colorBar] = fnMakeColorBar(g_strctStatistics.m_aixyYCoorindateColorMatchingTable);
    imagesc(colorBar);
    set(gca,'xTickLabel','')
    set(gca,'yTickLabel','')
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    %numXTickLabels = numel(str2num(get(gca,'XTickLabel')));
    
    %numXTickLabels = 11;
    %L = get(gca,'XLim');
    %set(gca,'XTick',linspace(L(1),L(2),NumTicks))
    
    %set(gca,'XTickLabel',round(linspace(-preTrialWindow*1000,exptDataK{iTrials,2}.m_iTrialLength_MS,numXTickLabels)));
    %figure(g_strctStatistics.m_hOrientationPSTHFigureHandle)
    for iConditions = 1:20
        PSTHOrientationHolder(iConditions,1,unitsInUpdate(iUnit)) = deg2rad(round(iConditions * (360/20)));
        PSTHOrientationHolder(iConditions,2,unitsInUpdate(iUnit)) = sum(g_strctStatistics.m_aiOrientationSpikeHolder(iConditions,...
            g_strctStatistics.m_aiOrientationSpikeHolder(iConditions,:,unitsInUpdate(iUnit)) ~= 0,unitsInUpdate(iUnit)));
        
        
    end
    PSTHOrientationHolder = circshift(PSTHOrientationHolder, [5,0,0]);
    subplot(2,numCurrentlyTrackedUnits,unitsInUpdate(iUnit) + numCurrentlyTrackedUnits);
    mmpolar(vertcat(flipud(PSTHOrientationHolder(:,1,unitsInUpdate(iUnit))),PSTHOrientationHolder(end,1,unitsInUpdate(iUnit))),...
        vertcat(PSTHOrientationHolder(:,2,unitsInUpdate(iUnit)),PSTHOrientationHolder(end,2,unitsInUpdate(iUnit)))-1);
end
drawnow;




return;




function [rgb] = ldrgyv2rgb(ld,rg,yv)
global g_strctStatistics
ldrgyv = [ld rg yv]';

%matrix=[	1 1 dRyv;
%1 dGrg dGyv;
%1 dBrg 1];

%g_strctStatistics.m_strctConversionMatrices
% Values for MIT, july 2015
matrix = g_strctStatistics.m_strctConversionMatrices.ldgyb;

%{
matrix=  [1	1	0.304455308556149
			1	-0.253409957412193	-0.257060304918859
			1	0.00799723127465672	1];
%}
% These are the correct values given out
% by the calib_correct function.


rgb = matrix*ldrgyv/2.0 + 0.5;
return;

function [ld,rg,yv] = rgb2ldrgyv(rgb)
global g_strctStatistics
%ldrgyv = [ld rg yv]';

%matrix=[	1 1 dRyv;
%1 dGrg dGyv;
%1 dBrg 1];

%g_strctStatistics.m_strctConversionMatrices
% Values for MIT, july 2015
matrix = g_strctStatistics.m_strctConversionMatrices.ldgyb;

%{
matrix=  [1	1	0.304455308556149
			1	-0.253409957412193	-0.257060304918859
			1	0.00799723127465672	1];
%}
% These are the correct values given out
% by the calib_correct function.


%    rgb = matrix*ldrgyv/2.0 + 0.5;
%1/(matrix*ldrgyv/2.0 + 0.5) %= 1/rgb
[s1 s2 thirdD] = size(r);
dkl = reshape((M_rgb2dkl*(2*(reshape(r,s1*s2,thirdD)-0.5))')',s1,s2,thirdD);
%.5 = (matrix*ldrgyv/2.0 )/rgb
%.5 = (matrix*ldrgyv/2.0 )/rgb

rgb = (matrix*ldrgyv/2.0 )/2
rgb = ((matrix*ldrgyv/2.0 )/2)
return;

% ------------------------------------------------------------------------------------------

function [colorBar] = fnMakeColorBar(CoorindateColorMatchingTable)

colorTableIDX = find(CoorindateColorMatchingTable(:,1));

CoorindateColorMatchingTable = CoorindateColorMatchingTable(colorTableIDX,:);
%CoorindateColorMatchingTable = CoorindateColorMatchingTable(any(CoorindateColorMatchingTable(:,1)),:);
%newColorBar = zeros(size(experimentStimulusVars.stimOrder,1),1);
%colorBar = zeros(size([conditions([conditions.numTrials] ~= 0).numTrials],2),1);
colorBar = [];
for i = 1:size(CoorindateColorMatchingTable,1) 
   
        colorBar(i,1,1) = CoorindateColorMatchingTable(i,4)/65535;
        colorBar(i,1,2) = CoorindateColorMatchingTable(i,5)/65535;
        colorBar(i,1,3) = CoorindateColorMatchingTable(i,6)/65535;
end


return;








function defunctCode


%figure(oldfighandle);

%{
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

%{
for iTrials = 1:size(strctTrial,2)
	g_strctTrial{g_strctNeuralServer.m_iTrialCircularBufferID} = strctTrial{iTrials,1};
	
	if strcmpi(g_strctTrial{g_strctNeuralServer.m_iTrialCircularBufferID}.m_strTrialType, 'plain bar')
		%disp('plain bar')
		
		% dont do anything else for now, will figure out what to do about it later
	elseif strcmpi(g_strctTrial{g_strctNeuralServer.m_iTrialCircularBufferID}.m_strTrialType, 'moving bar')
	
	
	
		
		
		
	strobeDataP=horzcat(events.timeStamps,events.strobeNumber);
	syncStrobeIdxP = strobeDataP(:,2)==syncStrobe;
	initTimeP=strobeDataP(find(syncStrobeIdxP==1,1),1);
%{
	
	for i=1:size(exptData,1)
		if isstruct(exptData{i,2})
			if i>10, startIdx=i-10; else startIdx=1; end
			if i+60<=size(exptData,1), endIdx=i+60; else endIdx=size(exptData,1); end
			tsAlign=exptData{i,1};
			rotAngle=exptData{i,2}.m_fRotationAngle+1;
			eventWindowTS=cell2mat(exptData(startIdx:endIdx,1));
			eventWindow = exptData(startIdx:endIdx,2);
			eventWindowStart = tsAlign - eventWindowPre;
			eventWindowEnd=tsAlign+eventWindowDur+eventWindowPost;
			eventWindowIdx=logical((eventWindowTS>eventWindowStart).*(eventWindowTS<eventWindowEnd));
			spikes(rotAngle,2)=spikes(rotAngle,2)+sum(cell2mat(cellfun(@(x) length(x)==spikeWindowSize,eventWindow(eventWindowIdx),'UniformOutput',false)));
		end
	end
%}
%{
		% Bin the orientation
	
		g_strctStatistics.m_strctMovingBarStats.m_iOrientationBin(round(g_strctTrial{g_strctNeuralServer.m_iTrialCircularBufferID}.m_fRotationAngle / ...
										g_strctStatistic.m_iNumOrientationBins)).m_fTrialStartTimes( ...
										g_strctStatistics.m_strctMovingBarStats.m_iOrientationBinID(round(g_strctTrial{ ...
										g_strctNeuralServer.m_iTrialCircularBufferID}.m_fRotationAngle / ...
										g_strctStatistic.m_iNumOrientationBins))) = ...
										g_strctTrial{g_strctNeuralServer.m_iTrialCircularBufferID}.m_fImageFlipON_TS_Kofiko;
										
		g_strctStatistics.m_strctMovingBarStats.m_iOrientationBinID(round(g_strctTrial{ ...
										g_strctNeuralServer.m_iTrialCircularBufferID}.m_fRotationAngle / ...
										g_strctStatistic.m_iNumOrientationBins)) = ...
										g_strctStatistics.m_strctMovingBarStats.m_iOrientationBinID(round(g_strctTrial{ ...
										g_strctNeuralServer.m_iTrialCircularBufferID}.m_fRotationAngle / ...
										g_strctStatistic.m_iNumOrientationBins)) + 1;
										
						g_strctStatistics.m_strctMovingBarStats.m_iOrientationBin
%{
		% we can sort this out later, when colors are selected based on cie coordinates.
		g_strctStatistics.m_strctMovingBarStats.m_iColorBin
	
%}
	
%}
	end
	
	
	g_strctNeuralServer.m_iTrialCircularBufferID = g_strctNeuralServer.m_iTrialCircularBufferID + 1;
	
    if g_strctNeuralServer.m_iTrialCircularBufferID > g_strctNeuralServer.m_iTrialsToKeepInBuffer
        save(['c:\Data\ExperimentBuffer\ExperimentBackup_' num2str(g_strctNeuralServer.m_iExperimentBackupIter)], 'g_strctTrial','fCurrTime');
    
    
    g_strctNeuralServer.m_iExperimentBackupIter = g_strctNeuralServer.m_iExperimentBackupIter + 1 ;
	g_strctNeuralServer.m_iTrialCircularBufferID = 1;
	g_strctTrial = cell(1,g_strctNeuralServer.m_iTrialsToKeepInBuffer);

    end
	%g_strctNeuralServer.m_iTrialCircularBufferID = g_strctNeuralServer.m_iTrialCircularBufferID + size(strctTrial,2);
end


%for i = 1:size(strctTrial,2)
	% Trial Information: 1: trial type
	%					 2: Flip on time (stim server)
	% 					 3: Flip off time (stim server)
	%					 4: trial length
	%					 5: stim on ms
	%					 6: stim off ms
	% 					 7: stim color
	% 					 8: background color
	% 					 9: orientation
	% 					 10: length
	% 					 11: width
	
%{
	%g_strctNeuralServer.m_acTrialCircularBuffer{g_strctNeuralServer.m_iTrialCircularBufferID} = strctTrial;
%g_strctNeuralServer.m_iTrialCircularBufferID = g_strctNeuralServer.m_iTrialCircularBufferID + 1;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_strTrialType = strctTrial.m_strTrialType;
	%g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_fImageFlipON_TS_StimulusServer = strctTrial.m_fImageFlipON_TS_StimulusServer;
	%g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_fImageFlipOFF_TS_StimulusServer = strctTrial.m_fImageFlipOFF_TS_StimulusServer;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_iTrialLength_MS = strctTrial.m_iTrialLength_MS;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_fStimulusON_MS = strctTrial.m_fStimulusON_MS;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_fStimulusOFF_MS = strctTrial.m_fStimulusOFF_MS;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_aiStimColor = strctTrial.m_aiStimColor;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_afBackgroundColor = strctTrial.m_afBackgroundColor;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_fRotationAngle = strctTrial.m_fRotationAngle;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_iLength = strctTrial.m_iLength;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_iWidth = strctTrial.m_iWidth;
	g_strctTrial(g_strctNeuralServer.m_iTrialCircularBufferID).m_fImageFlipON_TS_Kofiko = strctTrial.m_fImageFlipON_TS_Kofiko;
	
	
	
	disp(sprintf('trial %i processed', g_strctNeuralServer.m_iTrialCircularBufferID))
end
%}
%}
%}
return;
