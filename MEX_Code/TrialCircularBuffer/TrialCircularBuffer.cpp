#include <stdio.h>
#include "mex.h"
#include <string>
#include <math.h>
#include "windows.h"
//#include "plexon.h"

#define MAX(a,b)( (a)<(b)?(b):(a))
#define MIN(a,b)( (a)<(b)?(a):(b))
#define MATLAB_TO_C(NumRows,i,j)( (j-1)*NumRows + (i-1))
const int MAX_FIRING_RATE_HZ = 300;
const int NUM_TRIALS_IN_CIRCULAR_BUFFER = 200;
const int MAX_TRIAL_TYPE_STROBE_WORD = 32000;
const int MAX_LFP_POINTERS = 10000;
const double PacketTimeJitterSec = 1e-3; // 1 ms

int DBG = 0;
bool PlexonInitialized = false;
/*
template<class T> class SafeArray{
public:
	SafeArray(int numelements);

	SafeArray();
	~SafeArray();
	SafeArray(const SafeArray &A);
	void malloc(int numelements);

	T& operator[] (const int nIndex);

	int num;
	T* data;
} ;


template<class T> SafeArray<T>::SafeArray(int numelements) {
	num = numelements;
	data = new T[num];
	for (int k=0;k<num;k++)
		data[k] = 0;

}


template<class T>	T& SafeArray<T>::operator[] (const int nIndex){
	assert(nIndex>=0 && nIndex<num);
	return data[nIndex];
}

template<class T> SafeArray<T>::SafeArray(const SafeArray &A) {
	num = A.num;
	data = new T[num];
	for (int k=0;<num;k++)
		data[k] = A.data[k];
}

template<class T> SafeArray<T>::SafeArray() {
	num = 0;
	data = NULL;
}

template<class T> SafeArray<T>::~SafeArray() {
	num = 0;
	if (data != NULL) {
		delete(data);
		data=NULL;
	}
}

 template<class T> void SafeArray<T>::malloc(int numelements) {
	num = numelements;
	data=new T[num];
}
*/


typedef struct {
	int Miss_Assign;
	int Miss_Start;
	int Miss_Stop;
	int Miss_AnalogPacket;
	int Miss_TrialLength;
	int Miss_NotKept;
	int SpikeInUnrecognizedChannel;
	int Unknown_TrialType;
	int Miss_Trial_BufferTooSmall;
} Warning_struct;

typedef struct {
	double ***SpikeTimes; // Channel x Unit
	int **NumSpikes; 

	double **LFP; // Channel x values
	double Start_TS;
	double End_TS;
	double AlignTo_TS;
	int Outcome;
	int CircularBufferPointer;
	int TrialType;
	int LFPBufferPointer;
	bool bHasValues;
} Trial_strct;

Warning_struct Warnings;


typedef struct {
	int NumConditions;
	int NumTrialTypes;
	int PSTH_BinSizeMS;
	int LFP_ResolutionMS;
	bool *TrialTypeToConditionMatrix;

	int **ConditionOutcomeFilter;
	int *NumConditionOutcomeFilters;

	double *LFP_BinTimes;
	int NumLFPBins;
	double *BinTimes;
	int NumPSTHBins;

	int TrialStartCode;
	int TrialEndCode;
	int TrialAlignCode;
	int NumOutcomes;
	int NumKeepOutcomes;
	int *TrialOutcomesCodes;
	int *KeepTrialOutcomeCodes;
} Opt_struct;

Opt_struct Opt = {0};

int ****ConditionToTrials = NULL;

int ***NumValidTrials = NULL;
int **NumValidTrialsCh = NULL;

int ***NumValidTrialsInBuf = NULL;
int **NumValidTrialsChInBuf = NULL;




int *NumSpikesPerPSTHBin = NULL;
double**** PSTH_Spikes = NULL;
double*** PSTH_LFP = NULL;

double **LastKnownTS = NULL;

int **TrialCounter = NULL;
int **WaveFormCounter = NULL;
double ***WaveFormMean = NULL;
double ***WaveFormVarMk = NULL;
double ***WaveFormVarSk = NULL;

// Globals
bool bAllocated = false;

int TotalTrialCounter = 0;

int NumSamplesInTrialLFPBuffer=0;
int LFP_Stored_Freq=0;
int NumSamplesInCircularLFP =0;

int LFP_Data_Pointer_Index = 0;

int *ChannelMapTransform = NULL;
int MaxRealChannel = 0;
int NumChannels = 0;
int NumUnitsPerChannel = 0;
int LFP_Freq = 0;
int NumTrials = 0;
double TrialLengthSec=0;
double Pre_TimeSec=0;
double Post_TimeSec=0;
int NumDataPointsInWaveForm = 0;

double NaN;

int MaxNumSpikesPerUnitPerTrial;

double LastKnownTimeStamp = 0;

bool bTrialInProgress = 0;
int CurrentTrialIndex = 0;

bool KeepUnsortedUnits = false;

Trial_strct *Trials; 
int SpikeCircularBufferSize;
double *SpikeCircularBuffer; // Matrix of Nx3 [Channel, Unit, Timestamp]
int SpikeCircularBufferSize_Pos;


double **LFP_CircularBuffer; 

double LFP_TS[MAX_LFP_POINTERS] = {0};
int LFP_StartPacketIndex[MAX_LFP_POINTERS]= {0};
int LFP_NumSamples[MAX_LFP_POINTERS]= {0};
int LFP_Counter=0;

int *TrialsAlive;
int TrialsAliveCounter=0;


int *TrialTypeCounter = NULL;
int *ConditionCounter = NULL;

void ReleasePSTHBuffers() {
	if (Opt.TrialOutcomesCodes != NULL)  {
			free(Opt.TrialOutcomesCodes);
			Opt.TrialOutcomesCodes = NULL;
			Opt.NumOutcomes = 0;
	}
	if (Opt.KeepTrialOutcomeCodes != NULL) {
			free(Opt.KeepTrialOutcomeCodes);
			Opt.KeepTrialOutcomeCodes = NULL;
	}
	if (Opt.TrialTypeToConditionMatrix != NULL) {
			free(Opt.TrialTypeToConditionMatrix);
			Opt.TrialTypeToConditionMatrix = NULL;

			if 	(ConditionToTrials != NULL) {

				for (int Ch=0;Ch<NumChannels;Ch++) {
					for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
						for (int Condition=0;Condition<Opt.NumConditions;Condition++) {
							free(ConditionToTrials[Ch][Unit][Condition]);
						}	
						free(ConditionToTrials[Ch][Unit]);
					}
					free(ConditionToTrials[Ch]);
				}
				free(ConditionToTrials);
				ConditionToTrials = NULL;

			}

			Opt.NumConditions = 0;
			Opt.NumTrialTypes = 0;
	}

	if (Opt.BinTimes != NULL)  {
			free(Opt.BinTimes);
			Opt.BinTimes = NULL;
	}

	if (Opt.LFP_BinTimes != NULL)  {
			free(Opt.LFP_BinTimes);
			Opt.LFP_BinTimes = NULL;
	}
	// Allocate memory for statistics....
	if (PSTH_Spikes!=NULL) {
		// Release....
		for (int Ch=0;Ch<NumChannels;Ch++) {
			for (int Unit=0;Unit < NumUnitsPerChannel; Unit++) {
				for (int CatIter=0;CatIter < Opt.NumConditions; CatIter++) {
					free(PSTH_Spikes[Ch][Unit][CatIter]);
				}
				free(PSTH_Spikes[Ch][Unit]);
			}
			free(PSTH_Spikes[Ch]);
		}

		free(PSTH_Spikes);
		PSTH_Spikes = NULL;
	}

	if (PSTH_LFP != NULL) {
		for (int Ch=0;Ch<NumChannels;Ch++) {
			for (int CatIter=0;CatIter < Opt.NumConditions; CatIter++) {
				free(PSTH_LFP[Ch][CatIter]);
			}
			free(PSTH_LFP[Ch]);
		}
		free(PSTH_LFP);
		PSTH_LFP = NULL;
	}

	if (NumValidTrials != NULL) {
		// Clear NumValidTrials
		for (int Ch=0;Ch<NumChannels;Ch++) {
			for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
				free(NumValidTrials[Ch][Unit]);
			}
			free(NumValidTrials[Ch]);
		}
		free(NumValidTrials);
		NumValidTrials = NULL;
	}


	if (NumValidTrialsCh!=NULL) {
		for (int Ch=0;Ch<NumChannels;Ch++) {
			free(NumValidTrialsCh[Ch]);
		}
		free(NumValidTrialsCh);
		NumValidTrialsCh=  NULL;
	}
///////////////////////
	if (NumValidTrialsInBuf != NULL) {
		// Clear NumValidTrialsChInBuf
		for (int Ch=0;Ch<NumChannels;Ch++) {
			for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
				free(NumValidTrialsInBuf[Ch][Unit]);
			}
			free(NumValidTrialsInBuf[Ch]);
		}
		free(NumValidTrialsInBuf);
		NumValidTrialsInBuf = NULL;
	}


	if (NumValidTrialsChInBuf !=NULL) {
		for (int Ch=0;Ch<NumChannels;Ch++) {
			free(NumValidTrialsChInBuf[Ch]);
		}
		free(NumValidTrialsChInBuf);
		NumValidTrialsChInBuf=  NULL;
	}
	////////////////////


	if (NumSpikesPerPSTHBin != NULL) {
		free(NumSpikesPerPSTHBin);
		NumSpikesPerPSTHBin = NULL;
	}

	if (Opt.ConditionOutcomeFilter != NULL) {
		for (int Cond = 0; Cond < Opt.NumConditions; Cond++) {
			if (Opt.ConditionOutcomeFilter[Cond] != NULL) {
				free(Opt.ConditionOutcomeFilter[Cond]);
			}
		}
		free(Opt.ConditionOutcomeFilter);
		Opt.ConditionOutcomeFilter = NULL;
		free(Opt.NumConditionOutcomeFilters);
		Opt.NumConditionOutcomeFilters = NULL;
	}

	if (TrialTypeCounter != NULL) {
		free(TrialTypeCounter);
		TrialTypeCounter = NULL;
	}

	if (ConditionCounter != NULL) {
		free(ConditionCounter);
		ConditionCounter = NULL;
	}


}


void Release() {

	if (!bAllocated)
		return ;

	for (int Trial=0; Trial<NumTrials;Trial++) {
		for (int Ch=0; Ch<NumChannels; Ch++) {

			for (int Unit=0; Unit<NumUnitsPerChannel;Unit++) {
				free(Trials[Trial].SpikeTimes[Ch][Unit]); // delete all spikes
			}
			free(Trials[Trial].SpikeTimes[Ch]); // delete unit
			free(Trials[Trial].NumSpikes[Ch]);
			free(Trials[Trial].LFP[Ch]);

		}
		free(Trials[Trial].LFP); // delete LFP information
		free(Trials[Trial].SpikeTimes); // delete spike information
		free(Trials[Trial].NumSpikes);
	}
	free(Trials); // delete trials

	free(SpikeCircularBuffer);

	free(TrialsAlive);
	

	// Free avg wave form
	for (int Channel=0;Channel < NumChannels;Channel++) {
		for (int Unit=0;Unit < NumUnitsPerChannel;Unit++) {
			free(WaveFormMean[Channel][Unit]);
			free(WaveFormVarMk[Channel][Unit]);
			free(WaveFormVarSk[Channel][Unit]);
		}
		free(WaveFormMean[Channel]);
		free(WaveFormVarMk[Channel]);
		free(WaveFormVarSk[Channel]);
		free(WaveFormCounter[Channel]);
	}
	free(WaveFormCounter);
	WaveFormCounter = NULL;
	free(WaveFormMean);
	WaveFormMean = NULL;
	free(WaveFormVarSk);
	free(WaveFormVarMk);
	WaveFormVarMk = NULL;
	WaveFormVarSk = NULL;

	if (ChannelMapTransform != NULL) {
		free(ChannelMapTransform);
		ChannelMapTransform=NULL;
	}

	for (int k=0;k<NumChannels;k++)
		free(LastKnownTS[k]);
	free(LastKnownTS);
	LastKnownTS = NULL;

	for (int k=0;k<NumChannels;k++)
		free(TrialCounter[k]);
	free(TrialCounter);
	TrialCounter = NULL;

	


	for (int Ch=0;Ch<NumChannels;Ch++)
		free(LFP_CircularBuffer[Ch]);

	free(LFP_CircularBuffer);
	
	ReleasePSTHBuffers();

	bAllocated = false;
	return ;
}


