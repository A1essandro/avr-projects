
;CodeVisionAVR C Compiler V3.27 Evaluation
;(C) Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny13
;Program type           : Application
;Clock frequency        : 9,600000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 20 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Automatic register allocation for global variables: On
;Smart register allocation: Off

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny13
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 64
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0014
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x7,0x6,0x5,0x4
_0x4:
	.DB  0x3,0x9F,0x25,0xD,0x99,0x49,0x41,0x1F
	.DB  0x1,0x9,0xE1,0xD1

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _DISPLAY_CONTROL
	.DW  _0x3*2

	.DW  0x0C
	.DW  _symbols
	.DW  _0x4*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x74

	.CSEG
;#define int8_t int
;#define uint8_t unsigned int
;#define DHT11_DDR DDRB
;#define DHT11_PORT PORTB
;#define DHT11_PIN PINB
;#define DHT11_INPUTPIN 1
;int8_t dht11_gettemperature();
;int8_t dht11_gethumidity();
;#include <delay.h>
;#include <stdio.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;//#include <io.h>
;
;#define DELAY 2000
;#define DS 0
;//#define OE 1
;#define ST_CP 2
;#define SH_CP 3
;#define MR 4
;#define unchar unsigned char
;
;void push_data_bit(unchar bt);
;void push_data(unsigned int data);
;void latch(void);
;void reset(void);
;unsigned int frame(unchar f, unchar symbol);
;unsigned int get_symbol(unchar n);
;
;unchar DISPLAY_CONTROL[4] = {7, 6, 5, 4};

	.DSEG
;//unchar EXTENDS_CONTROL[4] = {0, 1, 2, 3};
;
;unchar symbols[12] = {
;    //abcdefg.
;    0b00000011, //0
;    0b10011111, //1
;    0b00100101, //2
;    0b00001101, //3
;    0b10011001, //4
;    0b01001001, //5
;    0b01000001, //6
;    0b00011111, //7
;    0b00000001, //8
;    0b00001001, //9
;    0b11100001, //t 10
;    0b11010001 //h 11
;};
;
;void main(void)
; 0000 0031 {

	.CSEG
_main:
; .FSTART _main
; 0000 0032     int tick = 0;
; 0000 0033     unchar v = 0;
; 0000 0034     DDRB = 0xFF;
;	tick -> R16,R17
;	v -> R18
	__GETWRN 16,17,0
	LDI  R18,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0035 
; 0000 0036     reset();
	RCALL _reset
; 0000 0037 
; 0000 0038     while(1)
_0x5:
; 0000 0039     {
; 0000 003A         if(tick == 0) {
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x8
; 0000 003B             push_data(frame(0, 10));
	RCALL SUBOPT_0x0
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x1
; 0000 003C             v = dht11_gettemperature();
	RCALL _dht11_gettemperature
	RJMP _0x2C
; 0000 003D         }
; 0000 003E         else if(tick > 0 && (tick + 1) < 0) {
_0x8:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0xB
	__GETW2R 16,17
	ADIW R26,1
	TST  R27
	BRMI _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 003F             push_data(frame(0, 11));
	RCALL SUBOPT_0x0
	LDI  R26,LOW(11)
	RCALL SUBOPT_0x1
; 0000 0040             v = dht11_gethumidity();
	RCALL _dht11_gethumidity
_0x2C:
	MOV  R18,R30
; 0000 0041         }
; 0000 0042         tick++;
_0xA:
	__ADDWRN 16,17,1
; 0000 0043 
; 0000 0044         if(tick > 0) {
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0xD
; 0000 0045             push_data(frame(0, 10));
	RCALL SUBOPT_0x0
	LDI  R26,LOW(10)
	RJMP _0x2D
; 0000 0046             push_data(frame(2, v / 10));
; 0000 0047             push_data(frame(3, v % 10));
; 0000 0048         } else {
_0xD:
; 0000 0049             push_data(frame(0, 11));
	RCALL SUBOPT_0x0
	LDI  R26,LOW(11)
_0x2D:
	RCALL _frame
	MOV  R26,R30
	MOV  R27,R31
	RCALL _push_data
; 0000 004A             push_data(frame(2, v / 10));
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R26,R30
	RCALL SUBOPT_0x1
; 0000 004B             push_data(frame(3, v % 10));
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOV  R26,R18
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R26,R30
	RCALL SUBOPT_0x1
; 0000 004C         }
; 0000 004D     }
	RJMP _0x5
; 0000 004E }
_0xF:
	RJMP _0xF
