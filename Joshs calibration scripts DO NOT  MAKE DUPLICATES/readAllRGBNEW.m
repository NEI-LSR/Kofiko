function [xyYvals] = readAllRGBNEW
warning('load color values to read')
%colorVals = uigetfile;
%colorVals = 

dbstop if error

uiopen;
global windowPTR gray
% Runs through R G B gun values and takes luminance values, returns array with values
% Use in first steps of Calibration 
Screen('Preference', 'SkipSyncTests', 1);
whichScreen=1;%max(Screen('Screens'));
[windowPTR,screenRect] = Screen('Openwindow',whichScreen,32768,[],32,2);

gray = [49360, 49581, 49849];

%load(colorVals)

m = numel(allColors);

for i = 1:m
	for iColors = 1:size(allColors{1,i}.RGB,1)
	[xyYJudd Spectrum] = JoshCalibforRARGB([allColors{1,i}.RGB(iColors,1), allColors{1,i}.RGB(iColors,2), allColors{1,i}.RGB(iColors,3)]);
	xyYvals(i,iColors).RGB(1:3) = allColors{1,i}.RGB(iColors,1);

	xyYvals(i,iColors).xyY(1:3) = xyYJudd;
	xyYvals(i,iColors).Spec = Spectrum;


	end
end

save('xyYvals','xyYvals')
Screen('CloseAll')