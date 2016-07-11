TITLE Composite Finder     (Assignment4_SundermanAdam.asm)

; Adam Sunderman	
; sunderad@onid.oregonstate.edu
; CS271-400
; Assignment # <------------------FILLME
; Due:, <------------------------ FILLME

; Description:  <-----------------FILLME			   
;_______________________________________________________________________________________________________________________

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

	ecHeader1		BYTE	" *ec1: ",13,10, 0
	ecHeader2		BYTE	"**ec2: ",13,10,13,10, 0	
	header1			BYTE	"  By Adam Sunderman",13,10, 0
	instruct1		BYTE	"  ",13,10, 0
	instruct2		BYTE	"  ",13,10,13,10, 0
	userPrompt		BYTE	"  ", 0


.code
main PROC

	call	Intro

	exit	; exit to operating system
main ENDP

;;_______________________________________________________________________________________
;;	Intro: Shows the program header and user introduction.
;;---------------------------------------------------------------------------------------
;;	Requires: None.
;;	Returns: None.
;;  Preconditions: None.
;;_______________________________________________________________________________________

Intro PROC USES edx

	mov		edx, OFFSET header1						;program title
	call	WriteString 
	mov		edx, OFFSET	ecHeader1
	call	WriteString
	mov		edx, OFFSET	ecHeader2
	call	WriteString
	mov		edx, OFFSET	instruct1					;display instructions
	call	WriteString
	mov		edx, OFFSET instruct2
	call	WriteString 

	ret
Intro ENDP

END main