bool Allocate(double *SelectedChannels) {
	// Allocate space for spikes
	if (bAllocated)
		Release();

	TotalTrialCounter = 0;
	
	// build the channel mapping transform.
	// how many channels?
	MaxRealChannel = 0;
	for (int i=0;i<NumChannels;i++)
		MaxRealChannel= MAX(MaxRealChannel, (int) SelectedChannels[i]);

    ChannelMapTransform = (int*) malloc(sizeof(int) * (MaxRealChannel+1));
	for (int i=0;i<MaxRealChannel+1;i++) 
		ChannelMapTransform[i] = 0;

	for (int i=0; i<NumChannels;i++) 
		ChannelMapTransform[(int)SelectedChannels[i]] = i+1;

	NaN = mxGetNaN();

	double TrialTotalLengthSec = Pre_TimeSec+Post_TimeSec+TrialLengthSec;
	MaxNumSpikesPerUnitPerTrial = (int) ceil(TrialTotalLengthSec * MAX_FIRING_RATE_HZ);

	// Spike Circular Buffer

	SpikeCircularBufferSize = (int) ceil(TrialTotalLengthSec * MAX_FIRING_RATE_HZ * NumChannels * NumUnitsPerChannel * NUM_TRIALS_IN_CIRCULAR_BUFFER);
	SpikeCircularBuffer = new double[SpikeCircularBufferSize*3];
	for (int k=0;k<SpikeCircularBufferSize*3;k++)
		SpikeCircularBuffer[k] = NaN;

	SpikeCircularBufferSize_Pos = 0;


	// LFP Circular Buffer
	LFP_CircularBuffer = (double **) malloc(NumChannels * sizeof(double*));
	NumSamplesInCircularLFP = (int)ceil(TrialTotalLengthSec * LFP_Stored_Freq * NUM_TRIALS_IN_CIRCULAR_BUFFER);
	for (int Ch=0;Ch<NumChannels;Ch++)
		LFP_CircularBuffer[Ch] = (double *) malloc(NumSamplesInCircularLFP * sizeof(double) );

	NumSamplesInTrialLFPBuffer = (int) ceil(TrialTotalLengthSec * LFP_Stored_Freq);


	// Trial Buffer
	TrialsAlive = (int*) malloc(NumTrials * sizeof(int));
	for (int j=0;j<NumTrials;j++)
		TrialsAlive[j] = -1;

	Trials =  (Trial_strct*) new Trial_strct[NumTrials]; 
	for (int Trial=0; Trial<NumTrials;Trial++) {
		Trials[Trial].bHasValues = false;
		Trials[Trial].SpikeTimes = (double***) malloc( NumChannels * sizeof(double**));
		Trials[Trial].NumSpikes	= (int**) malloc( NumChannels * sizeof(int*));
		Trials[Trial].LFP = (double**)  malloc(NumChannels * sizeof(double *));

		for (int Ch=0; Ch<NumChannels; Ch++) {
			Trials[Trial].SpikeTimes[Ch] = (double**)  malloc(NumUnitsPerChannel * sizeof(double*));
			Trials[Trial].NumSpikes[Ch] = (int*)  malloc(NumUnitsPerChannel * sizeof(int));
			Trials[Trial].LFP[Ch] = (double*)  malloc(NumSamplesInTrialLFPBuffer * sizeof(double));
			for (int j=0;j<NumSamplesInTrialLFPBuffer;j++)
				Trials[Trial].LFP[Ch][j] = NaN;

			for (int Unit=0; Unit<NumUnitsPerChannel;Unit++) {
				Trials[Trial].SpikeTimes[Ch][Unit] = (double*)  malloc(MaxNumSpikesPerUnitPerTrial * sizeof(double));
				Trials[Trial].NumSpikes[Ch][Unit] = 0;

				for (int k=0;k<MaxNumSpikesPerUnitPerTrial;k++) {
					Trials[Trial].SpikeTimes[Ch][Unit][k] = NaN;
				}
			}
		}
	}



	WaveFormCounter = (int **) malloc(NumChannels * sizeof(int **));
	WaveFormMean = (double ***) malloc(NumChannels * sizeof(double **));
	WaveFormVarMk = (double ***) malloc(NumChannels * sizeof(double **));
	WaveFormVarSk = (double ***) malloc(NumChannels * sizeof(double **));
	for (int Channel=0;Channel < NumChannels;Channel++) {
		WaveFormMean[Channel] = (double **) malloc(NumUnitsPerChannel * sizeof(double *));
		WaveFormVarMk[Channel] = (double **) malloc(NumUnitsPerChannel * sizeof(double *));
		WaveFormVarSk[Channel] = (double **) malloc(NumUnitsPerChannel * sizeof(double *));
		WaveFormCounter[Channel] = (int *) malloc(NumUnitsPerChannel * sizeof(int));
		for (int Unit=0;Unit < NumUnitsPerChannel;Unit++) {
			WaveFormMean[Channel][Unit] = (double *) malloc(NumDataPointsInWaveForm * sizeof(double));
			WaveFormVarSk[Channel][Unit] = (double *) malloc(NumDataPointsInWaveForm * sizeof(double));
			WaveFormVarMk[Channel][Unit] = (double *) malloc(NumDataPointsInWaveForm * sizeof(double));
			WaveFormCounter[Channel][Unit] = 0;
			for (int k=0;k<NumDataPointsInWaveForm;k++) {
				WaveFormMean[Channel][Unit][k] = 0;
				WaveFormVarSk[Channel][Unit][k] = 0;
				WaveFormVarMk[Channel][Unit][k] = 0;
			}
		
		}
	}


	LastKnownTS = (double**) malloc(NumChannels * sizeof(double*));
	for (int Channel=0;Channel < NumChannels;Channel++) {
		LastKnownTS[Channel] = (double*) malloc(NumUnitsPerChannel * sizeof(double));
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
			LastKnownTS[Channel][Unit] = NaN;
		}
	}

	TrialCounter = (int**) malloc(NumChannels * sizeof(int*));
	for (int Channel=0;Channel < NumChannels;Channel++) {
		TrialCounter[Channel] = (int*) malloc(NumUnitsPerChannel * sizeof(int));
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
			TrialCounter[Channel][Unit] = 0;
		}
	}


	
    LFP_Counter=0;
	LFP_Data_Pointer_Index = 0;

	for (int k=0;k<MAX_LFP_POINTERS;k++) {
		LFP_TS[k] = 0;
		LFP_StartPacketIndex[k] = 0;
		LFP_NumSamples[k]= 0;
	}


	bTrialInProgress = 0;
	CurrentTrialIndex = 0;
	TrialsAliveCounter=0;
	LastKnownTimeStamp = 0;


	Warnings.Miss_Assign = 0;
	Warnings.Miss_Start = 0;
	Warnings.Miss_Stop = 0;
	Warnings.Miss_AnalogPacket = 0;
	Warnings.Miss_TrialLength = 0;
	Warnings.Miss_NotKept = 0;
	Warnings.SpikeInUnrecognizedChannel = 0;
	Warnings.Unknown_TrialType = 0;
	Warnings.Miss_Trial_BufferTooSmall = 0;
	bAllocated = true;

	return true;
}


bool fnUpdateTrialAnalog(int TrialIndex, double TrialStartTS, double TrialEndTS, double TrialAlignToTS) {
	// First - find the previous time stamp before trial onset....
	assert(TrialIndex >= 0 && TrialIndex < NumTrials);

	int StartSeachIndex = Trials[TrialIndex].LFPBufferPointer;
	int Counter = 0;
	bool bEntryFound = false;
	while (Counter <MAX_LFP_POINTERS ) {


		assert(StartSeachIndex >= 0 && StartSeachIndex < MAX_LFP_POINTERS);


		if (LFP_TS[StartSeachIndex] != 0 && (LFP_TS[StartSeachIndex] <= (TrialStartTS-Pre_TimeSec) )) {
			bEntryFound = true;
			break;
		}
		StartSeachIndex--;
		if (StartSeachIndex < 0)
			StartSeachIndex = MAX_LFP_POINTERS-1;
		Counter++;
	}

	if (!bEntryFound) {
		Warnings.Miss_AnalogPacket++; 
		return false;
	}

	assert(StartSeachIndex >= 0 && StartSeachIndex < MAX_LFP_POINTERS);

	double fPacketTS = LFP_TS[StartSeachIndex];

	double TimeInterval = TrialLengthSec +Pre_TimeSec+Post_TimeSec;//TrialEndTS + Post_TimeSec - (TrialStartTS - Pre_TimeSec);
	int NumSamplesInterp = NumSamplesInTrialLFPBuffer;//(int)floor(LFP_Stored_Freq*TimeInterval);

	// Time points to sample...
	double fTime0 = TrialStartTS - Pre_TimeSec;

	int CurrDataPacket = StartSeachIndex;

	//assert(NumSamplesInterp <= NumSamplesInTrialLFPBuffer);

	for (int InterpCounter=0;InterpCounter < NumSamplesInterp; InterpCounter++) {
		double CurrSampleTime = fTime0 + InterpCounter*TimeInterval/(NumSamplesInterp-1);

		assert(CurrDataPacket >= 0 && CurrDataPacket < MAX_LFP_POINTERS);

		if (CurrSampleTime > LFP_TS[CurrDataPacket] + double(LFP_NumSamples[CurrDataPacket])/LFP_Stored_Freq) {
			// Time to move to the next packet (!)

			CurrDataPacket++;
			if (CurrDataPacket >= MAX_LFP_POINTERS)
				CurrDataPacket -= MAX_LFP_POINTERS;

			fPacketTS = LFP_TS[CurrDataPacket];
			if (fPacketTS == 0 || (fPacketTS + double(LFP_NumSamples[CurrDataPacket])/LFP_Stored_Freq < CurrSampleTime)) {
				for (int k=InterpCounter;k<NumSamplesInterp;k++) {
					for (int Channel = 0; Channel < NumChannels; Channel++) {
						Trials[TrialIndex].LFP[Channel][k] = NaN;
					}
				}
				return true;
			}
		}

		// Things are still simple enough. We need to locate the two time points in this packet 
		// to do the linear interpolation....
		// The two time points can be computed explicitely since it is a fixed sampling rate !
		double ExactSample = (CurrSampleTime - fPacketTS) * LFP_Stored_Freq;
		int FloorSample = (int)floor(ExactSample);

		assert(CurrDataPacket >= 0 && CurrDataPacket < MAX_LFP_POINTERS);

		int LeftIndex = LFP_StartPacketIndex[CurrDataPacket] + FloorSample;

		double DeltaTime = ExactSample-FloorSample;

		if (LeftIndex < 0) {
			// we have a gap in the A/D samples!
			for (int Channel = 0; Channel < NumChannels; Channel++) {
					Trials[TrialIndex].LFP[Channel][InterpCounter] = NaN;
			}
			continue;
		}
		
		int RightIndex = LeftIndex+1;
		if (FloorSample+1 <= LFP_NumSamples[CurrDataPacket]-1) {

			if (LeftIndex >= NumSamplesInCircularLFP)
				LeftIndex -= NumSamplesInCircularLFP;

			if (RightIndex >= NumSamplesInCircularLFP)
				RightIndex -= NumSamplesInCircularLFP;


			for (int Channel = 0; Channel < NumChannels; Channel++) {
				assert(LeftIndex >= 0 && RightIndex >= 0 && LeftIndex < NumSamplesInCircularLFP && RightIndex < NumSamplesInCircularLFP);
				double LeftValue = LFP_CircularBuffer[Channel][LeftIndex];
				double RightValue = LFP_CircularBuffer[Channel][RightIndex];
				double DeltaValue = RightValue-LeftValue;
				double InterpolatedValue = LeftValue + DeltaValue * DeltaTime;
				Trials[TrialIndex].LFP[Channel][InterpCounter] = InterpolatedValue;
			}
		} else  {
			// Still not moving to the next packet, but the right hand side
			// comes from the next packet....

			if (LeftIndex >= NumSamplesInCircularLFP)
				LeftIndex -= NumSamplesInCircularLFP;

			if (RightIndex >= NumSamplesInCircularLFP)
				RightIndex -= NumSamplesInCircularLFP;

			int NextPacketIndex = CurrDataPacket+1;
			if (NextPacketIndex >= MAX_LFP_POINTERS)
				NextPacketIndex -= MAX_LFP_POINTERS;

			assert(CurrDataPacket >= 0 && CurrDataPacket < MAX_LFP_POINTERS);
			assert(NextPacketIndex >= 0 && NextPacketIndex < MAX_LFP_POINTERS);

			double LastTS_CurrPacket = LFP_TS[CurrDataPacket] + double((LFP_NumSamples[CurrDataPacket]-1)) / double(LFP_Stored_Freq);
			double StartTS_NextPacket = LFP_TS[NextPacketIndex];
			if (StartTS_NextPacket > LastTS_CurrPacket) {
			double DeltaTimeToNextPacket = StartTS_NextPacket - CurrSampleTime;
			double DeltaTimeFromLastTSOfCurrentPacket = CurrSampleTime-LastTS_CurrPacket;

			for (int Channel = 0; Channel < NumChannels; Channel++) {
				assert(LeftIndex >= 0 && RightIndex >= 0 && LeftIndex < NumSamplesInCircularLFP && RightIndex < NumSamplesInCircularLFP);

				double LeftValue = LFP_CircularBuffer[Channel][LeftIndex];
				double RightValue = LFP_CircularBuffer[Channel][RightIndex];
				double DeltaValue = RightValue-LeftValue;
				double InterpolatedValue = LeftValue + DeltaValue * DeltaTimeFromLastTSOfCurrentPacket/(DeltaTimeFromLastTSOfCurrentPacket+DeltaTimeToNextPacket);
				Trials[TrialIndex].LFP[Channel][InterpCounter] = InterpolatedValue;
			}
			} else {
				// Next packet is empty... Fill NaNs....
				for (int Channel = 0; Channel < NumChannels; Channel++) {
					Trials[TrialIndex].LFP[Channel][InterpCounter] = NaN;
				}

			}
		}
	}
	return true;
}



 
/* qsort int comparison function */ 
int TS_cmp(const void *a, const void *b) 
{ 
	double diff = *(double*)a  - *(double*)b;
	if (diff > 0)
		return 1; 
	else if (diff < 0)
		return -1;
	return 0;
} 

