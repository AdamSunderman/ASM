TITLE Random Number Generator and Sorter     (Assignment5_SundermanAdam.asm)

; Adam Sunderman	
; sunderad@onid.oregonstate.edu
; CS271-400
; Assignment #5
; Due:2/28/2016

; Description:  Program gets user input in the range 10 to 200 inclusive. The program then generates and saves the user inputed
;				amount of random numbers to an array. The array of random numbers is then printed for the user. Next the array is
;				sorted, then printed one last time bofore displaying the exit message.  			   
;_______________________________________________________________________________________________________________________

INCLUDE Irvine32.inc

	INPUT_MIN = 10
	INPUT_MAX = 200
	RANGE_LO  = 100
	RANGE_HI  = 999

.data
	middleTerm_Local		EQU		DWORD PTR [ebp-4]
	termCount_Local			EQU		DWORD PTR [ebp-4]					
	numRows_Local			EQU		DWORD PTR [ebp-8]
	lastRowLength_Local		EQU		DWORD PTR [ebp-12]
	jumpVal_Local			EQU		DWORD PTR [ebp-16]

	ecHeader1		BYTE	"		   *ec1: Prints the List in columns instead of rows. ",13,10,13,10, 0	
	header1			BYTE	"		Random Number Generator and Sorter	 By Adam Sunderman",13,10, 0
	instruct1		BYTE	" This program will generate and save 10 to 200 random integers in the range [100...999].  ",13,10, 0
	instruct2		BYTE	" These numbers will be shown to you as a list after they have all been created, then the  ",13,10, 0
	instruct3		BYTE	" list will be sorted in descending order and shown one last time before the program closes. ",13,10,13,10, 0
	userPrompt		BYTE	" How many numbers would you like to see generated? [10...200]  ", 0
	errorMsg		BYTE	13,10," Input Error! Try again please.",13,10,0
	medianMsg		BYTE	13,10,"	The median is: ", 0
	title1			BYTE	" The unsorted list is: ", 0
	title2			BYTE	" The sorted list is: ", 0
	request			DWORD	0
	array			DWORD	INPUT_MAX	DUP(0)


.code
main PROC

	call	Randomize

	push	OFFSET header1
	push	OFFSET instruct1	
	push	OFFSET instruct2
	push	OFFSET instruct3	
	push	OFFSET ecHeader1
	call	Intro

	push	OFFSET request
	push	OFFSET errorMsg
	push	OFFSET userPrompt
	call	GetData

	push	OFFSET array
	push	request
	call	FillArray

	push	OFFSET array
	push	request
	push	OFFSET title1
	call	DisplayListVert

	push	OFFSET array
	push	request
	call	SortList

	push	OFFSET array
	push	request
	push	OFFSET medianMsg
	call	DisplayMedian

	push	OFFSET array
	push	request
	push	OFFSET title2
	call	DisplayListVert

	exit	; exit to operating system
main ENDP

;;_______________________________________________________________________________________
;;	Intro: Shows the program header and user introduction.
;;---------------------------------------------------------------------------------------
;;	Requires: None
;;	Parameters: 1: header1(ref) 2: instruct1(ref) 3: instruct2(ref) 4: instruct3(ref) 
;;				5: ecHeader1(ref)
;;	Returns: None. 
;;  Preconditions: None.
;;_______________________________________________________________________________________

Intro PROC 
	push	ebp
	mov		ebp, esp

	mov		edx, [ebp+24]						;program title
	call	WriteString 
	mov		edx, [ebp+8]						;extra credit info
	call	WriteString
	mov		edx, [ebp+20]						;display instructions x 3
	call	WriteString
	mov		edx, [ebp+16]
	call	WriteString 
	mov		edx, [ebp+12]
	call	WriteString 

	pop		ebp
	ret	20
Intro ENDP

