function fnVariableUpdateCheck()
global g_strctPTB g_strctParadigm g_strctGUIParams

%
% Copyright (c) 2015 Joshua Fuller-Deets, Massachusetts Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

% This function handles updating of paradigm variables via mouse dragging on the PTB window.
% position updates are handled separately because it contains x and y information
% all other updates are handled by the modular function, and the range of the variable is normalized 
% to the width of the PTB screen. 
% IE, 1-100 and 1-10000 will take the same amount of dragging to set, rather than the latter taking 100x

if ~g_strctGUIParams.m_bDisplayPTB
	return;
end
try
[g_strctPTB.m_strctControlInputs.m_mousePosition(1), g_strctPTB.m_strctControlInputs.m_mousePosition(2)] = GetMouse(g_strctPTB.m_hWindow);
end

if g_strctPTB.m_variableUpdating && g_strctPTB.m_strctControlInputs.m_mouseButtons(1)

	fnUpdateParadigmWithPTBSlider();


% The mouse is inside the PTB screen, we should check to see if it's being used to update things
% If the mouse is inside the stimulus presentation area and the mouse button is down...
% Update the stimulus area to be the new mouse position
%g_strctPTB.m_strctControlInputs.m_bLastStimulusPositionCheck = fCurrTime;
elseif	 ~g_strctPTB.m_variableUpdating  && g_strctPTB.m_strctControlInputs.m_mousePosition(1) >= g_strctPTB.m_aiScreenRect(1) && ...
		g_strctPTB.m_strctControlInputs.m_mousePosition(2) >= g_strctPTB.m_aiScreenRect(2) && ...
		g_strctPTB.m_strctControlInputs.m_mousePosition(1) <= g_strctPTB.m_aiScreenRect(3) && ...
		g_strctPTB.m_strctControlInputs.m_mousePosition(2) <= g_strctPTB.m_aiScreenRect(4) && ...
		g_strctPTB.m_strctControlInputs.m_mouseButtons(1) 
		switch g_strctParadigm.m_strCurrentlySelectedVariable
			case {'StimulusPosition', 'SecondaryStimulusPosition','AFCChoiceLocation'}

			%if strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, 'StimulusPosition')% &&	...
			
				% Start the stimulus position update process
				g_strctPTB.m_variableUpdating = true;
				% Starting point of mouse
				g_strctPTB.m_startingMousePosition = g_strctPTB.m_strctControlInputs.m_mousePosition;
				g_strctPTB.m_startingVariableValue = fnTsGetVar('g_strctParadigm', g_strctParadigm.m_strCurrentlySelectedVariable);
				g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(1) = ...
					g_strctPTB.m_startingVariableValue(1) - g_strctPTB.m_strctControlInputs.m_mousePosition(1);
				g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(2) = ...
					g_strctPTB.m_startingVariableValue(2) - g_strctPTB.m_strctControlInputs.m_mousePosition(2);
            
            %elseif strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, ['SecondaryStimulusPosition']); %Felix NTlab_add
                %{
                % Start the stimulus position update process
				g_strctPTB.m_variableUpdating = true;
				% Starting point of mouse
				g_strctPTB.m_startingMousePosition = g_strctPTB.m_strctControlInputs.m_mousePosition;
				g_strctPTB.m_startingVariableValue = fnTsGetVar('g_strctParadigm', g_strctParadigm.m_strCurrentlySelectedVariable);
				g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(1) = ...
					g_strctPTB.m_startingVariableValue(1) - g_strctPTB.m_strctControlInputs.m_mousePosition(1);
				g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(2) = ...
					g_strctPTB.m_startingVariableValue(2) - g_strctPTB.m_strctControlInputs.m_mousePosition(2);
					%}
			case 'ColorPicker'

           % elseif strcmp(g_strctParadigm.m_strCurrentlySelectedVariable,'ColorPicker')
                fnUpdateParadigmWithPTBSlider()
                g_strctPTB.m_variableUpdating = true;
            otherwise
            %else
				g_strctPTB.m_variableUpdating = true;
				% Starting point of mouse
				g_strctPTB.m_startingMousePosition = g_strctPTB.m_strctControlInputs.m_mousePosition;
				g_strctPTB.m_startingVariableValue = fnTsGetVar('g_strctParadigm', g_strctParadigm.m_strCurrentlySelectedVariable);
			end
	
elseif g_strctPTB.m_variableUpdating && ~g_strctPTB.m_strctControlInputs.m_mouseButtons(1)
	% end the stimulus variable update
	g_strctPTB.m_variableUpdating = false;
	
	
end
return;



function fnUpdateParadigmWithPTBSlider()
global g_strctPTB g_strctParadigm



