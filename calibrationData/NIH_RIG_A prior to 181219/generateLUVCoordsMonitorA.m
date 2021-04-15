function [thisLUVParam,targetRGB] = generateLUVCoordsMonitorA()

plotON = 0;
aiLuminanceLevels = [0,0,-10,0,10];
aiChromaLevels = [.50,.15,.20,.20,.20];
azimuthRad{1} = deg2rad(0:22.5:359.9999);
for i=2:5
azimuthRad{i} = deg2rad(0:45:359.9999);
end
grayPointLUV = [50,0,0];
%spectraName = 'spectra.xls';
%LUT_R = textread('NIH_March_15_2018_rigA_Rlum_LUT');
%LUT_G = textread('NIH_March_15_2018_rigA_Glum_LUT');
%LUT_B = textread('NIH_March_15_2018_rigA_Blum_LUT');
%LUT = cat(2,LUT_R(:,2),LUT_G(:,2),LUT_B(:,2));

% values from Romain's MatrixTransfo.m file. Update for separate rigs using
% appropriate photoradiometer measurements
SRGBToXYZr = [0.412390799265959,0.357584339383878,0.180480788401834; ...
    0.212639005871510,0.715168678767756,0.0721923153607337;...
    0.0193308187155918,0.119194779794626,0.950532152249661];

SRGBToXYZBarco = [0.376799692493593,0.323445610012955,0.282494093773623;
    0.202504394456375,0.677583647548661,0.119911957994964;
    0.0217834472884110,0.124299590739843,1.49109249812455];

XYZ2Srgb = inv(SRGBToXYZBarco);



%S=xlsread(spectraName);
%[xyY, XYZ]  = spectra2xyY(S, 'judd');

RGBIdeals = [1 0 0; 0 1 0; 0 0 1];
for i = 1:size(RGBIdeals,1)
    XYZIdeals(i,:) = SRGBToXYZBarco*[RGBIdeals(i,:)'];
    LUV_Vertices(i,:) = XYZToLuv(XYZIdeals(i,:)',SRGBToXYZBarco*([1; 1; 1]));
end

grayPoint = SRGBToXYZBarco*[.5;.5;.5];
whitePointX = grayPoint(1);
whitePointY = grayPoint(2);
whitePointZ = grayPoint(3);
[grayPointLUV] = XYZToLuv(grayPoint,  SRGBToXYZBarco*([1; 1; 1]));


% Find the center of the color triangle and find the point equidistant to
% all sides
iCoords = 1;
for iChroma = 1:numel(aiChromaLevels)
   % for iLuminance = 1:numel(aiLuminanceLevels)
       % for iAzimuths = 1:numel(azimuthRad)
        
        LUVRadiusMultiplier = aiChromaLevels(iChroma);
        [aiUCoordinate, aiVCoordinate] = deal([]);
         [aiUCoordinate, aiVCoordinate, aiLCoordinate] = ...
                        sph2cart(azimuthRad{iChroma},0,100*LUVRadiusMultiplier);   

        for iCoordsIter = 1:numel(aiUCoordinate)
            thisLUVCoord(iCoords,:) = [grayPointLUV(1) + aiLuminanceLevels(iChroma),aiUCoordinate(iCoordsIter)+grayPointLUV(2), aiVCoordinate(iCoordsIter)+grayPointLUV(3)];
            thisLUVParam(iCoords,:) = [rad2deg(azimuthRad{iChroma}(iCoordsIter)), aiLuminanceLevels(iChroma), aiChromaLevels(iChroma)];
            targetLUV = [grayPointLUV(1) + aiLuminanceLevels(iChroma),aiUCoordinate(iCoordsIter)+grayPointLUV(2), aiVCoordinate(iCoordsIter)+grayPointLUV(3)];
            [targetXYZCoords(iCoordsIter,:)] = LuvToXYZ(targetLUV',SRGBToXYZBarco*([1; 1; 1]));
            [targetRGB(iCoords,:)] = XYZ2Srgb*targetXYZCoords(iCoordsIter,:)';
           % targetGammaCorrected(iCoords,1) = round(LUT(floor(targetRGB(iCoords,1)*65535)+1,1)/255);
           % targetGammaCorrected(iCoords,2) = round(LUT(floor(targetRGB(iCoords,2)*65535)+1,2)/255);
           % targetGammaCorrected(iCoords,3) = round(LUT(floor(targetRGB(iCoords,3)*65535)+1,3)/255);
            iCoords = iCoords + 1;
        end
        
        %whitePointRGBCorrected = [round(LUT(floor(trueCenterRGB(1)*65535)+1,1)/255),round(LUT(floor(trueCenterRGB(2)*65535)+1,2)/255),round(LUT(floor(trueCenterRGB(3)*65535)+1,3)/255)];
        %end
    %end
end
%whitePointRGBCorrected = [round(LUT(floor(.5*65535)+1,1)/255),round(LUT(floor(.5*65535)+1,2)/255),round(LUT(floor(.5*65535)+1,3)/255)];

if plotON
    figure();
    hold on
    set(gca,'color',whitePointRGBCorrected/255);
    for iIdeals = 1:3
        scatter3(LUV_Vertices(iIdeals,2),LUV_Vertices(iIdeals,3),LUV_Vertices(iIdeals,1),200,'filled','markerfacecolor',(RGBIdeals(iIdeals,:)))
    end
    %scatter(LUVCenter2d(1),LUVCenter2d(2));
    for iColors = 1:size(targetGammaCorrected,1)
       scatter3(thisLUVCoord(iColors,2),thisLUVCoord(iColors,3), thisLUVCoord(iColors,1),200,'filled','markerfacecolor',((targetGammaCorrected(iColors,:)-1)/255)); 
        %scatter(aiUCoordinate(iColors)+LUVCenter2d(1),aiVCoordinate(iColors)+LUVCenter2d(2),200,'filled','markerfacecolor',(targetGammaCorrected(iColors,:)/255));
        %    scatter(aiUCoordinate(iColors),aiVCoordinate(iColors),50,'filled','markerfacecolor',(targetGammaCorrected(iColors,:)/255));

    end

figure()
for i = 1:size(targetGammaCorrected,1)
circleColorBar(i,1,:) = targetGammaCorrected(i,:)/255;
end
imagesc(circleColorBar)
end
%{
if plotON
    figure();
    set(gca,'color',whitePointRGBCorrected/255);
    hold on
    scatter(XYZ(:,1),XYZ(:,2));
    scatter(whitePointX, whitePointY);
    scatter(targetXYZCoords(:,1),targetXYZCoords(:,2));
end
%}
return