function fnStatServerCallbacks(strEvent, varargin)
global g_strctCycle g_strctConfig g_strctNet g_strctNeuralServer g_strctWindows g_DebugDataLog g_counter g_strctTrial 

strEvent
tic
switch strEvent

    
	
    case 'UpdateAxes'
	
        fnSetAxesForPlotting();
    case 'SetBarGraphRange'
        if strcmpi(varargin{1},'Start')
            g_strctConfig.m_strctGUIParams.m_fBarGraphFrom = varargin{2};
        else
            g_strctConfig.m_strctGUIParams.m_fBarGraphTo = varargin{2};
        end
		
    case 'UpdateAdvancer'
        
        if ~isempty(g_strctCycle.m_strSessionName)
            strSession = g_strctCycle.m_strSessionName;
        else
            strSession = g_strctCycle.m_strTmpSessionName;
        end
        
        iAdvancerIndex = varargin{1};
        fNewDepth = varargin{2};
        fTS_PTB = GetSecs();
        fTS_MapClockNow = TrialCircularBuffer('GetLastKnownTimestamp');
        fEstimatedTimeStampPLXFile = fTS_MapClockNow-g_strctCycle.m_strctPlexonFrame.m_fMAPClockAtFrameStart;
        strOutputText = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[strSession,'-Advancers.txt']);
        hFileID = fopen(strOutputText,'a+');
        fprintf(hFileID,'%d %f %d %f %f %f\r\n',iAdvancerIndex,fNewDepth, g_strctCycle.m_strctPlexonFrame.m_iCurrentPlexonFrame, fEstimatedTimeStampPLXFile,fTS_MapClockNow,fTS_PTB);
        fclose(hFileID);
        
    case 'SetVisualization'
        strMode = varargin{1};
        switch strMode
            case 'ToggleAutoRescale'
                g_strctConfig.m_strctGUIParams.m_bAutoRescale = ~g_strctConfig.m_strctGUIParams.m_bAutoRescale;
                fnDisplayOverview();
                
            case 'PSTH'
                g_strctConfig.m_strctGUIParams.m_strViewMode = 'PSTH';
                fnDisplayOverview();
            case 'Raster'
                g_strctConfig.m_strctGUIParams.m_strViewMode = 'Raster';
                fnDisplayOverview();
            case 'BarGraph'
                g_strctConfig.m_strctGUIParams.m_strViewMode = 'BarGraph';
                fnDisplayOverview();
            case 'ResetAxes'
                fnDisplayOverview();
            case 'LinkAxes'
                %  bLink = get(g_strctWindows.m_strctSettingsPanel.m_hLinkAxes,'value');
                % if bLink
                %   linkaxes(g_strctWindows.m_strctStatPanel.m_a2hPlotAxes(:),'x');
                % else
                %   linkaxes(g_strctWindows.m_strctStatPanel.m_a2hPlotAxes(:),'off');
                
                % end
                % fnDisplayOverview();
            case 'SmoothCurves'
                % g_strctConfig.m_strctGUIParams.m_bSmoothPSTH = get(g_strctWindows.m_strctSettingsPanel.m_hSmoothCurves,'value') > 0;
                % fnDisplayOverview();
            otherwise
                fnStatLog('Unknown GUI Option');
        end
        
    case 'KofikoInput'
        fnParseInputFromKofiko(varargin{:});
    case 'ToggleActive'
        if isempty(g_strctCycle.m_strSessionName)
            return;
        end
        
        iChannel = varargin{1};
        iUnit = varargin{2};
        fLastKnownTS = TrialCircularBuffer('GetLastKnownTimestamp');
        
        NumAvailCh = size(g_strctNeuralServer.m_a2cActiveUnitsHistory,1);
        NumAvailUnit = size(g_strctNeuralServer.m_a2cActiveUnitsHistory,2);
        if iChannel > NumAvailCh || NumAvailUnit>NumAvailUnit
            return;
        end;
        
        iNumEntries = size(g_strctNeuralServer.m_a2cActiveUnitsHistory{iChannel,iUnit},1);
        
        if g_strctNeuralServer.m_a2iCurrentActiveUnits(iChannel,iUnit) > 0
            % Unit WAS active and we just lost it
            if iNumEntries == 0
                % BUG ?!?!?!
            else
                g_strctNeuralServer.m_a2iCurrentActiveUnits(iChannel,iUnit) = 0;
                g_strctNeuralServer.m_a2cActiveUnitsHistory{iChannel,iUnit}(iNumEntries,2) = fLastKnownTS;
                %                set(g_strctWindows.m_strctStatPanel.m_a2hPushButtons(iChannel,iUnit+1),'String', sprintf('Activate [%d:%d]',iChannel,iUnit),'FontWeight','Normal');
                
            end
        else
            % Unit was inactive and we just activated it.
            g_strctCycle.m_iGlobalUnitCounter = g_strctCycle.m_iGlobalUnitCounter + 1;
            g_strctNeuralServer.m_a2iCurrentActiveUnits(iChannel,iUnit) =  g_strctCycle.m_iGlobalUnitCounter ;
            
            TrialCircularBuffer('ResetUnitTrialCounter',iChannel,iUnit);
            
            if iNumEntries == 0
                g_strctNeuralServer.m_a2cActiveUnitsHistory{iChannel,iUnit} = [fLastKnownTS, NaN];
            else
                g_strctNeuralServer.m_a2cActiveUnitsHistory{iChannel,iUnit}(iNumEntries+1,:) = [fLastKnownTS, NaN];
            end
            %           set(g_strctWindows.m_strctStatPanel.m_a2hPushButtons(iChannel,iUnit+1),'String', sprintf('[%d:%d] is Active!',iChannel,iUnit),'FontWeight','Bold');
        end
        
        % Save this immediately to disk ?
        
        %         strOutput = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[g_strctCycle.m_strSessionName,'-Electrophsyiology.mat']);
        %         save(strOutput,'g_strctNeuralServer');
        
        if ~isempty(g_strctCycle.m_strSessionName)
            strSession = g_strctCycle.m_strSessionName;
        else
            strSession = g_strctCycle.m_strTmpSessionName;
        end
        
        strOutputText = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[strSession,'-ActiveUnits.txt']);
        hFileID = fopen(strOutputText,'a+');
        
        fTS_PTB = GetSecs();
        fTS_MapClockNow = TrialCircularBuffer('GetLastKnownTimestamp');
        fEstimatedTimeStampPLXFile = fTS_MapClockNow-g_strctCycle.m_strctPlexonFrame.m_fMAPClockAtFrameStart;
        
        fprintf(hFileID,'%d %d %d %d %f %f %f\r\n',iChannel,iUnit,g_strctNeuralServer.m_a2iCurrentActiveUnits(iChannel,iUnit) > 0,  g_strctCycle.m_strctPlexonFrame.m_iCurrentPlexonFrame, fEstimatedTimeStampPLXFile,fTS_MapClockNow,fTS_PTB);
        fclose(hFileID);
        
        %        fnUpdatePushButtonsTitle();
        %         if g_strctCycle.m_bConditionInfoAvail
        %             fnDisplayOverview();
        %         end
