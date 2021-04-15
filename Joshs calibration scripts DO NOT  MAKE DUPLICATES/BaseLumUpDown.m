
function [LumValuesUP, LumValuesDOWN] = BaseLumUpDown
global windowPTR gray PRport
% Runs through R G B gun values and takes luminance values, returns array with values
% Use in first steps of Calibration


PRport = 'COM4';
gray = [49360 49581 49849];




Screen('Preference', 'SkipSyncTests', 1);
whichScreen= 2;%max(Screen('Screens'));
%[windowPTR, screenRect] = BitsPlusPlus('OpenWindowBits++', whichScreen);%,32768,[],32,2);
[windowPTR,screenRect] = Screen('Openwindow',whichScreen,32768,[],32,2);
LumValuesUP = [];

for g = 1:4
    reading = 1;
    for i = 0:2500:65535
        switch g
            case 1
                [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([i 0 0]);
                LumValuesUP.red(reading,1).gunValue = i;
                LumValuesUP.red(reading,1).xyYcie = xyYcie;
                LumValuesUP.red(reading,1).xyYJudd = xyYJudd;
                LumValuesUP.red(reading,1).Spectrum = Spectrum;
                if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([65535 0 0]);
                    LumValuesUP.red(reading+1,1).gunValue = i;
                    LumValuesUP.red(reading+1,1).xyYcie = xyYcie;
                    LumValuesUP.red(reading+1,1).xyYJudd = xyYJudd;
                    LumValuesUP.red(reading+1,1).Spectrum = Spectrum;
                end
            case 2
                [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 i 0]);
                LumValuesUP.green(reading,1).gunValue = i;
                LumValuesUP.green(reading,1).xyYcie = xyYcie;
                LumValuesUP.green(reading,1).xyYJudd = xyYJudd;
                LumValuesUP.green(reading,1).Spectrum = Spectrum;
                if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 65535 0]);
                    LumValuesUP.green(reading+1,1).gunValue = i;
                    LumValuesUP.green(reading+1,1).xyYcie = xyYcie;
                    LumValuesUP.green(reading+1,1).xyYJudd = xyYJudd;
                    LumValuesUP.green(reading+1,1).Spectrum = Spectrum;
                end
            case 3
                [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 0 i]);
                LumValuesUP.blue(reading,1).gunValue = i;
                LumValuesUP.blue(reading,1).xyYcie = xyYcie;
                LumValuesUP.blue(reading,1).xyYJudd = xyYJudd;
                LumValuesUP.blue(reading,1).Spectrum = Spectrum;
                if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 0 65535]);
                    LumValuesUP.blue(reading+1,1).gunValue = i;
                    LumValuesUP.blue(reading+1,1).xyYcie = xyYcie;
                    LumValuesUP.blue(reading+1,1).xyYJudd = xyYJudd;
                    LumValuesUP.blue(reading+1,1).Spectrum = Spectrum;
                end
                
            case 4
                 [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([i i i]);
                LumValuesUP.white(reading,1).gunValue = i;
                LumValuesUP.white(reading,1).xyYcie = xyYcie;
                LumValuesUP.white(reading,1).xyYJudd = xyYJudd;
                LumValuesUP.white(reading,1).Spectrum = Spectrum;
                if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([65535 65535 65535]);
                    LumValuesUP.white(reading+1,1).gunValue = i;
                    LumValuesUP.white(reading+1,1).xyYcie = xyYcie;
                    LumValuesUP.white(reading+1,1).xyYJudd = xyYJudd;
                    LumValuesUP.white(reading+1,1).Spectrum = Spectrum;
                end
                
        end
        reading = reading + 1;
        disp(LumValuesUP)
    end
end

for g = 1:4
    reading = 1;
    for i = 65000:-2500:0
        switch g
            case 1
				if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([65535 0 0]);
                    LumValuesDOWN.red(reading,1).gunValue = i;
                    LumValuesDOWN.red(reading,1).xyYcie = xyYcie;
                    LumValuesDOWN.red(reading,1).xyYJudd = xyYJudd;
                    LumValuesDOWN.red(reading,1).Spectrum = Spectrum;
                end
                [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([i 0 0]);
                LumValuesDOWN.red(reading+1,1).gunValue = i;
                LumValuesDOWN.red(reading+1,1).xyYcie = xyYcie;
                LumValuesDOWN.red(reading+1,1).xyYJudd = xyYJudd;
                LumValuesDOWN.red(reading+1,1).Spectrum = Spectrum;
                
            case 2
				if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 65535 0]);
                    LumValuesDOWN.green(reading,1).gunValue = i;
                    LumValuesDOWN.green(reading,1).xyYcie = xyYcie;
                    LumValuesDOWN.green(reading,1).xyYJudd = xyYJudd;
                    LumValuesDOWN.green(reading,1).Spectrum = Spectrum;
                end
                [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 i 0]);
                LumValuesDOWN.green(reading+1,1).gunValue = i;
                LumValuesDOWN.green(reading+1,1).xyYcie = xyYcie;
                LumValuesDOWN.green(reading+1,1).xyYJudd = xyYJudd;
                LumValuesDOWN.green(reading+1,1).Spectrum = Spectrum;
              
            case 3
			 if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 0 65535]);
                    LumValuesDOWN.blue(reading,1).gunValue = i;
                    LumValuesDOWN.blue(reading,1).xyYcie = xyYcie;
                    LumValuesDOWN.blue(reading,1).xyYJudd = xyYJudd;
                    LumValuesDOWN.blue(reading,1).Spectrum = Spectrum;
                end
                [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([0 0 i]);
                LumValuesDOWN.blue(reading+1,1).gunValue = i;
                LumValuesDOWN.blue(reading+1,1).xyYcie = xyYcie;
                LumValuesDOWN.blue(reading+1,1).xyYJudd = xyYJudd;
                LumValuesDOWN.blue(reading+1,1).Spectrum = Spectrum;
               
                
            case 4
			 if i == 65000
                    [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([65535 65535 65535]);
                    LumValuesDOWN.white(reading,1).gunValue = i;
                    LumValuesDOWN.white(reading,1).xyYcie = xyYcie;
                    LumValuesDOWN.white(reading,1).xyYJudd = xyYJudd;
                    LumValuesDOWN.white(reading,1).Spectrum = Spectrum;
                end
                 [xyYcie, xyYJudd, Spectrum] = JoshCalibforBL([i i i]);
                LumValuesDOWN.white(reading+1,1).gunValue = i;
                LumValuesDOWN.white(reading+1,1).xyYcie = xyYcie;
                LumValuesDOWN.white(reading+1,1).xyYJudd = xyYJudd;
                LumValuesDOWN.white(reading+1,1).Spectrum = Spectrum;
               
                
        end
        reading = reading + 1;
        disp(LumValuesDOWN)
    end
end





Screen('CloseAll')