/*
* rf.h
*
* Created: 04.04.2017 0:32:07
*  Author: Alexander Yermakov
*/

#define DEF_SIGNATURE 0b11101011
#define DELAY 125 //us -> ~1000 bytes per second

#ifndef RF_RECEIVE_PIN
# warning "RF_RECEIVE_PIN not defined for <rf.h>"
# define RF_RECEIVE_PIN 0
#endif

#ifndef RF_TRANSMIT_PIN
# warning "RF_TRANSMIT_PIN not defined for <rf.h>"
# define RF_TRANSMIT_PIN 0
#endif

unsigned char check_signature(void);
void set_signature(unsigned char sign);
unsigned char get_signature(void);

void send_data(unsigned char data);

void send_with_signature(unsigned char data);

unsigned char receive(void);