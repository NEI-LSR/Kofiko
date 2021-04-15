function [varargout] = fnLoadImageSet(command, varargin)
global g_strctParadigm


switch command
    case 'FindImageSets'
        
        imageSetPath = g_strctParadigm.m_strImageListDirectoryPath;
        tempDirList = dir(imageSetPath);
        imageLists = {};
        for i = 1:size(tempDirList,1)
            if tempDirList(i).isdir && ~strcmpi(tempDirList(i).name,'.') && ~strcmpi(tempDirList(i).name,'..')
                imageLists{end+1} = tempDirList(i).name;
            end
        end
        varargout{1} = imageLists;
        
    case 'LoadImageSet'
        g_strctParadigm.m_strctImages.m_ahImageHandles = [];
        imageSetName = varargin{1};
        imageSetDir = dir([g_strctParadigm.m_strImageListDirectoryPath,'\',imageSetName]);
        filetype = {};
        for iDirSize = 1:size(imageSetDir,1)
            [~,~,filetype{iDirSize}] = fileparts(imageSetDir(iDirSize).name);
            %idx = structfun(@(x) fileparts(x.name), [imageSetDir.name])
        end
        
        imagesIDX = strcmpi('.tif' ,filetype) | strcmpi('.jpg' ,filetype);
        
        imagesFileNames = imageSetDir(imagesIDX);
        
        for iImage = 1:size(imagesFileNames,1)
           imageFileName = [imageSetDir,'\',imagesFileNames(iImage).name];
           [Image, ~] = imread(imageFileName);
           g_strctParadigm.m_strctImages.m_ahImageHandles(iImage) = ...
                            Screen('MakeTexture', g_strctPTB.m_hWindow,  Image);
            
        end
        
        
end

return;