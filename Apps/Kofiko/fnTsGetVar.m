function varargout = fnTsGetVar(tstrct, varargin)
%tic
if iscell(tstrct)
% only works for g_strctParadigm at the moment. 
	substructVariable = true;
	substruct = tstrct{2};
	tstrct = tstrct{1};
else
    substructVariable = false;
end

for i = 1:numel(varargin)
	strVarName = varargin{i};
	if ischar(tstrct)
		structName = tstrct;
	else
		structName = inputname(1);
	end
	switch structName
		case 'g_strctParadigm'
		global g_strctParadigm
			if substructVariable
				if ischar(g_strctParadigm.(substruct).(strVarName).Buffer) || iscell(g_strctParadigm.(substruct).(strVarName).Buffer)
				   varargout{i} = g_strctParadigm.(substruct).(strVarName).Buffer{g_strctParadigm.(substruct).(strVarName).BufferIdx};
				else
					if length(size(g_strctParadigm.(substruct).(strVarName).Buffer)) == 3
						varargout{i} =  g_strctParadigm.(substruct).(strVarName).Buffer(:,:,g_strctParadigm.(substruct).(strVarName).BufferIdx);
					end
				end
			else
				if ischar(g_strctParadigm.(strVarName).Buffer) || iscell(g_strctParadigm.(strVarName).Buffer)
				   varargout{i} = g_strctParadigm.(strVarName).Buffer{g_strctParadigm.(strVarName).BufferIdx};
				else
					if length(size(g_strctParadigm.(strVarName).Buffer)) == 3
						varargout{i} =  g_strctParadigm.(strVarName).Buffer(:,:,g_strctParadigm.(strVarName).BufferIdx);
					end
				end
			end
		case 'g_strctEyeCalib'
		global g_strctEyeCalib
			if ischar(g_strctEyeCalib.(strVarName).Buffer) || iscell(g_strctEyeCalib.(strVarName).Buffer)
			   varargout{i} = g_strctEyeCalib.(strVarName).Buffer{g_strctEyeCalib.(strVarName).BufferIdx};
			else
				if length(size(g_strctEyeCalib.(strVarName).Buffer)) == 3
					varargout{i} =  g_strctEyeCalib.(strVarName).Buffer(:,:,g_strctEyeCalib.(strVarName).BufferIdx);
				end
			end
		case 'g_strctDAQParams'
		global g_strctDAQParams
			if ischar(g_strctDAQParams.(strVarName).Buffer) || iscell(g_strctDAQParams.(strVarName).Buffer)
			   varargout{i} = g_strctDAQParams.(strVarName).Buffer{g_strctDAQParams.(strVarName).BufferIdx};
			else
				if length(size(g_strctDAQParams.(strVarName).Buffer)) == 3
					varargout{i} =  g_strctDAQParams.(strVarName).Buffer(:,:,g_strctDAQParams.(strVarName).BufferIdx);
				end
			end
		otherwise 
			if ischar(tstrct.(strVarName).Buffer) || iscell(tstrct.(strVarName).Buffer)
			   varargout{i} = tstrct.(strVarName).Buffer{tstrct.(strVarName).BufferIdx};
			else
				if length(size(tstrct.(strVarName).Buffer)) == 3
					varargout{i} =  tstrct.(strVarName).Buffer(:,:,tstrct.(strVarName).BufferIdx);
				end
			end
	end	
%disp(sprintf('get struct %s takes %f',structName,toc))
end
return;
