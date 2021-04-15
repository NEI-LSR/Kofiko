
g_strctAppConfig.m_strctDirectories.m_strPTB_Folder = 'C:\toolboxes\psychtoolbox\';

addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychBasic']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychBasic\MatlabWindowsFilesR2007a']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychOneliners']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychRects']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychTests']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychPriority']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychAlphaBlending']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychOpenGL\MOGL\core']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychOpenGL\MOGL\wrap']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychGLImageProcessing']);
addpath([g_strctAppConfig.m_strctDirectories.m_strPTB_Folder,'PsychOpenGL']);

%usage: [windowPtr,rect]=Screen('OpenWindow',windowPtrOrScreenNumber [,color]
%[,rect][,pixelSize][,numberOfBuffers][,stereomode][,multisample][,imagingmode][,specialFlags][,clientRect]);
[hPTBWindow, aiScreenRect] = Screen('OpenWindow',0,[],[0 0 641 353]);
%disp(Screen)
%class(Screen)
strMovie = 'c:\users\josh\documents\kofiko\data\test.avi';

[hMovie,fDuration,fFramesPerSeconds,iWidth,iHeight]=Screen('OpenMovie', hPTBWindow, strMovie);



Screen('PlayMovie', hMovie, 1,0,1);
Screen('SetMovieTimeIndex',hMovie,0);

while 1
    [hFrameTexture, fTimeToFlip] = Screen('GetMovieImage', hPTBWindow, hMovie,1);
    if hFrameTexture < 0
        break;
    end
    Screen('DrawTexture', hPTBWindow, hFrameTexture);
   fCueOnsetTS = Screen('Flip',hPTBWindow); % This would block the server until the next flip.
   Screen('Close', hFrameTexture);
end

     