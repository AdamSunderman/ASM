TITLE Fibonacci Terms     (Assignment_2.asm)

; Author: Adam Sunderman
; Course / Project ID  CS271 / Demo #0               Date:1/9/2016
; Description: converts a persons age to their age in dog years

INCLUDE Irvine32.inc

UPPER_LIMIT = 46

.data

	header_1		BYTE	"	     Fibonacci Numbers ", 0	
	header_2		BYTE	"	Programmed by Adam Sunderman ", 0
	name_prompt		BYTE	"Whats your name? ", 0
	user_name		BYTE	21 DUP(0)
	hello			BYTE	"Hello, ", 0
	loop_prompt1	BYTE	"Enter the number of fibonacci terms you would like me to calculate ", 0
	loop_prompt2	BYTE	"The number must be an integer between 1 and 46 ", 0
	loop_prompt3	BYTE	"How many terms would you like to see? ", 0
	loop_length		DWORD	?
	error_msg		BYTE	"Out of range. Numeber must be between 1 and 46 ", 0
	last_term		DWORD	1

.code
main PROC

; introduction
	mov		edx, OFFSET header_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET header_2
	call	WriteString
	call	CrLf
	call	CrLf

; user instructions
	mov		edx, OFFSET name_prompt
	call	WriteString
	mov		edx, OFFSET	user_name
	mov		ecx, 21
	call	ReadString
	mov		edx, OFFSET hello
	call	WriteString 
	mov		edx, OFFSET user_name 
	call	WriteString 
	call	CrLf
	mov		edx, OFFSET loop_prompt1
	call	WriteString 
	call	CrLf	
	mov		edx, OFFSET loop_prompt2
	call	WriteString 
	call	CrLf
	call	CrLf

; get user data
	
badInput:								
	mov		edx, OFFSET loop_prompt3
	call	WriteString
	call	ReadInt
	call	CrLf

	.IF		eax > UPPER_LIMIT				;error message if input error exists
	mov		edx, OFFSET error_msg
	call	WriteString 
	call	CrLf
	.ENDIF

	cmp		eax, UPPER_LIMIT				
	jg		badInput
			
	mov		loop_length, eax
	
; display fibonacci terms

	mov		ecx, loop_length
	mov		eax, 1
	call	WriteDec
	call	WriteDec

fibLoop:

	mov		last_term, eax
	add		eax, last_term
	
	call	WriteDec
	loop	fibLoop
	 

; say goodbye

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
