function TabOfMask = fnInitializeTexturesMask
global g_strctPTB
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
RotateVal  =  1;
NumOfRev   =  1;
fps                 = Screen('NominalFrameRate', g_strctPTB.m_hWindow); % Refresh rate of the screen
%fps                 = fnParadigmToKofikoComm('GetRefreshRate');
%fps                 = 60;
%WidthScreen = 600; HeightScreen = 400;
% Retrieve video redraw interval for later control of our animation timing:
ifi                 = 1/fps;
sec =  2;
ImSizeY = 768;
ImSizeX = 1024;

th    = linspace( pi/2,  NumOfRev * (2*pi) + pi/2, fps * sec);
RMov  = ImSizeY/3;
x     = RMov*RotateVal*cos(th);
y     = RMov*sin(th);
   
RMask = ImSizeY/12;  %or whatever radius you want

Tab = [];
Tab.Rect = [0 0 0 0];
Tab      = repmat(Tab,length(th),1);

for ii = 1 : length(th)
    xC =   ImSizeX/2 + x(ii);
    yC =   ImSizeY/2 + y(ii);   
    
    % Create my mask positions
    %[rr,cc]=meshgrid(-(yC-1):(ImSizeY-yC),-(xC-1):(ImSizeX-xC));
    %Tab(ii).InMask=repmat(double(((rr.^2+cc.^2)<=(RMask)^2)),1,1,3);
    Tab(ii).Rect  = [xC - RMask, yC - RMask, xC + RMask, yC + RMask];
    %Tab(ii).ImFrame = Im1.*double(~InMask) + Im2.*(InMask); 
%Tab(ii).Text=Screen('MakeTexture',number, Tab(ii).ImFrame);    
end

TabOfMask = Tab;

end

