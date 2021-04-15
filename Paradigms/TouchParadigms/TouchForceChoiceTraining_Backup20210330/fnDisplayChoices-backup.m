function fChoicesOnsetTS = fnDisplayChoices(hPTBWindow, aiChoices, strctCurrentTrial, acMedia,bFlip,bClear,bHighlightRewardedChoices,fScale, bDrawResponseRegion)
global  g_strctPTB
% Clear screen

if strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
	fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, aiChoices, strctCurrentTrial, acMedia,bFlip,...
									bClear,bHighlightRewardedChoices,fScale, bDrawResponseRegion);
	return;
end	
    Screen('FillRect',hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor);

choice_location_holder = zeros(4, numel(aiChoices));

[choice_color_holder] = zeros(3, numel(aiChoices));
[choice_Clut_holder] = zeros(numel(aiChoices), 3);

for iChoiceIter = aiChoices
    if strctCurrentTrial.m_bLoadOnTheFly
        iLocalMediaIndex = 1+iChoiceIter;
    else
        iLocalMediaIndex = strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_iMediaIndex;
    end
    
    aiTextureSize = [ acMedia{iLocalMediaIndex}.m_iWidth, acMedia{iLocalMediaIndex}.m_iHeight];
    
    aiStimulusRect = fnComputeStimulusRect(strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_fSizePix,aiTextureSize, ...
        strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition);
		
    choice_location_holder(:,iChoiceIter) = fScale*aiStimulusRect;
    choice_color_holder(:,iChoiceIter) = deal(iChoiceIter + 1);
    choice_Clut_holder(iChoiceIter,:) = acMedia{iLocalMediaIndex}.Clut(3,:);

	
    if bHighlightRewardedChoices
        if strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_bJuiceReward
            Screen('FrameRect', hPTBWindow, [0 255 0],fScale*aiStimulusRect,3);
        end
        if bDrawResponseRegion
            aiResponseRect = [strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition(:)'-ones(1,2)*strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize,...
                                             strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition(:)'+ones(1,2)*strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize];
            switch lower(strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType)
                case 'rect'
                              Screen('FrameRect', hPTBWindow, [255 255 255],fScale*aiResponseRect);
                case 'circular'
                              Screen('FrameArc', hPTBWindow, [255 255 255],fScale*aiResponseRect,0,360);
                    
            end
        end
        
        
    end
    
end
Clut(3:numel(aiChoices)+2,:) = cat(1,choice_Clut_holder(1:numel(aiChoices),:));

if g_strctPTB.m_bRunningOnStimulusServer
	BitsPlusSetClut(hPTBWindow, Clut)
	Screen('FillOval', hPTBWindow, choice_color_holder, choice_location_holder);
else
	Screen('FillRect', hPTBWindow, strctCurrentTrial.m_strctPreCuePeriod.m_afLocalBackgroundColor,...
					[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_aiStimServerScreen(3),...
					g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_aiStimServerScreen(4)]);
	%Screen('FillRect',hPTBWindow, [128 128 128]);
	Screen('FillOval', hPTBWindow, round(choice_Clut_holder'/255), choice_location_holder);
	%Screen('FillOval', hPTBWindow, round(choice_Clut_holder'/255), choice_location_holder);
	
end

if  strctCurrentTrial.m_strctChoicePeriod.m_bShowFixationSpot
      fnDrawFixationSpot(hPTBWindow, strctCurrentTrial.m_strctChoicePeriod, false, fScale);
end


if bFlip
    fChoicesOnsetTS =fnFlipWrapper(hPTBWindow); % This would block the server until the next flip.
    if ~g_strctPTB.m_bRunningOnStimulusServer
        fChoicesOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
    end
else
    fChoicesOnsetTS =  NaN;
end

return;





function fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, aiChoices, strctCurrentTrial, acMedia,bFlip,bClear,bHighlightRewardedChoices,fScale, bDrawResponseRegion)
global  g_strctPTB
if bClear && g_strctPTB.m_bRunningOnStimulusServer
	Screen('FillRect',hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor);
elseif bClear && ~g_strctPTB.m_bRunningOnStimulusServer
	Screen('FillRect',hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor,...
				[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_aiStimServerScreen(3),...
				g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_aiStimServerScreen(4)]);

end
aiResponseRect = zeros(4,numel(aiChoices));

aiTextureSize(1:2) = deal(strctCurrentTrial.m_astrctChoicesMedia(1).m_fSizePix /2);
for iChoiceIter = aiChoices
	aiStimulusRect = fnComputeStimulusRect(strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_fSizePix,aiTextureSize, ...
        strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition);
	if bHighlightRewardedChoices
		if strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_bJuiceReward
			Screen('FrameRect', hPTBWindow, [0 255 0],fScale*aiStimulusRect,3);
		end
		
		if bDrawResponseRegion
			aiResponseRect(:,iChoiceIter) = [strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition(:)'-ones(1,2)*strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize,...
											 strctCurrentTrial.m_astrctChoicesMedia(iChoiceIter).m_pt2fPosition(:)'+ones(1,2)*strctCurrentTrial.m_strctChoicePeriod.m_fInsideChoiceRegionSize];
			switch lower(strctCurrentTrial.m_strctChoicePeriod.m_strInsideChoiceRegionType)
				case 'rect'
							  Screen('FrameRect', hPTBWindow, [255 255 255],fScale*aiResponseRect(:,iChoiceIter));
				case 'circular'
							  Screen('FrameArc', hPTBWindow, [255 255 255],fScale*aiResponseRect(:,iChoiceIter),0,360);
			end
		end
	end
end
colors = [];
for iChoices = 1:strctCurrentTrial.m_strctChoicePeriod.m_iNumChoices
	colors = [colors, strctCurrentTrial.m_astrctChoicesMedia(iChoices).m_iClutIndex'];
end

if g_strctPTB.m_bRunningOnStimulusServer
	BitsPlusSetClut(hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.Clut);
	Screen('FillOval', hPTBWindow, colors , strctCurrentTrial.m_strctChoicePeriod.m_afPositions);
else
	Screen('FillOval', hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.LocalColors, strctCurrentTrial.m_strctChoicePeriod.m_afPositions);
end

if  strctCurrentTrial.m_strctChoicePeriod.m_bShowFixationSpot
      fnDrawFixationSpot(hPTBWindow, strctCurrentTrial.m_strctChoicePeriod, false, fScale);
end


if bFlip
    fChoicesOnsetTS =fnFlipWrapper(hPTBWindow); % This would block the server until the next flip.
    if ~g_strctPTB.m_bRunningOnStimulusServer
        fChoicesOnsetTS =  GetSecs(); % Don't trust TS obtained from flip on touch mode
    end
else
    fChoicesOnsetTS =  NaN;
end

return;