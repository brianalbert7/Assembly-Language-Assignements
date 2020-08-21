TITLE Labi10            (Lab10i.asm)

; Programmed by:	Brian Albert
;
; Description:		Lab uses an array of records 
;
; Revision date:	11/7/2019

INCLUDE Irvine32.inc
INCLUDE MACROS.inc

Car STRUCT								; defines Car Structure
  yearModel DWORD ?						; year as unsigned int
  make byte 30 dup(0)					; make initialized to nulls
  speed dword ?							; speed as unsigned int
  availability dword 1					; status ( 1 = available, 0 - unavailable)
Car ENDS

.data
										; array of 10 Cars
carList Car <1910,"Model-T",0,0>, <2018,"Edsel",0,1>, <2018,"Dodge",0,1>,
		<2018,"Malibu",0,0>, <2018,"Explorer",0,1>, <2018,"Aero",0,0>, 
		<2018,"Camaro",0,1>, <2018,"Neon",0,0>,
		<2018, "Avalon",0,1>, <1965,"Shelby",0,1> 

spaceStr byte " ", 0					; ' '
speedStr byte ", Speed is = ", 0		; label for speed
availabilityStr byte ", Available: ", 0

numAvailable dword 0					; number of cars available
numAvailableStr byte "# available = ",0

.code
main PROC

	call displayCarListArray


     mov ecx, lengthOf carList			; prep for loop
	mov edi, offset carList				; load edi with address of car1
L2:
     mov eax, (Car PTR [edi]).availability   ; load eax with availability
     add numAvailable, eax                   ; add eax to numAvailable

     add edi, type car					; advance to next car

	Loop L2

	call displayCarListArray

	exit

main ENDP

; ===========================================
;
; displayCar
;		displays Car record
;	Inputs:
;		EDI address of record
;
displayCar PROC uses edx eax

											; [EDI] is a pointer
											; use PTR to say [EDI] points to a Car
	mov eax, (Car PTR [edi]).yearModel		; load eax with year in record at EDI
	call writedec							; display year

	mov edx, offset spaceStr				; display space
	call writestring

	mov edx, edi							; load edx with address of record that is in edi
	add edx, 4								; add 4 to skip over year to make
	call writestring						; display make

	mov edx, offset speedStr				; display speed string
	call writestring

											; [EDI] is a pointer
											; use PTR to say [EDI] points to a Car
	
	mov eax, (Car PTR [edi]).speed			; load eax with speed in record at EDI
	call writedec							; display speed

	mov edx, offset availabilityStr			; display availability string
	call writestring

     
     mov eax, (Car PTR [edi]).availability	; load eax with availability in record at EDI

     cmp (Car PTR [edi]).availability, 0     ; compare availability to 0
     JE isZero                               ; if 0 jump to isZero

     cmp (Car PTR [edi]).availability, 1     ; compare availability to 1
     JE isOne                                ; if 1 jump to isOne

isZero: 
     mWrite "no"                             ; if availability is 0, display no
     jmp done                                ; jump to done
isOne:
     mWrite "yes"                            ; if availability is 1, display yes
     jmp done                                ; jump to done

done:
	
	call crlf

	ret
displayCar ENDP

; ====================================
; displayCarListArray
;	  displays the array of Car
;
displayCarListArray PROC uses ecx edi

	call crlf							; \n

	mov ecx, lengthOf carList			; prep for loop
	mov edi, offset carList				; load edi with address of car1
L1:
	mov eax, lengthOf carList			; load EAX with # of elements
	sub eax, ecx						; eax now has 'index' value
	call writeDec						; display index
	mov eax, ':'						; display :
	call writeChar
	call displayCar						; display car

	add edi, type car					; advance to next car

	Loop L1

	call crlf							; \n
	call crlf							; \n

	mov edx, offset numAvailableStr		; display num available string
	call writeString

	mov eax, numAvailable				; display the number available
	call writeDec
	call crlf							; \n
	ret
displayCarListArray ENDP


; ===========================================
;
; accelerate
;		adds 5 to speed
;	Inputs:
;		EDI address of Car record
;
accelerate PROC
										; [EDI] is a pointer
										; use PTR to say [EDI] points to a Car
	add (Car PTR [edi]).speed, 5		; add 5 to speed in record at EDI
	ret
accelerate ENDP

; ===========================================
;
; brake
;		subtracts 5 from speed
;	Inputs:
;		EDI address of Car record
;
brake PROC
										; [EDI] is a pointer
										; use PTR to say [EDI] points to a Car
	sub (Car PTR [edi]).speed, 5		; subtract 5 from speed in record at EDI
	cmp (Car PTR [edi]).speed, 0		; did we go negative?
	jge L3								; if not leave
	mov (Car PTR [edi]).speed, 0		; make 0
L3:
	ret
brake ENDP



END main
