

; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

#include "p16f887.inc"

; CONFIG1
; __config 0x28DD
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_ON & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 
    LIST p=16F887
   
N EQU 0xC7
cont1 EQU 0x20
cont2 EQU 0x21
cont3 EQU 0x22
varsec EQU 0x23
 
 
    ORG	0x00
    GOTO INICIO
    
INICIO
    BCF STATUS,RP0   ;RP0 = 0
    BCF STATUS,RP1  ;RP1 = 0
    CLRF PORTA	;PORTA = 0
    CLRF PORTD ;PORT SECUENCIA LED
    ;MOVLW B'0000000'  ;
    ;MOVWF PORTA
    BSF STATUS, RP0 ;RP0 = 1
    CLRF TRISA
    CLRF TRISD	;SECUENCIA SALIDA
    BSF STATUS,RP1
    CLRF ANSEL
    BCF STATUS,RP0  ;BANK O RP1=0 RP0=0
    BCF STATUS,RP1
LOOP
    MOVLW 0x80
    MOVWF PORTD
    MOVLW 0x00
    MOVWF varsec
    
Secuenica4
	
	MOVF varsec,0
	CALL SEVENSEG_LOOKUP
	;para anodo comun complemento (1 -> 0, 0 -> 1)
	MOVWF PORTD ;PUT DATA ON PORTB.
	CALL RETARDO1
	INCF varsec
	MOVLW 0x07
	XORWF varsec, 0
	BTFSS STATUS,2 
	GOTO Secuenica4
	
	MOVLW 0x08
	MOVWF varsec
	MOVLW 0xF0
	MOVWF PORTD
    
Secuencia4 
	SWAPF PORTD
	CALL RETARDO1
	DECF varsec,1
	BTFSS STATUS,2 
	GOTO Secuencia4
    
    GOTO LOOP
    
    
   
	
	
    
SEVENSEG_LOOKUP 
	ADDWF PCL,f
	RETLW 0x81 ; //Hex value to display the number 0. 0x40
	RETLW 0x42 ; //Hex value to display the number 1. 0x79
	RETLW 0x24 ; //Hex value to display the number 2.
	RETLW 0x18 ; //Hex value to display the number 3.
	RETLW 0x24 ; //Hex value to display the number 4.
	RETLW 0x42 ; //Hex value to display the number 5.
	RETLW 0x81 ; //Hex value to display the number 6.
	RETURN
    
    
RETARDO
    MOVLW N
    MOVWF cont1
    
REP_1
    MOVLW N
    MOVWF cont2
    
REP_2
    DECFSZ cont2,1
    GOTO REP_2
    DECFSZ cont1,1
    GOTO REP_1
    RETURN

RETARDO1
    MOVLW N
    MOVWF cont1
    
REP_11
    MOVLW N
    MOVWF cont2
    
REP_22
    DECFSZ cont2,1
    GOTO REP_22
    DECFSZ cont1,1
    GOTO REP_11
    RETURN    
    end
