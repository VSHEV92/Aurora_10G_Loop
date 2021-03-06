#include "xgpio.h"
#include "xtmrctr.h"
#include "aurora_loop.h"

extern unsigned char CH_1_State;
extern unsigned char CH_2_State;
extern unsigned char CH_3_State;

extern unsigned char Timer_Done;

void GpioHandler(void *CallbackRef)
{
	XGpio *GpioPtr = (XGpio *)CallbackRef;
	XGpio_InterruptGlobalDisable(GpioPtr);

	unsigned char Ch[3];
	unsigned char link_state = XGpio_DiscreteRead(GpioPtr, 1);
	parse_link_state(link_state, Ch);

	if (CH_1_State != Ch[0]){
		CH_1_State = Ch[0];
		print_ch_state(1, CH_1_State);
	}

	if (CH_2_State != Ch[1]){
		CH_2_State = Ch[1];
		print_ch_state(2, CH_2_State);
	}

	if (CH_3_State != Ch[2]){
		CH_3_State = Ch[2];
		print_ch_state(3, CH_3_State);
	}

	XGpio_InterruptGlobalEnable(GpioPtr);
	XGpio_InterruptClear(GpioPtr, 1);
}

void TimerHandler(void *CallBackRef, u8 TmrCtrNumber)
{
	Timer_Done = 1;
}