void fnUpateTrialSpikes(int TrialIndex, double TrialStartTS, double TrialEndTS, double TrialAlignToTS)
{

	// First, update Spikes.
	// Instead of searching the entire spike buffer, we use the saved pointers for start trial and end trial.
	// and then look backward in time...
	// If we go backward and find a spike with TS smaller than  TrialStartTS - Pre_TimeSec , we can stop searching.
	// same for going forward and  TrialEndTS + Post_TimeSec 				


	assert(TrialIndex >= 0 && TrialIndex < NumTrials);

	int StartSeachIndex = Trials[TrialIndex].CircularBufferPointer;
	int MaxEntriesBackward = (int) ceil(Pre_TimeSec * MAX_FIRING_RATE_HZ * NumChannels * NumUnitsPerChannel);
	int MaxEntriesForward = (int) ceil(Post_TimeSec * MAX_FIRING_RATE_HZ * NumChannels * NumUnitsPerChannel);

	int SpikeIter = StartSeachIndex-1;

	if (SpikeIter < 0)
			SpikeIter = SpikeCircularBufferSize-1;

	int Counter = 0;
	while (1) {
		assert(SpikeIter >= 0 && SpikeIter < SpikeCircularBufferSize*3);

		double SpikeTS = SpikeCircularBuffer[3*SpikeIter+2];

		if ( (SpikeTS < TrialStartTS-Pre_TimeSec-PacketTimeJitterSec) || (Counter > MaxEntriesBackward))
			break;

		if (SpikeTS >= TrialStartTS - Pre_TimeSec &&
			SpikeTS <= TrialEndTS + Post_TimeSec) {
				// Add this spike to the trial buffer, and align it properly (?)
				int Channel = (int)SpikeCircularBuffer[3*SpikeIter]-1;
				int Unit = (int)SpikeCircularBuffer[3*SpikeIter+1]-1;
				if (Channel>= 0 && Channel < NumChannels && Unit >=0 && Unit < NumUnitsPerChannel) {
					//int Index = Channel *NumUnitsPerChannel+Unit ;
					int NumSpk = Trials[TrialIndex].NumSpikes[Channel][Unit];
					if (NumSpk < MaxNumSpikesPerUnitPerTrial) {
						Trials[TrialIndex].SpikeTimes[Channel][Unit][ NumSpk] = SpikeTS-TrialAlignToTS;
						Trials[TrialIndex].NumSpikes[Channel][Unit]++;
					}
				} else {
					Warnings.SpikeInUnrecognizedChannel++;
				}
		}


		SpikeIter--;
		if (SpikeIter < 0)
			SpikeIter = SpikeCircularBufferSize-1;

		Counter++;

	}

	// Now search forward...
	SpikeIter = StartSeachIndex;
	Counter = 0;
	while (1) {
		double SpikeTS = SpikeCircularBuffer[3*SpikeIter+2];

		if (Counter > MaxEntriesForward || SpikeTS > TrialEndTS+Post_TimeSec + PacketTimeJitterSec)
			break;

		if (SpikeTS >= TrialStartTS - Pre_TimeSec &&
			SpikeTS <= TrialEndTS + Post_TimeSec) {
				// Add this spike to the trial buffer, and align it properly (?)
				int Channel = (int)SpikeCircularBuffer[3*SpikeIter]-1;
				int Unit = (int)SpikeCircularBuffer[3*SpikeIter+1]-1;
				if (Channel>= 0 && Channel < NumChannels && Unit >=0 && Unit < NumUnitsPerChannel) {
					//int Index = Channel *NumUnitsPerChannel+Unit ;
					int NumSpk = Trials[TrialIndex].NumSpikes[Channel][Unit];
					if (NumSpk < MaxNumSpikesPerUnitPerTrial) {
						Trials[TrialIndex].SpikeTimes[Channel][Unit][NumSpk] = SpikeTS-TrialAlignToTS;
						Trials[TrialIndex].NumSpikes[Channel][Unit]++;
					}
				} else {
					Warnings.SpikeInUnrecognizedChannel++;
				}
		}

		SpikeIter++;
		if (SpikeIter >= SpikeCircularBufferSize)
			SpikeIter = 0;

		Counter++;

	}		
/* Sort spikes.
You would assume that time stamps received from plexon are time sorted, but they are not...
that is, you can get two packets, such that LastTS(Packet K) > FirstTS(Packet K+1)
*/
	for (int Channel=0;Channel < NumChannels;Channel++) {
		for (int Unit=0;Unit < NumUnitsPerChannel;Unit++) {
			int NumSpk = Trials[TrialIndex].NumSpikes[Channel][Unit];
			if (NumSpk > 1) {
			    qsort(Trials[TrialIndex].SpikeTimes[Channel][Unit], NumSpk, sizeof(double), TS_cmp);
			}

		}
	}
	

}

void ZeroOutTrial(int CurrentTrialIndex) {
	Trials[CurrentTrialIndex].AlignTo_TS=0;
	Trials[CurrentTrialIndex].CircularBufferPointer=0;
	Trials[CurrentTrialIndex].End_TS=0;
	Trials[CurrentTrialIndex].Outcome=0;
	Trials[CurrentTrialIndex].Start_TS=0;
	Trials[CurrentTrialIndex].TrialType=0;
	Trials[CurrentTrialIndex].LFPBufferPointer = 0;
	Trials[CurrentTrialIndex].bHasValues = false;

	// Zero out spike data
	for (int Ch=0; Ch<NumChannels; Ch++) {
		// zero out LFP information

		for (int k=0;k<NumSamplesInTrialLFPBuffer;k++) {
			Trials[CurrentTrialIndex].LFP[Ch][k] = NaN;
		}

		// zero out spike information
		for (int Unit=0; Unit<NumUnitsPerChannel;Unit++) {
			Trials[CurrentTrialIndex].NumSpikes[Ch][Unit]=0;
			for (int k=0;k<MaxNumSpikesPerUnitPerTrial;k++) {
				Trials[CurrentTrialIndex].SpikeTimes[Ch][Unit][k] = NaN;
			}
		}
	}
}



void fnUpdateTrialStatistics(int TrialIndex) {
	if (Trials[TrialIndex].TrialType == 0 || Trials[TrialIndex].TrialType > Opt.NumTrialTypes) { 
		// Unknown trial type or incorrect trial update - don't update statistics.
		Warnings.Unknown_TrialType++;
		return;
	}
	
	TrialTypeCounter[Trials[TrialIndex].TrialType - 1]++;


	for (int Channel=0;Channel < NumChannels;Channel++) {
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
			TrialCounter[Channel][Unit]++;
		}
	}


	for (int Condition=0;Condition < Opt.NumConditions;Condition++) {
		int TrialCategoryIndex = MATLAB_TO_C(Opt.NumTrialTypes,Trials[TrialIndex].TrialType,Condition+1);

		bool bOutcomeMatch = false;

		if ( (Opt.ConditionOutcomeFilter != NULL) &&  Opt.NumConditionOutcomeFilters[Condition] > 0 && 
			(Opt.ConditionOutcomeFilter[Condition] != NULL) ) {
			// Outcome filtering is active!
				for (int OutcomeIter=0;OutcomeIter<Opt.NumConditionOutcomeFilters[Condition]; OutcomeIter++) {
					if (Opt.ConditionOutcomeFilter[Condition][OutcomeIter] == Trials[TrialIndex].Outcome) {
						bOutcomeMatch = true;
						break;
					}
				}

		} else {
			// Trial outcome condition filtering is not active
			bOutcomeMatch = true;
		}
		assert(TrialCategoryIndex >= 0 && TrialCategoryIndex < Opt.NumTrialTypes * Opt.NumConditions);
		bool bTrialTypeMatch = Opt.TrialTypeToConditionMatrix[TrialCategoryIndex];
		bool bUpdate = bTrialTypeMatch && bOutcomeMatch;

		if (bUpdate) {
			
			ConditionCounter[Condition]++;
			for (int Channel=0;Channel<NumChannels;Channel++) {
				for (int Unit=0;Unit < NumUnitsPerChannel;Unit++) {

					int Ptr = NumValidTrialsInBuf[Channel][Unit][Condition];
					if (Ptr == NumTrials) {
						// Move pointers one left ?
						for (int k=0; k < NumTrials-1;k++)
							ConditionToTrials[Channel][Unit][Condition][k]=ConditionToTrials[Channel][Unit][Condition][k+1];

						Ptr = NumTrials-1;
					}

					assert(Ptr >= 0 && Ptr < NumTrials);
					ConditionToTrials[Channel][Unit][Condition][Ptr] = TrialIndex;

					NumValidTrialsInBuf[Channel][Unit][Condition]++;
					NumValidTrials[Channel][Unit][Condition]++;

					if (NumValidTrialsInBuf[Channel][Unit][Condition] >= NumTrials)
						NumValidTrialsInBuf[Channel][Unit][Condition] = NumTrials;


					// Zero out bin counter
					for (int k=0;k<Opt.NumPSTHBins;k++) NumSpikesPerPSTHBin[k] = 0;

					// Count how many spikes in each bin
					assert(Trials[TrialIndex].NumSpikes[Channel][Unit] <= MaxNumSpikesPerUnitPerTrial);
					for (int SpikeIter = 0;SpikeIter < Trials[TrialIndex].NumSpikes[Channel][Unit];SpikeIter++) {
						// spikes are already aligned, in the sense that their timestamp is
						// time of occurance - align_TS. 

						// Time
						double TimePosSec = Trials[TrialIndex].SpikeTimes[Channel][Unit][SpikeIter]+Pre_TimeSec;
						double SamplingBin = 1/(Opt.PSTH_BinSizeMS/1e3);

						int MatchedBin = (int) floor(TimePosSec*SamplingBin);
						
						if (MatchedBin >=0 && MatchedBin < Opt.NumPSTHBins) {
							NumSpikesPerPSTHBin[MatchedBin]++;
						}
					}

					// Update firing rate
					for (int BinIter=0;BinIter<Opt.NumPSTHBins;BinIter++) {
						PSTH_Spikes[Channel][Unit][Condition][BinIter] = 
							((NumValidTrials[Channel][Unit][Condition]-1) * PSTH_Spikes[Channel][Unit][Condition][BinIter] + NumSpikesPerPSTHBin[BinIter]) 
							/ NumValidTrials[Channel][Unit][Condition];
					}
				} // end of unit iteration

				// Update Analog Average....
				double SamplingOffset = Trials[TrialIndex].AlignTo_TS-Trials[TrialIndex].Start_TS;
				double Time0 = Trials[TrialIndex].Start_TS-Pre_TimeSec;

				NumValidTrialsChInBuf[Channel][Condition]++;
				NumValidTrialsCh[Channel][Condition]++;
				if (NumValidTrialsChInBuf[Channel][Condition] >= NumTrials-1)
					NumValidTrialsChInBuf[Channel][Condition] = NumTrials-1;

				for (int iBinIter=0;iBinIter<Opt.NumLFPBins;iBinIter++) {
					// Linear interpolate at the given values bin times (relative to alignment?)
					double fSamplingTime = Trials[TrialIndex].Start_TS+Opt.LFP_BinTimes[iBinIter] + SamplingOffset;
					// Which LFP bin is the left value and which is the right?
					double ExactLeftIndex = (fSamplingTime - Time0) * LFP_Stored_Freq;
					int LeftIndex = (int) floor(ExactLeftIndex);
					double DeltaTime = ExactLeftIndex-double(LeftIndex);
					int RightIndex = LeftIndex + 1;
					if (LeftIndex >= 0 && RightIndex < NumSamplesInTrialLFPBuffer) {
						double LeftValue = Trials[TrialIndex].LFP[Channel][LeftIndex];
						double RightValue = Trials[TrialIndex].LFP[Channel][RightIndex];
						double InterpolatedValue = LeftValue+DeltaTime*(RightValue-LeftValue);
						
						if (LeftValue != NaN && RightValue != NaN) {
							PSTH_LFP[Channel][Condition][iBinIter] = 
								((NumValidTrialsCh[Channel][Condition]-1)*PSTH_LFP[Channel][Condition][iBinIter] + InterpolatedValue) / NumValidTrialsCh[Channel][Condition];
						}

					} 
				} // end of PSTH bin iteration
			} // end of channel iteration
		} // end of correct category if condition
	} // end of category iteration

}


