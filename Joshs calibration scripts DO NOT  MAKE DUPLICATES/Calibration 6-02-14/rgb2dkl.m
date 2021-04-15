function dkl = rgb2dkl(r, g, b)
%RGB2DKL  Convert RGB to cartesian DKL coordinates.
%   DKL = RGB2DKL(R, G, B) for scalar values R, G and B converts
%      the RGB triplet into cartesian DKL coordinates, where 
%      DKL(1) : luminance (L+M) axis, 
%      DKL(2) : constant blue (L-M) axis
%      DKL(3) : tritanopic confusion (S) axis
%
%   DKL = RGB2DKL(I) for RGB color image I, converts each color value in
%      I into the cartesian DKL coordinates.
%
%   Function INITMON must be called once prior to RGB2DKL.
%
%   See also DKL2RGB, INITMON.
%  
%Thorsten Hansen 2005-02-15
global M_rgb2dkl

if prod(size(M_rgb2dkl)) == 0
  error('Initialize conversion matrices by INITMON.')
end

%if nargin == 1 & ndims(r) == 3 % input is RGB color image
%  I = r; 
%  r = I(:,:,1);
%  g = I(:,:,2);
%  b = I(:,:,3);
%end

if size(r,1) == 1 & size(r,2) == 1 % single value
  disp('single value')
  dkl = M_rgb2dkl*(2*([r;g;b]-0.5));
elseif ndims(r) == 3
  [s1 s2 thirdD] = size(r);
  dkl = reshape((M_rgb2dkl*(2*(reshape(r,s1*s2,thirdD)-0.5))')',s1,s2,thirdD);
else
  error('Dimension too large.')
end

adjust_range = 0;
if adjust_range
  ind = find(dkl < -1);
  if ~isempty(ind)
    warning('Color smallter than -1 values mapped to -1.')
    dkl(ind) = -1;
  end
  
  ind = find(dkl > 1);
  if ~isempty(ind)
    warning('Color values greater 1 mapped to 1.')
    dkl(ind) = 1;
  end
end
