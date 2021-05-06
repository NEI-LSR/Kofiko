function drawMultipleOvalsTest()
Screen('Preference', 'SkipSyncTests', 1);
ovalRadius = 30;
numDiscs = 16;
numDiscsToGenerate = 200;
%{
ovalCols =  horzcat(linspace(0,255,16)',...
                    linspace(0,255,16)',...
                    linspace(0,255,16)');
%}
ovalCols = ones(3,16) * 128;
frames = 300;
randColorVariation = 1:9;
randColorAmplitude = 10;
tic
   
[winPtr, winRect] = Screen(2,'OpenWindow',ones(1,3)*127,[0,0,1024,768]);
halfScreenHeight = myRange([winRect(2),winRect(4)])/2;

%colors = linspace(0,255,16);
theta = [0:(pi/(numDiscs/2)):2*pi-.0000001];
rho = .5 * halfScreenHeight;


%findInternalPointsX = [targetPointsX - ovalRadius:targetPointsX + ovalRadius-1];
%findInternalPointsY = [targetPointsY - ovalRadius:targetPointsY + ovalRadius-1];

[coordGridX, coordGridY] = meshgrid([1:ovalRadius*2] ,...
                                        [1:ovalRadius*2]);

tic
dist = sqrt((coordGridX - ovalRadius(:)).^2   +   (coordGridY - ovalRadius(:)).^2); % distance calc.

% Find points inside circle
in = find(dist<ovalRadius);
insidePoints(1,:) = coordGridX(in);
insidePoints(2,:) = coordGridY(in);
toc
randomNums = ceil(rand(1,size(insidePoints,2)).*size(randColorVariation,2)-1)+1;
randomColVals = floor(randColorVariation(randomNums)/9 * 255);% * randColorAmplitude;
targetRect = [];
lastSubscript = 1;
targetRectsX = insidePoints(1,:); %+ targetPointsX(iTargetPoints);
targetRectsY = insidePoints(2,:); %+ targetPointsY(iTargetPoints);
linearIndices = sub2ind([ovalRadius*2, ovalRadius*2],targetRectsX,targetRectsY);
thisTexture = ones((ovalRadius*2)*(ovalRadius*2),3)*128;
% rectColors(1:3,lastSubscript:lastSubscript+size(targetRectsX,2)-1) =  repmat(randomColVals(randperm(numel(randomColVals))),[3,1]);
textHolder = zeros(numDiscsToGenerate,1);
tic
for iDiscs = 1:numDiscsToGenerate
    
	
    thisTexture(linearIndices, :) = repmat(randomColVals(randperm(numel(randomColVals)))',[1,3]);
    textHolder(iDiscs) = Screen('MakeTexture', winPtr, reshape(thisTexture,[(ovalRadius*2),(ovalRadius*2),3]));
	%for iTargetPoints = 1:numel(targetPointsX)
	
		%iTargetPoints = 1
		%targetRectsX = insidePoints(1,:) + targetPointsX(iTargetPoints);
		%targetRectsY = insidePoints(2,:) + targetPointsY(iTargetPoints);
		%rectColors(1:3,lastSubscript:lastSubscript+size(targetRectsX,2)-1) =  repmat((randomColVals(randperm(numel(randomColVals))) + ovalCols(1,iTargetPoints)),[3,1]);
		%targetRect(1:4,lastSubscript:lastSubscript+size(targetRectsX,2)-1) = [targetRectsX-1; targetRectsY-1; targetRectsX; targetRectsY];
		
		
	
		%lastSubscript = lastSubscript + size(targetRectsX,2);
	   
	%end
end
toc
[targetPointsX, targetPointsY] = pol2cart(theta,rho);
ScreenCenterX = myRange([winRect(1),winRect(3)])/2;
ScreenCenterY = halfScreenHeight;
targetRect = zeros(4,numDiscs);
targetPointsX = round(targetPointsX + ScreenCenterX);
targetPointsY = round(targetPointsY + ScreenCenterY);
for iTargetCoords = 1:numDiscs
    
   targetRect(:,iTargetCoords) = [targetPointsX(iTargetCoords) - ovalRadius, ...
										targetPointsY(iTargetCoords) - ovalRadius, ...
										targetPointsX(iTargetCoords) + ovalRadius, ...
										targetPointsY(iTargetCoords) + ovalRadius]; 
end

for frames = 1:frames
    thisFrameTextures = ceil(rand(numDiscs,1) * numDiscsToGenerate);
    tic
    Screen('DrawTextures',winPtr, textHolder(thisFrameTextures),[], targetRect)
    %toc
    Screen('Flip',winPtr)
    time2(frames) =  toc;
end
    
    sca

return;