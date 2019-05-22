; Lab 2
; Raj Joshi & Arihant Gupta
; 4/29/2019

#include <p16f887.inc>

SWITCH_BIT EQU 0

   ORG 0x0000
   GOTO setup

int:
    ORG 0x004
    GOTO isr

setup:
	MOVLW b'00010000'
	MOVWF PORTC
    BANKSEL TRISB
    BSF TRISB, SWITCH_BIT ; 1 is input
    BANKSEL TRISC
    CLRF TRISC ; all LED outputs
	BANKSEL ANSEL
    CLRF ANSEL ; digital I/O
    BANKSEL PORTB

main:
	MOVF PORTB
    BTFSS PORTB, SWITCH_BIT 
    GOTO rotateLeft ; switch=0, right to left
    GOTO rotateRight ; switch=1, left to right

rotateLeft:
	RLF PORTC
    BTFSC PORTC, 7
	CALL lastState
    GOTO main
	
lastState:
	BCF PORTC, 7
	MOVLW b'00000001'
	MOVWF PORTC
	RETURN
	
rotateRight:
    RRF PORTC
    BTFSC PORTC, 0
	CALL firstState
    GOTO main
	
firstState:
	BCF PORTC, 0
	MOVLW b'10000000'
	MOVWF PORTC
	RETURN

isr:
    NOP
    RETFIE

	END