void UpdateTimeStamp(int NumSpikeEntries, double *SpikeAndStrobeWordTable, double *AnalogChannelsData, int NumAnalogEntries, double *AnalogTime0) 
{
	double LastTS_Spikes = (NumSpikeEntries > 0) ? SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, NumSpikeEntries,4)]:LastKnownTimeStamp;// Timestamp
	double LastTS_Analog = (NumAnalogEntries > 0) ? AnalogTime0[0]+double(NumAnalogEntries)/double(LFP_Freq) : LastKnownTimeStamp;
	LastKnownTimeStamp = MAX(LastTS_Spikes,LastTS_Analog);
}

void UpdatePlexon(int NumSpikeEntries, double *SpikeAndStrobeWordTable, double *AnalogChannelsData, int NumAnalogEntries, double *AnalogTime0, double *WaveForms) 
{
	// This function is doing all the heavy lifting....

	// First - update internal circular buffers.
	bool bSpikeEntry;
	int x3,StrobeWordValue;
	double StrobeWordTimestamp;

	// Matlab Indexing : [i,j] -> C++ Index: (j-1)*#Rows + (i-1)


	// Update analog channels. No fancy stuff here.
	int SubSampleSkip = LFP_Freq / LFP_Stored_Freq;


	
	// Num samples to update should not exceed the buffer....
	int NumSamplesToUpdate = MIN(NumAnalogEntries/SubSampleSkip,NumSamplesInCircularLFP -1);
	if (NumSamplesToUpdate > 0) {

		LFP_TS[LFP_Counter] = AnalogTime0[0];
		LFP_NumSamples[LFP_Counter] = NumSamplesToUpdate;
		LFP_StartPacketIndex[LFP_Counter] = LFP_Data_Pointer_Index;
		LFP_Counter++;
		if (LFP_Counter >= MAX_LFP_POINTERS)
			LFP_Counter -= MAX_LFP_POINTERS;


		for (int iChannelIter=0;iChannelIter<NumChannels;iChannelIter++) {

			int ChannelOffset = iChannelIter*NumAnalogEntries;
			if ( (LFP_Data_Pointer_Index + NumSamplesToUpdate) > NumSamplesInCircularLFP) {

				// We break the update to two parts, to keep the if statement out of the loop.
				int NumSamples1 = NumSamplesInCircularLFP-LFP_Data_Pointer_Index;
				int NumSamples2 = NumSamplesInCircularLFP-(LFP_Data_Pointer_Index + NumSamplesToUpdate);

				for (int iDataIter=0;iDataIter<NumSamples1;iDataIter++)
					LFP_CircularBuffer[iChannelIter][LFP_Data_Pointer_Index+iDataIter] = AnalogChannelsData[iDataIter*SubSampleSkip + ChannelOffset];

				for (int iDataIter=0;iDataIter<NumSamples2;iDataIter++)
					LFP_CircularBuffer[iChannelIter][iDataIter] = AnalogChannelsData[iDataIter*SubSampleSkip + NumSamples1+ChannelOffset];


			} else {
				// we do not exceed circular buffer
				for (int iDataIter=0;iDataIter<NumSamplesToUpdate;iDataIter++)
					LFP_CircularBuffer[iChannelIter][LFP_Data_Pointer_Index+iDataIter] = AnalogChannelsData[iDataIter*SubSampleSkip + ChannelOffset];
			}
		}

		LFP_Data_Pointer_Index += NumSamplesToUpdate;

		if (LFP_Data_Pointer_Index >= NumSamplesInCircularLFP)
			LFP_Data_Pointer_Index -= NumSamplesInCircularLFP;
	}

	double LastTS_Spikes = (NumSpikeEntries > 0) ? SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, NumSpikeEntries,4)]:LastKnownTimeStamp;// Timestamp
	double LastTS_Analog = (NumAnalogEntries > 0) ? AnalogTime0[0]+double(NumAnalogEntries)/double(LFP_Freq) : LastKnownTimeStamp;
	LastKnownTimeStamp = MAX(LastTS_Spikes,LastTS_Analog);

	for (int iEntryIter=0;iEntryIter<	NumSpikeEntries; iEntryIter++) {
		
		bSpikeEntry = SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, iEntryIter+1,1)] == 1; // Is this a spike?

		if (bSpikeEntry) {
			// Simple enough. Add this information to the circular buffer
			x3 = SpikeCircularBufferSize_Pos*3;
			int UnitIndex = (int) SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, iEntryIter+1,3)]; // Unit
			int ChRealNumber = (int) SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, iEntryIter+1,2)];
			
			if (ChRealNumber < 1 || ChRealNumber > MaxRealChannel) {
				Warnings.SpikeInUnrecognizedChannel++;
				continue;
			}

			int ChannelCount1 = ChannelMapTransform[ChRealNumber];

			if (ChannelCount1 == 0) {
				Warnings.SpikeInUnrecognizedChannel++;
				continue;
			}

			bool KeepSpike = UnitIndex > 0 || (UnitIndex == 0 && KeepUnsortedUnits);

			if (KeepUnsortedUnits) 
				UnitIndex++; // because unsorted ones start at zero...


			if (KeepSpike && UnitIndex > 0 && UnitIndex <= NumUnitsPerChannel && ChannelCount1 >= 1 && ChannelCount1 <= NumChannels)  {
				SpikeCircularBuffer[x3] = ChannelCount1; // Channel
				SpikeCircularBuffer[x3+1] = UnitIndex;
				SpikeCircularBuffer[x3+2] = SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, iEntryIter+1,4)]; // TimeStamp

				LastKnownTS[ChannelCount1-1][UnitIndex-1] = SpikeCircularBuffer[x3+2];

				// Update Average Wave Forms...
				if (WaveForms != NULL) {
					int Cnt = WaveFormCounter[ChannelCount1-1][UnitIndex-1];

					assert(ChannelCount1-1 >= 0 && UnitIndex-1 >=0  && ChannelCount1-1 < NumChannels &&  UnitIndex-1 < NumUnitsPerChannel);
					if (Cnt == 0) {
						double NewValue;
						for (int WaveFormSample=0;WaveFormSample < NumDataPointsInWaveForm;WaveFormSample++) {
							NewValue = WaveForms[WaveFormSample*NumSpikeEntries +iEntryIter];
							
							WaveFormMean[ChannelCount1-1][UnitIndex-1][WaveFormSample] =
								1.0/double((Cnt+1)) * (Cnt*WaveFormMean[ChannelCount1-1][UnitIndex-1][WaveFormSample] + NewValue);

							WaveFormVarMk[ChannelCount1-1][UnitIndex-1][WaveFormSample] = NewValue;
							WaveFormVarSk[ChannelCount1-1][UnitIndex-1][WaveFormSample] = 0;
						}


					} else {
						double NewValue;
						for (int WaveFormSample=0;WaveFormSample < NumDataPointsInWaveForm;WaveFormSample++) {
							NewValue = WaveForms[WaveFormSample*NumSpikeEntries +iEntryIter];
							WaveFormMean[ChannelCount1-1][UnitIndex-1][WaveFormSample] =
								1.0/double((Cnt+1)) * (Cnt*WaveFormMean[ChannelCount1-1][UnitIndex-1][WaveFormSample] + NewValue);

							WaveFormVarMk[ChannelCount1-1][UnitIndex-1][WaveFormSample] += (NewValue - WaveFormVarMk[ChannelCount1-1][UnitIndex-1][WaveFormSample])/Cnt;
							WaveFormVarSk[ChannelCount1-1][UnitIndex-1][WaveFormSample] += (NewValue - WaveFormVarMk[ChannelCount1-1][UnitIndex-1][WaveFormSample])*(NewValue - WaveFormVarMk[ChannelCount1-1][UnitIndex-1][WaveFormSample]);
						}
					}

					WaveFormCounter[ChannelCount1-1][UnitIndex-1]++;
					//Mk = Mk-1+ (xk - Mk-1)/k 
					//Sk = Sk-1 + (xk - Mk-1)*(xk - Mk).
					//For 2 ≤ k ≤ n, the kth estimate of the variance is s2 = Sk/(k - 1).
				}
				SpikeCircularBufferSize_Pos++;

				if (SpikeCircularBufferSize_Pos == SpikeCircularBufferSize)
					SpikeCircularBufferSize_Pos = 0;
			}
		}

		if 	(!bSpikeEntry) {
			// Strobe Word entry (!)
			StrobeWordValue = (int)SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, iEntryIter+1,3)]; // Strobe word
			StrobeWordTimestamp = SpikeAndStrobeWordTable[MATLAB_TO_C(NumSpikeEntries, iEntryIter+1,4)]; // TimeStamp

			if ((StrobeWordValue < MAX_TRIAL_TYPE_STROBE_WORD) && bTrialInProgress) {
				// This strobe word actually indicates current trial type (!)
				Trials[CurrentTrialIndex].TrialType = StrobeWordValue; 
			}

			if (StrobeWordValue == Opt.TrialAlignCode) {
				if (!bTrialInProgress ) {
					// Output some warning
					// How can we align something if a trial is not in progress?
					Warnings.Miss_Assign++;
					
				} else {
					Trials[CurrentTrialIndex].AlignTo_TS = StrobeWordTimestamp;
				}
			}

			if (bTrialInProgress && Opt.NumOutcomes > 0) {
				for (int TrialOutcomeIter=0;TrialOutcomeIter<Opt.NumOutcomes;TrialOutcomeIter++) {
					if (StrobeWordValue == Opt.TrialOutcomesCodes[TrialOutcomeIter]) {
						Trials[CurrentTrialIndex].Outcome = StrobeWordValue;
					}
				}
			}
				 
			if (StrobeWordValue == Opt.TrialStartCode)  {

				if (bTrialInProgress ) { 
					// Oh oh.... problematic situation...
					// we should output a warning or something here...
					// We probably missed an END_TRIAL event, or it was never sent...
					Warnings.Miss_Stop++;
				}
				Trials[CurrentTrialIndex].Start_TS = StrobeWordTimestamp; 
				Trials[CurrentTrialIndex].CircularBufferPointer = SpikeCircularBufferSize_Pos; 

				if (LFP_Counter-1 < 0 )
					Trials[CurrentTrialIndex].LFPBufferPointer = MAX_LFP_POINTERS-1;
				else
					Trials[CurrentTrialIndex].LFPBufferPointer = LFP_Counter-1;

				bTrialInProgress = true;
				if (Opt.TrialAlignCode == 0)
					Trials[CurrentTrialIndex].AlignTo_TS = StrobeWordTimestamp; 

			}

			if (StrobeWordValue == Opt.TrialEndCode)  {

				if (!bTrialInProgress)   {
					// Not Good. We missed the start event.
					// Output some warning? And Ignore Trial
					Warnings.Miss_Start++;
				} else {

					Trials[CurrentTrialIndex].End_TS = StrobeWordTimestamp; 

					// Should we keep this trial or not ?!?!?)
					bTrialInProgress = false;
					bool bKeepTrial = false;
					if (Opt.NumKeepOutcomes == 0) {
						bKeepTrial = true;
					} else {
						for (int keep_iter=0;keep_iter < Opt.NumKeepOutcomes;keep_iter++)
							if (Trials[CurrentTrialIndex].Outcome == Opt.KeepTrialOutcomeCodes[keep_iter]) {
								bKeepTrial = true;
								break;
							}

					}
		
					if (Trials[CurrentTrialIndex].End_TS - Trials[CurrentTrialIndex].Start_TS > 1.1*TrialLengthSec) {
						// ahh.. this is not good. What should we do now? Discard the trial?
						Warnings.Miss_TrialLength++;
						bKeepTrial = false;
						ZeroOutTrial(CurrentTrialIndex);
					}


					if (bKeepTrial) {

						TrialsAlive[TrialsAliveCounter] = CurrentTrialIndex;
						if (TrialsAliveCounter >= NumTrials-1) {
						// we collected more alive trials than our buffer can hold...
							// get rid of 
							// do not increase the alive counter
							Warnings.Miss_Trial_BufferTooSmall++;
						} else {
							TrialsAliveCounter++;
						}

						CurrentTrialIndex++;
						if (CurrentTrialIndex >= NumTrials-1)
							CurrentTrialIndex  = 0;

						// Zero out next Trial Data
						ZeroOutTrial(CurrentTrialIndex);	
					} else {
						Warnings.Miss_NotKept++;
					}
				}
			}


		}

	}


	// Second - handle strobe words...
	int LastDead = 0;
	int NumAlive = TrialsAliveCounter;
	for (int TrialAliveIter=0; TrialAliveIter<NumAlive ;TrialAliveIter++) {
		if (TrialsAlive[TrialAliveIter] >= 0) {

			int TrialIndex = TrialsAlive[TrialAliveIter];
			double TrialEndTS = Trials[TrialIndex].End_TS;
			double TrialAlignToTS = Trials[TrialIndex].AlignTo_TS;
			double TrialStartTS = Trials[TrialIndex].Start_TS;
			if (LastKnownTimeStamp > TrialEndTS+Post_TimeSec) {
				// Now comes the hard part...
				// Use the circular buffer to update the trial buffer...

				TotalTrialCounter++;

				if (fnUpdateTrialAnalog(TrialIndex, TrialStartTS,TrialEndTS,TrialAlignToTS)) {
					fnUpateTrialSpikes(TrialIndex, TrialStartTS,TrialEndTS,TrialAlignToTS);
					fnUpdateTrialStatistics(TrialIndex);
					Trials[TrialIndex].bHasValues = true;
				} else {
					// Degenerate case - statistics server was not initiated early enough, so we don't have any A/D data on this trial
					Warnings.Miss_AnalogPacket++;
				}

				
				// Delete Trial Alive
				TrialsAlive[TrialAliveIter] = -1;
				TrialsAliveCounter--;
				assert(TrialsAliveCounter>=0);
			}
		}
	}

	// Shift Alive Vector
	int OpenSpace = 0;
	for (int k=0;k<NumAlive;k++) {
		if (TrialsAlive[k] == -1) {
			OpenSpace = k;
		} 		else {
			TrialsAlive[OpenSpace] = TrialsAlive[k];
		}
	}

}

