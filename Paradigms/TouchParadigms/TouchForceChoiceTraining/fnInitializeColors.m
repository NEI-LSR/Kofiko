function fnInitializeColors()
global g_strctParadigm

% conversion matrices and the gamme correction tables
g_strctParadigm.m_strctGammaCorrectedLookupTable = load('gammaCorrectedLookUpTable');
g_strctParadigm.m_strctConversionMatrices = load('ConversionMatrices');

% how many colors per saturation/chroma
g_strctParadigm.m_aiNumPresetSaturationColors = g_strctParadigm.m_afInitial_NumColorsPerSaturations;

% name of the saturation or chroma level
g_strctParadigm.m_acstrSaturationsLookupDKL = strsplit(g_strctParadigm.m_strInitial_SaturationsLookupDKL);
g_strctParadigm.m_acstrChromaLookupLUV = strsplit(g_strctParadigm.m_strInitial_ChromaLookupLUV);

% saturations and luminance elevations
g_strctParadigm.m_aiPresetDKLSaturations = g_strctParadigm.m_afInitial_SaturationsDKL;
g_strctParadigm.m_aiPresetLUVChroma = g_strctParadigm.m_afInitial_ChromaLUV;
g_strctParadigm.m_aiPresetElevationsDKL = g_strctParadigm.m_afInitial_SaturationsElevationDKL;
g_strctParadigm.m_aiPresetElevationsLUV = g_strctParadigm.m_afInitial_ChromaElevationsLUV;

% which color conversion is being used (Currently 1 is LUV 2 is DKL)
g_strctParadigm.m_iCurrentColorConversionID = g_strctParadigm.m_fInitial_ColorConversionID;
g_strctParadigm.m_acAvailableColorSpaceNames = strsplit(g_strctParadigm.m_strInitial_ColorSpaceNames);
g_strctParadigm.m_strCurrentConversionType = g_strctParadigm.m_acAvailableColorSpaceNames{g_strctParadigm.m_iCurrentColorConversionID};
g_strctParadigm.m_cMasterColorTableLookup{1} = g_strctParadigm.m_acstrChromaLookupLUV;
g_strctParadigm.m_cMasterColorTableLookup{2} = g_strctParadigm.m_acstrSaturationsLookupDKL;

% feeds in color tuning data
g_strctParadigm.m_StartingHue = fnTsGetVar('g_strctParadigm','StartingHue');

% generates 19-stimulus triangular tesselation in CIELUV
g_strctParadigm.m_aPolarCoordinatesarAngs = mod(linspace(g_strctParadigm.m_StartingHue,g_strctParadigm.m_StartingHue+360-(360/6),6), 360); %Compute 6 exterior points
[a,b] = g_strctParadigm.m_aPolarCoordinates2cart(deg2rad(g_strctParadigm.m_aPolarCoordinatesarAngs),ones(1,6)*maxSat); %Convert g_strctParadigm.m_aPolarCoordinatesar co-ordinates to cartesian co-ordinates
g_strctParadigm.m_aCartesianCoordinates = [a;b];
for i = 1:6
    inbetween = [g_strctParadigm.m_aCartesianCoordinates(1,i)/2;g_strctParadigm.m_aCartesianCoordinates(2,i)/2];
    g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,inbetween];
end
for i = 1:5
    inbetween = [(g_strctParadigm.m_aCartesianCoordinates(1,i)+g_strctParadigm.m_aCartesianCoordinates(1,i+1))/2;(g_strctParadigm.m_aCartesianCoordinates(2,i)+g_strctParadigm.m_aCartesianCoordinates(2,i+1))/2];
    g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,inbetween];
end
inbetween = [(g_strctParadigm.m_aCartesianCoordinates(1,6)+g_strctParadigm.m_aCartesianCoordinates(1,1))/2;(g_strctParadigm.m_aCartesianCoordinates(2,6)+g_strctParadigm.m_aCartesianCoordinates(2,1))/2];
g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,inbetween];
g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,[0;0]]; %add origin
g_strctParadigm.m_aCartesianCoordinates = g_strctParadigm.m_aCartesianCoordinates(:,[1,13,2,14,3,15,4,16,5,17,6,18,7,8,9,10,11,12,19]); 

[g_strctParadigm.m_aPolarCoordinates(1,:),g_strctParadigm.m_aPolarCoordinates(2,:)] = cart2g_strctParadigm.m_aPolarCoordinates(g_strctParadigm.m_aCartesianCoordinates(1,:),g_strctParadigm.m_aCartesianCoordinates(2,:));
g_strctParadigm.m_aPolarCoordinates(1,:) = round(rad2deg(g_strctParadigm.m_aPolarCoordinates(1,:)));
g_strctParadigm.m_aPolarCoordinates(1,g_strctParadigm.m_aPolarCoordinates(1,:)<0) = 360+g_strctParadigm.m_aPolarCoordinates(1,g_strctParadigm.m_aPolarCoordinates(1,:)<0); % the rad2deg remapping puts 190deg as -170deg (for example) - I want everything positive from 0 -> 360.


