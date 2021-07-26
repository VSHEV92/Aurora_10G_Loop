#include "xgpio.h"
#include "xintc.h"
#include "xparameters.h"
#include "mb_interface.h"

#include "aurora_loop.h"

extern unsigned char CH_1_State;
extern unsigned char CH_2_State;
extern unsigned char CH_3_State;

void GpioHandler(void *CallbackRef);

void init_platform(XGpio* Gpio_Reset, XGpio* Gpio_Hot_Plug, XIntc* Intr_Controller){

	xil_printf("Init Platform Start\r\n");

	// enable microblaze interrupts
	microblaze_enable_interrupts();

	// -------------------------------------------------------------------------------
	// init gpio reset
	int Status;
	Status = XGpio_Initialize(Gpio_Reset, XPAR_GPIO_1_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("GPIO Reset Init Fail\r\n");
		return XST_FAILURE;
	}

	// reset aurora
	reset_aurora(Gpio_Reset);

	// -------------------------------------------------------------------------------
	// init gpio hot plug
	Status = XGpio_Initialize(Gpio_Hot_Plug, XPAR_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("GPIO Hot Plug Init Fail\r\n");
		return XST_FAILURE;
	}

	// -------------------------------------------------------------------------------
	// init interrupt controller
	Status = XIntc_Initialize(Intr_Controller, XPAR_INTC_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Interrupt Controller Init Fail\r\n");
		return XST_FAILURE;
	}

	XIntc_Connect(Intr_Controller, XPAR_INTC_0_GPIO_0_VEC_ID, (XInterruptHandler)GpioHandler, Gpio_Hot_Plug);
	XIntc_Enable(Intr_Controller, XPAR_INTC_0_GPIO_0_VEC_ID);
	Status = XIntc_Start(Intr_Controller, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {
		xil_printf("Can't Interrupt Controller REAL MODE\r\n");
		return XST_FAILURE;
	}

	// get current link state
	unsigned char CH[3];
	unsigned char link_state = XGpio_DiscreteRead(Gpio_Hot_Plug, 1);
	parse_link_state(link_state, CH);
	CH_1_State = CH[0];
	CH_2_State = CH[1];
	CH_2_State = CH[2];
	print_ch_state(1, CH_1_State);
	print_ch_state(3, CH_2_State);
	print_ch_state(3, CH_3_State);

	// enable gpio interrupt
	XGpio_InterruptClear(Gpio_Hot_Plug, 1);
	XGpio_InterruptEnable(Gpio_Hot_Plug, 1);
	XGpio_InterruptGlobalEnable(Gpio_Hot_Plug);

}