void GetRasterCell(int Condition, mxArray *plhs[]) {
	mxArray* Cell = mxCreateCellMatrix(NumChannels, NumUnitsPerChannel);
	for (int Ch=0;Ch<NumChannels;Ch++) {
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {

			mxArray *TrialsAndSpikes = mxCreateCellMatrix(1, NumValidTrialsInBuf[Ch][Unit][Condition]);



			for (int TrialIter=0; TrialIter < NumValidTrialsInBuf[Ch][Unit][Condition]; TrialIter++) {
				int TrialPtr = ConditionToTrials[Ch][Unit][Condition][TrialIter];
				int NumSpikes = Trials[TrialPtr].NumSpikes[Ch][Unit];

				const mwSize dim[2]={1,NumSpikes};
				mxArray *TrialSpikes = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
				double *TmpV = mxGetPr(TrialSpikes);
				for (int k=0;k<NumSpikes;k++) {
					TmpV[k] = Trials[TrialPtr].SpikeTimes[Ch][Unit][k];
				}

				mxSetCell(TrialsAndSpikes, TrialIter, TrialSpikes);
			}

			mxSetCell(Cell, Unit*NumChannels+Ch, TrialsAndSpikes);
		}
	}

	plhs[0] = Cell;
}



void GetRasterForPlot(int Condition, mxArray *plhs[]) {
	mxArray* Cell = mxCreateCellMatrix(NumChannels, NumUnitsPerChannel);
	for (int Ch=0;Ch<NumChannels;Ch++) {
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {

			int TotalNumberOfSpikesInAllTrials = 0;
			for (int TrialIter=0; TrialIter < NumValidTrialsInBuf[Ch][Unit][Condition]; TrialIter++) {
				int TrialPtr = ConditionToTrials[Ch][Unit][Condition][TrialIter];
				int NumSpikes = Trials[TrialPtr].NumSpikes[Ch][Unit];
				TotalNumberOfSpikesInAllTrials += NumSpikes;
			}

			const mwSize dim[2]={TotalNumberOfSpikesInAllTrials,2};
			mxArray *AllTrialsSpikes = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
			double *TmpV = mxGetPr(AllTrialsSpikes);
			int Index = 0;
			for (int TrialIter=0; TrialIter < NumValidTrialsInBuf[Ch][Unit][Condition]; TrialIter++) {
				int TrialPtr = ConditionToTrials[Ch][Unit][Condition][TrialIter];
				int NumSpikes = Trials[TrialPtr].NumSpikes[Ch][Unit];
				
				assert(NumSpikes <= MaxNumSpikesPerUnitPerTrial);
				for (int SpikeIter=0;SpikeIter<NumSpikes;SpikeIter++,Index++) {
					TmpV[Index] = Trials[TrialPtr].SpikeTimes[Ch][Unit][SpikeIter];
					TmpV[Index+TotalNumberOfSpikesInAllTrials] = TrialIter+1;
				}
			}

			mxSetCell(Cell, Unit*NumChannels+Ch, AllTrialsSpikes);
		}
	}

	plhs[0] = Cell;
}


void fnGetRealTimePSTH(int nlhs, mxArray *plhs[]) {

	// Allocate Spikes PSTH
	const mwSize dim_spikes[4]={Opt.NumPSTHBins,Opt.NumConditions,NumUnitsPerChannel,NumChannels};
	plhs[0] = mxCreateNumericArray(4, dim_spikes, mxDOUBLE_CLASS, mxREAL);
	double *mxPSTH_Spikes = mxGetPr(plhs[0]);

	for (int Ch=0;Ch<NumChannels;Ch++) {
		int ChannelOffset = Ch*NumUnitsPerChannel*Opt.NumConditions*Opt.NumPSTHBins;
		for (int Unit=0;Unit < NumUnitsPerChannel; Unit++) {
			int UnitOffset = Unit*Opt.NumConditions*Opt.NumPSTHBins;
			for (int Con=0;Con<Opt.NumConditions;Con++) {
				int ConditionOffset = Con * Opt.NumPSTHBins;
				for (int Bin=0; Bin<Opt.NumPSTHBins;Bin++) {
					int Index = ChannelOffset + UnitOffset + ConditionOffset + Bin;
					mxPSTH_Spikes[Index]=PSTH_Spikes[Ch][Unit][Con][Bin];
				}
			}
		}
	}

	// Allocate LFP PSTH
	const mwSize dim_lfp[3]={Opt.NumLFPBins,Opt.NumConditions,NumChannels};
	plhs[1] = mxCreateNumericArray(3, dim_lfp, mxDOUBLE_CLASS, mxREAL);
	double *mxPSTH_LFP = mxGetPr(plhs[1]);

	for (int Ch=0;Ch<NumChannels;Ch++) {
		int ChannelOffset = Ch*Opt.NumConditions*Opt.NumLFPBins;
		for (int Con=0;Con<Opt.NumConditions;Con++) {
			int ConditionOffset = Con*Opt.NumLFPBins;
			for (int Bin=0; Bin<Opt.NumLFPBins;Bin++) {
				int Index = ChannelOffset + Bin + ConditionOffset;
				mxPSTH_LFP[Index]=PSTH_LFP[Ch][Con][Bin];
			}
		}
	}

	// Allocate LFP PSTH
	const mwSize dim_lfptime[2]={1, Opt.NumLFPBins};
	plhs[2] = mxCreateNumericArray(2, dim_lfptime, mxDOUBLE_CLASS, mxREAL);
	double *mxLFPTime = mxGetPr(plhs[2]);
	for (int k=0;k<Opt.NumLFPBins;k++)
		mxLFPTime[k] = Opt.LFP_BinTimes[k];


	const mwSize dim_bintime[2]={1, Opt.NumPSTHBins};
	plhs[3] = mxCreateNumericArray(2, dim_bintime, mxDOUBLE_CLASS, mxREAL);
	double *mxSpikeTime = mxGetPr(plhs[3]);
	for (int k=0;k<Opt.NumPSTHBins;k++)
		mxSpikeTime[k] = Opt.BinTimes[k];


	// Allocate Wave Form Avg and Std
	const mwSize dim_wave[3]={NumDataPointsInWaveForm,NumUnitsPerChannel,NumChannels};
	plhs[4] = mxCreateNumericArray(3, dim_wave, mxDOUBLE_CLASS, mxREAL);
	double *mxWaveAvg = mxGetPr(plhs[4]);
	plhs[5] = mxCreateNumericArray(3, dim_wave, mxDOUBLE_CLASS, mxREAL);
	double *mxWaveVar = mxGetPr(plhs[5]);

	for (int Ch=0;Ch<NumChannels;Ch++) {
		int ChannelOffset = Ch*NumUnitsPerChannel*NumDataPointsInWaveForm;
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
			int UnitOffset = Unit*NumDataPointsInWaveForm;
			for (int Sample=0;Sample < NumDataPointsInWaveForm;Sample++) {
				assert(ChannelOffset+UnitOffset+Sample >= 0 && ChannelOffset+UnitOffset+Sample < NumDataPointsInWaveForm*NumUnitsPerChannel*NumChannels);
				mxWaveAvg[	ChannelOffset+UnitOffset+Sample]=WaveFormMean[Ch][Unit][Sample];
				mxWaveVar[	ChannelOffset+UnitOffset+Sample]=WaveFormVarSk[Ch][Unit][Sample] / (WaveFormCounter[Ch][Unit]);
			}
		}
	}


		//Mk = Mk-1+ (xk - Mk-1)/k 
				//Sk = Sk-1 + (xk - Mk-1)*(xk - Mk).
				//For 2 ≤ k ≤ n, the kth estimate of the variance is s2 = Sk/(k - 1).


}

/*
void fnGetPSTH(int Channel, int Unit, bool* TrialToCategoryMatrix, int NumTrialTypes, int NumCategories,
			   double *Outcomes, int Numoutcomes, double fBinSizeMS, double PreAlign_Sec, double PostAlign_Sec, int nlhs, mxArray *plhs[]) {

	// First, how many bins?

	double TimeInterval = PreAlign_Sec+ PostAlign_Sec;
	double BinSizeSec = fBinSizeMS/1e3;
	int NumBins = (int)ceil(TimeInterval / BinSizeSec);
	double *BinTimes  = new double[NumBins];


	int NumBinsBefore = 0;
	const mwSize dim[2]={1,NumBins};
	plhs[0] = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
	double *OutputPeri = mxGetPr(plhs[0]);

	double BinTime;
	for (int BinIter=0;BinIter<NumBins-1;BinIter++) {
		BinTime=-PreAlign_Sec + BinIter*TimeInterval/(NumBins-1);
		NumBinsBefore+=BinTime<0;
		BinTimes[BinIter] = BinTime;
		OutputPeri[BinIter] = BinTimes[BinIter];
	}
	BinTimes[NumBins-1] = PostAlign_Sec;
	OutputPeri[NumBins-1] = PostAlign_Sec;


	// Allocate PSTH
	const mwSize dim1[2]={NumCategories,NumBins};
	plhs[1] = mxCreateNumericArray(2, dim1, mxDOUBLE_CLASS, mxREAL);
	double *PSTH = mxGetPr(plhs[1]);

	const mwSize dim2[2]={1,NumCategories};
	plhs[2] = mxCreateNumericArray(2, dim2, mxDOUBLE_CLASS, mxREAL);
	double *NumValidTrialsForThisCondition = mxGetPr(plhs[2]);
	for (int k=0;k<NumCategories;k++)
		NumValidTrialsForThisCondition[k] = 0;



					// Update Spiking Average
	int *NumSpikesPerBin = new int[NumBins];
	
	// Allocate LFP PSTH
	plhs[3] = mxCreateNumericArray(2, dim1, mxDOUBLE_CLASS, mxREAL);
	double *LFP_PSTH = mxGetPr(plhs[3]);
	// Zero out 
	for (int k=0;k<NumCategories*NumBins;k++) {
		PSTH[k] = 0;
		LFP_PSTH[k] = 0;
	}
	// Compute PSTH
	int NumValidTrials = NumValidTrialsUnit[Channel][Unit];

	for (int k=0; k<NumValidTrials;k++) {
		int TrialIndex = CurrentTrialIndex-1-k;
		if (TrialIndex < 0) TrialIndex += NumTrials;

		bool bCorrectOutcome=false;
		if (Numoutcomes == 0)  {
			bCorrectOutcome = true;
		} else {
			for (int outcome_iter=0;outcome_iter<Numoutcomes;outcome_iter++) {
				if ((int)Outcomes[outcome_iter] == Trials[TrialIndex].Outcome) {
					bCorrectOutcome = true;
					break;
				}
			}
		}

		if ((Trials[TrialIndex].TrialType > 0)  && (bCorrectOutcome) ) {
			for (int iCatIter=0;iCatIter < NumCategories;iCatIter++) {
				int TrialCategoryIndex = MATLAB_TO_C(NumTrialTypes,Trials[TrialIndex].TrialType,iCatIter+1);
				if (TrialToCategoryMatrix[TrialCategoryIndex]) {
					NumValidTrialsForThisCondition[iCatIter]++;


					// Zero out bin counter
					for (int k=0;k<NumBins;k++) NumSpikesPerBin[k] = 0;

					// Count how many spikes in each bin
					for (int SpikeIter = 0;SpikeIter < Trials[TrialIndex].NumSpikes[Channel][Unit];SpikeIter++) {
						int MatchedBin = NumBinsBefore+(int) floor(Trials[TrialIndex].SpikeTimes[Channel][Unit][SpikeIter] / BinSizeSec);
						if (MatchedBin >=0 && MatchedBin < NumBins) {
							NumSpikesPerBin[MatchedBin]++;
						}
					}

					// Update firing rate
					for (int BinIter=0;BinIter<NumBins;BinIter++) {
							int PSTH_Index = MATLAB_TO_C(NumCategories, iCatIter+1, BinIter+1);
							PSTH[PSTH_Index] = ((NumValidTrialsForThisCondition[iCatIter]-1)*PSTH[PSTH_Index] + NumSpikesPerBin[BinIter]) / NumValidTrialsForThisCondition[iCatIter];
					}

					// Update Analog Average....
					double SamplingOffset = Trials[TrialIndex].AlignTo_TS-Trials[TrialIndex].Start_TS;
					double Time0 = Trials[TrialIndex].Start_TS-Pre_TimeSec;


					for (int iBinIter=0;iBinIter<NumBins;iBinIter++) {
						// Linear interpolate at the given values bin times (relative to alignment?)
						double fSamplingTime = Trials[TrialIndex].Start_TS+BinTimes[iBinIter] + SamplingOffset;
						// Which LFP bin is the left value and which is the right?
						double ExactLeftIndex = (fSamplingTime - Time0) * LFP_Stored_Freq;
						int LeftIndex = (int) floor(ExactLeftIndex);
						double DeltaTime = ExactLeftIndex-double(LeftIndex);
						int RightIndex = LeftIndex + 1;
						if (LeftIndex >= 0 && RightIndex < NumSamplesInTrialLFPBuffer) {
							double LeftValue = Trials[TrialIndex].LFP[Channel][LeftIndex];
							double RightValue = Trials[TrialIndex].LFP[Channel][RightIndex];
							double InterpolatedValue = LeftValue+DeltaTime*(RightValue-LeftValue);
							int PSTH_Index = MATLAB_TO_C(NumCategories, iCatIter+1, iBinIter+1);
							LFP_PSTH[PSTH_Index] = ((NumValidTrialsForThisCondition[iCatIter]-1)*LFP_PSTH[PSTH_Index] + InterpolatedValue) / NumValidTrialsForThisCondition[iCatIter];


						}
					    

					}


				}
			}
		}
	}


	delete [] BinTimes;
}
*/


