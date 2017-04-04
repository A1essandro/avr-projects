/*
* RF.c
*
* Created: 04.04.2017 0:30:41
* Author : Alexander Yermakov
*/

#include <avr/io.h>
#include "rf.h"
#include <util/delay.h>

/************************************************************************/
/*                                Transmitter                           */
/************************************************************************/

void send_data(unsigned char data)
{
	for(unsigned char i = 0; i < 8; i++)
	{
		if(((data >> 7) & 1))
		{
			PORTB &= ~(1 << RF_TRANSMIT_PIN);
		}
		else
		{
			PORTB |= (1 << RF_TRANSMIT_PIN);
		}
		_delay_us(DELAY);
		data <<= 1;
	}
}

void send_with_signature(unsigned char data)
{
	send_data(RF_SIGNATURE);
	send_data(data);
}

/************************************************************************/
/*                             Receiver                                 */
/************************************************************************/

unsigned char receive(void)
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
	if(receive() == RF_SIGNATURE)
	{
		return 1;
	}
	return 0;
}