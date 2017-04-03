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

void init()
{
	CLEAR(DDRB, RF_RECEIVE_PIN);
	SET(PORTB, RF_RECEIVE_PIN);
}

int main(void)
{
	init();
	byte data;
	while (1)
	{
		_delay_ms(100);
		while (1)
		{
			if (check_signature() > 0)
			{
				data = receive();
				if(data % 2 == 0)
				{
					SET(PORTB, 3);
				}
				else
				{
					CLEAR(PORTB, 3);
				}
				break;
			}
		}
	}
}

