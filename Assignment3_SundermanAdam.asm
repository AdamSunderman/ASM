TITLE Negative Sums     (Assignment3_SundermanAdam.asm)

; Adam Sunderman	
; sunderad@onid.oregonstate.edu
; CS271-400
; Assignment # 3
; Due: 2/7/2016

; Description: Repeatedly takes user input in the range [-100...-1]. When a 0 or a positive number is entered
;			   by the user the sum and the average of the numbers given is calculated and displayed.


INCLUDE Irvine32.inc
	
LOWER_LIMIT	= -100
ARRAY_LENGTH = 128
THOUSAND = 1000

.data
	average			SDWORD	0
	remainder		SDWORD	0
	decAverage		SDWORD	0
	decRemainder	SDWORD	0
	sum				SDWORD	0
	termCount		DWORD	0
	ecHeader1		BYTE	"  *ec1: Lines are numbered during input. ", 0
	ecHeader2		BYTE	" **ec2: Diplays the average in floating point to nearest .001. ", 0
	ecHeader3		BYTE	"***ec3: Repeats until user quits, can continue accumulation or start new. ", 0
	header1			BYTE	"		Negative Accumulator ", 0
	header2			BYTE	"	   Programmed By, Adam Sunderman ", 0
	userName		BYTE	32 DUP(0)
	NamePrompt		BYTE	"Before we get started could you please enter your name : ", 0
	UserGreet		BYTE	"Hello, nice to meet you ", 0
	instruct1		BYTE	"You can now enter negative numbers between -100 and -1 (inclusive), ", 0
	instruct2		BYTE	"once you enter a non-negative number including zero the sum and the ", 0 
	instruct3		BYTE	"average of your numbers will be shown. ", 0
	inputPrompt		BYTE	"Please Enter Term ", 0
	endMsg1			BYTE	" you entered ", 0
	endMsg2			BYTE	" numbers.",0
	sumMsg			BYTE	"Their sum is: ", 0
	avgMsg			BYTE	"Their integer rounded average is: ", 0
	decAvgMsg		BYTE	"Their decimal rounded average is: ", 0
	continueMsg1	BYTE	"Enter 1 to keep your old values and continue entering numbers. ", 0
	continueMsg2	BYTE	"Enter 0 to clear your old values and start entering new numbers.", 0
	continueMsg3	BYTE	"Or enter any other number to quit.", 0
	goodbyeMsg1		BYTE	"Thanks ", 0
	goodbyeMsg2		BYTE	" see you next time! ", 0
	errorMsg		BYTE	"OOPS... The number must be in the range [-100...-1]", 0
	noInputMsg		BYTE	"You didn't enter any numbers, enter 1 to try again or any other number to exit. ", 0
	colon			BYTE	" : ", 0
	decimal			BYTE	".", 0
	numbers			SDWORD	ARRAY_LENGTH  DUP(0)
	prgCarryFlag	SDWORD	0
	
.code
main PROC
	
	call	Intro
	jmp		ReRunCarry
ReRunNoCarry:	
	call	ClearState
ReRunCarry:									
	call	GetData
	cmp		termCount, 0							;skip calculations if there was no input
	je		NoInput
	call	ArraySum																												
	call	ArrayAverage
NoInput:
	call	PrintResults
	cmp		prgCarryFlag, 1
	je		ReRunCarry
	cmp		prgCarryFlag, 2
	je		ReRunNoCarry

	mov		edx, OFFSET goodbyeMsg1					;say goodbye
	call	WriteString 
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET goodbyeMsg2
	call	WriteString
	call	CrLf



	exit	; exit to operating system
main ENDP

;;_______________________________________________________________________________________
;;	Intro: Shows the program header and user introduction.
;;---------------------------------------------------------------------------------------
;;	Requires: None.
;;	Returns: None.
;;  Preconditions: None.
;;_______________________________________________________________________________________

