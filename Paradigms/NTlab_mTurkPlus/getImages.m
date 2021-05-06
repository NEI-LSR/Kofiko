function [imgCh,imgaCh,circle] = getImages()
    ImageDirCh = fullfile(pwd,'chromatic');
    ImageDiraCh = fullfile(pwd,'achromatic');
    ImageDirCircle = fullfile(pwd);
    numShapes = 14;
    
    for i = 1:numShapes
        shapeFiles{i} = [num2str(i) '.png'];
    end

    for i = 1:numShapes
        [imgCh{i},~, alpha] = imread(fullfile(ImageDirCh, shapeFiles{i}));
        imgCh{i}(:,:,4) = alpha;
        [imgaCh{i},~, alpha] = imread(fullfile(ImageDiraCh, shapeFiles{i}));
        imgaCh{i}(:,:,4) = alpha;
    end 

    [circle,~,alpha] = imread(fullfile(ImageDirCircle,'colorCircle.png'));
    circle(:,:,4) = alpha;


end