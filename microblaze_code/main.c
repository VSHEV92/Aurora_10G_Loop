#include "xil_printf.h"
#include "xgpio.h"
#include "xintc.h"

#include "aurora_loop.h"

XGpio Gpio_Reset;
XGpio Gpio_Hot_Plug;
XIntc Intr_Controller;

unsigned char CH_1_State;
unsigned char CH_2_State;
unsigned char CH_3_State;

void init_platform(XGpio* Gpio_Reset, XGpio* Gpio_Hot_Plug, XIntc* Intr_Controller);

int main(){

	int counter = 0;


	init_platform(&Gpio_Reset, &Gpio_Hot_Plug, &Intr_Controller);

	//link_state = XGpio_DiscreteRead(&Gpio_Hot_Plug, 1);
	//xil_printf("%d \r\n", link_state);

//	while(1){}
////	xil_printf("done \r\n");
////
////    int delay = 1;
    while(1){
        delay();
        counter++;
        xil_printf("counter = %d \r\n", counter);
    }

	return 0;
}
