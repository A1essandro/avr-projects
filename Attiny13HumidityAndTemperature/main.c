#define int8_t int
#define uint8_t unsigned int
#define DHT11_DDR DDRB
#define DHT11_PORT PORTB
#define DHT11_PIN PINB
#define DHT11_INPUTPIN 1
int8_t dht11_gettemperature();
int8_t dht11_gethumidity();
#include <delay.h>
#include <stdio.h>
#include <string.h>
//#include <io.h>

#define DELAY 2000
#define DS 0
//#define OE 1
#define ST_CP 2
#define SH_CP 3
#define MR 4
#define unchar unsigned char

void push_data_bit(unchar bt);
void push_data(unsigned int data);
void latch(void);
void reset(void);
unsigned int frame(unchar f, unchar symbol);
unsigned int get_symbol(unchar n);

unchar DISPLAY_CONTROL[4] = {7, 6, 5, 4}; 
//unchar EXTENDS_CONTROL[4] = {0, 1, 2, 3}; 

unchar symbols[12] = {
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
    0b11100001, //t 10
    0b11010001 //h 11
};

void main(void)
{
    int tick = 0;
    unchar v = 0;
    DDRB = 0xFF;

    reset();

    while(1)
    {
        if(tick == 0) {
            push_data(frame(0, 10));
            v = dht11_gettemperature();
        }
        else if(tick > 0 && (tick + 1) < 0) {
            push_data(frame(0, 11));
            v = dht11_gethumidity();
        }
        tick++;

        if(tick > 0) {
            push_data(frame(0, 10));
            push_data(frame(2, v / 10));
            push_data(frame(3, v % 10));
        } else {
            push_data(frame(0, 11));
            push_data(frame(2, v / 10));
            push_data(frame(3, v % 10));
        }
    }
}

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
    delay_ms(3);
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


//DHT11 part. Thanks for Davide Gironi

/*
DHT11 Library 0x01
copyright (c) Davide Gironi, 2011
Released under GPLv3.
Please refer to LICENSE file for licensing information.
*/
#define DHT11_ERROR 255

/*
 * get data from dht11
 */
uint8_t dht11_getdata(unchar select) {
    uint8_t bits[5];
    uint8_t i,j = 0;

    memset(bits, 0, sizeof(bits));

    //reset port
    DHT11_DDR |= (1<<DHT11_INPUTPIN); //output
    DHT11_PORT |= (1<<DHT11_INPUTPIN); //high
    delay_ms(100);

    //send request
    DHT11_PORT &= ~(1<<DHT11_INPUTPIN); //low
    delay_ms(18);
    DHT11_PORT |= (1<<DHT11_INPUTPIN); //high
    delay_us(1);
    DHT11_DDR &= ~(1<<DHT11_INPUTPIN); //input
    delay_us(39);

    //check start condition 1
    if((DHT11_PIN & (1<<DHT11_INPUTPIN))) {
        return DHT11_ERROR;
    }
    delay_us(80);

    //check start condition 2
    if(!(DHT11_PIN & (1<<DHT11_INPUTPIN))) {
        return DHT11_ERROR;
    }
    delay_us(80);

    //read the data
    for (j=0; j<5; j++) { //read 5 byte
        uint8_t result=0;
        for(i=0; i<8; i++) {//read every bit
            while(!(DHT11_PIN & (1<<DHT11_INPUTPIN))); //wait for an high input
            delay_us(30);
            if(DHT11_PIN & (1<<DHT11_INPUTPIN)) //if input is high after 30 us, get result
                result |= (1<<(7-i));
            while(DHT11_PIN & (1<<DHT11_INPUTPIN)); //wait until input get low
        }
        bits[j] = result;
    }

    //reset port
    DHT11_DDR |= (1<<DHT11_INPUTPIN); //output
    DHT11_PORT |= (1<<DHT11_INPUTPIN); //low
    delay_ms(100);

    //check checksum
    if (bits[0] + bits[1] + bits[2] + bits[3] == bits[4]) {
        if (select == 0) { //return temperature
            return(bits[2]);
        } else if(select == 1){ //return humidity
            return(bits[0]);
        }
    }



    return DHT11_ERROR;
}

/*
 * get temperature (0..50C)
 */
int8_t dht11_gettemperature() {
    uint8_t ret = dht11_getdata(0);
    if(ret == DHT11_ERROR)
        return -1;
    else
        return ret;
}

/*
 * get humidity (20..90%)
 */
int8_t dht11_gethumidity() {
    uint8_t ret = dht11_getdata(1);
    if(ret == DHT11_ERROR)
        return -1;
    else
        return ret;
}