; .FEND
;
;void push_data_bit(unchar bt)
; 0000 0051 {
_push_data_bit:
; .FSTART _push_data_bit
; 0000 0052     if (bt)
	ST   -Y,R16
	MOV  R16,R26
;	bt -> R16
	CPI  R16,0
	BREQ _0x10
; 0000 0053         PORTB |= (1 << DS);
	SBI  0x18,0
; 0000 0054     else
	RJMP _0x11
_0x10:
; 0000 0055         PORTB &= ~(1 << DS);
	CBI  0x18,0
; 0000 0056     PORTB &= ~(1 << SH_CP);
_0x11:
	CBI  0x18,3
; 0000 0057     PORTB |= (1 << SH_CP);
	SBI  0x18,3
; 0000 0058 }
	RJMP _0x2060005
; .FEND
;
;void latch(void)
; 0000 005B {
_latch:
; .FSTART _latch
; 0000 005C     PORTB |= (1 << ST_CP);
	SBI  0x18,2
; 0000 005D     PORTB &= ~(1 << ST_CP);
	CBI  0x18,2
; 0000 005E }
	RET
; .FEND
;
;void reset(void)
; 0000 0061 {
_reset:
; .FSTART _reset
; 0000 0062     PORTB &= ~(1 << MR);
	CBI  0x18,4
; 0000 0063     delay_ms(3);
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x2
; 0000 0064     latch();
	RCALL _latch
; 0000 0065     PORTB |= (1 << MR);
	SBI  0x18,4
; 0000 0066     latch();
	RCALL _latch
; 0000 0067 }
	RET
; .FEND
;
;void push_data(unsigned int data)
; 0000 006A {
_push_data:
; .FSTART _push_data
; 0000 006B     unchar f;
; 0000 006C     for(f = 0; f < 16; f++)
	RCALL __SAVELOCR3
	__PUTW2R 17,18
;	data -> R17,R18
;	f -> R16
	LDI  R16,LOW(0)
_0x13:
	CPI  R16,16
	BRSH _0x14
; 0000 006D     {
; 0000 006E         push_data_bit(data & 1);
	MOV  R30,R17
	ANDI R30,LOW(0x1)
	MOV  R26,R30
	RCALL _push_data_bit
; 0000 006F         data = data >> 1;
	LSR  R18
	ROR  R17
; 0000 0070     }
	SUBI R16,-1
	RJMP _0x13
_0x14:
; 0000 0071     latch();
	RCALL _latch
; 0000 0072 }
	RCALL __LOADLOCR3
	RJMP _0x2060001
