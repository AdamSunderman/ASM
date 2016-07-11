TITLE Sample Divider program
; Written by Justin Goins
; 10/11/12

INCLUDE Irvine32.inc
.data
myMessage	BYTE "Welcome to the DIV instruction tutorial!",0dh,0ah,0
number_1	DWORD 120
number_2	DWORD 7
quotient	DWORD ?
remainder	DWORD ?

.code
main PROC
	call Clrscr

	mov	 edx,OFFSET myMessage
	call WriteString

	; print the divisor
	mov edx, 0
	mov eax, number_2
	;cdq
	call WriteDec
	call Crlf
	; print the dividend
	mov eax, number_1
	call WriteDec
	call Crlf

	; perform the division
	mov ebx, number_2
	div ebx
	mov quotient, eax
	mov remainder, edx
	; print the quotient
	call WriteDec
	call Crlf
	mov eax, remainder
	; print the remainder
	call WriteDec
	call Crlf

	exit
main ENDP

END main