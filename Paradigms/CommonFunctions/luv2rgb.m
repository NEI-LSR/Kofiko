function [targetRGB] = luv2rgb(targetLUV)
global g_strctParadigm
if size(targetLUV,2) ~= 3
   targetLUV = targetLUV'; 
end

for iLUV = 1:size(targetLUV,1)
   targetXYZCoords(iLUV,:) = LuvToXYZ(targetLUV(iLUV,:)',g_strctParadigm.m_strctConversionMatrices.RGBToXYZ*([1; 1; 1]))';
   targetRGB(iLUV,:) = g_strctParadigm.m_strctConversionMatrices.XYZToRGB*targetXYZCoords(iLUV,:)';
end

return;