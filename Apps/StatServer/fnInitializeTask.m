function fnInitializeTask(TaskName)
global g_strctConfig g_strctStatistics

% Disable all plots
allPlotTypes = fieldnames(g_strctConfig.m_strctEnabledPlots)
for iFields = 1:numel(allPlotTypes)
	g_strctConfig.m_strctEnabledPlots.(allPlotTypes{iFields}) = false;
end
	% Clear the statistics struct and setup default values for all tasks
	g_strctStatistics = [];
	g_strctStatistics.m_bDebugModeEnabled = 0;
switch TaskName
	case 'RingAFC'
		
		
		% enable default plot for this task
		g_strctConfig.m_strctEnabledPlots.m_bTrialCorrectIncorrect = true;
		
		
		
		% update initialization information
		g_strctConfig.m_bRingAFCTaskInitialized = true;
		g_strctConfig.m_bHandMapperTaskInitialized = false;
		
	case 'HandMapper'
		% enable default plot for this task
	
		g_strctConfig.m_strctEnabledPlots.m_bPSTHEnabled = true;
		g_strctConfig.m_strctEnabledPlots.m_bImagePlotEnabled = true;
		
		% Clear the statistics struct and setup default values for this task		
		g_strctStatistics = [];
		%g_strctStatistic.m_iNumOrientationBins = 20;
		%g_strctStatistics.m_strctMovingBarStats.m_iOrientationBinID = zeros(g_strctStatistic.m_iNumOrientationBins,1);
		%g_strctStatistic.m_iNumColorBins = 16;
		g_strctStatistics.m_aiColorSpikeHolder = zeros(16,5000,5);
		g_strctStatistics.m_aiOrientationSpikeHolder = zeros(20,5000,5);
		g_strctStatistics.m_aiColorSpikeHolderIDX = ones(16,5);
		g_strctStatistics.m_aiOrientationSpikeHolderIDX = ones(20,5);

		g_strctStatistics.uniquexyYCoordinates = [];
		g_strctStatistics.numTrackedNonPresetColors = 1;



		g_strctStatistics.preTrialWindow = -.05;
		g_strctStatistics.curTrialWindow = .4;


		g_strctStatistics.m_aiDKLCoorindateSpikeHolder = zeros(200,5000,5);
		g_strctStatistics.m_aiDKLCoorindateSpikeHolderIDX = ones(200, 5);
		g_strctStatistics.trackedDKLCoordinates = [];

		g_strctStatistics.m_aiSpikePositionBinGrid = [12,20]; 
		g_strctStatistics.m_aiSpikePositionBinsSpikeHolder = zeros(12*20,5,5000);
		g_strctStatistics.m_aiSpikePositionBinsSpikeHolderIDX = ones(12*20,5);
		g_strctStatistics.m_aiSpikePositionBinsTrialCounter = zeros(12*20,5);
		g_strctStatistics.m_afPositionMappingSpikeIntegrationTimeMS = [.05,.2];

		g_strctStatistics.m_aiDKLCoorindateColorMatchingTable = [];
		g_strctStatistics.m_aiDKLCoorindateColorTrialCounter = zeros(200,5);


		g_strctStatistics.m_aiLUVCoorindateColorMatchingTable =  [];
		g_strctStatistics.m_aiLUVCoorindateColorTrialCounter = zeros(200,5);

		g_strctStatistics.m_aiLUVCoorindateSpikeHolder = zeros(200,5000,5);
		g_strctStatistics.m_aiLUVCoorindateSpikeHolderIDX = ones(200, 5);
		g_strctStatistics.trackedLUVCoordinates = [];



		if exist('Z:\calibrationData\colorVals.mat')
			strctColorValues = load('Z:\calibrationData\colorVals.mat');
			strctColorValues.fieldNames = fieldnames(strctColorValues);
			strctColorValues.fieldNames = sort(strctColorValues.fieldNames);
			strctColorValues.allDKLCoordinates = [];
			strctColorValues.allRGBValues = [];
			for iNumFields = 1: size(strctColorValues.fieldNames,1)
				nameOfField = strctColorValues.fieldNames{iNumFields};
				strctColorValues.allDKLCoordinates = vertcat(strctColorValues.allDKLCoordinates, strctColorValues.(nameOfField).xyY);
				strctColorValues.allRGBValues = vertcat(strctColorValues.allRGBValues, strctColorValues.(nameOfField).RGB);
			end
			g_strctStatistics.trackedDKLCoordinates  = nan(size(strctColorValues.allDKLCoordinates,1),size(strctColorValues.allDKLCoordinates,2));
			
		else
			g_strctStatistics.trackedDKLCoordinates  = [];
		end


		g_strctStatistics.m_aiActiveUnits = [];

					  


		g_strctStatistics.m_strctGammaCorrectedLookupTable = load('gammaCorrectedLookUpTable');
		g_strctStatistics.m_strctConversionMatrices = load('ConversionMatrices');
		g_strctStatistics.m_iTrialIter = 1;

		
		
		% update initialization information
		g_strctConfig.m_bRingAFCTaskInitialized = false;
		g_strctConfig.m_bHandMapperTaskInitialized = true;
end
return;