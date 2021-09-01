function [stimulusServerColors, controlComputerColors] = fnCalculateColorsForChoiceAFCDisplay(activeSaturationsIds, activeSaturationsStr, activeColorConversionId, luminanceDeviation, numLuminanceStepsPerChoice)
global g_strctParadigm
%luminanceDeviation = fnTsGetVar('g_strctParadigm','ChoiceLuminanceDeviation');
% (activeSaturationsIds, activeSaturationsStr, activeColorConversionId, luminanceDeviation, numLuminanceStepsPerChoice, cColorsPerSaturation)
%numLuminanceStepsPerChoice = floor(253 / ((numel(activeChoiceColorIds)+1)*numel(activeSaturationsIds)));
%if rem(numLuminanceStepsPerChoice,2) == 0
%    numLuminanceStepsPerChoice = numLuminanceStepsPerChoice - 1;
%end

g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps = ...
    linspace(-luminanceDeviation,luminanceDeviation,numLuminanceStepsPerChoice);
%LUTsize = size(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs);
%ChoiceLUTs = ...
 %   sort(reshape(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs,[LUTsize(1) * LUTsize(2),1]));
%sort(g_strctParadigm.m_strctChoiceVars.ChoiceLUTs);
stimulusServerColors = [];
controlComputerColors = [];

for iSaturations = 1:numel(activeSaturationsIds)
	% color order for 19-stimulus triangular tessalation 
	if iSaturations == 1 
		iStimuli = [1 3 5 7 9 11];
	elseif iSaturations==2
		iStimuli = [2 4 6 8 10 12];
	elseif iSaturations==3
		iStimuli = [13 14 15 16 17 18];
	elseif iSaturations==4
		iStimuli = 19;
	end;
    for iColors = 1:length(iStimuli);
        thisColorCoordinate = g_strctParadigm.m_strctMasterColorTable{activeColorConversionId}.(activeSaturationsStr{iSaturations}).m_afCartCoordinates(iColors,:);
        rawValues = luv2rgb([ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .* ...
            ((thisColorCoordinate(1)*100) + g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps*100)', ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(2)'.*100, ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(3)'.*100]);
        if any(any(rawValues > 1)) ||  any(any(rawValues < 0))
            rawValues( rawValues > 1) = 1;
            rawValues( rawValues < 0) = 0;
            fnParadigmToKofikoComm('DisplayMessageNow','Choice Color Values Out Of Range');
            
        end
		stimServerColorsTemp = fnGammaCorrectRGBValues(rawValues);
        stimulusServerColors = vertcat(stimulusServerColors, fnGammaCorrectRGBValues(rawValues));
        controlComputerColors = vertcat(controlComputerColors, round((stimServerColorsTemp/((2^16)-1)) * ((2^8)-1)));
        
    end
end
%{
	if fnTsGetVar('g_strctParadigm','IncludeGrayTrials')
	% append the gray choice information
		thisColorCoordinate = fnTsGetVar('g_strctParadigm', 'BackgroundLUVCoordinates');
        rawValues = luv2rgb([ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .* ...
            ((thisColorCoordinate(1)) + g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps*100)', ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(2)'.*100, ...
            ones(numel(g_strctParadigm.m_strctChoiceVars.m_fChoiceLuminanceSteps),1) .*thisColorCoordinate(3)'.*100]);
        if any(any(rawValues > 1)) ||  any(any(rawValues < 0))
            rawValues( rawValues > 1) = 1;
            rawValues( rawValues < 0) = 0;
            fnParadigmToKofikoComm('DisplayMessageNow','Choice Color Values Out Of Range');
            
        end
	
			stimServerColorsTemp = fnGammaCorrectRGBValues(rawValues);

		%ChoiceLUTs = vertcat(ChoiceLUTs,g_strctParadigm.m_strctChoiceVars.GrayChoiceLUTs');
		stimulusServerColors = vertcat(stimulusServerColors,stimServerColorsTemp);
		controlComputerColors = vertcat(controlComputerColors, round((stimServerColorsTemp/((2^16)-1)) * ((2^8)-1)));
		
	end
%}
return;