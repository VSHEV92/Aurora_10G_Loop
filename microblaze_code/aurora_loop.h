#include "xgpio.h"
#include "xtmrctr.h"

void delay(XTmrCtr* Timer, u32 ResetValue);

void parse_link_state(unsigned char link_state, unsigned char* CH);

void reset_aurora(XGpio* Gpio_Reset, XTmrCtr* Timer);

void print_ch_state(unsigned char CH, unsigned char state);

void start_transaction(XTmrCtr* Timer, u8 tx_channel, u8 rx_channel, u8 data);
