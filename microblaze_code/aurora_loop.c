#include "xgpio.h"

void delay(){
    unsigned int delay = 1000 * 1000 * 50 / 8;
    for (int i = 0; i < delay; i++){}
}

void parse_link_state(unsigned char link_state, unsigned char* CH){
	CH[0] = link_state & 0x01;

	CH[1] = link_state & 0x02;
	CH[1] = CH[1] >> 1;

	CH[2] = link_state & 0x04;
	CH[2] = CH[2] >> 2;
}

void reset_aurora(XGpio* Gpio_Reset){
	xil_printf("Reset Aurora Start\r\n");
	XGpio_DiscreteWrite(Gpio_Reset, 1, 1);
	delay();
	XGpio_DiscreteWrite(Gpio_Reset, 2, 1);
	delay();
	XGpio_DiscreteWrite(Gpio_Reset, 2, 0);
	delay();
	XGpio_DiscreteWrite(Gpio_Reset, 1, 0);
	delay();
	xil_printf("Reset Aurora Done\r\n");
}

void print_ch_state(unsigned char CH, unsigned char state){
	if (state)
		xil_printf("Channel %d link up \r\n", CH);
	else
		xil_printf("Channel %d link down \r\n", CH);
}
