function [varargout] = fnLoadImageSet(command, DirectoryPath, varargin)
global g_strctPTB

for iCommand = 1:numel(command)
    switch command{iCommand}
        case 'FindImageSets'
            
            % imageSetPath = g_strctParadigm.m_strImageListDirectoryPath;
            tempDirList = dir(DirectoryPath);
            imageLists = {};
            for i = 1:size(tempDirList,1)
                if tempDirList(i).isdir && ~strcmpi(tempDirList(i).name,'.') && ~strcmpi(tempDirList(i).name,'..')
                    imageLists{end+1} = tempDirList(i).name;
                end
            end
            varargout{1} = imageLists;
        case 'LoadImageSet'
            ImageLists = varargin{1};
            for iImageSets = 1:size(ImageLists,1)
                imageListName = ImageLists{iImageSets};
                ahImageHandles = [];
                imageSetName = deblank(ImageLists{iImageSets});
                imageSetDir = dir([DirectoryPath,'\',imageSetName]);
                filetype = {};
                for iDirSize = 1:size(imageSetDir,1)
                    [~,~,filetype{iDirSize}] = fileparts(imageSetDir(iDirSize).name);
                    %idx = structfun(@(x) fileparts(x.name), [imageSetDir.name])
                end
                
                imagesIDX = strcmpi('.tif' ,filetype) | strcmpi('.jpg' ,filetype);
                
                imagesFileNames = imageSetDir(imagesIDX);
                
                for iImage = 1:size(imagesFileNames,1)
                    imageFileName = [DirectoryPath,'\',imageListName,'\',imagesFileNames(iImage).name];
                    [Image, ~] = imread(imageFileName);
                    ahImageHandles(iImage) = ...
                        Screen('MakeTexture', g_strctPTB.m_hWindow,  Image);
                    
                end
            end
            varargout{1} = ahImageHandles;
    end
end
return;