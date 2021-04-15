function col_ret = showrgb(rgbtriplet)
% Examples
%  showrgb([10 149 170]/255) 
%    showrgb([0 171 129; 0 170 149; 0 170 170; 0 149 170]/255)
%   showrgb(dkl2rgb(rad(180), 0, 1)')
%   showrgb(reshape(dkl2rgb(rad([140:20:220]), zeros(1,5), ones(1,5)), [5 3]))  
col = reshape(rgbtriplet, [1 size(rgbtriplet,1) 3]);
imshow(col)
if nargout > 0
  col_ret = col;
end
