; Lab 7
; Raj Joshi & Arihant Gupta
; 6/10/19

#include <p16f887.inc>
onesec_counter equ 0x20
outer_counter equ 0x21
inner_counter equ 0x22

	ORG 0
	GOTO main
	ORG 4
	GOTO isr

main:
	BANKSEL ANSELH
	CLRF ANSELH
	BANKSEL TRISB
	CLRF TRISB
	BSF TRISB, RB0
	BSF INTCON, INTE
	BSF OPTION_REG, INTEDG
	BANKSEL PORTB
	CLRF PORTB
	BSF INTCON, GIE

loop:
	NOP
	GOTO loop

isr:
	BCF INTCON, INTF
	CALL onesec_delay
	INCF PORTB
	RETFIE

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

	END
	
