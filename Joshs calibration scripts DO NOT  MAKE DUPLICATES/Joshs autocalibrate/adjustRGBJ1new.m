function [R_f, G_f, B_f, x_f, y_f, Y_f, spectrum] = adjustRGB1new(TargetValues, satName, colorName, count, Yname)
global Clut
global wptr;

R = TargetValues(1);
G = TargetValues(2);
B = TargetValues(3);
x_t = TargetValues(4);
y_t = TargetValues(5);
Y_t = TargetValues(6);





% Initial values
[x, y, Y, spectrum] = runPR655J1(R, G, B, Clut);



% Starting RGB values and target xyY
start_RGB(1,1:3) = [R G B];

n = 1;
fprintf('\n\n---------GUESS #%i: R %i, G %i, B %i----------\n',n,R,G,B);

fValsObtained = 0;

% Calculates the differences of our obtained vals from target

% Set to 0 for sign command later if value is in range of target


% Plots xy and Y guesses for every saturation and color
figure(count)
subplot(2,1,1); plot(x_t, y_t,'r*'); title([satName ', ' colorName ', ' Yname, ': xy']);
hold on;
plot(x,y,'k^');

subplot(2,1,2); plot(n,Y_t,'b*'); title([satName ', ' colorName ', ' Yname, ': luminance']);
hold on;
plot(n,Y,'k^');

% Records the first guess and xyY result
triesMat(1,1:6) = [R G B x y Y];

while fValsObtained == 0
	[cR cG cB] = deal(0);
	[dx dy dY dx_val dy_val dY_val] = checkDifs(x, y, Y, x_t, y_t, Y_t);
	% See if our values are obtained
	if dx == 0 & dy == 0 & dY == 0
	[fValsObtained finalGuesses triesMat n, spectrum] = checkFinalValues(x_t, y_t, Y_t, R, G, B, Clut, n, triesMat);
	end
	% Check luminance difference first, get back to correct values if off
	if sign(dY) ~= 0
	disp('Luminance is off, adjusting for Y')
		if sign(dY) == -1
	% Luminance below target, increase luminance
		% If x and y are below target, increase red and green
			if sign(dx) == -1 && sign(dy) == -1
				cR = 1;
				cG = 1;
			% If x and y are above target, increase blue
			elseif sign(dx) == 1 && sign(dy) == 1
				cB = 1;
			% If x is high and y is low, increase green and blue
			elseif sign(dx) == 1 
                if sign(dx) == 0 || sign(dy) == -1 
				cG = 1;
                cB = 1;
                end
			% If x is low and y is high, increase red and blue
			elseif sign(dx) == -1 
                if sign(dy) == 1 || sign(dy) == 0
				cR = 1;
                cB = 1;
                end
            % If x is good and y is high, increase red and blue
            elseif sign(dx) == 0
                if sign(dy) == 1 
                cR = 1;
                cB = 1;
                end
			% both x and y are on target, increase all values
			elseif sign(dx) == 0 && sign(dy) == 0
				[cR cG cB] = deal(1);
			end
		elseif sign(dY) == 1
		% Luminance above target, decrease luminance
			% If x and y are below target, decrease blue
			if sign(dx) == -1 && sign(dy) == -1
				cB = -1;
			% If x and y are above target, decrease red and green
			elseif sign(dx) == 1 && sign(dy) == 1
				cR = -1;
				cG = -1;
			% if x is high and y is low or y is on target, decrease red
			elseif sign(dx) == 1 
                if sign(dy) == -1 || sign(dy) == 0
                    cR = -1;
                end
            % if x is low and y is low or y is on target, decrease green
            % and blue
            elseif sign(dx) == -1 && sign(dy) == 0
                
                    cG = -1;
                    cB = -1;
                
			% if x is low or x is on target and y is high, decrease green
			elseif sign(dy) == 1  
                if sign(dx) == 0 || sign(dx) == -1
				cG = -1;
                end
            % if x is low or x is good and y is low, decrease red and blue
            elseif sign(dy) == -1 && sign(dx) == 0 
				cR = -1;
                cB = -1;
			% both x and y are on target, decrease all values
			elseif sign(dx) == 0 && sign(dy) == 0
				[cR cG cB] = deal(-1);
			end
		end
	% Change values based on sign of cR cG and cB
	[R G B] = findNewRGBValsForLum(cR, cG, cB, dx_val, dy_val, dY_val, R ,G, B);

	% Run, save and plot new values and go to next iteration of the while loop
	[x, y, Y, spectrum] = runPR655J1(R, G, B, Clut);
	triesMat(end+1,1:6) = [R G B x y Y];
        n = n+1;

        % Plots them
        pause(0.01);
        subplot(2,1,1); hold on; plot(triesMat(end-1,4),triesMat(end-1,5),'k^');
        disp('Previous and current x, y, and Y values');
        [triesMat(end-1:end,4) triesMat(end-1:end,5) triesMat(end-1:end,6)]
        plot(triesMat(end-1:end,4),triesMat(end-1:end,5),'k-');
        plot(x,y,'m^');
        subplot(2,1,2); hold on; plot((n-1),triesMat(end-1,6),'k^');
        plot((n-1):n,triesMat(end-1:end,6),'k-');
        plot(n,Y,'m^');
    continue
	end
    % Luminance is on target, we can adjust for the other values now
	disp('Luminance is on target, adjusting for x and y')
	if sign(dx) == 1 && sign(dy) == 1
		% x and y high, increase blue
		cB = 1;
	elseif sign(dx) == -1 && sign(dy) == -1
		% x and y low, decrease blue
		cB = -1;
	elseif sign(dx) == -1 && sign(dy) == 1
		% x is low and y is high, increase R and decrease G
		cR = 1 ;
		cG = -1;
    elseif sign(dx) == -1 && sign(dy) == 0
        % x is low and y is good, increase R
        cR = 1;
	elseif sign(dx) == 1 && sign(dy) == -1
		% x is high and y is low, decrease R and increase G
		cR = -1;
		cG = 1;
	elseif sign(dx) == 1 && sign(dy) == 1
		% x and y are high, decrease R and G
		cR = -1;
		cG = -1;
	elseif sign(dx) == 0 && sign(dy) == 1
		% x is good and y is high, decrease G
		cG = -1;
	elseif sign(dx) == 0 && sign(dy) == -1
		% x is good and y is low, increase G
		cG = 1;
    
	end
	% Change values based on sign of cR cG and cB
	[R G B] = findNewRGBVals(cR, cG, cB, dx_val, dy_val, dY_val, R ,G, B);

	% Run, save and plot new values and go to next iteration of the while loop
	[x, y, Y, spectrum] = runPR655J1(R, G, B, Clut);
	triesMat(end+1,1:6) = [R G B x y Y];
        n = n+1;

        % Plots them
        pause(0.01);
        subplot(2,1,1); hold on; plot(triesMat(end-1,4),triesMat(end-1,5),'k^');
        disp('Previous and current x, y, and Y values');
        [triesMat(end-1:end,4) triesMat(end-1:end,5) triesMat(end-1:end,6)]
        plot(triesMat(end-1:end,4),triesMat(end-1:end,5),'k-');
        plot(x,y,'m^');
        subplot(2,1,2); hold on; plot((n-1),triesMat(end-1,6),'k^');
        plot((n-1):n,triesMat(end-1:end,6),'k-');
        plot(n,Y,'m^');
    continue
