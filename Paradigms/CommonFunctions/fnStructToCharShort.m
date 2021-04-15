function [a2cCharMatrix,acFileNamesNoPath] = fnStructToCharShort(acFileNamesWithPath) 
if isstruct(acFileNamesWithPath)
    acFileNamesNoPath = fieldnames(acFileNamesWithPath);
else
    acFileNamesNoPath = num2str(acFileNamesWithPath);
end

a2cCharMatrix = char(acFileNamesNoPath);
return;
