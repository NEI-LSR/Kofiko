function [xyY] = JoshReadPR

PR655write('M5')

clear spec;
spec = [];
clear spd;
while isempty(spec)
	spec = PR655rawspd(1);
end
%disp(psd)
spec = PR655parsespdstrJ(spec);
[xyY] = s2jJ(spec);

clear spd;
end