function rgb = dkl2rgb(az, el, r, s, with_correction)
%DKL2RGB  Convert polar DKL coordinates to RGB.
%   RGB = DKL2RGB(AZIMUTH, ELEVATION, RADIUS) returns the corresponding 
%   RGB color image. AZIMUTH specifies the angle with respect to the 
%   constant blue (L-M) axis in DKL space and must be given in radians
%   in the range [0, 2*pi]. ELEVATION specifies the angle with respect to
%   the isoluminant plane and must be given in radians
%   in the range [-pi, pi]. RADIUS must be in the range [0,1]. 
%     
%   Function INITMON must be called once prior to DKL2RGB.
%
%
%Example 1: RGB values of sample DKL color
%
%   initmon;                    % must be called once to initialize 
%                               %    the global conversion matrices
%   R = dkl2rgb(rad(0), 0, 1))  % "red" along (L-M) axis 
%   imshow(reshape(R,1,1,3))    % rearrange as color image and show
%
%
%Example 2: Isoluminant plane of DKL space
%  
%   initmon; % if not already called before
%   halfimsize = 256;
%   x = -halfimsize:halfimsize; y = fliplr(x); % (x,y) coordinate systems
%   [X, Y] = meshgrid(x, y);
%   R = sqrt(X.^2 + Y.^2); PHI = atan2(Y, X);
%   R = R/halfimsize; R(R>1) = 0;   % R in the range [0, 1]   
%   PHI(PHI<0) = PHI(PHI<0) + 2*pi; % PHI in the range [0, 2*pi] 
%   imshow(dkl2rgb(PHI, 0, R));  
%  
%   See also DKL2RGB, INITMON.
%  
%Thorsten Hansen 2003-06-23
%                2004-04-10  faster computation
%                            warning with number of remapped values 
%                            NEW DEFAULT: NO correction!!!
% dkl given as row vector of polar coordinates (az, el, r)
% az and el given in radians

if nargin < 4, s = 1; end % no scaling
if nargin < 5, with_correction = 0; end % default is no correction

global M_dkl2rgb

if prod(size(M_dkl2rgb)) == 0
  error('initialize conversion matrices by INIMON.')
end

[x,y,z] = sph2cart(az, el, r);
x = x/s; y = y/s; z = z/s;

if size(x,1) == 1 & size(x,2) == 1 % single value
  rgb = 0.5 + M_dkl2rgb*[z;x;y]/2; % z:= lum, x:= cb, y:= tc
elseif ndims(x) == 2
  % rgb = zeros(size(x,1), size(x,2), 3);
  % for i=1:size(x,1)
  %  for j=1:size(x,2)
  %    rgb(i,j,:) = 0.5 + M_dkl2rgb*[z(i,j);x(i,j);y(i,j)]/2;
  %  end
  %end
  dkl= cat(3, z, x, y);
  [rows cols thirdDim] = size(dkl);
  rgb = reshape(reshape(dkl, rows*cols, 3) * M_dkl2rgb', rows, cols, 3);
  rgb = 0.5 + rgb/2;
else
  error('dimension to large.')
end

if with_correction
  ind = find(rgb<0);
  if ~isempty(ind)
    warning([int2str(length(ind)) ' negative color values mapped to 0.'])
    rgb(ind) = 0;  
  end

  ind = find(rgb>1);
  if ~isempty(ind)
    warning([int2str(length(ind)) ' color values greater 1 mapped to 1.'])
    rgb(ind) = 1;  
  end
end
