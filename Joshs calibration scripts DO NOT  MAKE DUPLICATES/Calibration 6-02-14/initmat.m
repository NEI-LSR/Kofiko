function initmat(initfile, verbose)
%INITMAT  Initializes DKL<-->RGB conversion matrices.
%
%   INITMAT(INITFILE) initializes DKL<-->RGB conversion matrices for the
%   xyY coordinates of monitor phosphors given in INITFILE. 
%
%   INITMAT(XYY) initializes conversion matrices from the xyY coordinates
%   provided in matrix XYY. The first row is x y Y for Red monitor
%   primary, second row is x y Y for Green, third row for blue. 
%
%   INITMAT without arguments uses default xyY values to initialize the
%   conversion matrices.
%  
%   Function INITMAt must be called once prior to subsequent calls of
%   conversion routines DKL2RGB or RGB2DKL.
%
%   See also DKL2RGB, RGB2DKL.
%  
%Thorsten Hansen 2003-06-23, 2008-06-05

if nargin < 2
  verbose = 0;
end
  
% define xyY monitor coordinates
if nargin == 0 % use default init file 'sony-th.xyY' from directory
               % '/home/hansen/bib/data/lut/sony-th.xyY'; 
  if verbose
    disp(['Initialize M_dkl2rgb and M_rgb2dkl from default values.'])
  end
    
%   moncie = [0.6130 0.3489 20.2888;
%             0.2829 0.6054 64.0547;
%             0.1565 0.0709 8.6309];

moncie = textread('HMS_June_2_2014.xyY');