double* LinSpace(double PreAlign_Sec, double PostAlign_Sec, double fBinSizeMS, int &NumBins) {
	double TimeInterval = PreAlign_Sec+ PostAlign_Sec;
	double BinSizeSec = fBinSizeMS/1e3;
	NumBins = (int)ceil(TimeInterval / BinSizeSec);
	double *BinTimes  = new double[NumBins];

	for (int BinIter=0;BinIter<NumBins-1;BinIter++) {
		BinTimes[BinIter] = -PreAlign_Sec + BinIter*TimeInterval/(NumBins-1);;
	} 

	BinTimes[NumBins-1] = PostAlign_Sec;
	return BinTimes;
}


void SetOpt(int nrhs, const mxArray *prhs[] )  {
	
	mxArray *Tmp;

	ReleasePSTHBuffers();


	Tmp = mxGetField(prhs[1],0,"TrialStartCode");
	if (Tmp != NULL)
		Opt.TrialStartCode = (int)*(double*)mxGetPr(Tmp);

	Tmp = mxGetField(prhs[1],0,"TrialEndCode");
	if (Tmp != NULL)
		Opt.TrialEndCode = (int)*(double*)mxGetPr(Tmp);

	Tmp = mxGetField(prhs[1],0,"TrialAlignCode");
	if (Tmp != NULL)
		Opt.TrialAlignCode = (int)*(double*)mxGetPr(Tmp);

	Tmp = mxGetField(prhs[1],0,"TrialOutcomesCodes");
	if (Tmp != NULL) {
		Opt.NumOutcomes = mxGetNumberOfElements(Tmp);
		double *TmpV = mxGetPr(Tmp);
		Opt.TrialOutcomesCodes = (int*) malloc(sizeof(int)*Opt.NumOutcomes);
		for (int k=0;k<Opt.NumOutcomes;k++) 
			Opt.TrialOutcomesCodes[k] = (int) TmpV[k];
	}
	
	Tmp = mxGetField(prhs[1],0,"KeepTrialOutcomeCodes");
	if (Tmp != NULL) {
		Opt.NumKeepOutcomes = mxGetNumberOfElements(Tmp);
		double *TmpV = mxGetPr(Tmp);
		Opt.KeepTrialOutcomeCodes= (int*) malloc(sizeof(int)*Opt.NumKeepOutcomes);
		for (int k=0;k<Opt.NumKeepOutcomes;k++) 
			Opt.KeepTrialOutcomeCodes[k] = (int) TmpV[k];
	}


	Tmp = mxGetField(prhs[1],0,"TrialTypeToConditionMatrix");
	if (Tmp != NULL) {

		const mwSize *dim = mxGetDimensions(Tmp);
		Opt.NumConditions = dim[1];
		Opt.NumTrialTypes = dim[0];

		if (mxIsDouble(Tmp)) {
			double *TmpV = mxGetPr(Tmp);
			Opt.TrialTypeToConditionMatrix = (bool*) malloc(Opt.NumConditions*Opt.NumTrialTypes * sizeof(bool));
			for (int k=0;k<Opt.NumConditions*Opt.NumTrialTypes;k++)
				Opt.TrialTypeToConditionMatrix[k] = TmpV[k] > 0;
		} else if (mxIsLogical(Tmp)) {
			bool *TmpV = (bool*) mxGetPr(Tmp);
			Opt.TrialTypeToConditionMatrix = (bool*) malloc(Opt.NumConditions*Opt.NumTrialTypes * sizeof(bool));
			for (int k=0;k<Opt.NumConditions*Opt.NumTrialTypes;k++)
				Opt.TrialTypeToConditionMatrix[k] = TmpV[k];
		}

		ConditionToTrials = (int****) malloc(NumChannels * sizeof(int ***));
		for (int Ch=0;Ch<NumChannels;Ch++) {
			ConditionToTrials[Ch] = (int***) malloc(NumUnitsPerChannel * sizeof(int **));
			for (int Unit=0;Unit < NumUnitsPerChannel;Unit++) {
				ConditionToTrials[Ch][Unit] = (int **) malloc( Opt.NumConditions * sizeof(int*));
				for (int Condition=0;Condition<Opt.NumConditions;Condition++) {
					ConditionToTrials[Ch][Unit][Condition] = (int *) malloc( NumTrials * sizeof(int));
					for (int PtrIter=0;PtrIter < NumTrials;PtrIter++) {
						ConditionToTrials[Ch][Unit][Condition][PtrIter] = -1;
					}
				}
			}
		}

	}

	Tmp = mxGetField(prhs[1],0,"ConditionOutcomeFilter");
	if (Tmp != NULL) {
		int NumCond = mxGetNumberOfElements(Tmp);
		if ((NumCond != Opt.NumConditions) || (!mxIsCell(Tmp)) ) {
			mexPrintf("Number of cells does not match number of conditions!");
			return;
		}

		Opt.ConditionOutcomeFilter = (int**) malloc(Opt.NumConditions * sizeof(int*));
		Opt.NumConditionOutcomeFilters = (int*) malloc(Opt.NumConditions * sizeof(int)); 
		
		for (int Condition=0;Condition<Opt.NumConditions;Condition++) {
			mxArray *Cond = mxGetCell(Tmp, Condition);
			if (Cond == NULL) {
				Opt.NumConditionOutcomeFilters[Condition] = 0;
				Opt.ConditionOutcomeFilter[Condition] = NULL;
			}  else {
				Opt.NumConditionOutcomeFilters[Condition] = mxGetNumberOfElements(Cond);
				Opt.ConditionOutcomeFilter[Condition] = (int*)malloc(Opt.NumConditionOutcomeFilters[Condition] * sizeof(int));
				double *TmpV = mxGetPr(Cond);
				for (int k=0;k<Opt.NumConditionOutcomeFilters[Condition];k++) {
					Opt.ConditionOutcomeFilter[Condition][k] = (int)TmpV[k];
				}
			}
		}
	}


	Tmp = mxGetField(prhs[1],0,"PSTH_BinSizeMS");
	if (Tmp != NULL)
		Opt.PSTH_BinSizeMS = (int)*(double*)mxGetPr(Tmp);

	Tmp = mxGetField(prhs[1],0,"LFP_ResolutionMS");
	if (Tmp != NULL)
		Opt.LFP_ResolutionMS = (int)*(double*)mxGetPr(Tmp);


	if (Opt.PSTH_BinSizeMS > 0) {
		Opt.BinTimes = LinSpace(Pre_TimeSec, TrialLengthSec+Post_TimeSec, Opt.PSTH_BinSizeMS, Opt.NumPSTHBins);
	}

	if (Opt.LFP_ResolutionMS > 0) {
		Opt.LFP_BinTimes = LinSpace(Pre_TimeSec, TrialLengthSec+Post_TimeSec, Opt.LFP_ResolutionMS, Opt.NumLFPBins);
	}


	NumValidTrials = (int***)malloc(NumChannels* sizeof(int**));
	for (int Ch=0;Ch<NumChannels;Ch++) {
		NumValidTrials[Ch] = (int**) malloc(NumUnitsPerChannel * sizeof(int*));
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
			NumValidTrials[Ch][Unit] = (int*) malloc(Opt.NumConditions * sizeof(int));
			for (int Con=0;Con<Opt.NumConditions;Con++) {
				NumValidTrials[Ch][Unit][Con] = 0;
			}
		}
	}


	NumValidTrialsCh = (int**) malloc(NumChannels * sizeof(int*));
	for (int Ch=0;Ch<NumChannels;Ch++) {
		NumValidTrialsCh[Ch] = (int*) malloc(Opt.NumConditions * sizeof(int));
		for (int Con=0;Con<Opt.NumConditions;Con++) {
			NumValidTrialsCh[Ch][Con] = 0;
		}
	}


NumValidTrialsInBuf = (int***)malloc(NumChannels* sizeof(int**));
	for (int Ch=0;Ch<NumChannels;Ch++) {
		NumValidTrialsInBuf[Ch] = (int**) malloc(NumUnitsPerChannel * sizeof(int*));
		for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
			NumValidTrialsInBuf[Ch][Unit] = (int*) malloc(Opt.NumConditions * sizeof(int));
			for (int Con=0;Con<Opt.NumConditions;Con++) {
				NumValidTrialsInBuf[Ch][Unit][Con] = 0;
			}
		}
	}


	NumValidTrialsChInBuf = (int**) malloc(NumChannels * sizeof(int*));
	for (int Ch=0;Ch<NumChannels;Ch++) {
		NumValidTrialsChInBuf[Ch] = (int*) malloc(Opt.NumConditions * sizeof(int));
		for (int Con=0;Con<Opt.NumConditions;Con++) {
			NumValidTrialsChInBuf[Ch][Con] = 0;
		}
	}


	if (Opt.NumConditions > 0 && Opt.NumPSTHBins > 0) {
		// Allocate memory for average spike count
		PSTH_Spikes  = (double ****) malloc(NumChannels * sizeof(double***));
		for (int Ch=0;Ch<NumChannels;Ch++) {
			PSTH_Spikes[Ch] = (double ***) malloc(NumUnitsPerChannel * sizeof(double**));
			for (int Unit=0;Unit < NumUnitsPerChannel; Unit++) {
				PSTH_Spikes[Ch][Unit] = (double **) malloc(Opt.NumConditions * sizeof(double*));
				for (int CatIter=0;CatIter < Opt.NumConditions; CatIter++) {
					PSTH_Spikes[Ch][Unit][CatIter] = (double *) malloc(Opt.NumPSTHBins * sizeof(double));
					for (int BinIter=0;BinIter<Opt.NumPSTHBins;BinIter++) {
						PSTH_Spikes[Ch][Unit][CatIter][BinIter] = 0;
					}
				}
			}
		}
		// Allocate memory for average LFP 
		PSTH_LFP  = (double ***) malloc(NumChannels * sizeof(double**));
		for (int Ch=0;Ch<NumChannels;Ch++) {
			PSTH_LFP[Ch] = (double **) malloc(Opt.NumConditions * sizeof(double*));
			for (int CatIter=0;CatIter < Opt.NumConditions; CatIter++) {
				PSTH_LFP[Ch][CatIter] = (double *) malloc(Opt.NumLFPBins * sizeof(double));
				for (int BinIter=0;BinIter<Opt.NumLFPBins;BinIter++) {
					PSTH_LFP[Ch][CatIter][BinIter] = 0;
				}
			}
		}
	}

	TrialTypeCounter = (int*) malloc(sizeof(int)*Opt.NumTrialTypes);
	for (int k=0;k<Opt.NumTrialTypes;k++)
		TrialTypeCounter[k] = 0;

	ConditionCounter  = (int*) malloc(sizeof(int)*Opt.NumConditions);
	for (int k=0;k<Opt.NumConditions;k++)
		ConditionCounter[k] = 0;



	NumSpikesPerPSTHBin = (int*) malloc(sizeof(int)*Opt.NumPSTHBins);

}