Intro PROC 

	mov		eax, green 
	call	setTextColor
	mov		edx, OFFSET header1							;program title
	call	WriteString 
	call	CrLf
	mov		edx, OFFSET	header2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ecHeader1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ecHeader2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ecHeader3
	call	WriteString
	call	CrLf
	call	CrLf

	mov		eax, cyan 
	call	setTextColor
	mov		edx, OFFSET namePrompt						;get user name 
	call	WriteString 
	mov		edx, OFFSET	userName
	mov		ecx, 31
	mov		eax, lightGray
	call	setTextColor
	call	ReadString
	call	CrLf
	call	CrLf
	mov		eax, cyan
	call	setTextColor

	mov		edx, OFFSET	userGreet						;greet user / display instructions
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET	instruct1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	instruct2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	instruct3
	call	WriteString
	call	CrLf
	call	CrLf

	ret
Intro ENDP

;;_______________________________________________________________________________________
;;	GetData: Gets user data as a negative integer in range [-100...-1] and stores it
;;			 in an array of 32 bit signed ints. Continues until a positive number or 0 is entered.
;; --------------------------------------------------------------------------------------  
;;	Requires: None.
;;	Returns: None / Data stored in variable "numbers".
;;	Preconditions: None.
;;_______________________________________________________________________________________

GetData PROC USES esi eax edx

	cmp		prgCarryFlag, 0								;see if values are being carried over set pointer accordingly
	je		CarryJump
	mov		esi, OFFSET numbers
	mov		eax, termCount
	imul	eax, 4
	add		esi, eax
	jmp		InputLoop	
CarryJump:
	mov		esi, OFFSET numbers		
								
InputLoop:												;loop until user enters a positive number or zero													
	jmp		SkipErrorMsg
			
InputError:												;error message and re-run if out of range [-100...-1]
	mov		edx, OFFSET errorMsg			
	call	WriteString
	call	CrLf

SkipErrorMsg:											
	mov		edx, OFFSET inputPrompt						;prompt user for term
	call	WriteString
	mov		eax, termCount
	add		eax, 1
	call	WriteDec
	mov		edx, OFFSET	colon
	call	WriteString
	mov		eax, lightGray
	call	setTextColor
	call	ReadInt
	
	cmp		eax, 0										;validate input
	jge		EndInput
	cmp		eax, LOWER_LIMIT
	jl		InputError 

	mov		[esi], eax									;store input / inc. pointer
	add		esi, TYPE SDWORD
	inc		termCount
	mov		eax, cyan
	call	setTextColor
	jmp		InputLoop
		
EndInput:
	mov		prgCarryFlag, 0
		
	ret
GetData ENDP

;;_______________________________________________________________________________________
;;	ArraySum: Calculates the sum of an array of signed 32bit integers.
;;---------------------------------------------------------------------------------------
;;	Requires: None.
;;	Returns: None / Data stored in variable "sum".  
;;  Preconditions: getData must have been called to fill  and set the address of the array.
;;_______________________________________________________________________________________

ArraySum PROC USES esi ecx

	mov		ecx, termCount									
	mov		esi, OFFSET numbers

	mov		eax, 0
sumLoop:	
	add		eax, [esi]
	add		esi, TYPE SDWORD
	loop	sumLoop

	mov		sum, eax

	ret
ArraySum ENDP

;;_______________________________________________________________________________________
;;	ArrayAverage: Calculates the integer average of an array of signed 32bit integers.
;;---------------------------------------------------------------------------------------
;;	Requires: ESI = Array Offset, ECX = Array size.
;;	Returns: None / Data stored in variable "average".
;;  Preconditions: GetData must be called to fill the array and set address. 
;;_______________________________________________________________________________________

ArrayAverage PROC USES esi ecx

	mov		ecx, termCount
	mov		esi, OFFSET numbers

.code
	mov		eax, 0
sumLoop:	
	add		eax, [esi]
	add		esi, TYPE SDWORD
	loop	sumLoop

	cdq
	mov		ebx, termCount							;get integer average with remainder
	idiv	ebx
	mov		average, eax
	mov		decAverage, eax
	mov		remainder, edx
	
	mov		eax, remainder							;round up or down
	imul	eax, 10
	cdq
	mov		ebx, termCount
	idiv	ebx
	cmp		eax, -5
	jge		SkipAdd
	sub		average, 1
