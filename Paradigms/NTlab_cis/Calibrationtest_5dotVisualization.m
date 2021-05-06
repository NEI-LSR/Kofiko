%%
%load([ExperimentFolder, filenameP, '.mat'], 'g_strctEyeCalib');
%load([ExperimentFolder, filenameP, '.mat'], 'g_strctStimulusServer');
load('/Users/felixbartsch/Downloads/190621_165907_Debug.mat')

%%
N_Gainsettings=length(g_strctEyeCalib.CenterX.TimeStamp);
fixpts=[];
fixpts(1,:)=[960,540]; %always in the center of the screen

%%
thisExptEyeRaw=g_strctEyeCalib.EyeRaw.Buffer;
thisExptEyeTimes=g_strctEyeCalib.EyeRaw.TimeStamp;
N_recalibs=g_strctEyeCalib.CenterX.TimeStamp;


for iSetting = 61:N_recalibs;
    % append eye trace information to this trial
    ThisSettingStartT = g_strctEyeCalib.CenterX.TimeStamp(iSetting);
    if iSetting<N_recalibs
        ThisSettingEndT = g_strctEyeCalib.CenterX.TimeStamp(iSetting+1);
    else
        ThisSettingEndT = g_strctEyeCalib.EyeRaw.TimeStamp(end);
    end
        curXGainID= find(ThisSettingStartT < g_strctEyeCalib.GainX.TimeStamp,1,'first');
        curYGainID= find(ThisSettingStartT < g_strctEyeCalib.GainY.TimeStamp,1,'first');
        if isempty(curXGainID); curXGainID=length(g_strctEyeCalib.CenterX.TimeStamp);        end
        if isempty(curYGainID); curYGainID=length(g_strctEyeCalib.CenterY.TimeStamp);        end

        thisTrialEyeBufferIDX = find(g_strctEyeCalib.EyeRaw.TimeStamp > ThisSettingStartT & ...
            g_strctEyeCalib.EyeRaw.TimeStamp < ThisSettingEndT );

        thisTrialRawEyeData = g_strctEyeCalib.EyeRaw.Buffer(thisTrialEyeBufferIDX,:);
        thisTrialRawEyeDatatimes = g_strctEyeCalib.EyeRaw.TimeStamp(1,thisTrialEyeBufferIDX);

        fEyeXPix = (thisTrialRawEyeData(:, 1) - g_strctEyeCalib.CenterX.Buffer(iSetting)) * g_strctEyeCalib.GainX.Buffer(curXGainID) + (g_strctStimulusServer.m_aiScreenSize(3)/2);
        fEyeYPix = (thisTrialRawEyeData(:, 2) - g_strctEyeCalib.CenterY.Buffer(iSetting)) * g_strctEyeCalib.GainY.Buffer(curYGainID) + (g_strctStimulusServer.m_aiScreenSize(4)/2);

        figure(1);
        scatter(fEyeXPix,fEyeYPix);
        xlabel('X Position (pixels)'); ylabel('Y Position (pixels)')
%        ylim([400 680]); xlim([600 1200])
        title(['GainX: ' num2str(g_strctEyeCalib.GainX.Buffer(curXGainID)) '  GainY :' num2str(g_strctEyeCalib.GainY.Buffer(curYGainID))])
        pause
%     plot(ExperimentRecording{iFixationCheck,1}.m_afEyeXPositionScreenCoordinates); hold on
%     plot(ExperimentRecording{iFixationCheck,1}.m_afEyeYPositionScreenCoordinates); hold off
% 
%     figure(3);
%     plot(ExperimentRecording{iFixationCheck,5}')
%     pause
end