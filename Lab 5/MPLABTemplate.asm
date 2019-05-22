; Lab 6
; Raj Joshi & Arihant Gupta
; 5/22/2019

#include <p16f887.inc>

SWITCH_BIT EQU 0
onesec_counter equ 0x20
outer_counter equ 0x21
inner_counter equ 0x22

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
	CALL onesec_delay
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


onesec_delay: ;do the smaller delay 20 times (50000*20 = 1,000,000 usec --> 1 second 	
	MOVLW D'20' 
	MOVWF onesec_counter
	bigloop:
		CALL smaller_delay
		DECFSZ onesec_counter
		GOTO bigloop
	RETURN

smaller_delay: ; so its 200 times of 5 microseconds --> 1000 * 50 times = 50000
	MOVLW D'50'
	MOVWF outer_counter

	outerloop:
		MOVLW D'200'
		MOVWF inner_counter
	innerloop:
		nop
		nop
		DECFSZ inner_counter
		GOTO innerloop
		
		DECFSZ outer_counter
		GOTO outerloop
	RETURN
	
isr:
    NOP
    RETFIE

	END