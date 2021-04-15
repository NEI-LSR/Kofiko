function fnUpdatePlots(command,varargin)
global g_strctPlexon g_strctPTB g_strctParadigm
%tic

persistent indices  logicalIndex spikes




% are we running multiple commands? You can update multiple plots, or update the data in the buffer and then plot

for i = 1:numel(command)
    if ~isempty(command{i})
	
        switch command{i}
            
            case 'UpdateCounts'
                
                
                if g_strctPlexon.m_bTrialInTempBuffer
                    
                    
                    if (isempty(g_strctPlexon.m_afTempStrobeID) || ~g_strctPlexon.m_afTempStrobeID) && ~isempty(g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents)
                        % We checked the buffer before the trial ID could be sent after the trial start strobe, so we need to get it now
                        g_strctPlexon.m_afTempStrobeID =  g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents(1,3);
                    end
                    
                    nextEndIndex = find(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == g_strctParadigm.m_strctStatServerDesign.TrialEndCode,1,'first');
                    if ~isempty(nextEndIndex)
                        if isempty(g_strctPlexon.m_afTempStrobeID) || ~g_strctPlexon.m_afTempStrobeID
                            error('shit')
                        end
                        % trial aligned timestamps
                        tempTrial = vertcat(g_strctPlexon.m_afTempTrial,g_strctPlexon.m_strctLastCheck.m_afTimeStamps(1:nextEndIndex,:));
                        trialAlignTime = tempTrial(tempTrial(:,3) == g_strctParadigm.m_strctStatServerDesign.TrialAlignCode,4);
                        tempTrial(:,4) = tempTrial(:,4)-trialAlignTime;
                        if numel(trialAlignTime) > 1
                            % Something fucked up, we have two trial align times and one trial. Don't record this one.
                            % It's still recorded in the plexon file, if it's recording.
                        else
                            fnCircularBuffer('put', 'g_strctPlexon', 'm_afSpikeBuffer',...
                                g_strctPlexon.m_afTempStrobeID,... Trial Index ID
                                tempTrial);
                           % tempTrial
                            
                            fnCircularBuffer('put', 'g_strctPlexon', 'm_afWaveFormBuffer',...
                                g_strctPlexon.m_afTempStrobeID,... Trial Index ID
                                vertcat(g_strctPlexon.m_afTempWaveForms,g_strctPlexon.m_strctLastCheck.m_afWaveForms(1:nextEndIndex,:)));
                            
                            g_strctPlexon.m_bTrialInTempBuffer  = 0;
                            %{
							g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(...
										iTrials):nextEndIndex + g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials) - 1, :));% Trial Data
                            %}
                        end
                    else
                        % trial still hasn't ended, we need to concatenate the temporary buffers
                        g_strctPlexon.m_afTempTrial = vertcat(g_strctPlexon.m_afTempTrial,g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,:));
                        g_strctPlexon.m_afTempWaveForms = vertcat(g_strctPlexon.m_afTempWaveForms,g_strctPlexon.m_strctLastCheck.m_afWaveForms(:,:));
                    end
                end
                % separates spikes from each channel into conditions
                % Find trial start events
                
                
                
                % find next trial end index
                for iTrials = 1:size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices),1)
                    % always try once, in case the buffer contains a partial trial only, so we can fill the temporary buffer
                    
                    
                    
                    % sometimes plexon or kofiko misses a strobe, so we
                    % need to check to make sure we don't have 2 starts and
                    % 1 end
                    
                    %{
                        nextEndIndex = min(...
                        find(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(...
                        iTrials):end,3) == g_strctParadigm.m_strctStatServerDesign.TrialEndCode,1,'first'),...
                        g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials)-1);
                    %}
                    nextEndIndex = find(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(...
                        iTrials):end,3) == g_strctParadigm.m_strctStatServerDesign.TrialEndCode,1,'first');
                    
                    if ~isempty(nextEndIndex)
                        
                        fnCircularBuffer('put','g_strctPlexon','m_afSpikeBuffer',...
                            g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents(g_strctPlexon.m_strctLastCheck.m_iStrobeTrialStartIndices(...
                            iTrials) + 1, 3),... Trial Index ID, should always be the strobe after the trial start
                            g_strctPlexon.m_strctLastCheck.m_afTimeStamps(g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(...
                            iTrials):nextEndIndex + g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials)-1 , :));% Trial Data
                        
                        fnCircularBuffer('put','g_strctPlexon','m_afWaveFormBuffer',...
                            g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents(g_strctPlexon.m_strctLastCheck.m_iStrobeTrialStartIndices(...
                            iTrials) + 1, 3),... Trial Index ID
                            g_strctPlexon.m_strctLastCheck.m_afWaveForms(g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(...
                            iTrials):nextEndIndex + g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials)-1 , :));% Trial Data
                        
                    else
                        % This trial will roll over to the next plexon check. temp store it.
                        clear g_strctPlexon.m_afTempTrial;
                        %{
                        g_strctPlexon.m_afTempTrial = zeros(size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(...
                            g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials):end)));
                        %}
                        g_strctPlexon.m_afTempTrial = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(...
                            g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials):end,:);
                        
                        if g_strctPlexon.m_strctLastCheck.m_iStrobeTrialStartIndices(iTrials) ~= size(g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents,1)
                            g_strctPlexon.m_afTempStrobeID = g_strctPlexon.m_strctLastCheck.m_aiStrobeEvents(...
                                g_strctPlexon.m_strctLastCheck.m_iStrobeTrialStartIndices(iTrials) + 1, 3);
                        else
                            g_strctPlexon.m_afTempStrobeID = [];
                        end
                        clear g_strctPlexon.m_afTempWaveForms;
                        %{
                        g_strctPlexon.m_afTempWaveForms = zeros(size(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(...
                            g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials):end),1),32);
                        %}
                        g_strctPlexon.m_afTempWaveForms = g_strctPlexon.m_strctLastCheck.m_afWaveForms(...
                            g_strctPlexon.m_strctLastCheck.m_iTrialStartIndices(iTrials):end,:);
                        
                        g_strctPlexon.m_bTrialInTempBuffer = 1;
                    end
                    
                end
                
                %{
			g_strctPlexon.m_strctLastCheck.m_iTrialStartIndex = find(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == g_strctParadigm.m_strctStatServerDesign.TrialStartCode);
			g_strctPlexon.m_strctLastCheck.m_iTrialEndIndex = find(g_strctPlexon.m_strctLastCheck.m_afTimeStamps(:,3) == g_strctParadigm.m_strctStatServerDesign.TrialEndCode);


			g_strctPlexon.m_strctLastCheck.m_aiTrialSpikeEvents = g_strctPlexon.m_strctLastCheck.m_afTimeStamps(...
						g_strctPlexon.m_strctLastCheck.m_iTrialStartIndex:g_strctPlexon.m_strctLastCheck.m_iTrialEndIndex,:);
			g_strctPlexon.m_strctLastCheck.m_afTrialWaveForms = g_strctPlexon.m_strctLastCheck.m_afWaveForms(...
						g_strctPlexon.m_strctLastCheck.m_iTrialStartIndex:g_strctPlexon.m_strctLastCheck.m_iTrialEndIndex,:);
					
					
			%trialSpikes = sum(g_strctPlexon.m_strctLastCheck.m_aiTrialSpikeEvents(:,1) == 1)
			
			arrayfun(@(x) g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(1,1:g_strctPlexon.m_afSpikeBuffer.m_aiCircularBufferIndices(1),...
			(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(1,1:g_strctPlexon.m_afSpikeBuffer.m_aiCircularBufferIndices(1),:,3) == 1),:)
			
			
                %}
            case 'UpdateHistogram'
                %{
			% pull out trials in condition one, into 3d array
			data = squeeze(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(1,1:g_strctPlexon.m_afSpikeBuffer.m_aiCircularBufferIndices(1),:,:));
			
			%pull out trial one in condition one into 2d array
			trialOne = squeeze(data(1,:,:));
			
			arrayfun(@(x) data(:,x,:), data(:,:,1) == 1 & data(:,:,3) == 1,'UniformOutput','false')
			arrayfun(@(x) data(:,x,:), sub2ind(data(:,:,1) == 1 & data(:,:,3) == 1),'UniformOutput','false')
			
			%pull out unit 1 timestamps from trial one of condition one
				trialOne(trialOne(:,1) == 1 & trialOne(:,3) == 1,4)
				trialOne(squeeze(data(1,:,:))(:,1) == 1 & squeeze(data(1,:,:))(:,3) == 1,4)
			
			alignedData = squeeze(data(:,:,4) - data(1,:,:) == 1 & data(3,:,:) == 1)
			%for iSpikes = 1:size(data,2)
			for iTrials = 1:size(data,1)
				
					alignedData(iTrials,:,:) = data(iTrials,data(iTrials,:,1) == 1,:)
					alignedData(iTrials,:,4) = alignedData(iTrials,:,4) - data(iTrials,data(iTrials,:,3) == 32698,4)
					

				end
                %}
                
                
                tic
                dataToPlot = fnCircularBuffer('get','g_strctPlexon','m_afSpikeBuffer',...
                    varargin{1},varargin{2});
                %alignedSpikeTimes = zeros(numel(varargin{1}),varargin{2},300); % 300 spikes per trial should be enough
                %fnAlignSpikesToStimulus(dataToPlot)
                %alignedData = zeros(size(dataToPlot));
                %alignedData = zeros(size(dataToPlot));
                
                for iCondition = 1:numel(varargin{1})
                    sizeOfCondition = size(squeeze(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,:)))
                    g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,:)
                    sub2ind(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,3) == 1 &...
                        g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,1) == 1)
                    
                    
                    g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),linIndices)
                    
                    
                    linIndices = (find(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,3) == 1 &...
                        g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,1) == 1))
                    
                    ind2sub(squeeze(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,3) == 1 &...
                        g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(iCondition,:),:,1) == 1),sizeOfCondition)
                    
                    %{
				alignedSpikeTimes(iCondition,1:varargin{2},:) = arrayfun(@(x) g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(iCondition,x,:),...
				...
					g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(...
					iCondition,dataToPlot(varargin{1}(iCondition)),...
					(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,3) ==...
					1) & (g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,1) ==...
																		1)...
																		,4) - ...
									g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(iCondition,dataToPlot(varargin{1}(iCondition)),... % SPIKE TIMES
					(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,3) ==...
																		g_strctParadigm.m_strctStatServerDesign.TrialAlignCode),4));
				
					g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(iCondition,dataToPlot(varargin{1}(iCondition)),... % SPIKE TIMES
					(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,3) ==...
																		g_strctParadigm.m_strctStatServerDesign.TrialAlignCode),4));
                        %}
                        %tic
                        for iTrials = 1:varargin{2}
                            trialAlignTime = g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(iCondition,dataToPlot(varargin{1}(iCondition)),...
                                (g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,3) ==...
                                g_strctParadigm.m_strctStatServerDesign.TrialAlignCode),4);
                            %g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer g_strctPlexon.m_afSpikeBuffer.m_aiCircularBufferIndices(conditionIndex(i))
                            numSpikesInThisTrial = sum((g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,3) ==...
                                1) & (g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,1) ==...
                                1));
                            alignedSpikeTimes(iCondition,iTrials,1:numSpikesInThisTrial) = g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(...
                                iCondition,dataToPlot(varargin{1}(iCondition)),...
                                (g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,3) ==...
                                1) & (g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),dataToPlot(varargin{1}(iCondition),iTrials),:,1) ==...
                                1)...
                                ,4) - trialAlignTime;
                            
                        end
                        %fprintf('loop takes %s\n',num2str(toc));
                        %}
                        %{
					(varargin{1}(iCondition),iTrials,1:...
					sum(g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(varargin{1}(iCondition),iTrials,:,3) == 1),... % # of spikes in this trial
					:) =...
					g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer(iCondition,dataToPlot(iCondition,iTrials),:,:)
			
            
                    %spikesInThisTrial = size(dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,1) == 1,:),3);
                    alignedData(varargin{1}(iCondition),iTrials,1:size(dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,1) == 1,:),3),:) = ...
                        dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,1) == 1,:);
                    
                    if any( alignedData(varargin{1}(iCondition),iTrials,:,4)) && ...
                            any(dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,3) == g_strctParadigm.m_strctStatServerDesign.TrialAlignCode,4))
                        alignedData(varargin{1}(iCondition),iTrials,:,4) = alignedData(varargin{1}(iCondition),iTrials,:,4) -...
                            dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,3) == g_strctParadigm.m_strctStatServerDesign.TrialAlignCode,4);
						end
                
                        %}
                        %tic
                        
                        
                        
                        
                        % temporary crap to pull unit one spikes out of the data
                        %{
				columnOneLogical = logical(reshape(alignedData(iCondition,:,:,1),[1,numel(alignedData(iCondition,:,:,1))]));
                columnThreeLogical = logical(reshape(alignedData(iCondition,:,:,3),[1,numel(alignedData(iCondition,:,:,3))]));
                columnFourReshape = reshape(alignedData(iCondition,:,:,4),[1,numel(alignedData(iCondition,:,:,4))]);
                g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition = columnFourReshape(columnOneLogical & columnThreeLogical);
                
                
               g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_aiHistData = hist(g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition(...
                g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition >= g_strctPlexon.m_strctStatistics.m_iPreTrialTime & ...
                 g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition <= g_strctPlexon.m_strctStatistics.m_iPostTrialTime),20);
                        %}
                        
                        %columnOneLogical = logical(reshape(alignedData(iCondition,:,:),[1,numel(alignedData(iCondition,:,1))]));
                        %columnThreeLogical = logical(reshape(alignedData(iCondition,:,:,3),[1,numel(alignedData(iCondition,:,:,3))]));
                        %columnFourReshape = reshape(alignedData(iCondition,:,:,4),[1,numel(alignedData(iCondition,:,:,4))]);
                        indices = alignedSpikeTimes(iCondition,:,:) ~= 0 & alignedSpikeTimes(iCondition,:,:) > g_strctPlexon.m_strctStatistics.m_iPreTrialTime;
                        logicalIndex = reshape(indices(:,:,:),[1,numel(indices)]);
                        spikes = reshape(alignedSpikeTimes(iCondition,:,:),[1,numel(alignedSpikeTimes(iCondition,:,:))]);
                        g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition = ...
                            spikes(logicalIndex);
                        
                        
                        %{
				indices = alignedSpikeTimes(iCondition,:,:) ~= 0 & alignedSpikeTimes(iCondition,:,:) > g_strctPlexon.m_strctStatistics.m_iPreTrialTime;
				array = alignedSpikeTimes(iCondition,:,:);
				array(iCondition,:,indices)
				x = reshape(indices(:,:,:),[1,numel(indices)]);
				
				z = reshape(alignedSpikeTimes(iCondition,:,:),[1,numel(alignedSpikeTimes(iCondition,:,:))])
				reshape(alignedSpikeTimes(iCondition,:,:),[1,cumsum(alignedSpikeTimes(iCondition,:,:)~= 0)]);
                            %}
                            
                            
                            
                            %columnFourReshape(columnOneLogical & columnThreeLogical);
                            
                            
                            g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_aiHistData = hist(g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition(...
                                g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition >= g_strctPlexon.m_strctStatistics.m_iPreTrialTime & ...
                                g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition <= g_strctPlexon.m_strctStatistics.m_iPostTrialTime),20);
                            % g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_aiHistData = hist(g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afUnitOneTimesByCondition,100);
                            
                            %  alignedDataThisCondition = squeeze(alignedData(varargin{1}(iCondition),:,:,:));
                            % alignedDataByCondition(iCondition) = cat(3,squeeze(alignedDataThisCondition(iCondition,:,logical(alignedData(iCondition,:,:,1)),:)))
                end
                fprintf('assignment takes %s\n',num2str(toc));
                % unitOneTimes = alignedData(:,:,alignedData(:,:,:,1) == 1 & alignedData(:,:,:,3) == 1,:)
                %{
            columnOneLogical = logical(reshape(alignedData(:,:,:,1),[1,numel(alignedData(:,:,:,1))]));
            columnThreeLogical = logical(reshape(alignedData(:,:,:,3),[1,numel(alignedData(:,:,:,3))]));
            columnFourReshape = reshape(alignedData(:,:,:,4),[1,numel(alignedData(:,:,:,4))]);
            g_strctPlexon.m_afUnitOneTimesByCondition = columnFourReshape(columnOneLogical & columnThreeLogical);
           
            g_strctPlexon.m_strctStatistics.m_hHistogram = figure();
            
            figure(g_strctPlexon.m_strctStatistics.m_hHistogram);
           
                %}
                % unitOneTimes = alignedData(:,:,alignedData(:,:,:,1) == 1 & alignedData(:,:,:,3) == 1,:);
                tic
                CurrFig = gcf;
                if isempty(g_strctPlexon.m_strctStatistics.m_hHistogram)
                    
                    g_strctPlexon.m_strctStatistics.m_hHistogram = figure();
                    
                    
                end
                figure(g_strctPlexon.m_strctStatistics.m_hHistogram);
                
                imagesc(vertcat(g_strctPlexon.m_strctStatistics.m_strctCondition(:).m_aiHistData));
                
                
                set(gca,'XTickLabel',[g_strctPlexon.m_strctStatistics.m_iPreTrialTime:.05:g_strctPlexon.m_strctStatistics.m_iPostTrialTime]*1000,...
                    'XTick',linspace(0,100,numel([g_strctPlexon.m_strctStatistics.m_iPreTrialTime:.05:g_strctPlexon.m_strctStatistics.m_iPostTrialTime]*1000)));
                
                fprintf('figure takes %s\n',num2str(toc));
                %colorbar;
                
                
                %{
            hold on
            for i = 1:numel(varargin{1})
                plot(g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_aiHistData);
            end
            hold off
                %}
                figure(CurrFig);
                
                
                g_strctPlexon.m_strctStatistics.m_aiPolarPlottingArray = zeros(numel(varargin{1}),2);
                g_strctPlexon.m_strctStatistics.m_aiPolarPlottingArray(:,1) = 1:numel(varargin{1});
                
            case 'UpdateRaster'
                
			%dataToPlot = fnCircularBuffer('get','g_strctPlexon','m_afSpikeBuffer',...
			%				varargin{1},varargin{2});
			%	fCurrTime = GetSecs();
			%fCurrTime - g_strctPlexon.m_afCurrentServerTime(2)
			%ServerTimeOffset = g_strctPlexon.m_afCurrentServerTime(1)-g_strctPlexon.m_afCurrentServerTime(2);
			%newtimes = g_strctPlexon.m_afRollingSpikeBuffer.Buf(1 : g_strctPlexon.m_afRollingSpikeBuffer.BufID, 4) + abs(ServerTimeOffset);
			SpikesToPlot = [];
			%SpikesToPlot= GetSecs() - newtimes(GetSecs() - newtimes < g_strctPlexon.m_strctStatistics.m_fRasterTrailMS * 1e-3);
			SpikesToPlot= GetSecs() - g_strctPlexon.m_afRollingSpikeBuffer.Buf(GetSecs() - ...
					g_strctPlexon.m_afRollingSpikeBuffer.Buf(1 : g_strctPlexon.m_afRollingSpikeBuffer.BufID, 4)...
								< g_strctPlexon.m_strctStatistics.m_fRasterTrailMS * 1e-3,4);
            
            PlottingRectWindowSize(1) = round(abs(g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1) -...
														g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(3)));
             PlottingRectWindowSize(2) = round(abs(g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(2) -...
														g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4)));
            %g_strctPlexon.m_aiRasterPlottingArray = zeros(2,2*60);
			%SpikesToPlot
          
			
			%numBins = g_strctPlexon.m_strctStatistics.m_iRasterUpdateHz*g_strctPlexon.m_strctStatistics.m_fRasterTrailMS * 1e-3;
			%tmpArray1 = round(linspace(1,PlottingRectWindowSize(1),60))+g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1);
                                                    %{
				g_strctPlexon.m_aiRasterPlottingArray(1,:) = round(linspace(1,abs(g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1) -...
														g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(3)), PlottingRectWindowSize) + ... 
														g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1));
                                              %}      
                                                    
			%g_strctPlexon.m_aiRasterPlottingArray(2,:) = round((SpikesToPlot / max(SpikesToPlot)) * PlottingRectWindowSize
			spikeCounts = hist(SpikesToPlot,60);
            spikeCounts = spikeCounts/max(spikeCounts);
           % tmpArray2 = round(spikeCounts *  PlottingRectWindowSize(2)) + g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(2);
            g_strctPlexon.m_aiRasterPlottingArray = zeros(2,size(spikeCounts,2)*2-1);
            
            tmpArray1 = round(linspace(1,PlottingRectWindowSize(1),60));
            tmpArray2 = round(linspace(1,PlottingRectWindowSize(1),60));
            tmpArray3 = abs(round(spikeCounts *  PlottingRectWindowSize(2))-g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4));
            g_strctPlexon.m_aiRasterPlottingArray(1,1:2:end) = tmpArray1 + g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1);
            g_strctPlexon.m_aiRasterPlottingArray(1,2:2:end-1) = tmpArray1(2:end) + g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1);
            g_strctPlexon.m_aiRasterPlottingArray(2,1:2:end) = tmpArray3;
            g_strctPlexon.m_aiRasterPlottingArray(2,2:2:end-1) = tmpArray3(2:end);
            
            %+fnTsGetVar('g_strctParadigm','rasterPlotX');
           % g_strctPlexon.m_aiRasterPlottingArray(1,1:2:end-1) = round(linspace(1,PlottingRectWindowSize(1),60))+fnTsGetVar('g_strctParadigm','rasterPlotX');
         %  tmpArray3 =  abs(round(spikeCounts *  PlottingRectWindowSize(2))-g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4));
            %g_strctPlexon.m_aiRasterPlottingArray(2,2:2:end) = round(spikeCounts *  PlottingRectWindowSize(2))+ fnTsGetVar('g_strctParadigm','rasterPlotY');
           % g_strctPlexon.m_aiRasterPlottingArray(1,:) = tmpArray1(2:end);
			%g_strctPlexon.m_aiRasterPlottingArray(2,:) = tmpArray2(2:end);
            %abs(g_strctPlexon.m_aiRasterPlottingArray(2,:)-500)]
			%g_strctPlexon.m_aiRasterPlottingArray(2,:) = round((spikeCounts/max(spikeCounts)*100));
			%g_strctPlexon.m_aiRasterPlottingArray(1:2:end-1,:) = round(linspace(1,PlottingRectWindowSize(1),60))+g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(1);
			%{
            g_strctPlexon.m_aiRasterPlottingArray(1,1:2:end-1) = round(linspace(1,PlottingRectWindowSize(1),60))+g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(3);
            g_strctPlexon.m_aiRasterPlottingArray(1,2:2:end) = round(linspace(1,PlottingRectWindowSize(1),60))+g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(3);
            g_strctPlexon.m_aiRasterPlottingArray(2,1:2:end-1) = round(spikeCounts *  PlottingRectWindowSize(2))+ g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4);
            g_strctPlexon.m_aiRasterPlottingArray(2,2:2:end) = round(spikeCounts *  PlottingRectWindowSize(2))+ g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4);
			%}
			
			%{
			g_strctPlexon.m_aiRasterPlottingArray(1,1:2:end-1) = round(linspace(1,PlottingRectWindowSize(1),60))+g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(3);
            g_strctPlexon.m_aiRasterPlottingArray(1,2:2:end) = round(linspace(1,PlottingRectWindowSize(1),60))+g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(3);
            g_strctPlexon.m_aiRasterPlottingArray(2,1:2:end-1) = round(spikeCounts *  PlottingRectWindowSize(2))+ g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4);
            g_strctPlexon.m_aiRasterPlottingArray(2,2:2:end) = round(spikeCounts *  PlottingRectWindowSize(2))+ g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(4);
			%}
			%{
			g_strctPlexon.m_aiRasterPlottingArray(1,1:2:end-1) = round(linspace(1,PlottingRectWindowSize(1),60))+fnTsGetVar('g_strctParadigm','rasterPlotX');
            g_strctPlexon.m_aiRasterPlottingArray(1,2:2:end) = round(linspace(1,PlottingRectWindowSize(1),60))+fnTsGetVar('g_strctParadigm','rasterPlotX');
            g_strctPlexon.m_aiRasterPlottingArray(2,1:2:end-1) = round(spikeCounts *  PlottingRectWindowSize(2))+ fnTsGetVar('g_strctParadigm','rasterPlotY');
            g_strctPlexon.m_aiRasterPlottingArray(2,2:2:end) = round(spikeCounts *  PlottingRectWindowSize(2))+ fnTsGetVar('g_strctParadigm','rasterPlotY');
            %}
            
            
            
			%g_strctPlexon.m_aiRasterPlottingArray(2,:) = round(spikeCounts *  PlottingRectWindowSize(2))+ g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect(2);
			%g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect = [1000,500,1400,600];

            % normalize 
			%g_strctPlexon.m_aiRasterPlottingArray = g_strctPlexon.m_aiRasterPlottingArray * max(g_strctPlexon.m_aiRasterPlottingArray);
			
			case 'UpdatePolar'
                dataToPlot = fnCircularBuffer('get','g_strctPlexon','m_afSpikeBuffer',...
                    varargin{1},varargin{2});
                for iCondition = 1:numel(varargin{1})
                    for iTrials = 1:varargin{2}
                        %spikesInThisTrial = size(dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,1) == 1,:),3);
                        alignedData(varargin{1}(iCondition),iTrials,1:size(dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,1) == 1,:),3),:) = ...
                            dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,1) == 1,:);
                        
                        if any( alignedData(varargin{1}(iCondition),iTrials,:,4)) && ...
                                any(dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,3) == g_strctParadigm.m_strctStatServerDesign.TrialAlignCode,4))
                            alignedData(varargin{1}(iCondition),iTrials,:,4) = alignedData(varargin{1}(iCondition),iTrials,:,4) -...
                                dataToPlot(varargin{1}(iCondition),iTrials,dataToPlot(varargin{1}(iCondition),iTrials,:,3) == g_strctParadigm.m_strctStatServerDesign.TrialAlignCode,4);
                            
                            
                        end
                        
                        
                    end
                    columnOneLogical = logical(reshape(dataToPlot(iCondition,:,:,1),[1,numel(dataToPlot(iCondition,:,:,1))]));
                    columnThreeLogical = logical(reshape(dataToPlot(iCondition,:,:,3),[1,numel(dataToPlot(iCondition,:,:,3))]));
                    columnFourReshape = reshape(dataToPlot(iCondition,:,:,4),[1,numel(dataToPlot(iCondition,:,:,4))]);
                    g_strctPlexon.m_strctStatistics.m_strctCondition(iCondition).m_afPolarPlotByCondition =...
                        size(columnFourReshape(columnOneLogical & columnThreeLogical),2);
                    
                end
                
                
                normalizedSpikes = ([g_strctPlexon.m_strctStatistics.m_strctCondition(:).m_afPolarPlotByCondition]./...
                    max([g_strctPlexon.m_strctStatistics.m_strctCondition(:).m_afPolarPlotByCondition]));
                centerOfCircle = [range([g_strctPlexon.m_strctStatistics.m_afPolarRect(1),g_strctPlexon.m_strctStatistics.m_afPolarRect(3)])/2 + g_strctPlexon.m_strctStatistics.m_afPolarRect(1),...
                    range([g_strctPlexon.m_strctStatistics.m_afPolarRect(2),g_strctPlexon.m_strctStatistics.m_afPolarRect(4)])/2 + g_strctPlexon.m_strctStatistics.m_afPolarRect(2)];
                
                
                polarRadius = range([g_strctPlexon.m_strctStatistics.m_afPolarRect(2),g_strctPlexon.m_strctStatistics.m_afPolarRect(4)])/2;
                rotAngles = [1:size(dataToPlot,1)]./size(dataToPlot,1) * 2 * pi;
                if any(normalizedSpikes)
                    [g_strctPlexon.m_strctStatistics.m_afPolarPlottingArray(:,1), g_strctPlexon.m_strctStatistics.m_afPolarPlottingArray(:,2)] =...
                        fnRotateAroundPoint(centerOfCircle(1) ,(centerOfCircle(2) + (normalizedSpikes(:) * polarRadius))' ,...
                        centerOfCircle(1), centerOfCircle(2), rad2deg(rotAngles));
                    %g_strctPlexon.m_bDrawToPTBScreen = 1;
                    Screen('FrameOval',g_strctPTB.m_hWindow, g_strctPlexon.m_strctStatistics.m_afPolarOutlineColors, g_strctPlexon.m_strctStatistics.m_afPolarRect)
                    Screen('FramePoly',g_strctPTB.m_hWindow, g_strctPlexon.m_strctStatistics.m_afPolarColors, g_strctPlexon.m_strctStatistics.m_afPolarPlottingArray)
                else
                    
                end
                %Screen('FrameOval',g_strctPTB.m_hWindow, g_strctPTB.m_afPolarOutlineColors, g_strctPTB.m_afColorPolarRect)
                %Screen('FramePoly',g_strctPTB.m_hWindow, g_strctPTB.m_afPolarColors, g_strctParadigm.m_strctStatistics.m_afColorPolarPlottingArray)
        end
    end