else
  % file format of xyY monitor coordinates
  % xyY coordinates of (r,g,b) monitor phospors and neutral gray point n
  % file format:
  %
  %   rx ry rY
  %   gx gy gY
  %   bx by bY
  %   nx ny nY <- neutral gray???
  
  if ~isstr(initfile) % assume matrix
    moncie = initfile;
  else
    
    if ~isempty(strfind(initfile, '.xyY'))...
          || ~isempty(strfind(initfile, '.xyy'))
      if exist(initfile)
        moncie = textread(initfile);
      else
        error(['Cannot open ' initfile '.xyY nor ' initfile '.xyy'])
      end
    else  
      if exist([initfile '.xyY'])
        moncie = textread([initfile '.xyY']);
        if verbose
          disp(['Initialize M_dkl2rgb and M_rgb2dkl from ''' ...
                initfile 'xyY.'''])
        end
      elseif exist([initfile '.xyy'])
        moncie = textread([initfile '.xyy']);
        if verbose
          disp(['Initialize M_dkl2rgb and M_rgb2dkl from ''' ...
                initfile 'xyy.'''])
        end
      else
        error(['Cannot open ' initfile '.xyY nor ' initfile '.xyy'])
      end
    end
  end
  if (size(moncie,1) < 3) || (size(moncie,2) < 3) 
    error(['Error reading file ''' initfile ...
           ''': must be at least 3x3 matrix.'])
  end
  if size(moncie, 2) > 3
    error('xyY data contain 4th column.')
  end
  if size(moncie, 1) > 3
    warning('xyY data contain more than 3 rows; only first 3 rows are considered.')
    moncie = moncie(1:3, :); % remove additional lines if present
  end
end
global global_moncie
global_moncie = moncie;


% initialize conversion matrices M_dkl2rgb and M_rgb2dkl 
% from monitor coordinates moncie
global M_dkl2rgb M_rgb2dkl


M_dkl2rgb = getdkl(moncie(1:3,:)); % fourth line not needed
M_rgb2dkl = inv(M_dkl2rgb);

%
% initialize conversion matrices M_rgb2lms and M_lms2rgb
%
global M_rgb2lms M_lms2rgb


% TEST: new vectorized implementation
monxyY = moncie; 
x = monxyY(:,1); y = monxyY(:,2); Y = monxyY(:,3);

if prod(y) == 0, error('y column contains zero value.'), end
z = 1 - x - y;
monxyz = [x y z];

white = Y/2;

X = x./y.*Y;
Z = z./y.*Y;
monXYZ = [X Y Z]; % this should be monCIE
% end TEST


monCIE = zeros(3,3);
monCIE(:,2) = moncie(1:3,3);

for i=1:3
  moncie(i,3) = 1.0 - moncie(i,1) - moncie(i,2);
  monCIE(i,1) = (moncie(i,1)/moncie(i,2))*monCIE(i,2);
  monCIE(i,3) = (moncie(i,3)/moncie(i,2))*monCIE(i,2);
  monRGB(i,1) = 0.15514 * monCIE(i,1) + ...
      0.54313 * monCIE(i,2) - 0.03386 * monCIE(i,3);
  monRGB(i,2) = -0.15514 * monCIE(i,1) + ...
      0.45684 * monCIE(i,2) + 0.03386 * monCIE(i,3);
  monRGB(i,3) = 0.01608 * monCIE(i,3);
  tsum = monRGB(i,1) + monRGB(i,2);
  monrgb(i,1) = monRGB(i,1) / tsum;
  monrgb(i,2) = monRGB(i,2) / tsum;
  monrgb(i,3) = monRGB(i,3) / tsum;
end

Xmon = monCIE; % who needs Xmon?
% maxdiff(monXYZ, monCIE)

Xmat= inv(Xmon);

M_rgb2lms = monRGB; % M_rgb2lms used in mon2cones
M_lms2rgb = inv(M_rgb2lms);


% white point
%w = mon2cones(0.5, 0.5, 0.5);
w = [0.5 0.5 0.5] * M_rgb2lms;



%------------------------------------------------------------------------------
function M_dkl2rgb = getdkl(monxyY) 
%------------------------------------------------------------------------------
% compute dkl2rgb conversion matrix from moncie coordinates
% (compare function "getdkl" in color.c)

x = monxyY(:,1); y = monxyY(:,2); Y = monxyY(:,3);
if prod(y) == 0, error('y column contains zero value.'), end
xyz = [x y 1-x-y];
white = Y/2;

% Smith & Pokorny cone fundamentals 
% V. C. Smith & J. Pokorny (1975), Vision Res. 15, 161-172.
M = [ 0.15514  0.54312  -0.03286
     -0.15514  0.45684   0.03286
      0.0      0.0       0.01608];

RGB = xyz*M'; % R, G  and B cones (i.e, long, middle and short wavelength)

RG_sum = RGB(:,1) + RGB(:,2); % R G sum
R = RGB(:,1)./RG_sum;
B = RGB(:,3)./RG_sum; 
G = 1 - R;

% alternative implementation of last 4 lines
%RGB = RGB./repmat(RGB(:,1) + RGB(:,2), 1, 3);
%R = RGB(:,1); G = RGB(:,2); B = RGB(:, 3);

% constant blue axis (red-green axis, i think brc?)
a = white(1)*B(1);
b = white(1)*(R(1)+G(1));
c = B(2);
d = B(3);
e = R(2)+G(2);
f = R(3)+G(3);
dGcb = (a*f/d - b)/(c*f/d - e); % solve x
dBcb = (a*e/c - b)/(d*e/c - f); % solve y

% tritanopic confusion axis (blue-yellow axis, i think brc?)
a = white(3)*R(3);
b = white(3)*G(3);
c = R(1);
d = R(2);
e = G(1);
f = G(2);
dRtc = (a*f/d - b)/(c*f/d - e); % solve x
dGtc = (a*e/c - b)/(d*e/c - f); % solve y

IMAX = 1;
M_dkl2rgb = IMAX * [1        1         dRtc/white(1)
                    1  -dGcb/white(2)  dGtc/white(2)
                    1  -dBcb/white(3)     -1]; 

