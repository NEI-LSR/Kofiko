function [xyY] = JoshCalib(colors)
% Josh's combined calibration scripts.
% displays 16 bit colors on screen, measures using PR, reads data from PR, calls modified s2j script and returns xyY values

% Make sure we're connected to the device. Connect if we're not, using COM4 for now

try 
	PR655getsyncfreq
catch
	PR655init('COM4')
end

% Call colorpatch program
bsuccess = CPforCPP(colors);
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
while isempty(spec)
	
	spec = PR655rawspd(1);
end
%disp(psd)
spec = PR655parsespdstrJ(spec);
[xyY] = s2jJ(spec);

%Screen('CloseAll');
%close all; 
clear spd;

%function [spec] = getSpecFromPR
%spec = PR655read;
Screen('CloseAll')
