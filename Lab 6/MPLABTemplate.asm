; ALab 6
; Raj Joshi & Arihant GUPTA
; 5/22/19

#include <p16f887.inc>

key_pressed equ 0x20

	ORG 0
	GOTO main
	ORG 4
	GOTO isr


main:
	BANKSEL ANSELH
	CLRF ANSELH
	
	BANKSEL TRISB	
	MOVLW b'11110000' ;0-3 is output 4-7 is input
	MOVWF TRISB

	BANKSEL ANSEL
	CLRF ANSEL

	BANKSEL TRISC
	CLRF TRISC

	BANKSEL PORTB
	CLRF PORTB
	CLRF PORTC
	CLRF key_pressed

test_keys:;common anode, msb is g lsb is a
	MOVF key_pressed, 0
	
	BSF PORTB, 0 ;testing column 4
	BTFSC PORTB, 4 ;check row 4
	MOVLW b'10100001';0x0D
	BTFSC PORTB, 5 ;check row 3
	MOVLW b'10000110';0x0E
	BTFSC PORTB, 6 ;check row 2
	MOVLW b'10001110';0x0F
	BTFSC PORTB, 7 ;check row 1
	MOVLW b'11000000';0x00
	BCF PORTB, 0
	
	BSF PORTB, 1 ;testing column 3
	BTFSC PORTB, 4 ;check row 4
	MOVLW b'11000110';0x0C
	BTFSC PORTB, 5 ;check row 3
	MOVLW b'10011000';0x09
	BTFSC PORTB, 6 ;check row 2
	MOVLW b'10000000';0x08
	BTFSC PORTB, 7 ;check row 1
	MOVLW b'11111000';0x07
	BCF PORTB, 1

	BSF PORTB, 2 ;testing column 2
	BTFSC PORTB, 4 ;check row 4
	MOVLW b'10000011';0x0B
	BTFSC PORTB, 5 ;check row 3
	MOVLW b'10000010';0x06
	BTFSC PORTB, 6 ;check row 2
	MOVLW b'10010010';0x05
	BTFSC PORTB, 7 ;check row 1
	MOVLW b'10011001';0x04
	BCF PORTB, 2

	BSF PORTB, 3 ;testing column 1
	BTFSC PORTB, 4 ;check row 4
	MOVLW b'10001000';0x0A
	BTFSC PORTB, 5 ;check row 3
	MOVLW b'10110000'0x03
	BTFSC PORTB, 6 ;check row 2
	MOVLW b'10100100';0x02
	BTFSC PORTB, 7 ;check row 1
	MOVLW b'11001111';0x01
	BCF PORTB, 3

	MOVWF key_pressed
	MOVWF PORTC
	
	GOTO test_keys

isr:
	NOP
	RETFIE

	END
	