g_strctParadigm.m_aAllStimulusHues = g_strctParadigm.m_aPolarCoordinates(1,:); 
g_strctParadigm.m_aAllStimulusSats = g_strctParadigm.m_aPolarCoordinates(2,:);

end

% load information for LUV colors and initialize the matrices
for iChroma = 1:numel(g_strctParadigm.m_aiPresetLUVChroma)
	if iChroma == 1 
		iStimuli = [1 3 5 7 9 11];
	elseif iChroma==2
		iStimuli = [2 4 6 8 10 12];
	elseif iChroma==3
		iStimuli = [13 14 15 16 17 18];
	elseif iChroma==4
		iStimuli = 19;
	end;
	
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps = deg2rad(g_strctParadigm.m_aPolarCoordinates(1, iStimuli));
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).Radius = g_strctParadigm.m_aiPresetLUVChroma(iChroma)/100;
	
    
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afCartCoordinates(:,2) = g_strctParadigm.m_aCartesianCoordinates(1,iStimuli)/100;
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afCartCoordinates(:,3) = g_strctParadigm.m_aCartesianCoordinates(2,iStimuli)/100;
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afCartCoordinates(:,1) = ones(19,1) * (g_strctParadigm.m_aiPresetElevationsLUV(iChroma)/100);
	
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_fElevation = g_strctParadigm.m_aiPresetElevationsLUV(iChroma);
	
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afSphereCoordinates = ...
        [g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps',...
        ones(numel(g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps),1) * g_strctParadigm.m_aiPresetElevationsLUV(iChroma),...
        ones(numel(g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps),1) * g_strctParadigm.m_aiPresetLUVChroma(iChroma)/100];
                                   
    uncorrectedRGB = luv2rgb([ones(19,1) * g_strctParadigm.m_aiPresetElevationsLUV(iChroma),g_strctParadigm.m_aCartesianCoordinates(1,iStimuli)',g_strctParadigm.m_aCartesianCoordinates(2,iStimuli)'])*65535;
    for iRGB = 1:size(uncorrectedRGB,1)
        g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).RGB(iRGB,:) = ...
        [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedRGB(iRGB,1)+1)),...
        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedRGB(iRGB,2)+1)),...
        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedRGB(iRGB,3)+1))];
    end
                                                            
    	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_strName = g_strctParadigm.m_acstrChromaLookupLUV{iChroma};
	

end


% load information for DKL colors and initialize the matrices (not using DKL, so this is the old version)
for iSaturations = 1:numel(g_strctParadigm.m_aiPresetDKLSaturations)
	g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).azimuthSteps = ...
									deg2rad(0:360/g_strctParadigm.m_aiNumPresetSaturationColors(iSaturations):359.99);
                                
    g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).Radius = g_strctParadigm.m_aiPresetDKLSaturations(iSaturations)/100;
        
	[x, y, z] = sph2cart(g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).azimuthSteps, ...
		ones(1,numel(g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).azimuthSteps)) * ...
			(0 ), g_strctParadigm.m_aiPresetDKLSaturations(iSaturations)/100) ;
        
    g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).m_afCartCoordinates(:,1) = x;
	g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).m_afCartCoordinates(:,2) = y;
	g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).m_afCartCoordinates(:,3) = ...
                                                                                g_strctParadigm.m_aiPresetElevationsDKL(iSaturations);
     
	g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).m_fElevation = ...
																					g_strctParadigm.m_aiPresetElevationsDKL(iSaturations)/100;
	 
    g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).m_afSphereCoordinates = ...
        [g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).azimuthSteps',...
        ones(numel(g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).azimuthSteps),1) * ...
                                                                            g_strctParadigm.m_aiPresetElevationsDKL(iSaturations),...
        ones(numel(g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).azimuthSteps),1) * ...
                                                                                 g_strctParadigm.m_aiPresetDKLSaturations(iSaturations)/100];
    uncorrectedRGB = (ldrgyv2rgb(ones(1,numel(x)) * g_strctParadigm.m_aiPresetElevationsDKL(iSaturations),x,y)*65535)';
    for iRGB = 1:size(uncorrectedRGB,1)
        g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).RGB(iRGB,:) = ...
                                                        [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedRGB(iRGB,1)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedRGB(iRGB,2)+1)),...
                                                        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedRGB(iRGB,3)+1))];
														
														
    end
	g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations}).m_strName = g_strctParadigm.m_acstrSaturationsLookupDKL{iSaturations};
end

return;