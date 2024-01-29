#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "dplive_driver.h"
#include "xv_tpg.h"
#include "xvidc.h"

#define DDR_BASE_ADDR   	0x800000000
#define VDMA_BASE_ADDR_0  	XPAR_AXI_VDMA_0_BASEADDR
#define VDMA_BASE_ADDR_1  	XPAR_AXI_VDMA_1_BASEADDR
#define VDMA_BASE_ADDR_2  	XPAR_AXI_VDMA_2_BASEADDR
#define VDMA_BASE_ADDR_3  	XPAR_AXI_VDMA_3_BASEADDR

#define VDMA_BASE_ADDR_4  	XPAR_AXI_VDMA_4_BASEADDR
#define VDMA_BASE_ADDR_5  	XPAR_AXI_VDMA_5_BASEADDR

#define VDMA_BASE_ADDR_R 	XPAR_AXI_VDMA_READ_BASEADDR


UINTPTR frame1_addr = 0x800000000;
UINTPTR frame2_addr = 0x801000000;
UINTPTR frame3_addr = 0x802000000;

XV_tpg tpg0;
XV_tpg tpg1;


int main()
{
    init_platform();

    //Background fill red 1920x1080
    Xil_DCacheDisable();
    for(int l = 0; l < 1080; l++){
    	for(int w = 0; w < 1920; w++){
    		Xil_Out32(frame1_addr, 0x010101);
    		Xil_Out32(frame2_addr, 0x010101);
    		Xil_Out32(frame3_addr, 0x010101);
    		frame1_addr += 3;
			frame2_addr += 3;
			frame3_addr += 3;
    	}
    }
    Xil_DCacheEnable();



    print("Initializing Write Channel 0...     \n\r");

    Xil_Out32(VDMA_BASE_ADDR_0 + 0x30, 0x808B);

    // For 1280x1024
    Xil_Out32(VDMA_BASE_ADDR_0 + 0xAC, 0x00000000 + (320 *3) + (60 *1920*3) );  //320 horizontal offset,  28 vertical offset
    Xil_Out32(VDMA_BASE_ADDR_0 + 0xB0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_0 + 0xB4, 0x01000000 + (320 *3) + (60 *1920*3)/* + (28 *1920*3) */);
    Xil_Out32(VDMA_BASE_ADDR_0 + 0xB8, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_0 + 0xBC, 0x02000000 + (320 *3) + (60 *1920*3)/* + (28 *1920*3) */);
    Xil_Out32(VDMA_BASE_ADDR_0 + 0xC0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_0 + 0xA8, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_0 + 0xA4, 640*3);
    Xil_Out32(VDMA_BASE_ADDR_0 + 0xA0, 480);
    print("                                  Done\n\r");


    print("Initializing Write Channel 1...     \n\r");

    Xil_Out32(VDMA_BASE_ADDR_1 + 0x30, 0x808B);

    Xil_Out32(VDMA_BASE_ADDR_1 + 0xAC, 0x00000000 + 960*3 + (60 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_1 + 0xB0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_1 + 0xB4, 0x01000000 + 960*3 + (60 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_1 + 0xB8, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_1 + 0xBC, 0x02000000 + 960*3 + (60 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_1 + 0xC0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_1 + 0xA8, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_1 + 0xA4, 640*3);
    Xil_Out32(VDMA_BASE_ADDR_1 + 0xA0, 480);

    print("                                  Done\n\r");


    print("Initializing Write Channel 2...     \n\r");

    Xil_Out32(VDMA_BASE_ADDR_2 + 0x30, 0x808B);

    Xil_Out32(VDMA_BASE_ADDR_2 + 0xAC, 0x00000000 + (320 *3) + (540 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_2 + 0xB0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_2 + 0xB4, 0x01000000 + (320 *3) + (540 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_2 + 0xB8, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_2 + 0xBC, 0x02000000 + (320 *3) + (540 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_2 + 0xC0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_2 + 0xA8, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_2 + 0xA4, 640*3);
    Xil_Out32(VDMA_BASE_ADDR_2 + 0xA0, 480);

    print("                                  Done\n\r");



    print("Initializing Write Channel 3...     \n\r");

    Xil_Out32(VDMA_BASE_ADDR_3 + 0x30, 0x808B);

    // For 1280x1024
    Xil_Out32(VDMA_BASE_ADDR_3 + 0xAC, 0x00000000 + (960*3) + (540 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_3 + 0xB0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_3 + 0xB4, 0x01000000 + (960*3) + (540 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_3 + 0xB8, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_3 + 0xBC, 0x02000000 + (960*3) + (540 *1920*3) );
    Xil_Out32(VDMA_BASE_ADDR_3 + 0xC0, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_3 + 0xA8, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_3 + 0xA4, 640*3);
    Xil_Out32(VDMA_BASE_ADDR_3 + 0xA0, 480);

    print("                                  Done\n\r");



    print("Initializing Read Channel ...     \n\r");

    Xil_Out32(VDMA_BASE_ADDR_R + 0x00, 0x800B);

    Xil_Out32(VDMA_BASE_ADDR_R + 0x5C, 0x00000000);
    Xil_Out32(VDMA_BASE_ADDR_R + 0x60, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_R + 0x64, 0x01000000);
    Xil_Out32(VDMA_BASE_ADDR_R + 0x68, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_R + 0x6C, 0x02000000);
    Xil_Out32(VDMA_BASE_ADDR_R + 0x70, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_R + 0x58, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_R + 0x54, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_R + 0x50, 1080);

    print("                                  Done\n\r");



    print("Initializing Read Channel 2&3 ...     \n\r");

    Xil_Out32(VDMA_BASE_ADDR_4 + 0x00, 0x800B);

    Xil_Out32(VDMA_BASE_ADDR_4 + 0x5C, 0x00000000 + (320 *3) + (60 *1920*3));
    Xil_Out32(VDMA_BASE_ADDR_4 + 0x60, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_4 + 0x64, 0x01000000 + (320 *3) + (60 *1920*3));
    Xil_Out32(VDMA_BASE_ADDR_4 + 0x68, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_4 + 0x6C, 0x02000000 + (320 *3) + (60 *1920*3));
    Xil_Out32(VDMA_BASE_ADDR_4 + 0x70, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_4 + 0x58, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_4 + 0x54, 640*3);
    Xil_Out32(VDMA_BASE_ADDR_4 + 0x50, 480);


    Xil_Out32(VDMA_BASE_ADDR_5 + 0x00, 0x800B);

    Xil_Out32(VDMA_BASE_ADDR_5 + 0x5C, 0x00000000 + 960*3 + (60 *1920*3));
    Xil_Out32(VDMA_BASE_ADDR_5 + 0x60, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_5 + 0x64, 0x01000000 + 960*3 + (60 *1920*3));
    Xil_Out32(VDMA_BASE_ADDR_5 + 0x68, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_5 + 0x6C, 0x02000000 + 960*3 + (60 *1920*3));
    Xil_Out32(VDMA_BASE_ADDR_5 + 0x70, 0x00000008);

    Xil_Out32(VDMA_BASE_ADDR_5 + 0x58, 1920*3);
    Xil_Out32(VDMA_BASE_ADDR_5 + 0x54, 640*3);
    Xil_Out32(VDMA_BASE_ADDR_5 + 0x50, 480);

    print("                                  Done\n\r");



    print("Initializing TPGs...     \n\r");

    XV_tpg_Initialize(&tpg0, XPAR_V_TPG_0_DEVICE_ID);
    XV_tpg_Set_width(&tpg0, 640);
    XV_tpg_Set_height(&tpg0, 480);

    XV_tpg_Initialize(&tpg1, XPAR_V_TPG_1_DEVICE_ID);
    XV_tpg_Set_width(&tpg1, 640);
    XV_tpg_Set_height(&tpg1, 480);


	XV_tpg_Set_colorFormat(&tpg0, 0x00);
	XV_tpg_InterruptGlobalDisable(&tpg0);
	XV_tpg_Start(&tpg0);
    XV_tpg_EnableAutoRestart(&tpg0);
    XV_tpg_Set_bckgndId(&tpg0, XTPG_BKGND_TARTAN_COLOR_BARS);




	XV_tpg_Set_colorFormat(&tpg1, 0x00);
	XV_tpg_InterruptGlobalDisable(&tpg1);
	XV_tpg_Start(&tpg1);
	XV_tpg_EnableAutoRestart(&tpg1);
    XV_tpg_Set_bckgndId(&tpg1, XTPG_BKGND_TARTAN_COLOR_BARS);

    print("                                  Done\n\r");



    print("DP Init\n\r");
    InitDpLive(XVIDC_VM_1920x1080_60_P);


    cleanup_platform();
    return 0;
}
