TITLE Fibonacci Terms     (Assignment_2.asm)

; Adam Sunderman	
; sunderad@onid.oregonstate.edu
; CS271-400
; Assignment # 2
; Due: 1/24/2016

; Description: Prints n, {0 < n > 47} user seleceted terms of the fibonacci sequence.
; 

INCLUDE Irvine32.inc

UPPER_LIMIT = 46
LOWER_LIMIT = 1
NEW_LINE	= 5

.data

	header_1		BYTE	"	     Fibonacci Numbers ", 0	
	header_2		BYTE	"	Programmed by Adam Sunderman ", 0
	ec_header1		BYTE	" *EC: Numbers are in alligned columns ", 0
	ec_header2		BYTE	"**EC: Numbers are to totaled and the sum is displayed ", 0
	name_prompt		BYTE	"Whats your name? ", 0
	user_name		BYTE	21 DUP(0)
	hello			BYTE	"Hello, ", 0
	loop_prompt1	BYTE	"Enter the number of fibonacci terms you would like me to calculate ", 0
	loop_prompt2	BYTE	"The number must be an integer from 1 to 46 ", 0
	loop_prompt3	BYTE	"How many terms would you like to see? ", 0
	loop_length		DWORD	?
	error_msg		BYTE	"Out of range. Number must be an integer from 1 to 46 ", 0
	sum_msg			BYTE	"The sum of these terms is: ", 0
	goodbye_1		BYTE	"Results verified by Adam Sunderman ",0
	goodbye_2		BYTE	"Goodbye, ", 0
	start_num		DWORD	1
	sum				DWORD	0
	pad_1			BYTE	" ", 0
	pad_5			BYTE	"     ", 0
	pad_9			BYTE	"         ", 0
	term_count		DWORD	1
	loop_counter	DWORD	0
	input_flag		DWORD	0
	x_temp			DWORD	0
	y_temp			DWORD	0
	loop_temp		DWORD	0

.code
main PROC

; introduction
	mov		edx, OFFSET header_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET header_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_header1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_header2
	call	WriteString
	call	CrLf
	call	CrLf

; user instructions
	mov		edx, OFFSET name_prompt
	call	WriteString
	mov		edx, OFFSET	user_name
	mov		ecx, 21
	call	ReadString
	call	CrLf
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
badInputLoop:											
	cmp		input_flag, 0							
	je		skipErrorMsg
	mov		edx, OFFSET error_msg
	call	WriteString 
	call	CrLf
		
skipErrorMsg:										
	add		input_flag, 1							
	mov		edx, OFFSET loop_prompt3
	call	WriteString
	call	ReadInt
	call	CrLf

	cmp		eax, UPPER_LIMIT				
	jg		badInputLoop
	cmp		eax, LOWER_LIMIT
	jl		badInputLoop
			
	mov		loop_length, eax
	
; display fibonacci terms
; print 1 to start and set/change ecx 
	mov		edx, OFFSET pad_9
	call	WriteString	
	mov		ecx, loop_length			
	mov		eax, start_num
	call	WriteDec
	add		sum, eax
	mov		edx, OFFSET pad_5
	call	WriteString	
	inc		loop_counter
	sub		ecx, 1
	cmp		ecx, 0
	je		skipLoop	
						

; print remaining terms
	mov		ebx, 0
	mov		eax, start_num

fibLoop:
	
	XADD	eax, ebx

	
	mov		x_temp, eax							;save values and ecx for number padding
	mov		y_temp, ebx
	mov		loop_temp, ecx

	call	PadCount							;set ecx for inner loop
	cmp		ecx, 0
	je		noPad
	mov		edx, OFFSET pad_1
padLoop:
	call	WriteString
	loop	padLoop

noPad:

	mov		eax, x_temp							;restore values and ecx
	mov		ebx, y_temp
	mov		ecx, loop_temp 

	call	WriteDec
	add		sum, eax
	inc		loop_counter

	mov		edx, OFFSET pad_5
	call	WriteString
	
	cmp		loop_counter, NEW_LINE				;check for five terms
	jne		skipNewLine					
	mov		loop_counter, 0
	call	CrLf

skipNewLine:	
	
	loop	fibLoop

skipLoop:

	call	CrLf
	call	CrLf
	mov		edx, OFFSET sum_msg
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

; say goodbye
	
	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodbye_2
	call	WriteString
	mov		edx, OFFSET user_name
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP

;sets ecx for padding loop
PadCount PROC
	mov		ecx, 0
	cmp		eax, 10
	jl		nine
	cmp		eax, 100
	jl		eight
	cmp		eax, 1000
	jl		seven
	cmp		eax, 10000
	jl		six
	cmp		eax, 100000
	jl		five
	cmp		eax, 1000000
	jl		four
	cmp		eax, 10000000
	jl		three
	cmp		eax, 100000000
	jl		two
	cmp		eax, 1000000000
	jl		one
	cmp		eax, 1000000000
	jg		none
nine:	
	add		ecx, 1
eight:
	add		ecx, 1
seven:
	add		ecx, 1
six:
	add		ecx, 1
five:
	add		ecx, 1
four:
	add		ecx, 1
three:
	add		ecx, 1
two:
	add		ecx, 1
one:
	add		ecx, 1
none:
	
	ret
PadCount ENDP

END main
