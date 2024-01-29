#include "dplive_driver.h"
#include "xil_cache.h"

/************************** Constant Definitions *****************************/

#define DPPSU_DEVICE_ID		XPAR_PSU_DP_DEVICE_ID
#define AVBUF_DEVICE_ID		XPAR_PSU_DP_DEVICE_ID
#define DPDMA_DEVICE_ID		XPAR_XDPDMA_0_DEVICE_ID
#define DPPSU_INTR_ID		151
#define DPDMA_INTR_ID		154
#define INTC_DEVICE_ID		XPAR_SCUGIC_0_DEVICE_ID

#define DPPSU_BASEADDR		XPAR_PSU_DP_BASEADDR
#define AVBUF_BASEADDR		XPAR_PSU_DP_BASEADDR
#define DPDMA_BASEADDR		XPAR_PSU_DPDMA_BASEADDR

/************************** Variable Declarations ***************************/

XDpPsu 				DpPsu;
XAVBuf 				AVBuf;
XScuGic 			Intr;
Run_Config 			RunCfg;


int InitDpLive(XVidC_VideoMode videoMode)
{
	int Status;

	Xil_DCacheDisable();
	Xil_ICacheDisable();

	InitRunConfig(&RunCfg);
	Run_Config *RunCfgPtr = &RunCfg;

	XDpPsu			*DpPsuPtr = RunCfgPtr->DpPsuPtr;
	XDpPsu_Config	*DpPsuCfgPtr;
	XAVBuf			*AVBufPtr = RunCfgPtr->AVBufPtr;


	/* Initialize DisplayPort driver. */
	DpPsuCfgPtr = XDpPsu_LookupConfig(DPPSU_DEVICE_ID);
	XDpPsu_CfgInitialize(DpPsuPtr, DpPsuCfgPtr, DpPsuCfgPtr->BaseAddr);
	/* Initialize Video Pipeline driver */
	XAVBuf_CfgInitialize(AVBufPtr, DpPsuPtr->Config.BaseAddr, AVBUF_DEVICE_ID);

	/* Initialize the DisplayPort TX core. */
	Status = XDpPsu_InitializeTx(DpPsuPtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/* Enable the Buffers required by Graphics Channel */
	XAVBuf_SetInputLiveVideoFormat(AVBufPtr, RGB_8BPC);
	//XAVBuf_EnableVideoBuffers(AVBufPtr, 0);
	/* Set the output Video Format */
	XAVBuf_SetOutputVideoFormat(AVBufPtr, RGB_8BPC);

	/* Select the Input Video Sources. */
	XAVBuf_InputVideoSelect(AVBufPtr, XAVBUF_VIDSTREAM1_LIVE, XAVBUF_VIDSTREAM2_NONE);
	/* Configure the output video pipeline */
	XAVBuf_ConfigureOutputVideo(AVBufPtr);
	xil_printf("[DPDMA] AVBuf Configred \r\n");
	/* Disable the global alpha, since we are using the pixel based alpha */
	XAVBuf_SetBlenderAlpha(AVBufPtr, 0, 0);
	/* Set the clock mode */
	XDpPsu_CfgMsaEnSynchClkMode(DpPsuPtr, RunCfgPtr->EnSynchClkMode);
	/* Set the clock source depending on the use case.
	 * Here for simplicity we are using PS clock as the source*/
	XAVBuf_SetAudioVideoClkSrc(AVBufPtr, XAVBUF_PS_CLK, XAVBUF_PS_CLK);
	/* Issue a soft reset after selecting the input clock sources */
	XAVBuf_SoftReset(AVBufPtr);

	SetupInterrupts(RunCfgPtr);

	return XST_SUCCESS;
}

void InitRunConfig(Run_Config *RunCfgPtr)
{
	/* Initial configuration parameters. */
		RunCfgPtr->DpPsuPtr   = &DpPsu;
		RunCfgPtr->IntrPtr   = &Intr;
		RunCfgPtr->AVBufPtr  = &AVBuf;
		RunCfgPtr->VideoMode = XVIDC_VM_1920x1080_60_P;
		RunCfgPtr->Bpc		 = XVIDC_BPC_8;
		RunCfgPtr->ColorEncode			= XDPPSU_CENC_RGB;
		RunCfgPtr->UseMaxCfgCaps		= 1;
		RunCfgPtr->LaneCount			= LANE_COUNT_2;
		RunCfgPtr->LinkRate				= LINK_RATE_540GBPS;
		RunCfgPtr->EnSynchClkMode		= 0;
		RunCfgPtr->UseMaxLaneCount		= 1;
		RunCfgPtr->UseMaxLinkRate		= 1;
}

void SetupInterrupts(Run_Config *RunCfgPtr)
{
	XDpPsu *DpPsuPtr = RunCfgPtr->DpPsuPtr;
	XScuGic		*IntrPtr = RunCfgPtr->IntrPtr;
	XScuGic_Config	*IntrCfgPtr;
	u32  IntrMask = XDPPSU_INTR_HPD_IRQ_MASK | XDPPSU_INTR_HPD_EVENT_MASK;

	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, XDPPSU_INTR_DIS, 0xFFFFFFFF);
	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, XDPPSU_INTR_MASK, 0xFFFFFFFF);

	XDpPsu_SetHpdEventHandler(DpPsuPtr, DpPsu_IsrHpdEvent, RunCfgPtr);
	XDpPsu_SetHpdPulseHandler(DpPsuPtr, DpPsu_IsrHpdPulse, RunCfgPtr);

	/* Initialize interrupt controller driver. */
	IntrCfgPtr = XScuGic_LookupConfig(INTC_DEVICE_ID);
	XScuGic_CfgInitialize(IntrPtr, IntrCfgPtr, IntrCfgPtr->CpuBaseAddress);

	/* Register ISRs. */
	XScuGic_Connect(IntrPtr, DPPSU_INTR_ID,
			(Xil_InterruptHandler)XDpPsu_HpdInterruptHandler, RunCfgPtr->DpPsuPtr);

	/* Trigger DP interrupts on rising edge. */
	XScuGic_SetPriorityTriggerType(IntrPtr, DPPSU_INTR_ID, 0x0, 0x03);

	/* Initialize exceptions. */
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
			(Xil_ExceptionHandler)XScuGic_DeviceInterruptHandler,
			INTC_DEVICE_ID);

	/* Enable exceptions for interrupts. */
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
	Xil_ExceptionEnable();

	/* Enable DP interrupts. */
	XScuGic_Enable(IntrPtr, DPPSU_INTR_ID);
	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, XDPPSU_INTR_EN, IntrMask);
}