end

%toc
return;



%{

		polarRadius = range([g_strctPTB.m_afPolarRect(2),g_strctPTB.m_afPolarRect(4)])/2; % Should always be a square, so we can use x or y. Using y here
		centerOfCircle = [range([g_strctPTB.m_afPolarRect(1),g_strctPTB.m_afPolarRect(3)])/2 + g_strctPTB.m_afPolarRect(1),...
						   range([g_strctPTB.m_afPolarRect(2),g_strctPTB.m_afPolarRect(4)])/2 + g_strctPTB.m_afPolarRect(2)];
		% Normalize the radius to the highest spike count

		%normalizedRadius = polarRadius/max(g_strctPlexon.m_afConditionSpikes);
		% Weighted Average the latest trial into the condition
		

		% Setup array for polar plotting

		numConditions = numel(fields(g_strctPlexon.m_afConditionSpikes));
		g_strctPlexon.m_afPolarPlottingArray  = zeros(numConditions,2);

        maximums = zeros(numConditions,1);
		for i = 1:numConditions
			
			cond = ['condition',num2str(i)];
			maximums(i) = mean(sum([g_strctPlexon.m_afConditionSpikes.(cond)(g_strctPlexon.m_afConditionSpikes.(cond)(:,2) == 1)],2));
        end
        %maximums(isnan(maximums)) = 0;
            %maximums(maximums == NaN) = 0;
        normMax = max(maximums);
            
		normalizedSpikes = zeros(numConditions,1);
		for i = 1:numConditions
            if isnan(normMax)
                normalizedSpikes(i) = 0;
            else
                normalizedSpikes(i) = maximums(i)/normMax;
            end
		   rotAngle = (i/numConditions) * 2 * pi;
		  % g_strctPlexon.m_afPolarArray(i,1) =
		   [g_strctPlexon.m_afPolarPlottingArray(i,1), g_strctPlexon.m_afPolarPlottingArray(i,2)] = fnRotateAroundPoint(centerOfCircle(1) ,centerOfCircle(2) + (normalizedSpikes(i) * polarRadius) ,...
                                                                    centerOfCircle(1), centerOfCircle(2), rotAngle);
		   %PolarArray(i,3) =
			
			%PolarArray(i,2) = normalizedSpikes(i);
		end
	%disp(g_strctPlexon.m_afPolarPlottingArray)
	%disp(normalizedSpikes)

return;
%}



