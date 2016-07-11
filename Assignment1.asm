TITLE Basic Arithmetic     (Assignment1.asm)

; Adam Sunderman	
; sunderad@onid.oregonstate.edu
; CS271-400
; Assignment # 1
; Due: 1/17/2016

; Description: Takes two user inputs and calculates the sum, difference, product 
;              and the quotient with remainder of the two inputs


INCLUDE Irvine32.inc


.data
	dot			BYTE	".", 0
	sign_p		BYTE	" + ", 0
	sign_m		BYTE	" - ", 0
	sign_x		BYTE	" x ", 0
	sign_d		BYTE	" / ", 0
	sign_e		BYTE	" = ", 0
	header		BYTE	"	Basic Arithmetic   by, Adam Sunderman", 0
	ec1_header	BYTE	"  *EC: Program repeats until user chooses to quit ", 0
	ec2_header	BYTE	" **EC: Program validates that the second input is less than the first ", 0
	ec3_header	BYTE	"***EC: Program shows the floating point form of the quotient to the nearest .001 ", 0
	error_msg	BYTE	"ERROR: Second number must be less than or equal to the first number ", 0
	intro_msg1	BYTE	"Enter two numbers and I will calculate the sum, difference, product and ", 0
	intro_msg2	BYTE	"the quotient with remainder as well as it's decimal form.", 0
	rem_msg		BYTE	" remainder ", 0
	dec_msg		BYTE	" or ", 0
	exit_msg	BYTE	"Goodbye!", 0
	repeat_msg	BYTE	"To exit type q or hit any other key to do another problem ", 0
	prompt_1	BYTE	"First Number: ", 0
	prompt_2	BYTE	"Second Number: ", 0
	operand_1	DWORD	?
	operand_2	DWORD	?
	sum			DWORD	?
	difference	DWORD	?
	product		DWORD	?
	quotient	DWORD	?
	remainder	DWORD	?
	decimal		DWORD	?
	exit_key	BYTE	'q'
	thousand	DWORD	1000

.code
main PROC

; introduction
	mov		edx, OFFSET header
	call	WriteString 
	call	CrLf
	mov		edx, OFFSET	ec1_header
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ec2_header
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ec3_header
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro_msg1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_msg2
	call	WriteString 
	call	CrLf
	call	CrLf

rerun:				

; get the data
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		operand_1, eax

input_error:

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	.IF		eax > operand_1
	call	Crlf
	mov		edx, OFFSET error_msg
	call	WriteString
	call	CrLf
	ja		input_error
	.ENDIF
	mov		operand_2, eax
	call	CrLf

; calculate the required values
  ; addition
	mov		eax, operand_1
	add		eax, operand_2
	mov		sum, eax

  ; subtraction
	mov		eax, operand_1
	mov		ebx, operand_2
	sub		eax, ebx
	mov		difference, eax
  
  ; multiplication	
	mov		eax, operand_1
	mul		operand_2
	mov		product, eax

  ; division with remainder
	mov		eax, operand_1
	cdq 
	mov		ebx, operand_2
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

   ; division with floating point
    mov		eax, remainder
	mul		thousand
	mov		ebx, operand_2
	div		ebx
	mov		decimal, eax
	
	

; display the results
  ; addition
	mov		eax, operand_1
	call	WriteDec
	mov		edx, OFFSET sign_p
	call	WriteString
	mov		eax, operand_2
	call	WriteDec
	mov		edx, OFFSET	sign_e
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

  ; subtraction
	mov		eax, operand_1
	call	WriteDec
	mov		edx, OFFSET sign_m
	call	WriteString
	mov		eax, operand_2
	call	WriteDec
	mov		edx, OFFSET	sign_e
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

  ; multiplication
	mov		eax, operand_1
	call	WriteDec
	mov		edx, OFFSET sign_x
	call	WriteString
	mov		eax, operand_2
	call	WriteDec
	mov		edx, OFFSET	sign_e
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

  ; division with remainder
	mov		eax, operand_1
	call	WriteDec
	mov		edx, OFFSET sign_d
	call	WriteString
	mov		eax, operand_2
	call	WriteDec
	mov		edx, OFFSET sign_e
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET rem_msg
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	
; division with floating point
	mov		edx, OFFSET dec_msg
	call	WriteString
	mov		eax, quotient	
	call	WriteDec
	mov		edx, OFFSET dot
	call	WriteString
	mov		eax, decimal
	call	WriteDec
	call	CrLf
	call	CrLf

; jump to rerun
	mov		edx, OFFSET repeat_msg
	call	WriteString
	call	CrLf
	call	CrLf
	call	ReadChar
	cmp		al, exit_key
	jne		rerun 
	
; say goodbye 
	mov		edx, OFFSET	exit_msg
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
