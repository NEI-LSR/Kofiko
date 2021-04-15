function XYZ = rgb2XYZ(RGB)
% Converts RGB values to XYZ tristimulus values.
%
% RGB values are assumend in the range 0 255
%
% Example:
%  XYZ = rgb2XYZ([255 0 0]) % convert to XYZ tristimulus values; See line
%  67; The values have to be adapted to BITS++
%  xyz = XYZ./sum(XYZ); % convert to xyz chromaticity coordinates
%
% Remasrks:
% 1. Y, the luminance is here simply the sum of RGB
%    To give correct values, one has to plug in 1/255*Y for the second
%    row in T
% 2. xy are the same when one varies only the brightness, e.g, [255 0 0]
%    for and [128 0 0] and [ 1 0 0];


% (c) 2005-10-14 Thorsten Hansen

% ensure that RGB is a column vector for later computations
if size(RGB, 1) == 1 % row vector
   RGB = RGB'; % convert to column vector
end


% Read xyY chromaticity coordinates

if ~isempty(whos('global', 'global_moncie'))
   % disp('moncie taken from global value.')
   global global_moncie
   moncie = global_moncie;
else
   disp('moncie taken from default BAY 3 values.')
   disp('use initmon to define a monitor specific moncie.')

%    % Default values are for SONY GDM-20se II CRT monitor (file sony-th.xyY)
%    moncie = [0.6130 0.3489 20.2888;
%              0.2829 0.6054 64.0547;
%              0.1565 0.0709 8.6309];

% % MARCH 2010, HMS Default values are for BAY 3 lcd projector, Mar24, 2010 
%     moncie=[0.63393 0.35723 31.86
%             0.30222 0.63574 153.23
%             0.15179 0.090219 12.111];

% April 4 2010, 
%     moncie=[0.64114 0.35526 25.555
%             0.30208 0.63885 118.37
%             0.15096 0.089028 9.4405];
        
        moncie = textread('HMS_June_2_2014.xyY');

end


% just sort matrix values to the individual coordinates
xR = moncie(1,1); yR= moncie(1,2); YR = moncie(1,3);
xG = moncie(2,1); yG= moncie(2,2); YG = moncie(2,3);
xB = moncie(3,1); yB= moncie(3,2); YB = moncie(3,3);

x = moncie(:,1)'; y = moncie(:,2)'; Y = moncie(:,3)';
z = 1-x-y;

% define transformation matrix
T1 =  [x./y; ones(1,3); z./y];

RGB2Lum = Y/65535; % this works only if after gamma correction 255 is still
                  % the mapped to 255 and 0 to 0 !!! ADAPTED TO BIT++

% variant 0
T =  [x./y.*RGB2Lum; ones(1,3).*RGB2Lum; z./y.*RGB2Lum];

% 1. alternative implementation
% T = T1*diag(RGB2Lum); % might be faster if once RGB is a whole image

% 2. alternative implementation
T = T1;
RGB = RGB2Lum'.*RGB;


% convert


% ready to convert
XYZ = T*RGB;