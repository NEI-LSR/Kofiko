%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% autocalibrate_EPv1.m: Client program for the suite of scripts that
% automatically calibrates the Barco monitor by adjusting its RGB gun values
% to achieve xyY target values (in the 1931 CIE Colour Space) as measured
% by the spectroradiometer, PR-655.
% > MODIFIED FOR ELECTROPHYSIOLOGY RIG
%
% Author: Jiun-Yiing Hu, 07/13
% Last modified: JYH 08.14.13 & MR 08.xx.13
% Dependencies: adjustRGB1.m

% Need to change line 40 'gray = [R G B]' upon calibrating baseline grey
% Line 80: lumVals = [-20 BL +20]; --> Set to the 3 target luminance values, e.g. 38.72 48.4 58.08

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function autocalibrate_EPv1J1
global iWhichValuesToUse;
global wptr;
global offwptr;
global screenRect;
global screenWidth;
global screenHeight;
path = pwd;
iWhichValuesToUse = 1;
%% Generates primary & off-screen windows
% Open window with Psychtoolbox
% Draw background and test square

% Imports file w/ initial RGB & target xyY vals for all colors at each sat
[targValsFile, path] = uigetfile({'.xls'},'Test Target Values (*.xls)',path);

% Temporary: create it to run sans Bits++c
% Initialize Bits++
screenID = 1;   %2 (0 for current monitor)
[wptr, screenRect] = Screen('OpenWindow',screenID); % window pointer

%[offwptr,screenRect] = Screen('OpenOffscreenWindow',wptr, 0); % Open offscreen window
%Screen('Flip', wptr);

Clut  = zeros(256,3);   % Clut 1:256
%gray = input('Starting gray RGB values (e.g. [45893 44408 45500]): ');  % Make static once program functional
gray = [50554	50711	50893];

% gray = [48813 48813 49337];

for i = 1:256
    Clut(i,:) = gray;
end

%% Import target values
    



% Obtains file sheet names (= the diff. pre-defined saturations)
[type, sats] = xlsfinfo(targValsFile);
clear path type;

%numColors = input('Number of colors: ');
numColors = 16;
sprintf('%i colors to be calibrated.',numColors);
    
% Static variables
if strfind(targValsFile,'Gray')
    lumVals = [1 2 3 4 5 6 7];   % Replace 1:7 with target Y values for -100 -20 -10 0 10 20 100 in that order
    sets = length(lumVals);
elseif strfind(targValsFile,'Colors')
    lumVals = [1 2 3]; % Set to the 3 target luminance values, e.g. 38.72 48.4 58.08
    sets = (length(lumVals)*numColors);
    sprintf('\nEach color at each saturation will be calibrated for 3 luminance values: %u %u(baseline) %u.\nThere are %i sets in total.',lumVals(1), lumVals(2), lumVals(3), sets);
end


%% General Prep
    
% Total # of colors and saturations
if any(strcmp('Final Calibration Vals',sats))
    numSats = length(sats)-1;   % The last sheet = final calibration values
else
    numSats = length(sats);
end
satsColors = zeros(length(numSats),1);
    % allows count to be an unusual size, accounting for when the # of
    % colors being calibrated for each sat is not the same for all sats

% Creates a matrix containing all final calibration values:
% Saturation | Color | Luminance | R | G | B | x | y | Y
FinalVals = {};

count = 1;

resumed = input('Are you resuming auto-calibration? (y/n) ','s');
if strcmp(resumed,'y')
    [Rnum Rtxt Rraw] = xlsread(targValsFile,'Final Calibration Vals');  % R = resumed
    resumeLoc = sum(~isnan(Rnum(:,4))) + 1;  % Row in final calib vals from which to resume calibration
    
    % How many remaining saturations?
    start_i = ceil(resumeLoc/sets);
        % ceil(resumeLoc/sets) gives how many full sets are in the
        % population of calibrated values so far, up until the location for
        % resuming calibration.
        
    % How many remaining colors/luminance levels?
    [c ia ic] = unique(Rnum(2:end,1),'first');
    clear c ic;
    if strfind(targValsFile,'Colors')%%substitute by 'Gray' when measuring grey values
        start_j = resumeLoc;
