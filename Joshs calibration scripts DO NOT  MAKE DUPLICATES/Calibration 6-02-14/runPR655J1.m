%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runPR655.m: Establishes communication with Barco and PR-655
% - Presentation of set [R G B] gun values stimuli on Barco screen
% - Obtain spectral readings [x y Y] via spectrophotometer, PR-655
%
% Author: Cleo Stoughton
% Last modified: Jiun-Yiing Hu, 5/30/13
% Dependencies: s2j.m
% Client: adjustRGB1.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, y, Y, varargout] = runPR655J1(R, G, B, Clut)
% Initialize PR655 - must be done every time variables are cleared in
% Matlab or PR is disconnected and reconnected

    global wptr;
    global offwptr;
	global screenRect;
	global screenWidth;
	global screenHeight;
    PR655init('COM4'); %COM4 (COM is for Windows)
                                    % 'ls /dev/cu.*' in terminal to obtain
                                    % Change port number to reflect correct port
                                    % (must be checked every time PR is connected)
                                    % /dev/cu.usbmodem1421
    numRepeats = 1;                 % Number of readings to take
        % -- changed numRepeats from 3 to 1, b/c GG set PR to take 3 measurements
    driveBitsPP = 1;                % Should this script also control Bits++?
	
    data = zeros(101,numRepeats);   % To store values from PR655measspd
    spectralData = zeros(101,2);    % To store mean values
    spectralData(:,1) = 380:4:780; % Place wavelengths in first column

    % Initialize gun values
    gunVals = [R G B];
   

    % Run PR-655: Take spectral readings
    beep;
    disp('Display next stimulus');
    % Display new stimulus
    if driveBitsPP == 1
        Clut(2,:) = gunVals;
         Screen('LoadNormalizedGammaTable',wptr,linspace(0,1,256)'*ones(1,3));
		 
		 BitsPlusSetClut(wptr,Clut);
		 [screenWidth, screenHeight]=Screen('windowSize', wptr);
		size = min([screenWidth screenHeight]);
		 xpos = screenWidth/2; ypos = screenHeight/2;
		 %Screen('LoadNormalizedGammaTable',wptr,Clut/65535,2);
        % ---- doesn't work on electrophysiology rig?
%         linspace(0,1,256)'*ones(1,3) instead of Clut/65535
	Screen('FillRect', wptr, 0);     % Fill background gray
	%ss = 40;
	
	squaresize = size / 6;
	Screen('FillOval', wptr, 1, [ xpos-squaresize/2 ypos-squaresize/2 xpos+squaresize/2 ypos+squaresize/2 ] );
		
		
        Screen('Flip',wptr)%,0,1);
        disp(['Gun values: ' num2str(gunVals)])
    else
        pause(5);   % Removed disp('and hit enter') b/c automating
    end
    
	
	disp('Let display warm up...')

pause(5)
PR655write('M5')

clear spec;
spec = [];
clear spd;
while isempty(spec)
	try
        spec = PR655rawspd(1);
    
    end
end
%disp(psd)
spec = PR655parsespdstrJ(spec);
[JUDDxyY] = s2jJ(spec);
    % Average readings together
    %save JUDDxyY;
    x=JUDDxyY(1);
    y=JUDDxyY(2);
    Y=JUDDxyY(3);
	varargout{1} = spec;
end