function [rgbNew, rgbInd, clutIndices, rgbControlComputer] = fnCreateNestedChoiceCircleAFC()
global g_strctParadigm


%clear choice parameters
%g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngles = [];
%g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho = [];
%g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRGB = [];
g_strctParadigm.m_strctChoiceVars.choiceParameters = [];
% keep track of the last used CLUT offset
% paradigm level offset is 2, one for the photodiode black and one for the
% background
lastClutOffset = g_strctParadigm.CLUTOffset;

[iChoiceRingSize] = fnTsGetVar('g_strctParadigm','ChoiceRingSize');
%[iChoiceRingNumRings]  = numel(get(g_strctParadigm.m_strctControllers.m_hChoiceSaturationLists,'value'));
iChoiceRingNumRings = numel(g_strctParadigm.m_strChromaLookupLUV);

conversionTypes = get(g_strctParadigm.m_strctControllers.m_hChoiceColorConversionType,'string');
conversionTypeID = get(g_strctParadigm.m_strctControllers.m_hChoiceColorConversionType,'value');

choiceSaturations = g_strctParadigm.m_strChromaLookupLUV;
choiceSaturationsID = 1:4; % hard-coded for triangular tessalation


for iChoiceSaturations = 1:numel(choiceSaturationsID)
    cstrCurrentChoiceSaturations{iChoiceSaturations} = deblank(choiceSaturations{choiceSaturationsID(iChoiceSaturations)});
end

strCurrentConversionType = deblank(conversionTypes{conversionTypeID});


%localBackgroundColor = floor(g_strctParadigm.m_aiBackgroundColor/255);
%rgbNew = localBackgroundColor
rgbNew = cat(3,repmat(g_strctParadigm.m_aiLocalBackgroundColor(1),[iChoiceRingSize,iChoiceRingSize]),...
    repmat(g_strctParadigm.m_aiLocalBackgroundColor(2),[iChoiceRingSize,iChoiceRingSize]),...
    repmat(g_strctParadigm.m_aiLocalBackgroundColor(3),[iChoiceRingSize,iChoiceRingSize]));

