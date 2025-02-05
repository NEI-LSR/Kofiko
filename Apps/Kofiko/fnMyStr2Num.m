function Y = fnMyStr2Num(strX)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

Y = str2num(strX);
if ~isempty(Y) && ~isreal(Y)
    Y = [];
end
return;
