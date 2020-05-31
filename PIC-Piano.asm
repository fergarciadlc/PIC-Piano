;******************************************************************************
;   This file is a basic template for assembly code for a PIC18F4550. Copy    *
;   this file into your project directory and modify or add to it as needed.  *
;                                                                             *
;   The PIC18FXXXX architecture allows two interrupt configurations. This     *
;   template code is written for priority interrupt levels and the IPEN bit   *
;   in the RCON register must be set to enable priority levels. If IPEN is    *
;   left in its default zero state, only the interrupt vector at 0x008 will   *
;   be used and the WREG_TEMP, BSR_TEMP and STATUS_TEMP variables will not    *
;   be needed.                                                                *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on the         *
;   features of the assembler.                                                *
;                                                                             *
;   Refer to the PIC18FXX50/XX55 Data Sheet for additional                    *
;   information on the architecture and instruction set.                      *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:    PlantillaASM                                                *
;    Date:        12/01/11                                                    *
;    File Version: 1.0                                                        *
;                                                                             *
;    Author:   Ing. Alejandro Vicente Lugo Silva                              *
;    Company:   Acad. Computación ICE - ESIME Zac.                            *
;                                                                             * 
;******************************************************************************
;                                                                             *
;    Files required: P18F4550.INC                                             *
;                                                                             *
;******************************************************************************

	LIST P=18F4550, F=INHX32	;directive to define processor
	#include <P18F4550.INC>		;processor specific variable definitions

;******************************************************************************
;Configuration bits

	CONFIG PLLDIV   = 5         ;(20 MHz crystal on PICDEM FS USB board)
    CONFIG CPUDIV   = OSC1_PLL2	
    CONFIG USBDIV   = 2         ;Clock source from 96MHz PLL/2
    CONFIG FOSC     = HSPLL_HS
    CONFIG FCMEN    = OFF
    CONFIG IESO     = OFF
    CONFIG PWRT     = OFF
    CONFIG BOR      = ON
    CONFIG BORV     = 3
    CONFIG VREGEN   = ON		;USB Voltage Regulator
    config WDT      = OFF
    config WDTPS    = 32768
    config MCLRE    = ON
    config LPT1OSC  = OFF
    config PBADEN   = OFF		;NOTE: modifying this value here won't have an effect
        							  ;on the application.  See the top of the main() function.
        							  ;By default the RB4 I/O pin is used to detect if the
        							  ;firmware should enter the bootloader or the main application
        							  ;firmware after a reset.  In order to do this, it needs to
        							  ;configure RB4 as a digital input, thereby changing it from
        							  ;the reset value according to this configuration bit.
    config CCP2MX   = ON
    config STVREN   = ON
    config LVP      = OFF
    config ICPRT    = OFF       ; Dedicated In-Circuit Debug/Programming
    config XINST    = OFF       ; Extended Instruction Set
    config CP0      = OFF
    config CP1      = OFF
    config CP2      = OFF
    config CP3      = OFF
    config CPB      = OFF
    config CPD      = OFF
    config WRT0     = OFF
    config WRT1     = OFF
    config WRT2     = OFF
    config WRT3     = OFF
    config WRTB     = OFF       ; Boot Block Write Protection
    config WRTC     = OFF
    config WRTD     = OFF
    config EBTR0    = OFF
    config EBTR1    = OFF
    config EBTR2    = OFF
    config EBTR3    = OFF
    config EBTRB    = OFF
;******************************************************************************
;Variable definitions
    x	equ 0x0
; These variables are only needed if low priority interrupts are used. 
; More variables may be needed to store other special function registers used
; in the interrupt routines.


;******************************************************************************
;Reset vector
; This code will start executing when a reset occurs.

RESET_VECTOR	ORG		0

		goto	Main		;go to start of main code

;******************************************************************************

;******************************************************************************
;Start of main program
; The main program code is placed here.
	ORG		0x1000
Main 				; *** main code goes here **
	movlw	0x0F
	movwf	ADCON1
	clrf	TRISA
	setf	TRISD
ciclo
	movlw	0XFF	    ;Mascara
	andwf	PORTD, W
	movwf	x 
	movlw	0XFF	    ;SIN TOCAR
	CPFSEQ	x	    
	goto	CompDo
	bcf	LATA,0
	goto	ciclo

CompDo
	movlw	0X7F	    ;Tocando Do
	CPFSEQ	x
	goto	CompRe	    
	call	NotaDo	    ;Suena Do
	
CompRe
	movlw	0xBF	    ;Tocando Re
	CPFSEQ	x
	goto	CompMi	    
	call	NotaRe	    ;Suena Re
	
CompMi
	movlw	0xDF	    ;Tocando Mi
	CPFSEQ	x
	goto	CompFa	    
	call	NotaMi	    ;Suena Mi
	
CompFa
	movlw	0xEF	    ;Tocando Fa
	CPFSEQ	x
	goto	CompSol	    
	call	NotaFa	    ;Suena Fa

CompSol
	movlw	0xF7	    ;Tocando Sol
	CPFSEQ	x
	goto	CompLa	    
	call	NotaSol	    ;Suena Sol
	
CompLa
	movlw	0xFB	    ;Tocando La
	CPFSEQ	x
	goto	CompSi	    
	call	NotaLa	    ;Suena La
	
CompSi
	movlw	0xFD	    ;Tocando Si
	CPFSEQ	x
	goto	CompDo2	    
	call	NotaSi	    ;Suena Si
	
CompDo2
	movlw	0xFE	    ;Tocando Si
	CPFSEQ	x
	goto	CompOtro	    
	call	NotaDo2	    ;Suena Si
	
CompOtro 
	movlw	0x0
	movwf	LATD
	goto ciclo
	
;;;;;;;;;;;;;;;;;;;NOTAS;;;;;;;;;;;;;;;;;	

	

	

					; end of main	
;******************************************************************************
; Start of subrutines
;******************************************************************************
NotaDo	
	movlw	0xA6	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x78	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
NotaRe	
	movlw	0xB0	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x50	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde2
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde2	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return

NotaMi	
	movlw	0xB9	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x38	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde3
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde3	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
NotaFa	
	movlw	0xBC	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0xF8	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde4
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde4	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
NotaSol	
	movlw	0xC4	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x78	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde5
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde5	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
NotaLa	
	movlw	0xCB	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x08	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde6
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde6	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
NotaSi	
	movlw	0xD0	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x8E	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde7
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde7	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
NotaDo2	
	movlw	0xD3	;Carga valor inicial
	movwf	TMR0H	;Primer Byte alto
	movlw	0x78	;valor inicial
	movwf	TMR0L	;byte bajo
	bcf	INTCON, TMR0IF	;Borra bandera de desborde
	movlw	0x88	;PALABRA DE CONTROL DEL TIMER 0   16 BITS SIN DIVISOR DE FRECUENCIA
	movwf	T0CON	;ENCENDIDO
desborde8
	btfss	INTCON, TMR0IF	;DETECTA DESBORDAMIENTO
	goto	desborde8	;TIMER 0
	bcf	T0CON, TMR0ON	;APAGA TIMER 0
	btg	LATA,0		;COMPLEMENTA RA5
	return
	
;******************************************************************************
;End of program
	END