end
	

R_f = R;
G_f = G;
B_f = B;


[C I] = min(min(abs(finalGuesses(:,4)-x_t)));
x_f = finalGuesses(I,4);
[C I] = min(min(abs(finalGuesses(:,5)-y_t)));
y_f = finalGuesses(I,5);
[C I] = min(min(abs(finalGuesses(:,6)-Y_t)));
Y_f = finalGuesses(I,6);

% Since running multiple colors and saturations, want to make sure that the
% figure of all the guesses don't overpopulate the screen

close all;
%triesMat(end+1,1:6) = [0 0 0 0 0 0]    % in the event of a constant matrix of tried values


end


% -------------------------------------------------------------------------------------
function [R G B] = findNewRGBVals(cR, cG, cB, dx_val, dy_val, dY_val, R, G, B)
% Change RGB values for next iteration
if cR ~= 0
R = R + cR * abs(round(300*(dx_val/0.004)));
end
if cG ~= 0
G = G + cG * abs(round(300*(dy_val/0.004)));
end
if cB ~= 0
B = B + cB * abs(round(300*(mean([dy_val dx_val])/0.004)));
end
end
% -------------------------------------------------------------------------------------
function [R G B] = findNewRGBValsForLum(cR, cG, cB, dx_val, dy_val, dY_val, R, G, B)
% Change RGB values for next iteration
changeBy = (-dY_val/500)
R = round(R + (changeBy*R));
G = round(G + (changeBy*G));
B = round(B + (changeBy*B));

end
% -------------------------------------------------------------------------------------

function [dx dy dY dx_val dy_val dY_val] = checkDifs(x, y, Y, x_t, y_t, Y_t)
% check differences from target values
dx = x - x_t;
dy = y - y_t;
dY = Y - Y_t;
dx_val = dx;
dy_val = dy;
dY_val = dY;

if abs(dx) < .00015
	dx = 0;
end
if abs(dy) < .00015
	dy = 0;
end
if abs(dY) < .75
	dY = 0;
end
end
% -------------------------------------------------------------------------------------

function [fValsObtained finalGuesses triesMat n, spectrum] = checkFinalValues(x_t, y_t, Y_t, R, G, B, Clut, n, triesMat)
finalGuesses = [];
for i = 1:6
[x, y, Y, spectrum] = runPR655J1(R, G, B, Clut);
finalGuesses(i,1:6) = [R G B x y Y]
triesMat(end+1,1:6) = [R G B x y Y];
n = n+1;

% Plots them
pause(0.01);
subplot(2,1,1); hold on; plot(triesMat(end-1,4),triesMat(end-1,5),'k^');
disp('Previous and current x, y, and Y values');
[triesMat(end-1:end,4) triesMat(end-1:end,5) triesMat(end-1:end,6)]
plot(triesMat(end-1:end,4),triesMat(end-1:end,5),'k-');
plot(x,y,'m^');
subplot(2,1,2); hold on; plot((n-1),triesMat(end-1,6),'k^');
plot((n-1):n,triesMat(end-1:end,6),'k-');
plot(n,Y,'m^');
end
if abs((mean(finalGuesses(:,4)))-x_t) < .00015 ...
        & abs((mean(finalGuesses(:,5)))-y_t) < .00015 & abs((mean(finalGuesses(:,6)))-Y_t) < .8
    fValsObtained = 1;
else
    fValsObtained = 0;
end
end