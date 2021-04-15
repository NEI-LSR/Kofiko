function tstrct = fnTsAddVar(tstrct, strVarName, InitValue,iInitBufferLength)
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

% Timstamped structure
fCurrTime = GetSecs();
if iscell(tstrct)
   subStruct = tstrct{2};
   tstrct = tstrct{1};
   substructAssignment = 1;
else
   substructAssignment = 0;
end

if ~exist('iInitBufferLength','var')
    iInitBufferLength = 1;
end;
% Allocate container.

if ischar(InitValue) || iscell(InitValue)
    Container = cell(1,iInitBufferLength);
    Container{1} = InitValue;

    afTimeStamp = zeros(1, iInitBufferLength);
    afTimeStamp(1) = fCurrTime;
    if substructAssignment
        tstrct.(subStruct).(strVarName).Buffer = Container;
        tstrct.(subStruct).(strVarName).TimeStamp = afTimeStamp;
        tstrct.(subStruct).(strVarName).BufferIdx = 1;
        tstrct.(subStruct).(strVarName).BufferSize = iInitBufferLength;

    else
        tstrct.(strVarName).Buffer = Container;
        tstrct.(strVarName).TimeStamp = afTimeStamp;
        tstrct.(strVarName).BufferIdx = 1;
        tstrct.(strVarName).BufferSize = iInitBufferLength;
    end
else

    sz = size(InitValue);
    Container = zeros([sz, iInitBufferLength]);
    if length(sz) == 1
        Container(1) = InitValue;
    end;
	
    if length(sz) == 2
        Container(:,:,1) = InitValue;
    end;
	
    if length(sz) == 3
        Container(:,:,:,1) = InitValue;
    end;
	
    afTimeStamp = zeros(1, iInitBufferLength);
    afTimeStamp(1) = fCurrTime;
    if substructAssignment
        tstrct.(subStruct).(strVarName).Buffer = Container;
        tstrct.(subStruct).(strVarName).TimeStamp = afTimeStamp;
        tstrct.(subStruct).(strVarName).BufferIdx = 1;
        tstrct.(subStruct).(strVarName).BufferSize = iInitBufferLength;
    else
        tstrct = setfield(tstrct, strVarName, struct('Buffer', Container, 'TimeStamp', afTimeStamp,'BufferIdx',1,'BufferSize', iInitBufferLength));
    end
end;

return;