rgbInd = ones(iChoiceRingSize,iChoiceRingSize,3);
clutIndices = [];
g_strctParadigm.m_strctChoiceVars.m_aiChoiceRingRGBCorrected = [];
g_strctParadigm.m_strctChoiceVars.m_aiLocalChoiceRingRGBCorrected = [];
for iRings = 1:iChoiceRingNumRings
    
    iChoiceRingwidth = floor(fnTsGetVar('g_strctParadigm','ChoiceRingSize')/ (iChoiceRingNumRings+1));    
    %aiCurrentlySelectedColors = get(g_strctParadigm.m_strctControllers.m_hChoiceColorLists,'value');
	if iRings == 1 
		aiCurrentlySelectedColors = [1 3 5 7 9 11];
	elseif iRings==2
		aiCurrentlySelectedColors = [2 4 6 8 10 12];
	elseif iRings==3
		aiCurrentlySelectedColors = [13 14 15 16 17 18];
	elseif iRings==4
		aiCurrentlySelectedColors = 19;
	end;
    [iChoiceRingNumChoices] =  numel(aiCurrentlySelectedColors);
    %[iChoiceRingElevation] = fnTsGetVar('g_strctParadigm','ChoiceRingElevation');
    %[iChoiceRingSaturation] = fnTsGetVar('g_strctParadigm','ChoiceRingSaturation');
    %aiChoiceAzimuthDegrees = 0:360/iChoiceRingChoices:359.99;
    %aiChoiceElevations = ones(1,numel(aiChoiceAzimuthDegrees)) * iChoiceRingElevation(iRings);
    %aiChoiceSaturations = ones(1,numel(aiChoiceAzimuthDegrees)) * iChoiceRingSaturation(iRings);
   
   
    if strcmp(strCurrentConversionType,'LUV')
        thisSaturationColorStruct = g_strctParadigm.m_strctMasterColorTable{conversionTypeID,1}.(cstrCurrentChoiceSaturations{iRings});
        afCurrentColorAzimuth = thisSaturationColorStruct.azimuthSteps;
        fCurrentColorElevation = thisSaturationColorStruct.m_fElevation;
        [luvCoords(2,:),luvCoords(3,:),luvCoords(1,:)] = sph2cart(afCurrentColorAzimuth, zeros(1,numel(afCurrentColorAzimuth)), thisSaturationColorStruct.Radius) ;
         ChoiceRGBUncorrectedTemp = luv2rgb([ones(numel(luvCoords(2,:)),1) * fCurrentColorElevation,luvCoords(2,:)'.*100,luvCoords(3,:)'.*100]);
      
    elseif strcmp(strCurrentConversionType,'DKL')
        [m_aiChoiceRingCoordinatesX,...
            m_aiChoiceRingCoordinatesY,...
            m_aiChoiceRingCoordinatesZ] = sph2cart(deg2rad(aiChoiceAzimuthDegrees),  aiChoiceElevations, aiChoiceSaturations);

        %g_strctParadigm.m_strctChoiceVars.m_strChoiceColorConversionType

         ChoiceRGBUncorrectedTemp = ldrgyv2rgb( m_aiChoiceRingCoordinatesZ,m_aiChoiceRingCoordinatesX,m_aiChoiceRingCoordinatesY)';
    else
        error(sprintf('Unknown color conversion type %s, add an appropriate handling statement in this function', strCurrentConversionType));
    end
    
    if any(any(ChoiceRGBUncorrectedTemp > 1)) || ...
            any(any(ChoiceRGBUncorrectedTemp < 0))
        ChoiceRGBUncorrectedTemp(ChoiceRGBUncorrectedTemp < 0) = 0;
        ChoiceRGBUncorrectedTemp(ChoiceRGBUncorrectedTemp > 1) = 1;
        fnParadigmToKofikoComm('DisplayMessage', 'Choice color values out of range');
        
    end
    choiceRGBTemp = [];
    localRgbCorrectedTemp = [];
    for iColors = 1:size(ChoiceRGBUncorrectedTemp,1)
        choiceRGBTemp(iColors,:) =...
            [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(ChoiceRGBUncorrectedTemp(iColors, 1) * 65535) + 1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(ChoiceRGBUncorrectedTemp(iColors, 2) * 65535) + 1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(ChoiceRGBUncorrectedTemp(iColors, 3) * 65535) + 1)];
        localRgbCorrectedTemp(iColors,:) = round((choiceRGBTemp(iColors,:) / 65535) * 255);
       
    end
    
    if g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors || g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations
        interleavedRGBWithBackground = ones(size(localRgbCorrectedTemp,1)*2,3);
		interleavedRGBWithBackground(1:2:end,:) = localRgbCorrectedTemp;
        interleavedCorrectedRGBWithBackground = ones(size(choiceRGBTemp,1)*2,3);
        interleavedCorrectedRGBWithBackground(1:2:end,:) = choiceRGBTemp;
        
		if g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations && iChoiceRingNumRings > 1
			RingWidthMultiplier = fnTsGetVar('g_strctParadigm', 'SaturationBoundaryWidthMultiplier')/100;
		else
			RingWidthMultiplier = 1;
        end
        if g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors
            for iInterleaved = 2:2:size(interleavedRGBWithBackground,1)
                interleavedRGBWithBackground(iInterleaved,:) = deal(0);
                interleavedCorrectedRGBWithBackground(iInterleaved,:) = deal(0);

                %interleavedRGBWithBackground(iInterleaved,:) = deal(g_strctParadigm.m_aiLocalBackgroundColor);
                %interleavedCorrectedRGBWithBackground(iInterleaved,:) = deal(floor(g_strctParadigm.m_aiBackgroundColor));
            end
        end
		%choiceRGBTemp = interleavedCorrectedRGBWithBackground;
       % localRgbCorrectedTemp = interleavedRGBWithBackground;
		[rgbTemp, rgbIndTemp, clutTemp, choiceParamsTemp] = fnCreateChoiceColorCircle(iChoiceRingSize,...
			iChoiceRingwidth * RingWidthMultiplier,...
			iChoiceRingNumChoices*2,...
			interleavedRGBWithBackground,...
			lastClutOffset,...
			g_strctParadigm.m_aiLocalBackgroundColor,...
			(iChoiceRingwidth*(iRings-1)),...
            g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors,...
			g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations);
	else


	[rgbTemp, rgbIndTemp, clutTemp, choiceParamsTemp] = fnCreateChoiceColorCircle(iChoiceRingSize,...
			iChoiceRingwidth,...
			iChoiceRingNumChoices,...
			localRgbCorrectedTemp,...
			lastClutOffset,...
			 g_strctParadigm.m_aiLocalBackgroundColor,...
			(iChoiceRingwidth*(iRings-1)),...
            g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceColors,...
			g_strctParadigm.m_strctChoiceVars.m_bInsertGrayBoundaryBetweenChoiceSaturations);
	end
	% append the angles in the color ring and in the color space to the choice parameters struct
	g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngleTolerance = choiceParamsTemp.m_afChoiceAngleTolerance;
	g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(iRings,:) = afCurrentColorAzimuth; %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngles, ...);
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(iRings,:) = choiceParamsTemp.m_afChoiceAngles'; %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngles, ...);
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(iRings,:,:) = repmat(choiceParamsTemp.m_iRingRho(1), size(choiceParamsTemp.m_afChoiceAngles',1),1); %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho,);
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRGB(iRings,:,:) = choiceRGBTemp; %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRGB,...);
	g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{iRings} = cstrCurrentChoiceSaturations{iRings};
	%{
    g_strctParadigm.m_strctChoiceVars.choiceParameters.(cstrCurrentChoiceSaturations{iRings}).m_afChoiceColorSpaceAngles = afCurrentColorAzimuth; %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngles, ...);
    g_strctParadigm.m_strctChoiceVars.choiceParameters.(cstrCurrentChoiceSaturations{iRings}).m_afChoiceRingAngles = choiceParamsTemp.m_afChoiceAngles'; %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceAngles, ...);
    g_strctParadigm.m_strctChoiceVars.choiceParameters.(cstrCurrentChoiceSaturations{iRings}).m_aiChoiceRho = repmat(choiceParamsTemp.m_iRingRho, size(choiceParamsTemp.m_afChoiceAngles',1),1); %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho,);
    g_strctParadigm.m_strctChoiceVars.choiceParameters.(cstrCurrentChoiceSaturations{iRings}).m_aiChoiceRGB = choiceParamsTemp.m_aiRGB; %vertcat(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRGB,...);
      %}                                                                      
	% append clut indices for this circle to the others                                                         
    if ~isempty(clutIndices)
        clutIndices = horzcat(clutIndices,clutTemp);% + max(clutIndices));
    else
        clutIndices = clutTemp;
    end
    lastClutOffset = max(clutIndices);

    g_strctParadigm.m_strctChoiceVars.m_aiChoiceRingRGBCorrected = vertcat(g_strctParadigm.m_strctChoiceVars.m_aiChoiceRingRGBCorrected, choiceRGBTemp);
    g_strctParadigm.m_strctChoiceVars.m_aiLocalChoiceRingRGBCorrected = vertcat(g_strctParadigm.m_strctChoiceVars.m_aiLocalChoiceRingRGBCorrected, localRgbCorrectedTemp);
	rgbNewR = reshape(rgbNew(:,:,1),[size(rgbNew,1) * size(rgbNew,2),1]);
	rgbNewG = reshape(rgbNew(:,:,2),[size(rgbNew,1) * size(rgbNew,2),1]);
	rgbNewB = reshape(rgbNew(:,:,3),[size(rgbNew,1) * size(rgbNew,2),1]);  
	rgbTempR = reshape(rgbTemp(:,:,1),[size(rgbTemp,1) * size(rgbTemp,2),1]);
	rgbTempG = reshape(rgbTemp(:,:,2),[size(rgbTemp,1) * size(rgbTemp,2),1]);
	rgbTempB = reshape(rgbTemp(:,:,3),[size(rgbTemp,1) * size(rgbTemp,2),1]);
	replaceCoords = find(rgbTempR ~= g_strctParadigm.m_aiLocalBackgroundColor(1) | rgbTempG ~= g_strctParadigm.m_aiLocalBackgroundColor(2) | rgbTempB ~= g_strctParadigm.m_aiLocalBackgroundColor(3));
	rgbNewR(replaceCoords) = rgbTempR(replaceCoords);
	rgbNewG(replaceCoords) = rgbTempG(replaceCoords);
	rgbNewB(replaceCoords) = rgbTempB(replaceCoords);
	rgbNew = cat(3,reshape(rgbNewR,[size(rgbNew,1) size(rgbNew,2)]),reshape(rgbNewG,[size(rgbNew,1) size(rgbNew,2)]),reshape(rgbNewB,[size(rgbNew,1) size(rgbNew,2)]));

	rgbIndR = reshape(rgbInd(:,:,1),[size(rgbInd,1) * size(rgbInd,2),1]);
	rgbIndG = reshape(rgbInd(:,:,2),[size(rgbInd,1) * size(rgbInd,2),1]);
	rgbIndB = reshape(rgbInd(:,:,3),[size(rgbInd,1) * size(rgbInd,2),1]);  
	rgbIndTempR = reshape(rgbIndTemp(:,:,1),[size(rgbIndTemp,1) * size(rgbIndTemp,2),1]);
	rgbIndTempG = reshape(rgbIndTemp(:,:,2),[size(rgbIndTemp,1) * size(rgbIndTemp,2),1]);
	rgbIndTempB = reshape(rgbIndTemp(:,:,3),[size(rgbIndTemp,1) * size(rgbIndTemp,2),1]);
	%replaceCoords = find(rgbTempR ~= g_strctParadigm.m_aiLocalBackgroundColor(1) | rgbTempG ~= g_strctParadigm.m_aiLocalBackgroundColor(2) | rgbTempB ~= g_strctParadigm.m_aiLocalBackgroundColor(3));
	rgbIndR(replaceCoords) = rgbIndTempR(replaceCoords);
	rgbIndG(replaceCoords) = rgbIndTempG(replaceCoords);
	rgbIndB(replaceCoords) = rgbIndTempB(replaceCoords);
	rgbInd = cat(3,reshape(rgbIndR,[size(rgbInd,1) size(rgbInd,2)]),reshape(rgbIndG,[size(rgbInd,1) size(rgbInd,2)]),reshape(rgbIndB,[size(rgbInd,1) size(rgbInd,2)]));

%{
    for iX = 1:size(rgbTemp,1)
        for iY = 1:size(rgbTemp,2)
            if (rgbTemp(iX,iY,1) ~= g_strctParadigm.m_aiLocalBackgroundColor(1) || rgbTemp(iX,iY,2) ~= g_strctParadigm.m_aiLocalBackgroundColor(2) || rgbTemp(iX,iY,3) ~= g_strctParadigm.m_aiLocalBackgroundColor(3)) && ...
                   (rgbNew(iX,iY,1) == g_strctParadigm.m_aiLocalBackgroundColor(1) && rgbNew(iX,iY,2) == g_strctParadigm.m_aiLocalBackgroundColor(2) && rgbNew(iX,iY,3) == g_strctParadigm.m_aiLocalBackgroundColor(3))
               warning('trigger')
                rgbNew(iX,iY,1) = rgbTemp(iX,iY,1);
                rgbNew(iX,iY,2) = rgbTemp(iX,iY,2);
                rgbNew(iX,iY,3) = rgbTemp(iX,iY,3);
                rgbInd(iX,iY,1) = rgbIndTemp(iX,iY,1);
                rgbInd(iX,iY,2) = rgbIndTemp(iX,iY,2);
                rgbInd(iX,iY,3) = rgbIndTemp(iX,iY,3);
                
            end
        end
    end
    %}
end
% null condition is now its own saturation
%{
% add null area (center of the choice ring where there are no choices) as
% its own choice area, for no stimulus trials

    % any angle will work for null, only rho important here
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceColorSpaceAngles(end+1,:) = deal(0); 
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_afChoiceRingAngles(end+1,:) = deal(0);
    
    % find last set rho, get the lower boundary, and set 0 to that boundary as
    % the null choice upper rho
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(end+1,:,:) = repmat([0, min(min(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(iRings,:,:)))],size(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRho(end,:,:),2),1);
    
    % Background color is null trial color
    g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRGB(end+1,:,:) = repmat(g_strctParadigm.m_aiBackgroundColor,size(g_strctParadigm.m_strctChoiceVars.choiceParameters.m_aiChoiceRGB(end,:,:),2), 1); 
    
    % Name this saturation
	g_strctParadigm.m_strctChoiceVars.choiceParameters.m_strSatname{end+1} = g_strctParadigm.m_strNullCategoryName;
    
%g_strctParadigm.m_strctChoiceVars.choiceParameters.NullArea.m_afChoiceRingAngles = 0;
%g_strctParadigm.m_strctChoiceVars.choiceParameters.NullArea.m_afChoiceColorSpaceAngles = 0;


%g_strctParadigm.m_strctChoiceVars.choiceParameters.NullArea.m_aiChoiceRho = [0, min(min(g_strctParadigm.m_strctChoiceVars.choiceParameters.(cstrCurrentChoiceSaturations{iRings}).m_aiChoiceRho))];
    
% null trials use the paradigm background color. Set that as the null
% choice RGB value
%g_strctParadigm.m_strctChoiceVars.choiceParameters.NullArea.m_aiChoiceRGB = g_strctParadigm.m_aiBackgroundColor;
%
%}
return;

function [rgbNew, rgbInd, clutIndices, varargout] = fnCreateChoiceColorCircle(ringDimension, ringWidth,ncols,targetRGB,CLUTOffset,backgroundColor,outerOffset,bGrayBoundaryBetweenColors,bGrayBoundaryBetweenSaturations)

%dbstop if warning
%warning('stop')
% Set parameters (these could be arguments to a function)
figureMaxDimension = max([ringDimension]);
rInner = round((figureMaxDimension/2)-ringWidth/2-(outerOffset/2));     % inner radius of the colour ring
rOuter = round((figureMaxDimension/2)-(outerOffset/2));    % outer radius of the colour ring
% Get polar coordinates of each point in the domain
%[x, y] = meshgrid(-rOuter:rOuter);
% if the ring dimension is an even number, subtract one from the upper end
% or the ring will be 1 pixel larger than intended in both dimensions
if ~mod(ringDimension,2)
    [x, y] = meshgrid(-ringDimension/2:(ringDimension-1)/2);
else
    [x, y] = meshgrid(-ringDimension/2:(ringDimension-1)/2);

end
[theta, rho] = cart2pol(x, y);
theta = theta - ((2*pi) / ncols)/2;

lastUsedClut = CLUTOffset;
clutIndices = [];
% Set up colour wheel in hsv space

hue = (theta + pi) / (2 * pi);     % hue into range (0, 1]
hue = round(hue * ncols) / ncols;   % quantise hue 

hues = unique(hue);



saturation = ones(size(hue));      % full saturation
brightness = double(rho >= rInner & rho <= rOuter);  % black outside ring
% Convert to rgb space for display
rgb = hsv2rgb(cat(3, hue, saturation, brightness));
radCoords = 0:(2*pi)/ncols:(2*pi)-(2*pi)/ncols;
rgbInd = ones(ringDimension,ringDimension,3);
%reshape(rgb,[size(rgb,1) * size(rgb,2),3])
%{
rgb = cat(3,repmat(backgroundColor(1),[ringDimension,ringDimension]),...
                repmat(backgroundColor(2),[ringDimension,ringDimension]),...
                repmat(backgroundColor(3),[ringDimension,ringDimension]));
%}
[x,y] = pol2cart(radCoords,rOuter - myRange([rInner,rOuter])/2);
rgbNew = rgb;
x = x + size(theta,1)/2;
y = y + size(theta,1)/2;
x = fliplr(x);
y = fliplr(y);
x = circshift(x,[0,1]);
y = circshift(y,[0,1]);

%rotate by half of one color area
% otherwise it will pick colors right along the boundary between colors,
% and will sometimes skip a color
[x, y] = fnRotateAroundPoint(x ,y , ringDimension/2, ringDimension/2, -(360/ncols)/2);

for i = 1:numel(x)
    %find rgb vals
    xTar = x(i);
    yTar = y(i);
    
    tarRGB = rgb(round(xTar),round(yTar),:);
    [x1,y1] = find(rgb(:,:,1) == tarRGB(1) & rgb(:,:,2) == tarRGB(2) & rgb(:,:,3) == tarRGB(3));

   if size(targetRGB,1) ~= numel(x)
      targetRGB = targetRGB'; 
   end
   if bGrayBoundaryBetweenColors && (targetRGB(i,1) ~= 0 && targetRGB(i,2) ~= 0 && targetRGB(i,3) ~= 0)
       
		lastUsedClut = lastUsedClut + 1;
   
       clutIndices(end+1) = lastUsedClut;
       thisColorInd = clutIndices(end);
   elseif ~bGrayBoundaryBetweenColors
       clutIndices(i) = lastUsedClut + i;
       thisColorInd = clutIndices(i);
   else
       thisColorInd = 2;
	   clutIndices(end+1) = lastUsedClut+1;
   end
    for ix = 1:numel(x1)
        rgbInd(y1(ix),x1(ix),1:3) = deal([clutIndices(end)])-1;
        rgbNew(y1(ix),x1(ix),1) = targetRGB(i,1);
        rgbNew(y1(ix),x1(ix),2) = targetRGB(i,2);
        rgbNew(y1(ix),x1(ix),3) = targetRGB(i,3);
    end
end
rgbNewR = reshape(rgbNew(:,:,1),[size(rgbNew,1) * size(rgbNew,2),1]);
rgbNewG = reshape(rgbNew(:,:,2),[size(rgbNew,1) * size(rgbNew,2),1]);
rgbNewB = reshape(rgbNew(:,:,3),[size(rgbNew,1) * size(rgbNew,2),1]);

[targetBackgroundCoord(:,1)] = find(rgbNewR == 0 & rgbNewG == 0 & rgbNewB == 0);
        
rgbNewR(targetBackgroundCoord) = backgroundColor(1);
rgbNewG(targetBackgroundCoord) = backgroundColor(2);
rgbNewB(targetBackgroundCoord) = backgroundColor(3);

rgbNew = cat(3,reshape(rgbNewR,[size(rgbNew,1) size(rgbNew,2)]),reshape(rgbNewG,[size(rgbNew,1) size(rgbNew,2)]),reshape(rgbNewB,[size(rgbNew,1) size(rgbNew,2)]));
%[x1,y1] = find(rgb(:,:,1) == 0 & rgb(:,:,2) == 0 & rgb(:,:,3) == 0)  
%[x2,y2] = find(rgbNew(:,:,1) == 0 & rgbNew(:,:,2) == 0 & rgbNew(:,:,3) == 0) ;
%{
x1 = vertcat(x1,x2);
y1 = vertcat(y1,y2);
    for ix = 1:numel(targetBackgroundCoord)
        
        rgbNew(y1(ix),x1(ix),1) = backgroundColor(1);
        rgbNew(y1(ix),x1(ix),2) = backgroundColor(2);
        rgbNew(y1(ix),x1(ix),3) = backgroundColor(3);
    end
%}

if nargout == 4
	% the plus or minus bound of each color wedge
	   choiceParameters.m_afChoiceAngleTolerance = (deg2rad(360)/ncols)/2;
	   choiceParameters.m_iRingDimension = ringDimension;
	   choiceParameters.m_iRingWidth = ringWidth;
	   choiceParameters.m_iRingRho = [rInner, rOuter];%ringDimension - outerOffset;
    if bGrayBoundaryBetweenSaturations
	   choiceParameters.m_aiRGB = targetRGB(1:2:end,:);
	   choiceParameters.m_afChoiceAngles = radCoords(1:2:end) + choiceParameters.m_afChoiceAngleTolerance;
    else
	   choiceParameters.m_afChoiceAngles = radCoords + choiceParameters.m_afChoiceAngleTolerance;
	   choiceParameters.m_aiRGB = targetRGB;
    end
	varargout{1} = choiceParameters;

end
return;