#ifndef SRC_DPLIVE_DRIVER_H_
/* Prevent circular inclusions by using protection macros. */
#define SRC_DPLIVE_DRIVER_H_


/******************************* Include Files ********************************/

#include "xparameters.h"
#include "xdppsu.h"
#include "xavbuf.h"
#include "xavbuf_clk.h"
#include "xscugic.h"

/****************************** Type Definitions ******************************/

typedef enum {
	LANE_COUNT_1 = 1,
	LANE_COUNT_2 = 2,
} LaneCount_t;

typedef enum {
	LINK_RATE_162GBPS = 0x06,
	LINK_RATE_270GBPS = 0x0A,
	LINK_RATE_540GBPS = 0x14,
} LinkRate_t;

typedef struct {
	XDpPsu	*DpPsuPtr;
	XScuGic	*IntrPtr;
	XAVBuf	*AVBufPtr;

	XVidC_VideoMode	  VideoMode;
	XVidC_ColorDepth  Bpc;
	XDpPsu_ColorEncoding ColorEncode;

	u8 UseMaxLaneCount;
	u8 UseMaxLinkRate;
	u8 LaneCount;
	u8 LinkRate;
	u8 UseMaxCfgCaps;
	u8 EnSynchClkMode;

	u32 PixClkHz;
} Run_Config;


/************************** Function Prototypes ******************************/

int InitDpLive(XVidC_VideoMode videoMode);

void InitRunConfig(Run_Config *RunCfgPtr);
void SetupInterrupts(Run_Config *RunCfgPtr);

void DpPsu_SetupVideoStream(Run_Config *RunCfgPtr);

void DpPsu_Run(Run_Config *RunCfgPtr);
void DpPsu_IsrHpdEvent(void *ref);
void DpPsu_IsrHpdPulse(void *ref);

#endif /* SRC_DPLIVE_DRIVER_H_ */