static u32 DpPsu_Wakeup(Run_Config *RunCfgPtr)
{
	u32 Status;
	u8 AuxData;

	AuxData = 0x1;
	Status = XDpPsu_AuxWrite(RunCfgPtr->DpPsuPtr,
			XDPPSU_DPCD_SET_POWER_DP_PWR_VOLTAGE, 1, &AuxData);
	if (Status != XST_SUCCESS)
		xil_printf("\t! 1st power wake-up - AUX write failed.\n\r");
	Status = XDpPsu_AuxWrite(RunCfgPtr->DpPsuPtr,
			XDPPSU_DPCD_SET_POWER_DP_PWR_VOLTAGE, 1, &AuxData);
	if (Status != XST_SUCCESS)
		xil_printf("\t! 2nd power wake-up - AUX write failed.\n\r");

	return Status;
}

static u32 DpPsu_Hpd_Train(Run_Config *RunCfgPtr)
{
	XDpPsu		 *DpPsuPtr    = RunCfgPtr->DpPsuPtr;
	XDpPsu_LinkConfig *LinkCfgPtr = &DpPsuPtr->LinkConfig;
	u32 Status;

	Status = XDpPsu_GetRxCapabilities(DpPsuPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("\t! Error getting RX caps.\n\r");
		return XST_FAILURE;
	}

	Status = XDpPsu_SetEnhancedFrameMode(DpPsuPtr,
			LinkCfgPtr->SupportEnhancedFramingMode ? 1 : 0);
	if (Status != XST_SUCCESS) {
		xil_printf("\t! EFM set failed.\n\r");
		return XST_FAILURE;
	}

	Status = XDpPsu_SetLaneCount(DpPsuPtr,
			(RunCfgPtr->UseMaxLaneCount) ?
				LinkCfgPtr->MaxLaneCount :
				RunCfgPtr->LaneCount);
	if (Status != XST_SUCCESS) {
		xil_printf("\t! Lane count set failed.\n\r");
		return XST_FAILURE;
	}

	Status = XDpPsu_SetLinkRate(DpPsuPtr,
			(RunCfgPtr->UseMaxLinkRate) ?
				LinkCfgPtr->MaxLinkRate :
				RunCfgPtr->LinkRate);
	if (Status != XST_SUCCESS) {
		xil_printf("\t! Link rate set failed.\n\r");
		return XST_FAILURE;
	}

	Status = XDpPsu_SetDownspread(DpPsuPtr,
			LinkCfgPtr->SupportDownspreadControl);
	if (Status != XST_SUCCESS) {
		xil_printf("\t! Setting downspread failed.\n\r");
		return XST_FAILURE;
	}

	xil_printf("Lane count =\t%d\n\r", DpPsuPtr->LinkConfig.LaneCount);
	xil_printf("Link rate =\t%d\n\r",  DpPsuPtr->LinkConfig.LinkRate);

	// Link training sequence is done
        xil_printf("\n\r\rStarting Training...\n\r");
	Status = XDpPsu_EstablishLink(DpPsuPtr);
	if (Status == XST_SUCCESS)
		xil_printf("\t! Training succeeded.\n\r");
	else
		xil_printf("\t! Training failed.\n\r");

	return Status;
}