SkipAdd:

	mov		eax, remainder						;decimal remainder
	imul	eax, -10							;tenths
	cdq
	mov		ebx, termCount
	idiv	ebx
	imul	eax, 100
	mov		decRemainder, eax			
	mov		eax, edx
	cmp		eax, 0
	je		SkipDigit
	imul	eax, -10							;hundredths
	cdq		 
	mov		ebx, termcount
	idiv	ebx
	imul	eax, -10
	add		decRemainder, eax
	mov		eax, edx
	cmp		eax, 0
	je		SkipDigit
	imul	eax, -10							;thousandths
	cdq
	mov		ebx, termCount
	idiv	ebx
	add		decRemainder, eax
	mov		eax, edx
	cmp		eax, 0
	je		SkipDigit
	cmp		eax, -5
	jle		SkipDigit
	add		decRemainder, 1

SkipDigit:		
			
	ret
ArrayAverage ENDP


;;________________________________________________________________________________________
;;	PrintResults: Shows the programs results and an exit message for the user
;;----------------------------------------------------------------------------------------
;;	Requires: None
;;	Returns: None
;;  Preconditions: GetData, ArraySum and ArrayAverage must be called to set correct sum and average.
;;________________________________________________________________________________________

PrintResults PROC 

	mov		eax, cyan							;term count
	call	setTextColor
	call	CrLf
	cmp		termCount, 0
	je		NoTerms
	mov		edx, OFFSET userName				
	call	WriteString
	mov		edx, OFFSET endMsg1								
	call	WriteString
	mov		eax, lightGray
	call	setTextColor
	mov		eax, termCount
	call	WriteDec

	mov		eax, cyan							;sum
	call	setTextColor
	mov		edx, OFFSET endMsg2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	sumMsg
	call	WriteString
	mov		eax, lightGray
	call	setTextColor
	mov		eax, sum
	call    WriteInt
	call	CrLf

	mov		eax, cyan							;integer average
	call	setTextColor
	mov		edx, OFFSET	avgMsg
	call	WriteString
	mov		eax, lightGray
	call	setTextColor
	mov		eax, average
	call    WriteInt
	call	CrLf

	mov		eax, cyan							;decimal average
	call	setTextColor 
	mov		edx, OFFSET decAvgMsg
	call	WriteString
	mov		eax, lightGray
	call	setTextColor
	mov		eax, decAverage
	call	WriteInt
	mov		edx, OFFSET decimal
	call	WriteString
	mov		eax, decRemainder
	call	WriteDec
	call	CrLf
	call	CrLF

	mov		eax, lightBlue							;check if the user wishes to continue
	call	setTextColor
	mov		edx, OFFSET continueMsg1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET continueMsg2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET continueMsg3
	call	WriteString
	mov		eax, white
	call	setTextColor
	call	readInt									;continue with or without old values
	call	CrLf
	cmp		eax, 0									
	je		ClearValues 
	cmp		eax, 1
	je		KeepValues
	jmp		NoRerun

NoTerms:
	mov		edx, OFFSET noInputMsg					;user never entered any terms
	call	WriteString
	call	readInt
	cmp		eax, 1
	je		ClearValues
	jmp		NoReRun

ClearValues:
	add		prgCarryFlag, 1
KeepValues:
	add		PrgCarryFlag, 1
NoRerun:
	mov		eax, cyan
	call	setTextColor
	ret
PrintResults ENDP

;;________________________________________________________________________________________
;;	ClearState: Clears all stored values in variables and screen 
;;----------------------------------------------------------------------------------------
;;	Requires: None
;;	Returns: None
;;  Preconditions: None
;;________________________________________________________________________________________

ClearState PROC

	mov		average, 0
	mov		remainder, 0
	mov		decAverage, 0
	mov		decRemainder, 0
	mov		sum, 0
	mov		termCount, 0
	call	Clrscr	

	ret
ClearState ENDP	 

END main