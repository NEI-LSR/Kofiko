function [correctedRGB] = fnGammaCorrectRGBValues(RGB, bSingleColorVector)
    global g_strctParadigm
    
    if nargin == 1
       bSingleColorVector = false; 
    end
    if size(RGB,2) ~= 3 && size(RGB,1) == 3
        RGB = RGB';
    end
    if bSingleColorVector
        R = RGB;
        G = RGB;
        B = RGB;
    else
        R = RGB(:,1);
        G = RGB(:,2);
        B = RGB(:,3);
    end
correctedRGB = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(R * 65535) + 1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(G * 65535) + 1),...
            g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(B * 65535) + 1)];


end