;;_______________________________________________________________________________________
;;	GetData: Gets the number of terms to be generated from the user and verifies 
;;           that it is in the range [10...200].
;;---------------------------------------------------------------------------------------
;;	Requires: None 
;;	Parameters: 1: request(ref) 2: errorMsg(ref) 3: userPrompt(ref)
;;	Returns: request (when valid)
;;  Preconditions: INPUT_MIN, INPUT_MAX must be defined global constants.
;;_______________________________________________________________________________________

GetData PROC 
	push	ebp
	mov		ebp, esp

	jmp		SkipError
InputError:											;jump for bad input message, skipped unless jumped to
	mov		edx, [ebp+12]
	call	WriteString
SkipError:
	mov		edx, [ebp+8]							;prompt for input
	call	WriteString 
	call	ReadInt

	cmp		eax, INPUT_MIN							;verify input
	jl		InputError	
	cmp		eax, INPUT_MAX
	jg		InputError

	mov		edi, [ebp+16]
	mov		[edi] , eax								;store input

	pop		ebp

	call	CrLf
	call	CrLf

	ret 12
GetData ENDP

;;_______________________________________________________________________________________
;;	FillArray: Fills an array with unsorted random 32 bit integers.
;;---------------------------------------------------------------------------------------
;;	Requires: EAX, ECX, 
;;	Parameters: request (val), array (ref)
;;	Returns: array
;;  Preconditions: RANGE_LO, RANGE_HI must be defined.
;;_______________________________________________________________________________________

FillArray PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		ecx, [ebp+8]

FillLoop:
	mov		eax, (RANGE_HI - RANGE_LO)+1						;set range for random
	call	RandomRange
	add		eax, RANGE_LO
	mov		[esi], eax
	add		esi, TYPE DWORD
	loop	FillLoop
	
	pop		ebp

	ret 8
FillArray ENDP 


;;_______________________________________________________________________________________
;;	DisplayList: Shows the list of random numbers in rows.
;; ******NOT USED******SEE *DisplayListVert* BELOW****************
;;---------------------------------------------------------------------------------------
;;	Requires: None
;;	Parameters: 1: request(val), 2:array(ref), 3:title(ref)
;;	Returns: None.
;;  Preconditions: None.
;;_______________________________________________________________________________________

DisplayList PROC
 
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+16]							;get array@
	mov		ecx, [ebp+12]							;get request
	mov		edx, [ebp+8]							;get list title
	call	WriteString

	sub		esp, 4									;create local for term counting
	mov		termCount_Local, 0

PrintLoop:
	mov		al, 09h									;add spacing to numbers
	call	WriteChar
	mov		eax, [esi]
	call	WriteDec
	add		esi, 4
	add		termCount_Local, 1						;increment and check how many terms are on the current line
	cmp		termCount_Local, 10
	jne		SkipNewLine
	call	CrLf
	mov		termCount_Local, 0

SkipNewLine:
	loop	PrintLoop

	call	CrLf
	mov		esp, ebp
	pop		ebp
	ret 12
DisplayList ENDP

;;_______________________________________________________________________________________
;;	DisplayListVert: Shows the list of random numbers in columns.
;;	   **** See the Helper function PrintLine for a more detailed explanation ****
;;---------------------------------------------------------------------------------------
;;	Requires: PrintRow helper function
;;	Parameters: 1: request(val) 2: array(ref) 3: title(ref)
;;	Returns: None.
;;  Preconditions: None.
;;_______________________________________________________________________________________

