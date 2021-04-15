function [calibratedValues] = autoCalibration(targetValues, varargin)


global wptr Clut COMPORT
wptr = Screen('OpenWindow',2);
COMPORT = 'COM4';
resumingFromPreviousSession = false;
if nargin == 2
   calibratedValues = varargin{1}; 
   resumingFromPreviousSession = true;
end

grayVal = input('enter calibrated background gray value');


Clut  = zeros(256,3); 
for i = 1:256
   Clut(i,:) = grayVal; 
   %Clut(i,:) = [ 48735 48725 49170]; 
   
end

dbstop if error;

saturationsToCalibrate = fields(targetValues);
iterationOfCalibrator = 1;


for iSaturations = 1:numel(saturationsToCalibrate)
    
    
    for iColors = 1:size(targetValues.(saturationsToCalibrate{iSaturations}),1)
        if resumingFromPreviousSession
            try
                disp(['found values for saturation - ',num2str(iSaturations),'- Color', num2str(iColors), '=',...
                    num2str(calibratedValues.(saturationsToCalibrate{iSaturations}).RGB(iColors,1:3))])
                continue
                
                
            catch
                % this field doesn't exist, calibrate it.
                [R, G, B, x, y, Y, spectrum] = adjustRGBJ1new([targetValues.(saturationsToCalibrate{iSaturations}).RGB(iColors,:),...
                     targetValues.(saturationsToCalibrate{iSaturations}).xyY(iColors,:)]   ,...
                    saturationsToCalibrate{iSaturations}, ['Color',num2str(iColors)], iterationOfCalibrator,'defaultLuminance');
                
                
                save([saturationsToCalibrate{iSaturations},'-Color',num2str(iColors)],'R', 'G', 'B', 'x', 'y', 'Y', 'spectrum');
                calibratedValues.(saturationsToCalibrate{iSaturations}).RGB(iColors,:) = [R, G, B];
                calibratedValues.(saturationsToCalibrate{iSaturations}).xyY(iColors,:) = [x, y, Y];
                save('calibratedValues','calibratedValues')
                iterationOfCalibrator = iterationOfCalibrator + 1;
            end
            
        else
            [R, G, B, x, y, Y, spectrum] = adjustRGBJ1new(targetValues.(saturationsToCalibrate{iSaturations})(iColors,:),...
                saturationsToCalibrate{iSaturations}, ['Color',num2str(iColors)], iterationOfCalibrator,'defaultLuminance');
            
            
            save([saturationsToCalibrate{iSaturations},'-Color',num2str(iColors)],'R', 'G', 'B', 'x', 'y', 'Y', 'spectrum');
            
            calibratedValues.(saturationsToCalibrate{iSaturations}).RGB(iColors,:) = [R, G, B];
            calibratedValues.(saturationsToCalibrate{iSaturations}).xyY(iColors,:) = [x, y, Y];
            save('calibratedValues','calibratedValues')
            iterationOfCalibrator = iterationOfCalibrator + 1;
        end
    end
end





save('calibratedValues');

Screen('CloseAll');


return;