void GetCounters(int nlhs, mxArray *plhs[]) {

	const char *field_names[] = {"TrialTypeCounter", "ConditionCounter"};
	const int NUMBER_OF_FIELDS = 2;
	const int NUMBER_OF_STRUCTS  = 1;
    mwSize dims[2] = {1, NUMBER_OF_STRUCTS };
	plhs[0] = mxCreateStructArray(2, dims, NUMBER_OF_FIELDS, field_names);

	mxArray *Tmp;
	double *TmpV;

	mwSize dim_trialtype[2] = {1,Opt.NumTrialTypes};
	Tmp = mxCreateNumericArray(2, dim_trialtype, mxDOUBLE_CLASS, mxREAL);
	TmpV = mxGetPr(Tmp);
	for (int k=0;k<Opt.NumTrialTypes;k++)
		TmpV[k] = TrialTypeCounter[k];
	mxSetFieldByNumber(plhs[0],0, 0, Tmp);


	mwSize dim_condition[2] = {1,Opt.NumConditions};
	Tmp = mxCreateNumericArray(2, dim_condition, mxDOUBLE_CLASS, mxREAL);
	TmpV = mxGetPr(Tmp);
	for (int k=0;k<Opt.NumConditions;k++)
		TmpV[k] = ConditionCounter[k];
	mxSetFieldByNumber(plhs[0],0, 1, Tmp);

}
mxArray* mxCreateScalarDouble(double Scalar) {
	mwSize dims[1] = {1};
	mxArray *Tmp = mxCreateNumericArray(1, dims, mxDOUBLE_CLASS, mxREAL);
	double *P = mxGetPr(Tmp);
	*P = Scalar;
	return Tmp;
}

void GetOpt(int nlhs, mxArray *plhs[]) {
	

    const char *field_names[] = {"TrialStartCode", "TrialEndCode","TrialAlignCode",
		"TrialOutcomesCodes","KeepTrialOutcomeCodes", "TrialTypeToConditionMatrix",
		"PSTH_BinSizeMS","LFP_ResolutionMS","ConditionOutcomeFilter"};

	const int NUMBER_OF_FIELDS = 9;
	const int NUMBER_OF_STRUCTS  = 1;
    mwSize dims[2] = {1, NUMBER_OF_STRUCTS };

	plhs[0] = mxCreateStructArray(2, dims, NUMBER_OF_FIELDS, field_names);

	mxArray *Tmp;
	double *TmpV;

	mxSetFieldByNumber(plhs[0],0, 0, mxCreateScalarDouble(Opt.TrialStartCode));
	mxSetFieldByNumber(plhs[0],0, 1, mxCreateScalarDouble(Opt.TrialEndCode));
	mxSetFieldByNumber(plhs[0],0, 2, mxCreateScalarDouble(Opt.TrialAlignCode));


	mwSize dim_outcome[2] = {1,Opt.NumOutcomes};
	Tmp = mxCreateNumericArray(2, dim_outcome, mxDOUBLE_CLASS, mxREAL);
	TmpV = mxGetPr(Tmp);
	for (int k=0;k<Opt.NumOutcomes;k++)
		TmpV[k] = Opt.TrialOutcomesCodes[k];
	mxSetFieldByNumber(plhs[0],0, 3, Tmp);


	mwSize dim_keepoutcome[2] = {1,Opt.NumKeepOutcomes};
	Tmp = mxCreateNumericArray(2, dim_keepoutcome, mxDOUBLE_CLASS, mxREAL);
	TmpV = mxGetPr(Tmp);
	for (int k=0;k<Opt.NumKeepOutcomes;k++)
		TmpV[k] = (double) Opt.KeepTrialOutcomeCodes[k];
	mxSetFieldByNumber(plhs[0],0, 4, Tmp);


	mwSize dim_trialcon[2] = {Opt.NumTrialTypes,Opt.NumConditions};
	Tmp = mxCreateNumericArray(2, dim_trialcon, mxLOGICAL_CLASS, mxREAL);
	bool *TmpB = (bool*) mxGetPr(Tmp);
	for (int k=0;k<Opt.NumConditions*Opt.NumTrialTypes;k++)
			TmpB[k] = Opt.TrialTypeToConditionMatrix[k];
	mxSetFieldByNumber(plhs[0],0, 5, Tmp);


	mxSetFieldByNumber(plhs[0],0, 6, mxCreateScalarDouble(Opt.PSTH_BinSizeMS));
	mxSetFieldByNumber(plhs[0],0, 7, mxCreateScalarDouble(Opt.LFP_ResolutionMS));

	mxArray *mxTmpCell = mxCreateCellMatrix(1, Opt.NumConditions);
	for (int Cond=0;Cond<Opt.NumConditions;Cond++) {

		if (Opt.ConditionOutcomeFilter[Cond] != NULL) {
			mwSize dim[2] = {1, Opt.NumConditionOutcomeFilters[Cond]};
			mxArray *mxTmpArray  = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
			double *TmpV = mxGetPr(mxTmpArray);
			for (int k=0;k<Opt.NumConditionOutcomeFilters[Cond];k++) {
				TmpV[k] = Opt.ConditionOutcomeFilter[Cond][k];
			}
			mxSetCell(mxTmpCell, Cond, mxTmpArray);
		}
	}

	mxSetFieldByNumber(plhs[0],0, 8, mxTmpCell);




	/*
	mwSize dim_psthoutcome[2] = {1,Opt.NumPSTH_Outcomes};
	Tmp = mxCreateNumericArray(2, dim_psthoutcome, mxDOUBLE_CLASS, mxREAL);
	TmpV = mxGetPr(Tmp);
	for (int k=0;k<Opt.NumPSTH_Outcomes;k++)
		TmpV[k] = (double) Opt.PSTH_Outcomes[k];
	mxSetFieldByNumber(plhs[0],0, 8, Tmp);
*/

}




void GetUnitsTrialCounter(int nlhs, mxArray *plhs[]) {
	mwSize dim[2] = {NumChannels,NumUnitsPerChannel};
	plhs[0] = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
	double *TmpV = mxGetPr(plhs[0]);
	for (int Channel=0;Channel < NumChannels; Channel++) {
		for (int Unit=0;Unit < NumUnitsPerChannel; Unit++) {
			TmpV[Unit*NumChannels +Channel] = TrialCounter[Channel][Unit];
		}
	}
		
}

void GetUnitsLastKnownTS(int nlhs, mxArray *plhs[]) {
	mwSize dim[2] = {NumChannels,NumUnitsPerChannel};
	plhs[0] = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
	double *TmpV = mxGetPr(plhs[0]);
	for (int Channel=0;Channel < NumChannels; Channel++) {
		for (int Unit=0;Unit < NumUnitsPerChannel; Unit++) {
			TmpV[Unit*NumChannels +Channel] = LastKnownTS[Channel][Unit];
		}
	}
	plhs[1] = mxCreateScalarDouble(LastKnownTimeStamp);
		
}

/*
void GetChannelNames(int nlhs, mxArray *plhs[]) {
  int freq[64],channels[64],gains[64];
  PL_GetSlowInfo64(freq, channels, gains);

  bool ActiveChannels[64];
  int NumActive = 0;
  for (int k=0;k<64;k++) {
	  ActiveChannels[k] = channels[k] > 0;
	  NumActive+=ActiveChannels[k];
  }
  
  mxArray *mxTmpCell = mxCreateCellMatrix(1, 64);

  char name[1000];
  for (int j=0;j<64;j++) {
	  //PL_GetName(1+j, name);
	  PL_GetSlowChanName(1+j, name);

	  mxSetCell(mxTmpCell, j, mxCreateString(name));
  }

  plhs[0] = mxTmpCell;

}
*/

