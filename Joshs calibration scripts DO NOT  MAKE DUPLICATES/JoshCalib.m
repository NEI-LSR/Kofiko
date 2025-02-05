function [vals] = JoshCalib(colors)
% Josh's combined calibration scripts.
% displays 16 bit colors on screen, measures using PR, reads data from PR, calls modified s2j script and returns xyY values
global screenID
% Make sure we're connected to the device. Connect if we're not, using COM4 for now
bsuccess = 0;
screenID = 2;
try 
	PR655getsyncfreq
catch
	PR655init('COM4')
end

% Call colorpatch program
bsuccess = CPforJC(colors);
pause(5)
if bsuccess == 1
	%spec = PR655measspd([],[380 5 81]);
	pause(1)
	PR655write('M5')
else
	disp('something broke. oops')
end
clear spec;
spec = [];
clear spd;
spec = readStr(spec);
if numel(spec) < 5

spec = readStr(spec);
end
%disp(psd)
vals.spec = PR655parsespdstrJ(spec);
vals.xyYCIE = s2jcie(vals.spec);
vals.xyYJudd = s2jJ(vals.spec);

%Screen('CloseAll');
%close all; 
clear spd;

%function [spec] = getSpecFromPR
%spec = PR655read;
Screen('CloseAll')

end
function spec = readStr(spec)
clear spec;
spec = [];
while isempty(spec)
	
	spec = PR655rawspd(1);
	
end
end