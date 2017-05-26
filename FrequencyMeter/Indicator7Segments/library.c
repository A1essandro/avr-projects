#include <avr/io.h>
#include <util/delay.h>
#include "Indicator7Segments.h"

#ifndef ISS_PORTOUT
# warning "ISS_PORTOUT not defined."
#define ISS_PORTOUT PORTB
#endif

#ifndef ISS_DS
# warning "ISS_DS not defined."
#define ISS_DS 0
#endif

#ifndef ISS_ST_CP
# warning "ISS_ST_CP not defined."
#define ISS_ST_CP 1
#endif

#ifndef ISS_SH_CP
# warning "ISS_SH_CP not defined."
#define ISS_SH_CP 2
#endif

#ifndef ISS_MR
# warning "ISS_MR not defined."
#define ISS_MR 3
#endif

#ifdef ISS_COMMON_CATHODE
int myfunc(int symbolCode)
{
	return 0;
}
#else
#ifdef ISS_COMMON_ANODE
int myfunc(void)
{
	return 0;
}
#else
# warning "ISS_COMMON_CATHODE or ISS_COMMON_ANODE not defined."
#endif
#endif

unsigned char DISPLAY_CONTROL[4] = {7, 6, 5, 4};
//unsigned char EXTENDS_CONTROL[4] = {0, 1, 2, 3};

unsigned char symbols[12] = {
	//abcdefg.
	0b00000011, //0
	0b10011111, //1
	0b00100101, //2
	0b00001101, //3
	0b10011001, //4
	0b01001001, //5
	0b01000001, //6
	0b00011111, //7
	0b00000001, //8
	0b00001001, //9
	0b11111110, //pt
};

void push_data_bit(unsigned char bt)
{
	if (bt)
	ISS_PORTOUT |= (1 << ISS_DS);
	else
	ISS_PORTOUT &= ~(1 << ISS_DS);
	ISS_PORTOUT &= ~(1 << ISS_SH_CP);
	ISS_PORTOUT |= (1 << ISS_SH_CP);
}

void latch(void)
{
	ISS_PORTOUT |= (1 << ISS_ST_CP);
	ISS_PORTOUT &= ~(1 << ISS_ST_CP);
}

void reset(void)
{
	ISS_PORTOUT &= ~(1 << ISS_MR);
	_delay_ms(3);
	latch();
	ISS_PORTOUT |= (1 << ISS_MR);
	latch();
}

void push_data(unsigned int data)
{
	unsigned char f;
	for(f = 0; f < 16; f++)
	{
		push_data_bit(data & 1);
		data = data >> 1;
	}
	latch();
}

unsigned int get_symbol(unsigned char n)
{
	return symbols[n] << 8;
}

unsigned int frame(unsigned char f, unsigned char symbol)
{
	return (1 << DISPLAY_CONTROL[f]) | get_symbol(symbol);
}
