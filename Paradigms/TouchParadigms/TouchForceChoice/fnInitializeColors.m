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

% load information for DKL colors and initialize the matrices
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

% load information for LUV colors and initialize the matrices
for iChroma = 1:numel(g_strctParadigm.m_aiPresetLUVChroma)
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps = ...
									deg2rad(0:360/g_strctParadigm.m_aiNumPresetSaturationColors(iSaturations):359.99);
                                
    g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).Radius = g_strctParadigm.m_aiPresetLUVChroma(iChroma)/100;
        
	[luvCoords(2,:),luvCoords(3,:),luvCoords(1,:)] = sph2cart(g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps, ...
		ones(1,numel(g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps)) * ...
			(0 ), g_strctParadigm.m_aiPresetLUVChroma(iChroma)/100) ;
        
    g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afCartCoordinates(:,2) = luvCoords(2,:);
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afCartCoordinates(:,3) = luvCoords(3,:);
	g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afCartCoordinates(:,1) = ...
                                                                                           g_strctParadigm.m_aiPresetElevationsLUV(iChroma)/100;
																						   
    g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_fElevation = g_strctParadigm.m_aiPresetElevationsLUV(iChroma);
	
    g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_afSphereCoordinates = ...
        [g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps',...
        ones(numel(g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps),1) * g_strctParadigm.m_aiPresetElevationsLUV(iChroma),...
        ones(numel(g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).azimuthSteps),1) * g_strctParadigm.m_aiPresetLUVChroma(iChroma)/100];
                                   
    uncorrectedRGB = luv2rgb([ones(numel(x),1) * g_strctParadigm.m_aiPresetElevationsLUV(iChroma),luvCoords(2,:)'.*100,luvCoords(3,:)'.*100])*65535;
    for iRGB = 1:size(uncorrectedRGB,1)
        g_strctParadigm.m_strctMasterColorTable{1}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).RGB(iRGB,:) = ...
        [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(uncorrectedRGB(iRGB,1)+1)),...
        g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(uncorrectedRGB(iRGB,2)+1)),...
        g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(uncorrectedRGB(iRGB,3)+1))];
    end
                                                            
    	g_strctParadigm.m_strctMasterColorTable{2}.(g_strctParadigm.m_acstrChromaLookupLUV{iChroma}).m_strName = g_strctParadigm.m_acstrChromaLookupLUV{iChroma};

end


return;