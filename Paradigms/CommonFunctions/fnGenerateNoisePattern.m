function [noiseOut] = fnGenerateNoisePattern(dimensions, blockSize, numPatternsToGenerate, iLuminanceStepsToGenerate)
% subtract one to deal with zeros in the resulting matrix
% the end product needs 1:iLuminanceStepsToGenerate instead of 
% 0:iLuminanceStepsToGenerate, so subtract one to generate 
% 9 unique steps between 0 and 1, then multiply by 8 and add one back on.
iLuminanceStepsToGenerate = iLuminanceStepsToGenerate - 1;
% generate coordinates of all checkboard rects
if numel(dimensions) == 1
    % square noise pattern
    dimensions(2) = dimensions(1);
end
if numel(blockSize) == 1
   blockSize(2) = blockSize(1); 
end
    dims = [ceil(dimensions(1)/blockSize(1)) ,ceil(dimensions(2)/blockSize(2))];
    uniqueNoisePatternVals = [1:1:iLuminanceStepsToGenerate] /iLuminanceStepsToGenerate;
    noisePattern = round(rand(round(prod(dims) * numPatternsToGenerate),1 ) * iLuminanceStepsToGenerate) + 1;
    %temp = repmat(noisePattern',[3,1]);
   % temp = reshape(temp,[size(temp,1) * size(temp,2)],1);
    %temp = repmat(temp,[3,1]);
   % noiseOut = temp(1:
   % reshape(temp', [sqrt(numel(temp)), sqrt(numel(temp))]);

    %noiseOut
   % noisePattern = round(rand(round(dimensions(1) * dimensions(2) * numPatternsToGenerate),1)* iLuminanceStepsToGenerate)/iLuminanceStepsToGenerate;
    %{
    noisePattern = round(rand(round(dimensions(1) * dimensions(2) ),1)* iLuminanceStepsToGenerate)/iLuminanceStepsToGenerate;
    noisePattern = reshape(noisePattern,[dimensions(1), dimensions(2)])
    noisePattern = kron(noisePattern,ones(blockSize(1)))
%}
    %n1 = 3;
    
 
noisePattern = reshape(noisePattern,[dims(1), dims(2), numPatternsToGenerate]);
tempOut = zeros([dims(1)*blockSize(1), dims(2)*blockSize(2), numPatternsToGenerate]);
for i = 1:size(noisePattern,3)
tempOut(:,:,i) = kron(noisePattern(:,:,i),ones(blockSize));
end

%shave the array down to size
%if size(tempOut,1) ~= dimensions(1) || size(tempOut,2) ~= dimensions(2) 
    noiseOut = tempOut(1:dimensions(1),1:dimensions(2),:);
%end



return;
