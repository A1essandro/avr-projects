/*
* IncFile1.h
*
* Created: 03.04.2017 0:00:41
*  Author: Alexander Yermakov
*/

#define RF_RECEIVE_PIN 0
#define RF_TRANSMIT_PIN 0
#define RF_SIGNATURE 0b11101011
#define F_CPU 9600000UL
#define byte unsigned char

#define SET(r, b) (r |= (1 << b))
#define CLEAR(r, b) (r &= ~(1 << b))