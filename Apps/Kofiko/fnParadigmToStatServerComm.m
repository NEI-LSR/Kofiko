function varargout = fnParadigmToStatServerComm(strCommand, varargin)
global g_strctRealTimeStatServer g_strctAcquisitionServer
 
 %holds code for sending paradigm data to stat server
switch lower(strCommand) 
%{
    case 'send'
       if g_strctRealTimeStatServer.m_bConnected
			%sends argument passed to function to the stat server
            strStringToSend = varargin{1};
            fndllZeroMQ_Wrapper('Send',g_strctRealTimeStatServer.m_iSocket,strStringToSend);
       end 
	   %}
	   
	   
	   case 'send'
       if g_strctAcquisitionServer.m_bConnected
			%sends argument passed to function to the stat server
            strStringToSend = varargin{1};
            fndllZeroMQ_Wrapper('Send',g_strctAcquisitionServer.m_iSocket,strStringToSend);
       end 
	   
	   
	case 'WaitOnTrialInfo'
       if g_strctAcquisitionServer.m_bConnected
			
            strStringToSend = varargin{1};
            fndllZeroMQ_Wrapper('Send',g_strctAcquisitionServer.m_iSocket,strStringToSend);
       end 
	   
    case 'isconnected'
        varargout{1} = g_strctRealTimeStatServer.m_bConnected || g_strctAcquisitionServer.m_bConnected;
    case 'cleardesign'
        if g_strctRealTimeStatServer.m_bConnected
           mssend(g_strctRealTimeStatServer.m_iSocket, {'ClearDesign'});
        end
      if g_strctAcquisitionServer.m_bConnected
            fndllZeroMQ_Wrapper('Send',g_strctAcquisitionServer.m_iSocket,'ClearDesign');
       end       
    case 'closeconnection'
        mssend(g_strctRealTimeStatServer.m_iSocket, {'CloseConnection'});
    case 'senddesign'
        strctDesign = varargin{1};
        if g_strctRealTimeStatServer.m_bConnected
            mssend(g_strctRealTimeStatServer.m_iSocket, {'Design',strctDesign});
        end
      if g_strctAcquisitionServer.m_bConnected
          fndllZeroMQ_Wrapper('Send',g_strctAcquisitionServer.m_iSocket,'ClearDesign');
          
          if ~isempty(strctDesign.TrialTypeToConditionMatrix)
              iNumConditions = length(strctDesign.ConditionNames);
              for Iter=1:iNumConditions
                  strCondName = strctDesign.ConditionNames{Iter};
                  strCondName(strCondName==' ') = '_';
                  % prepare a stringto send
                  aiTrialTypes = find(strctDesign.TrialTypeToConditionMatrix(:,Iter));
                  strNewCondition = ['AddCondition Name ',strCondName,' Visible ',...
                      num2str(strctDesign.ConditionVisibility(Iter)),' TrialTypes ',num2str(aiTrialTypes(:)')];
                  fndllZeroMQ_Wrapper('Send',g_strctAcquisitionServer.m_iSocket,strNewCondition);
              end
               % strctDesign.ConditionOutcomeFilter
             fndllZeroMQ_Wrapper('Send',g_strctAcquisitionServer.m_iSocket,['NewDesign ',strctDesign.DesignName]);
          end
       end       
        
    case 'pong'
        if g_strctRealTimeStatServer.m_bConnected
            fPingTimeStatServer = varargin{1};
            fPongTimeLocal = GetSecs();
            mssend(g_strctRealTimeStatServer.m_iSocket, {'Pong',fPingTimeStatServer,fPongTimeLocal});
        end        
end


return;