end

return;

function fnParseInputFromKofiko(acInputFromKofiko)
global g_strctCycle g_strctNeuralServer g_strctWindows g_strctConfig g_strctStatistics strctColorValues g_strctTrial
tic 
strCommand = acInputFromKofiko{1};
strCommand
%
switch lower(strCommand)

		
    case 'pong'
        
        fLocalTimeSend = acInputFromKofiko{2};
        fKofikoTime = acInputFromKofiko{3};
        fNow = GetSecs();
        fJitterMS = (fNow-fLocalTimeSend)*1e3;
        g_strctCycle.m_strctSync = fnTsSetVar(g_strctCycle.m_strctSync,'KofikoSyncPingPong', [fLocalTimeSend, fKofikoTime, fJitterMS]);
        
    case 'syncwithkofiko'
        fKofikoTime = acInputFromKofiko{2};
        g_strctCycle.m_strctSync = fnTsSetVar(g_strctCycle.m_strctSync,'KofikoSync', [GetSecs(), fKofikoTime]);
        g_strctNeuralServer.m_fSyncTimer = acInputFromKofiko{2};
        
        
    case 'plexonframestart'
        %{
        g_strctCycle.m_strctPlexonFrame.m_fMAPClockAtFrameStart = TrialCircularBuffer('GetLastKnownTimestamp');
        g_strctCycle.m_strctPlexonFrame.m_iCurrentPlexonFrame = acInputFromKofiko{2};
        g_strctCycle.m_strctPlexonFrame.m_fKofiko_TS = acInputFromKofiko{3};
        g_strctCycle.m_strctPlexonFrame.m_fStatServerTS = GetSecs();
		
        g_strctCycle.m_strctSync = fnTsSetVar(g_strctCycle.m_strctSync,'PlexonSync',...
			[g_strctCycle.m_strctPlexonFrame.m_fMAPClockAtFrameStart,g_strctCycle.m_strctPlexonFrame.m_iCurrentPlexonFrame,...
			g_strctCycle.m_strctPlexonFrame.m_fKofiko_TS,g_strctCycle.m_strctPlexonFrame.m_fStatServerTS    ]);
        
        g_strctCycle.m_bPlexonIsRecording = true;
        set(g_strctWindows.m_strctStatPanel.m_a2hPushButtons(~isnan(g_strctWindows.m_strctStatPanel.m_a2hPushButtons)),'enable','on');
        %}
    case 'plexonframeend'
        %{
        fnTurnOffAllActiveUnits(false);
        g_strctCycle.m_strctPlexonFrame.m_fMAPClockAtFrameStart = NaN;
        g_strctCycle.m_strctPlexonFrame.m_iCurrentPlexonFrame = NaN;
        g_strctCycle.m_bPlexonIsRecording = false;
        
        set(g_strctWindows.m_strctStatPanel.m_a2hPushButtons(~isnan(g_strctWindows.m_strctStatPanel.m_a2hPushButtons)),'enable','off');
        %}
    case 'startnewsession'
       % if isempty(g_strctCycle.m_strSessionName)
            g_strctCycle.m_strKofikoLog = acInputFromKofiko{2};
            
            % Re-opened while kofiko still running ?
            [strP,strF]=fileparts(g_strctCycle.m_strKofikoLog);
            
            g_strctCycle.m_strSessionName = strF;
            
            
            % rename files...
            strActiveUnitsTmpFile = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[g_strctCycle.m_strTmpSessionName,'-ActiveUnits.txt']);
            if exist(strActiveUnitsTmpFile,'file')
                strActiveUnitsFile = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[g_strctCycle.m_strSessionName,'-ActiveUnits.txt']);
                movefile(strActiveUnitsTmpFile,strActiveUnitsFile);
            end
            
            strAdvancersTmpFile = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[g_strctCycle.m_strTmpSessionName,'-Advancers.txt']);
            if exist(strAdvancersTmpFile,'file')
                strAdvancersFile = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[g_strctCycle.m_strSessionName,'-Advancers.txt']);
                movefile(strAdvancersTmpFile,strAdvancersFile);
            end
            
            
            
            strOutput = fullfile(g_strctConfig.m_strctDirectories.m_strDataFolder,[strF,'-Electrophsyiology.mat']);
            
            if exist(strOutput,'file')
                strAnswer = questdlg('Information about this session exist. Reload from disk?','Warning!','Yes','No','Yes');
                if strcmp(strAnswer,'Yes')
                    strctInfo = load( strOutput);
                    % Take only relevant information....
                    if all(size(g_strctNeuralServer.m_a2iCurrentActiveUnits) == size(strctInfo.g_strctNeuralServer.m_a2iCurrentActiveUnits) )
                        g_strctNeuralServer.m_a2iCurrentActiveUnits = strctInfo.g_strctNeuralServer.m_a2iCurrentActiveUnits;
                        g_strctNeuralServer.m_a2cActiveUnitsHistory = strctInfo.g_strctNeuralServer.m_a2cActiveUnitsHistory;
                    end
                end
            end
        %else
            
            % Kofiko crashed.... problematic...
            %assert(false);
            
            
        %end
    case 'cleardesign'
        g_strctCycle.m_bConditionInfoAvail = false;
        % release buffers...
        
    case 'design'
        strctDesign = acInputFromKofiko{2};
        
        fnStatLog('New Design Received');
        
        NumPointsInWaveform = g_strctNeuralServer.m_fNumPointsInWaveform;
        NumChannels = g_strctNeuralServer.m_iNumActiveSpikeChannels;
        NumUnitsPerChannel = g_strctNeuralServer.m_iNumberUnitsPerChannel;
        LFP_Sampled_Freq = g_strctNeuralServer.m_fAD_Freq;
        LFP_Stored_Freq = g_strctNeuralServer.m_fAD_Freq/5; % ideally, sampled is 2K and stored is 400Hz
        assert( mod(LFP_Stored_Freq,10) == 0)
        
        if ~isfield(strctDesign,'NumTrialsInCircularBuffer') || ~isfield(strctDesign,'TrialLengthSec') || ~isfield(strctDesign,'Pre_TimeSec') || ...
                ~isfield(strctDesign,'Post_TimeSec') ||     ~isfield(strctDesign,'TrialStartCode')
            
            fnStatLog('Failed to update design!');
            fnStatLog('Some fields are missing!');
            g_strctCycle.m_bConditionInfoAvail = false;
            return;
        end;
        
        
        NumTrials = strctDesign.NumTrialsInCircularBuffer;
        TrialLengthSec = strctDesign.TrialLengthSec;
        Pre_TimeSec = strctDesign.Pre_TimeSec;
        Post_TimeSec = strctDesign.Post_TimeSec;
        
        fnStatLog('Allocating memory for trials...');
        aiChannels = g_strctNeuralServer.m_aiActiveSpikeChannels;
        TrialCircularBuffer('Allocate',aiChannels,NumUnitsPerChannel,LFP_Sampled_Freq,LFP_Stored_Freq,NumTrials,TrialLengthSec,Pre_TimeSec,Post_TimeSec,NumPointsInWaveform);
        
        
        strctOpt.TrialStartCode = strctDesign.TrialStartCode;
        strctOpt.TrialEndCode = strctDesign.TrialEndCode;
        strctOpt.TrialAlignCode = strctDesign.TrialAlignCode;
        strctOpt.TrialOutcomesCodes = strctDesign.TrialOutcomesCodes;
        strctOpt.KeepTrialOutcomeCodes = strctDesign.KeepTrialOutcomeCodes;
        
        % Augment conditions with "All kept trials"
        NumTrialsTypes = size(strctDesign.TrialTypeToConditionMatrix,1);
        NumConditions = size(strctDesign.TrialTypeToConditionMatrix,2);
        if isempty(strctDesign.ConditionNames)
            strctDesign.ConditionNames = cell(1,NumConditions);
            for k=1:NumConditions
                strctDesign.ConditionNames{k} = sprintf('Unknwon Condition %d',k);
            end
        end
        TrialToConditionAug = [ones(NumTrialsTypes,1)>0, strctDesign.TrialTypeToConditionMatrix];
        
        strctOpt.TrialTypeToConditionMatrix = TrialToConditionAug;
        
        AugOutcomeFilter = cell(1, NumConditions+1);
        AugOutcomeFilter(2:end) = strctDesign.ConditionOutcomeFilter;
        strctOpt.ConditionOutcomeFilter = AugOutcomeFilter;
        strctOpt.PSTH_BinSizeMS = 10;
        strctOpt.LFP_ResolutionMS = 5;
        
        AugNames = cell(1,NumConditions+1);
        AugNames{1} = 'All Kept Trials';
        AugNames(2:end) = strctDesign.ConditionNames;
        strctOpt.ConditionNames = AugNames;
        strctOpt.NumChannels = NumChannels;
        strctOpt.NumUnitsPerChannel = NumUnitsPerChannel;
        strctOpt.LFP_Sampled_Freq = LFP_Sampled_Freq;
        strctOpt.LFP_Stored_Freq = LFP_Stored_Freq ;
        strctOpt.NumTrials = NumTrials;
        strctOpt.TrialLengthSec = TrialLengthSec;
        strctOpt.Pre_TimeSec = Pre_TimeSec;
        strctOpt.Post_TimeSec = Post_TimeSec;
        
        TrialCircularBuffer('SetOpt',strctOpt);
        
        g_strctCycle.m_strctTrialBufferOpt = strctOpt;
        g_strctCycle.m_bConditionInfoAvail = true;
        
        
        if isfield(strctDesign,'ConditionVisibility') && length(strctDesign.ConditionVisibility) == NumConditions
            g_strctCycle.m_abDisplayConditions = [true, strctDesign.ConditionVisibility] > 0;
        else
            g_strctCycle.m_abDisplayConditions = ones(1,NumConditions+1) > 0;
        end
        g_strctCycle.m_abDisplayConditionsRaster = zeros(1,NumConditions+1) > 0;
        g_strctCycle.m_abDisplayConditionsRaster(1) = true;
        g_strctCycle.m_a2fConditionColors = lines(NumConditions+1);
        
        fnStatLog('Allocation finished successfully.');
        % fnUpdateConditionList();
        
        % Clear spike and LFP buffer. It might still contain information
        % about previous trials that are not irrelevant....
        
        % [NumSpikeAndStrobeEvents, a2fSpikeAndEvents, a2fWaveForms] =PL_GetWFEvs(g_strctNeuralServer.m_hSocket);
        % [NumAnalog, afAnalogTime, a2fLFP] = PL_GetADVEx(g_strctNeuralServer.m_hSocket);
    case 'waitontrialinfo'
        disp('waiting')
        [acInputFromKofiko, iSocketErrorCode] = msrecv(g_strctNet.m_iCommSocket,.4);
        if ~isempty(acInputFromKofiko)
            
            %fnAcceptDynamicTrialInformation(acInputFromKofiko{2});
        end
    case 'setdynamictrialmode'
        
        
        
        
        g_strctCycle.m_bDynamicTrialMode = acInputFromKofiko{2};
        if g_strctCycle.m_bDynamicTrialMode
            if ~g_strctNeuralServer.m_bTrialCircularBufferInitialized
                g_strctNeuralServer.m_acTrialCircularBuffer = cell(1,200000);
                g_strctNeuralServer.m_iTrialCircularBufferID = 1;
                g_strctNeuralServer.m_bTrialCircularBufferInitialized = 1;
            end
            if ~g_strctNeuralServer.m_bSpikeCircularBufferInitialized
                g_strctNeuralServer.m_acSpikeCircularBuffer = zeros(20000,1,1,32); %20000 spikes
                g_strctNeuralServer.m_iSpikeCircularBufferID = 1;
                g_strctNeuralServer.m_bSpikeCircularBufferInitialized = 1;
            end
        end
        
    case 'dynamictrialinformation'
        %{
				case 'togglepsthplot'
				g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServe,'togglepsthplot'];
		
	case 'toggleorientationpolar'
		g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServe,'toggleorientationpolar'];
	case 'toggleisiplot'
		g_strctParadigm.m_strHandMappingCommandToStatServer = [g_strctParadigm.m_strHandMappingCommandToStatServe,'toggleisiplot'];
        %}
        if ischar(acInputFromKofiko{2})
            switch(acInputFromKofiko{2})
                case 'flushcolorspikebuffer'
                    % g_strctStatistics.m_aiColorSpikeHolder = zeros(16,5000,5);
                    % g_strctStatistics.m_aiColorSpikeHolderIDX = ones(16,5);
                    
                    %g_strctStatistics.trackedxyYCoordinates = [];
                    g_strctStatistics.m_aixyYCoorindateSpikeHolder = zeros(200,5000,5);
                    g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX = ones(200, 5);
                    g_strctStatistics.m_aixyYCoorindateColorMatchingTable = zeros(200,6);
                    g_strctStatistics.m_aixyYCoorindateColorTrialCounter = zeros(200,5);
                    g_strctStatistics.trackedxyYCoordinates  = nan(size(strctColorValues.allxyYCoordinates,1),size(strctColorValues.allxyYCoordinates,2));
                    
                    
                    
                    %g_strctStatistics.trackedxyYCoordinates = [];
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolder = zeros(200,5000,5);
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX = ones(200, 5);
                    g_strctStatistics.m_aiXYZCoorindateColorMatchingTable = [];
                    g_strctStatistics.m_aiXYZCoorindateColorTrialCounter = zeros(200,5);
                    g_strctStatistics.trackedXYZCoordinates  = [];
                    
                    
                    
                    
                case 'flushorientationspikebuffer'
                    
                    g_strctStatistics.m_aiOrientationSpikeHolder = zeros(20,5000,5);
                    g_strctStatistics.m_aiOrientationSpikeHolderIDX = ones(20,5);
                    
                case 'reconnecttoneuralserver'
                    bSuccess = fnConnectToNeuralServer();
                    if ~bSuccess
                        % do something
                    end
                    
            end
		elseif isstruct(acInputFromKofiko{2}) && isfield(acInputFromKofiko{2},'cmd')

			for iCmnds = 1:numel(acInputFromKofiko{2})
				switch acInputFromKofiko{2}(iCmnds).cmd{1}
				
					case 'PreTrialPlottingWindow'
						g_strctStatistics.preTrialWindow = -acInputFromKofiko{2}(iCmnds).cmd{2};
						
					case 'PostTrialPlottingWindow'
						g_strctStatistics.curTrialWindow = acInputFromKofiko{2}(iCmnds).cmd{2};
						g_strctStatistics.curTrialWindow 
						%acInputFromKofiko{2}(iCmnds).cmd{2}
					case 'FlushColorSpikeBuffer'
                    g_strctStatistics.m_aixyYCoorindateSpikeHolder = zeros(200,5000,5);
                    g_strctStatistics.m_aixyYCoorindateSpikeHolderIDX = ones(200, 5);
                    g_strctStatistics.m_aixyYCoorindateColorMatchingTable = zeros(200,6);
                    g_strctStatistics.m_aixyYCoorindateColorTrialCounter = zeros(200,5);
                    g_strctStatistics.trackedxyYCoordinates  = nan(size(strctColorValues.allxyYCoordinates,1),size(strctColorValues.allxyYCoordinates,2));
                    
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolder = zeros(200,5000,5);
                    g_strctStatistics.m_aiXYZCoorindateSpikeHolderIDX = ones(200, 5);
                    g_strctStatistics.m_aiXYZCoorindateColorMatchingTable = [];
                    g_strctStatistics.m_aiXYZCoorindateColorTrialCounter = zeros(200,5);
                    g_strctStatistics.trackedXYZCoordinates  = [];

                    case 'FlushOrientationSpikeBuffer'

                        g_strctStatistics.m_aiOrientationSpikeHolder = zeros(20,5000,5);
                        g_strctStatistics.m_aiOrientationSpikeHolderIDX = ones(20,5);

                    case 'FlushPositionSpikeBuffer'

                        g_strctStatistics.m_aiSpikePositionBinsSpikeHolder = zeros(12*20,5,5000);
                        g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX = ones(12*20,5);
                        g_strctStatistics.m_aiSpikePositionBinsTrialCounter = zeros(12*20,5);

					case 'FlushImageSpikeBuffer'
					  g_strctStatistics.m_strctImageAnalysis = [];

						
                    case 'TogglePSTHPlot'

                        g_strctStatistics.m_strctEnabledPlots.m_bPSTHEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bPSTHEnabled;


                    case 'ToggleOrientationPolar'
                        g_strctStatistics.m_strctEnabledPlots.m_bOrientationPolarEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bOrientationPolarEnabled;

					case 'ToggleVariableLengthPlot'
						g_strctStatistics.m_strctEnabledPlots.m_bVariableLengthPlotEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bVariableLengthPlotEnabled;

					case 'ToggleVariableWidthPlot'
						g_strctStatistics.m_strctEnabledPlots.m_bVariableWidthPlotEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bVariableWidthPlotEnabled;
						
					case 'ToggleVariableSpeedPlot'
						g_strctStatistics.m_strctEnabledPlots.m_bVariableSpeedPlotEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bVariableSpeedPlotEnabled;
						
                    case 'ToggleISIPlot'
                        g_strctStatistics.m_strctEnabledPlots.m_bISIPlotEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bISIPlotEnabled;

                    case 'TogglePositionPlot'
                        g_strctStatistics.m_strctEnabledPlots.m_bPositionHeatmapEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bPositionHeatmapEnabled;
						
					case 'ToggleImagePlot'
						g_strctStatistics.m_strctEnabledPlots.m_bImagePlotEnabled = ~g_strctStatistics.m_strctEnabledPlots.m_bImagePlotEnabled;
						
					case 'DebugMode'
						g_strctStatistics.m_bDebugModeEnabled = ~g_strctStatistics.m_bDebugModeEnabled;
                        
					case 'PrintFigure'
					try
					set(g_strctStatistics.m_hFigureHandle,'paperorientation','landscape');
					print(g_strctStatistics.m_hFigureHandle,'resize','-bestfit');
					%	figure(g_strctStatistics.m_hFigureHandle)
				catch
					try
						strSaveFileName = questdlg('print failed, enter figure save name');
						savefig(strSaveFileName)
					end
				end
				end
			end
				
			
		
        else
            %acInputFromKofiko{2}
            fnAcceptDynamicTrialInformation(acInputFromKofiko{2});
            
        end
        
        
    case 'syncrequestts'
        
        
    case 'writetodisk'
        
		%g_strctStatistics.m_iTrialIter
		fnAcceptDynamicTrialInformation(acInputFromKofiko{3});
        
        
		filepath = acInputFromKofiko{2}; 
		numTrialsToSave = acInputFromKofiko{4};
		if g_strctStatistics.m_iTrialIter - numTrialsToSave < 1
			fileSaveIndices = [1 : g_strctStatistics.m_iTrialIter,...
			g_strctNeuralServer.m_iTrialsToKeepInBuffer - (numTrialsToSave-g_strctStatistics.m_iTrialIter) : ...
			g_strctNeuralServer.m_iTrialsToKeepInBuffer ];
		else
			fileSaveIndices = [g_strctStatistics.m_iTrialIter-numTrialsToSave:g_strctStatistics.m_iTrialIter-1];
		
		end
		%g_strctStatistics.m_iTrialIter
		
       
       if numel(fileSaveIndices) > size(g_strctTrial,1)
            g_strctLocalExperimentRecording = {g_strctTrial}';%,{acInputFromKofiko{3}});
       else
           g_strctLocalExperimentRecording ={g_strctTrial{fileSaveIndices,1}}';%,{acInputFromKofiko{3}});

           
       
        
       end
       filepath(1) = 'C';
       fileDir = fileparts(filepath);
       %fileDir(1) = 'C';
       if ~exist(fileDir,'dir')
          mkdir(fileDir)
       end
        save(filepath, 'g_strctLocalExperimentRecording');
		%{
        filepath = acInputFromKofiko{2};
        g_strctLocalExperimentRecording = acInputFromKofiko{3};
        fnAcceptDynamicTrialInformation({acInputFromKofiko{3}{acInputFromKofiko{4}}}),
        save(filepath, 'g_strctLocalExperimentRecording');
        %}
        
   % case 'writefulldumptodisk'    
    %    filepath = acInputFromKofiko{2}; 
end
toc


% Opt = TrialCircularBuffer('GetOpt');
% War = TrialCircularBuffer('GetWarningCounters');
% NumTr = TrialCircularBuffer('GetNumTrialsInBuffer');
%
% CORRECT_OUTCOME = 32698;
% TrialLength = zeros(1,NumTr);
% TrialAlignFromStart = zeros(1,NumTr);
% TrialOutcome = zeros(1,NumTr);
% for k=1:NumTr
%     astrctTrials(k) = TrialCircularBuffer('GetTrial',k-1);
%     TrialLength(k) = astrctTrials(k).End_TS-astrctTrials(k).Start_TS;
%     TrialAlignFromStart(k) = astrctTrials(k).Align_TS - astrctTrials(k).Start_TS;
%     TrialOutcome(k) = astrctTrials(k).Outcome;
% end
%
% find(TrialOutcome == CORRECT_OUTCOME)
% figure;
% plot(TrialLength,'b');
% hold on;
% plot(TrialAlignFromStart,'r');
%
