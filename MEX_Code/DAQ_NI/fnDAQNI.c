#include <stdio.h>
#include "mex.h"
#include <math.h>
#include "math.h"

#include <windows.h>
#include <mmsystem.h>
#include "nidaqmx.h"
#include <string.h>
#include <string>
#include <NIDAQmx>
using namespace std;

const int Pow2[15] = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192, 16384};
const int Pow2Rev[15] = {16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1};

int BoardNum=0;
const int EYE_X_PORT = 0; // hard wired for a faster implementation, but can always be acquired using GetAnalog command
const int EYE_Y_PORT = 1;
static TaskHandle digitalTasks[24] = {0};
static TaskHandle analogTasks[16] = {0};
string dolines[24] = {"Dev1/port0/line0", "Dev1/port0/line1", "Dev1/port0/line2", "Dev1/port0/line3", "Dev1/port0/line4", "Dev1/port0/line5", "Dev1/port0/line6", "Dev1/port0/line7", "Dev1/port1/line0", "Dev1/port1/line1", "Dev1/port1/line2", "Dev1/port1/line3", "Dev1/port1/line4", "Dev1/port1/line5", "Dev1/port1/line6", "Dev1/port1/line7", "Dev1/port2/line0", "Dev1/port2/line1", "Dev1/port2/line2", "Dev1/port2/line3", "Dev1/port2/line4", "Dev1/port2/line5", "Dev1/port2/line6", "Dev1/port2/line7"}; // string names that refer to each digital line
string anlines[16] = {"Dev1/ai0", "Dev1/ai1", "Dev1/ai2", "Dev1/ai3", "Dev1/ai4", "Dev1/ai5", "Dev1/ai6", "Dev1/ai7", "Dev1/ai8", "Dev1/ai9", "Dev1/ai10", "Dev1/ai11", "Dev1/ai12", "Dev1/ai13", "Dev1/ai14", "Dev1/ai15"}; // string names for each analog input

void fnSleep(double fWaitSecHighPerc) {

	LARGE_INTEGER prevTime;
	LARGE_INTEGER curTime;
	LARGE_INTEGER freqValue;
	double timeDifference;

	if (fWaitSecHighPerc <= 0)
		return;

	QueryPerformanceFrequency(&freqValue);
	QueryPerformanceCounter(&prevTime);

	while (1)
	{
		QueryPerformanceCounter(&curTime);
		timeDifference = curTime.QuadPart - prevTime.QuadPart;
		if (timeDifference / freqValue.QuadPart >= fWaitSecHighPerc )
			break;
	}     
}
void fnPrintUsage()
{
	mexPrintf("Usage:\n");
	mexPrintf("fnDAQREDBox(command, param)\n");
	mexPrintf("\n");
	mexPrintf("Commands are: \n");
	mexPrintf("Init    [initializes ports, must call before any other function] \n");
	mexPrintf("SetBit(BitNumber [0,23], BitValue [0,1]) \n");
	mexPrintf("TTL(BitNumber [0,23], \n");
	mexPrintf("afValues = GetAnalog(aiChannels) \n");
		
	mexPrintf("\n");
	mexPrintf("\n");
	mexPrintf("More specific commands that are relevant for the to behavior machine:\n");
	mexPrintf("\n");
	mexPrintf("StrobeWord(Number 0..2^15-1),     [sends a 15 bit word, output bits are hard wired] \n");
	mexPrintf("\n");
}

void fnGetPortTypeAndFirstBit(int PortNumber,  int &PortType, int &FirstBit)
{
	switch (PortNumber) {
			 case 0:
				 PortType = FIRSTPORTA;
				 FirstBit = 0;
				 break;
			 case 1:
				 PortType = FIRSTPORTB;
				 FirstBit = 8;
				 break;
			 case 2:
				 PortType = FIRSTPORTCL;
				 FirstBit = 16;
				 break;
			 case 3:
				 PortType = FIRSTPORTCH;
				 FirstBit = 20;
				 break;
	}
}


