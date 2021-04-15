function [LumValues] = readAllRGB
warning('load color values to read')
%colorVals = uigetfile;
%colorVals = 
uiopen;
global windowPTR
% Runs through R G B gun values and takes luminance values, returns array with values
% Use in first steps of Calibration 
Screen('Preference', 'SkipSyncTests', 1);
whichScreen=1;%max(Screen('Screens'));
[windowPTR,screenRect] = Screen('Openwindow',whichScreen,32768,[],32,2);
LumValues = [];


%load(colorVals)

[m n] = size(experimentStimulusVars.stimOrder)
for i = 1:m
	[xyYJudd Spectrum] = JoshCalibforRARGB([experimentStimulusVars.stimOrder(i,1) experimentStimulusVars.stimOrder(i,2) experimentStimulusVars.stimOrder(i,3)]);
	xyYvals(i).RGB(1:3) = experimentStimulusVars.stimOrder(i,1:3);
	xyYvals(i).condition(1:2) = experimentStimulusVars.stimOrder(i,4:5);
	xyYvals(i).xyY(1:3) = xyYJudd;
end
save('xyYvals','xyYvals')
Screen('CloseAll')