%     elseif strfind(targValsFile,'Colors')
%         if (resumeLoc >= ia(1)) && (resumeLoc <= ia(2))
%             start_j = resumeLoc;
%         elseif (resumeLoc > ia(2)) && (resumeLoc <= ia(3))
%             start_j = resumeLoc - sets;
%         elseif (resumeLoc > ia(3)) && (resumeLoc <= ia(4))
%             start_j = resumeLoc - (2*sets);
%         elseif (resumeLoc > ia(4)) && (resumeLoc <= ia(5))
%             start_j = resumeLoc - (3*sets);
%         elseif (resumeLoc > ia(5)) && (resumeLoc <= ia(6))
%             start_j = resumeLoc - (4*sets);
%         elseif (resumeLoc > ia(6))
%             start_j = resumeLoc - (5*sets);
%         end
     end
    
    fprintf('\nThe starting i value is %i, the starting j value is %i.\n', start_i, start_j);

    clear Rnum Rtxt Rraw resumeLoc;
else
    % Not resuming calibration, start from the beginning
    start_i = 1;
    start_j = 1;
end

% Turns on diary when running program. Just in case my fix doesn't work, and
% Java heap does run out of memory, at least there will be a record of the
% RGB guesses tried.
%diary


%% Calibrate each color & saturation

