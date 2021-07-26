#include "xgpio.h"
void delay();
void parse_link_state(unsigned char link_state, unsigned char* CH);
void reset_aurora(XGpio* Gpio_Reset);
void print_ch_state(unsigned char CH, unsigned char state);
