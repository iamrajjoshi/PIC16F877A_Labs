; Lab 4
; Raj Joshi & Arihant Gupta
; 5/10/2019

#include <p16f887.inc>

count EQU 0x20

	ORG 0x00
	GOTO main
	ORG 0x04
	GOTO isr

main:
	
	MOVLW 0x01
	BANKSEL TRISC
	MOVWF TRISC


	BANKSEL PORTC
	CLRF PORTC

	BANKSEL count
	CLRF count

	BANKSEL ANSEL
	CLRF ANSEL

loop:
	BANKSEL PORTC
	BTFSC PORTC, 0
	INCF count
	MOVF count,0
	MOVWF PORTC
	GOTO loop

isr:
	NOP
	RETFIE

	END
	