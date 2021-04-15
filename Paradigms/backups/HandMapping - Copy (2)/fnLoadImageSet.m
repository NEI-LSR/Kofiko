function [varargout] = fnLoadImageSet(command, DirectoryPath, varargin)
global g_strctPTB
if ~iscell(command)
   command = {command}; 
end
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
		case 'FindMovieSets'
            
            % imageSetPath = g_strctParadigm.m_strImageListDirectoryPath;
            tempDirList = dir(DirectoryPath);
            movieLists = {};
            for i = 1:size(tempDirList,1)
                if tempDirList(i).isdir && ~strcmpi(tempDirList(i).name,'.') && ~strcmpi(tempDirList(i).name,'..')
                    movieLists{end+1} = tempDirList(i).name;
                end
            end
            varargout{1} = movieLists;
			
		case 'LoadMovieSet'
			movieSets = varargin{1};
            for iMovieSets = 1:size(movieSets,1)
                movieListName = movieSets{iMovieSets};
                movieSetName = deblank(movieSets{iMovieSets});
                movieSetDir = dir([DirectoryPath,'\',movieSetName]);
                filetype = {};
                for iDirSize = 1:size(movieSetDir,1)
                    [~,~,filetype{iDirSize}] = fileparts(movieSetDir(iDirSize).name);
                end
                
                moviesIDX = strcmpi('.avi' ,filetype) | strcmpi('.mp4' ,filetype ) | strcmpi('.mov' ,filetype) ;
                
                movieFileNames = movieSetDir(moviesIDX);
                
                for iMovie = 1:size(movieFileNames,1)
                    movieFileName = [DirectoryPath,'\',movieListName,'\',movieFileNames(iMovie).name];
					%[acMovieHandles{iMovie, 1}, acMovieHandles{iMovie, 2}] = fnReadVideoFileToMemory(movieFileName)
					[acMovieHandles{iMovie}, videoData{iMovie}, bIsMovie(iMovie)] = fnReadVideoFileToMemory(movieFileName);
                    movieFilePaths{iMovie} = movieFileName;
                end
                
            end
			varargout{1} = acMovieHandles;
			varargout{2} = videoData;
			varargout{3} = bIsMovie;
            if nargout == 4
                varargout{4} = movieFilePaths;
            end
        case 'GetMovieFilePaths'
            movieSets = varargin{1};
            for iMovieSets = 1:size(movieSets,1)
                movieListName = movieSets{iMovieSets};
                movieSetName = deblank(movieSets{iMovieSets});
                movieSetDir = dir([DirectoryPath,'\',movieSetName]);
                filetype = {};
                for iDirSize = 1:size(movieSetDir,1)
                    [~,~,filetype{iDirSize}] = fileparts(movieSetDir(iDirSize).name);
                end
                
                moviesIDX = strcmpi('.avi' ,filetype) | strcmpi('.mp4' ,filetype ) | strcmpi('.mov' ,filetype) ;
                
                movieFileNames = movieSetDir(moviesIDX);
                
                for iMovie = 1:size(movieFileNames,1)
                    movieFileName = [DirectoryPath,'\',movieListName,'\',movieFileNames(iMovie).name];
                    movieFilePaths{iMovie} = movieFileName;
                end
                
            end
			varargout{1} = movieFilePaths;
			
    end
end
return;



function [hMovieHandle, videoData, bIsMovie] = fnReadVideoFileToMemory(fileName)
global g_strctPTB
%{
videoData.iWidth = vid.Width;
videoData.iHeight = vid.Height;
videoData.fFrameRate = vid.FrameRate;


%}
[ hMovieHandle videoData.fDuration videoData.fFPS videoData.iWidth videoData.iHeight videoData.iCount videoData.fAspectRatio] = Screen('OpenMovie', g_strctPTB.m_hWindow,fileName );
if ~g_strctPTB.m_bRunningOnStimulusServer
    videoData.aiApproxNumFrames = round(videoData.fDuration / (g_strctPTB.g_strctStimulusServer.m_RefreshRateMS));
end
%astrctFrameInfo.fFrameRate = vid.FrameRate;
bIsMovie = true;


%while hasFrame(vid)
	%tmp = readFrame(vid);
	%movieHandles(iFrames) = Screen('MakeTexture',g_strctPTB.m_hWindow,tmp);
%	iFrames = iFrames + 1;
%end
return;