void mexFunction( int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[] ) 
{

	int ULStat,UDStat;

	if (nrhs < 1) {
		fnPrintUsage();
		return;
	}
	

	int StringLength = int(mxGetNumberOfElements(prhs[0])) + 1;
	char* Command = (char*)mxCalloc(StringLength, sizeof(char));

	if (mxGetString(prhs[0], Command, StringLength) != 0){
		mexErrMsgTxt("\nError extracting the command.\n");
		return;
	}

	if   (strcmp(Command, "StrobeWord") == 0) {
		/* get a user value to write to the port */
		int Number;
		if (mxIsDouble(prhs[1]))
			Number = int(*(double*)mxGetData(prhs[1]));
		else if (mxIsSingle(prhs[1]))
			Number = int(*(float*)mxGetData(prhs[1]));
		else if (mxIsUint8(prhs[1]))
			Number = int(*(char*)mxGetData(prhs[1]));
		else Number = 0;

		unsigned char LowByte = Number & 255;
		unsigned char HighByte = (Number >> 8) & 127; // Set strobe to zero

		for(int k = 0; k < 8; k++){
			bit = LowByte & Pow2[k];
       		ULStat = DAQmxWriteDigitalLines(digitalTasks[k], 1, true, -1, DAQmx_Val_GroupByChannel, bit, NULL, NULL);
		}
		for(int k = 8; k < 16; k++){
			bit = HighByte & Pow2[k - 8];
       		ULStat = DAQmxWriteDigitalLines(digitalTasks[k], 1, true, -1, DAQmx_Val_GroupByChannel, bit, NULL, NULL);
		}
		ULStat = DAQmxWriteDigitalLines(digitalTasks[15], 1, true, -1, DAQmx_Val_GroupByChannel, 1, NULL, NULL); // Trigger strobe

		//Plexon Manual says Pulse width must be ≥ 250 μsec.
        fnSleep(250 * 1e-6);

		//ULStat = cbDBitOut (BoardNum, FIRSTPORTA, 15, 0); 

		for(int k = 0; k < 16; k++){
       		ULStat = DAQmxWriteDigitalLines(digitalTasks[k], 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL, NULL);
		}
		int dim[1] = {1};
		plhs[0] = mxCreateNumericArray(1, dim, mxDOUBLE_CLASS, mxREAL);
		double *Out = (double*)mxGetPr(plhs[0]);
		*Out = ULStat == 0;

 		return;
	} else if (strcmp(Command, "GetAnalog") == 0) {

		const int *dim = mxGetDimensions(prhs[1]);

		double *Channels = (double*)mxGetData(prhs[1]);
		
		plhs[0] = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
		int Gain = BIP5VOLTS;
		double *MatlabData= (double*)mxGetPr(plhs[0]);

		int NumElements = dim[0] > dim[1] ? dim[0] : dim[1];
		WORD Data;

		for (int iIter = 0; iIter< NumElements;iIter++) {
			int Channel = int(Channels[iIter]);
			// assume +- 5V
			
			UDStat = DAQmxReadAnalogScalarF64(analogTasks[Channel], -1, &Data);
			assert(UDStat == 0);
			MatlabData[iIter] = double(Data);
		}

	} else if (strcmp(Command, "Init") == 0) {

		BoardNum = int(*(double*)mxGetData(prhs[1]));
		// For each line on each port, create a task, assign a DO channel to it, and zero it.
		for(int k=0; k<24; k++) {
			DAQmxCreateTask("",&(digitalTasks[k]));
			DAQmxCreateDOChan(digitalTasks[k], dolines[k], DAQmx_Val_ChanPerLine);
			DAQmxStartTask(digitalTasks[k]);
			DAQmxWriteDigitalLines(digitalTasks[k], 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL, NULL);
		}

		// Assign each analog input to a task
		for(int n=0; n<16; n++){
			DAQmxCreateTask("", &(analogTasks[n]);
			DAQmxCreateAIVoltageChan(analogTasks[n], anlines[n], DAQmx_Val_Cfg_Default, -5, 5, DAQmx_Val_Volts, NULL);
		}

		int dim[1] = {1};
		plhs[0] = mxCreateNumericArray(1, dim, mxDOUBLE_CLASS, mxREAL);
		double *Out = (double*)mxGetPr(plhs[0]);
		*Out = 0;

	} else if (strcmp(Command, "SetBit") == 0) {
		/* get a user value to write to the port */
		int BitNumber = int(*(double*)mxGetData(prhs[1]));
		bool BitValue = int(*(double*)mxGetData(prhs[2])) > 0;
		ULStat = DAQmxWriteDigitalLines(digitalTasks[BitNumber], 1, true, -1, DAQmx_Val_GroupByChannel, BitValue, NULL, NULL);
		int dim[1] = {1};
		plhs[0] = mxCreateNumericArray(1, dim, mxDOUBLE_CLASS, mxREAL);
		double *Out  =(double*)mxGetPr(plhs[0]);
		*Out = ULStat == 0;
		return;

	} else if (strcmp(Command, "TTL") == 0) {
		/* get a user value to write to the port. TTL Pulse is roughly 5 micro sec. Non blocking operation.... */
		int BitNumber = int(*(double*)mxGetData(prhs[1]));
		double fWidthSec = *(double*)mxGetData(prhs[2]);

		ULStat = DAQmxWriteDigitalLines(digitalTasks[BitNumber], 1, true, -1, DAQmx_Val_GroupByChannel, 1, NULL, NULL);
        fnSleep(fWidthSec); 
        ULStat = DAQmxWriteDigitalLines(digitalTasks[BitNumber], 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL, NULL);
		int dim[1] = {1};
		plhs[0] = mxCreateNumericArray(1, dim, mxDOUBLE_CLASS, mxREAL);
		double *Out = (double*)mxGetPr(plhs[0]);
		*Out = ULStat == 0;
		return;
	} else if (strcmp(Command, "SetByte") == 0) {
		int PortNumber = int(*(double*)mxGetData(prhs[1]));
		unsigned char DataByte= (unsigned char)(*(double*)mxGetData(prhs[2]));	

		int PortType, FirstBit;
		fnGetPortTypeAndFirstBit(PortNumber, PortType, FirstBit);
		for(int k = FirstBit; k < FirstBit+8; k++){
			bit = DataByte & Pow2[k-FirstBit];
       		ULStat = DAQmxWriteDigitalLines(digitalTasks[k], 1, true, -1, DAQmx_Val_GroupByChannel, bit);
		}

		int dim[1] = {1};
		plhs[0] = mxCreateNumericArray(1, dim, mxDOUBLE_CLASS, mxREAL);
		double *Out = (double*)mxGetPr(plhs[0]);
		*Out = ULStat == 0;
	} else if (strcmp(Command, "DelayedTrigger") == 0) {
		// Used to shut down the head stage amplifier just before stimulation trigger....
		int GatePort = int(*(double*)mxGetData(prhs[1]));
		int TriggerPort = int(*(double*)mxGetData(prhs[2]));
		double TriggerDelayMS = *(double*)mxGetData(prhs[3]);
		double GatePeriodMS = *(double*)mxGetData(prhs[4]);
		double FirstPulseLengthMS = *(double*)mxGetData(prhs[5]);
		double SecondPulseLengthMS = *(double*)mxGetData(prhs[6]);
		double InterPulseIntervalMS = *(double*)mxGetData(prhs[7]);
		
		ULStat = DAQmxWriteDigitalLines(digitalTasks[GatePort], 1, true, -1, DAQmx_Val_GroupByChannel, 1, NULL, NULL); // Shut down head stage
		fnSleep(TriggerDelayMS/1000.0); // Usually, 1ms for safety in BAK amplifier

		ULStat = DAQmxWriteDigitalLines(digitalTasks[TriggerPort], 1, true, -1, DAQmx_Val_GroupByChannel, 1, NULL, NULL); // First Pulse
		fnSleep(FirstPulseLengthMS/1000.0); // Usually, 1ms for safety in BAK amplifier
		ULStat = DAQmxWriteDigitalLines(digitalTasks[TriggerPort], 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL, NULL); // First Pulse off
		fnSleep(InterPulseIntervalMS/1000.0);  
		ULStat = DAQmxWriteDigitalLines(digitalTasks[TriggerPort], 1, true, -1, DAQmx_Val_GroupByChannel, 1, NULL, NULL); // Second Pulse on
		fnSleep(SecondPulseLengthMS/1000.0);  
		ULStat = DAQmxWriteDigitalLines(digitalTasks[TriggerPort], 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL, NULL); // Second Pulse off
		fnSleep((GatePeriodMS-(TriggerDelayMS+FirstPulseLengthMS+SecondPulseLengthMS+InterPulseIntervalMS))/1000.0); // Usually, 1ms for safety in BAK amplifier
		ULStat = DAQmxWriteDigitalLines(digitalTasks[GatePort], 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL, NULL); // Head stage is back on
	} else if (strcmp(Command, "WaveFormOut") == 0) {
	 int  I;
    int BoardNum = 0;
    int NumChan = 2;
    int ULStat = 0;
    int LowChan, HighChan;
   	int NumPoints = 2048*2;
    WORD ADData[2048*2];
    long Count, Rate;

    /* Initiate error handling
        Parameters:
            PRINTALL :all warnings and errors encountered will be printed
            DONTSTOP :program will continue even if error occurs.
                     Note that STOPALL and STOPFATAL are only effective in 
                     Windows applications, not Console applications. 
   */
   
   	for (I = 0; I < 2048*2; I++) {
	   ADData[I] = (I>2048) ? 2048-I:I;
	}

   TaskHandle aout = -1;
   DAQmxCreateTask("", &aout);
   DAQmxCreateAOVoltageChan(aout, "Dev1/ao0", "", -5.0, 5.0, DAQmx_Val_Volts, NULL);
   DAQmxCfgSampClkTiming(aout, "Dev1/port2/line7", NumPoints, DAQmx_Val_Rising, DAQmx_Val_ContSamps, NumPoints)
   ULSTAT = DAQmxWriteAnalogF64(aout, 1, true, -1, DAQmx_Val_GroupByChannel, 0, NULL);
   ULStat = DAQmxWriteAnalogF64(aout, 1, true, -1, DAQmx_Val_GroupByChannel, ADData, NULL);
   DAQmxStartTask(aout);
	} else  {
		fnPrintUsage();
	}

}