DisplayListVert PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+16]							;get array@
	mov		edx, [ebp+8]							;get/show list title
	call	WriteString
	call	CrLf

	sub		esp, 16									;Create 4 locals 						
	mov		numRows_Local, 0						;1: number of rows to print, will be = (request/10) + (1 for remainder if present)  
	mov		lastRowLength_Local, 0					;2: number of terms in the last row if < 10
	mov		jumpVal_Local, 0						;3: base offset jump value (4 x number of rows)
	mov		termCount_Local, 0						;4: number of terms printed so far

	mov		eax, [ebp+12]							;get request 
	cdq
	mov		ebx, 10
	div		ebx										;Determine number of rows using division by 10, remainder indicates a last row
	mov		numRows_Local, eax						;of < 10. These numbers determine OFFSET jumps and loop counters in PrintRow 
	cmp		edx, 0									;helper function, see below.
	je		NoShortRow								
	mov		lastRowLength_Local, edx
	add		numRows_Local, 1 
NoShortRow:

	mov		eax, numRows_Local						;find the num of bytes each offset jump should be 
	cdq												; 4 x number of rows to print
	mov		ebx, 4
	mul		ebx
	mov		jumpVal_Local, eax

	mov		ecx, numRows_Local						
LineLoop:

	mov		edi, esi								;current row start address for PrintLine Helper function
	call	PrintLine
	add		esi, 4									;move to the next rows start address 

	loop	LineLoop
	
	mov		esp, ebp
	pop		ebp
	ret 12
DisplayListVert ENDP

;;_______________________________________________________________________________________
;;	**PrintLine: Prints one line with ten terms. Jumps in increments of 10 terms to display the list vertically. 
;;				 Uses two loops if the list length is not a factor of ten. One loop uses increments of the standard OFFSET that is expected
;;				 when the rows are exactly ten terms long, i.e. 10 terms x 4 bytes, the other loop changes the previous OFFSET by -4. 
;;				 The loops are set to 10 between the two or just loop one to 10. The second loop handles the case where there is a last row with less than 10 terms,
;;				 this changes the offset in every previous row for the last 10-n terms. Where n is equal to the number of terms in the last row.
;;				 EXAMPLE- If the list is 23 terms long then the last 7 terms of each row must be adjusted.  
;;				 	 
;;  ***     This is a Helper function for DisplayListVert	    ***
;;---------------------------------------------------------------------------------------
;;	Requires: Uses: eax, ebx, ecx, edx, edi								
;;	Parameters: None. Uses Locals from DisplayListVert					
;;	Returns: None.
;;  Preconditions: 
;;_______________________________________________________________________________________
PrintLine PROC

	push	ecx									;save ecx because PrintLine function has loops

	mov		ecx, lastRowLength_Local			; if the last row length is 0 then the number of terms to 
	mov		eax, lastRowLength_Local			; print is a multiple of 10 and only one loop is needed set to 10 every time, 
	cmp		eax, 0								; otherwise loop 1 is set to the number of terms in the last row
	jne		StartLoop

	mov		ecx, 10

StartLoop:
L1:
	mov		al, 09h								;tab for padding
	call	WriteChar
	mov		eax, [edi]							;current rows start address is in edi, edi will be changed to track eack row
	call	WriteDec							
	add		edi, jumpVal_Local
	inc		termCount_Local
	loop	L1 

	mov		eax, termCount_Local				;if this was the last row jump out before the next loop
	cmp		eax, [ebp+12]
	je		PrintDone

	mov		eax, lastRowLength_Local			;jump if only the first loop is needed
	cmp		eax, 0
	je		PrintDone

	mov		eax, 10								;last loop and number of terms left in the row = 10 - n  
	sub		eax, lastRowLength_Local			;       n = terms in last row to print
	mov		ecx, eax
L2:
	mov		al, 09h	
	call	WriteChar
	mov		eax, [edi]
	call	WriteDec
	mov		eax, jumpVal_Local					;the offset must be decrease by 4 for every number 
	sub		eax, 4
	add		edi, eax
	inc		termCount_Local
	loop	L2

PrintDone:
	
	pop		ecx				
	call	CrLf

	ret
PrintLine ENDP

