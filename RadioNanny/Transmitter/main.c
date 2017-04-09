/*
* Transmitter.c
*
* Created: 02.04.2017 21:19:57
* Author : Alexander Yermakov
*/

#define RF_TRANSMIT_PIN 0

#include "nanny_common.h"
#include "rf.h"
#include <avr/io.h>
#include <util/delay.h>

void init()
{
	TO_H(DDRB, RF_TRANSMIT_PIN);
	TO_H(PORTB, RF_TRANSMIT_PIN);
}

int main(void)
{
	init();
	while (1)
	{
		for (byte i=0; i<255; i++)
		{
			for (long j=0; j<1000; j++)
			{
				send_with_signature(i);
			}
		}
	}
}

