function fnReadVideoFileToMemory
clear all
dbstop if error

%filename = 'C:\testfolder\dyloc\Battleship (2012) [1080p]\Battleship.2012.BluRay.1080p.x264.YIFY.mp4';
%v = VideoReader(filename);
filename = 'C:\testfolder\dyloc\00008_3.avi';
v = VideoReader(filename);
Screen('Preference', 'SkipSyncTests', 1)
vidWidth = v.Width;
vidHeight = v.Height;

[y, fs] = audioread(filename);
InitializePsychSound;

wavedata = y';
nrchannels = size(wavedata,1);
if nrchannels < 2
    wavedata = [wavedata ; wavedata];
    nrchannels = 2;
end
try
    % Try with the 'freq'uency we wanted:
    pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
catch
    % Failed. Retry with default frequency as suggested by device:
    fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
    fprintf('Sound may sound a bit out of tune, ...\n\n');

    psychlasterror('reset');
    pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
end
PsychPortAudio('FillBuffer', pahandle, wavedata);


lastSample = 0;
lastTime = t1;

%mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
winPtr = Screen('OpenWindow', 0, [], [0,0,vidWidth,vidHeight]);
k = 1;
while hasFrame(v)
%mov(k).cdata = readFrame(v);
tmp = readFrame(v);
movie(k) = Screen('MakeTexture',winPtr,tmp);
t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);

k = k+1;
end
frameRate = Screen('NominalFrameRate',winPtr);
Screen('DrawTexture',winPtr,movie(1));
tic
[~, ~, ~,~,~] = Screen('Flip',winPtr);
iFrames = 2;
iFlips = 1;
while iFrames < numel(movie)
    switch iFlips
        case 1
            Screen('DrawTexture',winPtr,movie(iFrames));    
            Screen('Flip',winPtr);
            iFlips = iFlips + 1;
        case 2
	%if (GetSecs() - flipTime) > ((1000 / frameRate)/1000) + .005
            iFlips = 1;
            iFrames = iFrames + 1;
            Screen('DrawTexture',winPtr,movie(iFrames));
            [~, ~, ~,~,~] = Screen('Flip',winPtr);
   % else
        
	end
	
end
toc




sca







return;