; .FEND
;
;unsigned int get_symbol(unchar n)
; 0000 0075 {
_get_symbol:
; .FSTART _get_symbol
; 0000 0076     return symbols[n] << 8;
	ST   -Y,R16
	MOV  R16,R26
;	n -> R16
	LDI  R26,LOW(_symbols)
	ADD  R26,R16
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
_0x2060005:
	LD   R16,Y+
	RET
; 0000 0077 }
; .FEND
;
;unsigned int frame(unchar f, unchar symbol)
; 0000 007A {
_frame:
; .FSTART _frame
; 0000 007B     return (1 << DISPLAY_CONTROL[f]) | get_symbol(symbol);
	RCALL __SAVELOCR2
	MOV  R16,R26
	LDD  R17,Y+2
;	f -> R17
;	symbol -> R16
	LDI  R26,LOW(_DISPLAY_CONTROL)
	ADD  R26,R17
	LD   R30,X
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	PUSH R31
	PUSH R30
	MOV  R26,R16
	RCALL _get_symbol
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	RCALL __LOADLOCR2
	RJMP _0x2060001
; 0000 007C }
; .FEND
;
;
;
;#define DHT11_ERROR 255
;
;/*
; * get data from dht11
; */
;uint8_t dht11_getdata(unchar select) {
; 0000 0085 unsigned int dht11_getdata(unsigned char select) {
_dht11_getdata:
; .FSTART _dht11_getdata
; 0000 0086     uint8_t bits[5];
; 0000 0087     uint8_t i,j = 0;
; 0000 0088 
; 0000 0089     memset(bits, 0, sizeof(bits));
	SBIW R28,10
	RCALL __SAVELOCR5
	MOV  R20,R26
;	select -> R20
;	bits -> Y+5
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 18,19,0
	MOV  R30,R28
	SUBI R30,-(5)
	ST   -Y,R30
	RCALL SUBOPT_0x0
	LDI  R26,LOW(10)
	RCALL _memset
; 0000 008A 
; 0000 008B     //reset port
; 0000 008C     DHT11_DDR |= (1<<DHT11_INPUTPIN); //output
	RCALL SUBOPT_0x3
; 0000 008D     DHT11_PORT |= (1<<DHT11_INPUTPIN); //high
; 0000 008E     delay_ms(100);
; 0000 008F 
; 0000 0090     //send request
; 0000 0091     DHT11_PORT &= ~(1<<DHT11_INPUTPIN); //low
	CBI  0x18,1
; 0000 0092     delay_ms(18);
	LDI  R26,LOW(18)
	RCALL SUBOPT_0x2
; 0000 0093     DHT11_PORT |= (1<<DHT11_INPUTPIN); //high
	SBI  0x18,1
; 0000 0094     delay_us(1);
	__DELAY_USB 3
; 0000 0095     DHT11_DDR &= ~(1<<DHT11_INPUTPIN); //input
	CBI  0x17,1
; 0000 0096     delay_us(39);
	__DELAY_USB 125
; 0000 0097 
; 0000 0098     //check start condition 1
; 0000 0099     if((DHT11_PIN & (1<<DHT11_INPUTPIN))) {
	SBIC 0x16,1
; 0000 009A         return DHT11_ERROR;
	RJMP _0x2060004
; 0000 009B     }
; 0000 009C     delay_us(80);
	RCALL SUBOPT_0x4
; 0000 009D 
; 0000 009E     //check start condition 2
; 0000 009F     if(!(DHT11_PIN & (1<<DHT11_INPUTPIN))) {
	SBIS 0x16,1
; 0000 00A0         return DHT11_ERROR;
	RJMP _0x2060004
; 0000 00A1     }
; 0000 00A2     delay_us(80);
	RCALL SUBOPT_0x4
; 0000 00A3 
; 0000 00A4     //read the data
; 0000 00A5     for (j=0; j<5; j++) { //read 5 byte
	__GETWRN 18,19,0
_0x18:
	__CPWRN 18,19,5
	BRSH _0x19
; 0000 00A6         uint8_t result=0;
; 0000 00A7         for(i=0; i<8; i++) {//read every bit
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	bits -> Y+7
;	result -> Y+0
	__GETWRN 16,17,0
_0x1B:
	__CPWRN 16,17,8
	BRSH _0x1C
; 0000 00A8             while(!(DHT11_PIN & (1<<DHT11_INPUTPIN))); //wait for an high input
_0x1D:
	SBIS 0x16,1
	RJMP _0x1D
; 0000 00A9             delay_us(30);
	__DELAY_USB 96
; 0000 00AA             if(DHT11_PIN & (1<<DHT11_INPUTPIN)) //if input is high after 30 us, get result
	SBIS 0x16,1
	RJMP _0x20
; 0000 00AB                 result |= (1<<(7-i));
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R16
	SBC  R31,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	LD   R26,Y
	LDD  R27,Y+1
	OR   R30,R26
	OR   R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00AC             while(DHT11_PIN & (1<<DHT11_INPUTPIN)); //wait until input get low
_0x20:
_0x21:
	SBIC 0x16,1
	RJMP _0x21
; 0000 00AD         }
	__ADDWRN 16,17,1
	RJMP _0x1B
_0x1C:
; 0000 00AE         bits[j] = result;
	MOV  R30,R18
	MOV  R26,R28
	SUBI R26,-(7)
	LSL  R30
	ADD  R30,R26
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00AF     }
	ADIW R28,2
	__ADDWRN 18,19,1
	RJMP _0x18
_0x19:
; 0000 00B0 
; 0000 00B1     //reset port
; 0000 00B2     DHT11_DDR |= (1<<DHT11_INPUTPIN); //output
	RCALL SUBOPT_0x3
; 0000 00B3     DHT11_PORT |= (1<<DHT11_INPUTPIN); //low
; 0000 00B4     delay_ms(100);
; 0000 00B5 
; 0000 00B6     //check checksum
; 0000 00B7     if (bits[0] + bits[1] + bits[2] + bits[3] == bits[4]) {
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x24
; 0000 00B8         if (select == 0) { //return temperature
	CPI  R20,0
	BRNE _0x25
; 0000 00B9             return(bits[2]);
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	RJMP _0x2060003
; 0000 00BA         } else if(select == 1){ //return humidity
_0x25:
	CPI  R20,1
	BRNE _0x27
; 0000 00BB             return(bits[0]);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RJMP _0x2060003
; 0000 00BC         }
; 0000 00BD     }
_0x27:
; 0000 00BE 
; 0000 00BF 
; 0000 00C0 
; 0000 00C1     return DHT11_ERROR;
_0x24:
_0x2060004:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
_0x2060003:
	RCALL __LOADLOCR5
	ADIW R28,15
	RET
; 0000 00C2 }
; .FEND
;
;/*
; * get temperature (0..50C)
; */
;int8_t dht11_gettemperature() {
; 0000 00C7 int dht11_gettemperature() {
_dht11_gettemperature:
; .FSTART _dht11_gettemperature
; 0000 00C8     uint8_t ret = dht11_getdata(0);
; 0000 00C9     if(ret == DHT11_ERROR)
	RCALL __SAVELOCR2
;	ret -> R16,R17
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x5
	BRNE _0x28
; 0000 00CA         return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060002
; 0000 00CB     else
_0x28:
; 0000 00CC         return ret;
	__GETW1R 16,17
	RJMP _0x2060002
; 0000 00CD }
; .FEND
;
;/*
; * get humidity (20..90%)
; */
;int8_t dht11_gethumidity() {
; 0000 00D2 int dht11_gethumidity() {
_dht11_gethumidity:
; .FSTART _dht11_gethumidity
; 0000 00D3     uint8_t ret = dht11_getdata(1);
; 0000 00D4     if(ret == DHT11_ERROR)
	RCALL __SAVELOCR2
;	ret -> R16,R17
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x5
	BRNE _0x2A
; 0000 00D5         return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060002
; 0000 00D6     else
_0x2A:
; 0000 00D7         return ret;
	__GETW1R 16,17
; 0000 00D8 }
_0x2060002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R26
    ld   r26,y
    tst  r26
    breq memset1
    clr  r31
    ldd  r30,y+2
    ldd  r22,y+1
memset0:
    st   z+,r22
    dec  r26
    brne memset0
memset1:
    ldd  r30,y+2
_0x2060001:
	ADIW R28,3
	RET
; .FEND

	.CSEG

	.DSEG
_DISPLAY_CONTROL:
	.BYTE 0x4
_symbols:
	.BYTE 0xC

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	RCALL _frame
	MOV  R26,R30
	MOV  R27,R31
	RJMP _push_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	SBI  0x17,1
	SBI  0x18,1
	LDI  R26,LOW(100)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__DELAY_USW 192
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	RCALL _dht11_getdata
	__PUTW1R 16,17
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R16
	CPC  R31,R17
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOV  R30,R26
	MOV  R31,R27
	BREQ __LSLW12R
__LSLW12S8:
	CP   R0,R1
	BRLO __LSLW12L
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOV  R30,R26
	MOV  R31,R27
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x960
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
