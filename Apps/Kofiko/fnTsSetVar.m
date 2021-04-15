function [varargout] = fnTsSetVar(tstrct, strVarName, Value)
 %tic
global g_strctParadigm g_strctDAQParams ExperimentDesigns g_strctEyeCalib g_strctAppConfig

if ischar(tstrct)
	nameOfStruct = tstrct;
	
else
	nameOfStruct = inputname(1);
end
fCurrTime = GetSecs();
switch nameOfStruct
	case 'g_strctParadigm'
		sz = max(size(g_strctParadigm.(strVarName).Buffer));
		if iscell(g_strctParadigm.(strVarName).Buffer)

			if g_strctParadigm.(strVarName).BufferIdx+1 > sz(end)
				g_strctParadigm.(strVarName).Buffer{sz*2} = [];
				g_strctParadigm.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctParadigm.(strVarName).BufferIdx = g_strctParadigm.(strVarName).BufferIdx + 1;
			g_strctParadigm.(strVarName).Buffer{g_strctParadigm.(strVarName).BufferIdx} = Value;
			g_strctParadigm.(strVarName).TimeStamp(g_strctParadigm.(strVarName).BufferIdx) = fCurrTime;
		else
			if g_strctParadigm.(strVarName).BufferIdx+1 > sz(end)
				g_strctParadigm.(strVarName).Buffer(:,:,sz*2) = 0;
				g_strctParadigm.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctParadigm.(strVarName).BufferIdx = g_strctParadigm.(strVarName).BufferIdx + 1;
			g_strctParadigm.(strVarName).Buffer(:,:,g_strctParadigm.(strVarName).BufferIdx) = Value;
			g_strctParadigm.(strVarName).TimeStamp(g_strctParadigm.(strVarName).BufferIdx) = fCurrTime;
		end
	if nargout
		varargout{1} = g_strctParadigm;
	end
	case 'g_strctDAQParams'
		sz = max(size(g_strctDAQParams.(strVarName).Buffer));
		if iscell(g_strctDAQParams.(strVarName).Buffer)

			if g_strctDAQParams.(strVarName).BufferIdx+1 > sz(end)
				g_strctDAQParams.(strVarName).Buffer{sz*2} = [];
				g_strctDAQParams.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctDAQParams.(strVarName).BufferIdx = g_strctDAQParams.(strVarName).BufferIdx + 1;
			g_strctDAQParams.(strVarName).Buffer{g_strctDAQParams.(strVarName).BufferIdx} = Value;
			g_strctDAQParams.(strVarName).TimeStamp(g_strctDAQParams.(strVarName).BufferIdx) = fCurrTime;
		else
			if g_strctDAQParams.(strVarName).BufferIdx+1 > sz(end)
				g_strctDAQParams.(strVarName).Buffer(:,:,sz*2) = 0;
				g_strctDAQParams.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctDAQParams.(strVarName).BufferIdx = g_strctDAQParams.(strVarName).BufferIdx + 1;
			g_strctDAQParams.(strVarName).Buffer(:,:,g_strctDAQParams.(strVarName).BufferIdx) = Value;
			g_strctDAQParams.(strVarName).TimeStamp(g_strctDAQParams.(strVarName).BufferIdx) = fCurrTime;
		end
	if nargout
	
		varargout{1} = g_strctDAQParams;
	end
	case 'ExperimentDesigns'
		sz = max(size(ExperimentDesigns.(strVarName).Buffer));
		if iscell(ExperimentDesigns.(strVarName).Buffer)

			if ExperimentDesigns.(strVarName).BufferIdx+1 > sz(end)
				ExperimentDesigns.(strVarName).Buffer{sz*2} = [];
				ExperimentDesigns.(strVarName).TimeStamp(sz*2) = 0;
			end
			ExperimentDesigns.(strVarName).BufferIdx = ExperimentDesigns.(strVarName).BufferIdx + 1;
			ExperimentDesigns.(strVarName).Buffer{ExperimentDesigns.(strVarName).BufferIdx} = Value;
			ExperimentDesigns.(strVarName).TimeStamp(ExperimentDesigns.(strVarName).BufferIdx) = fCurrTime;
		else
			if ExperimentDesigns.(strVarName).BufferIdx+1 > sz(end)
				ExperimentDesigns.(strVarName).Buffer(:,:,sz*2) = 0;
				ExperimentDesigns.(strVarName).TimeStamp(sz*2) = 0;
			end
			ExperimentDesigns.(strVarName).BufferIdx = ExperimentDesigns.(strVarName).BufferIdx + 1;
			ExperimentDesigns.(strVarName).Buffer(:,:,ExperimentDesigns.(strVarName).BufferIdx) = Value;
			ExperimentDesigns.(strVarName).TimeStamp(ExperimentDesigns.(strVarName).BufferIdx) = fCurrTime;
		end
		if nargout
			varargout{1} = ExperimentDesigns;
		end
	case 'g_strctEyeCalib'
		sz = max(size(g_strctEyeCalib.(strVarName).Buffer));
		if iscell(g_strctEyeCalib.(strVarName).Buffer)

			if g_strctEyeCalib.(strVarName).BufferIdx+1 > sz(end)
				g_strctEyeCalib.(strVarName).Buffer{sz*2} = [];
				g_strctEyeCalib.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctEyeCalib.(strVarName).BufferIdx = g_strctEyeCalib.(strVarName).BufferIdx + 1;
			g_strctEyeCalib.(strVarName).Buffer{g_strctEyeCalib.(strVarName).BufferIdx} = Value;
			g_strctEyeCalib.(strVarName).TimeStamp(g_strctEyeCalib.(strVarName).BufferIdx) = fCurrTime;
		else
			if g_strctEyeCalib.(strVarName).BufferIdx+1 > sz(end)
				g_strctEyeCalib.(strVarName).Buffer(:,:,sz*2) = 0;
				g_strctEyeCalib.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctEyeCalib.(strVarName).BufferIdx = g_strctEyeCalib.(strVarName).BufferIdx + 1;
			g_strctEyeCalib.(strVarName).Buffer(:,:,g_strctEyeCalib.(strVarName).BufferIdx) = Value;
			g_strctEyeCalib.(strVarName).TimeStamp(g_strctEyeCalib.(strVarName).BufferIdx) = fCurrTime;
		end
		if nargout
			varargout{1} = g_strctEyeCalib;
		end
		
	case 'g_strctAppConfig'
		sz = max(size(g_strctAppConfig.(strVarName).Buffer));
		if iscell(g_strctAppConfig.(strVarName).Buffer)

			if g_strctAppConfig.(strVarName).BufferIdx+1 > sz(end)
				g_strctAppConfig.(strVarName).Buffer{sz*2} = [];
				g_strctAppConfig.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctAppConfig.(strVarName).BufferIdx = g_strctAppConfig.(strVarName).BufferIdx + 1;
			g_strctAppConfig.(strVarName).Buffer{g_strctAppConfig.(strVarName).BufferIdx} = Value;
			g_strctAppConfig.(strVarName).TimeStamp(g_strctAppConfig.(strVarName).BufferIdx) = fCurrTime;
		else
			if g_strctAppConfig.(strVarName).BufferIdx+1 > sz(end)
				g_strctAppConfig.(strVarName).Buffer(:,:,sz*2) = 0;
				g_strctAppConfig.(strVarName).TimeStamp(sz*2) = 0;
			end
			g_strctAppConfig.(strVarName).BufferIdx = g_strctAppConfig.(strVarName).BufferIdx + 1;
			g_strctAppConfig.(strVarName).Buffer(:,:,g_strctAppConfig.(strVarName).BufferIdx) = Value;
			g_strctAppConfig.(strVarName).TimeStamp(g_strctAppConfig.(strVarName).BufferIdx) = fCurrTime;
		end
		if nargout
			varargout{1} = g_strctAppConfig;
		end
		
	otherwise
		 sz = max(size(tstrct.(strVarName).Buffer));
		if iscell(tstrct.(strVarName).Buffer)

			if tstrct.(strVarName).BufferIdx+1 > sz(end)
				tstrct.(strVarName).Buffer{sz*2} = [];
				tstrct.(strVarName).TimeStamp(sz*2) = 0;
			end
			tstrct.(strVarName).BufferIdx = tstrct.(strVarName).BufferIdx + 1;
			tstrct.(strVarName).Buffer{tstrct.(strVarName).BufferIdx} = Value;
			tstrct.(strVarName).TimeStamp(tstrct.(strVarName).BufferIdx) = fCurrTime;
		else
			if tstrct.(strVarName).BufferIdx+1 > sz(end)
				tstrct.(strVarName).Buffer(:,:,sz*2) = 0;
				tstrct.(strVarName).TimeStamp(sz*2) = 0;
			end
			tstrct.(strVarName).BufferIdx = tstrct.(strVarName).BufferIdx + 1;
			tstrct.(strVarName).Buffer(:,:,tstrct.(strVarName).BufferIdx) = Value;
			tstrct.(strVarName).TimeStamp(tstrct.(strVarName).BufferIdx) = fCurrTime;
		end
		varargout{1} = tstrct;
end
%disp(sprintf('set struct %s takes %f',nameOfStruct,toc))
return;