/* Entry Points */
void mexFunction( int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[] ) 
{

	// Operations:
	// SetOpt (AlignSpikesTo, StartTrialCode, EndTrialCode, SpikesAlignCode)					 
	// Allocate (#Channels, #Units per Channel, LFP_Sampled_Freq, LFP_Stored_Freq, #Trials, Trial_Length_Sec, PreTime_Sec, PostTime_Sec)
	// Release
	// UpdatePlexon (Spike,StrobeWord, AD)
	// ResetTrialUnit (Ch, Unit)
	// GetRaster(Channel, Unit, Trial Type)
	// GetRasterCell(Channel, Unit, Trial Type)

	// [a2fPSTH, afBinTime] = GetPSTH(Channel, Unit, a2bTrialToCategoryMatrix[Trial_Type x Category], Bin_Size_Ms)

	// ResetAD (Ch)
	// GetPSTH(Channel, Unit, Trial_Type)
	// GetAverageFiringRate(Channel, Unit, Trial_Type, Start_Avg_Time, End_Avg_Time)					 
	// GetLFP(Channel, Trial_Type)


//	SafeArray<SafeArray<int>> X;

	//SafeArrayDouble X;

	static char buff[80+1];
	buff[0]=0;
	mxGetString(prhs[0],buff,80);
/*

	if (strcmp(buff,"InitPlexon") == 0) {
		int res = PL_InitClientEx3(0, NULL, NULL);
		PlexonInitialized = true;
		plhs[0] = mxCreateScalarDouble(res);
		if (res==1) {
			int freq[64],channels[64],gains[64];
			PL_GetSlowInfo64(freq, channels, gains);
			LFP_Freq = freq[0];
		}
		return;
	}

	if (strcmp(buff,"GetChannelNames") == 0) {
		if (!PlexonInitialized) {
			mexPrintf("Please Initialize Plexon first!");
			return;
		}
		GetChannelNames(nlhs,plhs);
		return;
	}


	if (strcmp(buff,"GetTimeStampTick") == 0) {
		if (!PlexonInitialized) {
			mexPrintf("Please Initialize Plexon first!");
			return;
		}
		plhs[0] = mxCreateScalarDouble(PL_GetTimeStampTick());
		return;
	}	*/

	if (strcmp(buff,"GetLastKnownTimestamp") == 0) {
			plhs[0] = mxCreateScalarDouble(LastKnownTimeStamp);
		return;
	}	


	if (strcmp(buff,"UpdateTimeStamp") == 0)  {

		// Plexon Style Update
		const mwSize *dim1 = mxGetDimensions(prhs[1]);
		int NumSpikeEntries = dim1[0]; 
		double *SpikeAndStrobeWordTable = (double*)mxGetPr(prhs[1]);

		double *AnalogChannelsData = (double*)mxGetPr(prhs[2]);
		const mwSize *dim2 = mxGetDimensions(prhs[2]);
		int NumAnalogEntries = dim2[0]; 
		int NumChannelsToUpdate = dim2[1]; 
		double *AnalogTime0 = (double*)mxGetPr(prhs[3]);

		UpdateTimeStamp(NumSpikeEntries,SpikeAndStrobeWordTable, AnalogChannelsData, NumAnalogEntries, AnalogTime0);
		return;
	}


	if (strcmp(buff,"Allocate") == 0)  {
		if (nrhs != 10) {
			mexPrintf("Use TrialCircularBuffer('Allocate',aiChannels, NumUnitsPerChannel, LFP_Sampled_Freq, LFP_Stored_Freq, NumTrialsInCircularBuffer, TrialLengthSec, Pre_TrialSec, PostTrialSec, NumPointsInWaveForm);\n");
			return;
		}
	

		NumChannels = mxGetNumberOfElements(prhs[1]);
		// build channel transform
		double *SelectedChannels = (double*) mxGetPr(prhs[1]);
		//(int) *(double*)mxGetPr(prhs[1]);

		NumUnitsPerChannel = (int) *(double*)mxGetPr(prhs[2]);
		LFP_Freq = (int) *(double*)mxGetPr(prhs[3]);
		LFP_Stored_Freq=(int) *(double*)mxGetPr(prhs[4]);
		NumTrials = (int) *(double*)mxGetPr(prhs[5]);
		TrialLengthSec = *(double*)mxGetPr(prhs[6]);
		Pre_TimeSec = *(double*)mxGetPr(prhs[7]);
		Post_TimeSec = *(double*)mxGetPr(prhs[8]);
		NumDataPointsInWaveForm = (int) *(double*)mxGetPr(prhs[9]);
		bool bSuccessful = Allocate(SelectedChannels);
		return;
	}


	if (strcmp(buff,"Allocated?") == 0)  {
		plhs[0] = mxCreateScalarDouble(bAllocated);
		return;
	}


	if (!bAllocated){
		mexPrintf("Use Allocate First!...\n");
		return;
	}

	if (strcmp(buff,"Release") == 0)  {
		Release();
		return;
	}

	if (strcmp(buff,"SetOpt") == 0)  {
		SetOpt(nrhs, prhs);
		return;
	}
	if (strcmp(buff,"GetOpt") == 0) {
		GetOpt(nlhs, plhs);
		return;
	}

	if (strcmp(buff,"GetWarningCounters") == 0)  {
		mwSize dim[2] = {1,6};
		plhs[0]= mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
		double *Tmp=mxGetPr(plhs[0]);
		Tmp[0] = TotalTrialCounter;
		Tmp[1] = Warnings.Miss_AnalogPacket;
		Tmp[2] = Warnings.Miss_Assign;
		Tmp[3] = Warnings.Miss_Start;
		Tmp[4] = Warnings.Miss_Stop;
		Tmp[5] = Warnings.Miss_TrialLength;
		return;
	}


	if (strcmp(buff,"UpdatePlexon") == 0)  {

		// Plexon Style Update
		const mwSize *dim1 = mxGetDimensions(prhs[1]);
		int NumSpikeEntries = dim1[0]; // [Spike/StrobeWord, Channel, Unit, Timestamp]
		double *SpikeAndStrobeWordTable = (double*)mxGetPr(prhs[1]);

		double *AnalogChannelsData = (double*)mxGetPr(prhs[2]);
		const mwSize *dim2 = mxGetDimensions(prhs[2]);
		int NumAnalogEntries = dim2[0]; 
		int NumChannelsToUpdate = dim2[1]; 
		if (NumChannelsToUpdate != NumChannels && NumChannelsToUpdate != 0) {
			mexPrintf("You allocated %d channels, but now trying to update %d channels",NumChannels,NumChannelsToUpdate);
			return;
		}

		
		double *AnalogTime0 = (double*)mxGetPr(prhs[3]);

		double *WaveForms = NULL;
		if (nrhs == 5)
			WaveForms = (double*)mxGetPr(prhs[4]);

		DBG++;
		UpdatePlexon(NumSpikeEntries,SpikeAndStrobeWordTable, AnalogChannelsData, NumAnalogEntries, AnalogTime0,WaveForms);
		return;
	}

	if (strcmp(buff,"ResetConditionSpikes") == 0) {
		if (nrhs != 4) {
			mexPrintf("Use TrialCircularBuffer('ResetConditionSpikes',Channel,Unit,Condition);\n");
			return;
		}
		int Channel = (int) *(double*)mxGetPr(prhs[1]);
		int Unit = (int) *(double*)mxGetPr(prhs[2]);
		int Condition = (int) *(double*)mxGetPr(prhs[3]);

		if (Channel-1 < 0 || Channel-1 >= NumChannels || Unit-1 < 0 || Unit-1 >= NumUnitsPerChannel || Condition < 0 || Condition >= Opt.NumConditions) {
			mexPrintf("Out of range values!. Use TrialCircularBuffer('ResetConditionSpikes',Channel,Unit,Condition);\n");
			return;
		}

		TrialCounter[Channel-1][Unit-1] = 0;
		if (Condition == 0 ) {
			for (int k=0;k< Opt.NumConditions;k++) {
				NumValidTrialsInBuf[Channel-1][Unit-1][k] = 0;
				NumValidTrials[Channel-1][Unit-1][k] = 0;
				for (int j=0;j<Opt.NumPSTHBins;j++)
					PSTH_Spikes[Channel-1][Unit-1][k][j] = 0;
			}
		} else if (Condition > 0 && Condition < Opt.NumConditions) {
			NumValidTrialsInBuf[Channel-1][Unit-1][Condition-1] = 0;
			NumValidTrials[Channel-1][Unit-1][Condition-1] = 0;

			for (int k=0;k<Opt.NumPSTHBins;k++)
				PSTH_Spikes[Channel-1][Unit-1][Condition][k] = 0;

		}

		return;
	}

	if (strcmp(buff,"ResetConditionAnalog") == 0) {
		if (nrhs != 3) {
			mexPrintf("Use TrialCircularBuffer('ResetConditionAnalog',Channel,Condition);\n");
			return;
		}

		int Channel = (int) *(double*)mxGetPr(prhs[1]);
		int Condition = (int) *(double*)mxGetPr(prhs[2]);

		if (Channel-1 < 0 || Channel-1 >= NumChannels || Condition < 0 || Condition >= Opt.NumConditions) {
			mexPrintf("Out of range values!. Use TrialCircularBuffer('ResetConditionSpikes',Channel,Unit,Condition);\n");
			return;
		}

		if (Condition == 0 ) {
			for (int k=0;k< Opt.NumConditions;k++) {
				NumValidTrialsCh[Channel-1][k] = 0;
				NumValidTrialsChInBuf[Channel-1][k] = 0;

			for (int j=0;j<Opt.NumLFPBins;j++)
				PSTH_LFP[Channel-1][k][j] = 0;

			}
		} else if (Condition > 0 && Condition < Opt.NumConditions) {

			NumValidTrialsCh[Channel-1][Condition-1] = 0;
			NumValidTrialsChInBuf[Channel-1][Condition-1] = 0;
			for (int j=0;j<Opt.NumLFPBins;j++)
				PSTH_LFP[Channel-1][Condition-1][j] = 0;
		}
		return;
	}

	if (strcmp(buff,"GetSpikeBuffer") == 0) {
		mwSize dim[2] = {SpikeCircularBufferSize, 3};
		plhs[0]= mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
		double *Tmp = mxGetPr(plhs[0]);
		for (int k=0; k<SpikeCircularBufferSize;k++) {
			Tmp[k] = SpikeCircularBuffer[3*k+0];
			Tmp[k+SpikeCircularBufferSize] = SpikeCircularBuffer[3*k+1];
			Tmp[k+2*SpikeCircularBufferSize] = SpikeCircularBuffer[3*k+2];
		}
		return;
	}


	if (strcmp(buff,"ResetWaveForm") == 0) {

		if (nrhs != 3) {
			mexPrintf("Use TrialCircularBuffer('ResetConditionAnalog',Channel,Unit);\n");
			return;
		}

		int Channel = (int) *(double*)mxGetPr(prhs[1]);
		int Unit = (int) *(double*)mxGetPr(prhs[2]);
		if (!(Channel >= 1 && Channel <= NumChannels && Unit >=1 && Unit <= NumUnitsPerChannel)) {
			mexPrintf("Out of range!. Use TrialCircularBuffer('ResetConditionAnalog',Channel,Unit);\n");
			return;
		}
		WaveFormCounter[Channel-1][Unit-1] = 0;
		for (int k=0;k<NumDataPointsInWaveForm;k++) {
			WaveFormMean[Channel-1][Unit-1][k] = 0;
			WaveFormVarMk[Channel-1][Unit-1][k] = 0;
			WaveFormVarSk[Channel-1][Unit-1][k] = 0;
		}
		return;
	}


	if (strcmp(buff,"GetTrial") == 0) {
		int Trial = (int) *(double*)mxGetPr(prhs[1]);
		const int NUMBER_OF_FIELDS = 7;
		//                               0          1          2        3          4          5      6
	    const char *field_names[] = {"Start_TS", "End_TS","Align_TS","Outcome","TrialType","Spikes","LFP"};
		const int NUMBER_OF_STRUCTS  = 1;
	    mwSize dims[2] = {1, NUMBER_OF_STRUCTS };

		plhs[0] = mxCreateStructArray(2, dims, NUMBER_OF_FIELDS, field_names);
		int iIter = 0;

		mxSetFieldByNumber(plhs[0],iIter, 0, mxCreateScalarDouble(Trials[Trial].Start_TS));
		mxSetFieldByNumber(plhs[0],iIter, 1, mxCreateScalarDouble(Trials[Trial].End_TS));
		mxSetFieldByNumber(plhs[0],iIter, 2, mxCreateScalarDouble(Trials[Trial].AlignTo_TS));
		mxSetFieldByNumber(plhs[0],iIter, 3, mxCreateScalarDouble(Trials[Trial].Outcome));
		mxSetFieldByNumber(plhs[0],iIter, 4, mxCreateScalarDouble(Trials[Trial].TrialType));

        mxArray* Spikes = mxCreateCellMatrix(NumChannels, NumUnitsPerChannel);
		for (int Ch=0;Ch<NumChannels;Ch++) {
			for (int Unit=0;Unit<NumUnitsPerChannel;Unit++) {
				if (Trials[Trial].NumSpikes[Ch][Unit] > 0) {
				    mwSize dim[2] = {1, Trials[Trial].NumSpikes[Ch][Unit]};
					mxArray *SpikesUnit = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
					double *Tmp = mxGetPr(SpikesUnit);
					assert(Trials[Trial].NumSpikes[Ch][Unit] <= MaxNumSpikesPerUnitPerTrial);
					for (int SpikeIter=0;SpikeIter<Trials[Trial].NumSpikes[Ch][Unit];SpikeIter++) {
						Tmp[SpikeIter] = Trials[Trial].SpikeTimes[Ch][Unit][SpikeIter];
					}
					int CellIndex = Unit*NumChannels + Ch;
					mxSetCell(Spikes, CellIndex, SpikesUnit);
				}
			}
		}
		mxSetFieldByNumber(plhs[0],iIter, 5, Spikes);
		// LFP
		mwSize dim[2] = {NumSamplesInTrialLFPBuffer,NumChannels};
        mxArray* LFP =  mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
		double *Tmp = mxGetPr(LFP);
		for (int Ch=0;Ch<NumChannels;Ch++) {
			for (int k=0;k<NumSamplesInTrialLFPBuffer;k++) {
				Tmp[k + Ch*NumSamplesInTrialLFPBuffer] = Trials[Trial].LFP[Ch][k];
			}
		}
		mxSetFieldByNumber(plhs[0],iIter, 6, LFP);


		return;
	}

	if (strcmp(buff,"GetRasters") == 0) {
		if (nrhs != 2) {
			mexPrintf("Use TrialCircularBuffer('GetRasters',Condition);");
			return;
		}
		int Condition = (int) *(double*)mxGetPr(prhs[1]);
		if (Condition > 0 && Condition < Opt.NumConditions)
			GetRasterCell(Condition-1,plhs);
		else
			mexPrintf("Condition is out of range.");
		return;
	}

	if (strcmp(buff,"GetUnitsLastKnownTS") == 0) {
		GetUnitsLastKnownTS(nlhs,plhs);
		return;
	}

	if (strcmp(buff,"GetNumTrialsInBuffer") == 0) {
			plhs[0] = mxCreateScalarDouble(MIN(TotalTrialCounter, NumTrials));
		return;
	}

	if (strcmp(buff,"ResetUnitTrialCounter") == 0) {
		if (nrhs != 3) {
			mexPrintf("Use TrialCircularBuffer('ResetUnitTrialCounter',Channel,Unit);\n");
			return;
		}

		int Channel = (int) *(double*)mxGetPr(prhs[1]);
		int Unit = (int) *(double*)mxGetPr(prhs[2]);
		if (!(Channel >= 1 && Channel <= NumChannels && Unit >=1 && Unit <= NumUnitsPerChannel)) {
			mexPrintf("Out of range!. Use TrialCircularBuffer('ResetUnitTrialCounter',Channel,Unit);\n");
			return;
		}
		TrialCounter[Channel-1][Unit-1] = 0;
		
		return;
	}


	if (strcmp(buff,"GetUnitsTrialCounter") == 0) {
		GetUnitsTrialCounter(nlhs,plhs);
		return;
	}

	

	if (strcmp(buff,"GetRastersForPlot") == 0) {
		if (nrhs != 2) {
			mexPrintf("Use TrialCircularBuffer('GetRasterForPlot',Condition);");
			return;
		}
		int Condition = (int) *(double*)mxGetPr(prhs[1]);
		if (Condition > 0 && Condition <= Opt.NumConditions)
			GetRasterForPlot(Condition-1,plhs);
		else
			mexPrintf("Condition is out of range.");
		return;
	}
	/*
	if (strcmp(buff,"GetPSTH") == 0) {
		if (nrhs != 8) {
			mexPrintf("Use TrialCircularBuffer('GetPSTH',Channel,Unit,a2bTrialToCategoryMatrix[Trial_Type x Category], Outcomes, Bin_Size_Ms, PreAlign_Sec, PostAlign_Sec)");
			return;
		}

		int Channel = (int) *(double*)mxGetPr(prhs[1])-1;
		int Unit = (int) *(double*)mxGetPr(prhs[2])-1;

		bool * TrialToCategoryMatrix = (bool*) mxGetPr(prhs[3]);
		double *Outcomes = (double*)mxGetPr(prhs[4]);
		int Numoutcomes = mxGetNumberOfElements(prhs[4]);

		double fBinSizeMS = *(double*)mxGetPr(prhs[5]);
		const mwSize *dim = mxGetDimensions(prhs[3]);
		double PreAlign_Sec =*(double*)mxGetPr(prhs[6]);
		double PostAlign_Sec =*(double*)mxGetPr(prhs[7]);
		

		int NumTrialTypes = dim[0];
		int NumCategories = dim[1];
		fnGetPSTH(Channel, Unit, TrialToCategoryMatrix, NumTrialTypes, NumCategories, Outcomes,Numoutcomes, fBinSizeMS, PreAlign_Sec, PostAlign_Sec, nlhs, plhs );
		return;
	}	
	*/

	if (strcmp(buff,"GetAllPSTH") == 0) {
		fnGetRealTimePSTH(nlhs, plhs );
		return;
	}	

	if (strcmp(buff,"GetCounters") == 0) {
		GetCounters(nlhs, plhs );
		return;
	}	

	

}
