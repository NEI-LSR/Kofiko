function fnInitializeStimulusSpace()
global g_strctParadigm

% Generates 19-stimulus triangular tesselation in CIELUV 

g_strctParadigm.m_StartingHue = fnTsGetVar('g_strctParadigm','StartingHue');

g_strctParadigm.m_aPolarCoordinatesarAngs = mod(linspace(g_strctParadigm.m_StartingHue,g_strctParadigm.m_StartingHue+360-(360/6),6), 360); %Compute 6 exterior points
[a,b] = g_strctParadigm.m_aPolarCoordinates2cart(deg2rad(g_strctParadigm.m_aPolarCoordinatesarAngs),ones(1,6)*maxSat); %Convert g_strctParadigm.m_aPolarCoordinatesar co-ordinates to cartesian co-ordinates
g_strctParadigm.m_aCartesianCoordinates = [a;b];
for i = 1:6
    inbetween = [g_strctParadigm.m_aCartesianCoordinates(1,i)/2;g_strctParadigm.m_aCartesianCoordinates(2,i)/2];
    g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,inbetween];
end
for i = 1:5
    inbetween = [(g_strctParadigm.m_aCartesianCoordinates(1,i)+g_strctParadigm.m_aCartesianCoordinates(1,i+1))/2;(g_strctParadigm.m_aCartesianCoordinates(2,i)+g_strctParadigm.m_aCartesianCoordinates(2,i+1))/2];
    g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,inbetween];
end
inbetween = [(g_strctParadigm.m_aCartesianCoordinates(1,6)+g_strctParadigm.m_aCartesianCoordinates(1,1))/2;(g_strctParadigm.m_aCartesianCoordinates(2,6)+g_strctParadigm.m_aCartesianCoordinates(2,1))/2];
g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,inbetween];
g_strctParadigm.m_aCartesianCoordinates = [g_strctParadigm.m_aCartesianCoordinates,[0;0]]; %add origin
g_strctParadigm.m_aCartesianCoordinates = g_strctParadigm.m_aCartesianCoordinates(:,[1,13,2,14,3,15,4,16,5,17,6,18,7,8,9,10,11,12,19]); 

[g_strctParadigm.m_aPolarCoordinates(1,:),g_strctParadigm.m_aPolarCoordinates(2,:)] = cart2g_strctParadigm.m_aPolarCoordinates(g_strctParadigm.m_aCartesianCoordinates(1,:),g_strctParadigm.m_aCartesianCoordinates(2,:));
g_strctParadigm.m_aPolarCoordinates(1,:) = round(rad2deg(g_strctParadigm.m_aPolarCoordinates(1,:)));
g_strctParadigm.m_aPolarCoordinates(1,g_strctParadigm.m_aPolarCoordinates(1,:)<0) = 360+g_strctParadigm.m_aPolarCoordinates(1,g_strctParadigm.m_aPolarCoordinates(1,:)<0); % the rad2deg remapping puts 190deg as -170deg (for example) - I want everything positive from 0 -> 360.


g_strctParadigm.m_aAllStimulusHues = g_strctParadigm.m_aPolarCoordinates(1,:); 
g_strctParadigm.m_aAllStimulusSats = g_strctParadigm.m_aPolarCoordinates(2,:);

end

