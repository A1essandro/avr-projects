/*
* Receiver.c
*
* Created: 02.04.2017 22:29:44
* Author : Alexander Yermakov
*/

#include "nanny_common.h"
#include "rf.h"
#include <avr/io.h>
#include <util/delay.h>

#define OUTPUT_PIN 0

void init()
{
	TO_L(DDRB, RF_RECEIVE_PIN);
	TO_H(DDRB, OUTPUT_PIN);
	TO_L(PORTB, OUTPUT_PIN);
}

void timer1_init(void) {
	TCCR0A |= (1 << COM0A1) | (1 << WGM01);
	TCCR0B |= (1 << CS01);
	OCR0A = 0x00;
}

int main(void)
{
	init();
	//timer1_init();
	while (1)
	{
		if (new_check())
		{
			if(receive_byte() % 2 == 1)
			{
				TO_H(PORTB, OUTPUT_PIN);
			}
			else
			{
				TO_L(PORTB, OUTPUT_PIN);
			}
		}
	}
}

