#include "xgpio.h"
#include "xtmrctr.h"

extern unsigned char Timer_Done;

void delay(XTmrCtr* Timer, u32 ResetValue){
	Timer_Done = 0;
	XTmrCtr_SetResetValue(Timer, 0, ResetValue);
	XTmrCtr_Start(Timer, 0);
}

void parse_link_state(unsigned char link_state, unsigned char* CH){
	CH[0] = link_state & 0x01;

	CH[1] = link_state & 0x02;
	CH[1] = CH[1] >> 1;

	CH[2] = link_state & 0x04;
	CH[2] = CH[2] >> 2;

	CH[3] = link_state & 0x08;
	CH[3] = CH[3] >> 3;
}

void reset_aurora(XGpio* Gpio_Reset, XTmrCtr* Timer){
	xil_printf("Reset Aurora Start\r\n");
	XGpio_DiscreteWrite(Gpio_Reset, 1, 1);
	delay(Timer, 1000);
	while(!Timer_Done){}

	XGpio_DiscreteWrite(Gpio_Reset, 2, 1);
	delay(Timer, 1e9/9);
	while(!Timer_Done){}

	XGpio_DiscreteWrite(Gpio_Reset, 2, 0);
	delay(Timer, 1000);
	while(!Timer_Done){}

	XGpio_DiscreteWrite(Gpio_Reset, 1, 0);
	xil_printf("Reset Aurora Done\r\n");
}

void print_ch_state(unsigned char CH, unsigned char state){
	if (state)
		xil_printf("Channel %d link up \r\n", CH);
	else
		xil_printf("Channel %d link down \r\n", CH);
}

void start_transaction(XTmrCtr* Timer, u8 tx_channel, u8 rx_channel, u8 data){
	u8 Data_Not_Ready;
	u8 Data_Count;
	u8 Data_Read;

	switch(tx_channel) {
	case 0:
		putfsl(data, 0);
		putfsl(0, 0);
		break;
	case 1:
		putfsl(data, 1);
		putfsl(0, 1);
		break;
	case 2:
		putfsl(data, 2);
		putfsl(0, 2);
		break;
	}
	delay(Timer, 1e6);

	Data_Count = 0;
	while (!Timer_Done) {

		switch(rx_channel) {
		case 0:
			ngetfsl(Data_Read, 0);
			break;
		case 1:
			ngetfsl(Data_Read, 1);
			break;
		case 2:
			ngetfsl(Data_Read, 2);
			break;
		}

		fsl_isinvalid(Data_Not_Ready);
		if (!Data_Not_Ready)
			Data_Count++;
		if (Data_Count == 2){
			XTmrCtr_Stop(Timer, 0);
		break;
		}
	}
}