void DpPsu_Run(Run_Config *RunCfgPtr)
{
	u32 Status;
	XDpPsu  *DpPsuPtr = RunCfgPtr->DpPsuPtr;

	XDpPsu_EnableMainLink(DpPsuPtr, 0);

	Status = DpPsu_Wakeup(RunCfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("! Wakeup failed.\n\r");
		return;
	}

	u8 Count = 0;
	do {
		usleep(100000);
		Count++;

		Status = DpPsu_Hpd_Train(RunCfgPtr);
		if (Status == XST_DEVICE_NOT_FOUND) {
			xil_printf("Lost connection\n\r");
			return;
		}
		else if (Status != XST_SUCCESS)
			continue;

		DpPsu_SetupVideoStream(RunCfgPtr);
		XDpPsu_EnableMainLink(DpPsuPtr, 1);

		Status = XDpPsu_CheckLinkStatus(DpPsuPtr, DpPsuPtr->LinkConfig.LaneCount);
		if (Status == XST_DEVICE_NOT_FOUND)
			return;
	} while ((Status != XST_SUCCESS) && (Count < 2));
}

void DpPsu_IsrHpdEvent(void *ref)
{
	xil_printf("HPD event .......... ");
	DpPsu_Run((Run_Config *)ref);
	xil_printf(".......... HPD event\n\r");
}

void DpPsu_IsrHpdPulse(void *ref)
{
	u32 Status;
	XDpPsu *DpPsuPtr = ((Run_Config *)ref)->DpPsuPtr;
	xil_printf("HPD pulse ..........\n\r");

	Status = XDpPsu_CheckLinkStatus(DpPsuPtr, DpPsuPtr->LinkConfig.LaneCount);
	if (Status == XST_DEVICE_NOT_FOUND) {
		xil_printf("Lost connection .......... HPD pulse\n\r");
		return;
	}

	xil_printf("\t! Re-training required.\n\r");

	XDpPsu_EnableMainLink(DpPsuPtr, 0);

	u8 Count = 0;
	do {
		Count++;

		Status = DpPsu_Hpd_Train((Run_Config *)ref);
		if (Status == XST_DEVICE_NOT_FOUND) {
			xil_printf("Lost connection .......... HPD pulse\n\r");
			return;
		}
		else if (Status != XST_SUCCESS) {
			continue;
		}

		DpPsu_SetupVideoStream((Run_Config *)ref);
		XDpPsu_EnableMainLink(DpPsuPtr, 1);

		Status = XDpPsu_CheckLinkStatus(DpPsuPtr, DpPsuPtr->LinkConfig.LaneCount);
		if (Status == XST_DEVICE_NOT_FOUND) {
			xil_printf("Lost connection .......... HPD pulse\n\r");
			return;
		}
	} while ((Status != XST_SUCCESS) && (Count < 2));

	xil_printf(".......... HPD pulse\n\r");
}

void DpPsu_SetupVideoStream(Run_Config *RunCfgPtr)
{
	XDpPsu		 *DpPsuPtr    = RunCfgPtr->DpPsuPtr;
	XDpPsu_MainStreamAttributes *MsaConfig = &DpPsuPtr->MsaConfig;

	XDpPsu_SetColorEncode(DpPsuPtr, RunCfgPtr->ColorEncode);
	XDpPsu_CfgMsaSetBpc(DpPsuPtr, RunCfgPtr->Bpc);
	XDpPsu_CfgMsaUseStandardVideoMode(DpPsuPtr, RunCfgPtr->VideoMode);

	/* Set pixel clock. */
	RunCfgPtr->PixClkHz = MsaConfig->PixelClockHz;
	XAVBuf_SetPixelClock(RunCfgPtr->PixClkHz);

	/* Reset the transmitter. */
	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, XDPPSU_SOFT_RESET, 0x1);
	usleep(10);
	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, XDPPSU_SOFT_RESET, 0x0);

	XDpPsu_SetMsaValues(DpPsuPtr);
	/* Issuing a soft-reset (AV_BUF_SRST_REG). */
	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, 0xB124, 0x3); // Assert reset.
	usleep(10);
	XDpPsu_WriteReg(DpPsuPtr->Config.BaseAddr, 0xB124, 0x0); // De-ssert reset.

	XDpPsu_EnableMainLink(DpPsuPtr, 1);

	xil_printf("DONE!\n\r");
}
