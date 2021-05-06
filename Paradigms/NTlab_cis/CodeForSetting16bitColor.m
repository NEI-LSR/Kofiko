% all from preparetrial (fnCycleColor)
% convert target coordinates to DKl space for transformation into 16-bit colors 
if numel(strctTrial.m_iZCoordinate) == numel(strctTrial.m_iXCoordinate)
    FullCycleRGB = ldrgyv2rgb(strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate,strctTrial.m_iYCoordinate)';
else
    FullCycleRGB = ldrgyv2rgb(ones(1,numel(strctTrial.m_iXCoordinate)) * strctTrial.m_iZCoordinate,strctTrial.m_iXCoordinate,strctTrial.m_iYCoordinate)';
end
   
if size(FullCycleRGB,2) < 3
    FullCycleRGB = FullCycleRGB';
end
if any(any(FullCycleRGB > 1)) || any(any(FullCycleRGB < 0));
    FullCycleRGB(FullCycleRGB >= 1) = 1;
    FullCycleRGB(FullCycleRGB <= 0) = 0;
    fnParadigmToKofikoComm('DisplayMessage', 'Colors outside of range, mapped to nearest real color!!')
end
        
        if strctTrial.m_bUseGaussianPulses
            for iFrames = 1:strctTrial.numFrames
                strctTrial.m_aiStimColor(iFrames,:) = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(FullCycleRGB(iFrames, 1) * 65535) + 1),...
                    g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(FullCycleRGB(iFrames, 2) * 65535) + 1),...
                    g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(FullCycleRGB(iFrames, 3) * 65535) + 1)];
                strctTrial.m_aiLocalStimColor(iFrames,:) = round((strctTrial.m_aiStimColor(iFrames,:)/65535) * 255);
                
                
            end
            % strctTrial.m_iXCoordinate = strctTrial.m_iXCoordinate(round(strctTrial.numFrames/2));
            %strctTrial.m_iYCoordinate = strctTrial.m_iYCoordinate(round(strctTrial.numFrames/2));
            %strctTrial.m_iZCoordinate = strctTrial.m_iZCoordinate(round(strctTrial.numFrames/2));
        else
            
            strctTrial.m_aiStimColor = [g_strctParadigm.m_strctGammaCorrectedLookupTable.RLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 1) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.GLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 2) * 65535) + 1),...
                g_strctParadigm.m_strctGammaCorrectedLookupTable.BLUT(floor(FullCycleRGB(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID, 3) * 65535) + 1)];
            strctTrial.m_aiLocalStimColor = round((strctTrial.m_aiStimColor/65535) * 255);
            %strctTrial.m_iXCoordinate = strctTrial.m_iXCoordinate(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID);
            %strctTrial.m_iYCoordinate = strctTrial.m_iYCoordinate(g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID);
            %strctTrial.m_iZCoordinate = strctTrial.m_iZCoordinate;
        end

        %% Set local sim color bat to 8-bit
strctTrial.m_aiLocalStimColor = [squeeze(g_strctParadigm.(currentBlockStimulusColorsR).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsR).BufferIdx))...
            squeeze(g_strctParadigm.(currentBlockStimulusColorsG).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsG).BufferIdx))...
            squeeze(g_strctParadigm.(currentBlockStimulusColorsB).Buffer(1,:,g_strctParadigm.(currentBlockStimulusColorsB).BufferIdx))];
        
        strctTrial.m_aiStimColor = round((strctTrial.m_aiLocalStimColor /255)*65535);
%%
    for iFrames = 1:strctTrial.numFrames
        
        strctTrial.m_aiLocalBlurStepHolder(1,:,iFrames) = deal(round(linspace(strctTrial.m_afLocalBackgroundColor(1),strctTrial.m_aiLocalStimColor(1),strctTrial.numberBlurSteps)));
        strctTrial.m_aiLocalBlurStepHolder(2,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(2),strctTrial.m_aiLocalStimColor(2),strctTrial.numberBlurSteps));
        strctTrial.m_aiLocalBlurStepHolder(3,:,iFrames) = round(linspace(strctTrial.m_afLocalBackgroundColor(3),strctTrial.m_aiLocalStimColor(3),strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(1,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(2,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
        strctTrial.m_aiBlurStepHolder(3,:,iFrames) = round(linspace(g_strctParadigm.m_iCLUTOffset,g_strctParadigm.m_iCLUTOffset+strctTrial.numberBlurSteps-1,strctTrial.numberBlurSteps));
   end
 
    %%
    