switch g_strctParadigm.m_strCurrentlySelectedVariable
    case {'StimulusPosition', 'SecondaryStimulusPosition','AFCChoiceLocation'}
        
        g_strctParadigm.m_aiCenterOfStimulus(1) = g_strctPTB.m_startingVariableValue(1) + ...
            ((g_strctPTB.m_strctControlInputs.m_mousePosition(1)-g_strctPTB.m_startingVariableValue(1)) +...
            g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(1)) ;
			
        g_strctParadigm.m_aiCenterOfStimulus(2) = g_strctPTB.m_startingVariableValue(2) + ...
            ((g_strctPTB.m_strctControlInputs.m_mousePosition(2)-g_strctPTB.m_startingVariableValue(2)) +...
            g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(2)) ;
			
        fnTsSetVarParadigm(g_strctParadigm.m_strCurrentlySelectedVariable, [g_strctPTB.m_startingVariableValue(1) + ...
            ((g_strctPTB.m_strctControlInputs.m_mousePosition(1)-g_strctPTB.m_startingVariableValue(1)) +...
            g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(1)), ...
            g_strctPTB.m_startingVariableValue(2) + ((g_strctPTB.m_strctControlInputs.m_mousePosition(2)- ...
            g_strctPTB.m_startingVariableValue(2)) + g_strctPTB.m_strctControlInputs.m_stimulusMovementMouseOffset(2))]);
        
	case 'ColorPicker'
		if g_strctParadigm.m_bUseCartesianCoordinates && ~g_strctParadigm.m_bCycleColors && ~g_strctParadigm.m_bRandomColor
			fnCheckColorPicker();
   
		end
		
    otherwise
        ControllerSlider = ['g_strctParadigm.m_strctControllers.m_h', g_strctParadigm.m_strCurrentlySelectedVariable,'Slider'];
        ControllerEdit = ['g_strctParadigm.m_strctControllers.m_h', g_strctParadigm.m_strCurrentlySelectedVariable,'Edit'];
        % Set smart bounds on movement of variable
        fMax = get(eval(ControllerSlider),'max');
        fMin = get(eval(ControllerSlider),'min');
        mScale =  range([fMax,fMin])/ 1024 ; % Hardcoded 
        
        newValue = round(g_strctPTB.m_startingVariableValue - mScale* ...
            (g_strctPTB.m_startingMousePosition(1) - g_strctPTB.m_strctControlInputs.m_mousePosition(1)));
			
			
		% handle special cases, wraparound: orientation/gabor phase should revert to zero after passing 359, and vice versa
		if any(findstr(g_strctParadigm.m_strCurrentlySelectedVariable, 'Orientation')) || strcmp(g_strctParadigm.m_strCurrentlySelectedVariable, 'GaborPhase')
			if newValue < fMin || newValue > fMax
				newValue = newValue - floor(newValue/fMax)*fMax;
			end
		else
			if newValue < fMin
				newValue = fMin;
			elseif newValue > fMax
				newValue = fMax;
			end
        end
        fnTsSetVarParadigm(g_strctParadigm.m_strCurrentlySelectedVariable, newValue);
        % Update the GUI
        
        set(eval(ControllerSlider),'value',newValue,'max', max(fMax,newValue), 'min',min(fMin,newValue));
        set(eval(ControllerEdit),'String', num2str(newValue));
end

return;


function fnCheckColorPicker()	
global g_strctPTB g_strctParadigm		
% Sets the color picker if DKL color mode is enabled, and the color picker is enabled
mousePos = [g_strctPTB.m_strctControlInputs.m_mousePosition(1) - g_strctPTB.m_aiScreenRect(1),...
			g_strctPTB.m_strctControlInputs.m_mousePosition(2) - g_strctPTB.m_aiScreenRect(2)];
%fDistX = (g_strctPTB.m_strctControlInputs.m_mousePosition(1) + g_strctPTB.m_aiScreenRect(1)) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter(1);
%fDistY = (g_strctPTB.m_strctControlInputs.m_mousePosition(2) + g_strctPTB.m_aiScreenRect(2)) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter(2);
%fDistX = (g_strctPTB.m_strctControlInputs.m_mousePosition(1) - g_strctPTB.m_aiScreenRect(1)) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter(1);
%fDistY = (g_strctPTB.m_strctControlInputs.m_mousePosition(2) - g_strctPTB.m_aiScreenRect(2)) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter(2);
fDistToColorPickerCenter = sqrt(((mousePos(1)-g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter(1))^2)+...
                                ((mousePos(2) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerCenter(2))^2));

bInsideCircle = fDistToColorPickerCenter < g_strctParadigm.m_strctColorPicker.m_iColorPickerRadius;

if ~bInsideCircle || g_strctParadigm.m_strctColorPicker.m_bColorPickerUpdating && ~g_strctPTB.m_strctControlInputs.m_mouseButtons(1) 
	
	g_strctParadigm.m_strctColorPicker.m_bColorPickerUpdating = false; 
    return;
elseif bInsideCircle &&	g_strctPTB.m_strctControlInputs.m_mouseButtons(1) 


		xRange = range([g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(1),g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(3)]);
		yRange = range([g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(2),g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(4)]);
        
		newXVal = ((mousePos(1) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(1))/xRange );
		newYVal = ((mousePos(2) - g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(2))/yRange );
		
		g_strctParadigm.m_strctColorPicker.m_afColorPickerScreenCoordinates = [(newXVal * xRange) + g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(1),...
																				(newYVal * yRange) + g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect(2)];
			
		fnTsSetVar('g_strctParadigm','CartesianXCoord',ceil(newXVal * .95 * 1000)); % anything beyond 95 is outside the monitor range
		fnTsSetVar('g_strctParadigm','CartesianYCoord',ceil(newYVal * .95 * 1000)); % anything beyond 95 is outside the monitor range
     
        
     g_strctParadigm.m_strctColorPicker.m_bColorPickerUpdating = true;
		
		
		
	


end				

return;