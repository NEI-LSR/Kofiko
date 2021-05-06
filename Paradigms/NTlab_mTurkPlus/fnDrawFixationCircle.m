function fnDrawFixationCircle(hWindow, strctFixationSpot, bClear, fScale)
global g_strctPTB


if bClear
    Screen('FillRect', hWindow, strctFixationSpot.m_afBackgroundColor,g_strctPTB.m_aiScreenRect);
end

switch lower(strctFixationSpot.m_strFixationSpotType)
    case 'circle';
        aiFixationSpot = [...
            strctFixationSpot.m_pt2fFixationPosition(1) - strctFixationSpot.m_fFixationSpotSize,...
            strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize,...
            strctFixationSpot.m_pt2fFixationPosition(1) + strctFixationSpot.m_fFixationSpotSize,...
            strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
        if g_strctPTB.m_bRunningOnStimulusServer
			Screen(hWindow,'FrameArc',strctFixationSpot.m_afFixationColor, fScale*aiFixationSpot,0,360);
		else
			Screen(hWindow,'FrameArc',strctFixationSpot.m_afLocalFixationColor, fScale*aiFixationSpot,0,360);
		end
    case 'disc';
        aiFixationSpot = [...
            strctFixationSpot.m_pt2fFixationPosition(1) - strctFixationSpot.m_fFixationSpotSize,...
            strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize,...
            strctFixationSpot.m_pt2fFixationPosition(1) + strctFixationSpot.m_fFixationSpotSize,...
            strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
        if g_strctPTB.m_bRunningOnStimulusServer
			Screen(hWindow,'FillArc',strctFixationSpot.m_afFixationColor, fScale*aiFixationSpot,0,360);
		else
			Screen(hWindow,'FillArc',strctFixationSpot.m_afLocalFixationColor, fScale*aiFixationSpot,0,360);
		end
			
			
    case 'triangle'
        %: each row specifies the (x,y) coordinates of a vertex.
    aiPointList = [strctFixationSpot.m_pt2fFixationPosition(1),strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
                            strctFixationSpot.m_pt2fFixationPosition(1)- strctFixationSpot.m_fFixationSpotSize,strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize
                            strctFixationSpot.m_pt2fFixationPosition(1)+ strctFixationSpot.m_fFixationSpotSize,strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
       
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillPoly',hWindow,strctFixationSpot.m_afFixationColor, fScale*aiPointList, 1); % convex
        else
			Screen('FillPoly',hWindow,strctFixationSpot.m_afLocalFixationColor, fScale*aiPointList, 1); % convex
		end
    case 'x'
        fWidth = 0.7;
        %: each row specifies the (x,y) coordinates of a vertex.
		aiPointList = [strctFixationSpot.m_pt2fFixationPosition(1)- strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
		
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillPoly',hWindow,strctFixationSpot.m_afFixationColor, fScale*aiPointList, 1); % convex
		else
			Screen('FillPoly',hWindow,strctFixationSpot.m_afLocalFixationColor, fScale*aiPointList, 1); % convex
		end
		
		aiPointList2 = [strctFixationSpot.m_pt2fFixationPosition(1)+fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillPoly',hWindow,strctFixationSpot.m_afFixationColor, fScale*aiPointList2, 1); % convex
		else
			Screen('FillPoly',hWindow,strctFixationSpot.m_afLocalFixationColor, fScale*aiPointList2, 1); % convex
		end
	case 'x.'
        fWidth = .7;
        %: each row specifies the (x,y) coordinates of a vertex.
		aiPointList = [strctFixationSpot.m_pt2fFixationPosition(1)- strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
		
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillPoly',hWindow,strctFixationSpot.m_afFixationColor, fScale*aiPointList, 1); % convex
		else
			Screen('FillPoly',hWindow,strctFixationSpot.m_afLocalFixationColor, fScale*aiPointList, 1); % convex
		end
		
		aiPointList2 = [strctFixationSpot.m_pt2fFixationPosition(1)+fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- fWidth*strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) + strctFixationSpot.m_fFixationSpotSize];
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillPoly',hWindow,strctFixationSpot.m_afFixationColor, fScale*aiPointList2, 1); % convex
		else
			Screen('FillPoly',hWindow,strctFixationSpot.m_afLocalFixationColor, fScale*aiPointList2, 1); % convex
		end
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillArc',hWindow,[0,0,0], [strctFixationSpot.m_pt2fFixationPosition(1)-2,strctFixationSpot.m_pt2fFixationPosition(2)-2,strctFixationSpot.m_pt2fFixationPosition(1)+2,strctFixationSpot.m_pt2fFixationPosition(2)+2] ,0,360); % convex
		else
			Screen('FillArc',hWindow,[0,0,0], [strctFixationSpot.m_pt2fFixationPosition(1)-2,strctFixationSpot.m_pt2fFixationPosition(2)-2,strctFixationSpot.m_pt2fFixationPosition(1)+2,strctFixationSpot.m_pt2fFixationPosition(2)+2] ,0,360); % convex
		end
    case 'diamond'
		aiPointList = [strctFixationSpot.m_pt2fFixationPosition(1), strctFixationSpot.m_pt2fFixationPosition(2) - strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)+ strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) ;
								strctFixationSpot.m_pt2fFixationPosition(1), strctFixationSpot.m_pt2fFixationPosition(2)+strctFixationSpot.m_fFixationSpotSize;
								strctFixationSpot.m_pt2fFixationPosition(1)- strctFixationSpot.m_fFixationSpotSize, strctFixationSpot.m_pt2fFixationPosition(2) ];
	   
		if g_strctPTB.m_bRunningOnStimulusServer
			Screen('FillPoly',hWindow,strctFixationSpot.m_afFixationColor, fScale*aiPointList, 1); % convex
		else
			Screen('FillPoly',hWindow,strctFixationSpot.m_afLocalFixationColor, fScale*aiPointList, 1); % convex
		end
    otherwise
        fprintf('Unknown fixation type!\n');
end
return;