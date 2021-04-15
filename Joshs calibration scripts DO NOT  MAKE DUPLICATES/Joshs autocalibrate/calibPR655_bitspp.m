function calibPR655_bitspp(vals)
% calibration script - PR655
% created by CS on 11/28/11
% modified ______

% initialize PR655 - must be done every time variables are cleared in
% matlab or PR is disconnected and reconnected

driveBitsPP = 1; % should this script also control Bits++?
talktoPR = 1;

if talktoPR == 1
    PR655init('COM4'); % change port number to reflect correct port (must be checked every time PR is connected)
    % CMCheckInit(4,'COM5')
end

numRepeats = 1; % set number of readings to take

data = zeros(101,numRepeats); % store values from PR655measspd
spectralData = zeros(101,2); % store mean values
spectralData(:,1) = 380:4:780'; % place wavelengths in first column

if driveBitsPP == 1
    % initialize Bits++
    screenID = 2;
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'EnableBits++Bits++Output');
    wptr = PsychImaging('OpenWindow',screenID);
    [offwptr,screenRect] = Screen('OpenOffscreenWindow',wptr, 0); % open offscreen window
    Screen('Flip', wptr);
    Clut  = zeros(256,3);
    gray =  [45592	42287	44092]; %[188 188 189]; % gray value from colorThresholdingVer1.m HMS 2/27/12
    for i = 1:256
        Clut(i,:) = gray;
    end
    ss = 60;
    % make background gray
    Screen('FillRect', offwptr,0); 
    
    Screen('DrawTexture', wptr, offwptr,[],[],[],0);
    Screen('LoadNormalizedGammaTable', wptr, Clut./66535, 2);
    Screen(wptr,'Flip',0,1);
end


% load vals
% vals = [gray; gray; gray];
% initialize gun vals

% complete = 0;

% START OF LOOP

% while complete == 0

% take spectral readings

for num = 1:size(vals,1)
    gunVals = vals(num,:);
    disp('Display next stimulus');
    % display new stimulus
    if driveBitsPP == 1
        vertoffset = 30;
        Screen('FillRect', offwptr,1,...
            [screenRect(3)/2-ss screenRect(4)/2-ss-vertoffset screenRect(3)/2+ss screenRect(4)/2+ss-vertoffset]);
        Screen('DrawTexture', wptr, offwptr,[],[],[],0);
        Clut(2,:) = gunVals;
        Screen('LoadNormalizedGammaTable',wptr,Clut./65535,2);
        Screen('Flip',wptr,0,1);
        disp(['Gun values: ' num2str(gunVals)])
        if talktoPR ~= 1
            pause
        end
    else
        disp('and hit enter')
        beep;
        pause;
    end
    disp('Let display warm up...')
    % tic
    % while toc < 5
    % end
    if talktoPR == 1
        for j = 1:numRepeats
            %         tic
            %         while toc < 5
            %         end

            % measure spectral data
            disp(['Take spectral reading #' num2str(j) ' of ' num2str(numRepeats)])
            [data(:,j) qual] = PR655measspd([380 4 101]);
        end

        % average readings together
        spectralData(:,2) = mean(data,2);

        JUDDxyY(num,:) = s2j(spectralData)
        specdata = spectralData(:,2);
        save JUDDxy JUDDxyY
        save specdata specdata
    end
end

Screen('CloseAll');
% if CIE vals are correct, break out of loop
% otherwise, go back to start of loop, make changes to gun values, take
% reading from PR again

% conditional statements that result in resetting gunVals

% END OF LOOP

% end