;;_______________________________________________________________________________________
;;	SortList: Sorts the list of random numbers. (Version of an in-place selection sort)
;;---------------------------------------------------------------------------------------
;;	Requires: FindLargest (helper funct.)
;;	Parameters: 1: request(val), 2: array(ref)
;;	Returns: sorted->array(ref)
;;  Preconditions: None.
;;_______________________________________________________________________________________

SortList PROC
	push	ebp
	mov		ebp, esp
	
	mov		edi, [ebp+12]					;set destination for insertions 
	mov		ecx, [ebp+8]					;set ecx for request-1
	dec		ecx

SortLoop:
	
	call	FindLargest						;esi will contain address of largest from list
	cmp		esi, edi						;if esi=edi there is no swap necesary
	je      InPlace

	mov		eax ,[esi]						;swap terms
	mov		ebx, [edi]
	mov		[esi], ebx
	mov		[edi], eax
	
InPlace:
	add		edi, TYPE DWORD					;correct value is in place, move edi
	loop	SortLoop

	pop	ebp
	ret	8
SortList ENDP

;;_______________________________________________________________________________________
;;	**FindLargest: Finds the largest item in a list, 
;;       **Helper function for SortList**
;;---------------------------------------------------------------------------------------
;;	Requires: SortList
;;	Parameters: None, uses edi from SortList as the start of values to check 
;;              and ecx from SortList as the value for the loop.
;;	Returns: None, modifies esi to the address of the largest item
;;  Preconditions: edi must contain the array address, ecx must contain the current loop count
;;_______________________________________________________________________________________

FindLargest Proc
	push	ebp
	mov		ebp, esp
	push	edi							;save the starting items address so we can use edi
	mov		eax, ecx					;save the old ecx but set new loop to same value
	push	ecx
	mov		ecx, eax

	mov		esi, edi					;esi holds currently largest/ first item 
Find:
	add		edi, TYPE DWORD				;look at next
	mov		eax, [esi]
	mov		ebx, [edi]
	cmp		eax, ebx
	jge		NotGreater
	mov		esi, edi					;if greater save address in esi

NotGreater:
	loop	Find

	pop		ecx
	pop		edi
	pop		ebp
	ret 
FindLargest ENDP

;;_______________________________________________________________________________________
;;	DisplayMedian: Shows the median of a list of sorted numbers. By selecting the middle
;;				   term or middle two terms with division.
;;---------------------------------------------------------------------------------------
;;	Requires: None
;;	Parameters: 1: request(val) 2: array(ref), medianMsg(ref)
;;	Returns: None.
;;  Preconditions: None.
;;_______________________________________________________________________________________

DisplayMedian PROC
	push	ebp
	mov		ebp, esp

	sub		esp, 4									;Create local						
	mov		middleTerm_Local, 0							

	mov		esi, [ebp+16]							;get array@
	mov		edx, [ebp+8]							;get/show medianMsg
	call	WriteString

	mov		eax, [ebp+12]							;get request and check if list is odd or even length 
	cdq
	mov		ebx, 2
	div		ebx										
	mov		middleTerm_Local, eax						 
	cmp		edx, 0									
	je		EvenList

	mov		eax, middleTerm_Local					;find middle term location
	cdq
	mov		ebx, 4
	mul		ebx

	add		esi, eax								;go to middle term and print
	mov		eax, [esi]
	call	WriteDec
	call	CrLf
	call	CrLf

	jmp		LeaveMedian
EvenList:
	
	mov		eax, middleTerm_Local					;find middle term location 
	cdq
	mov		ebx, 4
	mul		ebx

	add		esi, eax								;get the pair for the middle term
	mov		eax, [esi]								;add them then divide by 2 and print
	sub		esi, 4
	add		eax, [esi]
	cdq
	mov		ebx, 2
	div		ebx	
	
	call	WriteDec
	call	CrLf
	call	CrLf

LeaveMedian:

	mov		esp, ebp
	pop		ebp	
	ret		12
DisplayMedian ENDP


END main
