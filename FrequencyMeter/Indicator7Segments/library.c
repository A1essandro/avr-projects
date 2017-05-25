#include <avr/io.h>
#include <util/delay.h>

#define DS 0
//#define OE 1
#define ST_CP 2
#define SH_CP 3
#define MR 4
#define unchar unsigned char

#ifdef COMMON_CATHODE
	int myfunc(int symbolCode)
	{
		return 0;
	}
#else
	#ifdef COMMON_ANODE
		int myfunc(void)
		{
			return 0;
		}
	#else
		# warning "COMMON_CATHODE or COMMON_ANODE not defined."
	#endif
#endif

unchar DISPLAY_CONTROL[4] = {7, 6, 5, 4};
//unchar EXTENDS_CONTROL[4] = {0, 1, 2, 3};

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

void push_data_bit(unchar bt)
{
	if (bt)
		PORTB |= (1 << DS);
	else
		PORTB &= ~(1 << DS);
		PORTB &= ~(1 << SH_CP);
		PORTB |= (1 << SH_CP);
}

void latch(void)
{
	PORTB |= (1 << ST_CP);
	PORTB &= ~(1 << ST_CP);
}

void reset(void)
{
	PORTB &= ~(1 << MR);
	_delay_ms(3);
	latch();
	PORTB |= (1 << MR);
	latch();
}

void push_data(unsigned int data)
{
	unchar f;
	for(f = 0; f < 16; f++)
	{
		push_data_bit(data & 1);
		data = data >> 1;
	}
	latch();
}

unsigned int get_symbol(unchar n)
{
	return symbols[n] << 8;
}

unsigned int frame(unchar f, unchar symbol)
{
	return (1 << DISPLAY_CONTROL[f]) | get_symbol(symbol);
}
