function [xyYJudd rawSpec] = JoshCalib(colors)
% Josh's combined calibration scripts.
% displays 16 bit colors on screen, measures using PR, reads data from PR, calls modified s2j script and returns xyY values
global windowPTR
% Make sure we're connected to the device. Connect if we're not, using COM4 for now

try 
	PR655getsyncfreq
catch
	PR655init('COM5')
end

% Call colorpatch program
bsuccess = CPforBL(colors);
pause(5)
if bsuccess == 1
	%spec = PR655measspd([],[380 5 81]);
	PR655write('M5')
else
	disp('something broke. oops')
end
clear spec;
spec = [];
clear spd;
spec = readstr(spec);
if numel(spec) < 5

spec = readstr(spec);
end
%disp(psd)
spec = PR655parsespdstrJ(spec);
rawSpec = spec;
clear xyYJudd 
clear xyYcie
[xyYJudd] = s2jJudd(spec);


%Screen('CloseAll');
%close all; 
clear spd;
end
%function [spec] = getSpecFromPR
%spec = PR655read;
function [spec] = readstr(spec)
clear spec;
spec = [];

while isempty(spec)
	try
	spec = PR655rawspd(1);
	
end
end
end