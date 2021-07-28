#include "xil_printf.h"
#include "xgpio.h"
#include "xintc.h"
#include "xtmrctr.h"

#include "aurora_loop.h"

XGpio Gpio_Reset;
XGpio Gpio_Hot_Plug;
XIntc Intr_Controller;
XTmrCtr Timer;

unsigned char Timer_Done;

unsigned char CH_1_State;
unsigned char CH_2_State;
unsigned char CH_3_State;

void init_platform(XGpio* Gpio_Reset, XGpio* Gpio_Hot_Plug, XIntc* Intr_Controller, XTmrCtr* Timer);

int main(){

	u8 counter_ch1 = 0;
	u8 counter_ch2 = 0;
	u8 counter_ch3 = 0;

	init_platform(&Gpio_Reset, &Gpio_Hot_Plug, &Intr_Controller, &Timer);

	while(1){

		// запись в первый канал
		if(CH_1_State) {
			start_transaction(&Timer, 0, 0, counter_ch1);
			counter_ch1++;

			if (Timer_Done)
				xil_printf("Channel 1 Transaction Faild\r\n");
			else
				xil_printf("Channel 1 Transaction Complited\r\n");
		}

		// запись во второй канал
		if(CH_2_State) {
			start_transaction(&Timer, 1, 1, counter_ch2);
			counter_ch2++;

			if (Timer_Done)
				xil_printf("Channel 2 Transaction Faild\r\n");
			else
				xil_printf("Channel 2 Transaction Complited\r\n");
		}

		// запись в третий канал
		if(CH_3_State) {
			start_transaction(&Timer, 2, 2, counter_ch3);
			counter_ch3++;

			if (Timer_Done)
				xil_printf("Channel 3 Transaction Faild\r\n");
			else
				xil_printf("Channel 3 Transaction Complited\r\n");
		}

	}

	return 0;
}
