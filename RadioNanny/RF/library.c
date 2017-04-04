/*
* RF.c
*
* Created: 04.04.2017 0:30:41
* Author : Alexander Yermakov
*/

#include <avr/io.h>
#include "rf.h"
#include <util/delay.h>
#include <stdbool.h>

/************************************************************************/
/*                                Transmitter                           */
/************************************************************************/

void send_byte(unsigned char data)
{
	for(unsigned char i = 0; i < 8; i++)
	{
		send_bit((data >> 7) /* & 1 */);
		_delay_us(DELAY);
		data <<= 1;
	}
}

void send_bit(unsigned char bit)
{
	if(bit & 1)
	{
		PORTB &= ~(1 << RF_TRANSMIT_PIN);
	}
	else
	{
		PORTB |= (1 << RF_TRANSMIT_PIN);
	}
}

void send_with_signature(unsigned char data)
{
	send_byte(RF_SIGNATURE);
	send_byte(data);
}

/************************************************************************/
/*                             Receiver                                 */
/************************************************************************/

unsigned char receive_byte(void)
{
	unsigned char  res = 0;
	unsigned char i;

	for(i = 0; i < 8; i++)
	{
		res <<= 1;
		if((PINB >> RF_RECEIVE_PIN) & 1)
		{
			res |= 1;
		}
		_delay_us(DELAY);
	}
	return res;
}

unsigned char check_signature(void)
{
	if(receive_byte() == RF_SIGNATURE)
	{
		return 1;
	}
	return 0;
}