% Goes through each saturation,
for i = start_i:numSats
    
    % Imports data from the Excel sheet
    [num txt raw] = xlsread(targValsFile, sats{i}); %B2:G9 - clear raw;
    [txtrows txtcols] = size(num);
    txtrows = txtrows +1;
    satsColors = txt(2:txtrows)';   % Gets color names (c1, c2, ..)
    clear txtrows txtcols;
    satName = sats{i};  % Gets saturation value
    % Goes through each colour and calibrates it
    
    for j = start_j:(size(num,1)-1)
        
        % Initial RGB values
        R = num(j,2);
        G = num(j,3);
        B = num(j,4);
        
        % Target (_t) xyY values for color j at saturation i
        x_t = num(j,5);
        y_t = num(j,6);
        Y_t = num(j,7);
        
        % To create a well-defined box for first aligning/focussing the PR
        % on the stimulus, if sat is too low to be visible
        % R = 50000; G = 10000; B = 10000;
        
        colorName = satsColors{j};
        Yname = [];
        if strfind(targValsFile,'Gray') 
            if Y_t == lumVals(1)
                Yname = 'Minus20';
            elseif Y_t == lumVals(2)
                Yname = 'Baseline';
            elseif Y_t == lumVals(3)
                Yname = 'Plus20';
            end
        end
        
        fprintf('\nBeginning: Saturation %s, Color %s, %s Luminance.\n',satName,colorName,Yname);
        
        % Run PR655 to produce xyY vals
        %save Clut Clut;
        [x, y, Y] = runPR655J1(R, G, B, Clut)
        % runPR655 just loads the new color lookup table and communicates
        % with the PR to read new values
        
        % Adjust RGB until xyY reach targets:
        % - x and ys within ±.0001 range
        % - Y within ±.5 range
        % Produces final (_f) RGB & xyY values 
        [R_f, G_f, B_f, x_f, y_f, Y_f, triesMat, spec] = adjustRGBJ1new(x, y, Y, ...
            R, G, B, x_t, y_t, Y_t, satName, colorName, count, Clut, Yname);
        
        % Final values prepared
        FinalVals{end+1} = {R_f, G_f, B_f, x_f, y_f, Y_f};
        
		
		% save the spectrum somewhere
		time_now = clock;
		filename_for_spec = sprintf('%s_%s_%s_%s_%s_%s_spec.mat',num2str(time_now(1)),num2str(time_now(2)),...
			num2str(time_now(3)),num2str(time_now(4)),num2str(time_now(5)),num2str(time_now(6)));
		save(filename_for_spec,'spec','x_f','y_f','Y_f')
        fprintf('\nThe final RGBxyY values for saturation %s, color %s, %s lum, are: \nR %i \nG %i \nB %i \nx %i \ny %i \nY %i\n\n',...
            satName,colorName,Yname,R_f,G_f,B_f,x_f,y_f,Y_f);
        
        backup_colVars = sprintf('Almost_S%s_%s_Y%s',satName(3:end),upper(colorName),Yname);
        save(backup_colVars);
        % Made more edits but didn't have opportunity to run, so this will be a
        % back-up save of all the color tries just in case the next part screws up
        
        final_ExcelRange = sprintf('D%i:I%i',(j+1+((i-1)*length(satsColors))),(j+1+((i-1)*length(satsColors))));
        [success, message] = xlswrite([pwd filesep targValsFile], ...
            FinalVals{end}, 'Final Calibration Vals', final_ExcelRange);
        
        % Checks for possibility of java out of memory error after every color
        checkJavaMemory
        
        count = count+1;
        
        % If this is a -20 lum, then adjust all the values to fit, so it
        % won't take as long to calibrate diff lums or same color
        if strfind(targValsFile,'Gray')
            if Y_t == lumVals(2)
               for m = 3:6
                   num(m,2) = num(m,2) + (1650*(m-2));
                   num(m,3) = num(m,3) + (1700*(m-2));
                   num(m,4) = num(m,4) + (1700*(m-2));
               end
               dif100 = [(num(2,2)-num(1,2)) (num(2,3)-num(1,3)) (num(2,4)-num(1,4))];
               num(7,2:4) = num(6,2:4) + dif100;
            end
        else
           if Y_t == lumVals(1)
               
               % Reordered so BL, -20, +20:
               % Minus 20 Lum
               num(j+1,2) = num(j,2) - 1650;
               num(j+1,3) = num(j,3) - 1700;
               num(j+1,4) = num(j,4) - 1700;
               
               % Plus 20 Lum
               num(j+2,2) = num(j,2) + 1650;
               num(j+2,3) = num(j,3) + 1700;
               num(j+2,4) = num(j,4) + 1700;
               

           end
        end
        
        
    end
    
    % Reset start_j to be 1, in case it isn't due to this being a resumed run
    start_j = 1;
    
    if strcmp(upper(satName),'GRAY') || strcmp(upper(satName),'GREY')   % so don't need to account for case
        
        pause;
        % Reset Y to luminance value gray is calibrated to
        Y = Y_f;

        % New background gray value
        gray = [R_f G_f B_f]
        for i = 1:256
            Clut(i,:) = gray;
        end
        Screen('FillRect', wptr, 0);     % Fill background gray
        Screen('FillRect', wptr, 1,...   % Draw square
            [screenRect(3)/2-ss screenRect(4)/2-ss screenRect(3)/2+ss screenRect(4)/2+ss]);


    end
    
    backup_satVars = sprintf('Almost_%s',satName);
    if exist(backup_satVars) == 1
        delete(backup_satVars);
    end
    save(backup_satVars);
    clear backup_satVars;
end


% Close Psychtoolbox window
Screen('CloseAll');
diary off;

    function checkJavaMemory
        
        % Beta testing: not sure if this will actually solve issue of Out
        % of Java Memory Heap running out of memory after a while
        heapTotalMemory = java.lang.Runtime.getRuntime.totalMemory;
        heapFreeMemory = java.lang.Runtime.getRuntime.freeMemory;
        if(heapFreeMemory < (heapTotalMemory*0.01))
            java.lang.Runtime.getRuntime.gc;
        end
        
    end

end