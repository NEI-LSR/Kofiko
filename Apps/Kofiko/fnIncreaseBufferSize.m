function X=fnIncreaseBufferSize(X)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
sz = size(X.Buffer,2);
if iscell(X.Buffer)
	X.Buffer{sz*2} = [];
else
	X.Buffer(:,:,sz*2) = 0;
end
X.TimeStamp(sz*2) = 0;
X.BufferSize = sz*2;


return;

